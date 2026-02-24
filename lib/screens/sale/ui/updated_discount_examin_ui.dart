import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/utils/extensions/decoration_extensions.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/coupon/coupon_model.dart';
import '../../../models/module.dart';
import '../../../models/sales/sale_data_model.dart';
import '../../../models/trade_promotions/applied_discount_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/sales_widget/examine_table_header.dart';
import '../../../reusable_widgets/sales_widget/examine_total_row.dart';
import '../../../services/coupon_service.dart';
import '../../../utils/promotion_utils.dart';
import 'examine_title_tab.dart';
import 'promotion_ui.dart';
import 'sku_case_piece_show_widget.dart';

class UpdatedDiscountExamineUI extends StatelessWidget {
  const UpdatedDiscountExamineUI({
    Key? key,
    required this.discounts,
    required this.module,
  }) : super(key: key);

  final List<AppliedDiscountModel> discounts;
  final Module module;

  @override
  Widget build(BuildContext context) {
    if (discounts.isEmpty) return Container();

    return Padding(
      padding: EdgeInsets.only(top: 15.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExamineTitleTab(module: module, title: 'Discount'),
          ExamineTableHeader(),
          _buildDiscountList(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildDiscountList() {
    return ListView.separated(
      itemCount: discounts.length,
      shrinkWrap: true,
      primary: false,
      separatorBuilder: (context, index) {
        if (discounts[index].promotion.id == discounts[index + 1].promotion.id) {
          return const SizedBox();
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: const Divider(color: Colors.white, height: 0.5),
        );
      },
      itemBuilder: (context, index) {
        final discount = discounts[index];
        return ShowSingleAppliedDiscount(
          appliedDiscount: discount,
          onTap: () => _showDiscountDetailsDialog(context, discount),
        );
      },
    );
  }

  Widget _buildFooter() {
    return Consumer(
      builder: (context, ref, _) {
        SaleDataModel discountSaleData = ref.watch(totalDiscountCalculationProvider(discounts));
        num slabPromotionsDiscount = ref.watch(slabPromotionDiscount);

        return ExamineTotalRow(
          price: (discountSaleData.price + slabPromotionsDiscount).toStringAsFixed(2),
          totalVolume: discountSaleData.qty,
        );
      },
    );
  }

  void _showDiscountDetailsDialog(BuildContext context, AppliedDiscountModel discount) {
    Alerts(context: context).showModalWithWidget(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 3.w, right: 3.w, bottom: 1.h, top: 2.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 1.h),
                Image.asset('assets/offer.png'),
                SizedBox(height: 1.h),
                PromotionItemUI(promotion: discount.promotion),
                SizedBox(height: 1.5.h),
                _buildDialogCloseButton(context),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.cancel_outlined, color: Colors.red, size: 13.sp),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDialogCloseButton(BuildContext context) {
    return Center(
      child: Container(
        width: 40.w,
        height: 5.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.sp),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF0F0F0), Color(0xFFBABABA)],
          ),
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, elevation: 0),
          child: Center(
            child: LangText('Close', style: TextStyle(color: grey, fontSize: 12.sp)),
          ),
        ),
      ),
    );
  }
}

class ShowSingleAppliedDiscount extends StatelessWidget {
  const ShowSingleAppliedDiscount({
    Key? key,
    required this.appliedDiscount,
    required this.onTap,
  }) : super(key: key);

  final AppliedDiscountModel appliedDiscount;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    if (appliedDiscount.skuWiseAppliedDiscountAmount.isEmpty) {
      return _buildEntireMemoRow();
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: appliedDiscount.skuWiseAppliedDiscountAmount.length,
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, index) {
            SkuWiseAppliedDiscountAmountModel sku = appliedDiscount.skuWiseAppliedDiscountAmount[index];
            return _buildSkuRow(sku);
          },
        ),
      ),
    );
  }

  Widget _buildEntireMemoRow() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: LangText("Entire Memo", style: TextStyle(fontSize: smallFontSize, color: grey))),
          const Expanded(child: Center(child: Text("--"))),
          Expanded(
            child: LangText(
              appliedDiscount.appliedDiscount.toStringAsFixed(2),
              isNumber: true,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: smallFontSize, color: grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkuRow(SkuWiseAppliedDiscountAmountModel sku) {
    final promotion = appliedDiscount.promotion;
    int quantity = 0;
    String priceStr = '0';

    // Logic for Quantity
    if (promotion.payableType == PayableType.productDiscount || promotion.payableType == PayableType.gift) {
      quantity = (sku.discountAmount ?? 0).toInt();
    }

    // Logic for Price
    if (promotion.isFractional == true) {
      if (promotion.payableType == PayableType.productDiscount) {
        priceStr = (appliedDiscount.appliedDiscount ?? 0).toStringAsFixed(2);
      }
    } else if (promotion.payableType == PayableType.absoluteCash || promotion.payableType == PayableType.percentageOfValue) {
      // Check if we show item wise discount or total applied discount
      if(promotion.rules?.isNotEmpty ?? false) {
        priceStr = (sku.discountAmount ?? 0).toStringAsFixed(2);
      } else {
        priceStr = appliedDiscount.appliedDiscount.toStringAsFixed(2);
      }
    }

    // Fallback logic from original code structure specifically for Percentage/Cash fractional=false single row case
    // The original code had a specific block for 'flex: 2' and 'flex: 1' splitting.
    // Simplified here to standard row as visually they look similar, but respecting the calculation.
    if ((promotion.rules?.isNotEmpty ?? false) &&
        (promotion.payableType == PayableType.percentageOfValue || promotion.payableType == PayableType.absoluteCash) &&
        promotion.isFractional == false) {
      // In the original code, this specific condition rendered differently.
      // However, for clean code, we are using the calculated values above.
      // If strict visual adherence to the exact pixel is needed for that specific `flex` case,
      // we would need a separate widget, but standard Row is usually preferred.
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: LangText(sku.skuName, style: TextStyle(fontSize: smallFontSize, color: grey)),
          ),
          Expanded(
            child: Center(
              child: UnitWiseCountWidget(
                unitName: "Pcs",
                count: quantity,
                unitTextStyle: TextStyle(fontSize: smallFontSize, color: grey),
                qtyTextStyle: TextStyle(fontSize: smallFontSize, color: grey),
              ),
            ),
          ),
          Expanded(
            child: LangText(
              priceStr,
              isNumber: true,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: smallFontSize, color: grey),
            ),
          ),
        ],
      ),
    );
  }
}

class TotalDiscountExamineUI extends ConsumerWidget {
  const TotalDiscountExamineUI({
    super.key,
    required this.totalSaleData,
    required this.discounts,
    this.coupon,
    this.totalSalesValue,
    this.totalSalesVolume,
    this.slabWise = true,
    this.module,
  });

  final SaleDataModel totalSaleData;
  final List<AppliedDiscountModel> discounts;
  final CouponModel? coupon;
  final num? totalSalesValue;
  final int? totalSalesVolume;
  final bool slabWise;
  final Module? module;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SaleDataModel discountSaleData = ref.watch(totalDiscountCalculationProvider(discounts));

    return Padding(
      padding: EdgeInsets.only(top: 15.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExamineTitleTab(module: module, title: slabWise ? 'Total' : 'Grand Total'),
          Container(
            width: 100.w,
            height: 4.h,
            color: primary,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: LangText('Price', style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                Expanded(
                  child: Consumer(
                    builder: (context, ref, _) {
                      num couponDiscount = ref.watch(couponDiscountProvider) ?? 0;
                      num finalPrice = slabWise
                          ? ((totalSalesValue ?? 0) - discountSaleData.price)
                          : (totalSaleData.price - discountSaleData.price - couponDiscount);

                      return LangText(
                        finalPrice.toStringAsFixed(2),
                        isNumber: true,
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
