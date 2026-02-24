import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:wings_olympic_sr/models/sales/sku_classification.dart';
import 'package:wings_olympic_sr/services/sync_service.dart';

import '../constants/constant_keys.dart';
import '../constants/sync_global.dart';
import '../models/AvModel.dart';
import '../models/location_category_models.dart';
import '../models/module.dart';
import '../models/outlet_model.dart';
import '../models/preorder_stock_model.dart';
import '../models/products_details_model.dart';
import '../models/sr_info_model.dart';
import 'helper.dart';


class SyncReadService {
  static final SyncReadService _syncReadService = SyncReadService._internal();

  factory SyncReadService() {
    return _syncReadService;
  }
  SyncReadService._internal();

  final SyncService _syncService = SyncService();

  getAssetVersion(String slug) {
    if (syncObj.containsKey('finalAssets')) {
      if (syncObj['finalAssets'].containsKey(slug)) {
        return syncObj['finalAssets'][slug]['version'];
      }
    }
  }
//===============Sales Date ===========
  Future<String> getSalesDate() async {
    await _syncService.checkSyncVariable();
    return syncObj['date'];
  }
  //===============SR info=============
  Future<SrInfoModel> getSrInfo() async {
    await _syncService.checkSyncVariable();
    return SrInfoModel.fromJson(syncObj["userData"]);
  }
  /// ========================== dashboard buttons =====================
  Future<bool>checkButtonAvailability(String slug)async{
    bool exist = false;
    try{
      await _syncService.checkSyncVariable();
      if(syncObj.containsKey("dashboard_button")){
        if(syncObj["dashboard_button"].containsKey(slug)){
          exist = syncObj["dashboard_button"][slug] == 1;
        }
      }
      else {
        exist = true;
      }
    }
    catch(e,s){
      Helper.dPrint("inside SyncReadService checkButtonAvailability error $e $s");
    }
    return exist;
  }

  ///============================== Stocks =====================================

  Future<String> getSkuSlug(String moduleId) async {
    await _syncService.checkSyncVariable();
    String slugName = '';

    syncObj['modules'][moduleId.toString()]['product_category'].forEach((key, value) {
      if (value['is_sku'] == 1) {
        slugName = value['slug'];
        return;
      }
    });
    return slugName;
  }



  Future<Module> getModuleById(String moduleId) async {
    await _syncService.checkSyncVariable();

    Module module = Module.fromJson(syncObj['modules'][moduleId]);
    return module;
  }

  Future<String>getModuleNameById(String moduleId)async{
    await _syncService.checkSyncVariable();
    return syncObj["modules"][moduleId]["name"];
  }


  ///module list for Tabbar
  Future<List<Module>> getModuleModelList() async {
    List<Module> modules = [];
    try {
      Map m = await getModuleList();
      if (m.isNotEmpty) {
        m.forEach((key, value) {
          modules.add(Module.fromJson(value));
        });
      }
    } catch (e) {
      Helper.dPrint("inside getModuleModelList syncReadServices catch block $e");
    }

    return modules;
  }

  Future<bool> checkRetailerHasSku(List skuIdList, int retailerId)async{
    bool success = false;
    try{

      await _syncService.checkSyncVariable();
      if(syncObj.containsKey(preorderKey)){
        if(syncObj[preorderKey].containsKey(retailerId.toString())){
          syncObj[preorderKey][retailerId.toString()].forEach((moduleId, skus){
            skus.forEach((skuId, skuModel){
              if(skuIdList.contains(int.tryParse(skuId))){
                success = true;
                return ;
              }
            });
          });
        }
      }
    }
    catch(e,s){
      Helper.dPrint("inside SyncReadService checkRetailerHasSku error $e, $s");
    }
    return success;
  }


  ///========================= Dashboard ================================

  /// get primary unit name
  Future<String> getModulePrimaryUnitName(int moduleId)async{
    String res = "";
    try {
      await _syncService.checkSyncVariable();

      if(syncObj["modules"].containsKey(moduleId.toString())){
        syncObj["modules"][moduleId.toString()]["units"].forEach((key, val){
          if(val["is_primary"] == 1){
            res = val["name"];
            return;
          }
        });
      }
    }catch(e){
      Helper.dPrint("Inside getModulePrimaryName function catch block $e");
    }
    return res;
  }
  /// which buttons should be on/off on Dashboard
  Future<Map> getDashboardButtons() async {
    Map buttons = {};
    try {
      await _syncService.checkSyncVariable();
      buttons.addAll(syncObj['dashboard_buttons']);
    } catch (e) {
      Helper.dPrint("Inside getDashboardButtons in SyncReadService catch block");
    }
    return buttons;
  }

  /// Get all MODULES list for  dashboard containers
  Future<Map> getModuleList() async {
    Map modules = {};
    try {
      await _syncService.checkSyncVariable();
      modules.addAll(syncObj['modules']);
    } catch (e) {
      Helper.dPrint("Inside getModuleList in SyncReadService catch block");
    }
    return modules;
  }
  Future<OutletModel?> getRetailerModelFromId(String retailerId) async {
    try {
      await _syncService.checkSyncVariable();
      for (var i in syncObj['retailers']) {
        if (i['id'].toString() == retailerId) {
          return OutletModel.fromJson(i);
        }
      }
    } catch (e, s) {
      Helper.dPrint("Inside getRetailerModelFromId in SyncReadService catch block $e");
      Helper.dPrint("Inside getRetailerModelFromId in SyncReadService catch block $s");
    }
    return null;
  }

  Future<Map> getRetailerModelList([bool isMemoPage = false]) async {
    List<OutletModel> retailer = [];
    List<OutletModel> retailerWithSales = [];
    Set<String> alphabet = {};
    List<String> alphabetList = [];
    try {
      await _syncService.checkSyncVariable();
      for (var i in syncObj['retailers']) {
        OutletModel retailerModel = OutletModel.fromJson(i);
        retailer.add(retailerModel);

        alphabet.add(i['outlet_name'].trim()[0]);
      }
      if(isMemoPage){
        retailer.insertAll(0, retailerWithSales);
      }
      else{
        retailer.addAll(retailerWithSales);
      }

      alphabetList.addAll(alphabet);
      if (alphabetList.isNotEmpty) {
        alphabetList.sort((a, b) => a.compareTo(b));
      }
    } catch (e, s) {
      Helper.dPrint("Inside getRetailerList in SyncReadService catch block $s");
    }

    return {'retailer': retailer, 'alphabet': alphabetList};
  }
  Future<bool> checkIfSaleEditable()async{
    try{
      await _syncService.checkSyncVariable();
      if(syncObj.containsKey("sales_configurations")){
        if(syncObj["sales_configurations"].containsKey("sale_edit_enable")){
          return syncObj["sales_configurations"]["sale_edit_enable"] == 1;
        }
      }
    }
    catch(e,s){
      Helper.dPrint("inside getModulesAvailableForPreorder checkIfSaleEditable catch block $e $s");
      return false;
    }
    return true;
  }

  ///========================== tutorials =======================
  Future<List<AvModel>> getVideoList() async {
    try {
      await _syncService.checkSyncVariable();
      List<AvModel> list = [];
      for (var v in syncObj['tutorial']) {
        AvModel videoModel = AvModel.fromJson(v);
        list.add(videoModel);
      }
      return list;
    } catch (e) {
      Helper.dPrint("Inside getVideoList in SyncReadService catch block $e");
      return [];
    }
  }



  int getModuleIndex(int moduleId) {
    int index = 0;
    try {
      if (syncObj.containsKey("modules")) {
        List moduleIdList = syncObj["modules"].keys.toList();
        index = moduleIdList.indexOf(moduleId.toString());
      }
    } catch (e) {
      Helper.dPrint("inside getModuleIndex syncReadService catch block $e");
    }
    return index;
  }

  Future<bool> checkAlreadyWelcomed() async {
    bool welcomed = true;
    try {
      await _syncService.checkSyncVariable();
        welcomed = syncObj["welcomed"] ?? false;
        log("welcomed ::::: ${syncObj["welcomed"]} : $welcomed");

    } catch (e) {
      Helper.dPrint("inside checkIfZeroSaleEnabled DeliveryServices catch block $e");
    }
    return true;
  }

  Future updateWelcomeStatus() async {
    try {
      await _syncService.checkSyncVariable();


      syncObj["welcomed"] = true;
      await SyncService().writeSync(jsonEncode(syncObj));

      await _syncService.checkSyncVariable();

      log("new sync file :::::::");
      SyncService().printSync();
    } catch (e) {
      Helper.dPrint("inside checkIfZeroSaleEnabled DeliveryServices catch block $e");
    }
  }


  Future<Map> getRetailerModelListBySection({bool isMemoPage = false, required SectionModel? section}) async {
    List<OutletModel> retailer = [];
    List<OutletModel> retailerWithSales = [];
    Set<String> alphabet = {};
    List<String> alphabetList = [];
    try {
      await _syncService.checkSyncVariable();

      /// for test memo retailer (test retailer)
      if(!isMemoPage){
        if(syncObj.containsKey("test_memo")){
          if(syncObj["test_memo"].containsKey("enable")){
            if(syncObj["test_memo"]["enable"] == 1){
              if(syncObj["test_memo"].containsKey("retailer")){
                try{
                  OutletModel retailerModel = OutletModel.fromJson(syncObj["test_memo"]["retailer"]);
                  retailer.add(retailerModel);
                }catch(error, stck){
                  Helper.dPrint(error.toString());
                  Helper.dPrint(stck.toString());
                }
              }
            }
          }
        }
      }

      /// retailer list related work
      ///
      log('total retailer on sync file is: ${syncObj['retailers'].length}');
      for (var i in syncObj['retailers']) {
        OutletModel retailerModel = OutletModel.fromJson(i);

        /// minus one (-1) indicates this retailer has no sale
        if(retailerModel.totalSale == -1){

          /// Here we are ignoring the retailer if its has no sale at all
          /// because we do not need retailers here which has no sale
          if(isMemoPage) {
            continue;
          }

          // if(retailerModel.sectionId.contains(section?.id)){
          if(retailerModel.sectionId == (section?.id)){
            retailer.add(retailerModel);
            alphabet.add(i['outlet_name'].trim()[0]);
          } else if (section == null) {
            retailer.add(retailerModel);
            alphabet.add(i['outlet_name'].trim()[0]);
          }
        }
        else {
          log('match the section :::: ${section?.id} :: ${retailerModel.sectionId}');
          if(section==null) {
            retailerWithSales.add(OutletModel.fromJson(i));
            alphabet.add(i['outlet_name'].trim()[0]);
          } else {
            // if(retailerModel.sectionId.contains(section?.id)){
            if(retailerModel.sectionId == (section.id)){
              retailerWithSales.add(OutletModel.fromJson(i));
              alphabet.add(i['outlet_name'].trim()[0]);
            }
          }
        }
      }
      if(isMemoPage){
        retailer.insertAll(0, retailerWithSales);
      }
      else{
        retailer.addAll(retailerWithSales);
      }

      alphabetList.addAll(alphabet);
      if (alphabetList.isNotEmpty) {
        alphabetList.sort((a, b) => a.compareTo(b));
      }
    } catch (e, s) {
      Helper.dPrint("Inside getRetailerList in SyncReadService catch block $e $s");
    }

    log('total retailer count for selected rout is: ${retailer.length}');

    return {'retailer': retailer, 'alphabet': alphabetList};
  }

  Future<String> getIncreasedId(String moduleId) async {
    await _syncService.checkSyncVariable();
    String increasedId = '';
    syncObj['modules'][moduleId]['units'].forEach((key, value) {
      if (value['is_primary'] == 1) {
        increasedId = value['increase_id'].toString();
        return;
      }
    });
    // if(increasedId.isEmpty && syncObj['modules'][moduleId]['units'].isNotEmpty) {
    //   syncObj['modules'][moduleId]['units'].forEach((key, value) {
    //       increasedId = value['increase_id'].toString();
    //       return;
    //
    //   });
    // }
    // log('increasedId===> $increasedId');
    return increasedId;
  }

  String getIncreasedIdSync(String moduleId) {
    String increasedId = '';
    syncObj['modules'][moduleId]['units'].forEach((key, value) {
      if (value['is_primary'] == 1) {
        increasedId = value['increase_id'].toString();
        return;
      }
    });
    // if(increasedId.isEmpty && syncObj['modules'][moduleId]['units'].isNotEmpty) {
    //   syncObj['modules'][moduleId]['units'].forEach((key, value) {
    //       increasedId = value['increase_id'].toString();
    //       return;
    //
    //   });
    // }
    // log('increasedId===> $increasedId');
    return increasedId;
  }

  List<SkuClassification> getSkuClassifications () {
    try {
      final jsonList = (syncObj['product_classification_types'] as List?) ?? [];
      return jsonList.map((json) => SkuClassification.fromJson(json)).toList();
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }
    return [];
  }


  int getIdealStockFromSync(Module module, ProductDetailsModel sku) {
    int idealStock = 0;
    try {
      idealStock = syncObj["stock"]?[module.name]?[sku.id.toString()]?["ideal_stock"]??0;
    } catch (e,t) {
      log(e.toString());
      log(t.toString());
    }
    return idealStock;
  }



  void setStock(ProductDetailsModel productDetailsModel, String moduleSlug) {
    StockModel stockModel = StockModel.fromJson(syncObj['stock'][moduleSlug][productDetailsModel.id.toString()]);
    productDetailsModel.setStocks(stockModel);
  }

  void setPreorderStock(ProductDetailsModel productDetailsModel, String moduleSlug) {
    int stt = 0;
    if(syncObj.containsKey('preorder-data')) {
      Map preorderData = syncObj['preorder-data'];
      preorderData.forEach((outletId, preorder) {
        preorder.forEach((moduleId, saleData) {
          if(saleData.containsKey(productDetailsModel.id.toString())) {
            stt += (saleData[productDetailsModel.id.toString()]['stt'] as num).toInt();
          }
        });
      });
    }

    if(syncObj.containsKey('max_order_limit_config')) {
      if(syncObj['max_order_limit_config'].containsKey(productDetailsModel.id.toString())) {
        final stockModel = PreorderStockModel.fromJson(syncObj['max_order_limit_config'][productDetailsModel.id.toString()], stt);
        productDetailsModel.setPreorderStocks(stockModel);
      } else {
        final stockModel = PreorderStockModel.fromJson({}, stt);
        productDetailsModel.setPreorderStocks(stockModel);
      }
    }
  }
}
