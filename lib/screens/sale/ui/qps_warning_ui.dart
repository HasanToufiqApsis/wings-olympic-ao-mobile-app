import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../models/qps_sales_data.dart';
import '../../../models/trade_promotions/promotion_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/loader/three_dot_loader.dart';
import '../../../services/qps_promotion_services.dart';
import '../controller/sale_controller.dart';

class QpsWarningUi extends ConsumerWidget {
  const QpsWarningUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<QpsSalesData>> asyncPromotions =
        ref.watch(allEnrolledQpsPromotionPerRetailerProvider);
    // OutletSaleStatus geoFencingStatus = ref.watch(outletSaleStatusProvider);
    String lang = ref.watch(languageProvider);

    return asyncPromotions.when(
      data: (promotions) {
        return promotions.isNotEmpty /*&& geoFencingStatus==OutletSaleStatus.showSkus*/
            ? promotions.length > 1
                ? InkWell(
                    onTap: () {
                      Alerts(context: context).showModalWithWidget(
                        child: Stack(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 3.w, right: 3.w, bottom: 1.h, top: 2.h),
                              child: SizedBox(
                                child: Consumer(
                                  builder: (
                                    BuildContext context,
                                    WidgetRef ref,
                                    Widget? child,
                                  ) {
                                    List<int> beforeSelectedOffers =
                                        ref.watch(beforeSelectedQpsPromotion);

                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        ListView.separated(
                                          itemCount: promotions.length,
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context, int index) {
                                            final promotion = promotions[index];
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 2.w,
                                                vertical: 8,
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    (promotion.requiredMemo -
                                                                promotion.memoCount) <=
                                                            0
                                                        ? Icons.cancel_rounded
                                                        : Icons.warning_amber_rounded,
                                                    size: 36,
                                                    color: darkGreen,
                                                  ),
                                                  2.5.w.horizontalSpacing,
                                                  Expanded(
                                                    child: FutureBuilder(
                                                      future: QPSPromotionServices()
                                                          .getQpsPromotionWarningMessage(lang,
                                                              qpsSalesData: promotion),
                                                      builder: (context, snapshot) {
                                                        return LangText(
                                                          snapshot.requireData,
                                                          // '${promotion.promotion.label} You need to buy 100 case CQP 98 case ${promotion.sales.first.sku?.slug} more on next 56 memo for get bike',
                                                          style: TextStyle(
                                                            color: (promotion.requiredMemo -
                                                                        promotion.memoCount) <=
                                                                    0
                                                                ? Colors.red
                                                                : primaryBlack,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          separatorBuilder: (BuildContext context, int index) {
                                            return const Divider(
                                              height: 2,
                                            );
                                          },
                                        ),
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
                        ),
                      );
                    },
                    child: Container(
                      color: darkGreen,
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.white,
                            size: 36,
                          ),
                          2.5.w.horizontalSpacing,
                          Expanded(
                            child: LangText(
                              'You have more than one QPS promotion',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: promotions.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      final promotion = promotions[index];
                      return Container(
                        color: darkGreen,
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              (promotion.requiredMemo - promotion.memoCount) <= 0
                                  ? Icons.cancel_rounded
                                  : Icons.warning_amber_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                            2.5.w.horizontalSpacing,
                            Expanded(
                              child: FutureBuilder(
                                future: QPSPromotionServices()
                                    .getQpsPromotionWarningMessage(lang, qpsSalesData: promotion),
                                builder: (context, snapshot) {
                                  return LangText(
                                    snapshot.requireData,
                                    // '${promotion.promotion.label} You need to buy 100 case CQP 98 case ${promotion.sales.first.sku?.slug} more on next 56 memo for get bike',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
            : const SizedBox();
      },
      // data: (promotions) {
      //   return promotions.isNotEmpty /*&& geoFencingStatus==OutletSaleStatus.showSkus*/
      //       ? ListView.builder(
      //           itemCount: promotions.length,
      //           shrinkWrap: true,
      //           physics: const NeverScrollableScrollPhysics(),
      //           itemBuilder: (BuildContext context, int index) {
      //             final promotion = promotions[index];
      //             return Container(
      //               color: darkGreen,
      //               padding: EdgeInsets.symmetric(
      //                 horizontal: 5.w,
      //                 vertical: 8,
      //               ),
      //               child: Row(
      //                 children: [
      //                   const Icon(
      //                     Icons.warning_amber_rounded,
      //                     color: Colors.white,
      //                     size: 36,
      //                   ),
      //                   2.5.w.horizontalSpacing,
      //                   Expanded(
      //                     child: LangText(
      //                       QPSPromotionServices().getQpsPromotionWarningMessage(lang, qpsSalesData: promotion),
      //                       // '${promotion.promotion.label} You need to buy 100 case CQP 98 case ${promotion.sales.first.sku?.slug} more on next 56 memo for get bike',
      //                       style: const TextStyle(
      //                         color: Colors.white,
      //                         fontWeight: FontWeight.bold,
      //                       ),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             );
      //           },
      //         )
      //       : const SizedBox();
      // },
      error: (error, _) => Container(),
      loading: () => Padding(
        padding: EdgeInsets.only(top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            16.horizontalSpacing,
            LangText('Checking enrolled promotions'),
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: ThreeDotLoader(),
            ),
          ],
        ),
      ),
    );
  }
}
