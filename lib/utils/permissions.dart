import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class Permissions {
  ///Checking that camera and storage permission granted or not (Platform vise)
  static Future<bool> cameraAndStoragePermissionsGranted() async {
    PermissionStatus cameraPermissionStatus = await _getCameraPermission();
    switch (Platform.isAndroid ? 1 : 0) {
      ///For Android
      case 1:
        PermissionStatus storagePermissionStatus =
            await _getStoragePermission();

        if (cameraPermissionStatus == PermissionStatus.granted &&
            storagePermissionStatus == PermissionStatus.granted) {
          return true;
        } else {
          _handleInvalidPermissions(
              cameraPermissionStatus, storagePermissionStatus);
          return false;
        }

      ///For iOS
      case 0:
        if (cameraPermissionStatus == PermissionStatus.granted) {
          return true;
        } else {
          _handleInvalidPermissions(cameraPermissionStatus, null);
          return false;
        }

      default:
        return false;
    }
  }

  ///Checking camera permission
  static Future<PermissionStatus> _getCameraPermission() async {
    PermissionStatus permission = await Permission.camera.status;
    if (permission != PermissionStatus.granted) {
      PermissionStatus permissionStatus = await Permission.camera.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  ///Checking storage permission
  static Future<PermissionStatus> _getStoragePermission() async {
    PermissionStatus permission = await Permission.storage.status;
    if (permission != PermissionStatus.granted) {
      PermissionStatus permissionStatus = await Permission.storage.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  ///Checking permission is availale or not (Platform specific)
  static void _handleInvalidPermissions(PermissionStatus cameraPermissionStatus,
      PermissionStatus? storagePermissionStatus) async {
    if (Platform.isAndroid) _getStoragePermission();
    PermissionStatus storagePermissionStatus = await _getStoragePermission();

    if (cameraPermissionStatus.isPermanentlyDenied) {
      openAppSettings();
      return;
    }
    ((cameraPermissionStatus == PermissionStatus.denied) &&
            (storagePermissionStatus == PermissionStatus.denied))
        ? permissionDeniedMessage()
        : permissionDisabledMessage();
  }

  ///Throw message for permission denied
  static void permissionDeniedMessage() {
    throw PlatformException(
        code: "PERMISSION_DENIED",
        message: "Access to camera and storage denied",
        details: null);
  }

  ///Throw message for permission disabled
  static void permissionDisabledMessage() {
    throw PlatformException(
        code: "PERMISSION_DISABLED",
        message: "Camera data is not available on device",
        details: null);
  }
}
