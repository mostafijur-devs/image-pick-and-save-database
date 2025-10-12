import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MultiImageSaveScreen extends StatefulWidget {
  const MultiImageSaveScreen({super.key});

  @override
  State<MultiImageSaveScreen> createState() => _MultiImageSaveScreenState();
}

class _MultiImageSaveScreenState extends State<MultiImageSaveScreen> {
  List<String> _base64Images = []; // সব image এর string list

  @override
  void initState() {
    super.initState();
    _loadImages(); // অ্যাপ চালু হলে সেভ করা ইমেজ গুলো লোড করো
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // File imageFile = File(pickedFile.path);
      // Uint8List bytes = await imageFile.readAsBytes();
      String base64Image = pickedFile.path;

      setState(() {
        _base64Images.add(base64Image);
      });

      _saveImages(); // SharedPreferences এ সেভ করো
    }
  }

  Future<void> _saveImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('image_list', _base64Images);
  }

  Future<void> _loadImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedList = prefs.getStringList('image_list');
    if (savedList != null) {
      setState(() {
        _base64Images = savedList;
      });
    }
  }

  Future<void> _deleteImage(int index) async {
    setState(() {
      _base64Images.removeAt(index);
    });
    _saveImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multi Image Save Example')),
      body: _base64Images.isEmpty
          ? const Center(child: Text('কোনো ছবি নেই'))
          : GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8),
        itemCount: _base64Images.length,
        itemBuilder: (context, index) {
          File imageBytes = File(_base64Images[index]);
          return Stack(
            children: [
              Positioned.fill(
                // child: Image.memory(
                //   imageBytes,
                //   fit: BoxFit.cover,
                // ),
                child: Image.file(
                  imageBytes,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: GestureDetector(
                  onTap: () => _deleteImage(index),
                  child: Container(
                    color: Colors.black54,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                ),
              ),
              ElevatedButton(onPressed: () {
                print(_base64Images);
              }, child: Text('mfk'))
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
