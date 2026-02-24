import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/models/trade_promotions/promotion_model.dart';

import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/offfer_date_range_widget.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../utils/promotion_utils.dart';

class PromotionsListScreen extends ConsumerStatefulWidget {
  static const routeName = 'PromotionsListScreen';
  final Map<int, Map<dynamic, dynamic>>? promotions;

  const PromotionsListScreen({
    Key? key,
    this.promotions,
  }) : super(key: key);

  @override
  ConsumerState createState() => _PromotionsListScreenState();
}

class _PromotionsListScreenState extends ConsumerState<PromotionsListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<PromotionModel>> asyncPromotionList = ref.watch(promotionListProvider(widget.promotions));
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: GlobalWidgets().customAppBar(
      //   context: context,
      //   title: 'Promotion',
      //   // iconName: 'promotion.png',
      //   keepLeadingIcon: true,
      //   voidCallback: () {
      //     Navigator.of(context).pop();
      //   },
      //   keepNotificationIcon: false,
      // ),
      appBar: CustomAppBar(
        title: "Promotion",
        titleImage: "promotion.png",
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
            style: BorderStyle.solid,
            width: .5,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0.5,
              blurRadius: 5,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: asyncPromotionList.when(data: (promotions) {
          if (promotions.isEmpty) {
            return Center(
              child: LangText("There is no promotion to display"),
            );
          }
          return ListView.builder(
            itemCount: promotions.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(index == 0 ? 10 : 0),
                    topRight: Radius.circular(index == 0 ? 10 : 0),
                    bottomLeft: Radius.circular(index == promotions.length ? 10 : 0),
                    bottomRight: Radius.circular(index == promotions.length ? 10 : 0),
                  ),
                  color: index % 2 == 0 ? Colors.white : const Color(0xFFE5E7EB).withOpacity(.5),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // color: greenPale.withOpacity(.5),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Image.asset(
                            _getImageByType(promotions[index]),
                            height: 20,
                            width: 20,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: LangText(
                            promotions[index].label ?? 'N/A',
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: EdgeInsets.only(right: 1.w, left: 10.4.w),
                      child: OfferDateWidget(promotion: promotions[index]),
                    ),

                  ],
                ),
              );
            },
          );
        }, error: (e, s) {
          return Container();
        }, loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
      ),
    );
  }

  String _getImageByType(PromotionModel promotion) {
    switch (promotion.payableType) {
      case PayableType.absoluteCash:
        return 'assets/promotion/money.png';
      // case PayableType.point:
      //   return 'assets/promotion/money.png';
      case PayableType.percentageOfValue:
        return 'assets/promotion/tax.png';
      case PayableType.productDiscount:
        return 'assets/promotion/package.png';
      case PayableType.gift:
        return 'assets/promotion/gift.png';
      // case PayableType.packRedemption:
      //   return 'assets/promotion/recycling.png';
      // case PayableType.scratchCard:
      //   return 'assets/promotion/gift.png';
    }
  }
}
