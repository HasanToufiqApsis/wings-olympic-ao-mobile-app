import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart';
import '../../api/links.dart';
import '../../constants/enum.dart';
import '../../constants/sync_global.dart';
import '../../models/assetModel.dart';
import '../../provider/global_provider.dart';
import '../../reusable_widgets/custom_dialog.dart';
import '../connectivity_service.dart';
import '../sync_service.dart';

class AssetDownloadService {
  final BuildContext context;
  int count = 0;
  WidgetRef? ref;

  AssetDownloadService(this.context, {this.ref});

  final SyncService _syncService = SyncService();

  // Future<bool> _requestPermission() async {
  //   if (Platform.isAndroid) {
  //     if (await Permission.storage.isGranted) {
  //       return true;
  //     } else {
  //       var result = await Permission.storage.request();
  //       if (result == PermissionStatus.granted) {
  //         return true;
  //       }
  //     }
  //     return false;
  //   }
  //   return false;
  // }

  Future<String> getBasePath() async {
    // bool permission = await _requestPermission();
    // if (permission != true) {
    //   // // openAppSettings();
    //   // Alerts(context: context).customDialog(
    //   //     type: AlertType.warning,
    //   //     message: 'Permission not Given',
    //   //     description: 'Please give storage permission for the app to function',
    //   //     onTap1: () {
    //   //       Navigator.pop(context);
    //   //       // openAppSettings();
    //   //     });
    // }

    // Directory? baseDir = await getExternalStorageDirectory();
    // print(baseDir.pa)
    Directory baseDir = await getApplicationDocumentsDirectory();
    String path = ('${baseDir.path}/v2');
    // String path = ('/v2');
    return path;
  }

  Future<bool> checkFolderExistence(String folder, {String? version}) async {
    String path = await getBasePath();
    Directory directory;
    if (version != null) {
      directory = Directory("$path/$folder/$version");
    } else {
      directory = Directory("$path/$folder");
    }
    bool folderExists = await directory.exists();
    return folderExists;
  }

  /// get list of files from directory
  Future<List> getListFromDirectory(String folder) async {
    List list = [];
    String path = await getBasePath();
    Directory directory = Directory("$path/$folder");
    List<FileSystemEntity> files = await directory.list().toList();

    for (var i in files) {
      folder == 'digital_learning' ?
      list.add('/app-api/static-file/$folder/${basename(i.path)}') :
      list.add('/app-api/static-file/av_kv_assets/${basename(i.path)}');
    }
    return list;
  }

  ///get list of files to download
  Future<List<AssetModel>> getSyncAssetList() async {
    await _syncService.checkSyncVariable();
    List<AssetModel> downloadList = [];

    // asset list
    if (syncObj.containsKey('finalAssets')) {
      Map finalAssets = syncObj['finalAssets'];

      for (var i in finalAssets.entries) {
        if (i.key != "icons") {
          bool exists = await checkFolderExistence(i.key, version: i.value["version"]);
          if (!exists) {
            downloadList.add(AssetModel.fromJson(i.value));
          }
        }
      }
    }

    /// av list
    if (syncObj.containsKey('av_configurations')) {
      Map avAssets = syncObj['av_configurations'];
      List syncAvFiles = [];
      List directoryAvFiles = [];
      List toDelete = [];
      List toDownload = [];

      bool exists = await checkFolderExistence('av');
      print("AV EXIST ::: $exists");

      if (!exists) {
        for (var i in avAssets.entries) {
          toDownload.add(i.value['url']);
        }
      } else {
        for (var i in avAssets.entries) {
          syncAvFiles.add(i.value['url']);
        }
        directoryAvFiles = await getListFromDirectory('av');
        print("AV EXIST ::: $directoryAvFiles");
        print("AV EXIST ::: $syncAvFiles");

        toDownload = syncAvFiles.toList()..removeWhere(directoryAvFiles.contains);
        toDelete = directoryAvFiles.toList()..removeWhere(syncAvFiles.contains);
        if (toDelete.isNotEmpty) {
          await delete(list: toDelete, folder: 'av');
        }
      }

      if (toDownload.isNotEmpty) {
        downloadList.add(AssetModel(slug: 'av', assets: toDownload));
      }
    }

    ///kv list
    if (syncObj.containsKey('wom_configurations')) {
      Map temp = syncObj['wom_configurations'];
      Map kvAssets = {for (var k in temp.keys.where((element) => temp[element]['type'] == 'kv')) k: temp[k]};

      List syncKvFiles = [];
      List directoryKvFiles = [];
      List toDelete = [];
      List toDownload = [];

      bool exists = await checkFolderExistence('kv');

      if (!exists) {
        for (var i in kvAssets.entries) {
          toDownload.add(i.value['url']);
        }
      } else {
        for (var i in kvAssets.entries) {
          syncKvFiles.add(i.value['url']);
        }
        directoryKvFiles = await getListFromDirectory('kv');

        toDownload = syncKvFiles.toList()..removeWhere(directoryKvFiles.contains);
        toDelete = directoryKvFiles.toList()..removeWhere(syncKvFiles.contains);

        if (toDelete.isNotEmpty) {
          await delete(list: toDelete, folder: 'kv');
        }
      }
      if (toDownload.isNotEmpty) {
        downloadList.add(AssetModel(slug: 'kv', assets: toDownload));
      }
    }

    ///tutorial list
    if (syncObj.containsKey('tutorial')) {
      List tutorialAssets = syncObj['tutorial'];
      List syncTutorialFiles = [];
      List directoryTutorialFiles = [];
      List toDelete = [];
      List toDownload = [];

      bool exists = await checkFolderExistence('tutorial');

      if (!exists) {
        for (var i in tutorialAssets) {
          toDownload.add(i['url']);
        }
      } else {
        for (var i in tutorialAssets) {
          syncTutorialFiles.add(i['url']);
        }
        directoryTutorialFiles = await getListFromDirectory('tutorial');
        print("TUTORIAL EXIST ::: $directoryTutorialFiles");
        print("TUTORIAL EXIST ::: $syncTutorialFiles");

        toDownload = syncTutorialFiles.toList()..removeWhere(directoryTutorialFiles.contains);
        toDelete = directoryTutorialFiles.toList()..removeWhere(syncTutorialFiles.contains);

        if (toDelete.isNotEmpty) {
          await delete(list: toDelete, folder: 'tutorial');
        }
      }

      if (toDownload.isNotEmpty) {
        downloadList.add(AssetModel(slug: 'tutorial', assets: toDownload));
      }
    }

    ///digital learning list
    if (syncObj.containsKey('rtc_config')) {
      if (syncObj["rtc_config"].containsKey('videos')) {
        List tutorialAssets = syncObj["rtc_config"]['videos'];
        List syncTutorialFiles = [];
        List directoryTutorialFiles = [];
        List toDelete = [];
        List toDownload = [];

        bool exists = await checkFolderExistence('digital_learning');

        if (!exists) {
          for (var i in tutorialAssets) {
            toDownload.add(i['video_url']);
          }
        } else {
          for (var i in tutorialAssets) {
            syncTutorialFiles.add(i['video_url']);
          }
          directoryTutorialFiles = await getListFromDirectory('digital_learning');

          toDownload = syncTutorialFiles.toList()..removeWhere(directoryTutorialFiles.contains);
          toDelete = directoryTutorialFiles.toList()..removeWhere(syncTutorialFiles.contains);

          if (toDelete.isNotEmpty) {
            await delete(list: toDelete, folder: 'digital_learning');
          }
        }

        if (toDownload.isNotEmpty) {
          downloadList.add(AssetModel(slug: 'digital_learning', assets: toDownload));
        }
      }
    }

    List<String> iconAssets = await getAllUniqueIconListForDownload();
    List syncIconImageFiles = [];
    List directoryIconImageFiles = [];
    List toDownloadIcons = [];
    List toDeleteIcons = [];

    bool folderExists = await checkFolderExistence("icon_images");
    if (!folderExists) {
      if (iconAssets.isNotEmpty) {
        toDownloadIcons = [...iconAssets];
      }
    } else {
      syncIconImageFiles = [...iconAssets];
      directoryIconImageFiles = await getListFromDirectory("icon_images");
      toDownloadIcons = syncIconImageFiles.toList()..removeWhere(directoryIconImageFiles.contains);
      toDeleteIcons = directoryIconImageFiles.toList()..removeWhere(syncIconImageFiles.contains);

      if (toDeleteIcons.isNotEmpty) {
        await delete(folder: "icon_images", list: toDeleteIcons);
      }
    }
    if (toDownloadIcons.isNotEmpty) {
      downloadList.add(AssetModel(slug: "icon_images", assets: toDownloadIcons));
    }

    return downloadList;
  }

  delete({List? list, required String folder}) async {
    print('toDelete $folder');
    await _syncService.checkSyncVariable();
    String path = await getBasePath();
    Directory directory;
    if (list == null) {
      directory = Directory("$path/$folder");
      bool b = await directory.exists();
      if (b == true) {
        directory.deleteSync(recursive: true);
      }
    } else {
      directory = Directory("$path/$folder");
      if (list.isNotEmpty) {
        for (var i in list) {
          await File('${directory.path}/${basename(i)}').delete();
        }
      }
    }
  }

  ///=============== download process ==========================

  Future<bool> bulkDownload({required String folder, required String? version, required List files}) async {
    try {
      String path;
      if (version != null) {
        await delete(folder: folder);
        path = ('${await getBasePath()}/$folder/$version');
      } else {
        path = ('${await getBasePath()}/$folder');
      }
      Directory assetDirectory = Directory(path);
      bool directoryExists = await assetDirectory.exists();

      if (!directoryExists) {
        await assetDirectory.create(recursive: true);
      }

      for (var i in files) {
        await downloadFileWithHttp(url: i, path: path).then((value) {
          ref!.read(progressProvider.state).state++;
        });
      }

      return true;
    } catch (e) {
      print('inside bulkDownload in AssetDownloadService catch block $e');
      return false;
    }
  }

  Future<bool> downloadFileWithHttp({required String url, required String path}) async {
    bool success = false;
    try {
      print("inside here");
      String fileName = basename(url);
      String fileUrl = '${Links.baseUrl}$url';
      print("file url $fileUrl");
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

  //=========== Unique icon list for download ==============
  Future<List<String>> getAllUniqueIconListForDownload() async {
    Set<String> icons = {};
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("retailers")) {
        if (syncObj["retailers"].isNotEmpty) {
          for (Map retailer in syncObj["retailers"]) {
            if (retailer.containsKey("icon_data")) {
              if (retailer["icon_data"].isNotEmpty) {
                for (var icon in retailer["icon_data"]) {
                  String iconUrl = "/static-file/assets/$icon";
                  icons.add(iconUrl);
                }
                // icons.addAll(retailer["icon_data"]);
              }
            }
          }
        }
      }
    } catch (e) {
      print("inside getAllUniqueIconListForDownload AssetDownloadServices catch block $e");
    }
    return icons.toList();
  }

  //=====================================================

  Future<double> getInternetSpeed() async {
    final stopWatch = Stopwatch();
    try {
      String fileUrl = "https://prism360.net/public/images/pp_images/img_avatar.png";
      // String fileUrl = '${Links().baseUrl}/static-file/assets/speed_test_file.pdf';
      ConnectivityService internetPopup = ConnectivityService();
      if (await internetPopup.checkInternet()) {
        stopWatch.start();
        Dio dio = Dio();
        Response response = await dio
            .get(
              fileUrl,
              options: Options(
                  responseType: ResponseType.bytes,
                  followRedirects: false,
                  validateStatus: (status) {
                    return status! < 500;
                  }),
            )
            .timeout(const Duration(seconds: 2));
        if (response.statusCode == 200 || response.statusCode == 201) {
          int milliSec = stopWatch.elapsed.inMilliseconds;
          if (stopWatch.isRunning) {
            stopWatch.stop();
          }
          if (milliSec == 0) {
            return 0.0;
          }
          return ((9216 * 8 * 1000) / (milliSec * 1024));
        }
      }
    } catch (e, s) {
      print("inside asset download service getInternetSpeed $e, $s");
    }
    if (stopWatch.isRunning) {
      stopWatch.stop();
    }
    return 0.0;
  }
}
