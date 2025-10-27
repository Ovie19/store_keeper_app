import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageServices {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 800,
      );

      if (image != null) {
        return File(image.path);
      }

      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        debugPrint(pickedFile.path);
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print('Error picking image from gallery: $e');
      return null;
    }
  }

  static Future<String> saveImage(File file) async {
    final directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';
    final String filePath = '$path/$fileName';

    final File newImage = await File(file.path).copy(filePath);
    debugPrint(newImage.path);
    return newImage.path;
  }
}
