import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> getCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      return true;
    }
    return false;

    // if (status.isDenied) {
    //   status = await Permission.camera.request();
    // }
    //
    //  else if (status.isDenied) {
    //   print("Camera permission denied");
    // } else if (status.isPermanentlyDenied) {
    //   print("Camera permission permanently denied, open settings");
    //   await openAppSettings();
    // }
  }

  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }
}