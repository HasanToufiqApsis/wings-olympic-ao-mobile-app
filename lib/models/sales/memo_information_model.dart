import '../../utils/case_piece_type_utils.dart';
import '../module.dart';
import '../products_details_model.dart';
import '../trade_promotions/applied_discount_model.dart';
import '../trade_promotions/promotion_model.dart';
import 'sale_data_model.dart';

class PreorderMemoInformationModel{
  final Module module;
  final List<ProductDetailsModel> skus;
  final SaleDataModel totalPreorderData;
  final List<DiscountPreviewModel> discounts;
  final SaleDataModel totalQcAmount;
  final Map<CasePieceType,int> totalCount;
  PreorderMemoInformationModel({required this.module, required this.skus, required this.totalPreorderData, required this.discounts, required this.totalQcAmount, required this.totalCount});
}


class AllMemoInformationModel{
  final List<MemoInformationModel> saleMemo;
  final List<PreorderMemoInformationModel> preorderMemo;
  AllMemoInformationModel({required this.saleMemo, required this.preorderMemo});
}


class MemoInformationModel {
  final Module module;
  final List<ProductDetailsModel> skus;
  final SaleDataModel totalSaleData;
  final SaleDataModel totalDiscount;
  // final List<UnnotiReimbursement> unnotiReimbursements;
  final SaleDataModel totalQcAmount;
  // final List<ProductWiseDiscountModel> productWiseDiscounts;
  final List<DiscountPreviewModel> packRedemptions;
  final List<AppliedDiscountModel> appliedPromotions;
  final List<DiscountPreviewModel> discounts;
  MemoInformationModel(
      {required this.module,
        required this.skus,
        required this.totalSaleData,
        required this.totalDiscount,
        // required this.productWiseDiscounts,
        required this.totalQcAmount,
        // required this.unnotiReimbursements,
        required this.packRedemptions,
        required this.appliedPromotions,
        required this.discounts,
      });
}
