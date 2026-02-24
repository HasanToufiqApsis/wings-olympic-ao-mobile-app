import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/utils/extensions/decoration_extensions.dart';
import 'package:wings_olympic_sr/utils/sales_type_utils.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/module.dart';
import '../../../models/outlet_model.dart';
import '../../../models/trade_promotions/applied_discount_model.dart';
import '../../../models/trade_promotions/promotion_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../utils/promotion_utils.dart';
import '../../sale/ui/coupon_examine_ui.dart';
import '../../sale/ui/sku_case_piece_show_widget.dart';
import 'memo_title_tab.dart';

// class DiscountPreviewUI extends StatelessWidget {
//   const DiscountPreviewUI({Key? key, required this.discounts, required this.totalPrice}) : super(key: key);
//   final List<DiscountPreviewModel> discounts;
//   final num totalPrice;
//
//   @override
//   Widget build(BuildContext context) {
//     // if(discounts.isNotEmpty){
//     return Padding(
//       padding: EdgeInsets.only(top: 15.sp),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Builder(
//             builder: (
//               context,
//             ) {
//               int totalDiscountQty = 0;
//               num totalDiscountPrice = 0;
//               for (DiscountPreviewModel discount in discounts) {
//                 print('---->  ${discount.payableType} : ${discount.discountType}');
//                 print('---->  ${discount.appliedDiscount} : ${discount.promotionId}');
//                 num thisDiscountQty = 0;
//                 for (var val in discount.discountSkus) {
//                   thisDiscountQty += val.discountAmount ?? 0;
//                 }
//                 if (discount.payableType == PayableType.productDiscount || discount.payableType == PayableType.gift) {
//                   totalDiscountQty += (discount.appliedDiscount.toInt());
//                   print('---->  1000');
//                 } else {
//                   if (discount.payableType == PayableType.absoluteCash && discount.appliedDiscount != thisDiscountQty) {
//                     totalDiscountQty += (thisDiscountQty - discount.appliedDiscount).toInt();
//                     print('---->  2000');
//                   }
//                   totalDiscountPrice += discount.appliedDiscount;
//                 }
//               }
//
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (discounts.isNotEmpty)
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           height: 4.h,
//                           padding: EdgeInsets.symmetric(horizontal: 3.w),
//                           decoration: const BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [primaryBlue, primaryGreen],
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                             ),
//                             // borderRadius: BorderRadius.only(topLeft: Radius.circular(5.sp), topRight: Radius.circular(5.sp))
//                           ),
//                           child: Tab(
//                             child: LangText(
//                               'Discount',
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                               // borderRadius: BorderRadius.only(
//                               //   topRight: Radius.circular(5.sp),
//                               // ),
//                               gradient: const LinearGradient(
//                                 begin: Alignment.centerLeft,
//                                 end: Alignment.centerRight,
//                                 colors: [primaryGreen, primaryBlue],
//                               ),
//                               color: Colors.grey[100]),
//                           child: DefaultTextStyle(
//                             style: TextStyle(fontSize: normalFontSize, color: Colors.white, fontWeight: FontWeight.bold),
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Expanded(
//                                     child: LangText(
//                                       'SKU',
//                                       style: TextStyle(color: Colors.white, fontSize: normalFontSize),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Center(
//                                       child: LangText(
//                                         'Quantity',
//                                         style: TextStyle(color: Colors.white, fontSize: normalFontSize),
//                                       ),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: LangText(
//                                       'Price',
//                                       textAlign: TextAlign.end,
//                                       style: TextStyle(color: Colors.white, fontSize: normalFontSize),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           child: ListView.builder(
//                             itemBuilder: (context, index) {
//                               DiscountPreviewModel discount = discounts[index];
//                               return ShowSingleDiscountPreview(
//                                 discount: discount,
//                               );
//                             },
//                             itemCount: discounts.length,
//                             shrinkWrap: true,
//                             primary: false,
//                           ),
//                         ),
//                         Container(
//                           width: 100.w,
//                           height: 4.h,
//                           padding: EdgeInsets.symmetric(horizontal: 2.w),
//                           decoration: const BoxDecoration(
//                             // borderRadius: BorderRadius.only(bottomRight: Radius.circular(5.sp), bottomLeft: Radius.circular(5.sp)),
//                             gradient: LinearGradient(
//                               begin: Alignment.centerRight,
//                               end: Alignment.centerLeft,
//                               colors: [primaryGreen, primaryBlue],
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: LangText('Total', style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white)),
//                               ),
//                               Expanded(
//                                 child: Center(
//                                   // alignment:Alignment.centerRight,
//                                   child: UnitWiseCountWidget(
//                                     unitName: "Pcs",
//                                     count: totalDiscountQty,
//                                     qtyTextStyle: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white),
//                                     unitTextStyle: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: LangText(
//                                   totalDiscountPrice.toStringAsFixed(2),
//                                   isNumber: true,
//                                   textAlign: TextAlign.end,
//                                   style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   const SizedBox(
//                     height: 15,
//                   ),
//
//                   ///-------------------------------- coupon
//
//                   Consumer(
//                     builder: (BuildContext context, WidgetRef ref, Widget? child) {
//                       OutletModel? dropdownSelected = ref.watch(selectedRetailerProvider);
//
//                       if (dropdownSelected == null) {
//                         return const SizedBox();
//                       }
//                       return FutureBuilder(
//                           future: CouponService().checkRetailerCouponCode(retailer: dropdownSelected),
//                           builder: (context, snapshot) {
//                             if (!snapshot.hasData) {
//                               return Container();
//                             }
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   height: 4.h,
//                                   padding: EdgeInsets.symmetric(horizontal: 3.w),
//                                   decoration: const BoxDecoration(
//                                     gradient: LinearGradient(
//                                       colors: [primaryBlue, primaryGreen],
//                                       begin: Alignment.topCenter,
//                                       end: Alignment.bottomCenter,
//                                     ),
//                                     // borderRadius: BorderRadius.only(topLeft: Radius.circular(5.sp), topRight: Radius.circular(5.sp))
//                                   ),
//                                   child: Tab(
//                                     child: LangText(
//                                       'Coupon discount',
//                                       style: const TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   decoration: BoxDecoration(
//                                       // borderRadius: BorderRadius.only(
//                                       //   topRight: Radius.circular(5.sp),
//                                       // ),
//                                       gradient: const LinearGradient(
//                                         begin: Alignment.centerLeft,
//                                         end: Alignment.centerRight,
//                                         colors: [primaryGreen, primaryBlue],
//                                       ),
//                                       color: Colors.grey[100]),
//                                   child: DefaultTextStyle(
//                                     style: TextStyle(fontSize: normalFontSize, color: Colors.white, fontWeight: FontWeight.bold),
//                                     child: Padding(
//                                       padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         children: [
//                                           Expanded(
//                                             child: LangText(
//                                               'Coupon',
//                                               style: TextStyle(color: Colors.white, fontSize: normalFontSize),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Center(
//                                               child: LangText(
//                                                 'Quantity',
//                                                 style: TextStyle(color: Colors.white, fontSize: normalFontSize),
//                                               ),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: LangText(
//                                               'Price',
//                                               textAlign: TextAlign.end,
//                                               style: TextStyle(color: Colors.white, fontSize: normalFontSize),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   color: secondaryBlue,
//                                   child: Row(
//                                     children: [
//                                       Expanded(
//                                         flex: 3,
//                                         child: Column(
//                                           children: [
//                                             Padding(
//                                               padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
//                                               child: Row(
//                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   Expanded(
//                                                     child: LangText(
//                                                       '${snapshot.data!["code"]}',
//                                                       style: TextStyle(fontSize: smallFontSize, color: grey),
//                                                       // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
//                                                     ),
//                                                   ),
//                                                   Expanded(
//                                                     child: Center(
//                                                       // alignment:Alignment.centerRight,
//                                                       child: FutureBuilder(
//                                                         future: CouponService().getCouponFromCouponCode(couponCode: snapshot.data!["code"]),
//                                                         builder: (BuildContext context, AsyncSnapshot<dynamic> snap) {
//                                                           print('snapshot data ::::::::: ${snapshot.data}');
//                                                           if (!snap.hasData || snap.data == null || snap.connectionState == ConnectionState.waiting) {
//                                                             return Container();
//                                                           }
//                                                           return CouponDiscountUI(
//                                                             coupon: snap.data,
//                                                           );
//                                                         },
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Expanded(
//                                                     child: LangText(
//                                                       '${snapshot.data!["achievedAmount"]}',
//                                                       isNumber: true,
//                                                       textAlign: TextAlign.end,
//                                                       style: TextStyle(fontSize: smallFontSize, color: grey),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             Container(
//                                               width: 100.w,
//                                               height: 4.h,
//                                               padding: EdgeInsets.symmetric(horizontal: 2.w),
//                                               decoration: const BoxDecoration(
//                                                 // borderRadius: BorderRadius.only(bottomRight: Radius.circular(5.sp), bottomLeft: Radius.circular(5.sp)),
//                                                 gradient: LinearGradient(
//                                                   begin: Alignment.centerRight,
//                                                   end: Alignment.centerLeft,
//                                                   colors: [primaryGreen, primaryBlue],
//                                                 ),
//                                               ),
//                                               child: Row(
//                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   Expanded(
//                                                     child: LangText('Total', style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white)),
//                                                   ),
//                                                   const Expanded(
//                                                     child: SizedBox(),
//                                                   ),
//                                                   Expanded(
//                                                     child: LangText(
//                                                       snapshot.data!["achievedAmount"].toStringAsFixed(2),
//                                                       isNumber: true,
//                                                       textAlign: TextAlign.end,
//                                                       style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             );
//                           });
//                     },
//                   ),
//
//                   ///-------------------------------- coupon
//
//                   const SizedBox(
//                     height: 15,
//                   ),
//                   Container(
//                     height: 4.h,
//                     padding: EdgeInsets.symmetric(horizontal: 3.w),
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [primaryBlue, primaryGreen],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                       ),
//                       // borderRadius: BorderRadius.only(topLeft: Radius.circular(5.sp), topRight: Radius.circular(5.sp)),
//                     ),
//                     child: Tab(
//                       child: LangText(
//                         'Grand Total',
//                         style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//
//                   Container(
//                     width: 100.w,
//                     height: 4.h,
//                     padding: EdgeInsets.symmetric(horizontal: 2.w),
//                     decoration: const BoxDecoration(
//                       // borderRadius: BorderRadius.only(bottomRight: Radius.circular(5.sp), bottomLeft: Radius.circular(5.sp)),
//                       gradient: LinearGradient(
//                         begin: Alignment.centerRight,
//                         end: Alignment.centerLeft,
//                         colors: [primaryGreen, primaryBlue],
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: LangText('Price', style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white)),
//                         ),
//                         Expanded(child: Consumer(
//                           builder: (BuildContext context, WidgetRef ref, Widget? child) {
//                             OutletModel? dropdownSelected = ref.watch(selectedRetailerProvider);
//                             if (dropdownSelected != null) {
//                               return FutureBuilder(
//                                 future: CouponService().checkRetailerCouponCode(retailer: dropdownSelected),
//                                 builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//                                   if (snapshot.hasData) {
//                                     if (snapshot.data == null) {
//                                       return const SizedBox();
//                                     }
//                                     // ref.read(couponDiscountProvider.notifier).state = snapshot.data!["achievedAmount"];
//                                     return LangText(
//                                       (totalPrice - totalDiscountPrice - snapshot.data!["achievedAmount"]).toStringAsFixed(2), //  - price - totalSaleData.discount
//                                       isNumber: true,
//                                       textAlign: TextAlign.end,
//                                       style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white),
//                                     );
//                                   }
//                                   return LangText(
//                                     (totalPrice - totalDiscountPrice).toStringAsFixed(2), //  - price - totalSaleData.discount
//                                     isNumber: true,
//                                     textAlign: TextAlign.end,
//                                     style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold, color: Colors.white),
//                                   );
//                                 },
//                               );
//                             }
//                             return const SizedBox();
//                           },
//                         )),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             },
//           )
//         ],
//       ),
//     );
//     // }
//     return Container();
//   }
// }
//
// class ShowSingleDiscountPreview extends StatelessWidget {
//   const ShowSingleDiscountPreview({Key? key, required this.discount}) : super(key: key);
//   final DiscountPreviewModel discount;
//
//   @override
//   Widget build(BuildContext context) {
//     if (discount.discountSkus.isNotEmpty) {
//       return Container(
//         color: discount.discountSkus.isNotEmpty ? secondaryBlue : Colors.white,
//         child: Row(
//           children: [
//             Expanded(
//               flex: 3,
//               child: ListView.builder(
//                 itemBuilder: (context, index) {
//                   SkuWiseAppliedDiscountAmountModel sku = discount.discountSkus[index];
//                   print('memo discount length is:: ${discount.discountSkus.length}');
//                   print('applied discount is:::::: ${discount.appliedDiscount} :: sku p:: ${sku.discountAmount}');
//                   return Column(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: LangText(
//                                 sku.skuName,
//                                 style: TextStyle(fontSize: smallFontSize, color: grey),
//                                 // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
//                               ),
//                             ),
//                             Expanded(
//                               child: Center(
//                                 // alignment:Alignment.centerRight,
//                                 child: UnitWiseCountWidget(
//                                   unitName: "Pcs",
//                                   count: ((sku.discountAmount ?? 0) - discount.appliedDiscount).toInt(),
//                                   unitTextStyle: TextStyle(fontSize: smallFontSize, color: grey),
//                                   qtyTextStyle: TextStyle(fontSize: smallFontSize, color: grey),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: LangText(
//                                 '0',
//                                 isNumber: true,
//                                 textAlign: TextAlign.end,
//                                 style: TextStyle(fontSize: smallFontSize, color: grey),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: LangText(
//                                 sku.skuName,
//                                 style: TextStyle(fontSize: smallFontSize, color: grey),
//                                 // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
//                               ),
//                             ),
//                             Expanded(
//                               child: Center(
//                                 // alignment:Alignment.centerRight,
//                                 child: UnitWiseCountWidget(
//                                   unitName: "Pcs",
//                                   count: 0,
//                                   unitTextStyle: TextStyle(fontSize: smallFontSize, color: grey),
//                                   qtyTextStyle: TextStyle(fontSize: smallFontSize, color: grey),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: LangText(
//                                 discount.appliedDiscount.toStringAsFixed(2),
//                                 // ((double.tryParse('.${sku.discountAmount.toString().split('.')[1]}'))??0).toStringAsFixed(2),
//                                 // (0.12).toStringAsFixed(2),
//                                 isNumber: true,
//                                 textAlign: TextAlign.end,
//                                 style: TextStyle(fontSize: smallFontSize, color: grey),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   );
//                   if (discount.appliedDiscount != sku.discountAmount) {
//                   }
//                   return Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: LangText(
//                             sku.skuName,
//                             style: TextStyle(fontSize: smallFontSize, color: grey),
//                             // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
//                           ),
//                         ),
//                         Expanded(
//                           child: Center(
//                             // alignment:Alignment.centerRight,
//                             child: UnitWiseCountWidget(
//                               unitName: "Pcs",
//                               count: discount.payableType == PayableType.productDiscount || discount.payableType == PayableType.gift ? (sku.discountAmount ?? 0).toInt() : 0,
//                               unitTextStyle: TextStyle(fontSize: smallFontSize, color: grey),
//                               qtyTextStyle: TextStyle(fontSize: smallFontSize, color: grey),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: LangText(
//                             discount.payableType == PayableType.absoluteCash || discount.payableType == PayableType.percentageOfValue ? (sku.discountAmount ?? 0).toStringAsFixed(2) : '0',
//                             isNumber: true,
//                             textAlign: TextAlign.end,
//                             style: TextStyle(fontSize: smallFontSize, color: grey),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//                 itemCount: discount.discountSkus.length,
//                 shrinkWrap: true,
//                 primary: false,
//               ),
//             ),
//           ],
//         ),
//       );
//     } else {
//       return Container(
//         color: Colors.white,
//         padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: LangText(
//                 "Entire Memo",
//                 style: TextStyle(fontSize: smallFontSize, color: grey),
//                 // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
//               ),
//             ),
//             const Expanded(
//               child: Center(
//                 // alignment:Alignment.centerRight,
//                 child: Text("--"),
//               ),
//             ),
//             Expanded(
//               child: LangText(
//                 discount.appliedDiscount.toStringAsFixed(2),
//                 isNumber: true,
//                 textAlign: TextAlign.end,
//                 style: TextStyle(fontSize: smallFontSize, color: grey),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }

class DiscountPreviewUI extends StatelessWidget {
  const DiscountPreviewUI({
    Key? key,
    required this.discounts,
    required this.totalPrice,
    required this.module, required this.saleType,
  }) : super(key: key);
  final List<DiscountPreviewModel> discounts;
  final num totalPrice;
  final Module module;
  final SaleType saleType;

  @override
  Widget build(BuildContext context) {
    if (discounts.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 15.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MemoTitleTab(
              title: 'Discount',
              module: module,
            ),
            Container(
              decoration: module.totalMemoBackgroundDecoration,
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
            ListView.builder(
              itemCount: discounts.length,
              itemBuilder: (context, index) {
                DiscountPreviewModel discount = discounts[index];
                return ShowSingleDiscountPreview(
                  discount: discount,
                );
              },
              shrinkWrap: true,
              primary: false,
            ),
            Builder(
              builder: (
                context,
              ) {
                int totalDiscountQty = 0;
                num totalDiscountPrice = 0;
                for (DiscountPreviewModel discount in discounts) {
                  if (discount.isFractional != null && discount.isFractional == true) {
                    print('i am fractional promotion');
                    num allDiscountAmount = 0;
                    for (var v in discount.discountSkus) {
                      allDiscountAmount += v.discountAmount ?? 0;
                    }
                    totalDiscountQty += (allDiscountAmount).toInt();
                    totalDiscountPrice += discount.appliedDiscount;
                  } else {
                    if (discount.payableType == PayableType.productDiscount || discount.payableType == PayableType.gift) {
                      totalDiscountQty += (discount.appliedDiscount.toInt());
                    } else {
                      totalDiscountPrice += discount.appliedDiscount;
                    }
                  }
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100.w,
                      height: 4.h,
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: module.bottomMemoBackgroundDecoration,
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
                    MemoTitleTab(
                      title: 'Total',
                      module: module,
                    ),
                    Container(
                      width: 100.w,
                      height: 4.h,
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: module.titleMemoBackgroundDecoration,
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
    if ((discount.payableType == PayableType.absoluteCash || discount.payableType == PayableType.percentageOfValue) &&
        discount.discountSkus.length > 1) {
      if (discount.discountSkus.isNotEmpty) {
        return Container(
          color: discount.discountSkus.isNotEmpty ? secondaryBlue : Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: ListView.builder(
                  itemCount: discount.discountSkus.length,
                  itemBuilder: (context, index) {
                    SkuWiseAppliedDiscountAmountModel sku = discount.discountSkus[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.5.h),
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
                                count: discount.payableType == PayableType.productDiscount || discount.payableType == PayableType.gift
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
                  shrinkWrap: true,
                  primary: false,
                ),
              ),
              Expanded(
                child: LangText(
                  (discount.appliedDiscount ?? 0).toStringAsFixed(2),
                  isNumber: true,
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: smallFontSize, color: grey),
                ),
              ),
            ],
          ),
        );
      }
      return SizedBox();
    }
    if (discount.discountSkus.isNotEmpty) {
      num allSkuDiscount = 0;
      if (discount.isFractional != null && discount.isFractional == true) {
        for (var v in discount.discountSkus) {
          allSkuDiscount += v.discountAmount ?? 0;
        }
      }
      return Container(
        color: discount.discountSkus.isNotEmpty ? secondaryBlue : Colors.white,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: ListView.builder(
                itemCount: discount.discountSkus.length,
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
                              count: (discount.isFractional != null && discount.isFractional == true)
                                  ? (allSkuDiscount).toInt()
                                  : discount.payableType == PayableType.productDiscount || discount.payableType == PayableType.gift
                                      ? (sku.discountAmount ?? 0).toInt()
                                      : 0,
                              unitTextStyle: TextStyle(fontSize: smallFontSize, color: grey),
                              qtyTextStyle: TextStyle(fontSize: smallFontSize, color: grey),
                            ),
                          ),
                        ),
                        Expanded(
                          child: LangText(
                            (discount.isFractional != null && discount.isFractional == true)
                                ? ((discount.appliedDiscount)).toStringAsFixed(2)
                                : (discount.payableType == PayableType.absoluteCash && discount.discountSkus.length > 1)
                                    ? (discount.appliedDiscount ?? 0).toStringAsFixed(2)
                                    : (discount.payableType == PayableType.absoluteCash || discount.payableType == PayableType.percentageOfValue)
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
