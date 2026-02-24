import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/enum.dart';
import '../models/returned_data_model.dart';
import '../models/sr_info_model.dart';
import 'sync_read_service.dart';

class ExportPdaService {
  final String data;

  ExportPdaService(this.data);

  final SyncReadService _syncReadService = SyncReadService();

  Future<ReturnedDataModel> exportPdaFile() async {
    ReturnedDataModel returned =
        ReturnedDataModel(status: ReturnedStatus.error);
    try {
      String? path = await getExportPathForPDA();
      if (path != null) {
        String salesDate = await _syncReadService.getSalesDate();
        SrInfoModel srInfo = await _syncReadService.getSrInfo();
        String fileName = "sync_${srInfo.fullname}_$salesDate.wings";
        String filePath = path + "/" + fileName;
        File encryptedPda = File(filePath);
        if (!await encryptedPda.exists()) {
          await encryptedPda.create(recursive: true);
        }
        File encryptedFile = await encryptedPda.writeAsString(data);
        if (await encryptedFile.exists()) {
          returned.status = ReturnedStatus.success;
          returned.data = "Wings";
        }
      }
    } catch (e, s) {
      print("inside exportPdaFile ExportPdaService catch block $e $s");
    }

    return returned;
  }

  Future<String?> getExportPathForPDA() async {
    try {
      bool permission = await _requestPermission();
      if (permission == true) {
        Directory? directory = await getExternalStorageDirectory();
        if (directory != null) {
          String path = "";
          List<String> paths = directory.path.split("/");
          for (String p in paths) {
            if (p != "Android") {
              path += "/$p";
            } else {
              break;
            }
          }
          path += "/Wings";
          Directory newDirectory = Directory(path);
          if (!await newDirectory.exists()) {
            await directory.create(recursive: true);
          }

          return newDirectory.path;
        }
      }
    } catch (e) {
      print("inside getOutputPathForArchive updateController catch block $e");
    }
  }

  Future<bool> _requestPermission() async {
    bool success = false;
    // AndroidDeviceInfo deviceInfo = await DeviceInfoService().getAndroidInfo();
    try {
      if (Platform.isAndroid) {
        if (await Permission.manageExternalStorage.isGranted) {
          success = true;
        } else {
          var result = await Permission.manageExternalStorage.request();
          if (result == PermissionStatus.granted) {
            success = true;
          }
        }
        // if (deviceInfo.version.sdkInt! >= 30) {
        //
        // } else {
        //   var result = await Permission.storage.request();
        //   if (result == PermissionStatus.granted) {
        //     success = true;
        //   }
        // }
      }
    } catch (e) {
      print("inside request permission exportPda services catch block $e");
    }
    return success;
  }
}
