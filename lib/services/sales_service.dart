import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:wings_olympic_sr/screens/stock_check/service/stock_check_service.dart';
import 'package:wings_olympic_sr/services/pre_order_service.dart';

import '../api/global_http.dart';
import '../api/links.dart';
import '../constants/constant_keys.dart';
import '../constants/constant_variables.dart';
import '../constants/enum.dart';
import '../constants/sync_global.dart';
import '../models/coupon/coupon_model.dart';
import '../models/general_id_slug_model.dart';
import '../models/module.dart';
import '../models/outlet_model.dart';
import '../models/product_category_model.dart';
import '../models/products_details_model.dart';
import '../models/qc_config_model.dart';
import '../models/qc_info_model.dart';
import '../models/returned_data_model.dart';
import '../models/sale_summary_model.dart';
import '../models/sales/memo_information_model.dart';
import '../models/slab_promotion_selection_model.dart';
import '../models/sr_info_model.dart';
import '../models/trade_promotions/applied_discount_model.dart';
import '../models/trade_promotions/promotion_model.dart';
import '../utils/promotion_utils.dart';
import '../utils/sales_type_utils.dart';
import 'Image_service.dart';
import 'before_sale_services/survey_service.dart';
import 'connectivity_service.dart';
import 'delivery_services.dart';
import 'device_info_services.dart';
import 'ff_services.dart';
import 'helper.dart';
import 'module_services.dart';
import 'offline_pda_service.dart';
import 'posm_management_service.dart';
import 'product_category_services.dart';
import 'promotion_services.dart';
import 'sr_target_services.dart';
import 'sync_read_service.dart';
import 'sync_service.dart';
import 'trade_promotion_services.dart';

class SalesService {
  static final SalesService _saleService = SalesService._internal();

  factory SalesService() {
    return _saleService;
  }

  SalesService._internal();

  final SyncService _syncService = SyncService();
  final SyncReadService _syncReadService = SyncReadService();
  final FFServices _ffServices = FFServices();
  final TradePromotionServices _tradePromotionServices =
      TradePromotionServices();
  final ProductCategoryServices _productCategoryServices =
      ProductCategoryServices();

  //saves sales of a specific retailer to sync
  Future<ReturnedDataModel?> saveAllDataForARetailer({
    required OutletModel retailer,
    required preorderData,
    required geoData,
    required List<AppliedDiscountModel> appliedDiscounts,
    required Map qcInfo,
    required SaleStatus saleStatus,
    String? reason,
    required SaleType saleType,
    bool sendToServer = true,
    List<SlabPromotionSelectionModel>? slabPromotions,
    CouponModel? coupon,
    num? couponDiscountAmount,
    Map<int, List<ProductDetailsModel>>? selectedSkuWithCount,
    // bool memoEdit,
  }) async {
    ReturnedDataModel returnedDataModel =
        ReturnedDataModel(status: ReturnedStatus.error);
    try {
      // if (saleType == SaleType.delivery && sendToServer == true) {
      //   Map checkMap = checkThisDeliveryDataValidateWithServerAvailableStock(
      //     retailer: retailer,
      //     appliedDiscounts: appliedDiscounts,
      //     preorderData: preorderData,
      //   );
      //
      //   ReturnedDataModel? returnedDataModel = await isStockAvailableApi(checkMap);
      //   if(returnedDataModel!=null && returnedDataModel.status != ReturnedStatus.success) {
      //
      //     return false;
      //   }
      // }
      await _syncService.checkSyncVariable();
      final previousSyncFile = jsonEncode(syncObj);

      await saveAllQCDataForARetailer(retailer, qcInfo, saleType);
      await saveAllQCDataForARetailer(retailer, qcInfo, saleType);
      if(saleType == SaleType.spotSale) {
        await saveUpdatedStockDataSync(retailer, selectedSkuWithCount??{}, saleStatus, saleType);
      }
      await savePreorderToSync(retailer, preorderData, saleType);

      await _tradePromotionServices.saveAllPromotionDataForASingleSale(
        retailer,
        appliedDiscounts,
        saleType,
        slabPromotions,
        saleStatus == SaleStatus.editedSale,
      );
      await saveCallTime(retailer);
      // bool saveSales = await saveSalesDataToSync(retailer, preorderData, saleType);
      await saveGeoDataToSync(retailer, geoData);

      ///todo save all data to sync file
      if (coupon != null && couponDiscountAmount != null) {
        await saveAllCouponToSync(retailer, coupon, couponDiscountAmount);
      }

      ///if the retailer already have on zero sales
      ///the need to remove from here
      removeRetailerFromZeroSell(retailer);

      await _syncService.writeSync(jsonEncode(syncObj));
      // if(saleType == SaleType.preorder && saveSales) {
      //   syncObj = jsonDecode(previousSyncFile);
      //   await _syncService.writeSync();
      //   await _syncService.checkSyncVariable();
      //   await revertSalesDataToSync(retailer, preorderData, saleType);
      //   SystemNavigator.pop();
      // }
      if (sendToServer) {
        ReturnedDataModel? returnedDataModel =
            await getFormattedSalesDataToSendToApi(
                retailer, saleType, coupon);
        if (saleType == SaleType.delivery &&
            returnedDataModel != null &&
            returnedDataModel.status != ReturnedStatus.success) {
          syncObj = jsonDecode(previousSyncFile);
          await _syncService.writeSync();
          await _syncService.checkSyncVariable();
          return returnedDataModel;
        }
      }

      return ReturnedDataModel(status: ReturnedStatus.success);
    } catch (e) {
      Helper.dPrint(
          "inside saveAllDataForARetailer salesServices catch block $e");
    }

    return returnedDataModel;
  }

  saveUpdatedStockDataSync(
    OutletModel retailer,
    Map<int, List<ProductDetailsModel>> preorderSkusByModule,
    SaleStatus salesStatus,
      SaleType saleType,
  ) async {
    try {
      String stockKey = "stock";
      final moduleList = await ModuleServices().getModuleModelList();
      List<PreorderMemoInformationModel> previousSalesData = [];
      if(salesStatus == SaleStatus.editedSale) {
        previousSalesData = await PreOrderService().getPreorderInfoForRetailer(retailer, saleType);
      }

      Map<int, Map<int, bool>> tracker = {};
      if (preorderSkusByModule.isNotEmpty) {
        preorderSkusByModule.forEach((moduleId, preorderSkus) {
          int index = moduleList.indexWhere((element) => element.id.toString() == moduleId.toString());
          if(index != -1) {
            final module = moduleList[index];
            for (var sku in preorderSkus) {
              int previousSaleQtyFroThisSku = 0;
              final previousSalesModuleIndex = previousSalesData.indexWhere((element) => element.module.id == moduleId);
              if(previousSalesModuleIndex != -1) {
                final previousSalesForThisModule = previousSalesData[previousSalesModuleIndex];
                final previousSalesSkuIndex = previousSalesForThisModule.skus.indexWhere((element) => element.id == sku.id);
                if(previousSalesSkuIndex != -1) {
                  final previousSalesSku = previousSalesForThisModule.skus[previousSalesSkuIndex];
                  previousSaleQtyFroThisSku = previousSalesSku.preorderData?.qty ?? 0;
                }
              }
              int currentStockForASku =  syncObj[stockKey][module.name][sku.id.toString()]["current_stock"] ?? 0;

              int currentStockAfterReduce = 0;
              if(salesStatus == SaleStatus.editedSale) {
                currentStockAfterReduce = currentStockForASku - ((sku.preorderData?.qty ?? 0) - previousSaleQtyFroThisSku);
              } else {
                currentStockAfterReduce = currentStockForASku - (sku.preorderData?.qty ?? 0);
              }
              syncObj[stockKey][module.name][sku.id.toString()]["current_stock"] = currentStockAfterReduce;
              if (!tracker.containsKey(moduleId)) {
                tracker[moduleId] = {};
              }
              tracker[moduleId]![sku.id] = true;
            }
          }
        });
      }

      if(previousSalesData.isNotEmpty && salesStatus == SaleStatus.editedSale) {
        for(var previousMemo in previousSalesData) {
          if(!tracker.containsKey(previousMemo.module.id)) {
            /// all sku inside this module should return on stock
            for(var sku in previousMemo.skus) {
              int currentStockForASku =  syncObj[stockKey][previousMemo.module.name][sku.id.toString()]["current_stock"] ?? 0;
              syncObj[stockKey][previousMemo.module.name][sku.id.toString()]["current_stock"] = currentStockForASku + (sku.preorderData?.qty ?? 0);
            }
          } else {
            Map skuMap = tracker[previousMemo.module.id]!;
            for(var sku in previousMemo.skus) {
              if (!skuMap.containsKey(sku.id)) {
                /// this sku should return on stock
                int currentStockForASku =  syncObj[stockKey][previousMemo.module.name][sku.id.toString()]["current_stock"] ?? 0;
                syncObj[stockKey][previousMemo.module.name][sku.id.toString()]["current_stock"] = currentStockForASku + (sku.preorderData?.qty ?? 0);
              }
            }
          }
        }
      }
    } catch (e, t) {
      Helper.dPrint("inside saveUpdatedStockDataSync");
      Helper.dPrint(e.toString());
      Helper.dPrint(t.toString());
    }
  }

  void removeRetailerFromZeroSell(OutletModel retailer) {
    try {
      List zeroSellList = OfflinePdaService().getUnsoldOutletData();
      List freshZeroSellList = zeroSellList;
      for (int a = 0; a < zeroSellList.length; a++) {
        var val = zeroSellList[a];
        if (val[outletIdUnsoldOutletKey] == retailer.id) {
          freshZeroSellList.removeAt(a);
        }
      }
      syncObj[outletIdUnsoldOutletKey] = freshZeroSellList;
    } catch (e, t) {
      Helper.dPrint(e.toString());
      Helper.dPrint(t.toString());
    }
  }

  saveAllQCDataForARetailer(
      OutletModel retailer, Map qcData, SaleType saleType) async {
    try {
      if (qcData.isNotEmpty) {
        String qcKey = SalesTypeUtils.toQcSaveKey(saleType);
        await _syncService.checkSyncVariable();
        if (!syncObj.containsKey(qcKey)) {
          syncObj[qcKey] = {};
        }
        syncObj[qcKey][retailer.id.toString()] = qcData;
      }
    } catch (e) {
      Helper.dPrint("saveAllQCDataForARetailer salesServices catch block $e");
    }
  }

  saveCallTime(OutletModel retailer) async {
    try {
      DateTime callEndTime = DateTime.now();
      int duration = callEndTime.difference(callStartTime).inSeconds;
      SrInfoModel? srInfo = await FFServices().getSrInfo();
      String salesDate = await FFServices().getSalesDate();
      Map callTime = {
        // callTimeSbuIdKey: srInfo.sbuId,
        callTimeDepIdKey: srInfo!.depId,
        callTimeSectionIdKey: srInfo.sectionId,
        callTimeffIdKey: srInfo.ffId,
        callTimeOutletIdKey: retailer.id,
        callTimeOutletCodeKey: retailer.outletCode,
        callTimeDateKey: salesDate,
        callStartDatetimeKey: apiDateTimeFormat.format(callStartTime),
        callEndDatetimeKey: apiDateTimeFormat.format(callEndTime),
        callTimeDurationKey: duration
      };

      if (!syncObj.containsKey(callTimeKey)) {
        syncObj[callTimeKey] = {};
      }
      if (!syncObj[callTimeKey].containsKey(retailer.id.toString())) {
        syncObj[callTimeKey][retailer.id.toString()] = [];
      }
      syncObj[callTimeKey][retailer.id.toString()].add(callTime);

      // await _syncService.writeSync(jsonEncode(syncObj));
    } catch (e) {
      Helper.dPrint("inside saveCallTime salesServices catch block $e");
    }
  }

  Future<Map> createCallTime(OutletModel retailer) async {
    Map callTime = {};
    try {
      DateTime callEndTime = DateTime.now();
      SrInfoModel? srInfo = await FFServices().getSrInfo();
      String salesDate = await FFServices().getSalesDate();
      callTime = {
        // callTimeSbuIdKey: srInfo.sbuId,
        callTimeDepIdKey: srInfo!.depId,
        callTimeSectionIdKey: srInfo.sectionId,
        callTimeffIdKey: srInfo.ffId,
        callTimeOutletIdKey: retailer.id,
        callTimeOutletCodeKey: retailer.outletCode,
        callTimeDateKey: salesDate,
        callStartDatetimeKey: apiDateTimeFormat.format(callEndTime),
        callEndDatetimeKey: apiDateTimeFormat.format(callEndTime),
        callTimeDurationKey: 0
      };

      // await _syncService.writeSync(jsonEncode(syncObj));
    } catch (e) {
      Helper.dPrint("inside saveCallTime salesServices catch block $e");
    }
    return callTime;
  }

  savePreorderToSync(
      OutletModel retailer, Map preorderData, SaleType saleType) async {
    try {
      String saleKey = SalesTypeUtils.toSaleSaveKey(saleType);

      await _syncService.checkSyncVariable();
      if (!syncObj.containsKey(saleKey)) {
        syncObj[saleKey] = {};
      }
      if (preorderData.isNotEmpty) {
        syncObj[saleKey][retailer.id.toString()] = preorderData;
      } else {
        if (syncObj[saleKey].containsKey(retailer.id.toString())) {
          syncObj[saleKey].remove(retailer.id.toString());
        }
      }
      if (saleType == SaleType.delivery) {
        log(jsonEncode(preorderData));
        await SrTargetServices().saveAchievementForASaleData(preorderData, {});
      }
      // else {
      //   await _srTargetServices.saveAchievementForASaleData(preorderData, {});
      // }
    } catch (e) {
      Helper.dPrint(
          "inside savePreorderDataToSync salesServices catch block $e");
    }
  }

  Future<bool> saveSalesDataToSync(
      OutletModel retailer, Map preorderData, SaleType saleType) async {
    try {
      String saleKey = SalesTypeUtils.toSaleSaveKey(saleType);

      await _syncService.checkSyncVariable();
      if (!syncObj.containsKey(saleKey)) {
        syncObj[saleKey] = {};
      }
      if (preorderData.isNotEmpty) {
        syncObj[saleKey][retailer.id.toString()] = preorderData;
      } else {
        if (syncObj[saleKey].containsKey(retailer.id.toString())) {
          syncObj[saleKey].remove(retailer.id.toString());
        }
      }
      if (saleType == SaleType.preorder) {
        final service = SurveyService();
        return await service.saveTheSale();
      }
      // else {
      //   await _srTargetServices.saveAchievementForASaleData(preorderData, {});
      // }
    } catch (e) {
      Helper.dPrint(
          "inside savePreorderDataToSync salesServices catch block $e");
    }
    return false;
  }

  Future revertSalesDataToSync(
      OutletModel retailer, Map preorderData, SaleType saleType) async {
    try {
      String saleKey = SalesTypeUtils.toSaleSaveKey(saleType);

      await _syncService.checkSyncVariable();
      if (!syncObj.containsKey(saleKey)) {
        syncObj[saleKey] = {};
      }
      if (preorderData.isNotEmpty) {
        syncObj[saleKey][retailer.id.toString()] = preorderData;
      } else {
        if (syncObj[saleKey].containsKey(retailer.id.toString())) {
          syncObj[saleKey].remove(retailer.id.toString());
        }
      }
      if (saleType == SaleType.preorder) {
        final service = SurveyService();
        await service.secure();
      }
      // else {
      //   await _srTargetServices.saveAchievementForASaleData(preorderData, {});
      // }
    } catch (e) {
      Helper.dPrint(
          "inside savePreorderDataToSync salesServices catch block $e");
    }
    return false;
  }

  saveGeoDataToSync(OutletModel retailer, Map geoData) async {
    try {
      if (geoData.isNotEmpty) {
        if (!syncObj.containsKey(geoDataKey)) {
          syncObj[geoDataKey] = {};
        }
        if (!syncObj[geoDataKey].containsKey(retailer.id.toString())) {
          syncObj[geoDataKey][retailer.id.toString()] = [];
        }
        syncObj[geoDataKey][retailer.id.toString()].add(geoData);
      }

      // await _syncService.writeSync(jsonEncode(syncObj));
    } catch (e) {
      Helper.dPrint("inside saveGeoDataToSync salesServices catch block $e");
    }
  }

  //save manual override data to sync
  saveManualOverride(
      {required int retailerId,
      required String imagePath,
      required lat,
      required long,
      required String timestamp,
      required int reasonId}) async {
    try {
      if (!syncObj.containsKey(manualOverrideKey)) {
        syncObj[manualOverrideKey] = {};
      }

      syncObj[manualOverrideKey][retailerId.toString()] = {
        manualOverrideRetailerIdKey: retailerId,
        manualOverrideSrLatKey: lat,
        manualOverrideSrLngKey: long,
        manualOverrideImageKey: imagePath,
        manualOverrideTimestampKey: timestamp,
        manualOverrideReasoningKey: reasonId
      };

      await _syncService.writeSync();
    } catch (e) {
      Helper.dPrint(
          "inside saveManualOverride in sales Services catch block $e");
    }
  }

  sendManualOverrideImageToServer(File compressedImage, SrInfoModel sr) async {
    if (await ConnectivityService().checkInternet()) {
      String date = await FFServices().getSalesDate();
      DateTime saleDate = DateTime.parse(date);
      String path =
          "$manualOverrideFolder/${saleDate.year}/${saleDate.month.toString().padLeft(2, '0')}/${saleDate.day.toString().padLeft(2, '0')}/${sr.depId}/${sr.sectionId}";
      bool done = await ImageService().sendImage(compressedImage.path, path);
      if (done) {
        if (await compressedImage.exists()) {
          await compressedImage.delete();
        }
      }
    }
  }

  sendUnsoldOutletImageToServer(File compressedImage, SrInfoModel sr) async {
    if (await ConnectivityService().checkInternet()) {
      String date = await FFServices().getSalesDate();
      DateTime saleDate = DateTime.parse(date);
      String path =
          "$unsoldOutletFolder/${saleDate.year}/${saleDate.month.toString().padLeft(2, '0')}/${saleDate.day.toString().padLeft(2, '0')}/${sr.depId}/${sr.sectionId}";
      bool done = await ImageService().sendImage(compressedImage.path, path);
      if (done) {
        if (await compressedImage.exists()) {
          await compressedImage.delete();
        }
      }
    }
  }

  saveCoolerImage(int retailerId, String imagePath) async {
    try {
      if (!syncObj.containsKey(coolerImageKey)) {
        syncObj[coolerImageKey] = {};
      }

      syncObj[coolerImageKey][retailerId.toString()] = imagePath;
    } catch (e) {
      Helper.dPrint("inside saveCoolerImage SalesServices catch block $e");
    }
  }

  saveCoolerPurityScore(int retailerId, String score) async {
    try {
      if (!syncObj.containsKey(coolerPurityScoreKey)) {
        syncObj[coolerPurityScoreKey] = {};
      }

      syncObj[coolerPurityScoreKey][retailerId.toString()] = score;
    } catch (e) {
      Helper.dPrint("inside saveCoolerImage SalesServices catch block $e");
    }
  }

  sendCoolerImageToServer(File compressedImage) async {
    if (await ConnectivityService().checkInternet()) {
      String date = await FFServices().getSalesDate();
      SrInfoModel? sr = await _ffServices.getSrInfo();
      DateTime saleDate = DateTime.parse(date);
      String path =
          "$coolerImageFolder/${saleDate.year}/${saleDate.month.toString().padLeft(2, '0')}/${saleDate.day.toString().padLeft(2, '0')}/${sr!.depId}/${sr.sectionId}";
      bool done = await ImageService().sendImage(compressedImage.path, path);
      if (done) {
        if (await compressedImage.exists()) {
          await compressedImage.delete();
        }
      }
    }
  }

  Future<bool> checkRetailerHasTakenPreorder(int retailerId) async {
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(preorderKey)) {
        return syncObj[preorderKey].containsKey(retailerId.toString());
      }
    } catch (e, s) {
      Helper.dPrint(
          "inside checkRetailerHasTakenPreorder salesServices catch block $e  $s");
    }
    return false;
  }

  Future<bool> checkRetailerHasSpotSales(int retailerId) async {
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(spotSaleKey)) {
        return syncObj[spotSaleKey].containsKey(retailerId.toString());
      }
    } catch (e, s) {
      Helper.dPrint(
          "inside checkRetailerHasTakenPreorder salesServices catch block $e  $s");
    }
    return false;
  }

  ///check zero sell exist or not
  Future<bool> checkZeroSell(int outletId) async {
    try {
      await _syncService.checkSyncVariable();
      List zeroSellList = OfflinePdaService().getUnsoldOutletData();
      if (zeroSellList.isNotEmpty) {
        List<String> outletIdesList = [];
        for (var val in zeroSellList) {
          if (val.containsKey(onboardingOutletIdKey)) {
            outletIdesList.add(val[onboardingOutletIdKey].toString());
          }
        }
        if (outletIdesList.contains(outletId.toString())) {
          return true;
        }
        return false;
      }
    } catch (e, s) {
      Helper.dPrint(
          "inside checkRetailerHasTakenPreorder salesServices catch block $e  $s");
    }
    return false;
  }

  Future<List<Map>> getZeroSellList() async {
    try {
      await _syncService.checkSyncVariable();
      List zeroSellList = OfflinePdaService().getUnsoldOutletData();
      if (zeroSellList.isNotEmpty) {
        List<Map> uniqueZeroSellList = [];
        List<String> idsList = [];

        for (var val in zeroSellList) {
          if (!idsList.contains(val[outletIdUnsoldOutletKey])) {
            idsList.add(val[outletIdUnsoldOutletKey].toString());
            uniqueZeroSellList.add({
              "sbu_id": 1,
              "dep_id": val[zeroSaleDepIdKey],
              "ff_id": val[zeroSaleFFIdKey],
              "section_id": val[zeroSaleSectionIdKey],
              "outlet_id": val[zeroSaleOutletIdKey],
              "outlet_code": val[outletCodeUnsoldOutletKey],
              "sku_id": "0",
              "unit_price": 0.0,
              "volume": 0,
              "total_price": 0.0,
              "date": val[dateUnsoldOutletKey],
              "order_datetime": val[dateTimeUnsoldOutletKey],
              // "image": val[imageUnsoldOutletKey],
              // reasonUnsoldOutletIdKey: val[reasonUnsoldOutletIdKey],
              // reasonUnsoldOutletKey: val[reasonUnsoldOutletKey],
            });
          }
        }

        return uniqueZeroSellList;
      }
      return [];
    } catch (e, s) {
      Helper.dPrint(
          "inside checkRetailerHasTakenPreorder salesServices catch block $e  $s");
    }
    return [];
  }


  //get QC data for sending to api
  Future<List> getQCDataToSendToApi(
      OutletModel retailer, SaleType saleType) async {
    List qcData = [];
    try {
      String qcKey = SalesTypeUtils.toQcSaveKey(saleType);
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(qcKey)) {
        SrInfoModel srInfo = await _syncReadService.getSrInfo();
        String salesDate = await _syncReadService.getSalesDate();
        if (syncObj[qcKey].containsKey(retailer.id.toString())) {
          Map qcDataFromSync = syncObj[qcKey][retailer.id.toString()];
          if (qcDataFromSync.isNotEmpty) {
            qcDataFromSync.forEach((moduleId, skuWiseFault) {
              if (skuWiseFault.isNotEmpty) {
                skuWiseFault.forEach((skuId, faultList) {
                  if (faultList.isNotEmpty) {
                    faultList.forEach((faultMap) {
                      Map qcDataMap = {
                        "sbu_id": int.parse(moduleId.toString()),
                        "dep_id": srInfo.depId,
                        "section_id": srInfo.sectionId,
                        "outlet_id": retailer.id,
                        "outlet_code": retailer.outletCode,
                        "ff_id": srInfo.ffId,
                        "sku_id": skuId,
                        "fault_id": faultMap[faultIdKey],
                        "volume": faultMap[qcVolumeKey],
                        "unit_price": faultMap[qcUnitPriceKey],
                        "total_value": faultMap[qcTotalValueKey],
                        "entry_type": faultMap[qcEntryTypeKey],
                        "qc_type": faultMap[qcTypeKey],
                        "status": faultMap[qcStatusKey],
                        "date": salesDate
                      };
                      qcData.add(qcDataMap);
                    });
                  }
                });
              }
            });
          }
        }
      }
    } catch (e) {
      Helper.dPrint("inside getQcDataToSendToApi salesServices catch block $e");
    }

    return qcData;
  }

  //get CallTime for a retailer for sending to api
  Future<List> getCallTimeDataForARetailer(OutletModel retailer) async {
    List callTimeData = [];
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(callTimeKey)) {
        if (syncObj[callTimeKey].containsKey(retailer.id.toString())) {
          callTimeData = syncObj[callTimeKey][retailer.id.toString()];
        }
      }
    } catch (e) {
      Helper.dPrint(
          "inside getCallTimeDataForARetailer salesServices catch block $e");
    }
    return callTimeData;
  }

  Future<List> getPreorderDataToSendToApi(
      OutletModel retailer, SaleType saleType,
      {bool withZeroSale = false}) async {
    List preorderData = [];
    try {
      String saleKey = SalesTypeUtils.toSaleSaveKey(saleType);
      await _syncService.checkSyncVariable();
      SrInfoModel srInfo = await _syncReadService.getSrInfo();
      if (syncObj.containsKey(saleKey)) {
        if (syncObj[saleKey].containsKey(retailer.id.toString())) {
          Map preorderDataForARetailer =
              syncObj[saleKey][retailer.id.toString()];
          if (preorderDataForARetailer.isNotEmpty) {
            preorderDataForARetailer.forEach((moduleId, preorderDataMap) {
              if (preorderDataMap.isNotEmpty) {
                preorderDataMap.forEach((skuId, preorderInfo) {
                  Map preorderForSku = {
                    "sbu_id": int.parse(moduleId),
                    "dep_id": srInfo.depId,
                    "ff_id": srInfo.ffId,
                    "section_id": srInfo.sectionId,
                    "outlet_id": retailer.id,
                    "outlet_code": retailer.outletCode,
                    "sku_id": skuId,
                    "unit_price": preorderInfo[preorderSttKey] != 0
                        ? preorderInfo[preorderPriceKey] /
                            preorderInfo[preorderSttKey]
                        : 0,
                    "volume": preorderInfo[preorderSttKey],
                    "total_price": preorderInfo[preorderPriceKey],
                    "date": preorderInfo[preorderSalesDateKey],
                    "order_datetime": preorderInfo[preorderSalesDateTimeKey]
                  };
                  preorderData.add(preorderForSku);
                });
              }
            });
          }
        }
      }

      if (withZeroSale == true) {
        List zeroSellList = OfflinePdaService().getUnsoldOutletData();
        if (zeroSellList.isNotEmpty) {
          List<String> idsList = [];

          String cleanStr =
              srInfo.sbuId.replaceAll(RegExp(r'[\[\]]'), ''); // Remove brackets
          int sbuId = int.parse(cleanStr);

          for (var val in zeroSellList) {
            if (!idsList.contains(val[outletIdUnsoldOutletKey])) {
              idsList.add(val[outletIdUnsoldOutletKey].toString());
              if (retailer.outletCode == val[zeroSaleOutletIdKey]) {
                preorderData.add({
                  "sbu_id": sbuId,
                  "dep_id": val[zeroSaleDepIdKey],
                  "ff_id": val[zeroSaleFFIdKey],
                  "section_id": val[zeroSaleSectionIdKey],
                  "outlet_id": val[zeroSaleOutletIdKey],
                  "outlet_code": val[outletCodeUnsoldOutletKey],
                  "sku_id": "0",
                  "unit_price": 0.0,
                  "volume": 0,
                  "total_price": 0.0,
                  "date": val[dateUnsoldOutletKey],
                  "order_datetime": val[dateTimeUnsoldOutletKey],
                });
              }
            }
          }
        }
      }
    } catch (e) {
      Helper.dPrint(
          "inside getPreorderDataToSendToApi salesServices catch block $e");
    }
    return preorderData;
  }

  //fetching geoData to send to server
  Future<List> getGeoDataToSendToApi(OutletModel retailer) async {
    List geoData = [];
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(geoDataKey)) {
        if (syncObj[geoDataKey].containsKey(retailer.id.toString())) {
          if (syncObj[geoDataKey][retailer.id.toString()].isNotEmpty) {
            geoData = syncObj[geoDataKey][retailer.id.toString()];
          }
        }
      }
    } catch (e) {
      Helper.dPrint(
          "inside geoGeoDataToSendToApi salesServices catch block $e");
    }
    return geoData;
  }

  saveAllCouponToSync(
    OutletModel retailer,
    CouponModel coupon,
    num couponDiscountAmount,
  ) async {
    try {
      await _syncService.checkSyncVariable();
      if (!syncObj.containsKey(couponDataKey)) {
        syncObj[couponDataKey] = {};
      }

      if (!syncObj[couponDataKey].containsKey(retailer.id.toString())) {
        syncObj[couponDataKey][retailer.id.toString()] = {};
      }
      syncObj[couponDataKey][retailer.id.toString()][coupon.id.toString()] = [];
      syncObj[couponDataKey][retailer.id.toString()][coupon.id.toString()].add({
        "id": coupon.id,
        "code": coupon.code,
        "discType": PayableTypeUtils.toStr(coupon.discType),
        "applicableFor": DiscountTypeUtils.toStr(coupon.applicableFor),
        "discountValue": coupon.discountValue,
        "achievedAmount": couponDiscountAmount,
      });
    } catch (e, t) {
      Helper.dPrint(
          "inside savePreorderDataToSync salesServices catch block $e");
      Helper.dPrint("$t");
    }
  }

  //fetching geoData to send to server
  Future<List> getCouponDataToSendToApi(
      OutletModel retailer, CouponModel coupon) async {
    List couponsData = [];
    try {
      await _syncService.checkSyncVariable();
      SrInfoModel srInfo = await _syncReadService.getSrInfo();
      String salesDate = await _syncReadService.getSalesDate();

      if (syncObj.containsKey(couponDataKey)) {
        if (syncObj[couponDataKey].containsKey(retailer.id.toString())) {
          Map allCouponsData = syncObj[couponDataKey][retailer.id.toString()];
          allCouponsData.forEach((key, value) {
            if (key.toString() == coupon.id.toString()) {
              Map targetedCouponData = value.last;
              Map singlePromotion = {
                "sbu_id": 1,
                "dep_id": srInfo.depId,
                "section_id": srInfo.sectionId,
                "ff_id": srInfo.ffId,
                "outlet_id": retailer.id,
                "outlet_code": retailer.outletCode,
                "date": salesDate,
                "coupon_id": coupon.id,
                "volume": 0,
                "value": targetedCouponData["achievedAmount"],
              };
              couponsData.add(singlePromotion);
            }
          });
        }
      }
    } catch (e, t) {
      Helper.dPrint(
          "inside geoGeoDataToSendToApi salesServices catch block $e");
      Helper.dPrint("${t.toString()}");
    }
    return couponsData;
  }

  Future<Map> getFormattedSaleData(
    OutletModel retailer,
    SaleType saleType, {
    CouponModel? coupon,
    bool withZeroSale = false,
  }) async {
    Map outletDataMap = {};
    try {
      //get Promotion data
      List promotionData = await getPromotionDataToSendToApi(retailer, saleType);
      if (promotionData.isNotEmpty) {
        outletDataMap["promotions"] = promotionData;
      }

      if (saleType == SaleType.preorder) {
        //get Survey Data
        List surveyData = await SurveyService().getSurveyDataForARetailer(retailer);
        if (surveyData.isNotEmpty) {
          outletDataMap["survey"] = surveyData;
        }
      }

      if (saleType == SaleType.delivery) {
        //get Qc Data
        List qcData = await getQCDataToSendToApi(retailer, saleType);
        if (qcData.isNotEmpty) {
          outletDataMap["qc"] = qcData;
        }

        if (saleType == SaleType.delivery) {
          outletDataMap["call_time"] = [await createCallTime(retailer)];
        }
      }

      if (saleType == SaleType.preorder) {
        //get Call time data
        List callTimeData = await getCallTimeDataForARetailer(retailer);
        if (callTimeData.isNotEmpty) {
          outletDataMap["call_time"] = callTimeData;
        }
      }

      // get preorder data
      String saleKeyInOutletData = SalesTypeUtils.toOutletDataSaleKey(saleType);
      List preorderData = await getPreorderDataToSendToApi(retailer, saleType,
          withZeroSale: withZeroSale);
      if (preorderData.isNotEmpty) {
        outletDataMap[saleKeyInOutletData] = preorderData;
      }

      if (saleType == SaleType.preorder) {
        List geoData = await getGeoDataToSendToApi(retailer);
        if (geoData.isNotEmpty) {
          outletDataMap["geo_data"] = geoData;
        }
      }

      List stockCheckData = await StockCheckService().getStockCheckDataDataToSendToApi(retailer);
      if (stockCheckData.isNotEmpty) {
        outletDataMap["stock_check_data"] = stockCheckData;
      }

      ///coupon data
      if (coupon != null) {
        List couponData = await getCouponDataToSendToApi(retailer, coupon);
        print('---> $couponData');
        if (couponData.isNotEmpty) {
          outletDataMap["coupons"] = couponData;
        }
      }

      if (saleType == SaleType.preorder) {
        List posmData = [];
        posmData =
            await PosmManagementService().havePosmData(retailer: retailer);

        if (posmData.isNotEmpty) {
          outletDataMap["posm"] = posmData;
        }
      }

      //get outlet stock count data
      List outletStockCountData =
          await getOutletStockCountDataToSendToApi(retailer: retailer);
      outletDataMap["outlet_stock_count"] = outletStockCountData;
    } catch (e) {
      Helper.dPrint("inside getFormattedSaleData salesServices catch block $e");
    }

    return outletDataMap;
  }

//format sales for submitting to the backend sales api
  Future<ReturnedDataModel?> getFormattedSalesDataToSendToApi(
      OutletModel retailer, SaleType saleType, CouponModel? coupon,
      {bool withZeroSale = false}) async {
    try {
      String salesDate = await _syncReadService.getSalesDate();
      SrInfoModel srInfo = await _syncReadService.getSrInfo();
      Map finalMap = {
        "outlet_id": retailer.id,
        "outlet_code": retailer.outletCode,
        "date": salesDate,
        "section_id": srInfo.sectionId,
        "ff_id": srInfo.ffId,
        "outlet_data": {},
      };
      Map outletDataMap = await getFormattedSaleData(retailer, saleType,
          coupon: coupon, withZeroSale: withZeroSale);
      finalMap['outlet_data'] = outletDataMap;

      //checks if device log is sent.has no connection with sale data
      // await DeviceInfoService().sendDeviceInfoIfDeviceInfoIsNotSent();

      //checks if device log is sent.has no connection with sale data
      Helper.dPrint("sale type $saleType");
      await DeviceInfoService().sendDeviceInfoIfDeviceInfoIsNotSent();
      String url = Links.saveSalesDataUrl;
      switch (saleType) {
        case SaleType.preorder:
          url = Links.saveSalesDataUrl;
        case SaleType.delivery:
          url = Links.saveDeliveryDataUrl;
        case SaleType.spotSale:
          url = Links.saveSpotSaleDataUrl;
      }

      ///TODO Delivery data saved
      if (saleType == SaleType.delivery) {
        Map overallStock =
            await getPayloadForCheckStock(preorderData: finalMap);
        log('overall stock is:::: ${jsonEncode(overallStock)}');
        if (overallStock.isNotEmpty) {
          finalMap["outlet_data"]["sales_summary"] = overallStock;
        }
      }
      log(jsonEncode(finalMap));
      ReturnedDataModel returnedDataModel = await GlobalHttp(
              httpType: HttpType.post,
              uri: '${Links.baseUrl}$url',
              accessToken: srInfo.accessToken,
              refreshToken: srInfo.refreshToken,
              body: jsonEncode(finalMap))
          .fetch();
      if (returnedDataModel.status != ReturnedStatus.success) {
        return returnedDataModel;
      }
    } catch (e, s) {
      Helper.dPrint("inside getFormattedSalesDataToSendToApi catch block $e");
      Helper.dPrint("inside getFormattedSalesDataToSendToApi catch block $s");
    }
  }

  Future<List> getPromotionDataToSendToApi(
      OutletModel retailer, SaleType saleType) async {
    List promotionData = [];
    try {
      String promotionKey = SalesTypeUtils.toPromotionSaveKey(saleType);
      await _syncService.checkSyncVariable();
      SrInfoModel srInfo = await _syncReadService.getSrInfo();
      String salesDate = await _syncReadService.getSalesDate();
      if (syncObj.containsKey(promotionKey)) {
        if (syncObj[promotionKey].containsKey(retailer.id.toString())) {
          Map promotionInfos = syncObj[promotionKey][retailer.id.toString()];
          if (promotionInfos.isNotEmpty) {
            for (var promotionId in promotionInfos.keys) {
              var values = promotionInfos[promotionId];
              var promotion = syncObj['promotions'][promotionId];

              if (values.isNotEmpty) {
                PayableType payableType = PayableTypeUtils.toType(
                    values[promotionDataPayableTypeKey]);

                List allSkusId =
                    values[promotionDataDiscountSkusKey].keys.toList();
                num skusDiscountAmount = 0;
                num discountAmount = values[promotionDataDiscountAmountKey];

                for (var val in allSkusId) {
                  skusDiscountAmount += values[promotionDataDiscountSkusKey]
                      [val.toString()][promotionDataDiscountAmountKey];
                }

                log('check data  payableType:: ${payableType} skusDiscountAmount:${skusDiscountAmount} discountAmount:$discountAmount');

                bool isFractional = false;

                if (syncObj.containsKey('promotions')) {
                  var promos = syncObj['promotions'];
                  if (promos.containsKey(promotionId)) {
                    var promo = promos[promotionId];
                    if (promo.containsKey('is_fractional')) {
                      if (promo['is_fractional'] == 1) {
                        isFractional = true;
                      }
                    }
                  }
                }

                if (isFractional == true) {
                  try {
                    num volume = 0;

                    values[promotionDataDiscountSkusKey].forEach((key, value) {
                      volume += value[
                          promotionDataDiscountAmountKey]; // wrong key removed
                    });

                    Map singlePromotion = {
                      "sbu_id": promotion[sbuIdUnsoldOutletKey],
                      "dep_id": srInfo.depId,
                      "section_id": srInfo.sectionId,
                      "ff_id": srInfo.ffId,
                      "outlet_id": retailer.id,
                      "outlet_code": retailer.outletCode,
                      "date": salesDate,
                      "promotion_id": promotionId,
                      "volume": 0, //pcs
                      "value": values[promotionDataDiscountAmountKey],
                    };

                    Map singlePromotion2 = {
                      "sbu_id": promotion[sbuIdUnsoldOutletKey],
                      "dep_id": srInfo.depId,
                      "section_id": srInfo.sectionId,
                      "ff_id": srInfo.ffId,
                      "outlet_id": retailer.id,
                      "outlet_code": retailer.outletCode,
                      "date": salesDate,
                      "promotion_id": promotionId,
                      "volume": volume, //pcs
                      "value": 0, //case
                    };
                    if (values[promotionDataDiscountAmountKey] != 0) {
                      promotionData.add(singlePromotion);
                    }
                    if (volume != 0) {
                      promotionData.add(singlePromotion2);
                    }
                  } catch (e, t) {
                    log(e.toString());
                    log(t.toString());
                  }
                } else {
                  Map singlePromotion = {
                    "sbu_id": promotion[sbuIdUnsoldOutletKey],
                    "dep_id": srInfo.depId,
                    "section_id": srInfo.sectionId,
                    "ff_id": srInfo.ffId,
                    "outlet_id": retailer.id,
                    "outlet_code": retailer.outletCode,
                    "date": salesDate,
                    "promotion_id": promotionId,
                    "volume": payableType == PayableType.productDiscount ||
                            payableType == PayableType.gift
                        ? values[promotionDataDiscountAmountKey].toInt()
                        : 0,
                    "value": payableType == PayableType.absoluteCash ||
                            payableType == PayableType.percentageOfValue
                        ? values[promotionDataDiscountAmountKey]
                        : 0
                  };
                  promotionData.add(singlePromotion);
                }
              }
            }
          }
        }
      }
    } catch (e, t) {
      Helper.dPrint(
          "inside getPromotionDataToSendToApi salesServices catch block $e $t");
    }

    return promotionData;
  }

  Future<int> getTotalRetailer({required SaleType saleType}) async {
    int total = 0;
    try {
      await _syncService.checkSyncVariable();

      final dataKey = saleType == SaleType.preorder ? preorderKey: saleType == SaleType.delivery ? deliveryKey : spotSaleKey;

      // log(jsonEncode(syncObj));
      if (syncObj.containsKey(dataKey)) {
        if (syncObj[dataKey].isNotEmpty) {
          total = syncObj[dataKey].length;
        }
      }
    } catch (e) {
      Helper.dPrint(
          "inside sales summary Services total retailer catch block $e");
    }
    return total;
  }

  /// ============================================== QC sync read service ===========================================
  Future<List<QCInfoModel>> getQCInfo(String moduleID) async {
    print("Module id is::: ${moduleID}");
    try {
      await _syncService.checkSyncVariable();
      List<QCInfoModel> qcInfoList = [];

      for (Map<String, dynamic> json in syncObj['qc_info'][moduleID]) {
        QCInfoModel qcInfo = QCInfoModel.fromJson(json);
        qcInfoList.add(qcInfo);
      }
      return qcInfoList;
    } catch (e, t) {
      Helper.dPrint(e.toString());
      Helper.dPrint(t.toString());
      return [];
    }
  }

  Future<QcConfigurationModel> getQcConfigurations() async {
    QcConfigurationModel conf =
        QcConfigurationModel(qcEnabled: false, availableModules: []);
    try {
      await _syncService.checkSyncVariable();
      Helper.dPrint("qc info available ${syncObj["qc_info"]}");
      if (syncObj.containsKey("qc_info")) {
        if (syncObj["qc_info"].isNotEmpty) {
          Map qcInfo = syncObj["qc_info"];
          List availableModule =
              qcInfo.keys.map((e) => int.parse(e.toString())).toList();
          conf.qcEnabled = true;
          conf.availableModules = availableModule;
        }
      }
    } catch (e) {
      Helper.dPrint("inside getQcConfigurations salesServices catch block $e");
    }

    return conf;
  }

  /// ===================================== Sales Summary ====================================

  Future<Map<String, List<SalesSummaryModel>>> getSalesSummaryData({required SaleType saleType}) async {
    try {
      await _syncService.checkSyncVariable();

      final dataKey = saleType == SaleType.preorder ? preorderKey: saleType == SaleType.delivery ? deliveryKey : spotSaleKey;

      Map<String, List<SalesSummaryModel>> saleSummaryData = {};
      List<SalesSummaryModel> summaryList = [];
      Map<String, SalesSummaryModel> uniqueSKU = {};
      if (syncObj.containsKey(dataKey)) {
        if (syncObj[dataKey].isNotEmpty) {
          for (var retailerID in syncObj[dataKey].keys) {
            var moduleVal = syncObj[dataKey][retailerID];
            if (moduleVal.isNotEmpty) {
              for (var moduleKey in moduleVal.keys) {
                var skuValue = moduleVal[moduleKey];

                Module module = Module.fromJson(syncObj['modules'][moduleKey]);
                ProductCategoryModel? skuCategory =
                    await ProductCategoryServices()
                        .getCategoryModelOfSkuForAModule(
                            int.parse(moduleKey.toString()));
                if (skuCategory != null) {
                  skuValue.forEach((skuID, salesSummaryValue) {

                    final skuUnitConfig = _productCategoryServices.getSkuUnitConfigBySkuId(skuId: skuID);
                    if (uniqueSKU.containsKey(skuID)) {
                      uniqueSKU[skuID.toString()]?.stt +=
                          salesSummaryValue['stt'] as int;
                      uniqueSKU[skuID.toString()]?.price +=
                          salesSummaryValue['price'].toDouble();
                      uniqueSKU[skuID]?.memo += 1;
                    } else {
                      String increasedId = '';
                      syncObj['modules'][module.id.toString()]['units']
                          .forEach((key, value) {
                        if (value['is_primary'] == 1) {
                          increasedId = value['increase_id'].toString();
                          return;
                        }
                      });
                      ProductDetailsModel productsDetails =
                          ProductDetailsModel.fromJson(
                              syncObj["cats"][moduleKey]
                                  [skuCategory.id.toString()][skuID],
                              "dfskjhksjd", unitConfiguration: skuUnitConfig,
                          increasedId);
                      productsDetails.setModule(module);
                      SalesSummaryModel salesSummary =
                          SalesSummaryModel.fromJson(salesSummaryValue);
                      salesSummary.setSKU(productsDetails);
                      salesSummary.memo += 1;
                      summaryList.add(salesSummary);
                      if (!saleSummaryData.containsKey(module.id.toString())) {
                        saleSummaryData[module.id.toString()] = [];
                      }
                      saleSummaryData[module.id.toString()]!.add(salesSummary);
                      uniqueSKU[skuID] = salesSummary;
                    }
                  });
                }
              }
            }
          }
        }
      }

      //sort sales summary

      if (saleSummaryData.isNotEmpty) {
        for (MapEntry s in saleSummaryData.entries) {
          List<SalesSummaryModel> summary = s.value;
          summary.sort((a, b) => a.sku.sort.compareTo(b.sku.sort));
          saleSummaryData[s.key] = summary;
        }
      }

      return saleSummaryData;
      // return summaryList;
    } catch (e, s) {
      Helper.dPrint("inside sales summary Services catch block $e $s");
      return {};
    }
  }

  Future<bool> checkIfSaleEditAlreadyDoneForARetailer(int retailerId) async {
    bool editDone = false;
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(preorderActivityKey)) {
        if (syncObj[preorderActivityKey].containsKey(retailerId.toString())) {
          List saleActivities =
              syncObj[preorderActivityKey][retailerId.toString()];
          if (saleActivities.isNotEmpty) {
            for (var saleActivity in saleActivities) {
              if (saleActivity.containsKey(preorderTypeKey)) {
                if (saleActivity[preorderTypeKey] == "edited") {
                  editDone = true;
                }
              }
            }
          }
        }
      }
    } catch (e) {
      Helper.dPrint(
          "inside checkIfSaleEditAlreadyDoneForARetailer SaleServices catch block $e");
    }
    return editDone;
  }

  Future<List<GeneralIdSlugModel>> getUnsoldNoButtonsList() async {
    List<GeneralIdSlugModel> list = [];
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("outlet_unsold_no_button_info")) {
        if (syncObj["outlet_unsold_no_button_info"].isNotEmpty) {
          for (Map unsoldData in syncObj["outlet_unsold_no_button_info"]) {
            list.add(GeneralIdSlugModel.fromJson(unsoldData));
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint(
          "inside getUnsoldNoButtonsList SaleServices catch block $e $s");
    }
    return list;
  }

  Future<bool> checkUnsoldInfoExist() async {
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("outlet_unsold_no_button_info")) {
        return syncObj["outlet_unsold_no_button_info"].isEmpty;
      }
    } catch (e, s) {
      Helper.dPrint(
          "inside checkUnsoldInfoExist SaleServices catch block $e $s");
    }
    return true;
  }

  saveUnsoldOutletData(SrInfoModel sr, OutletModel outlet, DateTime time,
      GeneralIdSlugModel unsoldInfo, String image, Map geoData) async {
    try {
      Helper.dPrint('unused id is::: ${unsoldInfo.id} : ${unsoldInfo.slug}');
      await _syncService.checkSyncVariable();

      String cleanStr =
          sr.sbuId.replaceAll(RegExp(r'[\[\]]'), ''); // Remove brackets
      Map payload = {
        sbuIdUnsoldOutletKey: int.tryParse(cleanStr),
        depIdUnsoldOutletKey: sr.depId,
        ffIdUnsoldOutletKey: sr.ffId,
        sectionIdUnsoldOutletKey: outlet.sectionId,
        outletIdUnsoldOutletKey: outlet.id,
        outletCodeUnsoldOutletKey: outlet.outletCode,
        dateUnsoldOutletKey: apiDateFormat.format(time),
        reasonUnsoldOutletKey: unsoldInfo.slug,
        // reasonUnsoldOutletIdKey: unsoldInfo.id,
        imageUnsoldOutletKey: image,
        dateTimeUnsoldOutletKey: apiDateTimeFormat.format(time)
      };
      if (!syncObj.containsKey(unsoldOutletKey)) {
        syncObj[unsoldOutletKey] = [];
      }
      syncObj[unsoldOutletKey].add(payload);

      await saveCallTime(outlet);
      await saveGeoDataToSync(outlet, geoData);

      await _syncService.writeSync();
      sendUnsoldDatToServer(payload, sr);

      ///todo call sales data api with data after zero sales
      getFormattedSalesDataToSendToApi(outlet, SaleType.preorder, null,
          withZeroSale: true);
    } catch (e, s) {
      Helper.dPrint(
          "inside saveUnsoldOutletData SaleServices catch block $e $s");
    }
  }

  sendUnsoldDatToServer(Map payload, SrInfoModel sr) async {
    try {
      Map body = {
        unsoldOutletKey: [payload]
      };
      await GlobalHttp(
              httpType: HttpType.post,
              uri: "${Links.baseUrl}${Links.sendUnsoldOutletDataUrl}",
              accessToken: sr.accessToken,
              refreshToken: sr.refreshToken,
              body: jsonEncode(body))
          .fetch();
    } catch (e, s) {
      Helper.dPrint(
          "inside sendUnsoldDatToServer SaleServices catch block $e $s");
    }
  }

  Future<Map> checkThisDeliveryDataValidateWithServerAvailableStock({
    required OutletModel retailer,
    required List<AppliedDiscountModel> appliedDiscounts,
    required Map preorderData,
    required Map qcData,
  }) async {
    try {
      SrInfoModel srInfo = await _syncReadService.getSrInfo();
      String cleanStr =
          srInfo.sbuId.replaceAll(RegExp(r'[\[\]]'), ''); // Remove brackets
      int sbuId = int.parse(cleanStr); // Convert to integer
      Map finalMap = {
        "outlet_id": retailer.id,
        "outlet_code": retailer.outletCode,
        "section_id": retailer.sectionId,
        "dep_id": retailer.deplId,
        "date": syncObj[deviceLogDateKey],
        "sbu_id": sbuId
      };

      Map preOrderList = {};

      Map preorderDataForARetailer = preorderData;
      if (preorderDataForARetailer.isNotEmpty) {
        preorderDataForARetailer.forEach((moduleId, preorderDataMap) {
          if (preorderDataMap.isNotEmpty) {
            preorderDataMap.forEach((skuId, preorderInfo) {
              if (preOrderList.containsKey(skuId)) {
                Map preorderForSku = {
                  "sku_id": skuId,
                  "volume": preorderInfo["volume"] +
                      preOrderList[skuId][preorderSttKey],
                };

                preOrderList[skuId] = preorderForSku;
              } else {
                preOrderList[skuId] = {
                  "sku_id": skuId,
                  "volume": preorderInfo[preorderSttKey],
                };
              }
            });
          }
        });
      }

      Map qcDataForARetailer = qcData;
      if (qcDataForARetailer.isNotEmpty) {
        qcDataForARetailer.forEach((moduleId, preorderDataMap) {
          if (preorderDataMap.isNotEmpty) {
            preorderDataMap.forEach((skuId, preorderInfo) {
              for (var data in preorderInfo) {
                if (preOrderList.containsKey(skuId)) {
                  Map preorderForSku = {
                    "sku_id": skuId,
                    "volume": data["volume"] + preOrderList[skuId]["volume"],
                  };

                  preOrderList[skuId] = preorderForSku;
                } else {
                  preOrderList[skuId] = {
                    "sku_id": skuId,
                    "volume": data["volume"],
                  };
                }
              }
            });
          }
        });
      }

      for (var val in appliedDiscounts) {
        for (var v in val.skuWiseAppliedDiscountAmount) {
          // num discountAmount = val.promotion.payableType == PayableType.productDiscount ? (v.discountAmount ?? 0) : 0;
          if (val.promotion.payableType == PayableType.productDiscount) {
            if (preOrderList.containsKey(v.skuId.toString())) {
              Map preorderForSku = {
                "sku_id": v.skuId.toString(),
                "volume": (v.discountAmount ?? 0) +
                    preOrderList[v.skuId.toString()]["volume"],
              };

              preOrderList[v.skuId.toString()] = preorderForSku;
            } else {
              preOrderList[v.skuId.toString()] = {
                "sku_id": v.skuId.toString(),
                "volume": v.discountAmount,
              };
            }
          }
        }
      }

      List finalPreorderList = [];

      preOrderList.forEach((key, value) {
        finalPreorderList.add({
          "sku_id": key,
          "volume": value["volume"],
        });
      });

      finalMap['pre_order'] = finalPreorderList;

      log('sales data is:::: ${jsonEncode(finalMap)}');

      return finalMap;
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
      return {};
    }
  }

  Future<List> createThisDeliverySkuValidateList({
    required List<AppliedDiscountModel> appliedDiscounts,
    required Map preorderData,
  }) async {
    try {
      SrInfoModel srInfo = await _syncReadService.getSrInfo();
      String cleanStr =
          srInfo.sbuId.replaceAll(RegExp(r'[\[\]]'), ''); // Remove brackets
      int sbuId = int.parse(cleanStr); // Convert to integer

      Map preOrderList = {};

      Map preorderDataForARetailer = preorderData;
      if (preorderDataForARetailer.isNotEmpty) {
        preorderDataForARetailer.forEach((moduleId, preorderDataMap) {
          if (preorderDataMap.isNotEmpty) {
            preorderDataMap.forEach((skuId, preorderInfo) {
              if (preOrderList.containsKey(skuId)) {
                Map preorderForSku = {
                  "sku_id": skuId,
                  "volume": preorderInfo["volume"] +
                      preOrderList[skuId][preorderSttKey],
                };

                preOrderList[skuId] = preorderForSku;
              } else {
                preOrderList[skuId] = {
                  "sku_id": skuId,
                  "volume": preorderInfo[preorderSttKey],
                };
              }
            });
          }
        });
      }

      for (var val in appliedDiscounts) {
        for (var v in val.skuWiseAppliedDiscountAmount) {
          if (val.promotion.payableType == PayableType.productDiscount) {
            if (preOrderList.containsKey(v.skuId.toString())) {
              Map preorderForSku = {
                "sku_id": v.skuId.toString(),
                "volume": (v.discountAmount ?? 0) +
                    preOrderList[v.skuId.toString()]["volume"],
              };

              preOrderList[v.skuId.toString()] = preorderForSku;
            } else {
              preOrderList[v.skuId.toString()] = {
                "sku_id": v.skuId.toString(),
                "volume": v.discountAmount,
              };
            }
          }
        }
      }

      List finalPreorderList = [];

      preOrderList.forEach((key, value) {
        finalPreorderList.add({
          "sku_id": key,
          "volume": value["volume"],
        });
      });

      return finalPreorderList;
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
      return [];
    }
  }

  Future<Map> allSkuValidateList(
      {required List<OutletModel> outletList, required WidgetRef ref}) async {
    try {
      SrInfoModel srInfo = await _syncReadService.getSrInfo();
      String cleanStr =
          srInfo.sbuId.replaceAll(RegExp(r'[\[\]]'), ''); // Remove brackets
      String salesDate = await FFServices().getSalesDate();
      int sbuId = int.parse(cleanStr); // Convert to integer
      Map finalMap = {
        "dep_id": srInfo.depId,
        "date": salesDate,
        "sbu_id": sbuId
      };

      Map modules = await SyncReadService().getModuleList();
      Module? m = await ProductCategoryServices().getModuleModelFromModuleId(
          int.tryParse(modules.keys.toList()[0]) ?? 1);

      List<ProductDetailsModel> productList =
          await ProductCategoryServices().getProductDetailsList(m!);

      Map<int, ProductDetailsModel> discountRelatedSkuInformation = {};
      for (ProductDetailsModel sku in productList) {
        discountRelatedSkuInformation[sku.id] = sku;
      }

      List allSkuList = [];

      for (var outlet in outletList) {
        Map moduleWiseData = await DeliveryServices().formatRetailers(
            outlet, modules, discountRelatedSkuInformation, ref);

        List newSku = await createThisDeliverySkuValidateList(
          appliedDiscounts: moduleWiseData['discountData'],
          preorderData: moduleWiseData['moduleWiseData'],
        );

        List pre = [...newSku];

        for (var val in newSku) {
          int index = allSkuList
              .indexWhere((e) => e["sku_id"] == val["sku_id"].toString());
          if (index == -1) {
            allSkuList.add(val);
          } else {
            var prev = allSkuList[index];
            allSkuList[index] = {
              "sku_id": val["sku_id"],
              "volume": prev["volume"] + val["volume"],
            };
          }
        }
      }

      finalMap['pre_order'] = allSkuList;

      log('{{{{}}}}> >:: ${jsonEncode(finalMap)}');
      return finalMap;
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
      return {};
    }
  }

  Future<Map> getPayloadForCheckStock({
    required Map preorderData,
  }) async {
    try {
      SrInfoModel srInfo = await _syncReadService.getSrInfo();
      String cleanStr =
          srInfo.sbuId.replaceAll(RegExp(r'[\[\]]'), ''); // Remove brackets
      String salesDate = await FFServices().getSalesDate();
      int sbuId = int.parse(cleanStr); // Convert to integer
      Map finalMap = {
        "dep_id": srInfo.depId,
        "date": salesDate,
        "sbu_id": sbuId
      };

      List finalPreorderList = [];

      if (preorderData["outlet_data"].containsKey("qc")) {
        for (var qc in preorderData["outlet_data"]["qc"] ?? []) {
          int index =
              finalPreorderList.indexWhere((e) => e["sku_id"] == qc["sku_id"]);

          if (index == -1) {
            finalPreorderList.add({
              "sku_id": qc["sku_id"],
              "volume": qc["volume"],
            });
          } else {
            var existingData = finalPreorderList[index];
            existingData["volume"] += qc["volume"];
            finalPreorderList[index] = existingData;
          }
        }
      }

      if (preorderData["outlet_data"].containsKey("sales")) {
        for (var qc in preorderData["outlet_data"]["sales"] ?? []) {
          int index =
              finalPreorderList.indexWhere((e) => e["sku_id"] == qc["sku_id"]);

          if (index == -1) {
            finalPreorderList.add({
              "sku_id": qc["sku_id"],
              "volume": qc["volume"],
            });
          } else {
            var existingData = finalPreorderList[index];
            existingData["volume"] += qc["volume"];
            finalPreorderList[index] = existingData;
          }
        }
      }

      if (preorderData["outlet_data"].containsKey("promotions")) {
        for (var promotion in preorderData["outlet_data"]["promotions"] ?? []) {
          PromotionModel? promotionDetails = PromotionServices()
              .getPromotionsDetailsFromPromotionId(promotion["promotion_id"]);
          if (promotionDetails != null) {
            if (promotionDetails.payableType == PayableType.productDiscount) {
              int index = finalPreorderList.indexWhere((e) =>
                  e["sku_id"] ==
                  promotionDetails.discountSkus.first.skuId.toString());

              if (index == -1) {
                finalPreorderList.add({
                  "sku_id":
                      promotionDetails.discountSkus.first.skuId.toString(),
                  "volume": promotion["volume"],
                });
              } else {
                var existingData = finalPreorderList[index];
                existingData["volume"] += promotion["volume"];
                finalPreorderList[index] = existingData;
              }
            }
          }
        }
      }

      // preOrderList.forEach((key, value) {
      //   finalPreorderList.add({
      //     "sku_id": key,
      //     "volume": value["volume"],
      //   });
      // });

      finalMap['pre_order'] = finalPreorderList;

      return finalMap;
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
      return {};
    }
  }

  Future<ReturnedDataModel?> isStockAvailableApi(Map finalMap) async {
    try {
      String salesDate = await _syncReadService.getSalesDate();
      SrInfoModel srInfo = await _syncReadService.getSrInfo();

      String url = Links.checkStockUrl;
      log(jsonEncode(finalMap));
      ReturnedDataModel returnedDataModel = await GlobalHttp(
        httpType: HttpType.post,
        uri: '${Links.baseUrl}$url',
        accessToken: srInfo.accessToken,
        refreshToken: srInfo.refreshToken,
        body: jsonEncode(finalMap),
      ).fetch();
      return returnedDataModel;
    } catch (e, s) {
      Helper.dPrint("inside getFormattedSalesDataToSendToApi catch block $e");
      Helper.dPrint("inside getFormattedSalesDataToSendToApi catch block $s");
    }
    return null;
  }

  Future<ReturnedDataModel?> isStockAvailableForBulkApi(Map finalMap) async {
    try {
      String salesDate = await _syncReadService.getSalesDate();
      SrInfoModel srInfo = await _syncReadService.getSrInfo();

      String url = Links.checkStockForBulkUrl;
      log(jsonEncode(finalMap));
      ReturnedDataModel returnedDataModel = await GlobalHttp(
        httpType: HttpType.post,
        uri: '${Links.baseUrl}$url',
        accessToken: srInfo.accessToken,
        refreshToken: srInfo.refreshToken,
        body: jsonEncode(finalMap),
      ).fetch();
      return returnedDataModel;
    } catch (e, s) {
      Helper.dPrint("inside getFormattedSalesDataToSendToApi catch block $e");
      Helper.dPrint("inside getFormattedSalesDataToSendToApi catch block $s");
    }
    return null;
  }

  Future saveRetailerPromotionData({
    required OutletModel retailer,
    required Map newPromotionDataForRetailer,
  }) async {
    try {
      int index = syncObj["retailers"]
          .indexWhere((element) => element["id"] == retailer.id);

      List<Map> pro = [];
      newPromotionDataForRetailer.forEach((key, value) {
        pro.add(value);
      });

      syncObj['retailers'][index]['available_promotions'] = pro;
      await _syncService.writeSync(jsonEncode(syncObj));
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
  }

  double getTotalSalePriceForARetailer(int retailerId) {
    double totalSalePrice = -1;
    try {
      if (syncObj.containsKey(totalSaleSummaryForRetailerKey)) {
        if (syncObj[totalSaleSummaryForRetailerKey]
            .containsKey(retailerId.toString())) {
          totalSalePrice = syncObj[totalSaleSummaryForRetailerKey]
              [retailerId.toString()][totalSalePriceKey];
        }
      }
    } catch (e) {
      print(
          "inside getTotalSalePriceForARetailer salesServices catch block $e");
    }
    return totalSalePrice;
  }

  Future<List> getOutletStockCountDataToSendToApi(
      {required OutletModel retailer}) async {
    List outletStockCountData = [];
    String saleDate = await _syncReadService.getSalesDate();
    try {
      await _syncService.checkSyncVariable();
      SrInfoModel srInfo = await _syncReadService.getSrInfo();
      if (syncObj.containsKey(outletStockCountKey)) {
        if (syncObj[outletStockCountKey].containsKey(retailer.id.toString())) {
          Map saleDataForARetailer =
              syncObj[outletStockCountKey][retailer.id.toString()];
          if (saleDataForARetailer.isNotEmpty) {
            for (MapEntry moduleWiseItem in saleDataForARetailer.entries) {
              int moduleId = int.parse(moduleWiseItem.key.toString());
              Map moduleWiseDataMap = moduleWiseItem.value;
              for (MapEntry skuWiseItem in moduleWiseDataMap.entries) {
                Map stockForSku = {
                  "sbu_id": moduleId,
                  "dep_id": srInfo.depId,
                  "ff_id": srInfo.ffId,
                  "section_id": srInfo.sectionId,
                  "outlet_id": retailer.id,
                  "outlet_code": retailer.outletCode,
                  "sku_id": skuWiseItem.key,
                  "damage": skuWiseItem.value['damage'],
                  "quantity": skuWiseItem.value['stock'],
                  'date': saleDate,
                };
                outletStockCountData.add(stockForSku);
              }
            }
          }
        }
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }

    return outletStockCountData;
  }

  Future<void> saveOutletStockCountToServer({
    required OutletModel retailer,
  }) async {
    List outletStockCountData = await getOutletStockCountDataToSendToApi(
      retailer: retailer,
    );
    SrInfoModel srInfo = await _syncReadService.getSrInfo();
    await GlobalHttp(
      httpType: HttpType.post,
      uri: '${Links.baseUrl}${Links.outletStockCountUrl}',
      accessToken: srInfo.accessToken,
      refreshToken: srInfo.refreshToken,
      body: jsonEncode(outletStockCountData),
    ).fetch();
  }



  Future<bool> doCheckoutAndSendDataToServer({OutletModel? retailer}) async {
    try {
      await _syncService.checkSyncVariable();
      bool saved = await _saveCheckoutToSyncFile(retailer: retailer);

      List checkoutData = await _getCheckoutToSyncFile(retailer: retailer);

      final payload = {
        "outlet_checkout": checkoutData
      };

      SrInfoModel srInfo = await _syncReadService.getSrInfo();
      ReturnedDataModel returned = await GlobalHttp(
          httpType: HttpType.post,
          uri: '${Links.baseUrl}${Links.checkoutFromSales}',
          accessToken: srInfo.accessToken,
          refreshToken: srInfo.refreshToken,
          body: jsonEncode(payload))
          .fetch();

      return saved;
    } catch (e,t) {
      log(e.toString());
      log(t.toString());
    }
    return false;
  }

  Future<bool> _saveCheckoutToSyncFile({OutletModel? retailer}) async {
    try {
      await _syncService.checkSyncVariable();
      final srInfo = await _syncReadService.getSrInfo();
      String salesDate = await _syncReadService.getSalesDate();
      final checkoutData = {
        "ff_id": srInfo.ffId,
        "sbu_id": srInfo.sbuId,
        "dep_id": srInfo.depId,
        "section_id": srInfo.sectionId,
        "outlet_id": retailer?.id,
        "outlet_code": retailer?.outletCode,
        "date": salesDate,
        "checkout_datetime": DateTime.now().toString(),
      };

      if (!syncObj.containsKey("checkout-data")) {
        syncObj["checkout-data"] = {};
      }
      if (!syncObj["checkout-data"].containsKey(retailer?.id.toString())) {
        syncObj["checkout-data"][retailer?.id.toString()] = [];
      }
      syncObj["checkout-data"][retailer?.id.toString()].add(checkoutData);

      ///update the sync file
      await _syncService.writeSync(jsonEncode(syncObj));
    } catch (e,t) {
      log(e.toString());
      log(t.toString());
    }
    return false;
  }

  Future<List> _getCheckoutToSyncFile({OutletModel? retailer}) async {
    try {
      await _syncService.checkSyncVariable();
      return syncObj["checkout-data"]?[retailer?.id.toString()]??[];
    } catch (e,t) {
      log(e.toString());
      log(t.toString());
    }
    return [];
  }
}
