import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:wings_olympic_sr/models/outlet_model.dart';

import '../../../constants/constant_keys.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/sync_global.dart';
import '../../../models/sr_info_model.dart';
import '../../../services/Image_service.dart';
import '../../../services/connectivity_service.dart';
import '../../../services/ff_services.dart';
import '../../../services/sync_service.dart';
import '../../../utils/stock_check_utils.dart';
import '../../stock_check/repository/stock_check_repository.dart';
import '../repository/stock_validation_repository.dart';

class StockCheckService {
  final _stockCheckRepository = CheckStockRepository();
  final _syncService = SyncService();

  Future getAndUpdateMaxStockLimitForPreorder() async {
    try {
      if (await ConnectivityService().checkInternet()) {
        final responseData = await _stockCheckRepository.getUpdatedMaxLimitForPreorder();
        if (responseData.data != null) {
          Map mapData = responseData.data;
          print("map data: $mapData");
          if (mapData.containsKey("data")) {
            if (!syncObj.containsKey('max_order_limit_config')) {
              syncObj['max_order_limit_config'] = {};
            }
            syncObj['max_order_limit_config'] = mapData["data"];
            await _syncService.writeSync();
          }
        }
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
  }

  Future sendManualOverrideImageToServer(
    File compressedImage,
    StockCheckStatus source,
    OutletModel outlet,
    String imageName,
  ) async {
    String timeStamp = apiDateFormat.format(DateTime.now());
    if (await ConnectivityService().checkInternet()) {
      SrInfoModel? sr = await FFServices().getSrInfo();
      String date = await FFServices().getSalesDate();
      DateTime saleDate = DateTime.parse(date);
      String path =
          "$stockCheckImageFolder/${saleDate.year}/${saleDate.month.toString().padLeft(2, '0')}/${saleDate.day.toString().padLeft(2, '0')}/${outlet.id}/${StockCheckUtils.toStr(source)}";
      bool done = await ImageService().sendImage(compressedImage.path, path);
      if (done) {
        await saveManualOverride(
          retailerId: outlet.id!,
          imagePath: compressedImage.path,
          dbPath: path,
          timestamp: timeStamp,
          source: source,
          imageName: imageName,
        );
        await getAndSubmitStockImage(source: source, retailer: outlet);
        // if (await compressedImage.exists()) {
        //   await compressedImage.delete();
        // }
      }
    } else {
      await saveManualOverride(
        retailerId: outlet.id!,
        imagePath: compressedImage.path,
        timestamp: timeStamp,
        source: source,
        imageName: imageName,
      );
    }
  }

  Future getAndSubmitStockImage({
    required StockCheckStatus source,
    required OutletModel retailer,
  }) async {
    try {
      final key = StockCheckUtils.toStr(source);
      if (syncObj.containsKey(stockCheckDaya)) {
        if (syncObj[stockCheckDaya].containsKey(retailer.id.toString())) {
          if (syncObj[stockCheckDaya][retailer.id.toString()].containsKey(key)) {
            SrInfoModel? sr = await FFServices().getSrInfo();
            final data = syncObj[stockCheckDaya][retailer.id.toString()][key];
            final payload = {
              "type": key,
              "dep_id": sr?.depId ?? 0,
              "outlet_id": retailer.id,
              "images": [data['imageName']],
              "date": data['timestamp'],
              "created_by": 0,
            };
            await _stockCheckRepository.submitStockImage(payLoad: payload);
          }
        }
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
  }

  Future<List> getStockCheckDataDataToSendToApi(OutletModel retailer) async {
    List stockCheckData = [];
    try {
      await _syncService.checkSyncVariable();
      SrInfoModel? sr = await FFServices().getSrInfo();
      String date = await FFServices().getSalesDate();
      if (syncObj.containsKey(stockCheckDaya)) {
        if (syncObj[stockCheckDaya].containsKey(retailer.id.toString())) {
          syncObj[stockCheckDaya][retailer.id.toString()].forEach((key, data) {
            if (!data.containsKey("dbPath")) {
              // getAndSubmitStockImage(source: StockCheckUtils.toType(key), retailer: retailer);
              DateTime saleDate = DateTime.parse(date);
              String path =
                  "$stockCheckImageFolder/${saleDate.year}/${saleDate.month.toString().padLeft(2, '0')}/${saleDate.day.toString().padLeft(2, '0')}/${retailer.id}/${key}";
              syncObj[stockCheckDaya][retailer.id.toString()][key]['dbPath'] = path;
              ImageService().sendImage(data['image'], path);
              _syncService.writeSync();
            }
            final payload = {
              "type": key,
              "dep_id": sr?.depId ?? 0,
              "outlet_id": retailer.id,
              "images": [data['imageName']],
              "date": data['timestamp'],
              "created_by": 0,
            };
            stockCheckData.add(payload);
          });
        }
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return stockCheckData;
  }

  Future saveManualOverride({
    required int retailerId,
    required String imagePath,
    required String timestamp,
    required StockCheckStatus source,
    String? dbPath,
    required String imageName,
  }) async {
    try {
      final key = StockCheckUtils.toStr(source);
      if (!syncObj.containsKey(stockCheckDaya)) {
        syncObj[stockCheckDaya] = {};
      }
      if (!syncObj[stockCheckDaya].containsKey(retailerId.toString())) {
        syncObj[stockCheckDaya][retailerId.toString()] = {};
      }
      if (!syncObj[stockCheckDaya][retailerId.toString()].containsKey(key)) {
        syncObj[stockCheckDaya][retailerId.toString()][key] = {};
      }

      syncObj[stockCheckDaya][retailerId.toString()][key] = {
        manualOverrideRetailerIdKey: retailerId,
        manualOverrideImageKey: imagePath,
        manualOverrideTimestampKey: timestamp,
        if (dbPath != null) "dbPath": dbPath,
        "imageName": "$imageName.jpg",
        "type": key,
      };

      await _syncService.writeSync();
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
  }
}
