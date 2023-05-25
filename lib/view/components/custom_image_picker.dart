import 'dart:io';

import 'package:image_picker/image_picker.dart';

class CustomImagePicker {
  final ImagePicker _picker = ImagePicker();

  Future<File?> takePicFromCamera() async {
    final newImage = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 500,
      maxHeight: 375,
    );
    return newImage != null ? File(newImage.path) : null;
  }

  Future<File?> chooseFromGallery() async {
    final newImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 500,
      maxHeight: 375,
    );
    return newImage != null ? File(newImage.path) : null;
  }

  Future<List<File>?> chooseMultipleImage() async {
    List<File> images = [];
    final pickedFiles = await _picker.pickMultiImage(
      imageQuality: 50,
      maxWidth: 500,
      maxHeight: 375,
    );
    if (pickedFiles != null) {
      for (var value in pickedFiles) {
        images.add(
          File(
            value.path,
          ),
        );
      }
      return images.isNotEmpty ? images : null;
    }
    return null;
  }
}
