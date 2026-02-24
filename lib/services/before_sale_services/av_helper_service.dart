import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../constants/constant_keys.dart';
import '../../constants/sync_global.dart';
import '../../models/AvModel.dart';
import '../asset_download/asset_download_helper_service.dart';
import '../sync_service.dart';

class AvHelperService {
  final ReceivePort port = ReceivePort();
  AvHelperService();

  final SyncService _syncService = SyncService();

  ///av dwnload and fetch


  ///av list for retailers
  Future<List<AvModel>> getAvList({required List avIdList, required int retailerId, bool all = false}) async {
    List<AvModel> avList = [];

    await _syncService.checkSyncVariable();
    print(avIdList);
    for (var i in avIdList) {
      syncObj['av_configurations'].forEach((k, v) {
        if (k == i.toString()) {
          bool alreadyCompleted = checkAvData(avId: i, retailerId: retailerId);

          if (all == false) {
            if (alreadyCompleted == false) {
              avList.add(AvModel.fromJson(v));
            }
          } else {
            avList.add(AvModel.fromJson(v));
          }
        }
      });
    }
    return avList;
  }

  ///checking if retailer already did the av
  bool checkAvData({required int avId, required int retailerId}) {
    bool checkAvData = false;

    if (syncObj.containsKey(avDataKey)) {
      if (syncObj[avDataKey].containsKey(retailerId.toString())) {
        if (syncObj[avDataKey][retailerId.toString()].containsKey(avId.toString())) {
          checkAvData = true;
        }
      }
    }

    return checkAvData;
  }


  Future<File?> getAv(String name) async {
    try {
      File? av;

      await createAvDirectory();
      String path = ('${await AssetDownloadHelperService().getBasePath()}/av');

      Directory avDirectory = Directory(path);

      av = File('${avDirectory.path}/$name');

      bool fileExists = await av.exists();

      if (!fileExists) {
        await AssetDownloadHelperService().downloadFileWithHttp(url: "/static-file/assets/$name", path: path);
        return File(av.path);
      } else {
        return File(av.path);
      }
    } catch (e) {
      print("inside getAv catch block $e");
      return null;
    }
  }


  //create asset Directory
  Future<bool> createAvDirectory() async {
    try {
      String path = await AssetDownloadHelperService().getBasePath();
      Directory avDirectory = Directory(path);
      bool directoryExists = await avDirectory.exists();

      if (!directoryExists) {
        await avDirectory.create(recursive: true);
        return true;
      } else {
        return true;
      }
    } catch (e, s) {
      print("inside createAvFile catch block $s");
      return false;
    }
  }
}
