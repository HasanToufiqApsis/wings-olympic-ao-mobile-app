import '../constants/sync_global.dart';
import '../models/brand/brand_model.dart';
import '../models/general_id_slug_model.dart';
import '../models/retailers_mdoel.dart';
import 'sync_read_service.dart';
import 'sync_service.dart';

class AssetManagementService {
  final SyncReadService _syncReadService = SyncReadService();
  final SyncService _syncService = SyncService();

  Future<List<GeneralIdSlugModel>> getAssetTypeList() async {
    List<GeneralIdSlugModel> assetTypeList = [];
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("asset_type")) {
        for (Map assetMap in syncObj["asset_type"]) {
          assetTypeList.add(GeneralIdSlugModel.fromJson(assetMap));
        }
      }
    } catch (e, s) {
      print("inside AssetService getAssetTypeList $e $s");
    }
    return assetTypeList;
  }

  Future<List<String>> getCoolerPullOutReasonList() async {
    List<String> assetTypeList = [];
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("pull_out_reasons")) {
        for (String assetMap in syncObj["pull_out_reasons"]) {
          assetTypeList.add(assetMap);
        }
      }
    } catch (e, s) {
      print("inside AssetService getAssetTypeList $e $s");
    }
    return assetTypeList;
  }

  Future<List<GeneralIdSlugModel>> getAssetCoolerTypeList() async {
    List<GeneralIdSlugModel> assetTypeList = [];
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("cooler_type")) {
        for (Map assetMap in syncObj["cooler_type"]) {
          assetTypeList.add(GeneralIdSlugModel.fromJson(assetMap));
        }
      }
    } catch (e, s) {
      print("inside AssetService getAssetCoolerTypeList $e $s");
    }
    return assetTypeList;
  }

  Future<List<RetailersModel>> getSoRetailerListProvider() async {
    List<RetailersModel> assetTypeList = [];
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("retailers")) {
        for (Map<String, dynamic> assetMap in syncObj["retailers"]) {
          assetTypeList.add(RetailersModel.fromJson(assetMap));
        }
      }
    } catch (e, s) {
      print("inside AssetService getAssetCoolerTypeList $e $s");
    }
    print('retailer list length is:: ${assetTypeList.length}');
    return assetTypeList;
  }

  Future<List<RetailersModel>>getTSMRetailerListProvider({required List<int> outletIds})async{
    List<RetailersModel> assetTypeList = [];
    try{
      await _syncService.checkSyncVariable();
      if(syncObj.containsKey("retailers")){
        for(Map<String, dynamic> assetMap in syncObj["retailers"]){
          RetailersModel retailersModel=  RetailersModel.fromJson(assetMap);
          if(outletIds.contains(retailersModel.id)) {
            assetTypeList.add(RetailersModel.fromJson(assetMap));
          }
        }
      }
    }
    catch(e,s){
      print("inside AssetService getAssetCoolerTypeList $e $s");
    }
    print('retailer list length is:: ${assetTypeList.length}');
    return assetTypeList;
  }

  Future<List<GeneralIdSlugModel>> getAssetLightBoxTypeList() async {
    List<GeneralIdSlugModel> assetTypeList = [];
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("light_box_type")) {
        for (Map assetMap in syncObj["light_box_type"]) {
          assetTypeList.add(GeneralIdSlugModel.fromJson(assetMap));
        }
      }
    } catch (e, s) {
      print("inside AssetService getAssetCoolerTypeList $e $s");
    }
    return assetTypeList;
  }

  Future<List<String>> getLightBoxBillCategory() async {
    List<String> lightBoxBillType = [];
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("light_box_type")) {
        lightBoxBillType = ["Product", "Cash"];
      }
    } catch (e, s) {
      print("inside AssetService getAssetCoolerTypeList $e $s");
    }
    return lightBoxBillType;
  }
}
