import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/screens/sales_summary/ui/sales_summary.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/delivery/delivery_summary_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../sale/ui/sku_case_piece_show_widget.dart';
import 'sale_summary_table_header.dart';

class DeliverySummary extends ConsumerStatefulWidget {
  const DeliverySummary({super.key});

  @override
  _DeliverySummaryState createState() => _DeliverySummaryState();
}

class _DeliverySummaryState extends ConsumerState<DeliverySummary> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        AsyncValue<List<DeliverySummaryModel>> asyncDeliverySummaryFeature =
            ref.watch(deliverySummaryProvider);

        return asyncDeliverySummaryFeature.when(
          data: (deliverySummery) {
            if (deliverySummery.isEmpty) {
              return Center(
                child: LangText('No data available.'),
              );
            }
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              children: [
                Consumer(builder: (context, ref, _) {
                  return Row(
                    children: [
                      for (int a = 0; a != deliverySummery.length; a++)
                        dateTab(
                          data: "${deliverySummery[a].date}",
                          selected: ref.watch(selectedDeliverySummary) == a,
                          onTap: () {
                            ref.read(selectedDeliverySummary.notifier).state = a;
                          },
                        ),
                      // dateTab(
                      //   data: "${deliverySummery.last.date}",
                      //   selected: ref.watch(selectedDeliverySummary) == 1,
                      //   onTap: () {
                      //     ref.read(selectedDeliverySummary.notifier).state = 1;
                      //   },
                      // ),
                    ],
                  );
                }),
                const SaleSummaryTableHeader(
                  sharpTopLeft: true,
                ),
                if (deliverySummery[ref.watch(selectedDeliverySummary)].sales?.isEmpty ?? true)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: LangText('No delivery summary available'),
                    ),
                  ),
                if (deliverySummery[ref.watch(selectedDeliverySummary)].sales?.isNotEmpty ?? true)
                  ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount:
                        deliverySummery[ref.watch(selectedDeliverySummary)].sales?.length ?? 0,
                    itemBuilder: (context, index) {
                      var value = deliverySummery[ref.watch(selectedDeliverySummary)].sales![index];
                      var bcp = getPcp(deliverySummery[ref.watch(selectedDeliverySummary)].sales);
                      // return salesSummaryItem(value, bcp);
                      return SalesSummaryItem(
                        skuName: value.skuName ?? 'N/A',
                        memo: value.outletCount.toString(),
                        bcp: bcp,
                        sttWidget: SKUCasePieceShowWidget(
                          sku: value.sku!,
                          qtyTextStyle: TextStyle(
                            color: red3,
                            fontSize: 11,
                          ),
                          unitTextStyle: TextStyle(
                            color: red3,
                            fontSize: 11,
                          ),
                          showUnitName: true,
                          qty: value.quantity ?? 0,
                          alignment: MainAxisAlignment.end,
                          verticalView: true,
                        ),
                        price: (value.price ?? 0),
                      );
                    },
                  ),
                Container(
                  width: 100.w,
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [primaryBlue, darkGreen],
                      ),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(5.sp), bottomLeft: Radius.circular(5.sp))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LangText('Discount',
                                style: TextStyle(
                                    fontSize: normalFontSize,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            // Discount & Others (-)
                            Row(
                              children: [
                                LangText(
                                  '- ',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: normalFontSize,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                LangText(
                                  (deliverySummery[ref.watch(selectedDeliverySummary)]
                                              .discountPrice ??
                                          0)
                                      .toStringAsFixed(2),
                                  isNumber: true,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: normalFontSize,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      /// grand total
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LangText('Grand Total',
                                style: TextStyle(
                                    fontSize: normalFontSize,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            // Grand Total
                            LangText(
                              getTotalPrice(
                                      deliverySummery[ref.watch(selectedDeliverySummary)].sales)
                                  .toStringAsFixed(2),
                              isNumber: true,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: normalFontSize,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          error: (error, _) => Container(),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget dateTab({required String data, required bool selected, required Function() onTap}) {
    return Container(
      height: 4.h,
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: selected
                ? [primaryBlue, primary]
                : [primaryBlue.withOpacity(0.3), primary.withOpacity(0.3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius:
              BorderRadius.only(topLeft: Radius.circular(5.sp), topRight: Radius.circular(5.sp))),
      child: InkWell(
        onTap: onTap,
        child: Tab(
          child: LangText(
            data,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget salesSummaryItem(Sales salesSummary, double bcp) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: LangText(
              salesSummary.skuName ?? '',
              style: TextStyle(color: red3, fontSize: normalFontSize),
            ),
          ),
          Expanded(
            child: Center(
              child: LangText(
                "${salesSummary.outletCount}",
                isNumber: true,
                style: TextStyle(color: red3, fontSize: normalFontSize),
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LangText(
                  bcp.toStringAsFixed(1),
                  isNumber: true,
                  isNum: false,
                  style: TextStyle(color: red3, fontSize: normalFontSize),
                ),
                LangText("%", style: TextStyle(color: red3, fontSize: normalFontSize))
              ],
            ),
          ),
          Expanded(
            child: SKUCasePieceShowWidget(
              sku: salesSummary.sku!,
              qtyTextStyle: TextStyle(color: red3, fontSize: normalFontSize),
              unitTextStyle: TextStyle(color: red3, fontSize: normalFontSize),
              showUnitName: true,
              qty: salesSummary.quantity ?? 0,
              alignment: MainAxisAlignment.end,
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LangText(
                    (salesSummary.price ?? 0).toStringAsFixed(2),
                    isNumber: true,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: red3, fontSize: normalFontSize),
                  ),
                  LangText(
                    '৳',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: red3, fontSize: normalFontSize),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double getTotalPrice(List<Sales>? sales) {
    double totalPrice = 0;
    sales?.forEach((element) {
      totalPrice += element.price ?? 0;
    });
    return totalPrice;
  }

  double getPcp(List<Sales>? sales) {
    int totalQuantity = 0;
    sales?.forEach((element) {
      totalQuantity += element.outletCount ?? 0;
    });

    return (totalQuantity * 100) / (sales?.length ?? 1);
  }
}
