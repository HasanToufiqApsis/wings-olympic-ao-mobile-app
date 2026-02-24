import 'dart:convert';
import 'dart:developer';

import '../constants/sync_global.dart';
import '../models/brand/brand_model.dart';
import '../models/outlet_model.dart';
import '../models/posm/added_posm_model.dart';
import '../models/posm/posm_type_model.dart';
import '../models/retailers_mdoel.dart';
import '../models/sr_info_model.dart';
import 'sync_read_service.dart';
import 'sync_service.dart';

class PosmManagementService {
  final SyncService _syncService = SyncService();
  final SyncReadService _syncReadService = SyncReadService();

  Future<List<BrandModel>> getBrandList() async {
    List<BrandModel> brandList = [];
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("cats")) {
        if (syncObj['cats'].containsKey("1")) {
          if (syncObj['cats']["1"].containsKey("9")) {
            List<String> keyList = syncObj['cats']["1"]['9'].keys.toList();
            for (var v in keyList) {
              List<String> allocatedList = await allocatedPOSMList();
              BrandModel brand = BrandModel.fromJson(syncObj['cats']["1"]['9'][v]);
              if (allocatedList.contains(brand.id.toString())) {
                // int quantity = int.tryParse(syncObj["allocated_posm"][v]["quantity"]) ?? 0;
                // brand.quantity = quantity;
                brandList.add(brand);
              }
            }
          }
        }
      }
    } catch (e, s) {
      print("inside AssetService getAssetTypeList $e $s");
    }
    return brandList;
  }

  Future<List<PosmTypeModel>> getPosmTypeList({required int brandId}) async {
    List<PosmTypeModel> posmTypeList = [];
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("allocated_posm")) {
        if (syncObj['allocated_posm'].containsKey('$brandId')) {
          List posmTypeMapList = syncObj['allocated_posm']['$brandId'];
          for (var v in posmTypeMapList) {
            PosmTypeModel posmTypeModel = PosmTypeModel(
              id: v['posm_type_id'],
              quantity: v['quantity'],
              posmConfigId: v['posm_config_id'],
              posmType: v['posm_type'],
              posmTypeId: v['posm_type_id'],
            );
            posmTypeList.add(posmTypeModel);
          }
        } else {

          print('----<<> 2');
        }
      } else {
        print('----<<> 1');
      }
    } catch (e, s) {
      print("inside AssetService getAssetTypeList $e $s");
    }
    return posmTypeList;
  }

  Future<List<String>> allocatedPOSMList() async {
    List<String> brandList = [];
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("allocated_posm")) {
        Map allocatedPosm = syncObj['allocated_posm'];
        if (allocatedPosm.isNotEmpty) {
          brandList = syncObj['allocated_posm'].keys.toList();
        }
      }
    } catch (e, s) {
      print("inside AssetService getAssetTypeList $e $s");
    }
    return brandList;
  }

  Future<int> getAvailableQuantity({required String brandId, required int posmTypeId}) async {
    int availableQuantity = 0;
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("allocated_posm")) {
        if (syncObj['allocated_posm'].containsKey(brandId)) {
          List posmTypes= syncObj['allocated_posm'][brandId];
          if(posmTypes.isNotEmpty){
            int index = posmTypes.indexWhere((element) => element['posm_type_id']==posmTypeId);
            if(index!=-1){
              availableQuantity = int.tryParse(posmTypes[index]['quantity']) ?? 0;
            }
          }
        }
      }
    } catch (e, s) {
      print("inside AssetService getAssetTypeList $e $s");
    }
    return availableQuantity;
  }

  Future<bool> addPosm({required AddedPosmModel posmModel}) async {
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("allocated_posm")) {
        if (syncObj["allocated_posm"].containsKey("${posmModel.brandId}")) {
          List posmTypes= syncObj['allocated_posm']['${posmModel.brandId}'];
          if(posmTypes.isNotEmpty){
            int index = posmTypes.indexWhere((element) => element['posm_type_id']==posmModel.posmTypeId);
            if(index!=-1){
              Map allocatedPosm = posmTypes[index];

              int availableQuantity = int.tryParse(allocatedPosm["quantity"]) ?? 0;

              int updatedAvailableQuantity = availableQuantity - posmModel.quantity;
              allocatedPosm["quantity"] = updatedAvailableQuantity.toString();

              syncObj['allocated_posm']["${posmModel.brandId}"][index] = allocatedPosm;
              await SyncService().writeSync(jsonEncode(syncObj));
            }
          }

          bool result = await distributePosm(posmModel: posmModel);
          return result;
        }
      }
      return false;
    } catch (e, t) {
      log('error-> ${e.toString()}');
      log('error-> ${t.toString()}');
      return false;
    }
  }

  Future<bool> distributePosm({required AddedPosmModel posmModel}) async {
    try {
      await _syncService.checkSyncVariable();
      Map distributePosmMap = {};
      if (syncObj.containsKey("distribute_posm")) {
        distributePosmMap = syncObj["distribute_posm"];
      }
      if (distributePosmMap.containsKey("${posmModel.outlet.id}")) {
        if (distributePosmMap["${posmModel.outlet.id}"].containsKey("${posmModel.brandId}")) {

          if(distributePosmMap["${posmModel.outlet.id}"]["${posmModel.brandId}"].containsKey("${posmModel.posmTypeId}")){
            Map outletWiseDistributePosm = distributePosmMap["${posmModel.outlet.id}"]["${posmModel.brandId}"]["${posmModel.posmTypeId}"];
            int quantity = int.tryParse(outletWiseDistributePosm["quantity"]) ?? 0;
            quantity += posmModel.quantity;
            outletWiseDistributePosm["quantity"] = quantity.toString();
            distributePosmMap["${posmModel.outlet.id}"]["${posmModel.brandId}"]["${posmModel.posmTypeId}"] = outletWiseDistributePosm;
          }
          else {
            distributePosmMap["${posmModel.outlet.id}"]["${posmModel.brandId}"]['${posmModel.posmTypeId}'] =  getMap(posmModel: posmModel);
          }
        }

        else {
          distributePosmMap[posmModel.outlet.id.toString()]["${posmModel.brandId}"] = {};
          distributePosmMap["${posmModel.outlet.id}"]["${posmModel.brandId}"]['${posmModel.posmTypeId}'] = getMap(posmModel: posmModel);
        }
      }
      else {
        distributePosmMap[posmModel.outlet.id.toString()] = {};
        distributePosmMap[posmModel.outlet.id.toString()]["${posmModel.brandId}"] = {};
        distributePosmMap[posmModel.outlet.id.toString()]["${posmModel.brandId}"]["${posmModel.posmTypeId}"] = {};
        // distributePosmMap[posmModel.outlet.id.toString()]["${posmModel.brandId}"]={};
        distributePosmMap[posmModel.outlet.id.toString()]["${posmModel.brandId}"]['${posmModel.posmTypeId}'] = getMap(posmModel: posmModel);
      }

      syncObj["distribute_posm"] = distributePosmMap;

      bool result = await SyncService().writeSync(jsonEncode(syncObj));
      return result;
    } catch (e, t) {
      log('error-> ${e.toString()}');
      log('error-> ${t.toString()}');
      return false;
    }
  }

  Future<List> havePosmData({OutletModel? retailer}) async {
    List posmMap = [];

    try {
      await _syncService.checkSyncVariable();

      SrInfoModel srInfo = await _syncReadService.getSrInfo();

      String salesDate = await _syncReadService.getSalesDate();

      Map distributePosmMap = {};

      if (syncObj.containsKey("distribute_posm")) {
        Map map = syncObj["distribute_posm"];
        if (map.containsKey(retailer?.id.toString())) {
          print('------->>> ${map[retailer?.id.toString()]}');
          distributePosmMap = map[retailer?.id.toString()];
          List<String> brandIds = [];
          brandIds = distributePosmMap.keys.toList().cast<String>();

          for (var v in brandIds) {
            if (distributePosmMap.containsKey(v)) {

              List<String> posmIds = [];
              posmIds = distributePosmMap[v].keys.toList().cast<String>();

              for(var posmId in posmIds){
                Map posmData = distributePosmMap[v][posmId];
                Map m = {
                  "sbu_id": 1,
                  "dep_id": srInfo.depId,
                  "section_id": srInfo.sectionId,
                  "ff_id": srInfo.ffId,
                  "outlet_id": retailer?.id,
                  "outlet_code": retailer?.outletCode,
                  "date": salesDate,
                  "classification_id": posmData["posm_id"],
                  "amount": posmData["quantity"],
                  "image": posmData["posmImageName"],
                  "posm_type": posmData["posmTypeId"],
                  "posm_config_id": posmData["posmConfigId"],
                };
                posmMap.add(m);
              }


            }
          }
        }
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return posmMap;
  }

  Future<List> haveAllPosmData() async {
    List posmMap = [];

    try {
      await _syncService.checkSyncVariable();

      SrInfoModel srInfo = await _syncReadService.getSrInfo();

      String salesDate = await _syncReadService.getSalesDate();

      Map<String, dynamic> distributePosmMap = {};

      if (syncObj.containsKey("distribute_posm")) {
        Map<String, dynamic> map = syncObj["distribute_posm"];
        List<String> retailerIds = [];
        retailerIds = map.keys.toList().cast<String>();
        for (var v in retailerIds) {
          if (map.containsKey(v.toString())) {
            distributePosmMap = map[v];
            List<String> brandsIds = [];
            brandsIds = distributePosmMap.keys.toList();

            for (var v in brandsIds) {
              if (distributePosmMap.containsKey("$v")) {

                List<String> posmIds = [];
                posmIds = distributePosmMap[v].keys.toList().cast<String>();

                for(var posmId in posmIds){
                  Map posmData = distributePosmMap[v][posmId];

                  Map m = {
                    "sbu_id": 1,
                    "dep_id": srInfo.depId,
                    "section_id": srInfo.sectionId,
                    "ff_id": srInfo.ffId,
                    "outlet_id": posmData["outlet_id"],
                    "outlet_code": posmData["outlet_code"],
                    "date": salesDate,
                    "classification_id": posmData["posm_id"],
                    "amount": posmData["quantity"],
                    "image": posmData["posmImageName"],
                    "posm_type": posmData["posmTypeId"],
                    "posm_config_id": posmData["posmConfigId"],
                  };
                  posmMap.add(m);
                }
              }
            }
          }
        }
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return posmMap;
  }

  Map getMap({required AddedPosmModel posmModel}) {
    Map map = {};
    try{
      map = {
        "outlet_id": posmModel.outlet.id,
        "outlet_code": posmModel.outlet.outletCode,
        "posm_id": posmModel.brandId,
        "quantity": posmModel.quantity.toString(),
        "posmImageName": posmModel.imageName,
        "posmImagePath": posmModel.imagePath,
        "posmTypeId": posmModel.posmTypeId,
        "posmConfigId": posmModel.posmConfigId,
      };
    } catch(e,t){
      print(e.toString());
      print(t.toString());
    }
    return map;
  }
}
