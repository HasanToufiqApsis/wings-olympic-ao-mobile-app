import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:wings_olympic_sr/services/audit_searvice.dart';
import 'package:wings_olympic_sr/services/posm_management_service.dart';
import 'package:wings_olympic_sr/services/stock_service.dart';

import '../api/global_http.dart';
import '../api/links.dart';
import '../constants/constant_keys.dart';
import '../constants/enum.dart';
import '../constants/sync_global.dart';
import '../models/coupon/coupon_model.dart';
import '../models/outlet_model.dart';
import '../models/products_details_model.dart';
import '../models/returned_data_model.dart';
import '../models/sale_submit_table_model.dart';
import '../models/sr_info_model.dart';
import '../utils/promotion_utils.dart';
import '../utils/sales_type_utils.dart';
import 'before_sale_services/survey_service.dart';
import 'coupon_service.dart';
import 'delivery_services.dart';
import 'ff_services.dart';
import 'helper.dart';
import 'outlet_services.dart';
import 'price_services.dart';
import 'product_category_services.dart';
import 'sales_service.dart';
import 'sync_read_service.dart';
import 'sync_service.dart';

class OfflinePdaService {
  static final OfflinePdaService _offlinePdaService = OfflinePdaService._internal();

  factory OfflinePdaService() {
    return _offlinePdaService;
  }

  OfflinePdaService._internal();

  final SyncService _syncService = SyncService();
  final SyncReadService _syncReadService = SyncReadService();
  final CouponService couponService = CouponService();

  // final DashboardServices _dashboardServices = DashboardServices();
  final ProductCategoryServices _productCategoryServices = ProductCategoryServices();

  // final MemoService _memoService = MemoService();
  final PriceServices _priceServices = PriceServices();
  final SalesService _salesService = SalesService();
  final OutletServices _outletServices = OutletServices();
  final DeliveryServices _deliveryServices = DeliveryServices();

  late SrInfoModel srInfo;
  late String salesDate;

  /////=====================Formatting data for offline pda data ===============================================

  Future<Map> formatPdaData() async {
    await _syncService.checkSyncVariable();
    srInfo = await _syncReadService.getSrInfo();
    salesDate = await _syncReadService.getSalesDate();
    Map pda = {
      "sbu_id": srInfo.sbuId,
      "dep_id": srInfo.depId,
      "section_id": srInfo.sectionId,
      "ff_id": srInfo.ffId,
      "date": salesDate,
    };
    Map sectionOutletData = await formatBikroiJomaData();
    pda['section_data'] = sectionOutletData['section_data'];
    pda['outlet_data'] = sectionOutletData['outlet_data'];
    pda['survey'] = await getSurveyData();
    pda['call_time'] = await getCallTime();
    pda['qc'] = await getQc();
    // pda['promotions'] = await getPromotion();
    // pda['outlet_data'] = await getOutletData();
    pda['geo_data'] = await getGeoData();
    // pda['device_log'] = [await DeviceInfoService().getDeviceLog()];
    //
    // pda["firefly_new_outlet"] = await setNewOutletFirefly();
    // pda["firefly_close_outlet"] = await setCloseOutlet();
    // pda["firefly_modify_outlet"] = await setChangeOutlet();
    pda["lifting_stock"] = await setLiftingStock(srInfo, salesDate);
    pda["pre_order"] = await getPreorderData();
    // pda["scratch_card"] = await setScratchCardFromSync();
    // pda["digonto_analytic_alert"] = await getDigontoAnalyticData();
    return pda;
  }

  Future<List> setLiftingStock(SrInfoModel srInfo, String salesDate) async {
    List liftingStock = [];
    try {
      if (syncObj.containsKey("stock")) {
        syncObj["stock"].forEach((name, skuList) {
          skuList.forEach((id, val) {
            if (val.containsKey("lifting_stock") && val.containsKey("sbu_id") && val.containsKey("id")) {
              if (val["lifting_stock"] != 0) {
                liftingStock.add(
                    {"ff_id": srInfo.ffId, "sbu_id": val["sbu_id"], "dep_id": srInfo.depId, "section_id": srInfo.sectionId, "sku_id": val["id"], "quantity": val["lifting_stock"], "date": salesDate});
              }
            }
          });
        });
      }
    } catch (e, s) {
      Helper.dPrint("inside offline PDA service setChangeOutlet function error: $e $s");
    }
    return liftingStock;
  }

  Future<List> getSurveyData() async {
    List survey = [];

    if (syncObj.containsKey(surveyDataKey)) {
      Map surveyData = syncObj[surveyDataKey];
      if (surveyData.isNotEmpty) {
        surveyData.forEach((retailerId, surveyValue) async {
          OutletModel? retailer = await _syncReadService.getRetailerModelFromId(retailerId);
          if (retailer != null) {
            if (surveyValue.isNotEmpty) {
              surveyValue.forEach((surveyId, questionValue) {
                if (questionValue.isNotEmpty) {
                  questionValue.forEach((questionId, answerValue) {
                    if (answerValue.isNotEmpty) {
                      Map surveyAnswerMap = {
                        "sbu_id": srInfo.sbuId,
                        "survey_id": surveyId,
                        "dep_id": srInfo.depId,
                        "section_id": srInfo.sectionId,
                        "ff_id": srInfo.ffId,
                        "outlet_id": retailerId,
                        "outlet_code": retailer.outletCode,
                        "date": salesDate,
                        "question_id": questionId,
                        "answer_id": answerValue[surveyAnswerIdKey],
                        "answer": answerValue[surveyAnswerKey]
                      };
                      survey.add(surveyAnswerMap);
                    }
                  });
                }
              });
            }
          }
        });
      }
    }

    return survey;
  }

  Future<List> getCallTime() async {
    List callTime = [];
    if (syncObj.containsKey(callTimeKey)) {
      Map callTimeData = syncObj[callTimeKey];

      if (callTimeData.isNotEmpty) {
        callTimeData.forEach((retailerId, callValue) {
          if (callValue.isNotEmpty) {
            for (var i in callValue) {
              callTime.add(i);
            }
          }
        });
      }
    }

    return callTime;
  }

  Future<List> getQc() async {
    List qc = [];

    if (syncObj.containsKey(qcDataKey)) {
      Map qcData = syncObj[qcDataKey];
      if (qcData.isNotEmpty) {
        for (MapEntry retailerData in qcData.entries) {
          String retailerId = retailerData.key.toString();
          Map moduleValue = retailerData.value;
          OutletModel? retailer = await _syncReadService.getRetailerModelFromId(retailerId);
          if (retailer != null) {
            if (moduleValue.isNotEmpty) {
              for (MapEntry moduleData in moduleValue.entries) {
                String moduleId = moduleData.key.toString();
                Map skuValue = moduleData.value;
                if (skuValue.isNotEmpty) {
                  for (MapEntry skuData in skuValue.entries) {
                    String skuId = skuData.key.toString();
                    List qcList = skuData.value;
                    for (Map qcValue in qcList) {
                      if (qcValue.isNotEmpty) {
                        Map qcMap = {
                          "sbu_id": int.parse(moduleId.toString()),
                          "dep_id": srInfo.depId,
                          "section_id": srInfo.sectionId,
                          "ff_id": srInfo.ffId,
                          "outlet_id": retailerId,
                          "outlet_code": retailer.outletCode,
                          "date": salesDate,
                          "sku_id": skuId,
                          "fault_id": qcValue[faultIdKey],
                          "volume": qcValue[qcVolumeKey],
                          "unit_price": qcValue[qcUnitPriceKey],
                          "total_value": qcValue[qcTotalValueKey],
                          "entry_type": qcValue[qcEntryTypeKey],
                          "qc_type": qcValue[qcTypeKey],
                          "status": qcValue[qcStatusKey],
                        };
                        qc.add(qcMap);
                      }
                    }
                  }
                  // skuValue.forEach((skuId, qcValue) {
                  //
                  // });
                }
              }
              // moduleValue.forEach((moduleId, skuValue) {
              //
              // });
            }
          }
        }
        // qcData.forEach((retailerId, moduleValue) async {
        //
        // });
      }
    }

    return qc;
  }

  // Future<List> getPromotion() async {
  //   List promotions = [];
  //
  //   if (syncObj.containsKey(promotionDataKey)) {
  //     Map promotionData = syncObj[promotionDataKey];
  //     if (promotionData.isNotEmpty) {
  //       promotionData.forEach((retailerId, promotion) async {
  //         OutletModel? retailer = await _syncReadService.getRetailerModelFromId(retailerId);
  //         if (retailer != null) {
  //           if (promotion.isNotEmpty) {
  //             promotion.forEach((promotionId, promotionValue) {
  //               if (promotionValue.isNotEmpty) {
  //                 Map qcMap = {
  //                   "sbu_id": srInfo.sbuId,
  //                   "dep_id": srInfo.depId,
  //                   "section_id": srInfo.sectionId,
  //                   "ff_id": srInfo.ffId,
  //                   "outlet_id": retailerId,
  //                   "outlet_code": retailer.retailerCode,
  //                   "date": salesDate,
  //                   "promotion_id": promotionId,
  //                   "quantaty": promotionValue[promotionVolumeKey],
  //                   "value": promotionValue[promotionValueKey]
  //                 };
  //                 promotions.add(qcMap);
  //               }
  //             });
  //           }
  //         }
  //       });
  //     }
  //   }
  //
  //   return promotions;
  // }

  // Future<List> getOutletData() async {
  //   List outlet = [];
  //
  //   if (syncObj.containsKey(salesKey)) {
  //     Map outletData = syncObj[salesKey];
  //     if (outletData.isNotEmpty) {
  //       outletData.forEach((retailerId, moduleValue) async {
  //         OutletModel? retailer = await _syncReadService.getRetailerModelFromId(retailerId);
  //         if (retailer != null) {
  //           Map outletMap = {"sbu_id": srInfo.sbuId, "dep_id": srInfo.depId, "section_id": srInfo.sectionId, "ff_id": srInfo.ffId, "data": []};
  //
  //           if (moduleValue.isNotEmpty) {
  //             moduleValue.forEach((moduleId, sku) {
  //               if (sku.isNotEmpty) {
  //                 sku.forEach((skuId, skuValue) {
  //                   if (!outletMap.containsKey('date')) {
  //                     outletMap['date'] = skuValue[salesDateKey];
  //                   }
  //                   if (!outletMap.containsKey('sales_datetime')) {
  //                     outletMap['dateTime'] = skuValue[salesDateTimeKey];
  //                   }
  //                   Map data = {
  //                     "outlet_id": retailerId,
  //                     "outlet_code": retailer.retailerCode,
  //                     "sku_id": skuId,
  //                     "quantity": skuValue[salesQtyKey],
  //                     "unit_price": skuValue[salesQtyKey] != 0 ? skuValue[salesPriceKey] / skuValue[salesQtyKey] : 0,
  //                     "total_price": skuValue[salesPriceKey]
  //                   };
  //                   outletMap['data'].add(data);
  //                 });
  //               }
  //             });
  //           }
  //
  //           outlet.add(outletMap);
  //         }
  //       });
  //     }
  //   }
  //
  //   return outlet;
  // }

  Future<List> getPreorderData() async {
    List preorderData = [];

    try {
      Map preorderMap = syncObj[preorderKey];
      if (preorderMap.isNotEmpty) {
        for (MapEntry retailerWisePreorderMap in preorderMap.entries) {
          OutletModel? retailer = await _syncReadService.getRetailerModelFromId(retailerWisePreorderMap.key.toString());
          if (retailerWisePreorderMap.value.isNotEmpty) {
            for (MapEntry moduleWisePreorderMap in retailerWisePreorderMap.value.entries) {
              int moduleId = int.parse(moduleWisePreorderMap.key.toString());
              if (moduleWisePreorderMap.value.isNotEmpty) {
                for (MapEntry skuWisePreorderMap in moduleWisePreorderMap.value.entries) {
                  int skuId = int.parse(skuWisePreorderMap.key.toString());
                  if (skuWisePreorderMap.value.isNotEmpty) {
                    Map preorderPayload = {
                      "sbu_id": moduleId,
                      "dep_id": srInfo.depId,
                      "ff_id": srInfo.ffId,
                      "section_id": srInfo.sectionId,
                      "outlet_id": retailer!.id,
                      "outlet_code": retailer.outletCode,
                      "sku_id": skuId,
                      "unit_price": skuWisePreorderMap.value[preorderSttKey] != 0 ? skuWisePreorderMap.value[preorderPriceKey] / skuWisePreorderMap.value[preorderSttKey] : 0,
                      "volume": skuWisePreorderMap.value[preorderSttKey],
                      "total_price": skuWisePreorderMap.value[preorderPriceKey],
                      "order_datetime": skuWisePreorderMap.value[preorderSalesDateTimeKey],
                      "date": skuWisePreorderMap.value[preorderSalesDateKey]
                    };
                    preorderData.add(preorderPayload);
                  }
                }
              }
            }
          }
        }
      }
    } catch (e) {
      Helper.dPrint("inside getPreorderData OfflinePdaServices catch block $e");
    }

    return preorderData;
  }

  ////======================Formatting data for bikroi joma start==============================================
  Future<Map> formatBikroiJomaData() async {
    Map finalBikroiJomaData = {};

    try {
      await _syncService.checkSyncVariable();

      //calculate outletData
      List<Map> outletDataMap = await getOutletDataForBicroiJoma();
      finalBikroiJomaData["outlet_data"] = outletDataMap;

      //calculate section data
      // List<Map> sectionData = await getSectionDataForBicroiJoma();
      // finalBikroiJomaData["section_data"] = sectionData;
    } catch (e) {
      Helper.dPrint("inside formatBikroiJomaData offlinePdaService catch block $e");
    }
    return finalBikroiJomaData;
  }

  //get OutletData List for bicroi joma
  Future<List<Map>> getOutletDataForBicroiJoma() async {
    List<Map> outletData = [];
    try {
      await _syncService.checkSyncVariable();
      Map<String, List<Map>> outletDataByModule = {};
      if (syncObj.containsKey(preorderKey)) {
        if (syncObj[preorderKey].isNotEmpty) {
          Map salesData = syncObj[preorderKey];
          for (var retailerId in salesData.keys) {
            var salesDataByModule = salesData[retailerId];
            OutletModel? retailer = await _syncReadService.getRetailerModelFromId(retailerId);
            if (retailer != null) {
              if (salesDataByModule.isNotEmpty) {
                for (var moduleId in salesDataByModule.keys) {
                  var saleDataBySku = salesDataByModule[moduleId];
                  if (saleDataBySku.isNotEmpty) {
                    for (var skuId in saleDataBySku.keys) {
                      var perSkuPerModulePerRetailerSaleMap = saleDataBySku[skuId];

                      Map perSkuPerModulePerRetailerOutletData = {
                        "outlet_id": retailer.id,
                        "outlet_code": retailer.outletCode,
                        "sku_id": skuId,
                        "quantity": perSkuPerModulePerRetailerSaleMap[preorderSttKey],
                        "unit_price":
                            perSkuPerModulePerRetailerSaleMap[preorderSttKey] != 0 ? perSkuPerModulePerRetailerSaleMap[preorderPriceKey] / perSkuPerModulePerRetailerSaleMap[preorderSttKey] : 0,
                        "total_price": perSkuPerModulePerRetailerSaleMap[preorderPriceKey],
                        "sales_datetime": perSkuPerModulePerRetailerSaleMap[preorderSalesDateTimeKey]
                      };
                      if (!outletDataByModule.containsKey(moduleId.toString())) {
                        outletDataByModule[moduleId.toString()] = [];
                      }
                      outletDataByModule[moduleId.toString()]!.add(perSkuPerModulePerRetailerOutletData);
                    }
                  }
                }
              }
            }
          }
        }
      }

      if (outletDataByModule.isNotEmpty) {
        SrInfoModel srInfo = await _syncReadService.getSrInfo();
        String salesDate = await _syncReadService.getSalesDate();
        outletDataByModule.forEach((moduleId, data) {
          if (data.isNotEmpty) {
            Map finalOutletDataByModule = {"sbu_id": int.parse(moduleId.toString()), "dep_id": srInfo.depId, "ff_id": srInfo.ffId, "section_id": srInfo.sectionId, "date": salesDate, "data": data};
            outletData.add(finalOutletDataByModule);
          }
        });
      }
    } catch (e) {
      Helper.dPrint("inside getOutletDataForBicroiJoma offlinePdaServices catch block $e");
    }
    return outletData;
  }

  Future<List> getGeoData() async {
    List geoData = [];

    if (syncObj.containsKey(geoDataKey)) {
      Map geo = syncObj[geoDataKey];

      if (geo.isNotEmpty) {
        geo.forEach((retailerId, geoArray) async {
          for (var i in geoArray) {
            geoData.add(i);
          }
        });
      }
    }

    return geoData;
  }

  Future<List> getLastGeoData() async {
    List geoData = [];

    if (syncObj.containsKey(geoDataKey)) {
      Map geo = syncObj[geoDataKey];

      if (geo.isNotEmpty) {
        geo.forEach((retailerId, geoArray) async {

            if(geoArray.isNotEmpty) {
              if(geoArray.length>1) {
                geoData.add(geoArray.last);
              } else {
                geoData.add(geoArray.first);
              }
            }

        });
      }
    }

    return geoData;
  }

  Future<List<SaleSubmitTableModel>> getSaleSubmittedData() async {
    List<SaleSubmitTableModel> saleSubmittedData = [];
    num deviceSurvey = 0;
    num auditSurvey = 0;

    if (syncObj.containsKey(surveyDataKey)) {
      deviceSurvey += syncObj[surveyDataKey].length;
    }

    if (syncObj.containsKey(surveyPointLocationDataKey)) {
      auditSurvey += syncObj[surveyPointLocationDataKey].length;
    }

    saleSubmittedData = [
      SaleSubmitTableModel('survey', 'Outlet survey', deviceSurvey),
      SaleSubmitTableModel('audit', 'Audit', auditSurvey),
    ];

    return saleSubmittedData;
  }

  num getTotalDiscountAmountOfTheDeviceAndType(SaleType saleType) {
    num totalPromotion = 0;
    try {
      String promotionKey = SalesTypeUtils.toPromotionSaveKey(saleType);
      Map promotionMap = syncObj[promotionKey] ?? {};
      if (promotionMap.isNotEmpty) {
        for (MapEntry promotionMapEntry in promotionMap.entries) {
          Map retailerWisePromotion = promotionMapEntry.value;
          if (retailerWisePromotion.isNotEmpty) {
            for (MapEntry retailerWisePromotionMapEntry in retailerWisePromotion.entries) {
              Map promotionMap = retailerWisePromotionMapEntry.value;
              if (promotionMap.isNotEmpty) {
                PayableType payableType = PayableTypeUtils.toType(promotionMap[promotionDataPayableTypeKey]);

                num discountAmountForFractional=0;

                for (MapEntry skuWishDiscount in promotionMap[promotionDataDiscountSkusKey].entries){
                  Map skuWise=skuWishDiscount.value;

                  discountAmountForFractional+=skuWise[promotionDataDiscountAmountKey];
                }



                if(payableType == PayableType.absoluteCash && DiscountTypeUtils.toType(promotionMap[promotionDataDiscountTypeKey])==DiscountType.normal && discountAmountForFractional!=promotionMap[promotionDataDiscountAmountKey]){

                  print('retailer promotion is::: ${discountAmountForFractional}');
                  totalPromotion+=promotionMap[promotionDataDiscountAmountKey]+(discountAmountForFractional-promotionMap[promotionDataDiscountAmountKey]);
                } else {
                  if (payableType == PayableType.percentageOfValue || payableType == PayableType.absoluteCash) {
                    print('retailer promotion is:::>>> ${discountAmountForFractional}');
                    totalPromotion += promotionMap[promotionDataDiscountAmountKey];
                    // Map discountSkus = promotionMap[promotionDataDiscountSkusKey];
                    // if(discountSkus.isNotEmpty){
                    //   for(MapEntry discountSkuMapEntry in discountSkus.entries){
                    //     totalPromotion+=(discountSkuMapEntry.value[promotionDataDiscountAmountKey]??0);
                    //   }
                    // }
                  } if(promotionMap.containsKey("is_fractional") && promotionMap["is_fractional"] == true) {
                    totalPromotion += promotionMap[promotionDataDiscountAmountKey];
                  }
                }
              }
            }
          }
        }
      }
    } catch (e, t) {
      Helper.dPrint("inside getTotalDiscountAmountOfTheDeviceAndType PromotionServices catch block $e");
      log(t.toString());
    }
    return totalPromotion;
  }

  num getTotalDiscountVolumeOfTheDeviceAndType(SaleType saleType) {
    num totalPromotion = 0;
    try {
      String promotionKey = SalesTypeUtils.toPromotionSaveKey(saleType);
      Map promotionMap = syncObj[promotionKey] ?? {};
      if (promotionMap.isNotEmpty) {
        for (MapEntry promotionMapEntry in promotionMap.entries) {
          Map retailerWisePromotion = promotionMapEntry.value;
          if (retailerWisePromotion.isNotEmpty) {
            for (MapEntry retailerWisePromotionMapEntry in retailerWisePromotion.entries) {
              Map promotionMap = retailerWisePromotionMapEntry.value;
              if (promotionMap.isNotEmpty) {
                PayableType payableType = PayableTypeUtils.toType(promotionMap[promotionDataPayableTypeKey]);

                if(payableType == PayableType.productDiscount && DiscountTypeUtils.toType(promotionMap[promotionDataDiscountTypeKey])==DiscountType.normal){

                  totalPromotion+=promotionMap[promotionDataDiscountAmountKey];
                }
              }
            }
          }
        }
      }
    } catch (e, t) {
      Helper.dPrint("inside getTotalDiscountAmountOfTheDeviceAndType PromotionServices catch block $e");
      log(t.toString());
    }
    return totalPromotion;
  }

  /////=====================Formatting data for sync data ===============================================
  Future<List<OutletModel>> checkUnsentSyncData() async {
    await _syncService.checkSyncVariable();
    List<OutletModel> unsentRetailers = await _outletServices.getOutletList(true);
    return unsentRetailers;
  }

  Future<List<OutletModel>> getDeliveryRetailerList() async {
    return await _outletServices.getDeliveryOutletList(all: true);
  }

  List getUnsoldOutletData() {
    try {
      if (syncObj.containsKey(unsoldOutletKey)) {
        return syncObj[unsoldOutletKey];
      }
    } catch (e, s) {
      Helper.dPrint("inside offline pda service getUnsoldOutletData $e $s");
    }
    return [];
  }

  Future<ReturnedDataModel?> getAllOutletDataForSync(List<OutletModel> retailers, SaleType saleType, {bool disableSalesSummary=false}) async {
    Map finalMap = {};
    try {
      String salesDate = await _syncReadService.getSalesDate();
      SrInfoModel srInfo = await _syncReadService.getSrInfo();
      finalMap = {
        "date": salesDate,
        "section_id": srInfo.sectionId,
        "ff_id": srInfo.ffId,
        "outlet_data": {},
        if(saleType==SaleType.preorder) "rtc_survey": [],
      };

      //pre_order
      String saleKeyInOutletData = SalesTypeUtils.toOutletDataSaleKey(saleType);

      List promotionData = [];
      List couponData = [];
      List surveyData = [];
      List qcData = [];
      List callTimeData = [];
      List preorderData = [];
      List geoData = [];
      List unsoldOutletData = [];
      List stockCountData = [];
      List stockCheckData = [];

      try {
        final points = await AuditService().getAllPointList();
        for (final point in points) {
          final survey = await SurveyService().getSurveyDataForAPoint(point);
          if(survey.isNotEmpty) {
            surveyData.addAll(survey);
          }
        }
      } catch (e, t) {
        debugPrint(e.toString());
        debugPrint(t.toString());
      }

      if (retailers.isNotEmpty) {
        for (OutletModel retailer in retailers) {
          CouponModel? coupon;

          Map? cpn= await couponService.checkRetailerCouponCode(retailer: retailer);
          if(cpn!=null){
            coupon = await couponService.getCouponFromCouponCode(couponCode: cpn["code"]);
            print('i found the coupon:: ${coupon?.maxUses}');
          }

          Map outletData = await _salesService.getFormattedSaleData(retailer, saleType, coupon: coupon);
          if (outletData.isNotEmpty) {
            // unsold outlet data
            unsoldOutletData = getUnsoldOutletData();

            //outlet stock count
            if(outletData.containsKey("stock_check_data")){
              if (outletData["stock_check_data"].isNotEmpty) {
                stockCheckData.addAll(outletData["stock_check_data"]);
              }
            }

            //outlet stock count
            if(outletData.containsKey("outlet_stock_count")){
              if (outletData["outlet_stock_count"].isNotEmpty) {
                stockCountData.addAll(outletData["outlet_stock_count"]);
              }
            }

            //promotions
            if (outletData.containsKey("promotions")) {
              if (outletData["promotions"].isNotEmpty) {
                promotionData.addAll(outletData["promotions"]);
              }
            }

            //coupon
            if (outletData.containsKey("coupons")) {
              if (outletData["coupons"].isNotEmpty) {
                couponData.addAll(outletData['coupons']);
              }
            }

            //survey
            if (outletData.containsKey("survey")) {
              if (outletData["survey"].isNotEmpty) {
                surveyData.addAll(outletData["survey"]);
              }
            }

            //qc
            if (outletData.containsKey("qc")) {
              if (outletData["qc"].isNotEmpty) {
                qcData.addAll(outletData["qc"]);
              }
            }

            //call_time
            if (outletData.containsKey("call_time")) {
              if (outletData["call_time"].isNotEmpty) {
                callTimeData.addAll(outletData["call_time"]);
              }
            }

            if (outletData.containsKey(saleKeyInOutletData)) {
              if (outletData[saleKeyInOutletData].isNotEmpty) {
                preorderData.addAll(outletData[saleKeyInOutletData]);
              }
            }

            //geo_data
            if (outletData.containsKey("geo_data")) {
              if (outletData["geo_data"].isNotEmpty) {
                geoData.addAll(outletData["geo_data"]);
              }
            }

            if(saleType == SaleType.delivery) {

              Map m = await _salesService.createCallTime(retailer);
              callTimeData.addAll([m]);
            }
          }
        }
      }

      try {
        if (syncObj.containsKey(zeroSaleDataKey) && saleType == SaleType.delivery) {
          Map zeroSaleDatas = syncObj[zeroSaleDataKey];
          if (zeroSaleDatas.isNotEmpty) {
            for (MapEntry zeroSaleDataEntry in zeroSaleDatas.entries) {
              OutletModel? retailer = await _syncReadService.getRetailerModelFromId(zeroSaleDataEntry.key);
              if (retailer != null) {
                List zeroSaleData = await _deliveryServices.getZeroSaleDataForARetailer(retailer.id ?? 0);
                if (zeroSaleData.isNotEmpty) {
                  preorderData.addAll(zeroSaleData);
                }
              }
            }
          }
        }
      } catch (e) {
        Helper.dPrint("zero sale data error in offline pda $e");
      }

      try {
        if (syncObj.containsKey(unsoldOutletKey) && saleType == SaleType.preorder) {
          List<Map> zeroSaleData = await _salesService.getZeroSellList();
          if (zeroSaleData.isNotEmpty) {
            preorderData.addAll(zeroSaleData);
            finalMap["outlet_data"][saleKeyInOutletData] = preorderData;
          }
        }
      } catch (e, t) {
        Helper.dPrint(e.toString());
        Helper.dPrint(t.toString());
      }

      finalMap["outlet_data"]["promotions"] = promotionData;
      finalMap["outlet_data"]["stock_check_data"] = stockCheckData;
      finalMap["outlet_data"][saleKeyInOutletData] = preorderData;

      if (saleType == SaleType.preorder || saleType == SaleType.spotSale) {
        finalMap["outlet_data"]["outlet_stock_count"] = stockCountData;
        finalMap["outlet_data"]["survey"] = surveyData;
        finalMap["outlet_data"]["geo_data"] = geoData;
        finalMap["outlet_data"]["call_time"] = callTimeData;
        finalMap["outlet_data"]["coupons"] = couponData;

        ///todo remove this line and add all zero sell data on "pre_order" list
        finalMap["outlet_data"][unsoldOutletKey] = unsoldOutletData;

        List posmData = [];
        posmData = await PosmManagementService().haveAllPosmData();

        if (posmData.isNotEmpty) {
          finalMap["outlet_data"]["posm"] = posmData;
        }
      } else {
        finalMap["outlet_data"]["call_time"] = callTimeData;
        finalMap["outlet_data"]["qc"] = qcData;
      }

      if(saleType==SaleType.preorder) {
        List<Map> digitalLearningSurvey = SurveyService().getDigitalLearningSurveyData();

        if (digitalLearningSurvey.isNotEmpty) {
          finalMap['rtc_survey'] = digitalLearningSurvey;
        }
      }
      // if(unsoldOutletData.isNotEmpty) {
      //   for (var val in unsoldOutletData) {
      //
      //   }
      // }

      ///

      if (finalMap.isNotEmpty) {
        String url = Links.saveSaleSectionDataUrl;
        switch (saleType) {
          case SaleType.preorder:
            url = Links.saveSaleSectionDataUrl;
          case SaleType.delivery:
            url = Links.saveDeliverySectionDataUrl;
          case SaleType.spotSale:
            url = Links.saveSpotSaleSectionDataUrl;
        }
        log("SaLeTyPeId::: $saleType");
        if(saleType == SaleType.delivery && disableSalesSummary == false) {
          Map overallStock = await _salesService.getPayloadForCheckStock(preorderData: finalMap);
          log('overall stock is:::: ${jsonEncode(overallStock)}');
          if(overallStock.isNotEmpty) {
            finalMap["outlet_data"]["sales_summary"] = overallStock;
          }
        }
        log(jsonEncode(finalMap));
        ReturnedDataModel returnedDataModel =
            await GlobalHttp(httpType: HttpType.post, uri: '${Links.baseUrl}$url', accessToken: srInfo.accessToken, refreshToken: srInfo.refreshToken, body: jsonEncode(finalMap)).fetch();

        if(returnedDataModel.status != ReturnedStatus.success && saleType == SaleType.delivery) {
          return returnedDataModel;
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside getAllOutletDataForSync OfflinePdaServices catch block $e $s");
    }
  }

  Future flashAllServerData() async {
    SrInfoModel? sr = await FFServices().getSrInfo();
    String date = await FFServices().getSalesDate();
    Map finalMap = { "sales_date": date, "section_id": sr?.sectionId, "ff_id": sr?.ffId};
    try {
      log(jsonEncode(finalMap));
      await GlobalHttp(httpType: HttpType.post,
        uri: Links.flashServerDataUrl,
        accessToken: sr?.accessToken,
        refreshToken: sr?.refreshToken,
        body: jsonEncode(finalMap),).fetch();

    } catch (e, s) {
      Helper.dPrint("inside getAllOutletDataForSync OfflinePdaServices catch block $e $s");
    }
  }
}
