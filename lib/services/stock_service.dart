import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:wings_olympic_sr/services/product_category_services.dart';
import 'package:wings_olympic_sr/services/sync_read_service.dart';
import 'package:wings_olympic_sr/services/sync_service.dart';

import '../api/global_http.dart';
import '../api/links.dart';
import '../constants/constant_keys.dart';
import '../constants/enum.dart';
import '../constants/sync_global.dart';
import '../models/module.dart';
import '../models/products_details_model.dart';
import '../models/returned_data_model.dart';
import '../models/sr_info_model.dart';
import 'device_info_services.dart';


class StockService {
  static final StockService _syncStockReadService = StockService._internal();

  factory StockService() {
    return _syncStockReadService;
  }
  StockService._internal();
  final SyncService _syncService = SyncService();
  final SyncReadService _syncReadService = SyncReadService();

  // final SyncDataWithServerServices _syncDataWithServerServices = SyncDataWithServerServices();
  final ProductCategoryServices _productCategoryServices = ProductCategoryServices();

  Future<bool> writeStockData(Map stocks) async {
    try {
      await _syncService.checkSyncVariable();
      stocks.forEach((key, value) {
        syncObj['stock'][value['slug']][key] = {"lifting_stock": value['lifting_stock'], "current_stock": value['current_stock']};
      });

      return true;
    } catch (e) {
      print('Inside writeStockData function $e');
      return false;
    }
  }

  Future<StockModel> getCurrentTotalStocks() async {
    int totalIssued = 0;
    int totalStock = 0;
    await _syncService.checkSyncVariable();
    Map<String, dynamic> stockMap = syncObj['stock'];
    stockMap.forEach((key, value) {
      value.forEach((k, v) {
        totalIssued += v['lifting_stock'] as int;
        totalStock += v['current_stock'] as int;
      });
    });
    return StockModel(liftingStock: totalIssued, currentStock: totalStock);
  }

  Future<int?> getStockAllocationAmount(int skuId)async{
    try {
      await _syncService.checkIfSalesModuleExists();
      if(syncObj.containsKey("stock_allocations")){
        if(syncObj["stock_allocations"].containsKey(skuId.toString())){
          return int.tryParse(syncObj["stock_allocations"][skuId.toString()].toString());
        }
      }
    }
    catch(e){
      print("inside getSkuAnalyticalData function error $e");
    }
    return null;
  }


  Future<Map<String, dynamic>> getSkuAnalyticalDataForStock(int skuID)async{
    try {
      await _syncService.checkIfSalesModuleExists();
      if(syncObj.containsKey("analytical_infos")){
        if(syncObj["analytical_infos"].containsKey("stock")){
          if(syncObj["analytical_infos"]["stock"].containsKey(skuID.toString())){

            return syncObj["analytical_infos"]["stock"][skuID.toString()];

          }
        }
      }
      // return syncObj["analytical_infos"]["stock"][skuID.toString()];
    }
    catch(e){
      print("inside getSkuAnalyticalData function error $e");
    }
    return {};
  }

  Future<StockModel> getCurrentTotalStocksByModuleId(String moduleSlug) async {
    int totalIssued = 0;
    int totalStock = 0;
    await _syncService.checkSyncVariable();
    if(!syncObj.containsKey("stock")){
      return StockModel(liftingStock: totalIssued, currentStock: totalStock);
    }
    if(!syncObj["stock"].containsKey(moduleSlug)){
      return StockModel(liftingStock: totalIssued, currentStock: totalStock);
    }
    Map<String, dynamic> stockMap = syncObj['stock'][moduleSlug];
    stockMap.forEach((key, value) {
      totalIssued += value['lifting_stock'] as int;
      totalStock += value['current_stock'] as int;
      // value.forEach((k, v) {
      //
      // });
    });
    return StockModel(liftingStock: totalIssued, currentStock: totalStock);
  }

  Future<int> getTotalInStock() async {
    await _syncService.checkSyncVariable();
    Map<String, dynamic> stockMap = syncObj['stock'];
    int totalInStock = 0;
    stockMap.forEach((key, value) {
      value.forEach((k, v) {
        totalInStock += v['current_stock'] as int;
      });
    });
    return totalInStock;
  }

  ////////Save lifting stock to SyncFile//////////////////
  saveLiftingStockToSync(Map<String, Map<String, Map<String, int>>> stocks) async {
    try {
      await _syncService.checkSyncVariable();
      Map prevStocks = syncObj["stock"];
      print("### Come to here::  ${prevStocks}");
      print("### Come to here:::  ${stocks}");
      if (prevStocks.isNotEmpty) {
        prevStocks.forEach((key, value) {
          if (stocks.containsKey(key)) {
            if (stocks[key]!.isNotEmpty) {
              syncObj["stock"][key] = stocks[key];
            }
          }
        });
        // await _syncDataWithServerServices.syncStockRelatedData(false);
        await _syncService.writeSync(jsonEncode(syncObj));
        print("### Come to here::>>>");
        sendStockDataToServer();
      }
    } catch (e) {
      print("inside saveLiftingStockToSync stock_services catch block $e");
    }
  }

  //getAllStockMap from sync File
  Future<Map> getAllStockMapFromSyncFile() async {
    try {
      await _syncService.checkSyncVariable();
      return syncObj["stock"];
    } catch (e) {
      print("inside getAllStockMapFromSyncFile stockServices catch block $e");
    }
    return {};
  }


  ///send stock data to server
  sendStockDataToServer() async {
    try {
      await _syncService.checkSyncVariable();
      //checks if device log is sent.has no connection with sale data
      await DeviceInfoService().sendDeviceInfoIfDeviceInfoIsNotSent();

      SrInfoModel srInfo = await _syncReadService.getSrInfo();
      List stockDataList = await getLiftingStock();

      print("--------------->>>> >> 4 ${stockDataList.length}");

      ReturnedDataModel returned = await GlobalHttp(
          httpType: HttpType.post,
          uri: '${Links.baseUrl}${Links.submitLiftingStock}',
          accessToken: srInfo.accessToken,
          refreshToken: srInfo.refreshToken,
          body: jsonEncode(stockDataList))
          .fetch();
      if (returned.status == ReturnedStatus.success) {
        // await _syncDataWithServerServices.syncStockRelatedData(true);
        await _syncService.writeSync(jsonEncode(syncObj));
      }
    } catch (e, s) {
      print('inside sendStockDataToServer in stock service $e $s');
    }
  }

  // returns List of lifting stock by sku id
  Future<List<Map>> getLiftingStock() async {
    List<Map> liftingStock = [];
    try {
      await _syncService.checkSyncVariable();
      SrInfoModel srInfo = await _syncReadService.getSrInfo();
      String salesDate = await _syncReadService.getSalesDate();
      if (syncObj["stock"].isNotEmpty) {
        for (var m in syncObj["stock"].keys) {
          var stockBySku = syncObj["stock"][m];
          print("--------------->>>> >> 1 ${stockBySku}");
          if (stockBySku.isNotEmpty) {
            Module? module = await _productCategoryServices.getModuleModelFromModuleSlug(m);
            print("--------------->>>> >> 2 ${module?.name}");
            stockBySku.forEach((skuId, stockMap) {
              if (stockMap.containsKey("lifting_stock")) {
                print("--------------->>>> >> 2 ${module?.name}");
                if (stockMap["lifting_stock"] > 0) {
                  print("--------------->>>> >> 3 ${stockMap["lifting_stock"]}");
                  Map s = {
                    "ff_id": srInfo.ffId,
                    "sbu_id": module!.id,
                    "dep_id": srInfo.depId,
                    "section_id": srInfo.sectionId,
                    "sku_id": int.parse(skuId.toString()),
                    "quantity": stockMap["lifting_stock"],
                    "date": salesDate
                  };
                  liftingStock.add(s);
                }
              }
            });
          }
        }
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }

    return liftingStock;
  }

  //set stock information in sku

}
