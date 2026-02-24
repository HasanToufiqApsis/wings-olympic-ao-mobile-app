import '../../constants/constant_keys.dart';
import '../../utils/promotion_utils.dart';
import '../sales/formatted_sales_preorder_discount_data_model.dart';
import 'applied_discount_model.dart';

class PromotionModel {
  final int id;
  final int sbuId;
  final String label;
  late PayableType payableType;
  final DiscountType discountType;
  final QpsTarget? qpsTarget;
  final num? numberOfMemo;
  final num capValue;
  final num discountAmount;
  final bool isDependent;
  final int? slabGroupId;
  final List<SkuWiseQtyModel> appliedSkus;
  final List<SkuWiseQtyModel> discountSkus;
  final bool isFractional;
  final List<Rules>? rules;
  final int totalApplicableQuantity;
  final int? targetAmount; ///for qps target
  final int? growthPercentage; ///for qps
  final String? startDate;
  final String? endDate;

  PromotionModel({
    required this.id,
    required this.sbuId,
    required this.label,
    required this.payableType,
    required this.discountType,
    this.qpsTarget,
    this.numberOfMemo,
    required this.capValue,
    required this.discountAmount,
    required this.isDependent,
    required this.slabGroupId,
    required this.appliedSkus,
    required this.discountSkus,
    required this.isFractional,
    this.rules,
    required this.totalApplicableQuantity,
    this.targetAmount,
    this.growthPercentage,
    this.startDate,
    this.endDate,
  });


  factory PromotionModel.fromJson(Map json) {
    List<SkuWiseQtyModel> appliedSkus = [];
    if (json['skus'] != null) {
      if (json['skus'].isNotEmpty) {
        for (Map json in json['skus']) {
          appliedSkus.add(SkuWiseQtyModel.fromJson(json));
        }
      }
    }

    List<SkuWiseQtyModel> discountSkus = [];
    if (json['discount_on'] != null) {
      if (json['discount_on'].isNotEmpty) {
        for (Map json in json['discount_on']) {
          discountSkus.add(SkuWiseQtyModel.fromJson(json));
        }
      }
    }

    List<Rules> rulesList = [];
    if (json['rules'] != null) {
      if (json['rules'].isNotEmpty) {
        json['rules'].forEach((v) {
          rulesList.add(Rules.fromJson(v));
        });
      }
    }

    return PromotionModel(
      id: json['id'],
      sbuId: json['sbu_id'] ?? 1,
      label: json['label'],
      payableType: PayableTypeUtils.toType(json['payable_type']),
      discountType: DiscountTypeUtils.toType(json['discount_type']),
      qpsTarget: QpsTargetUtils.toType(json['target_on'] ?? ''),
      numberOfMemo: json['number_of_memo'] ?? 0,
      capValue: json['cap_value'] ?? 0,
      discountAmount: json['discount_amount'] ?? 0,
      isDependent: json['is_dependency'] == 1,
      slabGroupId: json['slab_group_id'],
      appliedSkus: appliedSkus,
      discountSkus: discountSkus,
      isFractional: json['is_fractional'] == 1,
      rules: rulesList,
      totalApplicableQuantity: json['total_applicable_quantity'] ?? 0,
      targetAmount: json['target_amount'] ?? 0,
      growthPercentage: json['growth_percentage'] ?? 0,
      startDate: json['start_date']??'',
      endDate: json['end_date']??'',
    );
  }
}

///===================== Sku wise promotion qty model =======================
class SkuWiseQtyModel {
  final int skuId;
  final int appliedUnit;
  final num discountQty;

  SkuWiseQtyModel(
      {required this.skuId, this.appliedUnit = 0, this.discountQty = 0});

  factory SkuWiseQtyModel.fromJson(Map json) {
    return SkuWiseQtyModel(
        skuId: json["sku_id"],
        appliedUnit: json["applied_unit"] ?? 0,
        discountQty: json["discount_val"] ?? 0);
  }
}

//==============  Discount Preview Model =================

class DiscountPreviewModel {
  final int promotionId;
  final PayableType payableType;
  final DiscountType discountType;
  final num appliedDiscount;
  bool? isFractional;
  final List<SkuWiseAppliedDiscountAmountModel> discountSkus;

  DiscountPreviewModel(
      {required this.promotionId,
      required this.payableType,
      required this.discountType,
      required this.discountSkus,
      required this.appliedDiscount,
      this.isFractional});

  factory DiscountPreviewModel.fromJson(Map json, int promotionId) {
    List<SkuWiseAppliedDiscountAmountModel> discountSkus = [];
    Map discountSkuMap = json[promotionDataDiscountSkusKey] ?? {};
    if (discountSkuMap.isNotEmpty) {
      discountSkuMap.forEach((key, value) {
        discountSkus.add(SkuWiseAppliedDiscountAmountModel.fromJson(value));
      });
    }

    return DiscountPreviewModel(
      promotionId: promotionId,
      payableType: PayableTypeUtils.toType(json[promotionDataPayableTypeKey]),
      discountType:
          DiscountTypeUtils.toType(json[promotionDataDiscountTypeKey]),
      discountSkus: discountSkus,
      appliedDiscount: json[promotionDataDiscountAmountKey] ?? 0,
      isFractional: json['is_fractional'] ?? false,
    );
  }
}
