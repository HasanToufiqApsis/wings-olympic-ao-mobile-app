import 'dart:developer';

import '../../../models/products_details_model.dart';
import '../../../models/trade_promotions/applied_discount_model.dart';

class LoadSummaryDetails {
  int? depId;
  int? sectionId;
  String? route;
  String? outletName;
  String? address;
  String? outletCode;
  int? outletId;
  String? ownerName;
  String? contactNumber;
  int? loadSummaryId;
  num? total;
  List<LoadSummarySkus>? skus;

  // List<ProductDetailsModel>? formatedSkuList;
  num? totalPrice;
  List<AppliedDiscountModel>? discount;

  LoadSummaryDetails({
    this.depId,
    this.sectionId,
    this.route,
    this.outletName,
    this.address,
    this.outletCode,
    this.outletId,
    this.ownerName,
    this.contactNumber,
    this.loadSummaryId,
    this.total,
    this.skus,
    // this.formatedSkuList,
    this.totalPrice,
    this.discount,
  });

  LoadSummaryDetails.fromJson(
      Map<String, dynamic> json,
      List<ProductDetailsModel> skuList,
      List<AppliedDiscountModel>? discounts) {
    depId = json['dep_id'];
    sectionId = json['section_id'];
    route = json['route'];
    outletName = json['outlet_name'];
    address = json['address'];
    outletCode = json['outlet_code'];
    outletId = json['outlet_id'];
    ownerName = json['owner_name'];
    contactNumber = json['contact_number'];
    loadSummaryId = json['load_summary_id'];
    total = json['total'];
    if (json['skus'] != null) {
      skus = <LoadSummarySkus>[];
      json['skus'].forEach((v) {
        int index = skuList.indexWhere((e) => e.id == v["sku_id"]);
        if (index != -1) {
          final fSku = skuList[index];
          int promotionIndex = discounts?.indexWhere(
                  (e) => e.promotion.appliedSkus.first.skuId == fSku.id) ??
              -1;
          List<AppliedDiscountModel> listDiscount = discounts?.where((e) {
                List<int> listSkuId =
                    e.promotion.appliedSkus.map((e) => e.skuId).toList();
                return listSkuId.contains(fSku.id);
              }).toList() ??
              [];
          print(
              "discount list ::::: ${discounts?.length} :: ${listDiscount.length}");
          // if(promotionIndex != -1) {
          //   var discount = discounts![promotionIndex];
          // log("~~~#~~~> ${fSku.id} : ${discount.promotion.appliedSkus.first.skuId}");
          // log("~~~#~~> ${fSku.nameBn} : ${discount.skuWiseAppliedDiscountAmount.first.discountAmount}");
          skus!.add(LoadSummarySkus.fromJson(v, fSku, listDiscount));
          // } else {
          //   skus!.add(LoadSummarySkus.fromJson(v, fSku, null));
          // }
        } else {
          skus!.add(LoadSummarySkus.fromJson(v, null, null));
        }
      });
    }
    // if (json['skus'] != null) {
    //   skus = <LoadSummarySkus>[];
    //   json['skus'].forEach((v) {
    //     int index = skuList.indexWhere((e) => e.id == v["sku_id"]);
    //     if(index != -1) {
    //       if(discounts!=null && discounts.isNotEmpty) {
    //         int promotionIndex = discounts.indexWhere((e) => e.promotion.appliedSkus.first.skuId == v["sku_id"]);
    //         if(promotionIndex != -1) {
    //           final discount = discounts[index];
    //           final fSku = skuList[index];
    //           skus!.add(LoadSummarySkus.fromJson(v, fSku, discount));
    //         } else {
    //           final fSku = skuList[index];
    //           skus!.add(LoadSummarySkus.fromJson(v, fSku, null));
    //         }
    //       } else {
    //         final fSku = skuList[index];
    //         skus!.add(LoadSummarySkus.fromJson(v, fSku, null));
    //       }
    //     } else {
    //       skus!.add(LoadSummarySkus.fromJson(v, null, null));
    //     }
    //   });
    // }
    totalPrice = json['total_price'];
    discount = discounts;
  }
}

class LoadSummarySkus {
  num? volume;
  num? unitPrice;
  num? totalPrice;
  int? skuId;
  String? packSize;
  num? packVolume;
  ProductDetailsModel? formatedSku;
  List<AppliedDiscountModel>? discount;

  LoadSummarySkus({
    this.volume,
    this.unitPrice,
    this.totalPrice,
    this.skuId,
    this.packSize,
    this.packVolume,
    this.formatedSku,
    this.discount,
  });

  LoadSummarySkus.fromJson(Map<String, dynamic> json, ProductDetailsModel? sku,
      List<AppliedDiscountModel>? discounts) {
    volume = json['volume'];
    unitPrice = json['unit_price'];
    totalPrice = json['total_price'];
    skuId = json['sku_id'];
    packSize = json['pack_size'];
    packVolume = json['pack_volume'];
    formatedSku = sku;
    discount = discounts;
  }
}
