import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/coupon/coupon_model.dart';
import '../../../models/sales/formatted_sales_preorder_discount_data_model.dart';
import '../../../models/sales/sale_data_model.dart';
import '../../../models/trade_promotions/applied_discount_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../utils/promotion_utils.dart';

class CouponExamineUI extends ConsumerWidget {
  final CouponModel coupon;
  final List<AppliedDiscountModel> discounts;
  final List<List<SlabDiscountModel>> slabList;
  final SaleDataModel totalSaleData;

  const CouponExamineUI({
    super.key,
    required this.coupon,
    required this.discounts,
    required this.slabList,
    required this.totalSaleData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        num? discountAmount = ref.watch(couponDiscountProvider);

        if(discountAmount==null){
          return SizedBox();
        }

        return Padding(
          padding: EdgeInsets.only(top: 15.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(5.sp), topRight: Radius.circular(5.sp))),
                    child: Tab(
                      child: LangText(
                        'Coupon discount',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                ],
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5.sp),
                    ),
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
                            'Coupon',
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
                        Expanded(child: SizedBox())
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: LangText(
                        coupon.code.toUpperCase(),
                        style: TextStyle(fontSize: smallFontSize, color: grey),
                        // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        // alignment:Alignment.centerRight,
                        child: CouponDiscountUI(
                          coupon: coupon,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
                        num? discountAmount=ref.watch(couponDiscountProvider);

                        return LangText(
                          (discountAmount??0).toStringAsFixed(2),
                          isNumber: true,
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: smallFontSize, color: grey),
                        );
                      },),
                    ),
                    Expanded(
                      child: Center(
                        child: Icon(
                          Icons.check_box,
                          color: primary,
                          size: mediumFontSize,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              ///total
              Container(
                width: 100.w,
                height: 4.h,
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(5.sp), bottomLeft: Radius.circular(5.sp)),
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
                    Expanded(child: Container()),
                    Expanded(
                      child: LangText(
                        (discountAmount??0).toStringAsFixed(2),
                        isNumber: true,
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    // Expanded(
                    //   child: LangText(
                    //     CouponService().getCouponDiscountAmount(
                    //       discountSaleData: discountSaleData,
                    //       slabPromotionsDiscount: slabPromotionsDiscount,
                    //       totalSaleData: totalSaleData,
                    //       coupon: coupon,
                    //     ).toStringAsFixed(2),
                    //     isNumber: true,
                    //     textAlign: TextAlign.end,
                    //     style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white),
                    //   ),
                    // ),
                    Expanded(child: Container())
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class CouponDiscountUI extends StatelessWidget {
  const CouponDiscountUI({
    super.key,
    required this.coupon,
  });

  final CouponModel coupon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LangText(
          '${coupon.discountValue}',
          isNumber: true,
          style: TextStyle(fontSize: smallFontSize, color: grey),
        ),
        Padding(
          padding: EdgeInsets.only(left: 3.0.sp),
          child: LangText(
            coupon.discType == PayableType.absoluteCash ? '৳' : '%',
            style: TextStyle(fontSize: smallFontSize, color: grey),
          ),
        ),
        SizedBox(
          width: 1.5.w,
        )
      ],
    );
  }
}
