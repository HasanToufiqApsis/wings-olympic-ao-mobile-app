import '../../constants/constant_keys.dart';
import 'promotion_model.dart';

class AppliedDiscountModel {
  final PromotionModel promotion;
  num appliedDiscount;
  List<SkuWiseAppliedDiscountAmountModel> skuWiseAppliedDiscountAmount;

  AppliedDiscountModel({
    required this.promotion,
    required this.appliedDiscount,
    required this.skuWiseAppliedDiscountAmount,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['promotion'] = promotion.toString();
    data['appliedDiscount'] = appliedDiscount;
    data['promotions'] = skuWiseAppliedDiscountAmount.map((v) => v.toJson()).toList();
    return data;
  }
}

//============= SKU Wise applied discount amount or qty model

class SkuWiseAppliedDiscountAmountModel {
  final int skuId;
  final String skuName;
  num? discountAmount;

  SkuWiseAppliedDiscountAmountModel({
    required this.skuId,
    required this.skuName,
    required this.discountAmount,
  });

  factory SkuWiseAppliedDiscountAmountModel.fromJson(Map json) {
    return SkuWiseAppliedDiscountAmountModel(
      skuId: json[promotionDataSkuIdKey],
      skuName: json[promotionDataSkuNameKey],
      discountAmount: json[promotionDataDiscountAmountKey],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      promotionDataSkuIdKey: skuId,
      promotionDataSkuNameKey: skuName,
      promotionDataDiscountAmountKey: discountAmount,
    };
  }
}
