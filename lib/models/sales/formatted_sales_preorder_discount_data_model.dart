import '../../utils/case_piece_type_utils.dart';
import '../../utils/sales_type_utils.dart';
import '../coupon/coupon_model.dart';
import '../module.dart';
import '../outlet_model.dart';
import '../products_details_model.dart';
import '../trade_promotions/applied_discount_model.dart';
import 'sale_data_model.dart';

class FormattedSalesPreorderDiscountDataModel {
  Map<int, List<ProductDetailsModel>> preorderData;
  Map<int, List<AppliedDiscountModel>> discountData;
  SaleDataModel totalSaleData;
  Map<CasePieceType, dynamic> unitWiseTotalQty;

  FormattedSalesPreorderDiscountDataModel({
    required this.preorderData,
    required this.discountData,
    required this.totalSaleData,
    required this.unitWiseTotalQty,
  });
}

class AllKindOfSaleDataModel {
  final OutletModel retailer;
  final List<Module> modules;
  final List<List<SlabDiscountModel>>? slabsList;
  final FormattedSalesPreorderDiscountDataModel salesPreorderDiscountDataModel;
  final bool saleEdit;
  SaleType saleType;
  late CouponModel? coupon;

  AllKindOfSaleDataModel({
    required this.retailer,
    required this.modules,
    required this.salesPreorderDiscountDataModel,
    required this.saleEdit,
    this.saleType = SaleType.preorder,
    this.slabsList,
    this.coupon,
  });
}

class SlabDiscountModel {
  late bool selected;
  int? slabGroupId;
  int? id;
  String? label;
  String? payableType;
  String? discountType;
  int? capValue;
  num? discountAmount;
  int? isDependency;
  int? entireMemo;
  int? restriction;
  int? totalApplicableQuantity;
  String? discountProductType;
  List<Rules>? rules;
  List<Skus>? skus;

  SlabDiscountModel(
      {required this.selected,
      this.slabGroupId,
      this.id,
      this.label,
      this.payableType,
      this.discountType,
      this.capValue,
      this.discountAmount,
      this.isDependency,
      this.entireMemo,
      this.restriction,
      this.totalApplicableQuantity,
      this.discountProductType,
      this.rules,
      this.skus});

  SlabDiscountModel.fromJson(Map<String, dynamic> json) {
    // print('--------> total applicable quantity ${json['total_applicable_quantity']}');
    selected = false;
    slabGroupId = json['slab_group_id'];
    id = json['id'];
    label = json['label'];
    payableType = json['payable_type'];
    discountType = json['discount_type'];
    capValue = json['cap_value'];
    discountAmount = json['discount_amount'];
    isDependency = json['is_dependency'];
    entireMemo = json['entire_memo'];
    restriction = json['restriction'];
    totalApplicableQuantity = json['total_applicable_quantity'];
    discountProductType = json['discount_product_type'];
    if (json['rules'] != null) {
      rules = <Rules>[];
      json['rules'].forEach((v) {
        rules!.add(Rules.fromJson(v));
      });
    }
    if (json['skus'] != null) {
      skus = <Skus>[];
      json['skus'].forEach((v) {
        skus!.add(Skus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['slab_group_id'] = slabGroupId;
    data['id'] = id;
    data['label'] = label;
    data['payable_type'] = payableType;
    data['discount_type'] = discountType;
    data['cap_value'] = capValue;
    data['discount_amount'] = discountAmount;
    data['is_dependency'] = isDependency;
    data['entire_memo'] = entireMemo;
    data['restriction'] = restriction;
    data['total_applicable_quantity'] = totalApplicableQuantity;
    data['discount_product_type'] = discountProductType;
    if (rules != null) {
      data['rules'] = rules!.map((v) => v.toJson()).toList();
    }
    if (skus != null) {
      data['skus'] = skus!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rules {
  String? skuId;
  int? appliedUnit;
  int? cases;

  Rules({this.skuId, this.appliedUnit, this.cases});

  Rules.fromJson(Map<String, dynamic> json) {
    skuId = json['sku_id'].toString();
    appliedUnit = json['applied_unit'];
    cases = json['cases'] ?? getCase(json['case']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sku_id'] = skuId;
    data['applied_unit'] = appliedUnit;
    data['cases'] = cases;
    return data;
  }

  int getCase(json) {
    int a = 0;
    if (json.runtimeType == String) {
      a = int.tryParse(json) ?? 0;
    } else {
      a = json;
    }
    return a;
  }
}

class Skus {
  int? skuId;
  int? appliedUnit;

  Skus({this.skuId, this.appliedUnit});

  Skus.fromJson(Map<String, dynamic> json) {
    skuId = json['sku_id'];
    appliedUnit = json['applied_unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sku_id'] = skuId;
    data['applied_unit'] = appliedUnit;
    return data;
  }
}
