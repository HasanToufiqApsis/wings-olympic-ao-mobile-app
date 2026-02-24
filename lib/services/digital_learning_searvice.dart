import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../constants/constant_keys.dart';
import '../constants/sync_global.dart';
import '../models/digital_learning/digital_learning_item.dart';
import 'asset_download/asset_download_service.dart';
import 'helper.dart';
import 'sync_service.dart';

class DigitalLearningService {
  final SyncService _syncService = SyncService();

  Future<List<DigitalLearningItem>> getDigitalLearningsList() async {
    List<DigitalLearningItem> list = [];
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("rtc_config")) {
        var rtcConfig = syncObj["rtc_config"];
        bool enableDigitalLearning = await checkDigitalLearningEnable();
        if (enableDigitalLearning) {
          if (rtcConfig.containsKey("videos")) {
            for (var val in rtcConfig["videos"]) {
              final digitalLearningItem = DigitalLearningItem.fromJson(val);
              if (rtcConfig.containsKey("survey_details")) {
                if (rtcConfig["survey_details"].containsKey("survey_info")) {
                  List allSurveyInfo = rtcConfig["survey_details"]["survey_info"];

                  for (var s in allSurveyInfo) {
                    if (s.containsKey('id') && s['id'] == val['survey_id'] && s.containsKey('name')) {
                      digitalLearningItem.name = s['name'];
                    }
                  }
                }
              }
              print('learning name is::: ${digitalLearningItem.name}');
              list.add(digitalLearningItem);
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("$e");
      Helper.dPrint("$s");
    }
    return list;
  }

  Future<void> viewSingleDigitalLearningData({
    required int digitalLearningId,
  }) async {
    await _syncService.checkSyncVariable();

    try {
      if (!syncObj.containsKey(digitalLearningKey)) {
        syncObj[digitalLearningKey] = {};
      }

      // if (!syncObj[digitalLearningKey].containsKey(digitalLearningId.toString())) {
      //   syncObj[digitalLearningKey][digitalLearningId.toString()] = {};
      // }

      Map discountSkus = {};

      Map tryBeforeBuyMap = {
        digitalLearningId: digitalLearningId,
        digitalLearningAlreadyView: true,
      };

      discountSkus[digitalLearningId.toString()] = tryBeforeBuyMap;

      syncObj[digitalLearningKey] = discountSkus;
      await SyncService().writeSync(jsonEncode(syncObj));
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
  }

  Future<bool> checkDigitalLearningEnable() async {
    bool enable = false;
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("rtc_config")) {
        var rtcConfig = syncObj["rtc_config"];
        if (rtcConfig.containsKey("is_enabled") && rtcConfig["is_enabled"] == true) {
          enable = true;
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside getUnsoldNoButtonsList SaleServices catch block $e $s");
    }
    return enable;
  }

  Future<File?> grtDigitalLearning(String name, BuildContext context) async {
    try {
      File? tutorial;

      await createAvDirectory(context);
      String path = ('${await AssetDownloadService(context).getBasePath()}/digital_learning');

      Directory avDirectory = Directory(path);

      tutorial = File(avDirectory.path + '/$name');

      bool fileExists = await tutorial.exists();

      if (!fileExists) {
        await AssetDownloadService(context).downloadFileWithHttp(url: "/static-file/assets/$name", path: path);
        return File(tutorial.path);
      } else {
        return File(tutorial.path);
      }
    } catch (e) {
      print("inside getTutorial catch block $e");
      return null;
    }
  }

  //create asset Directory
  Future<bool> createAvDirectory(BuildContext context) async {
    try {
      String path = await AssetDownloadService(context).getBasePath();
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
