import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/trade_promotions/applied_discount_model.dart';
import '../../../models/trade_promotions/promotion_model.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../utils/promotion_utils.dart';
import '../../sale/ui/sku_case_piece_show_widget.dart';

class DiscountPreviewUI2 extends StatelessWidget {
  const DiscountPreviewUI2({Key? key, required this.discounts, required this.totalPrice}) : super(key: key);
  final List<DiscountPreviewModel> discounts;
  final num totalPrice;

  @override
  Widget build(BuildContext context) {
    if (discounts.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 15.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 4.h,
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primaryBlue, primary],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                // borderRadius: BorderRadius.only(topLeft: Radius.circular(5.sp), topRight: Radius.circular(5.sp))
              ),
              child: Tab(
                child: LangText(
                  'Discount',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.only(
                  //   topRight: Radius.circular(5.sp),
                  // ),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [primary, primaryBlue],
                  ),
                  color: Colors.grey[100]),
              child: DefaultTextStyle(
                style: TextStyle(fontSize: normalFontSize, color: Colors.white, fontWeight: FontWeight.bold),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: LangText(
                          'SKU',
                          style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: LangText(
                            'Quantity',
                            style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                          ),
                        ),
                      ),
                      Expanded(
                        child: LangText(
                          'Price',
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  DiscountPreviewModel discount = discounts[index];
                  return ShowSingleDiscountPreview(
                    discount: discount,
                  );
                },
                itemCount: discounts.length,
                shrinkWrap: true,
                primary: false,
              ),
            ),
            Builder(
              builder: (
                context,
              ) {
                int totalDiscountQty = 0;
                num totalDiscountPrice = 0;
                for (DiscountPreviewModel discount in discounts) {
                  if (discount.payableType == PayableType.productDiscount || discount.payableType == PayableType.gift) {
                    totalDiscountQty += (discount.appliedDiscount.toInt());
                  } else {
                    totalDiscountPrice += discount.appliedDiscount;
                  }
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100.w,
                      height: 4.h,
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.only(bottomRight: Radius.circular(5.sp), bottomLeft: Radius.circular(5.sp)),
                        gradient: const LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [primary, primaryBlue],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: LangText('Total', style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                          Expanded(
                            child: Center(
                              // alignment:Alignment.centerRight,
                              child: UnitWiseCountWidget(
                                unitName: "Pcs",
                                count: totalDiscountQty,
                                qtyTextStyle: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white),
                                unitTextStyle: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                          Expanded(
                            child: LangText(
                              totalDiscountPrice.toStringAsFixed(2),
                              isNumber: true,
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 4.h,
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryBlue, primary],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        // borderRadius: BorderRadius.only(topLeft: Radius.circular(5.sp), topRight: Radius.circular(5.sp)),
                      ),
                      child: Tab(
                        child: LangText(
                          'Grand Total',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: 100.w,
                      height: 4.h,
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.only(bottomRight: Radius.circular(5.sp), bottomLeft: Radius.circular(5.sp)),
                        gradient: const LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [primary, primaryBlue],
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: LangText('Price', style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                          Expanded(
                            child: LangText(
                              (totalPrice - totalDiscountPrice).toStringAsFixed(2), //  - price - totalSaleData.discount
                              isNumber: true,
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            )
          ],
        ),
      );
    }
    return Container();
  }
}

class ShowSingleDiscountPreview extends StatelessWidget {
  const ShowSingleDiscountPreview({Key? key, required this.discount}) : super(key: key);
  final DiscountPreviewModel discount;

  @override
  Widget build(BuildContext context) {
    if (discount.discountSkus.isNotEmpty) {
      return Container(
        color: discount.discountSkus.isNotEmpty ? secondaryBlue : Colors.white,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  SkuWiseAppliedDiscountAmountModel sku = discount.discountSkus[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: LangText(
                            sku.skuName,
                            style: TextStyle(fontSize: smallFontSize, color: grey),
                            // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            // alignment:Alignment.centerRight,
                            child: UnitWiseCountWidget(
                              unitName: "Pcs",
                              count: discount.payableType == PayableType.productDiscount || discount.payableType == PayableType.gift ? (sku.discountAmount ?? 0).toInt() : 0,
                              unitTextStyle: TextStyle(fontSize: smallFontSize, color: grey),
                              qtyTextStyle: TextStyle(fontSize: smallFontSize, color: grey),
                            ),
                          ),
                        ),
                        Expanded(
                          child: LangText(
                            discount.payableType == PayableType.absoluteCash || discount.payableType == PayableType.percentageOfValue ? (sku.discountAmount ?? 0).toStringAsFixed(2) : '0',
                            isNumber: true,
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: smallFontSize, color: grey),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: discount.discountSkus.length,
                shrinkWrap: true,
                primary: false,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: LangText(
                "Entire Memo",
                style: TextStyle(fontSize: smallFontSize, color: grey),
                // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
              ),
            ),
            Expanded(
              child: Center(
                // alignment:Alignment.centerRight,
                child: Text("--"),
              ),
            ),
            Expanded(
              child: LangText(
                discount.appliedDiscount.toStringAsFixed(2),
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
}
