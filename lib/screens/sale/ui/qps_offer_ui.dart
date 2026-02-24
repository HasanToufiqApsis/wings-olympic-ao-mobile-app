import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../models/trade_promotions/promotion_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../utils/promotion_utils.dart';
import '../controller/sale_controller.dart';
import 'promotion_ui.dart';

class QpsOffer extends ConsumerWidget {
  final List<PromotionModel> promotions;
  final Map salesData;

  const QpsOffer({
    Key? key,
    required this.promotions,
    required this.salesData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    if (promotions.isNotEmpty) {
      promotions.sort((a, b) {
        return a.slabGroupId?.compareTo(b.slabGroupId ?? 0) ?? 0;
      });

      Map<int, List<PromotionModel>> slabWisePromotions = {};
      List slabIdList = [];

      for (var val in promotions) {
        if (val.slabGroupId != null) {
          if (!slabWisePromotions.containsKey(val.slabGroupId)) {
            slabWisePromotions[val.slabGroupId!] = [val];
            slabIdList.add(val.slabGroupId);
          } else {
            slabWisePromotions[val.slabGroupId!] = [
              ...slabWisePromotions[val.slabGroupId!] ?? [],
              ...[val],
            ];
          }
        }
      }

      return slabWisePromotions.isNotEmpty /*&& geoFencingStatus==OutletSaleStatus.showSkus*/
          ? Container(
        padding: EdgeInsets.only(left: 10.sp),
        child: InkWell(
          onTap: () {
            Alerts(context: context).showModalWithWidget(
              child: SlabListView(
                slabWisePromotions: slabWisePromotions,
                promotions: promotions,
                salesData: salesData,
              ),
            );
          },
          child: Image.asset(
            'assets/qps_offers.png',
            height: 3.5.h,
          ),
        ),
      )
          : const SizedBox();
    }
    return const SizedBox();


    // AsyncValue<Map> asyncSalesData = ref.watch(salesDataForQpsPromotionTargetProvider);
    // AsyncValue<List<PromotionModel>> asyncPromotions =
    //     ref.watch(unEnrolledQpsPromotionPerRetailerProvider);
    // // OutletSaleStatus geoFencingStatus = ref.watch(outletSaleStatusProvider);
    // return asyncPromotions.when(
    //   data: (promotions) {
    //     if (promotions.isNotEmpty) {
    //       promotions.sort((a, b) {
    //         return a.slabGroupId?.compareTo(b.slabGroupId ?? 0) ?? 0;
    //       });
    //
    //       Map<int, List<PromotionModel>> slabWisePromotions = {};
    //       List slabIdList = [];
    //
    //       for (var val in promotions) {
    //         if (val.slabGroupId != null) {
    //           if (!slabWisePromotions.containsKey(val.slabGroupId)) {
    //             slabWisePromotions[val.slabGroupId!] = [val];
    //             slabIdList.add(val.slabGroupId);
    //           } else {
    //             slabWisePromotions[val.slabGroupId!] = [
    //               ...slabWisePromotions[val.slabGroupId!] ?? [],
    //               ...[val],
    //             ];
    //           }
    //         }
    //       }
    //
    //       return slabWisePromotions.isNotEmpty /*&& geoFencingStatus==OutletSaleStatus.showSkus*/
    //           ? Container(
    //               padding: EdgeInsets.only(left: 10.sp),
    //               child: InkWell(
    //                 onTap: () {
    //                   Alerts(context: context).showModalWithWidget(
    //                     child: SlabListView(
    //                       slabWisePromotions: slabWisePromotions,
    //                       promotions: promotions,
    //                       salesData: asyncSalesData.value,
    //                     ),
    //                   );
    //                 },
    //                 child: Image.asset(
    //                   'assets/qps_offers.png',
    //                   height: 3.5.h,
    //                 ),
    //               ),
    //             )
    //           : const SizedBox();
    //     }
    //     return const SizedBox();
    //   },
    //   error: (error, _) => Container(),
    //   loading: () => Center(
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           LangText(
    //             'Pending QPS promotion...',
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

class SlabListView extends ConsumerWidget {
  final Map<int, List<PromotionModel>> slabWisePromotions;
  final List<PromotionModel> promotions;
  final Map? salesData;

  const SlabListView({
    Key? key,
    required this.slabWisePromotions,
    required this.promotions,
    this.salesData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 3.w, right: 3.w, bottom: 1.h, top: 2.h),
          child: SizedBox(
            height: 60.h,
            child: Consumer(
              builder: (
                BuildContext context,
                WidgetRef ref,
                Widget? child,
              ) {
                List<int> beforeSelectedOffers = ref.watch(beforeSelectedQpsPromotion);
                List<int> beforeSuggestedOffers = ref.watch(beforeSuggestedQpsPromotion);

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
                      child: ListView.separated(
                        itemCount: slabWisePromotions.length,
                        itemBuilder: (BuildContext context, int index) {
                          List<PromotionModel> list =
                              slabWisePromotions[slabWisePromotions.keys.toList()[index]] ?? [];
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            child: ListView.builder(
                              itemCount: list.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, i) {
                                PromotionModel promotion = list[i];
                                return PromotionItemUI(
                                  promotion: promotion,
                                  onTap: () {
                                    SaleController salesController = SaleController(
                                      context: context,
                                      ref: ref,
                                    );
                                    salesController.selectBeforeQPSOffer(
                                      promotion: promotion,
                                      promotions: promotions,
                                    );
                                  },
                                  selected: beforeSelectedOffers.contains(promotion.id),
                                  suggested: beforeSuggestedOffers.contains(promotion.id),
                                );
                              },
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 8,
                            width: 100.w,
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
                      child: Consumer(builder: (context, ref, _) {
                        bool internet = ref.watch(internetConnectivityProvider);
                        if (!internet) {
                          return Center(child: LangText("No internet"));
                        }
                        return ElevatedButton(
                          onPressed: () async {
                            await SaleController(context: context, ref: ref).enrollQPSPromotion();
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
                                'Enroll',
                                style: TextStyle(color: grey, fontSize: 12.sp),
                              ),
                            ),
                          ),
                        );
                      }),
                    )
                  ],
                );
              },
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
    );
  }
}

class SuggestedSlab extends StatelessWidget {
  final PromotionModel promotion;
  final Map? salesData;

  const SuggestedSlab({
    super.key,
    required this.promotion,
    this.salesData,
  });

  @override
  Widget build(BuildContext context) {
    if (salesData != null && (salesData?.isNotEmpty ?? false)) {
      num salesDataSum =
          getSalesDataSumForThisPromotion(promotion: promotion, salesData: salesData);
      return Text('$salesDataSum');
    }
    return const SizedBox();
  }

  num getSalesDataSumForThisPromotion({required PromotionModel promotion, Map? salesData}) {
    num salesDataSum = 0;
    try {
      if (salesData != null && promotion.qpsTarget != null) {
        for (var sku in promotion.rules!) {
          if (sku.skuId?.isNotEmpty ?? false) {
            if (sku.skuId != "%") {
              Map skuSales = salesData["sales_data"];
              final qpsTarget = promotion.qpsTarget!;
              Map specificSkuSales = skuSales[sku.skuId];
              if (specificSkuSales.isNotEmpty) {
                if (qpsTarget == QpsTarget.value) {
                  /// total_price
                  salesDataSum += specificSkuSales["total_price"];
                } else {
                  /// total_volume
                  salesDataSum += specificSkuSales["total_volume"];
                }
              }
              // skuSales.forEach((key, value) {
              //   if (qpsTarget == QpsTarget.value) {
              //     /// total_price
              //     if (sku.skuId == key) {
              //       salesDataSum += value["total_price"];
              //     }
              //   } else {
              //     /// total_volume
              //     if (sku.skuId == key) {
              //       salesDataSum += value["total_volume"];
              //     }
              //   }
              // });
            }
          }
        }
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return salesDataSum;
  }
}
