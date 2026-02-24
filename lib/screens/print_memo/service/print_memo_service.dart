import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../api/global_http.dart';
import '../../../api/links.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../constants/sync_global.dart';
import '../../../models/outlet_model.dart';
import '../../../models/products_details_model.dart';
import '../../../models/returned_data_model.dart';
import '../../../models/sales/sale_data_model.dart';
import '../../../models/sr_info_model.dart';
import '../../../models/trade_promotions/applied_discount_model.dart';
import '../../../models/trade_promotions/promotion_model.dart';
import '../../../services/ff_services.dart';
import '../../../services/helper.dart';
import '../../../services/outlet_services.dart';
import '../../../services/price_services.dart';
import '../../../services/product_category_services.dart';
import '../../../services/sync_read_service.dart';
import '../../../services/trade_promotion_services.dart';
import '../../../utils/promotion_utils.dart';
import '../model/cross_promotion_applicable.dart';
import '../model/load_summaryDetailsModel.dart';
import '../model/load_summary_model.dart';
import '../model/retailer_promotion_model.dart';
import '../model/retailer_wise_memo_data.dart';
import '../model/trip_wise_memo_data.dart';
import '../repository/print_memo_repository.dart';

class PrintMemoService {
  final _productCategoryServices = ProductCategoryServices();
  final _printMemoRepository = PrintMemoRepository();
  final _tradePromotionServices = TradePromotionServices();
  final _priceService = PriceServices();

  Future<List<LoadSummaryModel>> getLoadSummary({required DateTime date}) async {
    List<LoadSummaryModel> finalList = [];
    try {
      final responseData = await _printMemoRepository.getLoadSummary(date: apiDateFormat.format(date));
      SrInfoModel sr = await SyncReadService().getSrInfo();
      if(responseData.data != null){
        Map mapData = responseData.data;
        print("map data: $mapData");
        if (mapData.containsKey("data")) {
          mapData['data'].forEach((v) {
            if(sr.ffId.toString() == v["ff_id"]) {
              finalList.add(LoadSummaryModel.fromJson(v));
            }
          });
        }
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return finalList;
  }

  Future<Map<String, List<LoadSummaryDetails>>> getLoadSummaryDetails({required LoadSummaryModel loadSummary, required DateTime date}) async {
    Map<String, List<LoadSummaryDetails>> finalList = {};
    try {
      final responseData = await _printMemoRepository.getLoadSummaryDetails(loadSummary: loadSummary, date: date);
      final retailerAndPromotions = await getUpdatedRetailerListFromApi(loadSummary.date ?? "");
      final retailerList = retailerAndPromotions.retailerList;
      final promotionList = retailerAndPromotions.promotionList;

      List<int> allSkuList = [];
      Map<int, ProductDetailsModel> skuMap = {};

      Map mapData = responseData.data;
      if (mapData.containsKey("data")) {
        mapData['data'].entries.forEach((entry) {
          entry.value.forEach((v) {
            v["skus"].forEach((sku) {
              if(!allSkuList.contains(sku["sku_id"])) {
                allSkuList.add(sku["sku_id"]);
              }
            });
          });
        });
      }

      for(var val in allSkuList) {
        final skuDetails = await _productCategoryServices.getSkuDetailsFromSkuId(val);
        if(skuDetails!=null) {
          skuMap[val] = skuDetails;
        }
      }

      List<Map<String, dynamic>> loadSummaryList = [];

      if (mapData.containsKey("data")) {
        mapData['data'].entries.forEach((entry) {
          entry.value.forEach((v) async {
            loadSummaryList.add(v);
          });
        });
      }

      final allProductList = await _productCategoryServices.getAllProductDetailsList();
      Map<int, ProductDetailsModel> localSkuMap = {};
      for(var skus in allProductList) {
        localSkuMap[skus.id] = skus;
      }
      for(var v in loadSummaryList) {
        List<ProductDetailsModel> skuList = [];

        Map<int, SaleDataModel> counts = {};

        List<Map> s = [];
        v["skus"].forEach((sku) {
          s.add(sku);
        });

        // print("RETTAILER ID:: ${v["outlet_id"]}");
        final retailerIndex = retailerList.indexWhere((e) => e.id == v["outlet_id"]); //e.outletCode == "R322111123-288"
        if(retailerIndex != -1) {
          Map<int, ProductDetailsModel> tempLocalSkuMap = {};
          tempLocalSkuMap = localSkuMap;
          for(var sku in s) {
            if(skuMap.containsKey(sku["sku_id"])) {
              skuList.add(skuMap[sku["sku_id"]]!);
            }
            final skuBasePrice = _priceService.getBasePriceForASku(sku["sku_id"]);
            ProductDetailsModel temp = skuMap[sku["sku_id"]]!;

            SaleDataModel saleDataModel = SaleDataModel(
                qty: sku["volume"],
                price: sku["volume"]*skuBasePrice,
                discount: 0,
                qcPrice: 0,
                salesDate: "",
                salesDateTime: ""
            );
            temp.preorderData = saleDataModel;
            tempLocalSkuMap[sku["sku_id"]] = temp;
            counts[sku["sku_id"]] = saleDataModel;
          }
          final availablePromotions = _tradePromotionServices.getAvailablePromotionForARetailerFromPromotions(
              retailerList[retailerIndex],
              promotionList,
          );
          List<int> beforeSelectedPromotion = availablePromotions.where((e) => (e.rules?.isNotEmpty??false) && e.discountType == DiscountType.normal).map((e) => e.id).toList();
          print("Before seledted :: ${beforeSelectedPromotion.length}");
          // beforeSelectedPromotion = [1566, 1567];
          var discount = await _tradePromotionServices.getAppliedDiscountsForARetailerFromPromotions(
              retailerList[retailerIndex],
              counts,
              tempLocalSkuMap,
              skuList,
              beforeSelectedPromotion,
              promotionList,
          );

          for(var val in discount) {
            print("UREKA ~!~!~!@> ${val.appliedDiscount} : $beforeSelectedPromotion");
            // print("UREKA ~!~!~!@> ${val.skuWiseAppliedDiscountAmount.first.discountAmount}");
            // print("UREKA ~!~!~!@> ${val.promotion.discountAmount}");
          }

          final loadSum = LoadSummaryDetails.fromJson(v, skuList, discount);

          if(finalList.containsKey(v["load_summary_id"].toString())) {
            List<LoadSummaryDetails> list = finalList[v["load_summary_id"].toString()] ?? [];
            finalList[v["load_summary_id"].toString()] = [...list, loadSum];
          } else {
            finalList[v["load_summary_id"].toString()] = [loadSum];
          }
        }
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return finalList;
  }

  Future<RetailerPromotionModel> getUpdatedRetailerListFromApi(String date) async {
    List<OutletModel> retailerList = [];
    List<PromotionModel> promotionList = [];
    try {
      final responseData = await _printMemoRepository.getDeliveryOutletData(date);
      Map mapData = responseData.data;

      if (mapData.containsKey("delivery_configurations")) {
        if (mapData["delivery_configurations"].containsKey("retailers")) {
          for (Map retailer in mapData["delivery_configurations"]["retailers"]) {
            OutletModel outlet = OutletModel.fromJson(retailer);
            retailerList.add(outlet);
          }
          for (Map promotion in mapData["delivery_configurations"]["promotions"]) {
            PromotionModel promo = PromotionModel.fromJson(promotion);
            promotionList.add(promo);
          }
        }
      }
    } catch (e) {
      Helper.dPrint("inside updateRetailerListFromApi OutletServices catch block $e");
    }
    return RetailerPromotionModel(
      retailerList: retailerList,
      promotionList: promotionList,
    );
  }

  String getFormatedQTY(LoadSummarySkus sku) {
    String purchase = getFormatedQtyPurchasesOnly(sku).toString();
    try {
      num qtyOffer = getFormatedQtyOfferOnly(sku);
      if(qtyOffer!=0) {
        purchase = "$purchase($qtyOffer)";
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return purchase;
  }

  num getFormatedQtyPurchasesOnly(LoadSummarySkus sku) {
    num purchase = ((sku.volume ?? 0) / (sku.formatedSku?.packSizeCases ?? 0));
    return purchase;
  }

  num getFormatedQtyOfferOnly(LoadSummarySkus sku) {
    num discountCount = 0;
    if(sku.discount!=null) {
      if((sku.discount?.isNotEmpty ?? false)) {
        List<AppliedDiscountModel> discounts = sku.discount ?? [];
        for(var discount in discounts) {
          if(discount.promotion.isFractional == true) {
            if(discount.promotion.payableType == PayableType.productDiscount) {
              if(discount.skuWiseAppliedDiscountAmount.isNotEmpty) {
                discountCount+= (discount.skuWiseAppliedDiscountAmount.first.discountAmount ?? 0);
              }
            }
          } else {
            if(discount.promotion.payableType == PayableType.productDiscount) {
              ///check is ts cross product promotion or not
              if(discount.promotion.appliedSkus.isNotEmpty && discount.promotion.discountSkus.isNotEmpty && discount.promotion.appliedSkus.length==1 && discount.promotion.discountSkus.length==1 && (discount.promotion.rules?.isEmpty ?? false)) {
                final appliedSkus = discount.promotion.appliedSkus.first;
                final discountSkus = discount.promotion.discountSkus.first;
                if(appliedSkus.skuId != discountSkus.skuId) {

                }
              } else if(discount.promotion.rules?.isNotEmpty ?? false) {
                log("~!~!~!~!~!!!!> ${discount.promotion.rules}");
                final discountSkus = discount.promotion.discountSkus.first;
                if(discountSkus.skuId == sku.skuId) {
                  discountCount += (discount.skuWiseAppliedDiscountAmount.first.discountAmount ?? 0);
                }
              } else {
                if(discount.skuWiseAppliedDiscountAmount.isNotEmpty) {
                  discountCount+= (discount.skuWiseAppliedDiscountAmount.first.discountAmount ?? 0);
                }
              }
            }
          }
        }
      }
    }
    if(discountCount!=0) {
      return num.tryParse(discountCount.toString().nonZeroText) ?? 0;
    }
    return 0;
  }

  num getFormatedTotal(LoadSummarySkus sku) {
    final price = PriceServices().getBasePriceForASku(sku.skuId??0);
    return num.tryParse(((sku.volume ?? 0) * price).toString().nonZeroText) ?? 0;
  }

  num getFormatedOffer(LoadSummarySkus sku) {
    num discountCount = 0;
    if(sku.discount!=null) {
      if((sku.discount?.isNotEmpty ?? false)) {
        List<AppliedDiscountModel> discounts = sku.discount ?? [];
        for(var discount in discounts) {
          if(discount.promotion.payableType == PayableType.absoluteCash) {
            discountCount+= (discount.skuWiseAppliedDiscountAmount.first.discountAmount ?? 0);
          }
          if(discount.promotion.payableType == PayableType.productDiscount && discount.promotion.isFractional == true) {
            discountCount+= (discount.appliedDiscount ?? 0);
          }
        }
      }
    }
    if(discountCount!=0) {
      return num.tryParse(discountCount.toString().nonZeroText) ?? 0;
    }
    return 0;
  }

  num getFormatedPayable(LoadSummarySkus sku) {
    final offer = getFormatedOffer(sku);
    final total = getFormatedTotal(sku);
    final finalOffer = offer;
    final finalTotal = total;
    return num.tryParse((finalTotal - finalOffer).toString().nonZeroText) ?? 0;
  }

  String getFormatedTotalTotal(LoadSummaryDetails loadSummaryModel) {
    num totalAmount = 0;
    for(LoadSummarySkus sku in loadSummaryModel.skus?? []) {
      final price = PriceServices().getBasePriceForASku(sku.skuId??0);
      totalAmount+= ((sku.volume??0)*price);
    }
    return totalAmount.toString().nonZeroText;
  }

  String getFormatedTotalQTY(LoadSummaryDetails loadSummaryModel) {
    num purchase = 0;
    num purchaseFraction = 0;
    num allDiscount = 0;
    for(LoadSummarySkus sku in loadSummaryModel.skus?? []) {
      final qtyPurchase = getFormatedQtyPurchasesOnly(sku);
      num qtyOffer = getFormatedQtyOfferOnly(sku);

      CrossPromotionApplicable? crossProductDiscount = _checkCrossProductPromotion(sku);
      if(crossProductDiscount!=null) {
        qtyOffer += crossProductDiscount.applicableQuantity;
      }

      if(!isRound(qtyPurchase)) {
        purchaseFraction+=getFractionalPart(qtyPurchase)*(sku.formatedSku?.packSizeCases??0);
      }
      purchase+=qtyPurchase.floor();
      allDiscount+=qtyOffer;
    }
    if(allDiscount!=0) {
      if(purchaseFraction!=0) {
        return "${purchase.toString().nonZeroText}[${purchaseFraction.toString().nonZeroText}](${allDiscount.toString().nonZeroText})";
      }
      return "${purchase.toString().nonZeroText}(${allDiscount.toString().nonZeroText})";
    }
    if(purchaseFraction!=0) {
      return "${purchase.toString().nonZeroText}[${purchaseFraction.toString().nonZeroText}]";
    }
    return purchase.toString().nonZeroText;
  }

  String getFormatedTotalOffer(LoadSummaryDetails loadSummaryModel) {
    num allDiscount = 0;
    for(LoadSummarySkus sku in loadSummaryModel.skus?? []) {
       final offer = getFormatedOffer(sku);
       final positiveOffer = offer;
       allDiscount += (num.tryParse(positiveOffer.toString()) ?? 0);
    }

    if(allDiscount!=0) {
      return "-$allDiscount";
    }
    return "-";
  }

  String getFormatedTotalPayable(LoadSummaryDetails loadSummaryModel) {
    num purchase = 0;
    num discount = 0;
    for(LoadSummarySkus sku in loadSummaryModel.skus?? []) {
      final offer = getFormatedOffer(sku);
      final total = getFormatedTotal(sku);
      final finalOffer = offer;
      final finalTotal = total;
      purchase+=finalTotal;
      discount+=finalOffer;
    }
    return (purchase-discount).toString().nonZeroText;
  }

  String getFormatedQty(RetailerWiseMemoData data) {
    if(data.qtyOffer!=0) {
      return "${getFormatedQtyPurchaseQtyOnly(data)}(${data.qtyOffer.toString().nonZeroText})";
    }
    return getFormatedQtyPurchaseQtyOnly(data);
  }

  String getFormatedQtyPurchaseQtyOnly(RetailerWiseMemoData data) {
    if(isRound(data.qtyPurchase)) {
      return data.qtyPurchase.toString().nonZeroText;
    }
    return "${data.qtyPurchase.floor().toString().nonZeroText}[${(getFractionalPart(data.qtyPurchase)*data.formatedSku.packSizeCases).toString().nonZeroText}]";
  }

  bool isRound(num value) {
    return value.remainder(1) == 0;
  }

  num getFractionalPart(num value) {
    return value - value.truncate();
  }

  static bool isValidString(String text) {
    List<String> characters = allowedCharacters.split("");
    return text.split('').every((char) => characters.contains(char));
  }

  static String allowedCharacters = """ 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!"#\$%&'()*+,-./:;<=>?@[\\]^_`{|}~""";

  Future<List<RetailerWiseMemoData>> printingMemoByOutlet({List<LoadSummarySkus>? loadSumSku}) async {
    Map<int, RetailerWiseMemoData> skuWiseMemoData = {};
    try {
      if(loadSumSku!=null && loadSumSku.isNotEmpty) {
        for(LoadSummarySkus sku in loadSumSku) {
          num qtyPurchase = getFormatedQtyPurchasesOnly(sku);
          num qtyOffer = getFormatedQtyOfferOnly(sku);
          num total = getFormatedTotal(sku);
          num offer = getFormatedOffer(sku);
          num payable = getFormatedPayable(sku);
          CrossPromotionApplicable? crossProductDiscount = _checkCrossProductPromotion(sku);
          if(crossProductDiscount!=null) {
            final skuDetails = await ProductCategoryServices().getSkuDetailsFromSkuId(crossProductDiscount.skuId);
            if(!skuWiseMemoData.containsKey(skuDetails?.id)) {
              RetailerWiseMemoData retailerWiseMemoData = RetailerWiseMemoData(
                qtyOffer: crossProductDiscount.applicableQuantity,
                formatedSku: skuDetails!,
              );
              skuWiseMemoData[skuDetails.id] = retailerWiseMemoData;
            } else {
              RetailerWiseMemoData retailerWiseMemoData = skuWiseMemoData[crossProductDiscount.skuId]!;
              retailerWiseMemoData.qtyOffer += crossProductDiscount.applicableQuantity;
              skuWiseMemoData[skuDetails?.id??0] = retailerWiseMemoData;
            }

            if(skuWiseMemoData.containsKey(sku.skuId)) {
              RetailerWiseMemoData retailerWiseMemoData = skuWiseMemoData[sku.skuId]!;
              retailerWiseMemoData.qtyPurchase += qtyPurchase;
              retailerWiseMemoData.qtyOffer += qtyOffer;
              retailerWiseMemoData.total += total;
              retailerWiseMemoData.offer += offer;
              retailerWiseMemoData.payable += payable;
              skuWiseMemoData[sku.skuId??0] = retailerWiseMemoData;
            } else {
              RetailerWiseMemoData retailerWiseMemoData = RetailerWiseMemoData(
                qtyPurchase: qtyPurchase,
                qtyOffer: qtyOffer,
                total: total,
                offer: offer,
                payable: payable,
                formatedSku: sku.formatedSku!,
              );
              skuWiseMemoData[sku.skuId??0] = retailerWiseMemoData;
            }

          } else {
            if(skuWiseMemoData.containsKey(sku.skuId)) {
              RetailerWiseMemoData retailerWiseMemoData = skuWiseMemoData[sku.skuId]!;
              retailerWiseMemoData.qtyPurchase += qtyPurchase;
              retailerWiseMemoData.qtyOffer += qtyOffer;
              retailerWiseMemoData.total += total;
              retailerWiseMemoData.offer += offer;
              retailerWiseMemoData.payable += payable;
              skuWiseMemoData[sku.skuId??0] = retailerWiseMemoData;
            } else {
              RetailerWiseMemoData retailerWiseMemoData = RetailerWiseMemoData(
                qtyPurchase: qtyPurchase,
                qtyOffer: qtyOffer,
                total: total,
                offer: offer,
                payable: payable,
                formatedSku: sku.formatedSku!,
              );
              skuWiseMemoData[sku.skuId??0] = retailerWiseMemoData;
            }
          }
        }
      }

    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return skuWiseMemoData.values.toList();
  }


  Future<List<TripWiseMemoData>> getAllTripLoadSummaryDetails({required Map<String, List<LoadSummaryDetails>> loadSummary}) async {

    Map<int, TripWiseMemoData> skuWiseMemoData = {};
    try {
      // List<LoadSummaryDetails> loadSummaryDetails = [];
      // print("LALALAL ${loadSummaryDetails.length}");

      List<List<LoadSummaryDetails>> load =[];

      loadSummary.forEach((key, value) {
        load.add(value);
      });

      // int a = 0;
      for(int a = 0; a!= load.length ; a++) {
        for(LoadSummaryDetails val in load[a]) {
          List<RetailerWiseMemoData> v = await printingMemoByOutlet(loadSumSku: val.skus);
          for(RetailerWiseMemoData data in v) {
            if(skuWiseMemoData.containsKey(data.formatedSku.id)) {
              TripWiseMemoData tripWiseMemoData = skuWiseMemoData[data.formatedSku.id]!;
              Map<num, num> tempPurchase = tripWiseMemoData.qtyPurchase;
              Map<num, num> tempOffer = tripWiseMemoData.qtyOffer;
              num purchase = 0;
              num offer = 0;

              if(tempPurchase.containsKey(a)) {
                tempPurchase[a] = (tempPurchase[a]??0) + data.qtyPurchase;
              } else {
                tempPurchase[a] = data.qtyPurchase;
              }

              if(tempOffer.containsKey(a)) {
                tempOffer[a] = (tempOffer[a]??0) + data.qtyOffer;
              } else {
                tempOffer[a] = data.qtyOffer;
              }

              // print("~~!~~!~~> #3: $a");
              print("!!+++>> ${purchase} : $offer : ${tripWiseMemoData.qtyPurchase} : ${tripWiseMemoData.qtyOffer}");
              tripWiseMemoData.qtyPurchase = tempPurchase;
              tripWiseMemoData.qtyOffer  = tempOffer;
              tripWiseMemoData.total += data.total;
              tripWiseMemoData.offer += data.offer;
              tripWiseMemoData.payable += data.payable;
              skuWiseMemoData[data.formatedSku.id] = tripWiseMemoData;
            } else {
              TripWiseMemoData tripWiseMemoData = TripWiseMemoData(
                qtyPurchase: {a: data.qtyPurchase},
                qtyOffer: {a: data.qtyOffer},
                total: data.total,
                offer: data.offer,
                payable: data.payable,
                formatedSku: data.formatedSku,
              );
              skuWiseMemoData[data.formatedSku.id] = tripWiseMemoData;
            }
          }
        }
      }

    } catch (e,t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return skuWiseMemoData.values.toList();
  }

  CrossPromotionApplicable? _checkCrossProductPromotion(LoadSummarySkus sku) {
    List<AppliedDiscountModel> discounts = sku.discount ?? [];
    if(discounts.isNotEmpty) {
      for(var discount in discounts) {
        if(discount.promotion.payableType == PayableType.productDiscount) {
          if(discount.promotion.appliedSkus.isNotEmpty && discount.promotion.discountSkus.isNotEmpty && discount.promotion.appliedSkus.length==1 && discount.promotion.discountSkus.length==1) {
            final appliedSkus = discount.promotion.appliedSkus.first;
            final discountSkus = discount.promotion.discountSkus.first;
            if(appliedSkus.skuId!=discountSkus.skuId) {
              return CrossPromotionApplicable(
                skuId: discountSkus.skuId,
                applicableQuantity: discount.appliedDiscount
              );
            }
          }
        }
      }
    }

    return null;
  }
}