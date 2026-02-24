import 'dart:convert';
import 'dart:developer';

import '../constants/constant_keys.dart';
import '../constants/enum.dart';
import '../constants/sync_global.dart';
import '../models/module.dart';
import '../models/outlet_model.dart';
import '../models/products_details_model.dart';
import '../models/sales/sale_data_model.dart';
import '../models/trade_promotions/promotion_model.dart';
import '../utils/promotion_utils.dart';
import '../utils/sales_type_utils.dart';
import 'helper.dart';
import 'price_services.dart';
import 'product_category_services.dart';
import 'sync_read_service.dart';
import 'sync_service.dart';

class PromotionServices {
  final SyncService _syncService = SyncService();
  final ProductCategoryServices _productCategoryServices = ProductCategoryServices();
  final PriceServices _priceServices = PriceServices();
  final SyncReadService _syncReadService = SyncReadService();

  num getTotalDiscountAmountForAPromotionInfo(Map promotionInfo) {
    num discountAmount = 0;
    try {
      if (promotionInfo.containsKey(promotionDataDiscountSkusKey)) {
        if (promotionInfo[promotionDataDiscountSkusKey].isNotEmpty) {
          Map discountSkus = promotionInfo[promotionDataDiscountSkusKey];
          discountSkus.forEach((skuId, skuMap) {
            discountAmount += skuMap[promotionDataDiscountAmountKey];
          });
        }
      }
    } catch (e) {
      Helper.dPrint("inside getTotalDiscountAmountForARetailerAndPromotion PromotionServices catch block $e");
    }
    return discountAmount;
  }





  num getPreviouslyAppliedDiscountForARetailerAndPromotionAndSku(int retailerId, int promotionId, int skuId, SaleType saleType) {
    num previousDiscountAmount = 0;
    try {} catch (e) {
      Helper.dPrint("inside getPreviouslyAppliedDiscountForARetailerAndPromotionAndSku PromotionServices catch block $e");
    }
    return previousDiscountAmount;
  }






  //get promotion model for a module
  Future<List<PromotionModel>> getPromotionsForAModule(int moduleId) async {
    List<PromotionModel> promotions = [];
    try {
      if (syncObj.containsKey("promotions")) {
        Map promotionConfigMap = syncObj["promotions"];
        print(promotionConfigMap);
        if (promotionConfigMap.isNotEmpty) {
          for (var promotionId in promotionConfigMap.keys) {
            var promotionConfig = promotionConfigMap[promotionId];
            if (promotionConfig.isNotEmpty) {
              List<Module> modules = await _productCategoryServices.getModuleModelListFromSkuList(promotionConfig["skus"]);
              if (modules.isNotEmpty) {
                bool moduleExists = false;
                modules.forEach((m) {
                  if (m.id == moduleId) {
                    moduleExists = true;
                    return;
                  }
                });

                if (moduleExists) {
                  promotions.add(PromotionModel.fromJson(promotionConfig));
                }
              }
            }
          }
        }
      }
    } catch (e, f) {
      print("inside getPromotionIdsForAModule salesServices catch block $e");
    }
    return promotions;
  }


  //get promotion model for a module
  PromotionModel? getPromotionsDetailsFromPromotionId(String promotionId) {
    try {
      if (syncObj.containsKey("promotions")) {
        Map promotionConfigMap = syncObj["promotions"];
        if (promotionConfigMap.isNotEmpty) {
          if(promotionConfigMap.containsKey(promotionId)) {
            var promotionConfig = promotionConfigMap[promotionId];
            return PromotionModel.fromJson(promotionConfig);
          }
        }
      }
    } catch (e, f) {
      print("inside getPromotionIdsForAModule salesServices catch block $e");
    }
    return null;
  }

  //calculates total discount and qc price for a retailer
  Future<double> getTotalDiscountAndQcInfo(int retailerId) async {
    double discountAndOthers = 0.0;
    try {
      // SaleDataModel discount = await getTotalDiscountForARetailer(retailerId);
      // discountAndOthers += discount.price;

      SaleDataModel qc = await getTotalQcForARetailer(retailerId);
      discountAndOthers += qc.price;
    } catch (e) {
      print("inside getTotalDiscountAndQcInfo salesServices catch block $e");
    }
    return discountAndOthers;
  }



  //calculate total discount and others of the day
  // Future<double> getTotalDiscountAndQcOfTheDay() async {
  //   double discountAndOther = 0.0;
  //   try {
  //     // SaleDataModel discount = await getTotalDiscountOfTheDay();
  //     // discountAndOther += discount.price;
  //
  //     SaleDataModel qc = await getTotalQcOfTheDay();
  //     discountAndOther += discount.price;
  //   } catch (e) {
  //     print("inside getTotalDiscountAndQcOfTheDay salesServices catch block $e");
  //   }
  //
  //   return discountAndOther;
  // }

  //calculates total Discount quantity and price for a retailer
  // Future<SaleDataModel> getTotalDiscountForARetailer(int retailerId) async {
  //   SaleDataModel discountInfo = SaleDataModel();
  //   try {
  //     await _syncService.checkSyncVariable();
  //     int totalVolume = 0;
  //     double totalValue = 0.0;
  //     if (syncObj.containsKey(promotionDataKey)) {
  //       if (syncObj[promotionDataKey].containsKey(retailerId.toString())) {
  //         Map retailerWisePromotion = syncObj[promotionDataKey][retailerId.toString()];
  //         if (retailerWisePromotion.isNotEmpty) {
  //           retailerWisePromotion.forEach((promotionId, promotionInfo) {
  //             totalVolume += int.tryParse(promotionInfo[promotionVolumeKey].toString()) ?? 0;
  //             totalValue += double.tryParse(promotionInfo[promotionValueKey].toString()) ?? 0.0;
  //           });
  //         }
  //       }
  //     }
  //     discountInfo.qty = totalVolume;
  //     discountInfo.price = totalValue;
  //   } catch (e) {
  //     print("inside getTotalDiscountForARetailer salesServices catch block $e");
  //   }
  //
  //   return discountInfo;
  // }

  //calculates total discount of the day for sales agent
  // Future<SaleDataModel> getTotalDiscountOfTheDay() async {
  //   SaleDataModel discountData = SaleDataModel();
  //   try {
  //     await _syncService.checkSyncVariable();
  //
  //     int totalVolume = 0;
  //     double totalValue = 0.0;
  //     if (syncObj.containsKey(promotionDataKey)) {
  //       if (syncObj[promotionDataKey].isNotEmpty) {
  //         Map promotionObject = syncObj[promotionDataKey];
  //         for (var retailerId in promotionObject.keys) {
  //           SaleDataModel promotionDataForARetailer = await getTotalDiscountForARetailer(int.parse(retailerId.toString()));
  //           totalVolume += promotionDataForARetailer.qty;
  //           totalValue += promotionDataForARetailer.price;
  //         }
  //       }
  //     }
  //     discountData.qty = totalVolume;
  //     discountData.price = totalValue;
  //   } catch (e) {
  //     print("inside getTotalDiscountOfTheDay salesServices catch block $e");
  //   }
  //   return discountData;
  // }

  //calculates total qc quantity and price for a retailer
  Future<SaleDataModel> getTotalQcForARetailer(int retailerId) async {
    SaleDataModel totalQcData = SaleDataModel();
    try {
      await _syncService.checkSyncVariable();
      int totalVolume = 0;
      double totalValue = 0.0;
      if (syncObj.containsKey(qcDataKey)) {
        if (syncObj[qcDataKey].containsKey(retailerId.toString())) {
          Map moduleWiseQcInfo = syncObj[qcDataKey][retailerId.toString()];
          if (moduleWiseQcInfo.isNotEmpty) {
            for (var moduleId in moduleWiseQcInfo.keys) {
              SaleDataModel qcForModule = await getTotalQcForAModuleAndARetailer(retailerId, moduleId);
              totalVolume += qcForModule.qty;
              totalValue += qcForModule.price;
            }
          }
        }
      }
      totalQcData.qty = totalVolume;
      totalQcData.price = totalValue;
    } catch (e, s) {
      print("inside getTotalQcForARetailer salesServices catch block $e $s");
    }

    return totalQcData;
  }

  Future<SaleDataModel> getTotalQcOfTheDay() async {
    SaleDataModel qcData = SaleDataModel();
    try {
      await _syncService.checkSyncVariable();
      int totalVolume = 0;
      double totalValue = 0.0;

      if (syncObj.containsKey(qcDataKey)) {
        Map qcObject = syncObj[qcDataKey];
        if (qcObject.isNotEmpty) {
          for (var retailerId in qcObject.keys) {
            SaleDataModel qcDataPerRetailer = await getTotalQcForARetailer(int.parse(retailerId.toString()));
            totalVolume += qcDataPerRetailer.qty;
            totalValue += qcDataPerRetailer.price;
          }
        }
      }

      qcData.qty = totalVolume;
      qcData.price = totalValue;
    } catch (e) {
      print("inside getTotalQcOfTheDay salesServices catch block $e");
    }
    return qcData;
  }

  //calculates total quantity and price of qc done for a retailer and specific module
  Future<SaleDataModel> getTotalQcForAModuleAndARetailer(int retailerId, String moduleId) async {
    SaleDataModel qcData = SaleDataModel();
    int totalVolume = 0;
    double totalValue = 0.0;
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(qcDataKey)) {
        if (syncObj[qcDataKey].containsKey(retailerId.toString())) {
          if (syncObj[qcDataKey][retailerId.toString()].containsKey(moduleId.toString())) {
            Map skuWiseQcInfo = syncObj[qcDataKey][retailerId.toString()][moduleId.toString()];
            if (skuWiseQcInfo.isNotEmpty) {
              skuWiseQcInfo.forEach((skuId, qcInfoList) {
                if (qcInfoList.isNotEmpty) {
                  qcInfoList.forEach((qcInfo) {
                    totalVolume += int.tryParse(qcInfo[qcVolumeKey].toString()) ?? 0;
                    totalValue += double.tryParse(qcInfo[qcTotalValueKey].toString()) ?? 0.0;
                  });
                }
              });
            }
          }
        }
      }
    } catch (e) {
      print("inside getTotalQcForAModuleAndARetailer salesServices catch block $e");
    }
    qcData.qty = totalVolume;
    qcData.price = totalValue;
    return qcData;
  }

  //calculates total quantity and price of qc done for a specific module
  Future<SaleDataModel> getTotalQcForAModule(int moduleId) async {
    SaleDataModel qcData = SaleDataModel();
    try {
      int totalVolume = 0;
      double totalValue = 0.0;

      await _syncService.checkSyncVariable();
      print(syncObj[qcDataKey]);
      if (syncObj.containsKey(qcDataKey)) {
        if (syncObj[qcDataKey].isNotEmpty) {
          syncObj[qcDataKey].forEach((retailerId, moduleInfo) {
            if (moduleInfo.containsKey(moduleId.toString())) {
              Map moduleWiseQc = moduleInfo[moduleId.toString()];
              if (moduleWiseQc.isNotEmpty) {
                moduleWiseQc.forEach((skuId, qcInfoList) {
                  if (qcInfoList.isNotEmpty) {
                    qcInfoList.forEach((qcInfo) {
                      totalVolume += int.tryParse(qcInfo[qcVolumeKey].toString()) ?? 0;
                      totalValue += double.tryParse(qcInfo[qcTotalValueKey].toString()) ?? 0.0;
                    });
                  }
                });
              }
            }
          });
        }
      }

      qcData.qty = totalVolume;
      qcData.price = totalValue;
    } catch (e, s) {
      print("inside getTotalQcForAModule salesServices catch block $e $s");
    }

    return qcData;
  }

  //check if a promotion can be available For a retailer
  Future<bool> checkIfPromotionAvailableForARetailer(OutletModel retailer, PromotionModel promotion) async {
    bool promotionAvailable = true;
    //TODO:: need to change later
    // try {
    //   if (!promotion.isRepeat) {
    //     await _syncService.checkSyncVariable();
    //     promotionAvailable = !await _syncReadService.checkRetailerHasSku(promotion.skus, retailer.id??0);
    //   }
    // } catch (e) {
    //   print("inside checkIfPromotionAvailableForARetailer PromotionServices catch block $e");
    // }
    return promotionAvailable;
  }

  //===================================== Promotion Applied in Sale =====================================

  // Future<List<DiscountModel>> getPreviousDiscountForARetailerAndModule(int moduleId, int retailerId) async {
  //   List<DiscountModel> allDiscountsForAModule = [];
  //   try {
  //     await _syncService.checkSyncVariable();
  //     if (syncObj.containsKey(promotionDataKey)) {
  //       if (syncObj[promotionDataKey].containsKey(retailerId.toString())) {
  //         if (syncObj[promotionDataKey][retailerId.toString()].isNotEmpty) {
  //           List<PromotionModel> promotionsForAModule = await getPromotionsForAModule(moduleId);
  //           if (promotionsForAModule.isNotEmpty) {
  //             for (PromotionModel promotion in promotionsForAModule) {
  //               if (syncObj[promotionDataKey][retailerId.toString()].containsKey(promotion.id.toString())) {
  //                 Map promotionDataMap = syncObj[promotionDataKey][retailerId.toString()][promotion.id.toString()];
  //                 DiscountModel discount = DiscountModel(appliedPromotion: promotion, discountAmount:promotionDataMap[promotionValueKey]??0.0 , discountVolume: promotionDataMap[promotionVolumeKey]??0);
  //                 allDiscountsForAModule.add(discount);
  //               }
  //             }
  //           }
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     print("inside getPreviousDiscountForARetailerAndModule promotionServices catch block $e");
  //   }
  //   return allDiscountsForAModule;
  // }


  Future<List<PromotionModel>> getAllPromotions()async{
    List<PromotionModel> promotions = [];
    try{
      await _syncService.checkSyncVariable();

      Map<PayableType, List<PromotionModel>> groupedPromotions = {};

      await _syncService.checkSyncVariable();
      Helper.dPrint("promotions in sync: ${syncObj["promotions"]}");

      for (MapEntry item in syncObj["promotions"].entries) {
        final promotion = PromotionModel.fromJson(item.value);

        // Check if the payable type exists in the map
        if (!groupedPromotions.containsKey(promotion.payableType)) {
          // If not, create a new entry with an empty list
          groupedPromotions[promotion.payableType] = [];
        }

        // Add the current promotion to the list of the corresponding payable type
        groupedPromotions[promotion.payableType]?.add(promotion);
      }

      groupedPromotions.values.forEach((list) {
        promotions.addAll(list);
      });

    }
    catch(e,s){
      Helper.dPrint(e.toString());
      Helper.dPrint(s.toString());
    }

    return promotions;
  }



  Future<List<PromotionModel>> getPromotionsById(Map<int, Map>? promotionMap) async {
    List<PromotionModel> promotions = [];
    try{
      await _syncService.checkSyncVariable();

      Map<PayableType, List<PromotionModel>> groupedPromotions = {};

      await _syncService.checkSyncVariable();
      Helper.dPrint("promotions in sync: ${syncObj["promotions"]}");

      for (MapEntry item in syncObj["promotions"].entries) {
        final promotion = PromotionModel.fromJson(item.value);

        // Check if the payable type exists in the map
        if (!groupedPromotions.containsKey(promotion.payableType)) {
          // If not, create a new entry with an empty list
          groupedPromotions[promotion.payableType] = [];
        }

        // Add the current promotion to the list of the corresponding payable type
        if(promotionMap?.containsKey(promotion.id) ?? false) {
          groupedPromotions[promotion.payableType]?.add(promotion);
        }
      }

      groupedPromotions.values.forEach((list) {
        promotions.addAll(list);
      });

    }
    catch(e,s){
      Helper.dPrint(e.toString());
      Helper.dPrint(s.toString());
    }

    return promotions;
  }


  Future<Module?> getModuleForAPromotion(int promotionId) async {
    Module? module;
    try {
      if (syncObj.containsKey("promotions")) {
        if (syncObj["promotions"].containsKey(promotionId.toString())) {
          if (syncObj["promotions"][promotionId.toString()].containsKey("skus")) {

            if (syncObj["promotions"][promotionId.toString()]["skus"].isNotEmpty) {
              List skuids = [];
              for(Map item in syncObj["promotions"][promotionId.toString()]["skus"]){
                skuids.add(item['sku_id']);
              }
              if (skuids.isNotEmpty) {
                List<Module> modules = await _productCategoryServices.getModuleModelListFromSkuList(skuids);
                if (modules.isNotEmpty) {
                  module = modules[0];
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print("inside getModuleForAPromotion PromotionServices catch block $e");
    }

    return module;
  }

  Future<List> getModuleListThatHavePromotionForARetailer(int retailerId)async{
    List modules = [];
    try{
      await _syncService.checkSyncVariable();
      Map promotionData =syncObj[promotionDataKey]?[retailerId.toString()]??{};
      print("promotiondata $promotionData");
      if(promotionData.isNotEmpty){
        for(MapEntry promotionMapEntry in promotionData.entries){
          Module? module =await getModuleForAPromotion(int.parse(promotionMapEntry.key));
          if(module!=null){
            if(!modules.contains(module.id)){
              modules.add(module.id);
            }
          }
        }
      }
    }catch(e){
      print("inside getModuleListThatHavePromotionForARetailer promotionServices catch block $e");
    }
    return modules;
  }

  Future<bool> getSalesModuleV2PromotionEnable() async {
    // return true;
    bool saleModulePromotionEnable = false;
    try {
      await _syncService.checkSyncVariable();
      int available = syncObj["sales_dashboard_buttons"]?["promotion"]??0;
      if(available == 1) {
        saleModulePromotionEnable = true;
      }
    } catch (e,t) {
      log(e.toString());
      log(t.toString());
    }
    return saleModulePromotionEnable;
  }
}
