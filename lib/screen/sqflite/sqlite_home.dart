import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_gallary/provider/gallery_image_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:mini_gallary/model/mini_gallery_model.dart';
import 'package:provider/provider.dart';

class SqliteHome extends StatefulWidget {
  const SqliteHome({super.key});

  @override
  State<SqliteHome> createState() => _SqliteHomeState();
}

class _SqliteHomeState extends State<SqliteHome> {
  @override
  void initState() {
    super.initState();
    context.read<GalleryImageProvider>().fetchImages();
  }

  Future<void> _pickImageFromGallery(ImageSource imageSource) async {
    String? image = await context
        .read<GalleryImageProvider>()
        .pickImageFromGallery(imageSource);
    if (image != null && image.isNotEmpty) {
      final node = MiniGalleryModel(
        dateTime: DateTime.now().toIso8601String(),
        imagePath: image,
      );
      await context.read<GalleryImageProvider>().addImage(node);
      await context.read<GalleryImageProvider>().fetchImages();
    }
  }

  void _openGalleryView(int initialIndex, List<MiniGalleryModel> imageList) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FullPhotoGallery(images: imageList, initialIndex: initialIndex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SQLite Gallery'), centerTitle: true),
      body: Consumer<GalleryImageProvider>(
        builder: (context, provider, child) {
          List<MiniGalleryModel> imageList = provider.imageList;
          return imageList.isEmpty
              ? const Center(child: Text('No images yet'))
              : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: imageList.length,
                  itemBuilder: (context, index) {
                    final imagePath = imageList[index].imagePath;
                    return GestureDetector(
                      onTap: () => _openGalleryView(index, imageList),
                      child: GestureDetector(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('You can delete this image'),
                                actions: [
                                  TextButton(
                                    onPressed: () {

                                    },
                                    child: Text('Delete'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('close'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Image.file(File(imagePath!), fit: BoxFit.cover),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PopupMenuButton(
          child: Text('Add your Image'),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text('Camera'),
                onTap: () {
                  _pickImageFromGallery(ImageSource.camera);
                },
              ),
              PopupMenuItem(
                child: Text('Gallery'),
                onTap: () {
                  _pickImageFromGallery(ImageSource.gallery);
                },
              ),
            ];
          },
        ),
      ),
    );
  }
}

class FullPhotoGallery extends StatefulWidget {
  final List<MiniGalleryModel> images;
  final int initialIndex;

  const FullPhotoGallery({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<FullPhotoGallery> createState() => _FullPhotoGalleryState();
}

class _FullPhotoGalleryState extends State<FullPhotoGallery> {
  late PageController _pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Image ${currentIndex + 1} / ${widget.images.length}'),
      ),
      body: PhotoViewGallery.builder(
        pageController: _pageController,
        itemCount: widget.images.length,
        builder: (context, index) {
          final imagePath = widget.images[index].imagePath!;
          return PhotoViewGalleryPageOptions(
            imageProvider: FileImage(File(imagePath)),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        backgroundDecoration: const BoxDecoration(color: Colors.black),
      ),
    );
  }
}
