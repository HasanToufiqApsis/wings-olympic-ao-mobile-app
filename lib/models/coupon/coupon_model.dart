import '../../utils/promotion_utils.dart';

class CouponModel {
  late int id;
  late String code;
  late String description;
  late PayableType discType;
  late DiscountType applicableFor;
  late int isStackable; //1 = with applicable other promotion //0 = not applicable with other promotion
  late int discountValue;
  late int minMemoVal;
  late int capValue;
  late int maxUses;
  late int currentUses;

  CouponModel({
    required this.id,
    required this.code,
    required this.description,
    required this.discType,
    required this.applicableFor,
    required this.isStackable,
    required this.discountValue,
    required this.minMemoVal,
    required this.capValue,
    required this.maxUses,
    required this.currentUses,
  });

  CouponModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    description = json['description'];
    discType = PayableTypeUtils.toType(json['disc_type']);
    applicableFor = DiscountTypeUtils.toType(json['applicable_for']);
    isStackable = json['is_stackable'];
    discountValue = json['discount_value'];
    minMemoVal = json['min_memo_val'];
    capValue = json['max_discount'];
    maxUses = json['max_uses'];
    currentUses = json['current_uses'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['description'] = description;
    data['disc_type'] = PayableTypeUtils.toStr(discType);
    data['applicable_for'] = DiscountTypeUtils.toStr(applicableFor);
    data['is_stackable'] = isStackable;
    data['discount_value'] = discountValue;
    data['min_memo_val'] = minMemoVal;
    data['max_discount'] = capValue;
    data['max_uses'] = maxUses;
    data['current_uses'] = currentUses;
    return data;
  }
}
