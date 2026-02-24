import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/trade_promotions/promotion_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../controller/sale_controller.dart';
import 'promotion_ui.dart';

class SpecialOffer extends ConsumerWidget {
  final List<PromotionModel> promotions;

  const SpecialOffer({Key? key, required this.promotions}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return promotions.isNotEmpty
        ? Container(
      padding: EdgeInsets.only(left: 10.sp),
      // height: 3.h,
      // width: 30.w,
      // decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.sp), bottomRight: Radius.circular(50.sp)), color: primaryGreen),
      child: InkWell(
        onTap: () {
          Alerts(context: context).showModalWithWidget(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 3.w, right: 3.w, bottom: 1.h, top: 2.h),
                  child: SizedBox(
                    height: 40.h,
                    child: Consumer(
                      builder: (
                          BuildContext context,
                          WidgetRef ref,
                          Widget? child,
                          ) {
                        List<int> beforeSelectedOffers =
                        ref.watch(beforeSelectedSlabPromotion);

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 1.h,
                            ),
                            Image.asset('assets/offer.png'),
                            SizedBox(
                              height: 1.h,
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: promotions.length,
                                itemBuilder: (context, i) {
                                  PromotionModel promotion = promotions[i];
                                  return PromotionItemUI(
                                    promotion: promotion,
                                    onTap: () {
                                      SaleController salesController =
                                      SaleController(context: context, ref: ref);
                                      salesController.selectBeforeSpecialOffer(
                                        promotion: promotion,
                                        promotions: promotions,
                                      );
                                    },
                                    selected: beforeSelectedOffers.contains(promotion.id),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Container(
                              width: 30.w,
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
                                          'Ok',
                                          style: TextStyle(color: grey, fontSize: 12.sp),
                                        ),
                                      ))),
                            )
                          ],
                        );
                      },
                      // child: Column(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     SizedBox(
                      //       height: 1.h,
                      //     ),
                      //     Image.asset('assets/offer.png'),
                      //     SizedBox(
                      //       height: 1.h,
                      //     ),
                      //     Expanded(
                      //       child: ListView.builder(
                      //         itemCount: promotions.length,
                      //         itemBuilder: (context, i) {
                      //           PromotionModel promotion = promotions[i];
                      //           return PromotionItemUI(
                      //             promotion: promotion,
                      //             onTap: () {
                      //               SaleController salesController = SaleController(context: context, ref: ref);
                      //               salesController.selectBeforeSpecialOffer(
                      //                 promotion: promotion,
                      //                 promotions: promotions,
                      //               );
                      //             },
                      //           );
                      //         },
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       height: 1.5.h,
                      //     ),
                      //     Center(
                      //       child: Container(
                      //         width: 40.w,
                      //         height: 5.h,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(5.sp),
                      //           gradient: const LinearGradient(
                      //             begin: Alignment.topCenter,
                      //             end: Alignment.bottomCenter,
                      //             colors: [Color(0xFFF0F0F0), Color(0xFFBABABA)],
                      //           ),
                      //         ),
                      //         child: ElevatedButton(
                      //             onPressed: () {
                      //               Navigator.pop(context);
                      //             },
                      //             style: ElevatedButton.styleFrom(
                      //               primary: Colors.transparent,
                      //               elevation: 0,
                      //             ),
                      //             child: SizedBox(
                      //                 width: 35.w,
                      //                 height: 5.h,
                      //                 child: Center(
                      //                   child: LangText(
                      //                     'Close',
                      //                     style: TextStyle(color: grey, fontSize: 12.sp),
                      //                   ),
                      //                 ))),
                      //       ),
                      //     )
                      //   ],
                      // ),
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
        child: Image.asset(
          'assets/special_offers.png',
          height: 3.5.h,
        ),
      ),
    )
        : const SizedBox();


    // AsyncValue<List<PromotionModel>> asyncPromotions = ref.watch(comboPromotionPerRetailerProvider);
    // return asyncPromotions.when(
    //   data: (promotions) {
    //     return promotions.isNotEmpty
    //         ? Container(
    //             padding: EdgeInsets.only(left: 10.sp),
    //             // height: 3.h,
    //             // width: 30.w,
    //             // decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.sp), bottomRight: Radius.circular(50.sp)), color: primaryGreen),
    //             child: InkWell(
    //               onTap: () {
    //                 Alerts(context: context).showModalWithWidget(
    //                   child: Stack(
    //                     children: [
    //                       Padding(
    //                         padding: EdgeInsets.only(left: 3.w, right: 3.w, bottom: 1.h, top: 2.h),
    //                         child: SizedBox(
    //                           height: 40.h,
    //                           child: Consumer(
    //                             builder: (
    //                               BuildContext context,
    //                               WidgetRef ref,
    //                               Widget? child,
    //                             ) {
    //                               List<int> beforeSelectedOffers =
    //                                   ref.watch(beforeSelectedSlabPromotion);
    //
    //                               return Column(
    //                                 mainAxisSize: MainAxisSize.min,
    //                                 children: [
    //                                   SizedBox(
    //                                     height: 1.h,
    //                                   ),
    //                                   Image.asset('assets/offer.png'),
    //                                   SizedBox(
    //                                     height: 1.h,
    //                                   ),
    //                                   Expanded(
    //                                     child: ListView.builder(
    //                                       itemCount: promotions.length,
    //                                       itemBuilder: (context, i) {
    //                                         PromotionModel promotion = promotions[i];
    //                                         return PromotionItemUI(
    //                                           promotion: promotion,
    //                                           onTap: () {
    //                                             SaleController salesController =
    //                                                 SaleController(context: context, ref: ref);
    //                                             salesController.selectBeforeSpecialOffer(
    //                                               promotion: promotion,
    //                                               promotions: promotions,
    //                                             );
    //                                           },
    //                                           selected: beforeSelectedOffers.contains(promotion.id),
    //                                         );
    //                                       },
    //                                     ),
    //                                   ),
    //                                   SizedBox(
    //                                     height: 1.5.h,
    //                                   ),
    //                                   Container(
    //                                     width: 30.w,
    //                                     height: 5.h,
    //                                     decoration: BoxDecoration(
    //                                       borderRadius: BorderRadius.circular(5.sp),
    //                                       gradient: const LinearGradient(
    //                                         begin: Alignment.topCenter,
    //                                         end: Alignment.bottomCenter,
    //                                         colors: [Color(0xFFF0F0F0), Color(0xFFBABABA)],
    //                                       ),
    //                                     ),
    //                                     child: ElevatedButton(
    //                                         onPressed: () {
    //                                           Navigator.pop(context);
    //                                         },
    //                                         style: ElevatedButton.styleFrom(
    //                                           backgroundColor: Colors.transparent,
    //                                           elevation: 0,
    //                                         ),
    //                                         child: SizedBox(
    //                                             width: 35.w,
    //                                             height: 5.h,
    //                                             child: Center(
    //                                               child: LangText(
    //                                                 'Ok',
    //                                                 style: TextStyle(color: grey, fontSize: 12.sp),
    //                                               ),
    //                                             ))),
    //                                   )
    //                                 ],
    //                               );
    //                             },
    //                             // child: Column(
    //                             //   mainAxisSize: MainAxisSize.min,
    //                             //   children: [
    //                             //     SizedBox(
    //                             //       height: 1.h,
    //                             //     ),
    //                             //     Image.asset('assets/offer.png'),
    //                             //     SizedBox(
    //                             //       height: 1.h,
    //                             //     ),
    //                             //     Expanded(
    //                             //       child: ListView.builder(
    //                             //         itemCount: promotions.length,
    //                             //         itemBuilder: (context, i) {
    //                             //           PromotionModel promotion = promotions[i];
    //                             //           return PromotionItemUI(
    //                             //             promotion: promotion,
    //                             //             onTap: () {
    //                             //               SaleController salesController = SaleController(context: context, ref: ref);
    //                             //               salesController.selectBeforeSpecialOffer(
    //                             //                 promotion: promotion,
    //                             //                 promotions: promotions,
    //                             //               );
    //                             //             },
    //                             //           );
    //                             //         },
    //                             //       ),
    //                             //     ),
    //                             //     SizedBox(
    //                             //       height: 1.5.h,
    //                             //     ),
    //                             //     Center(
    //                             //       child: Container(
    //                             //         width: 40.w,
    //                             //         height: 5.h,
    //                             //         decoration: BoxDecoration(
    //                             //           borderRadius: BorderRadius.circular(5.sp),
    //                             //           gradient: const LinearGradient(
    //                             //             begin: Alignment.topCenter,
    //                             //             end: Alignment.bottomCenter,
    //                             //             colors: [Color(0xFFF0F0F0), Color(0xFFBABABA)],
    //                             //           ),
    //                             //         ),
    //                             //         child: ElevatedButton(
    //                             //             onPressed: () {
    //                             //               Navigator.pop(context);
    //                             //             },
    //                             //             style: ElevatedButton.styleFrom(
    //                             //               primary: Colors.transparent,
    //                             //               elevation: 0,
    //                             //             ),
    //                             //             child: SizedBox(
    //                             //                 width: 35.w,
    //                             //                 height: 5.h,
    //                             //                 child: Center(
    //                             //                   child: LangText(
    //                             //                     'Close',
    //                             //                     style: TextStyle(color: grey, fontSize: 12.sp),
    //                             //                   ),
    //                             //                 ))),
    //                             //       ),
    //                             //     )
    //                             //   ],
    //                             // ),
    //                           ),
    //                         ),
    //                       ),
    //                       Positioned(
    //                           top: 0.h,
    //                           right: 0.w,
    //                           child: IconButton(
    //                             onPressed: () {
    //                               Navigator.pop(context);
    //                             },
    //                             icon: Icon(
    //                               Icons.cancel_outlined,
    //                               color: Colors.red,
    //                               size: 13.sp,
    //                             ),
    //                           ))
    //                     ],
    //                   ),
    //                 );
    //               },
    //               child: Image.asset(
    //                 'assets/special_offers.png',
    //                 height: 3.5.h,
    //               ),
    //             ),
    //           )
    //         : const SizedBox();
    //   },
    //   error: (error, _) => Container(),
    //   loading: () => Center(
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           LangText(
    //             'Checking combo promotion...',
    //             style: TextStyle(color: grey, fontSize: 12.sp),
    //           ),
    //           const SizedBox(height: 4),
    //           LinearProgressIndicator(),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
