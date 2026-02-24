import 'dart:convert';
import 'dart:developer';

import 'package:wings_olympic_sr/services/product_category_services.dart';

import '../api/global_http.dart';
import '../api/links.dart';
import '../constants/constant_keys.dart';
import '../constants/enum.dart';
import '../constants/sync_global.dart';
import '../models/outlet_model.dart';
import '../models/products_details_model.dart';
import '../models/returned_data_model.dart';
import '../models/sr_info_model.dart';
import '../models/trade_promotions/applied_discount_model.dart';
import '../models/trade_promotions/promotion_model.dart';
import '../models/try_before_buy/try_before_buy_model.dart';
import '../utils/promotion_utils.dart';
import 'helper.dart';
import 'price_services.dart';
import 'sync_read_service.dart';
import 'sync_service.dart';

class TryBeforeBuyService {
  final SyncService _syncService = SyncService();
  final SyncReadService _syncReadService = SyncReadService();
  final PriceServices _priceServices = PriceServices();
  final ProductCategoryServices _productCategoryServices = ProductCategoryServices();

  // ProductDetailsModel
  //ProductCategoryServices().getAllSkuListForAProductCategoryAndModule

  Future<List<PromotionModel>> getAllAvailableTryBeforeBuyForARetailer(OutletModel retailer) async {
    List<PromotionModel> list = [];
    try {
      await _syncService.checkSyncVariable();
      Map promotionList = syncObj.containsKey('promotions') ? syncObj['promotions'] : {};
      print("object>>> ${retailer.availableTryBeforeBuy.length}");
      if (retailer.availableTryBeforeBuy.isNotEmpty) {
        retailer.availableTryBeforeBuy.forEach((key, value) {
          if (promotionList.containsKey(key.toString())) {
            Map<String, dynamic> p = promotionList[key.toString()] as Map<String, dynamic>;

            list.add(PromotionModel.fromJson(p));
          }
        });
      }
    } catch (e) {
      Helper.dPrint("inside getAllAvailableTryBeforeBuyForARetailer PromotionServices catch block $e");
    }
    return list;
  }

  Future<List<ProductDetailsModel>> getAllAvailableSkuForThisRetailer({
    required List<PromotionModel> allTryBeforeBuy,
  }) async {
    List<ProductDetailsModel> skuList = [];
    try {
      await _syncService.checkSyncVariable();
      Map modules = syncObj.containsKey("modules") ? syncObj['modules'] : {};
      Map cats = syncObj.containsKey("cats") ? syncObj['cats'] : {};
      modules.forEach((key, value) async {
        String increaseId = await _syncReadService.getIncreasedId(value["id"].toString());
        if (cats.containsKey(key.toString()) && cats[key.toString()].containsKey('10')) {
          Map<String, dynamic> allSkus = cats[key.toString()]['10'];

          for (var tryBeforeBuy in allTryBeforeBuy) {
            for (var sku in tryBeforeBuy.discountSkus) {
              if (allSkus.containsKey(sku.skuId.toString())) {
                final skuUnitConfig = _productCategoryServices.getSkuUnitConfigBySkuId(skuId: sku.skuId.toString());
                Map<String, dynamic> skuDetails = allSkus[sku.skuId.toString()];

                skuList.add(ProductDetailsModel.fromJson(skuDetails, '', increaseId, unitConfiguration: skuUnitConfig));
              }
            }
          }
          print('all akus is:: $allSkus');
        }
      });
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return skuList;
  }

  Future<List<ProductDetailsModel>> getAllAvailableSkuForThisTryBeforeBuy({
    required PromotionModel tryBeforeBuy,
    required OutletModel retailer,
  }) async {
    List<ProductDetailsModel> skuList = [];
    try {
      await _syncService.checkSyncVariable();
      Map modules = syncObj.containsKey("modules") ? syncObj['modules'] : {};
      Map cats = syncObj.containsKey("cats") ? syncObj['cats'] : {};

      modules.forEach((key, value) {
        String increaseId = _syncReadService.getIncreasedIdSync(value["id"].toString());
        if (cats.containsKey(key.toString()) && cats[key.toString()].containsKey('10')) {
          Map<String, dynamic> allSkus = cats[key.toString()]['10'];

          for (var sku in tryBeforeBuy.discountSkus) {
            if (allSkus.containsKey(sku.skuId.toString())) {
              final skuUnitConfig = _productCategoryServices.getSkuUnitConfigBySkuId(skuId: sku.skuId.toString());
              Map<String, dynamic> skuDetailsMap = allSkus[sku.skuId.toString()];
              ProductDetailsModel skuDetails = ProductDetailsModel.fromJson(skuDetailsMap, '', increaseId, unitConfiguration: skuUnitConfig);
              bool alreadyTested = alreadyTestThisSkuFromThisTryBeforeBuy(sku: skuDetails, tryBeforeBuy: tryBeforeBuy, retailer: retailer);
              if (alreadyTested == false) {
                skuList.add(skuDetails);
              }
            }
          }
        }
      });
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return skuList;
  }

  bool alreadyTestThisSkuFromThisTryBeforeBuy({
    required ProductDetailsModel sku,
    required PromotionModel tryBeforeBuy,
    required OutletModel retailer,
  }) {
    try {
      if (syncObj.containsKey(tryBeforeBuyKey)) {
        if (syncObj[tryBeforeBuyKey].containsKey(retailer.id.toString())) {
          if (syncObj[tryBeforeBuyKey][retailer.id.toString()].containsKey(tryBeforeBuy.id.toString())) {
            if (syncObj[tryBeforeBuyKey][retailer.id.toString()][tryBeforeBuy.id.toString()][promotionDataDiscountSkusKey].containsKey(sku.id.toString())) {
              return true;
            }
          }
        }
      }

      return false;
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
      return false;
    }
  }

  Future<void> saveSingleTryBeforeBuyData({
    required int retailerId,
    required AppliedDiscountModel discount,
  }) async {
    await _syncService.checkSyncVariable();

    try {
      if (!syncObj.containsKey(tryBeforeBuyKey)) {
        syncObj[tryBeforeBuyKey] = {};
      }

      if (!syncObj[tryBeforeBuyKey].containsKey(retailerId.toString())) {
        syncObj[tryBeforeBuyKey][retailerId.toString()] = {};
      }

      Map discountSkus = {};

      if (syncObj[tryBeforeBuyKey][retailerId.toString()].containsKey(discount.promotion.id.toString())) {
        if (syncObj[tryBeforeBuyKey][retailerId.toString()][discount.promotion.id.toString()].containsKey(promotionDataDiscountSkusKey)) {
          discountSkus = syncObj[tryBeforeBuyKey][retailerId.toString()][discount.promotion.id.toString()][promotionDataDiscountSkusKey];
        }
      }

      print('previous discount sku:: ${jsonEncode(discountSkus)}');

      if (discount.skuWiseAppliedDiscountAmount.isNotEmpty) {
        for (SkuWiseAppliedDiscountAmountModel discountSku in discount.skuWiseAppliedDiscountAmount) {
          try {
            Map discountMap = discountSku.toJson();

            discountSkus[discountSku.skuId.toString()] = discountMap;
            print('new discount sku:: ${jsonEncode(discountSkus)}');
          } catch (e, t) {
            log(e.toString());
            log(t.toString());
          }
        }
      }

      Map tryBeforeBuyMap = {
        promotionDataPayableTypeKey: PayableTypeUtils.toStr(PayableType.productDiscount),
        promotionDataDiscountTypeKey: DiscountTypeUtils.toStr(DiscountType.normal),
        promotionDataDiscountAmountKey: discount.promotion.discountAmount,
        promotionDataDiscountSkusKey: discountSkus,
      };
      // print('try before you buy data is::::: ${jsonEncode(promotionMap)}');

      syncObj[tryBeforeBuyKey][retailerId.toString()][discount.promotion.id.toString()] = tryBeforeBuyMap;
      await SyncService().writeSync(jsonEncode(syncObj));
      log('save try before buy--> ${jsonEncode(tryBeforeBuyMap)}');
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
  }

  Future<bool> saveAllTryBeforeYouBuy({
    required List<TryBeforeBuyModel> tryBeforeBuyList,
    required OutletModel retailer,
  }) async {
    try {
      for (TryBeforeBuyModel val in tryBeforeBuyList) {
        AppliedDiscountModel appliedDiscountModel = AppliedDiscountModel(
          promotion: val.tryBeforeBuy,
          appliedDiscount: val.tryBeforeBuy.discountAmount,
          skuWiseAppliedDiscountAmount: [
            ...[
              SkuWiseAppliedDiscountAmountModel(
                skuId: val.sku.id,
                skuName: val.sku.shortName,
                discountAmount: val.tryBeforeBuy.discountAmount,
              )
            ]
          ],
        );

        await saveSingleTryBeforeBuyData(
          retailerId: retailer.id ?? 0,
          discount: appliedDiscountModel,
        );
      }
      return true;
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return false;
  }

  Future<bool> sendTryBeforeYouBuyToApi({
    required OutletModel retailer,
    required List<TryBeforeBuyModel> tryBeforeYouBuys,
  }) async {
    try {
      await _syncService.checkSyncVariable();
      SrInfoModel srInfo = await _syncReadService.getSrInfo();
      String salesDate = await _syncReadService.getSalesDate();

      if (syncObj.containsKey(tryBeforeBuyKey)) {
        if (syncObj[tryBeforeBuyKey].containsKey(retailer.id.toString())) {
          Map retailerTryBeforeYouBuy = syncObj[tryBeforeBuyKey][retailer.id.toString()];

          Map<String, dynamic> finalMap = {"promotions": []};

          List<int> soledSkuId = tryBeforeYouBuys.map((element) => element.sku.id).toList();

          retailerTryBeforeYouBuy.forEach((key, value) {
            if (value.containsKey(promotionDataDiscountSkusKey)) {
              Map discountSku = value[promotionDataDiscountSkusKey];

              discountSku.forEach((k1, v1) {
                if (soledSkuId.contains(v1[promotionDataSkuIdKey])) {
                  Map<String, dynamic> singleTBYB = {};

                  double price = _priceServices.getBasePriceForASku(v1[promotionDataSkuIdKey]);

                  singleTBYB = {
                    "sbu_id": int.tryParse(srInfo.sbuId.replaceAll("[", "").replaceAll("]", "")), //TODO:: need to change later
                    "dep_id": srInfo.depId,
                    "section_id": srInfo.sectionId,
                    "ff_id": srInfo.ffId,
                    "outlet_id": retailer.id,
                    "outlet_code": retailer.outletCode,
                    "date": salesDate,
                    "promotion_id": key.toString(),
                    "volume": v1[promotionDataDiscountAmountKey], //pcs
                    "value": price,
                    "sku_id": v1[promotionDataSkuIdKey],
                  };
                  finalMap['promotions'].add(singleTBYB);
                }
              });
            }
          });
          ReturnedDataModel returnedDataModel = await GlobalHttp(
            httpType: HttpType.post,
            uri: Links.tryBeforeYouBuySubmit,
            accessToken: srInfo.accessToken,
            refreshToken: srInfo.refreshToken,
            body: jsonEncode(finalMap),
          ).fetch();

          if (returnedDataModel.status == ReturnedStatus.success) {
            return true;
          }
          return false;
        }
      }
      return false;
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
      return false;
    }
  }
}
