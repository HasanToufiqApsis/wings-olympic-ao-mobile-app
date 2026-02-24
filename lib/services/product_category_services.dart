import 'dart:developer';

import 'package:flutter/material.dart';

import '../constants/constant_keys.dart';
import '../constants/enum.dart';
import '../constants/sync_global.dart';
import '../models/general_id_slug_model.dart';
import '../models/module.dart';
import '../models/outlet_model.dart';
import '../models/product_category_model.dart';
import '../models/product_model.dart';
import '../models/products_details_model.dart';
import '../models/sales/sale_data_model.dart';
import '../screens/aws_stock/model/aws_product_model.dart';
import 'helper.dart';
import 'module_services.dart';
import 'pre_order_service.dart';
import 'sync_read_service.dart';
import 'sync_service.dart';

class ProductCategoryServices {
  final SyncService _syncService = SyncService();
  final SyncReadService _syncReadService = SyncReadService();
  final ModuleServices _moduleServices = ModuleServices();


  //=====================================================================//
  //===================== NEW CATEGORY CODE =============================//
  Future<ProductCategoryModel?> getCategoryModelOfSkuForAModule(int moduleId) async {
    ProductCategoryModel? skuCategory;
    try {
      await _syncService.checkSyncVariable();
      if (syncObj["modules"].containsKey(moduleId.toString())) {
        if (syncObj["modules"][moduleId.toString()].containsKey("product_category")) {
          for (var key in syncObj["modules"][moduleId.toString()]["product_category"].keys) {
            var value = syncObj["modules"][moduleId.toString()]["product_category"][key];
            if (value['is_sku'] == 1) {
              skuCategory = ProductCategoryModel.fromJson(value);
            }
          }
        }
      }
    } catch (e) {
      print("inside getCategoryModelOfSkuForAModule productCategoryServices catch block $e");
    }
    return skuCategory;
  }

  Future<Map<String, List<ProductDetailsModel>>> getProductDetailsGroupByClassification(Module module) async {
    await _syncService.checkSyncVariable();
    final allProductList = await getProductDetailsList(module, type: PreorderCategoryFilterButtonType.all);
    // final classifications = _syncReadService.getSkuClassifications();

    final result = {
      'All': allProductList,
    };

    for (var p in allProductList) {
      final classification = p.filterType;
      result.putIfAbsent(classification, () => []);
      result[classification]!.add(p);
    }

    return result;
  }

  Future<List<ProductDetailsModel>> getAllProductDetailsList() async {
    List<ProductDetailsModel> productList = [];
    final moduleList = await _syncReadService.getModuleModelList();
    for(Module module in moduleList) {
      productList.addAll(await getProductDetailsList(module));
    }
    return productList;
  }

  List<SkuUnitItem> getSkuUnitConfigBySkuId({required String skuId}) {
    List<SkuUnitItem> skuUnitConfig = [];
    try {
      if(syncObj.containsKey('sku_unit_config')) {
        if (syncObj['sku_unit_config'].containsKey(skuId)) {
          List l = syncObj['sku_unit_config'][skuId];
          skuUnitConfig = l.map((e) => SkuUnitItem.fromJson(e)).toList();
        }
        skuUnitConfig.sort((a, b) {
          final aSize = a.packSize ?? 0;
          final bSize = b.packSize ?? 0;
          return aSize.compareTo(bSize);
        });
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return skuUnitConfig;
  }

  // List<SkuUnitItem> getSkuUnitConfigBySkuId({required String skuId}) {
  //   List<SkuUnitItem> skuUnitConfig = [];
  //
  //   try {
  //     if (syncObj.containsKey('sku_unit_config')) {
  //       print("------------->>><>>> $skuId ${syncObj['sku_unit_config']}");
  //
  //       final skuMap = syncObj['sku_unit_config'];
  //
  //       if (skuMap is Map && skuMap.containsKey(skuId)) {
  //         List l = skuMap[skuId];
  //         skuUnitConfig = l.map((e) => SkuUnitItem.fromJson(e)).toList();
  //       }
  //     }
  //   } catch (e, t) {
  //     debugPrint(e.toString());
  //     debugPrint(t.toString());
  //   }
  //
  //   return skuUnitConfig;
  // }

  Future<List<ProductDetailsModel>> getProductDetailsList(Module module,{PreorderCategoryFilterButtonType type = PreorderCategoryFilterButtonType.all}) async {
    await _syncService.checkSyncVariable();
    List<ProductDetailsModel> productList = [];
    try {
      if (syncObj["cats"].containsKey(module.id.toString())) {
        ProductCategoryModel? skuCategory = await getCategoryModelOfSkuForAModule(module.id);
        String increaseId = await _syncReadService.getIncreasedId(module.id.toString());
        if (skuCategory != null) {
          if (syncObj["cats"][module.id.toString()].containsKey(skuCategory.id.toString())) {
            Map skuMap = syncObj["cats"][module.id.toString()][skuCategory.id.toString()];
            if (skuMap.isNotEmpty) {
              for (String skuId in skuMap.keys) {
                // get sku unit configuration
                final skuUnitConfig = getSkuUnitConfigBySkuId(skuId: skuId);
                Map skuDetails = skuMap[skuId];
                bool available = checkIfSkuAvailableForFilter(skuDetails,type);
                if(available){
                  ProductDetailsModel sku = ProductDetailsModel.fromJson(skuDetails, skuCategory.slug, increaseId, unitConfiguration: skuUnitConfig);
                  _syncReadService.setStock(sku, module.slug);
                  _syncReadService.setPreorderStock(sku, module.slug);
                  sku.setModule(module);
                  productList.add(sku);
                }
              }
            }
          }
        }
      }
      if (productList.isNotEmpty) {
        productList.sort((a, b) => a.sort.compareTo(b.sort));
      }
    } catch (e, s) {
      print("inside getProductDetailsList ProductCategoryServices catch block $e $s");
    }
    return productList;
  }

  bool checkIfSkuAvailableForFilter(Map skuDetails, PreorderCategoryFilterButtonType type){
    bool available = true;
    try{
      if(type==PreorderCategoryFilterButtonType.all){
        available = true;

      }else{
        available = type.name.toString().toUpperCase()==skuDetails["filter_type"];
      }


    }catch(e){
      Helper.dPrint("inside checkIfSkuAvailableForFilter ProductCategoryServices catch block $e");
    }

    return available;
  }

  Future<double> getDeliveryDetailsPrice(OutletModel outlet)async{
    double price = 0.0;
    try {

      List<Module> moduleList = await _syncReadService.getModuleModelList();
      for(Module module in moduleList){
        List<ProductDetailsModel> skuList = await getProductDetailsList(module);

        Map<String, dynamic> preorderData =  await PreOrderService().getPreOrderPerRetailer(outlet.id??0, module.id);

        for(ProductDetailsModel sku in skuList){
          // double skuPrice = sku.preorderData?.price??0.0;

          if(preorderData.containsKey(sku.id.toString())){
            SaleDataModel saleDataModel = SaleDataModel();
            await saleDataModel.saveQty(
                retailer: outlet, sku: sku, quantity: preorderData[sku.id.toString()]);
            sku.savePreorderData(saleDataModel);
            price = price + (sku.preorderData != null?sku.preorderData!.price : 0.0);
          }

        }

      }

    }catch(e,s){
      print("Inside ProductCategoryServices getDeliveryDetailsPrice $e $s");
    }
    return price;
  }

  Future<Map<String, List<ProductDetailsModel>>> getProductDetailsGroupByClassificationForDelivery(Module module, OutletModel retailer) async {
    await _syncService.checkSyncVariable();
    final allProductList = await getDeliveryDetailsList(module, retailer);
    // final classifications = _syncReadService.getSkuClassifications();

    final result = {
      'All': allProductList,
    };

    for (var p in allProductList) {
      final classification = p.filterType;
      result.putIfAbsent(classification, () => []);
      result[classification]!.add(p);
    }

    return result;
  }

  //delivery list
  Future<List<ProductDetailsModel>> getDeliveryDetailsList(Module module, OutletModel outlet)async{
    await _syncService.checkSyncVariable();
    List<ProductDetailsModel> list = [];
    try{
      List<ProductDetailsModel> productWithoutPreorder = [];
      List<ProductDetailsModel> productWithPreorder = [];
      Map<String, dynamic> preorderData =  await PreOrderService().getPreOrderPerRetailer(outlet.id??0, module.id);
      print(preorderData);
      List<ProductDetailsModel> allProduct = await getProductDetailsList(module);
      if(allProduct.isNotEmpty){
        for(ProductDetailsModel sku in allProduct){
          if(preorderData.containsKey(sku.id.toString())){
            productWithPreorder.add(sku);
          }else{
            productWithoutPreorder.add(sku);
          }
        }
        list = [...productWithPreorder,...productWithoutPreorder];
      }
    }catch(e){
      print("inside getDeliveryDetailsList ProductCategoryServices catch block $e");
    }
    return list;
  }

  //get module model from module slug
  Future<Module?> getModuleModelFromModuleSlug(String slug) async {
    Module? module;
    try {
      await _syncService.checkSyncVariable();
      if (syncObj["modules"].isNotEmpty) {
        Map modules = syncObj["modules"];
        for (var moduleId in modules.keys) {
          print("--------->>>> >> ${moduleId}");
          var moduleInfo = modules[moduleId];
          if (moduleInfo.containsKey("slug")) {
            if (moduleInfo["slug"] == slug) {
              module = Module.fromJson(moduleInfo);
              break;
            }
          }
        }
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return module;
  }

  Future<List<GeneralIdSlugModel>> getProductCategoryModelList(int moduleId)async{
    List<GeneralIdSlugModel> list = [];
    try{
      await _syncService.checkSyncVariable();
      if(syncObj.containsKey("modules")){
        if(syncObj["modules"].containsKey(moduleId.toString())){
          if(syncObj["modules"][moduleId.toString()].containsKey("units")){
            for(MapEntry unitEntry in syncObj["modules"][moduleId.toString()]["units"].entries){
              Map unitMap = unitEntry.value;
              list.add(GeneralIdSlugModel.fromJson(unitMap));
            }
          }
        }
      }
    }
    catch(e,s){
      print("inside gtProductCategoryModelList ProductCategoryServices catch block $e $s");
    }
    return list;
  }
  
  Future<int?> getSkuPackSizeByModuleBySkuId(int moduleId, int skuId)async{
    try{
      await _syncService.checkSyncVariable();
      if(syncObj.containsKey("cats")){
        if(syncObj["cats"].containsKey(moduleId.toString())){
          if(syncObj["cats"][moduleId.toString()].containsKey("10")){
            if(syncObj["cats"][moduleId.toString()]["10"].containsKey(skuId.toString())){
              if(syncObj["cats"][moduleId.toString()]["10"][skuId.toString()].containsKey("pack_size_value")){
                return syncObj["cats"][moduleId.toString()]["10"][skuId.toString()]["pack_size_value"];
              }
            }
          }
        }
      }
    }
    catch(e,s){
      print("inside product category service getSkuPackSizeByModuleBySkuId $e $s");
    }
    return null;
  }

  Future<String> getProductCategoryPrimaryIncreaseId(int moduleId)async{
    try{
      await _syncService.checkSyncVariable();
      if(syncObj.containsKey("modules")){
        if(syncObj["modules"].containsKey(moduleId.toString())){
          if(syncObj["modules"][moduleId.toString()].containsKey("units")){
            for(MapEntry unitEntry in syncObj["modules"][moduleId.toString()]["units"].entries){
              Map unitMap = unitEntry.value;
              String unitId = unitEntry.key.toString();
              if(unitMap.containsKey("is_primary")){
                if(unitMap["is_primary"] == 0){
                  return unitId;
                }
              }
            }
          }
        }
      }
    }
    catch(e,s){
      print("inside gtProductCategoryModelList ProductCategoryServices catch block $e $s");
    }
    return "";
  }

  //get module model from module slug
  Future<Module?> getModuleModelFromModuleId(int id) async {
    Module? module;
    try {
      await _syncService.checkSyncVariable();
      if (syncObj["modules"].isNotEmpty) {
        Map modules = syncObj["modules"];
        for (var moduleId in modules.keys) {
          var moduleInfo = modules[moduleId];
          if (moduleId == id.toString()) {
            module = Module.fromJson(moduleInfo);
            break;
          }
        }
      }
    } catch (e) {
      print("inside getModuleModuleFromModuleSlug ProductCategoryServices catch block $e");
    }
    return module;
  }

  //============== get Module from sku ===========
  Future<Module?> getModuleModelFromSkuId(int skuId) async {
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("modules")) {
        if (syncObj["modules"].isNotEmpty) {
          Map modules = syncObj["modules"];
          Module? module;
          for (var moduleId in modules.keys) {
            var moduleInfo = modules[moduleId];
            if (syncObj["cats"].containsKey(moduleId)) {
              ProductCategoryModel? skuCategory = await getCategoryModelOfSkuForAModule(int.parse(moduleId));
              if (skuCategory != null) {
                if (syncObj["cats"][moduleId][skuCategory.id.toString()].containsKey(skuId.toString())) {
                  module = Module.fromJson(moduleInfo);
                  break;
                }
              }
            }
          }

          return module;
        }
      }
    } catch (e) {
      print("inside getModuleModelFromSkuId syncReadServices catch block $e");
    }
  }

  // get module list from sku list
  Future<List<Module>> getModuleModelListFromSkuList(List skuids) async {
    List<Module> modules = [];
    try {

      if (skuids.isNotEmpty) {
        int skuId = skuids[0]["sku_id"];
        Module? module = await getModuleModelFromSkuId(skuId);
        if (module != null) {
          modules.add(module);
        }
      }
    } catch (e,s) {
      print("inside getModuleModelListFromSkuList syncReadServices catch block $e $s");
    }
    return modules;
  }

//=============================== CALCULATE LEVEL WISE MEMO START ==========================//
  Future<ProductCategoryModel?> getProductCategoryModelForACertainLevelAndModule(int moduleId, int level) async {
    ProductCategoryModel? category;
    try {
      ProductCategoryModel? skuCategory = await getCategoryModelOfSkuForAModule(moduleId);
      if(level == 0){
        return skuCategory;
      }
      if (skuCategory != null) {
        Map categoryMap = {};
        int parentId = skuCategory.parentId;
        for (int i = 0; i < level; i++) {
          if (parentId != 0 && syncObj["modules"][moduleId.toString()]["product_category"].containsKey(parentId.toString())) {
            categoryMap = syncObj["modules"][moduleId.toString()]["product_category"][parentId.toString()];
            parentId = categoryMap["parent_id"];
          } else {
            break;
          }
        }
        if (categoryMap.isNotEmpty) {
          category = ProductCategoryModel.fromJson(categoryMap);
        }
      }
    } catch (e) {
      print("inside getProductCategoryModelForACertainLevelAndModule productCategoryServices catch block $e");
    }
    return category;
  }

  Future<ProductCategoryWithAvailableIds?> getCategoryDetailsForASpecificModuleAndLevel(int moduleId, int level) async {
    ProductCategoryWithAvailableIds? categoryDetails;
    try {
      ProductCategoryModel? category = await getProductCategoryModelForACertainLevelAndModule(moduleId, level);
      if (category != null) {
        if (syncObj["cats"][moduleId.toString()].containsKey(category.id.toString())) {
          List availableIds = syncObj["cats"][moduleId.toString()][category.id.toString()].keys.toList();
          categoryDetails = ProductCategoryWithAvailableIds(category, availableIds);
        }
      }
    } catch (e) {
      print("inside getCategoryDetailsForASpecificModuleAndLevel ProductCategoryServices catch block $e");
    }
    return categoryDetails;
  }

  Future<List<int>> getSkuIdListForASpecificProductCategoryAndId(int productCategoryId, int parentId, int moduleId, ProductCategoryModel skuCategory) async {
    List<int> skuIds = [];
    try {
      Map skuMap = syncObj["cats"][moduleId.toString()][skuCategory.id.toString()];
      if (skuMap.isNotEmpty) {
        skuMap.forEach((skuId, skuDetails) {
          if (skuDetails["parents"].containsKey(productCategoryId.toString())) {
            if (skuDetails["parents"][productCategoryId.toString()] == parentId) {
              skuIds.add(int.parse(skuId.toString()));
            }
          }
        });
      }
    } catch (e) {
      print("inside getSkuIdListForASpecificProductCategoryAndId ProductCategoryServices catch block $e");
    }
    return skuIds;
  }

//==========================================================================================//




  Future<int?> getDigontoSBUId()async{
    int? id;
    try{
      await _syncService.checkSyncVariable();
      if(syncObj["modules"].isNotEmpty){
        for(MapEntry module in syncObj["modules"].entries){
          if(module.value.containsKey("slug")){
            if(module.value["slug"]=="Digonto"){
              id= module.value["id"];
              break;
            }
          }
        }
      }
    }catch(e){
      print("inside getDigontoSBUId productCategoryServices catch block $e");
    }
    return id;
  }


  //================== FOR SR Target Achievement ==========================
  Future<int?> getProductIdForASkuAndModuleAndProductCategory(int moduleId, int skuId, int productCategoryId)async{
    int? productId;
    try{
      await _syncService.checkSyncVariable();
      ProductCategoryModel? skuCategory = await getCategoryModelOfSkuForAModule(moduleId);
      if(skuCategory !=null){
        if(skuCategory.id==productCategoryId){
          productId = skuId;
        }else{
          if(syncObj.containsKey("cats")){
            if(syncObj["cats"].containsKey(moduleId.toString())){
              if(syncObj["cats"][moduleId.toString()].containsKey(skuCategory.id.toString())){
                if(syncObj["cats"][moduleId.toString()][skuCategory.id.toString()].containsKey(skuId.toString())){
                  Map skuMap =syncObj["cats"][moduleId.toString()][skuCategory.id.toString()][skuId.toString()];
                  if(skuMap.isNotEmpty){
                    if(skuMap.containsKey("parents")){
                      if(skuMap["parents"].containsKey(productCategoryId.toString())){
                        productId = skuMap["parents"][productCategoryId.toString()];
                      }
                    }
                  }
                }
              }
            }
          }
        }

      }

    }catch(e){
      print("inside getProductCategoryTypeIdForASkuAndModule ProductCategoryServices catch block $e");
    }
    return productId;
  }


  Future<ProductModel?> getProductModelFromProductTypeAndProductIdAndModule(int sbuId, int productCategoryId, int productId)async{
    ProductModel? product;
    try{
      if (syncObj.containsKey("cats")) {
        if (syncObj["cats"].containsKey(sbuId.toString())) {
          if (syncObj["cats"][sbuId.toString()].containsKey(productCategoryId.toString())) {
            if (syncObj["cats"][sbuId.toString()][productCategoryId.toString()].containsKey(productId.toString())) {
              if (syncObj["cats"][sbuId.toString()][productCategoryId.toString()][productId.toString()].isNotEmpty) {
                product = ProductModel.fromJson(syncObj["cats"][sbuId.toString()][productCategoryId.toString()][productId.toString()]);
              }
            }
          }
        }
      }
    }catch(e){
      print("inside getProductModelFromProductTypeAndProductIdAndModule ProductCategoryServices catch block $e");
    }
    return product;
  }

  Future<ProductModel?> getFirstSkuModelForAProductCategoryAndModule(int moduleId, int productCategoryId, int productId)async{
    ProductModel? product;
    try{

      ProductCategoryModel? skuCategory = await getCategoryModelOfSkuForAModule(moduleId);
      if(skuCategory !=null){
        if(skuCategory.id!=productCategoryId){
          if(syncObj.containsKey("cats")){
            if(syncObj["cats"].containsKey(moduleId.toString())){
              if(syncObj["cats"][moduleId.toString()].containsKey(skuCategory.id.toString())){
                if(syncObj["cats"][moduleId.toString()][skuCategory.id.toString()].isNotEmpty){
                  Map allSkuOfAModule = syncObj["cats"][moduleId.toString()][skuCategory.id.toString()];
                  for(MapEntry skuEntry in allSkuOfAModule.entries){
                    Map sku = skuEntry.value;
                    if(sku.isNotEmpty){
                      if(sku.containsKey("parents")){
                        if(sku["parents"].containsKey(productCategoryId.toString())){
                          if(sku["parents"][productCategoryId.toString()]==productId){
                            productId = sku["id"];
                            break;
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        print("product id $productId");
        product =await getProductModelFromProductTypeAndProductIdAndModule(moduleId, skuCategory.id, productId);
      }
    }catch(e){
      print("inside getFirstSkuModelForAProductCategoryAndModule ProductCategoryServices catch block $e");
    }

    return product;
  }


  Future<List<ProductModel>> getAllSkuListForAProductCategoryAndModule(int moduleId, int productCategoryId, int productId)async{
    List<ProductModel> products = [];
    try{
      ProductCategoryModel? skuCategory = await getCategoryModelOfSkuForAModule(moduleId);
      if(skuCategory !=null){
        if(skuCategory.id!=productCategoryId){
          if(syncObj.containsKey("cats")){
            if(syncObj["cats"].containsKey(moduleId.toString())){
              if(syncObj["cats"][moduleId.toString()].containsKey(skuCategory.id.toString())){
                if(syncObj["cats"][moduleId.toString()][skuCategory.id.toString()].isNotEmpty){
                  Map allSkuOfAModule = syncObj["cats"][moduleId.toString()][skuCategory.id.toString()];
                  for(MapEntry skuEntry in allSkuOfAModule.entries){
                    Map sku = skuEntry.value;
                    if(sku.isNotEmpty){
                      if(sku.containsKey("parents")){
                        if(sku["parents"].containsKey(productCategoryId.toString())){
                          if(sku["parents"][productCategoryId.toString()]==productId){
                            ProductModel product = ProductModel.fromJson(sku);
                            products.add(product);
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }

      }
    }catch(e){
      print("inside getAllSkuListForAProductCategoryAndModule ProductCategoryServices catch block $e");
    }

    return products;
  }

  Future<ProductDetailsModel?> getSkuModelFromModuleIdAndSkuId(Module module, int skuId)async{
    ProductDetailsModel? sku;
    try{
      if (syncObj["cats"].containsKey(module.id.toString())) {
        ProductCategoryModel? skuCategory = await getCategoryModelOfSkuForAModule(module.id);
        String increaseId = await _syncReadService.getIncreasedId(module.id.toString());
        if (skuCategory != null) {
          if (syncObj["cats"][module.id.toString()].containsKey(skuCategory.id.toString())) {
            Map skuMap = syncObj["cats"][module.id.toString()][skuCategory.id.toString()];
            if(skuMap.containsKey(skuId.toString())){
              final skuUnitConfig = getSkuUnitConfigBySkuId(skuId: skuId.toString());
              sku = ProductDetailsModel.fromJson(skuMap[skuId.toString()], skuCategory.slug, increaseId, unitConfiguration: skuUnitConfig);
              sku.setModule(module);
            }
          }
        }
      }
    }catch(e){
      Helper.dPrint("inside getSkuModelFromModuleIdAndSkuId ProductCategory Services catch block $e");
    }
    return sku;
  }

  Future<ProductDetailsModel?> getSkuDetailsFromSkuId(int skuId)async{
    ProductDetailsModel? sku;
    try{

      List<Module> moduleList = await _moduleServices.getModuleModelList();

      for(var module in moduleList){
        if (syncObj["cats"].containsKey(module.id.toString())) {
          ProductCategoryModel? skuCategory = await getCategoryModelOfSkuForAModule(module.id);
          String increaseId = await _syncReadService.getIncreasedId(module.id.toString());
          if (skuCategory != null) {
            if (syncObj["cats"][module.id.toString()].containsKey(skuCategory.id.toString())) {
              Map skuMap = syncObj["cats"][module.id.toString()][skuCategory.id.toString()];
              if(skuMap.containsKey(skuId.toString())){
                final skuUnitConfig = getSkuUnitConfigBySkuId(skuId: skuId.toString());
                sku = ProductDetailsModel.fromJson(skuMap[skuId.toString()], skuCategory.slug, increaseId, unitConfiguration: skuUnitConfig);
                sku.setModule(module);
              }
            }
          }
        }
      }


    }catch(e){
      Helper.dPrint("inside getSkuModelFromModuleIdAndSkuId ProductCategory Services catch block $e");
    }
    return sku;
  }


  Future<bool> checkGlobalOutletStockConfigurationEnable() async {
    bool isEnable = false;
    try {
      isEnable = (syncObj[outletStockConfiguration]?[outletStockEnable]??0) == 1? true : false;
    } catch (e,t) {
      log(e.toString());
      log(t.toString());
    }
    return isEnable;
  }


  /// for aws stock
  Future<List<AwsProductModel>> getProductDetailsListForAwsStock() async {
    await _syncService.checkSyncVariable();
    List<AwsProductModel> productList = [];
    try {
      if(syncObj.containsKey("cats")){
        for(MapEntry moduleIdWiseEntry in syncObj["cats"].entries){
          int moduleId = int.parse(moduleIdWiseEntry.key.toString());
          ProductCategoryModel? skuCategory = await getCategoryModelOfSkuForAModule(moduleId);
          String increaseId = await _syncReadService.getIncreasedId(moduleId.toString());
          if (skuCategory != null) {
            if (syncObj["cats"][moduleId.toString()].containsKey(skuCategory.id.toString())) {
              Map skuMap = syncObj["cats"][moduleId.toString()][skuCategory.id.toString()];
              if (skuMap.isNotEmpty) {
                for (String skuId in skuMap.keys) {
                  Map skuDetails = skuMap[skuId];
                  // log('aws sku model => $skuDetails');
                  AwsProductModel sku = AwsProductModel.fromJson(skuDetails);
                  sku.setModuleId(moduleId);
                  // await _syncReadService.setStock(sku, module.slug);
                  // sku.setModule(module);
                  productList.add(sku);
                }
              }
            }
          }
        }
      }

      // if (productList.isNotEmpty) {
      //   productList.sort((a, b) => a.sort.compareTo(b.sort));
      // }
    } catch (e, s) {
      print("inside getProductDetailsList ProductCategoryServices catch block $e $s");
    }
    return productList;
  }
}