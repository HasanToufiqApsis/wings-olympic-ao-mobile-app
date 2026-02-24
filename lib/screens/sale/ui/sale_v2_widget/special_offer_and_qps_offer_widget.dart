import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wings_olympic_sr/reusable_widgets/language_textbox.dart';
import 'package:wings_olympic_sr/reusable_widgets/language_textbox.dart';
import 'package:wings_olympic_sr/reusable_widgets/loader/three_dot_loader.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../../provider/global_provider.dart';
import '../qps_offer_ui.dart';
import '../special_offer_ui.dart';

class SpecialOfferAndQpsOfferWidget extends StatelessWidget {
  const SpecialOfferAndQpsOfferWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final asyncSpecialPromotions = ref.watch(comboPromotionPerRetailerProvider);

      // return asyncSpecialPromotions.when(
      //   data: (specialPromotions) {
          return Consumer(
            builder: (context, ref, _) {
              final asyncSalesData = ref.watch(salesDataForQpsPromotionTargetProvider);
              final asyncQpsPromotions = ref.watch(unEnrolledQpsPromotionPerRetailerProvider);

              return asyncQpsPromotions.when(
                data: (qpsPromotions) {
                  return asyncSalesData.when(
                    data: (salesData) {
                      return Wrap(
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 10.0,
                        children: [
                          // SpecialOffer(promotions: specialPromotions),
                          QpsOffer(promotions: qpsPromotions, salesData: salesData),
                          // PreorderCategoryFilterButtons(),
                        ],
                      );
                    },
                    error: (err, stack) => const SizedBox(),
                    loading: () => SizedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          16.horizontalSpacing,
                          LangText('Loading Sales data'),
                          Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: ThreeDotLoader(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                error: (err, stack) => const SizedBox(),
                loading: () => SizedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      16.horizontalSpacing,
                      LangText('Loading QPS promotions'),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: ThreeDotLoader(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
      //   },
      //   error: (err, stack) => const SizedBox(),
      //   loading: () => SizedBox(
      //     child: Row(
      //       crossAxisAlignment: CrossAxisAlignment.end,
      //       children: [
      //         16.horizontalSpacing,
      //         LangText('Loading Special promotions'),
      //         Padding(
      //           padding: EdgeInsets.only(bottom: 8),
      //           child: ThreeDotLoader(),
      //         ),
      //       ],
      //     ),
      //   ),
      // );
    });
  }
}
