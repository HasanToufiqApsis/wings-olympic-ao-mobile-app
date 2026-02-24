import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../api/links.dart';
import '../../constants/sync_global.dart';
import '../sync_service.dart';

class AssetDownloadHelperService {
  int count = 0;

  AssetDownloadHelperService();

  final SyncService _syncService = SyncService();

  Future<bool> _requestPermission() async {
    return true;
    if (Platform.isAndroid) {
      if (await Permission.storage.isGranted) {
        return true;
      } else {
        var result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      }
      return false;
    }
    return false;
  }

  Future<String> getBasePath() async {
    bool permission = await _requestPermission();
    if (permission != true) {
      // openAppSettings();
      // Alerts(context: context).customDialog(
      //     type: AlertType.warning,
      //     message: 'Permission not Given',
      //     description: 'Please give storage permission for the app to function',
      //     onTap1: () {
      //       Navigator.pop(context);
      //       // openAppSettings();
      //     });
    }

    // Directory? baseDir = await getExternalStorageDirectory();
    // print(baseDir.pa)
    Directory baseDir = await getApplicationDocumentsDirectory();
    String path = ('${baseDir.path}/v2');
    // String path = ('/v2');
    return path;
  }

  /// This method return the actual url from where the file will be downloaded
  /// it could be from the server or from the Microsoft Blob
  Future<String> _getAssetDownloadUrl(String staticPath) async {
    String prefix = Links.baseUrl;
    String postfix = '';

    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey('assets_download_urls')) {
        if (syncObj['assets_download_urls'].containsKey('prefix_url')) {
          prefix = syncObj['assets_download_urls']['prefix_url'];
        }
        if (syncObj['assets_download_urls'].containsKey('postfix_url')) {
          postfix = syncObj['assets_download_urls']['postfix_url'];
        }
      }
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }

    return prefix + staticPath + postfix;
  }

  Future<bool> downloadFileWithHttp({required String url, required String path}) async {
    bool success = false;
    try {
      String fileName = basename(url);

      String fileUrl = await _getAssetDownloadUrl(url);
      log('Downloading... $fileUrl');
      String pathString = "$path/$fileName";

      File pathFile = File(pathString);
      if (!(await pathFile.exists())) {
        try {
          Dio dio = Dio();
          Response response = await dio.get(
            fileUrl,
            options: Options(
                responseType: ResponseType.bytes,
                followRedirects: false,
                validateStatus: (status) {
                  return status! < 500;
                }),
          );
          var raf = pathFile.openSync(mode: FileMode.write);
          raf.writeFromSync(response.data);
          await raf.close();
        } catch (e) {
          print("start file download catch block $e");
        }
      }
    } catch (e) {
      print("inside downloadFileWithHttp assetDownloadService catch block $e");
    }

    return success;
  }
}
