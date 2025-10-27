import 'package:flutter/material.dart';

import '../services/image_services.dart';

void showImagePickerOptions(
  BuildContext context, {
  required VoidCallback onCameraOption,
  required VoidCallback onGaleryOption,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
    ),
    builder: (_) {
      return SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: onCameraOption,
              ),
              Divider(
                color: Colors.grey[100],
                height: 2,
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: onGaleryOption,
              ),
            ],
          ),
        ),
      );
    },
  );
}
