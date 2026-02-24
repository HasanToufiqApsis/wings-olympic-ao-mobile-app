import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/enum.dart';
import '../../../constants/sync_global.dart';
import '../../../models/module.dart';
import '../../../models/outlet_model.dart';
import '../../../models/products_details_model.dart';
import '../../../models/returned_data_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../services/delivery_services.dart';
import '../../../services/pre_order_service.dart';
import '../../../services/price_services.dart';
import '../../../services/product_category_services.dart';
import '../../../services/sales_service.dart';
import '../../../services/sync_read_service.dart';
import '../../../services/sync_service.dart';
import '../../../utils/sales_type_utils.dart';

class DeliveryController {
  late BuildContext context;
  late WidgetRef ref;
  late Alerts alerts;

  DeliveryController({required this.context, required this.ref}) {
    alerts = Alerts(context: context);
  }

  final SyncReadService syncReadService = SyncReadService();
  final SyncService syncService = SyncService();
  final ProductCategoryServices productCategoryServices = ProductCategoryServices();
  final PreOrderService preOrderService = PreOrderService();
  final PriceServices priceServices = PriceServices();
  final SalesService salesService = SalesService();

  // saveMultiDelivery(List<OutletModel> outletList) async {
  //   alerts.floatingLoading(message: "Saving...");
  //   final previousSyncFile = syncObj;
  //
  //   Map modules = await syncReadService.getModuleList();
  //   Module? m = await productCategoryServices.getModuleModelFromModuleId(int.tryParse(modules.keys.toList()[0]) ?? 1);
  //
  //   List<ProductDetailsModel> productList = await productCategoryServices.getProductDetailsList(m!);
  //
  //   Map<int, ProductDetailsModel> discountRelatedSkuInformation = {};
  //   for (ProductDetailsModel sku in productList) {
  //     discountRelatedSkuInformation[sku.id] = sku;
  //   }
  //
  //   String errorMessage = '';
  //
  //   Map allStockMap = await salesService.allSkuValidateList(outletList: outletList, ref: ref);
  //
  //   ReturnedDataModel? returnedDataModel = await salesService.isStockAvailableForBulkApi(allStockMap);
  //   if (returnedDataModel != null && returnedDataModel.status == ReturnedStatus.success) {
  //
  //   } else {
  //     errorMessage = returnedDataModel?.errorMessage??"Stock not available!";
  //   }
  //
  //   if (errorMessage.isEmpty) {
  //     await DeliveryServices().syncOutletDeliveryData();
  //     Navigator.pop(context);
  //   } else {
  //     alerts.customDialog(
  //         type: AlertType.error,
  //         description: errorMessage,
  //         onTap1: () {
  //           Navigator.of(context).pop();
  //           Navigator.of(context).pop();
  //           Navigator.of(context).pop();
  //           ref.refresh(dashboardTargetList(m.id));
  //           ref.refresh(deliveryOutletListProvider);
  //           ref.refresh(selectedMultiOutletProvider);
  //         });
  //   }
  // }

  saveMultiDelivery(List<OutletModel> outletList) async {
    alerts.floatingLoading(message: "Saving...");
    final previousSyncFile = jsonEncode(syncObj);

    Map modules = await syncReadService.getModuleList();
    Module? m =await productCategoryServices.getModuleModelFromModuleId(int.tryParse(modules.keys.toList()[0])??1);

    List<ProductDetailsModel> productList = await productCategoryServices.getProductDetailsList(m!);

    Map<int, ProductDetailsModel> discountRelatedSkuInformation = {};
    for (ProductDetailsModel sku in productList) {
      discountRelatedSkuInformation[sku.id] = sku;
    }

    for (var outlet in outletList) {
      Map moduleWiseData = await DeliveryServices().formatRetailers(outlet, modules, discountRelatedSkuInformation, ref);

      var sendData = await salesService.saveAllDataForARetailer(
          retailer: outlet,
          preorderData: moduleWiseData['moduleWiseData'],
          geoData: {},
          appliedDiscounts: moduleWiseData['discountData'],
          qcInfo: {},
          saleStatus: SaleStatus.newSale,
          saleType: SaleType.delivery,
          sendToServer: false);

      print('after sending data: $sendData');

      // if (sendData) {
        ref.refresh(dashboardTargetList(m.id));
        ref.refresh(deliveryOutletListProvider);
        ref.refresh(selectedMultiOutletProvider);
      // }
    }

    ReturnedDataModel? returnDataModel = await DeliveryServices().syncOutletDeliveryData(outletList);

    if(returnDataModel!=null && returnDataModel.status != ReturnedStatus.success) {
      log("replace previous syncfile to new sync file");
      syncObj = jsonDecode(previousSyncFile);
      await syncService.writeSync();
      await syncService.checkSyncVariable();
      String lang = ref.watch(languageProvider);
      String skus = returnDataModel.errorMessage!.replaceAll("Stock not available for sku:", "");
      String messageStart = "Stock not available for SKU: $skus";
      if (lang != "en") {
        messageStart = "এই SKU এর/গুলোর পর্যাপ্ত স্টক নেই: $skus";
      }
      alerts.customDialog(
          type: AlertType.error,
          description: skus.toLowerCase() == "no internet connection"?"No Internet connection" : messageStart,
          onTap1: () async {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            await syncService.checkSyncVariable();
            // ref.refresh(dashboardTargetList(m.id));
            // ref.refresh(deliveryOutletListProvider);
            // ref.refresh(selectedMultiOutletProvider);
          });
    } else {
      Navigator.pop(context);
    }
  }
}
