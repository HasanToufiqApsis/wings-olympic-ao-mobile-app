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
import '../../../services/coupon_service.dart';
import '../../../utils/promotion_utils.dart';
import 'examine_title_tab.dart';
import 'promotion_ui.dart';
import 'sku_case_piece_show_widget.dart';

class DiscountExamineUI extends StatelessWidget {
  const DiscountExamineUI({
    Key? key,
    required this.discounts,
    required this.module,
  }) : super(key: key);
  final List<AppliedDiscountModel> discounts;
  final Module module;

  @override
  Widget build(BuildContext context) {
    // print('discounts:: ${discounts.length}');
    // print('slab discounts:: ${slabList.length}');
    if (discounts.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 15.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExamineTitleTab(
              module: module,
              title: 'Discount',
            ),
            Container(
              decoration: module.titleBackgroundDecoration,
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
                      Expanded(child: Container())
                    ],
                  ),
                ),
              ),
            ),
            if (discounts.isNotEmpty)
              ListView.separated(
                itemBuilder: (context, index) {
                  AppliedDiscountModel discount = discounts[index];
                  return ShowSingleAppliedDiscount(
                    appliedDiscount: discount,
                    onTap: () {
                      Alerts(context: context).showModalWithWidget(
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 3.w, right: 3.w, bottom: 1.h, top: 2.h),
                              child: SizedBox(
                                // height: 40.h,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Image.asset('assets/offer.png'),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    PromotionItemUI(promotion: discount.promotion),
                                    // const Spacer(),
                                    SizedBox(
                                      height: 1.5.h,
                                    ),
                                    Center(
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
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.transparent,
                                              elevation: 0,
                                            ),
                                            child: SizedBox(
                                                width: 35.w,
                                                height: 5.h,
                                                child: Center(
                                                  child: LangText(
                                                    'Close',
                                                    style: TextStyle(color: grey, fontSize: 12.sp),
                                                  ),
                                                ))),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                                top: 0.h,
                                right: 0.w,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.red,
                                    size: 13.sp,
                                  ),
                                ))
                          ],
                        ),
                      );
                    },
                  );
                },
                itemCount: discounts.length,
                shrinkWrap: true,
                primary: false,
                separatorBuilder: (BuildContext context, int index) {
                  AppliedDiscountModel discount = discounts[index];
                  AppliedDiscountModel discount2 = discounts[index + 1];
                  if (discount.promotion.id == discount2.promotion.id) {
                    return const SizedBox();
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: const Divider(
                      color: Colors.white,
                      height: 0.5,
                    ),
                  );
                },
              ),
            Consumer(
              builder: (context, ref, _) {
                SaleDataModel discountSaleData = ref.watch(totalDiscountCalculationProvider(discounts));
                return Container(
                  width: 100.w,
                  height: 4.h,
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: module.bottomBackgroundDecoration,
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
                            count: discountSaleData.qty,
                            qtyTextStyle: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white),
                            unitTextStyle: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Consumer(
                          builder: (BuildContext context, WidgetRef ref, Widget? child) {
                            num slabPromotionsDiscount = ref.watch(slabPromotionDiscount);
                            return LangText(
                              (discountSaleData.price + slabPromotionsDiscount).toStringAsFixed(2),
                              isNumber: true,
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white),
                            );
                          },
                        ),
                      ),
                      Expanded(child: Container())
                    ],
                  ),
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
    if (appliedDiscount.skuWiseAppliedDiscountAmount.isNotEmpty) {
      return InkWell(
        onTap: onTap,
        child: Container(
          color: appliedDiscount.skuWiseAppliedDiscountAmount.isNotEmpty ? secondaryBlue : Colors.white,
          child: Row(
            children: [
              if ((appliedDiscount.promotion.rules?.isNotEmpty ?? false) &&
                  appliedDiscount.promotion.payableType != PayableType.percentageOfValue &&
                  appliedDiscount.promotion.payableType != PayableType.absoluteCash &&
                  appliedDiscount.promotion.isFractional == false)
                Expanded(
                  flex: 3,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      SkuWiseAppliedDiscountAmountModel sku = appliedDiscount.skuWiseAppliedDiscountAmount[index];
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
                                  count: appliedDiscount.promotion.payableType == PayableType.productDiscount ||
                                          appliedDiscount.promotion.payableType == PayableType.gift
                                      ? (sku.discountAmount ?? 0).toInt()
                                      : 0,
                                  unitTextStyle: TextStyle(fontSize: smallFontSize, color: grey),
                                  qtyTextStyle: TextStyle(fontSize: smallFontSize, color: grey),
                                ),
                              ),
                            ),
                            Expanded(
                              child: LangText(
                                appliedDiscount.promotion.payableType == PayableType.absoluteCash ||
                                        appliedDiscount.promotion.payableType == PayableType.percentageOfValue
                                    ? (sku.discountAmount ?? 0).toStringAsFixed(2)
                                    : '0',
                                isNumber: true,
                                textAlign: TextAlign.end,
                                style: TextStyle(fontSize: smallFontSize, color: grey),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: appliedDiscount.skuWiseAppliedDiscountAmount.length,
                    shrinkWrap: true,
                    primary: false,
                  ),
                ),
              if ((appliedDiscount.promotion.rules?.isNotEmpty ?? false) &&
                  (appliedDiscount.promotion.payableType == PayableType.percentageOfValue ||
                      appliedDiscount.promotion.payableType == PayableType.absoluteCash) &&
                  appliedDiscount.promotion.isFractional == false)
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      SkuWiseAppliedDiscountAmountModel sku = appliedDiscount.skuWiseAppliedDiscountAmount[index];
                      return Padding(
                        padding: EdgeInsets.only(left: 2.w, top: 0.5.h, bottom: 0.5.h),
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
                                  count: appliedDiscount.promotion.payableType == PayableType.productDiscount ||
                                          appliedDiscount.promotion.payableType == PayableType.gift
                                      ? (sku.discountAmount ?? 0).toInt()
                                      : 0,
                                  unitTextStyle: TextStyle(fontSize: smallFontSize, color: grey),
                                  qtyTextStyle: TextStyle(fontSize: smallFontSize, color: grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: appliedDiscount.skuWiseAppliedDiscountAmount.length,
                    shrinkWrap: true,
                    primary: false,
                  ),
                ),
              if ((appliedDiscount.promotion.rules?.isNotEmpty ?? false) &&
                  (appliedDiscount.promotion.payableType == PayableType.percentageOfValue ||
                      appliedDiscount.promotion.payableType == PayableType.absoluteCash) &&
                  appliedDiscount.promotion.isFractional == false)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: LangText(
                            appliedDiscount.promotion.payableType == PayableType.absoluteCash
                                ? (appliedDiscount.appliedDiscount)
                                    .toStringAsFixed(2) //(appliedDiscount.promotion.discountAmount ?? 0).toStringAsFixed(2)
                                : appliedDiscount.promotion.payableType == PayableType.percentageOfValue
                                    ? (appliedDiscount.appliedDiscount).toStringAsFixed(2)
                                    : '0',
                            isNumber: true,
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: smallFontSize, color: grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (appliedDiscount.promotion.isFractional == true)
                Expanded(
                  flex: 3,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      SkuWiseAppliedDiscountAmountModel sku = appliedDiscount.skuWiseAppliedDiscountAmount[index];
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
                                  count: appliedDiscount.promotion.payableType == PayableType.productDiscount ? (sku.discountAmount ?? 0).toInt() : 0,
                                  unitTextStyle: TextStyle(fontSize: smallFontSize, color: grey),
                                  qtyTextStyle: TextStyle(fontSize: smallFontSize, color: grey),
                                ),
                              ),
                            ),
                            Expanded(
                              child: LangText(
                                appliedDiscount.promotion.payableType == PayableType.productDiscount
                                    ? (appliedDiscount.appliedDiscount ?? 0).toStringAsFixed(2)
                                    : '0',
                                isNumber: true,
                                textAlign: TextAlign.end,
                                style: TextStyle(fontSize: smallFontSize, color: grey),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: appliedDiscount.skuWiseAppliedDiscountAmount.length,
                    shrinkWrap: true,
                    primary: false,
                  ),
                ),
              if ((appliedDiscount.promotion.rules?.isEmpty ?? false) && appliedDiscount.promotion.isFractional == false)
                Expanded(
                  flex: 3,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      SkuWiseAppliedDiscountAmountModel sku = appliedDiscount.skuWiseAppliedDiscountAmount[index];
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
                                  count: appliedDiscount.promotion.payableType == PayableType.productDiscount ||
                                          appliedDiscount.promotion.payableType == PayableType.gift
                                      ? (sku.discountAmount ?? 0).toInt()
                                      : 0,
                                  unitTextStyle: TextStyle(fontSize: smallFontSize, color: grey),
                                  qtyTextStyle: TextStyle(fontSize: smallFontSize, color: grey),
                                ),
                              ),
                            ),
                            Expanded(
                              child: LangText(
                                appliedDiscount.promotion.payableType == PayableType.absoluteCash ||
                                        appliedDiscount.promotion.payableType == PayableType.percentageOfValue
                                    ? (sku.discountAmount ?? 0).toStringAsFixed(2)
                                    : '0',
                                isNumber: true,
                                textAlign: TextAlign.end,
                                style: TextStyle(fontSize: smallFontSize, color: grey),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: appliedDiscount.skuWiseAppliedDiscountAmount.length,
                    shrinkWrap: true,
                    primary: false,
                  ),
                ),
              ShowDiscountAddedMark(
                appliedDiscount: appliedDiscount,
              )
            ],
          ),
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
            const Expanded(
              child: Center(
                // alignment:Alignment.centerRight,
                child: Text("--"),
              ),
            ),
            Expanded(
              child: LangText(
                appliedDiscount.appliedDiscount.toStringAsFixed(2),
                isNumber: true,
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: smallFontSize, color: grey),
              ),
            ),
            ShowDiscountAddedMark(
              appliedDiscount: appliedDiscount,
            )
          ],
        ),
      );
    }
  }
}

class ShowDiscountAddedMark extends StatelessWidget {
  const ShowDiscountAddedMark({Key? key, required this.appliedDiscount}) : super(key: key);
  final AppliedDiscountModel appliedDiscount;

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Builder(
      builder: (context) {
        if (appliedDiscount.promotion.isDependent) {
          return Container();
        } else {
          return Center(
            child: Icon(
              Icons.check_box,
              color: primary,
              size: mediumFontSize,
            ),
          );
        }
      },
    ));
  }
}

class TotalDiscountExamineUI extends ConsumerWidget {
  const TotalDiscountExamineUI({
    Key? key,
    required this.totalSaleData,
    required this.discounts,
    this.coupon,
    this.totalSalesValue,
    this.totalSalesVolume,
    this.slabWise = true,
    this.module,
  }) : super(key: key);
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
          ExamineTitleTab(
            module: module,
            title: slabWise ? 'Total' : 'Grand Total',
          ),
          Container(
            width: 100.w,
            height: 4.h,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: module.totalBackgroundDecoration,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: LangText('Price', style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                Expanded(
                  child: Consumer(
                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      num? couponDiscount = ref.watch(couponDiscountProvider);

                      return LangText(
                        slabWise
                            ? ((totalSalesValue ?? 0) - discountSaleData.price).toStringAsFixed(2)
                            : (totalSaleData.price - discountSaleData.price - (couponDiscount ?? 0)).toStringAsFixed(2),
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
