import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../data/local_database_sqf/db_helper.dart';
import '../model/mini_gallery_model.dart';

class GalleryImageProvider extends ChangeNotifier {
  final DbHelper db = DbHelper.instance;

  List<MiniGalleryModel> _imageList = [];

  List<MiniGalleryModel> get imageList => _imageList;

  Future<void> fetchImages() async {
    _imageList = await db.getAllData();
    notifyListeners();
  }
  Future<void> addImage(MiniGalleryModel node) async {
    final rowId = await db.insertData(node);
    // node.id = rowId;
    // _nodeList.add(node);
    // // _nodeList = await db.getAllData();
    // notifyListeners();
    await fetchImages();
  }
  Future<String?> pickImageFromGallery( ImageSource imageSource) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      return pickedFile.path;
    }
    else{
      return '';

    }
  }
  deleteNote(MiniGalleryModel node) async {
    await db.deleteTodo(node.id!);
    await fetchImages();
  }
}
