import 'package:flutter/foundation.dart';

import '../constants/sync_global.dart';
import '../models/outlet_model.dart';
import '../models/products_details_model.dart';
import '../models/qc_info_model.dart';
import 'helper.dart';
import 'sync_read_service.dart';
import 'sync_service.dart';

class PriceServices{

  final SyncReadService _syncReadService = SyncReadService();
  final SyncService _syncService = SyncService();

  double getBasePriceForASku(int skuId) {

    double price = 0.0;
    try {
      if (syncObj.containsKey("price_group")) {
        if (syncObj["price_group"].isNotEmpty) {
          String firstKey = syncObj["price_group"].keys.toList()[0];
          Map firstPriceGroup = syncObj["price_group"][firstKey];
          if (firstPriceGroup.isNotEmpty) {
            if (firstPriceGroup.containsKey(skuId.toString())) {
              price = double.parse(
                  firstPriceGroup[skuId.toString()]["base_price"].toString());
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside getBasePriceForASku priceServices catch block $e $s");
    }
    return price;
  }


  ////////get the base price of a specific SKU for a certain retailer///////////////
  Future<double> getBasePriceForASKUAndRetailer(ProductDetailsModel sku, OutletModel retailer) async {
    double price = 0.0;
    try {
      await _syncService.checkSyncVariable();
      price = syncObj["price_group"][retailer.priceGroup.toString()].containsKey(sku.id.toString())
          ? double.parse(syncObj["price_group"][retailer.priceGroup.toString()][sku.id.toString()]['base_price'].toString())
          : 0.0;
    } catch (e, s) {
      Helper.dPrint("inside getPriceForSpecificSkuAmount PriceService catch block $e");
      Helper.dPrint("inside getPriceForSpecificSkuAmount PriceService catch block stack $s");
    }
    return price;
  }


  ////////get the qc price of a specific SKU for a certain retailer///////////////
  Future<double> getQcPriceForASKUAndRetailer(ProductDetailsModel sku, OutletModel retailer) async {
    double price = 0.0;
    try {
      await _syncService.checkSyncVariable();
      // Helper.dPrint('sku id is:::::: ${sku.id}\n${retailer.qcPriceGroup}\n${syncObj["price_group"][retailer.qcPriceGroup.toString()]}');
      price = syncObj["price_group"][retailer.qcPriceGroup.toString()].containsKey(sku.id.toString())
          ? double.parse(syncObj["price_group"][retailer.qcPriceGroup.toString()][sku.id.toString()]['base_price'].toString())
          : 0.0;
    } catch (e, s) {
      Helper.dPrint("$e");
      Helper.dPrint("$s");
    }
    return price;
  }

  /////// get the sku price for a specific amount and specific retailer/////////
  Future<num> getSkuPriceForASpecificAmount(ProductDetailsModel sku, OutletModel retailer, int unit) async {
    num price = 0.0;
    try {
      num basePrice = await getBasePriceForASKUAndRetailer(sku, retailer);
      price = basePrice * unit;
    } catch (e, s) {
      debugPrint("inside getSkuPriceForASpecificAmount PriceService catch block $e");
      debugPrint("inside getSkuPriceForASpecificAmount PriceService catch block stack $s");
    }
    return price;
  }

  /////// get the qc sku price for a specific amount and specific retailer/////////
  Future<num> getQcSkuPriceForASpecificAmount(ProductDetailsModel sku, OutletModel retailer, int unit) async {
    num price = 0.0;
    try {
      num basePrice = await getQcPriceForASKUAndRetailer(sku, retailer);
      price = basePrice * unit;
    } catch (e, s) {
      debugPrint("inside getSkuPriceForASpecificAmount PriceService catch block $e");
      debugPrint("inside getSkuPriceForASpecificAmount PriceService catch block stack $s");
    }
    return price;
  }

  Future<double> calculateTotalPriceForQc(List<SelectedQCInfoModel> qcInfo) async {
    double totalQcSettlement = 0;

    try {
      if (qcInfo.isNotEmpty) {
        for (SelectedQCInfoModel qc in qcInfo) {
          int totalQC = 0;
          for (QCInfoModel qcInfo in qc.qcInfoList) {
            totalQC = qcInfo.totalValidQCQuantity();
            totalQcSettlement += await getQcSkuPriceForASpecificAmount(qc.sku, qc.retailer, totalQC);
          }
        }
      }
    } catch (e) {
      Helper.dPrint("inside calculateTotalPriceForQc salesController catch block $e");
    }

    return totalQcSettlement;
  }

}



