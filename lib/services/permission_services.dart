import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionServices {
  PermissionServices._();

  static Future<void> initPermissions() async {
    try {
      // Request permissions
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.photos, // For Android 13+ gallery access
        Permission.storage, // For Android 9 and below external storage
      ].request();

      // Check permission statuses
      if (statuses[Permission.camera]!.isGranted) {
        debugPrint('Camera permission granted');
      } else {
        debugPrint('Camera permission denied');
      }
      if (statuses[Permission.photos]!.isGranted) {
        debugPrint('Photos permission granted');
      } else {
        debugPrint('Photos permission denied');
      }
      if (statuses[Permission.storage]!.isGranted) {
        debugPrint('Storage permission granted');
      } else {
        debugPrint('Storage permission denied');
      }
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
    }
  }
}