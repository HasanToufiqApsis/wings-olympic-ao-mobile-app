import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/src/consumer.dart';

import '../api/global_http.dart';
import '../api/links.dart';
import '../constants/constant_keys.dart';
import '../constants/constant_variables.dart';
import '../constants/enum.dart';
import '../constants/sync_global.dart';
import '../models/delivery/delivery_summary_model.dart';
import '../models/module.dart';
import '../models/outlet_model.dart';
import '../models/products_details_model.dart';
import '../models/returned_data_model.dart';
import '../models/sales/sale_data_model.dart';
import '../models/sr_info_model.dart';
import '../models/trade_promotions/applied_discount_model.dart';
import '../provider/global_provider.dart';
import '../utils/sales_type_utils.dart';
import 'ff_services.dart';
import 'helper.dart';
import 'offline_pda_service.dart';
import 'pre_order_service.dart';
import 'price_services.dart';
import 'product_category_services.dart';
import 'sync_read_service.dart';
import 'sync_service.dart';
import 'trade_promotion_services.dart';

class DeliveryServices {
  final SyncService _syncService = SyncService();
  final FFServices _ffServices = FFServices();

  final ProductCategoryServices _productCategoryServices = ProductCategoryServices();
  final TradePromotionServices _tradePromotionServices = TradePromotionServices();

  Future<bool> checkIfDeliveryEnabled() async {
    bool enabled = false;
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("delivery_configurations")) {
        enabled = syncObj["delivery_configurations"]["delivery_enabled"] == 1;
      }
    } catch (e) {
      Helper.dPrint("inside checkIfDeliveryEnabled DeliveryServices catch block $e");
    }
    return enabled;
  }

  Future<bool> checkIfZeroSaleEnabled() async {
    bool enabled = false;
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("delivery_configurations")) {
        enabled = syncObj["delivery_configurations"]["zero_sale_enabled"] == 1;
      }
    } catch (e) {
      Helper.dPrint("inside checkIfZeroSaleEnabled DeliveryServices catch block $e");
    }
    return enabled;
  }

  doZeroSale(OutletModel retailer) async {
    try {
      await _syncService.checkSyncVariable();
      SrInfoModel? srInfo = await _ffServices.getSrInfo();
      String salesDate = await _ffServices.getSalesDate();
      Map zeroSaleData = {};
      if (srInfo != null) {
        if (syncObj.containsKey("existing_preorders")) {
          if (syncObj["existing_preorders"].containsKey(retailer.id.toString())) {
            Map retailerWisePreorderInfo = syncObj["existing_preorders"][retailer.id.toString()];
            if (retailerWisePreorderInfo.isNotEmpty) {
              retailerWisePreorderInfo.forEach((moduleId, skuWisePreorderInfo) {
                if (skuWisePreorderInfo.isNotEmpty) {
                  zeroSaleData = {
                    zeroSaleSbuIdKey: int.parse(moduleId),
                    zeroSaleDepIdKey: srInfo.depId,
                    zeroSaleFFIdKey: srInfo.ffId,
                    zeroSaleSectionIdKey: srInfo.sectionId,
                    zeroSaleOutletIdKey: retailer.id,
                    zeroSaleOutletCodeKey: retailer.outletCode,
                    zeroSaleSkuIdKey: int.tryParse(skuWisePreorderInfo.keys.first.toString()) ?? 20000001,
                    zeroSaleUnitPriceKey: 0.0,
                    zeroSaleVolumeKey: 0,
                    zeroSaleTotalPriceKey: 0.0,
                    zeroSaleSalesDateKey: salesDate,
                    zeroSaleSalesDatetimeKey: apiDateTimeFormat.format(DateTime.now())
                  };
                  return;
                }
              });
            }
          }
        }
        if (zeroSaleData.isNotEmpty) {
          await saveZeroSaleDataToSync(zeroSaleData, retailer.id ?? 0);
          sendZeroSaleDataToApi(retailer);
        }
      }
    } catch (e) {
      Helper.dPrint("inside doZeroSale salesServices catch block $e");
    }
  }

  saveZeroSaleDataToSync(Map zeroSaleData, int retailerId) async {
    try {
      await _syncService.checkSyncVariable();
      if (!syncObj.containsKey(zeroSaleDataKey)) {
        syncObj[zeroSaleDataKey] = {};
      }
      syncObj[zeroSaleDataKey][retailerId.toString()] = [zeroSaleData];
      await _syncService.writeSync(jsonEncode(syncObj));
    } catch (e) {
      print("inside saveZeroSaleDataToSync saleServices catch block $e");
    }
  }

  sendZeroSaleDataToApi(OutletModel retailer) async {
    try {
      List zeroSaleData = await getZeroSaleDataForARetailer(retailer.id ?? 0);
      if (zeroSaleData.isNotEmpty) {
        String salesDate = await _ffServices.getSalesDate();
        SrInfoModel? srInfo = await _ffServices.getSrInfo();
        Map finalMap = {
          "outlet_id": retailer.id,
          "outlet_code": retailer.outletCode,
          "date": salesDate,
          "section_id": srInfo!.sectionId,
          "ff_id": srInfo.ffId,
          "outlet_data": {}
        };
        finalMap['outlet_data']['sales'] = zeroSaleData;

        ReturnedDataModel returnedDataModel = await GlobalHttp(
                httpType: HttpType.post,
                uri: '${Links.baseUrl}${Links.saveSalesDataUrl}',
                accessToken: srInfo.accessToken,
                refreshToken: srInfo.refreshToken,
                body: jsonEncode(finalMap))
            .fetch();
      }
    } catch (e) {
      print("inside sendZeroSaleDataToApi SaleServices catch block $e");
    }
  }

  Future<List> getZeroSaleDataForARetailer(int retailerId) async {
    List zeroSaleData = [];
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(zeroSaleDataKey)) {
        if (syncObj[zeroSaleDataKey].containsKey(retailerId.toString())) {
          zeroSaleData = syncObj[zeroSaleDataKey][retailerId.toString()];
        }
      }
    } catch (e) {
      print("inside getZeroSaleDataForARetailer SalesServices catch block $e");
    }

    return zeroSaleData;
  }

  Future<bool> checkIfDeliveryDoneForARetailer(int retailerId) async {
    bool done = false;
    try {
      await _syncService.checkSyncVariable();
      Map retailerWiseDelivery = syncObj[deliveryKey]?[retailerId.toString()] ?? {};
      done = retailerWiseDelivery.isNotEmpty;
    } catch (e) {
      print("inside checkIdDeliveryDoneForARetailer catch block $e");
    }
    return done;
  }

  updateRetailerListFromApi() async {
    try {
      SrInfoModel? srInfoModel = await _ffServices.getSrInfo();
      String salesDate = await _ffServices.getSalesDate();
      String url = "${Links.baseUrl}${Links.deliveryRetailerUrl}/${srInfoModel!.ffId}/$salesDate";
      ReturnedDataModel returned =
          await GlobalHttp(uri: url, httpType: HttpType.get, accessToken: srInfoModel.accessToken, refreshToken: srInfoModel.refreshToken).fetch();
      if (returned.status == ReturnedStatus.success) {
        if (syncObj.containsKey("delivery_configurations") && returned.data.containsKey("delivery_configurations")) {
          syncObj["delivery_configurations"] = returned.data["delivery_configurations"];
          await _syncService.writeSync();
        }
      }
    } catch (e) {
      Helper.dPrint("inside updateRetailerListFromApi OutletServices catch block $e");
    }
  }

  Future<ReturnedDataModel?> syncOutletDeliveryData(List<OutletModel> outletList) async {
    try {
      OfflinePdaService offlinePdaService = OfflinePdaService();
      List<OutletModel> deliveryRetailerList = await offlinePdaService.getDeliveryRetailerList();
      print("delivery retailer list $deliveryRetailerList");
      ReturnedDataModel? returnDataModel = await offlinePdaService.getAllOutletDataForSync(outletList, SaleType.delivery);
      if(returnDataModel!=null) {
        return returnDataModel;
      }
    } catch (e) {
      Helper.dPrint("inside syncOutletDeliveryData SaleSubmitController catch block $e");
    }
  }

  Future<Map> formatRetailers(OutletModel outlet, Map modules, Map<int, ProductDetailsModel> discountRelatedSkuInformation, WidgetRef ref) async {
    String salesDate = await _ffServices.getSalesDate();
    Map moduleWiseData = {};

    List<AppliedDiscountModel> discountList = [];

    for (var moduleKey in modules.keys) {
      var moduleValue = modules[moduleKey];
      Map<String, dynamic> preorderData = await PreOrderService().getPreOrderPerRetailer(outlet.id ?? 0, int.parse(moduleKey));

      Map skuWiseData = {};

      Map<int, SaleDataModel> skuWiseCount = {};

      for (var skuKey in preorderData.keys) {
        var skuValue = preorderData[skuKey];
        var product = await _productCategoryServices.getSkuModelFromModuleIdAndSkuId(Module.fromJson(moduleValue), int.parse(skuKey));
        num price = await PriceServices().getSkuPriceForASpecificAmount(product!, outlet, skuValue);

        SaleDataModel saleData = SaleDataModel(qty: skuValue, price: price);
        skuWiseCount[product.id] = saleData;

        //TODO:: need development
        // var discountData=await _promotionServices.getDiscountAmountForRetailerAndSku(outlet,product,skuValue,false);
        //
        // if(discountData!=null)
        //   {
        //     discountList.add(discountData);
        //   }

        skuWiseData[skuKey] = {"stt": skuValue, "price": price, "sales_date": salesDate, "sales_datetime": apiDateTimeFormat.format(DateTime.now())};
      }

      ///todo send all empty array

      List<int> selectedBeforePromotions = ref.read(beforeSelectedSlabPromotion);

      List<ProductDetailsModel> soledProductList = [];

      discountRelatedSkuInformation.forEach((key, value) {
        soledProductList.add(value);
      });

      List<AppliedDiscountModel> discounts = await _tradePromotionServices.getAppliedDiscountsForARetailer(
        outlet,
        skuWiseCount,
        discountRelatedSkuInformation,
        soledProductList,
        selectedBeforePromotions,
      );
      discountList.addAll(discounts);

      moduleWiseData[moduleKey] = skuWiseData;
    }

    return {'moduleWiseData': moduleWiseData, 'discountData': discountList};
  }

  Future<List<DeliverySummaryModel>> deliverySummary() async {
    List<DeliverySummaryModel> list = [];
    try {
      String salesDate = await _ffServices.getSalesDate();
      SrInfoModel? srInfo = await _ffServices.getSrInfo();

      ReturnedDataModel returnedDataModel = await GlobalHttp(
        httpType: HttpType.get,
        uri: '${Links.baseUrl}${Links.deliverySummaryUrl(srInfo?.ffId ?? 0)}',
        accessToken: srInfo?.accessToken,
        refreshToken: srInfo?.refreshToken,
      ).fetch();

      if (returnedDataModel.data != null) {
        returnedDataModel.data['data'].forEach((key, value) {
          value.forEach((k, v) {
            DeliverySummaryModel model = DeliverySummaryModel.fromJson(v);
            model.date = k;
            model.sales?.forEach((element) async {
              ProductDetailsModel sku = await getProductDetailerFromSkuIdForDeliverySummary(element.skuId ?? 0);
              model.sales![model.sales?.indexWhere((e) => e.skuId == element.skuId) ?? 0].sku = sku;
            });
            list.add(model);
          });
        });
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return list;
  }

  Future<ProductDetailsModel> getProductDetailerFromSkuIdForDeliverySummary(int skuId) async {
    List<Module> modules = await SyncReadService().getModuleModelList();

    List<ProductDetailsModel> products = [];
    if (modules.isNotEmpty) {
      for (Module module in modules) {
        List<ProductDetailsModel> allProductForModule = await ProductCategoryServices().getProductDetailsList(module);

        if (allProductForModule.isNotEmpty) {
          for (ProductDetailsModel sku in allProductForModule) {
            products.add(sku);
          }
        }
      }
    }

    return products.firstWhere((element) => element.id == skuId);
  }
}
