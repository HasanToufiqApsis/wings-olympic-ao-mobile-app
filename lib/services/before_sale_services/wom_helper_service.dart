import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';

import '../../constants/constant_keys.dart';
import '../../constants/sync_global.dart';
import '../../models/WomModel.dart';
import '../sync_service.dart';

class WomHelperService {
  final ReceivePort port = ReceivePort();
  WomHelperService();

  final SyncService _syncService = SyncService();


  ///wom list for retailers
  Future<List<WomModel>> getWomList(
      {required List womIdList, required int retailerId}) async {
    List<WomModel> womList = [];

    await _syncService.checkSyncVariable();
    for (var i in womIdList) {
      syncObj['wom_configurations'].forEach((k, v) {
        if (k == i.toString()) {
          bool alreadyCompleted =
          checkWomData(womId: i, retailerId: retailerId);

          if (alreadyCompleted == false) {
            womList.add(WomModel.fromJson(v));
          }
        }
      });
    }

    return womList;
  }

  ///checking if retailer already did the wom
  bool checkWomData({required int womId, required int retailerId}) {
    bool checkWomData = false;
    if (syncObj.containsKey(womDataKey)) {
      if (syncObj[womDataKey].containsKey(retailerId.toString())) {
        if (syncObj[womDataKey][retailerId.toString()]
            .containsKey(womId.toString())) {
          checkWomData = true;
        }
      }
    }

    return checkWomData;
  }
}
