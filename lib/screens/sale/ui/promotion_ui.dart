import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../models/products_details_model.dart';
import '../../../models/trade_promotions/promotion_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/language_textbox.dart';

class PromotionUI extends ConsumerWidget {
  final double iconHeight;
  final double iconWidth;
  const PromotionUI({Key? key, required this.sku, this.iconHeight = 28, this.iconWidth = 28}) : super(key: key);
  final ProductDetailsModel sku;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<PromotionModel>> asyncPromotions =
        ref.watch(promotionsPerSkuAndRetailerProvider(sku));
    return asyncPromotions.when(
      data: (promotions) {
        if (promotions.isEmpty) {
          return const SizedBox();
        }

        return InkWell(
          onTap: () {
            Alerts(context: context).showModalWithWidget(
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 3.w, right: 3.w, bottom: 1.h, top: 2.h),
                    child: SizedBox(
                      height: 40.h,
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
                          Expanded(
                            child: ListView.builder(
                              itemCount: promotions.length,
                              itemBuilder: (context, i) {
                                PromotionModel promotion = promotions[i];
                                return PromotionItemUI(promotion: promotion);
                              },
                            ),
                          ),
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
                    ),
                  )
                ],
              ),
            );
          },
          child: Image.asset(
            'assets/promotion/percentage.png',
            height: iconHeight,
            width: iconHeight,
            fit: BoxFit.fill,
          ),
        );
      },
      error: (error, _) => Container(),
      loading: () => SizedBox(
        height: iconHeight,
        width: iconWidth,
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 1,),
        ),
      ),
    );
  }
}

class PromotionItemUI extends StatelessWidget {
  const PromotionItemUI({
    Key? key,
    required this.promotion,
    this.onTap,
    this.selected,
    this.suggested,
  }) : super(key: key);
  final PromotionModel promotion;
  final Function()? onTap;
  final bool? selected;
  final bool? suggested;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.zero,
              shape: selected ?? false
                  ? RoundedRectangleBorder(
                      side: const BorderSide(color: primary, width: 2.0),
                      borderRadius: BorderRadius.circular(7.0),
                    )
                  : null,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                  child: LangText(
                    promotion.label,
                    style: TextStyle(color: green, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            if (suggested == true)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                    color: green,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  child: LangText(
                    'After analysing you previous sales, we recommend this offer to you',
                    style: TextStyle(fontSize: standardFontSize, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
