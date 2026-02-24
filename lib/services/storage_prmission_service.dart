import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/enum.dart';
import '../reusable_widgets/custom_dialog.dart';


class StoragePermissionService {
  final BuildContext context;
  final Alerts _alerts;

  StoragePermissionService({required this.context}) : _alerts = Alerts(context: context);

  void requestStoragePermission() async {
    return;
    try {
      final android = await DeviceInfoPlugin().androidInfo;

      /// For SDK version 30 and later
      if (android.version.sdkInt >= 30) {
        PermissionStatus status = await Permission.manageExternalStorage.request();
        if (status == PermissionStatus.granted) {
          /// Do on ranted
        } else if (status == PermissionStatus.permanentlyDenied) {
          _alerts.customDialog(
              type: AlertType.warning,
              message: 'Manage Storage Permission Denied Forever!',
              description: 'Please give manage storage permission from Settings and press Try again',
              button1: 'Try Again',
              button2: 'Go To Settings',
              twoButtons: false,
              onTap1: () async {
                status = await Permission.storage.request();
                if (status == PermissionStatus.granted) {
                  Navigator.of(context).pop();
                }
              },
              onTap2: () async {
                // await openAppSettings();
              });
        } else if (status != PermissionStatus.granted) {
          status = await Permission.manageExternalStorage.request();
          if (status == PermissionStatus.granted) {
            /// Do on ranted
          } else if (status != PermissionStatus.granted) {
            _alerts.customDialog(
                type: AlertType.warning,
                message: 'Manage Storage Permission not granted!',
                description: 'Please give manage storage permission from Settings and press Try again',
                button1: 'Try Again',
                button2: 'Go To Settings',
                twoButtons: false,
                onTap1: () async {
                  Navigator.pop(context);
                  requestStoragePermission();
                },
                onTap2: () async {
                  // await openAppSettings();
                });
          }
        }
      }

      /// For SDK version 29 and older
      else {
        PermissionStatus status = await Permission.storage.request();

        if (status == PermissionStatus.granted) {
          /// Do on ranted
        } else if (status == PermissionStatus.permanentlyDenied) {
          _alerts.customDialog(
              type: AlertType.warning,
              message: 'Storage Permission Denied Forever!',
              description: 'Please give storage permission from Settings and press Try again',
              button1: 'Try Again',
              button2: 'Go To Settings',
              twoButtons: true,
              onTap1: () async {
                status = await Permission.storage.request();
                if (status == PermissionStatus.granted) {
                  Navigator.of(context).pop();
                }
              },
              onTap2: () async {
                // await openAppSettings();
              });
        } else if (status != PermissionStatus.granted) {
          status = await Permission.storage.request();
          if (status == PermissionStatus.granted) {
            /// Do on ranted
          } else if (status != PermissionStatus.granted) {
            _alerts.customDialog(
                type: AlertType.warning,
                message: 'Storage Permission not granted!',
                description: 'Please give storage permission from Settings and press Try again',
                button1: 'Try Again',
                button2: 'Go To Settings',
                twoButtons: true,
                onTap1: () async {
                  Navigator.pop(context);
                  requestStoragePermission();
                },
                onTap2: () async {
                  // await openAppSettings();
                });
          }
        }
      }
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }
  }

  Future<bool> requestBasicPermission() async {
    try {
      final android = await DeviceInfoPlugin().androidInfo;

      PermissionStatus status = (android.version.sdkInt >= 30)
          ? await Permission.manageExternalStorage.request()
          : await Permission.storage.request();

      if (status == PermissionStatus.granted) {
        return true;
      } else if (status == PermissionStatus.permanentlyDenied) {
        return false;
      }
      // else if (status != PermissionStatus.granted) {
      //   status = (android.version.sdkInt >= 30)
      //       ? await Permission.manageExternalStorage.request()
      //       : await Permission.storage.request();
      //
      //   return status == PermissionStatus.granted;
      // }
      return status == PermissionStatus.granted;
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }

    return false;
  }

  static Future<bool> isStoragePermissionGranted() async {
    final android = await DeviceInfoPlugin().androidInfo;

    PermissionStatus status = (android.version.sdkInt >= 30)
        ? await Permission.manageExternalStorage.status
        : await Permission.storage.status;

    return status == PermissionStatus.granted;
  }
}
