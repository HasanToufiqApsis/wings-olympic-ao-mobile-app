import 'dart:convert';
import 'dart:developer';

import '../api/global_http.dart';
import '../api/links.dart';
import '../constants/enum.dart';
import '../constants/sync_global.dart';
import '../models/outlet_model.dart';
import '../models/products_details_model.dart';
import '../models/qps_sales_data.dart';
import '../models/qps_slab_sort_model.dart';
import '../models/returned_data_model.dart';
import '../models/sales/formatted_sales_preorder_discount_data_model.dart';
import '../models/sr_info_model.dart';
import 'dart:async' show Future;

import '../models/trade_promotions/promotion_model.dart';
import '../reusable_widgets/global_widgets.dart';
import '../utils/promotion_utils.dart';
import 'helper.dart';
import 'product_category_services.dart';
import 'sync_read_service.dart';
import 'sync_service.dart';

class QPSPromotionServices {
  final SyncService _syncService = SyncService();
  final SyncReadService _syncReadService = SyncReadService();
  final ProductCategoryServices _productCategoryServices = ProductCategoryServices();

  //Returns All available promotion for a retailer
  Future<List<PromotionModel>> getAllEnrollAvailableQpsPromotionForARetailer(OutletModel retailer) async {
    List<PromotionModel> list = [];
    try {
      await _syncService.checkSyncVariable();
      Map promotionList = syncObj.containsKey("promotions") ? syncObj['promotions'] : {};
      if (retailer.availablePromotions.isNotEmpty) {
        retailer.availablePromotions.forEach((key, value) {
          if (promotionList.containsKey(key.toString())) {
            Map<String, dynamic> p = promotionList[key.toString()] as Map<String, dynamic>;
            list.add(PromotionModel.fromJson(p));
          }
        });
      }
    } catch (e) {
      Helper.dPrint("inside getAllAvailablePromotionForARetailer PromotionServices catch block $e");
    }
    return list;
  }

  //Returns All available promotion for a retailer
  Future<List<PromotionModel>> _getAllQpsPromotionFromPromotionId(List<int> promotionIds) async {
    List<PromotionModel> list = [];
    try {
      await _syncService.checkSyncVariable();
      Map promotionList = syncObj.containsKey("promotions") ? syncObj['promotions'] : {};

      promotionList.forEach((key, value) {
        if (promotionList.containsKey(key.toString())) {
          Map<String, dynamic> p = promotionList[key.toString()] as Map<String, dynamic>;
          PromotionModel promotion = PromotionModel.fromJson(p);

          if (promotionIds.contains(promotion.id)) {
            list.add(promotion);
          }
        }
      });
    } catch (e) {
      Helper.dPrint("inside getAllAvailablePromotionForARetailer PromotionServices catch block $e");
    }
    return list;
  }

  ///get all QPS promotions that's retailer are able to enroll now
  ///
  Future<List<PromotionModel>> getAvailableQPSPromotionForRetailer(OutletModel retailer) async {
    List<PromotionModel> list = [];
    try {
      await _syncService.checkSyncVariable();
      List<num> enrollQPSPromotionsSlabIds = await getEnrolledQPSPromotionSlabsForRetailer(retailer);
      Map promotionList = syncObj.containsKey("promotions") ? syncObj['promotions'] : {};
      if (retailer.availableQpsPromotions.isNotEmpty) {
        retailer.availableQpsPromotions.forEach((key, value) {
          if (promotionList.containsKey(key.toString())) {
            Map<String, dynamic> p = promotionList[key.toString()] as Map<String, dynamic>;
            PromotionModel promotion = PromotionModel.fromJson(p);
            if (p["discount_type"] == "Qps") {
              if (!enrollQPSPromotionsSlabIds.contains(promotion.slabGroupId)) {
                list.add(promotion);
              }
            }
          }
        });
      }
    } catch (e, t) {
      Helper.dPrint("$e");
      Helper.dPrint("$t");
    }
    return list;
  }

  ///get all QPS promotions that's retailer are able to enroll now
  ///
  Future<Map> getSalesDataForQPSPromotionTarget(OutletModel retailer) async {
    Map data = {};
    try {
      List<String> promotion = [];
      retailer.availableQpsPromotions.forEach((key, value) {
        promotion.add(key.toString());
      });
      Map salesData = await QPSPromotionServices().getSalesDataForQPSTarget(
        retailer: retailer,
        promotions: promotion,
      );
      data = salesData;
    } catch (e, t) {
      Helper.dPrint("$e");
      Helper.dPrint("$t");
    }
    return data;
  }

  ///get enroll QPS promotion Slab Group Id that's retailer already enrolled
  ///[use: for avoid repeating re-enroll on already enrolled QPS promotion
  ///
  Future<List<num>> getEnrolledQPSPromotionSlabsForRetailer(OutletModel retailer) async {
    List<num> list = [];
    try {
      await _syncService.checkSyncVariable();
      // Map enrollQPSPromotionData = syncObj.containsKey("enroll-qps-promotion-data") ? syncObj['enroll-qps-promotion-data'] : {};

      if (syncObj.containsKey("enroll-qps-promotion-data")) {
        if (syncObj["enroll-qps-promotion-data"].containsKey(retailer.id.toString())) {
          Map retailerEnrolledQPS = syncObj["enroll-qps-promotion-data"][retailer.id.toString()];
          if (retailerEnrolledQPS.isNotEmpty) {
            retailerEnrolledQPS.forEach((key, value) {
              list.add(num.parse(key.toString()));
            });
          }
        }
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return list;
  }

  Future<bool> _enrollQPSPromotionForRetailerOnSyncFile(
    OutletModel retailer,
    List<PromotionModel> promotions,
  ) async {
    bool result = false;
    try {
      await _syncService.checkSyncVariable();
      if (!syncObj.containsKey("enroll-qps-promotion-data")) {
        syncObj["enroll-qps-promotion-data"] = {};
      }

      if (!syncObj["enroll-qps-promotion-data"].containsKey(retailer.id.toString())) {
        syncObj["enroll-qps-promotion-data"][retailer.id.toString()] = {};
      }

      for (var promotion in promotions) {
        syncObj["enroll-qps-promotion-data"][retailer.id.toString()][promotion.slabGroupId.toString()] = {
          "promotion_id": promotion.id,
          "slab_group_id": promotion.slabGroupId,
        };
      }

      await _syncService.writeSync(jsonEncode(syncObj));
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return result;
  }

  Future<Map> _getQpsPromotionDataForApi({
    required OutletModel retailer,
    required List<PromotionModel> promotions,
  }) async {
    SrInfoModel srInfo = await _syncReadService.getSrInfo();
    Map finalMap = {};
    try {
      List promotionsData = await _getPromotionDataForApi(retailer: retailer, promotions: promotions, srInfo: srInfo);
      if (promotionsData.isNotEmpty) {
        finalMap['qps_enroll_data'] = promotionsData;
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return finalMap;
  }

  Future<List> _getPromotionDataForApi({
    required OutletModel retailer,
    required List<PromotionModel> promotions,
    required SrInfoModel srInfo,
  }) async {
    String salesDate = await _syncReadService.getSalesDate();
    List promotionData = [];
    try {
      for (var promotion in promotions) {
        Map singlePromotion = {
          "sbu_id": 1,
          "dep_id": srInfo.depId,
          "section_id": srInfo.sectionId,
          "ff_id": srInfo.ffId,
          "outlet_id": retailer.id,
          "outlet_code": retailer.outletCode,
          "date": salesDate,
          "promotion_id": promotion.id,
        };

        promotionData.add(singlePromotion);
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return promotionData;
  }

  Future<Map> saveEnrollQpsPromotionForARetailer({
    required OutletModel retailer,
    required List<int> selectedPromotionIds,
  }) async {
    Map finalMap = {};
    try {
      List<PromotionModel> promotions = await _getAllQpsPromotionFromPromotionId(selectedPromotionIds);

      ///send data to API
      finalMap = await _getQpsPromotionDataForApi(retailer: retailer, promotions: promotions);
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return finalMap;
  }

  Future<ReturnedDataModel> sendQpsEnrollToApi({
    required Map finalMap,
    required OutletModel retailer,
    required List<int> selectedPromotionIds,
  }) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(status: ReturnedStatus.success);
    SrInfoModel srInfo = await _syncReadService.getSrInfo();
    try {
      returnedDataModel = await GlobalHttp(
        httpType: HttpType.post,
        uri: '${Links.baseUrl}${Links.qpsEnroll}',
        accessToken: srInfo.accessToken,
        refreshToken: srInfo.refreshToken,
        body: jsonEncode(finalMap),
      ).fetch();
      if (returnedDataModel.status == ReturnedStatus.success) {
        final promotions = await _getAllQpsPromotionFromPromotionId(selectedPromotionIds);
        await _enrollQPSPromotionForRetailerOnSyncFile(retailer, promotions);
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return returnedDataModel;
  }

  Future<List<QpsSalesData>> getSalesDataForSpecificQPSs({
    required OutletModel retailer,
    required List<int> qpsIds,
    required List<PromotionModel> promotions,
  }) async {
    List<QpsSalesData> salesData = [];
    SrInfoModel srInfo = await _syncReadService.getSrInfo();

    final finalMap = {"retailer_id": retailer.id, "promotion_ids": qpsIds};

    try {
      final data = await GlobalHttp(
        httpType: HttpType.post,
        uri: '${Links.baseUrl}${Links.salesDataForQps}',
        accessToken: srInfo.accessToken,
        refreshToken: srInfo.refreshToken,
        body: jsonEncode(finalMap),
      ).fetch();
      if (data.status == ReturnedStatus.success) {
        Map responseData = data.data;

        responseData["data"].forEach((promotionId, salesMap) async {
          int pId = int.tryParse(promotionId) ?? 0;
          List<PromotionModel> v = await _getAllQpsPromotionFromPromotionId([pId]);
          Map sales = salesMap as Map<String, dynamic>;

          List<SkuWiseSales> sws = [];
          PromotionModel promo = promotions.firstWhere((element) => element.id == pId);

          if (sales["sales"] == null || sales["sales"].isEmpty) {
            for (Rules ru in promo.rules ?? []) {
              if (ru.skuId != '%') {
                final skuDetails = await _productCategoryServices.getSkuDetailsFromSkuId(int.tryParse(ru.skuId ?? '0') ?? 0);
                sws.add(
                  SkuWiseSales(
                    sku: skuDetails,
                    volume: 0,
                    value: 0,
                  ),
                );
              }
            }
          } else {
            for (Rules ru in promo.rules ?? []) {
              if (ru.skuId != '%') {
                sales["sales"].forEach((skuId, skuWiseSales) async {
                  if (skuId == ru.skuId) {
                    final skuDetails = await _productCategoryServices.getSkuDetailsFromSkuId(int.tryParse(skuId) ?? 0);
                    sws.add(
                      SkuWiseSales(
                        sku: skuDetails,
                        volume: skuWiseSales['total_volume'],
                        value: skuWiseSales['total_price'],
                      ),
                    );
                  } else {
                    if (!sales["sales"].containsKey('${ru.skuId}')) {
                      final skuDetails = await _productCategoryServices.getSkuDetailsFromSkuId(int.tryParse(skuId) ?? 0);
                      sws.add(
                        SkuWiseSales(
                          sku: skuDetails,
                          volume: 0,
                          value: 0,
                        ),
                      );
                    }
                  }
                });
              }
            }
          }

          int requiredMemo = 0;
          int memoCount = 0;
          if (salesMap["required_memos"] == null) {
            PromotionModel promo = promotions.firstWhere((element) => element.id == pId);
            requiredMemo = promo.numberOfMemo?.toInt() ?? 0;
          } else {
            if (salesMap["required_memos"].runtimeType == String) {
              requiredMemo = int.tryParse(salesMap["required_memos"]) ?? 0;
            } else {
              requiredMemo = salesMap["required_memos"];
            }
          }

          if (salesMap["memo_count"].runtimeType == String) {
            memoCount = int.tryParse(salesMap["memo_count"]) ?? 0;
          } else {
            memoCount = salesMap["memo_count"];
          }

          salesData.add(
            QpsSalesData(
              promotion: v.first,
              sales: sws,
              requiredMemo: requiredMemo,
              memoCount: memoCount,
            ),
          );
        });
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return salesData;
  }

  Future<Map> getSalesDataForQPSTarget({
    required OutletModel retailer,
    required List<String> promotions,
  }) async {
    Map salesData = {};
    SrInfoModel srInfo = await _syncReadService.getSrInfo();

    String str = '';
    for (var val in promotions) {
      str += '$val,';
    }
    if (str.isNotEmpty) {
      str = str.substring(0, str.length - 1);
    }
    final finalMap = {
      "retailer_id": retailer.id.toString(),
      "promotion_ids": str
    };

    try {
      final data = await GlobalHttp(
        httpType: HttpType.get,
        uri: '${Links.baseUrl}${Links.salesDataForQpsTarget}',
        accessToken: srInfo.accessToken,
        refreshToken: srInfo.refreshToken,
        queryParameters: finalMap,
      ).fetch();
      if (data.status == ReturnedStatus.success) {
        Map responseData = data.data["data"];
        salesData = responseData;
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return salesData;
  }

  ///get the warning message to retailer
  Future<String> getQpsPromotionWarningMessage(
    String lang, {
    required QpsSalesData qpsSalesData,
  }) async {
    String message = "You need to buy ";
    PromotionModel promotion = qpsSalesData.promotion;
    try {
      int alreadyPurchase = 0;
      String unit = promotion.qpsTarget == QpsTarget.volume ? "case" : "taka";

      String skuMessage= '';
      for (int a = 0; a != qpsSalesData.sales.length; a++) {
        String qpsWisePurchase = "";
        SkuWiseSales skuWiseSales = qpsSalesData.sales[a];
        for (Rules rule in promotion.rules ?? []) {
          if (int.tryParse(rule.skuId ?? '0') == qpsSalesData.sales[a].sku?.id) {
            num totalCasePurchase = promotion.qpsTarget == QpsTarget.volume
                ? (rule.cases ?? 0) - (skuWiseSales.volume / (qpsSalesData.sales[a].sku?.packSizeCases ?? 0))
                : (rule.cases ?? 0) - skuWiseSales.value;

            if(totalCasePurchase>0) {
              qpsWisePurchase += "${qpsSalesData.sales[a].sku?.shortName} ${totalCasePurchase.toStringAsFixed(0)} $unit ";
            }
            alreadyPurchase += rule.cases ?? 0;
          }
        }

        skuMessage += qpsWisePurchase;
        // message += qpsWisePurchase;
      }


      String skuAnyMessage= '';
      if (alreadyPurchase != promotion.targetAmount) {
        // message += " and any other sku in ${(promotion.targetAmount ?? 0) - alreadyPurchase} $unit";
        skuAnyMessage += " and any other sku in ${(promotion.targetAmount ?? 0) - alreadyPurchase} $unit";
      }
      message = skuMessage + skuAnyMessage;
      num remainingMemo = qpsSalesData.requiredMemo - qpsSalesData.memoCount;
      message += " more on next ${remainingMemo <= 0 ? "0" : "$remainingMemo"} memo";

      String gift = "";
      if (promotion.payableType == PayableType.absoluteCash) {
        if(skuMessage.isEmpty && skuAnyMessage.isEmpty){
          message = '';
          gift += "Congratulations, you get ${promotion.discountAmount} taka";
        } else {
          gift += " to get ${promotion.discountAmount} taka";
        }
        message += gift;
      } else {
        for (var discountSku in promotion.discountSkus)  {
          if (promotion.payableType == PayableType.productDiscount) {
            gift += 'Congratulations, you get ';
            ProductDetailsModel? skuDetails = await _productCategoryServices.getSkuDetailsFromSkuId(discountSku.skuId);
            if(skuMessage.isEmpty && skuAnyMessage.isEmpty){
              message = '';
              gift += "${skuDetails?.shortName}: ${discountSku.discountQty/(skuDetails?.packSizeCases??1)} case";
            } else {
              gift += " to get ${skuDetails?.shortName}: ${discountSku.discountQty/(skuDetails?.packSizeCases??1)} case";
            }
            // gift += "";
          }
          if (promotion.payableType == PayableType.gift) {
            Map giftMap = _getGiftInfoFromGiftId(discountSku.skuId);

            if (giftMap.isNotEmpty) {
              if(skuMessage.isEmpty && skuAnyMessage.isEmpty){
                message = '';
                gift += "Congratulations, you get ${giftMap['name']}";
              } else {
                gift += " to get ${giftMap['name']}";
              }
            }
          }

          message += gift;
        }
        if (remainingMemo <= 0) {
          message += " (YOU MISS THE OFFER)";
        }
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return message;
  }

  ///get the warning message to retailer
  // String getQpsPromotionWarningMessage(
  //   String lang, {
  //   required QpsSalesData qpsSalesData,
  // }) {
  //   PromotionModel promotion = qpsSalesData.promotion;
  //
  //   String gift = "";
  //   for (var discountSku in promotion.discountSkus) {
  //     if (promotion.payableType == PayableType.absoluteCash) {
  //       gift += " to get ${promotion.discountAmount} taka";
  //     }
  //     if (promotion.payableType == PayableType.productDiscount) {
  //       // final skuDetails = _productCategoryServices.getSkuDetailsFromSkuId(discountSku.skuId);
  //
  //       gift += "";
  //     }
  //     if (promotion.payableType == PayableType.gift) {
  //       Map giftMap = _getGiftInfoFromGiftId(discountSku.skuId);
  //
  //       if (giftMap.isNotEmpty) {
  //         gift += " ${lang == "en" ? "to get " : ""}${giftMap['name']} ${lang == "en" ? "" : "পাওয়ার জন্য"}";
  //       }
  //     }
  //
  //     gift;
  //   }
  //
  //   String message = lang == "en" ? "You need to buy " : "$gift আপনাকে আরো কিনতে হবে ";
  //
  //   try {
  //     int alreadyPurchase = 0;
  //     String unit = promotion.qpsTarget == QpsTarget.volume
  //         ? lang == "en"
  //             ? "case"
  //             : "কেইস"
  //         : lang == "en"
  //             ? "taka"
  //             : "টাকার";
  //     for (int a = 0; a != qpsSalesData.sales.length; a++) {
  //       String qpsWisePurchase = "";
  //       SkuWiseSales skuWiseSales = qpsSalesData.sales[a];
  //       for (Rules rule in promotion.rules ?? []) {
  //         if (int.tryParse(rule.skuId ?? '0') == qpsSalesData.sales[a].sku?.id) {
  //           num totalCasePurchase = promotion.qpsTarget == QpsTarget.volume
  //               ? (rule.cases ?? 0) - (skuWiseSales.volume / (qpsSalesData.sales[a].sku?.packSizeCases ?? 0))
  //               : (rule.cases ?? 0) - skuWiseSales.value;
  //
  //           qpsWisePurchase +=
  //               "${qpsSalesData.sales[a].sku?.shortName} ${lang == "en" ? totalCasePurchase.toStringAsFixed(0) : GlobalWidgets().numberEnglishToBangla(num: totalCasePurchase.toStringAsFixed(0), lang: lang)} $unit ";
  //           alreadyPurchase += rule.cases ?? 0;
  //         }
  //       }
  //
  //       message += qpsWisePurchase;
  //     }
  //
  //     if (alreadyPurchase != promotion.targetAmount) {
  //       message += " and any other sku in ${(promotion.targetAmount ?? 0) - alreadyPurchase} $unit";
  //     }
  //     message += lang == "en"
  //         ? " more on next ${qpsSalesData.requiredMemo - qpsSalesData.memoCount} memo $gift"
  //         : " পরবর্তী ${GlobalWidgets().numberEnglishToBangla(num: (qpsSalesData.requiredMemo - qpsSalesData.memoCount).toStringAsFixed(0), lang: lang)} মেমোর মধ্যে";
  //
  //     ///gift
  //   } catch (e, t) {
  //     log(e.toString());
  //     log(t.toString());
  //   }
  //   return message;
  // }

  Map _getGiftInfoFromGiftId(int id) {
    return syncObj["gifts"]?[id.toString()] ?? {};
  }

  Future<List<int>> getPromotionWithSuggestion({
    required List<PromotionModel> promotions,
    required Map salesData,
  }) async {
    List<int> suggestions = [];
    try {
      Map<int, List<PromotionModel>> slabWisePromotions = {};
      List slabIdList = [];

      for (var val in promotions) {
        if (val.slabGroupId != null) {
          if (!slabWisePromotions.containsKey(val.slabGroupId)) {
            slabWisePromotions[val.slabGroupId!] = [val];
            slabIdList.add(val.slabGroupId);
          } else {
            slabWisePromotions[val.slabGroupId!] = [
              ...slabWisePromotions[val.slabGroupId!] ?? [],
              ...[val],
            ];
          }
        }
      }

      for (var value in slabWisePromotions.values) {
        List<PromotionModel> promotionsForThisSlab = value;

        Map<int, num> allSumList = {};
        for (var pro in promotionsForThisSlab) {
          num sum = getSalesDataWithGrowthForThisPromotion(promotion: pro, data: salesData);
          allSumList[pro.id] = sum;
        }

        int? suggestion = await getBestSuggestedPromotionsForThisRetailer(
          promotions: promotionsForThisSlab,
          salesDataWithGrowthForAllPromotions: allSumList,
        );
        if (suggestion != null) {
          suggestions.add(suggestion);
        }
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return suggestions;
  }

  num getSalesDataWithGrowthForThisPromotion({required PromotionModel promotion, Map? data}) {
    num salesDataSum = 0;
    try {
      if (data != null && promotion.qpsTarget != null) {
        if(data["${promotion.id}"]!=null){
          Map salesData = data["${promotion.id}"];
          for (var sku in promotion.rules!) {
            if (sku.skuId?.isNotEmpty ?? false) {
              if (sku.skuId != "%") {
                Map skuSales = salesData["sales_data"];
                final qpsTarget = promotion.qpsTarget!;
                Map specificSkuSales = skuSales[sku.skuId];
                if (specificSkuSales.isNotEmpty) {
                  if (qpsTarget == QpsTarget.value) {
                    /// total_price
                    salesDataSum += specificSkuSales["total_price"];
                  } else {
                    /// total_volume
                    salesDataSum += specificSkuSales["total_volume"];
                  }
                }
              }
            }
            salesDataSum += ((salesDataSum * (promotion.growthPercentage ?? 0)) / 100);
          }
        }
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return salesDataSum;
  }

  Future<int?> getBestSuggestedPromotionsForThisRetailer({
    required List<PromotionModel> promotions,
    required Map<int, num> salesDataWithGrowthForAllPromotions,
  }) async {
    int? suggestion;
    try {
      Map<int, num> promotionWiseRequiresSales = {};
      for (var p in promotions) {
        if (p.rules != null && (p.rules?.isNotEmpty ?? false)) {
          num needToPurchaseForThisPromotion = 0;
          for (var sku in p.rules!) {
            if (sku.skuId != "%") {
              ProductDetailsModel? skuDetails = await _productCategoryServices.getSkuDetailsFromSkuId(int.tryParse(sku.skuId ?? '0') ?? 0);
              if (skuDetails != null) {
                num packSizeInCase = skuDetails.packSizeCases;
                needToPurchaseForThisPromotion += p.qpsTarget == QpsTarget.volume ? (packSizeInCase * (sku.cases ?? 0)) : (sku.cases ?? 0);
              }
            }
          }
          num finalSumWithGrowthPercentage = needToPurchaseForThisPromotion;
          promotionWiseRequiresSales[p.id] = finalSumWithGrowthPercentage;
        }
      }

      final sorted = promotionWiseRequiresSales.entries.toList()..sort((a, b) => a.value.compareTo(b.value));
      promotionWiseRequiresSales = {for (var entry in sorted) entry.key: entry.value};
      // var sum = sums.reduce((a, b) => a + b);
      print('final map is::: ${promotions.first.slabGroupId}\n${salesDataWithGrowthForAllPromotions}\n${promotionWiseRequiresSales}');

      promotionWiseRequiresSales.forEach((key, target) {
        num achievement = salesDataWithGrowthForAllPromotions[key] ?? 0;
        if (achievement >= target) {
          print("key is::::: $key");
          suggestion = key;
        }
      });
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return suggestion;
  }
}
