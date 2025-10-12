import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraPickExample extends StatefulWidget {
  const CameraPickExample({super.key});

  @override
  State<CameraPickExample> createState() => _CameraPickExampleState();
}

class _CameraPickExampleState extends State<CameraPickExample> {
  File? _image; // নির্বাচিত ছবি রাখার জন্য

  Future<void> _pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera Image Picker')),
      body: Center(
        child: _image == null
            ? const Text('কোনো ছবি নির্বাচন করা হয়নি')
            : Image.file(_image!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImageFromCamera,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
