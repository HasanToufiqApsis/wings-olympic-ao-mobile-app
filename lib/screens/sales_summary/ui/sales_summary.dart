import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/utils/sales_type_utils.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/delivery/delivery_summary_model.dart';
import '../../../models/sale_summary_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../sale/ui/sku_case_piece_show_widget.dart';
import 'sale_summary_table_header.dart';

class SalesSummary extends ConsumerStatefulWidget {
  final SaleType saleType;

  const SalesSummary({super.key, required this.saleType});

  @override
  _SalesSummaryState createState() => _SalesSummaryState();
}

class _SalesSummaryState extends ConsumerState<SalesSummary> {
  GlobalWidgets globalWidgets = GlobalWidgets();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: globalWidgets.showInfo(
              message: "Your full day sales details will be here",
            ), // Your full day sales details will be here
          ),
          SizedBox(
            height: 0.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Consumer(builder: (context, ref, _) {
              AsyncValue<Map<String, List<SalesSummaryModel>>> asyncSummaryData =
                  ref.watch(salesSummaryProvider(widget.saleType));

              return asyncSummaryData.when(
                  data: (salesSummaryData) {
                    if (salesSummaryData.isNotEmpty) {
                      return ListView.builder(
                          itemCount: salesSummaryData.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            String moduleId = salesSummaryData.keys.elementAt(i);
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ///module heading
                                // Align(
                                //   alignment: Alignment.centerLeft,
                                //   child: Container(
                                //     height: 4.h,
                                //     width: 20.w,
                                //     padding: EdgeInsets.symmetric(horizontal: 3.w),
                                //     alignment: Alignment.centerLeft,
                                //     decoration: BoxDecoration(
                                //         gradient: const LinearGradient(
                                //           colors: [primaryGreen, blue3],
                                //           begin: Alignment.topCenter,
                                //           end: Alignment.bottomCenter,
                                //         ),
                                //         borderRadius: BorderRadius.only(topLeft: Radius.circular(5.sp), topRight: Radius.circular(5.sp))),
                                //     child: Center(
                                //       child: Consumer(builder: (context, ref, _) {
                                //         AsyncValue<Module> asyncModule = ref.watch(moduleByIdProvider(moduleId));
                                //         return asyncModule.when(
                                //             data: (moduleModel) {
                                //               return Text(
                                //                 moduleModel.name,
                                //                 style: const TextStyle(color: Colors.white),
                                //               );
                                //             },
                                //             error: (error, _) => Container(),
                                //             loading: () => Container());
                                //       }),
                                //     ),
                                //   ),
                                // ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5.sp),
                                        bottomRight: Radius.circular(5.sp)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 0.5,
                                        blurRadius: 5,
                                        offset: const Offset(0, 1), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      /// table header
                                      const SaleSummaryTableHeader(),

                                      ///sku list
                                      ListView.builder(
                                        shrinkWrap: true,
                                        primary: false,
                                        itemCount: salesSummaryData[moduleId]!.length,
                                        itemBuilder: (context, index) {
                                          final summary = salesSummaryData[moduleId]![index];
                                          return Consumer(
                                            builder: (context, ref, _) {
                                              AsyncValue<int> asyncTotalRetailer =
                                                  ref.watch(totalRetailerProvider(widget.saleType));

                                              return asyncTotalRetailer.when(
                                                data: (retailer) {
                                                  return SalesSummaryItem(
                                                    skuName: summary.sku.shortName,
                                                    memo: summary.memo.toString(),
                                                    bcp: summary.getBCP(retailer),
                                                    sttWidget: SKUCasePieceShowWidget(
                                                      sku: summary.sku,
                                                      qtyTextStyle: TextStyle(
                                                          color: red3, fontSize: smallFontSize),
                                                      unitTextStyle: TextStyle(
                                                        color: red3,
                                                        fontSize: smallerFontSize,
                                                      ),
                                                      showUnitName: true,
                                                      qty: summary.stt,
                                                      alignment: MainAxisAlignment.center,
                                                      verticalView: false,
                                                    ),
                                                    price: summary.price,
                                                  );
                                                },
                                                error: (error, _) => Container(),
                                                loading: () => Container(),
                                              );
                                            },
                                          );
                                        },
                                      ),

                                      ///total count
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
                                                bottomRight: Radius.circular(5.sp),
                                                bottomLeft: Radius.circular(5.sp))),
                                        child: Consumer(builder: (context, ref, _) {
                                          AsyncValue<num> asyncTotalSaleDiscountOthers = ref.watch(
                                              totalSaleDiscountOthersProvider(int.parse(moduleId)));
                                          return asyncTotalSaleDiscountOthers.when(
                                              data: (totalSaleDiscountOthers) {
                                                double total = 0;
                                                int totalProduct = 0;

                                                double grandTotalSale = 0.0;
                                                double totalSale = 0.0;
                                                double totalDiscountSale = 0.0;

                                                for (SalesSummaryModel salesSummaryModel
                                                    in salesSummaryData[moduleId] ?? []) {
                                                  total += salesSummaryModel.price;
                                                  totalProduct += salesSummaryModel.stt;
                                                }
                                                double totalAfterDiscountAndOthers =
                                                    total - totalSaleDiscountOthers;

                                                totalSale += total;
                                                totalDiscountSale += totalSaleDiscountOthers;
                                                grandTotalSale += totalAfterDiscountAndOthers;
                                                return Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 1.h),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.spaceBetween,
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
                                                                totalSaleDiscountOthers
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
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          LangText('Grand Total',
                                                              style: TextStyle(
                                                                  fontSize: normalFontSize,
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold)),
                                                          // Grand Total
                                                          LangText(
                                                            grandTotalSale.toStringAsFixed(2),
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
                                                );
                                              },
                                              error: (error, s) {
                                                print('inside UI error sales summary: $error $s');
                                                return Container();
                                              },
                                              loading: () => Container());
                                        }),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                              ],
                            );
                          });
                    } else {
                      return Center(
                        child: LangText(
                          'Nothing to show', // Nothing to show
                          style: TextStyle(fontSize: normalFontSize, color: grey),
                        ),
                      );
                    }
                  },
                  error: (error, _) {
                    print('inside UI error sales summary: $error');
                    return Container();
                  },
                  loading: () => Container());
            }),
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 5.w),
          //   child: const TotalSaleAmountWidget(),
          // ),
          // globalWidgets.button(
          //     colors: [blue3, darkBlue],
          //     text: 'Print',
          //     callback: () async {
          //       // Print
          //
          //       await PrinterController(context: context, ref: ref).printSaleSummaryMemo();
          //     },
          //     isIconLeft: true,
          //     icon: const Icon(
          //     icon: const Icon(
          //       Icons.print,
          //       color: Colors.white,
          //     )),
          SizedBox(
            height: 3.h,
          )
        ],
      ),
    );
  }

  Widget salesSummaryItem(SalesSummaryModel salesSummary) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: LangText(
              salesSummary.sku.shortName,
              style: TextStyle(color: red3, fontSize: normalFontSize),
            ),
          ),
          Expanded(
            child: Center(
              child: LangText(
                salesSummary.memo.toString(),
                isNumber: true,
                style: TextStyle(color: red3, fontSize: normalFontSize),
              ),
            ),
          ),
          Consumer(builder: (context, ref, _) {
            AsyncValue<int> asyncTotalRetailer = ref.watch(totalRetailerProvider(widget.saleType));

            return asyncTotalRetailer.when(
                data: (retailer) {
                  return Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: LangText(
                            salesSummary.getBCP(retailer).toStringAsFixed(1),
                            isNumber: true,
                            isNum: false,
                            style: TextStyle(color: red3, fontSize: normalFontSize),
                          ),
                        ),
                        LangText("%", style: TextStyle(color: red3, fontSize: normalFontSize))
                      ],
                    ),
                  );
                },
                error: (error, _) => Container(),
                loading: () => Container());
          }),
          Expanded(
            child: SKUCasePieceShowWidget(
              sku: salesSummary.sku,
              qtyTextStyle: TextStyle(color: red3, fontSize: normalFontSize),
              unitTextStyle: TextStyle(color: red3, fontSize: normalFontSize),
              showUnitName: true,
              qty: salesSummary.stt,
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
                  Expanded(
                    child: LangText(
                      '${salesSummary.price.toStringAsFixed(2)}৳',
                      isNumber: true,
                      textAlign: TextAlign.right,
                      style: TextStyle(color: red3, fontSize: normalFontSize),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SalesSummaryItem extends StatelessWidget {
  final String skuName;
  final String memo;
  final num bcp;
  final Widget sttWidget;
  final num price;

  const SalesSummaryItem({
    super.key,
    required this.skuName,
    required this.memo,
    required this.bcp,
    required this.sttWidget,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: LangText(
              skuName,
              style: TextStyle(color: red3, fontSize: smallFontSize),
            ),
          ),
          Expanded(
            child: Center(
              child: LangText(
                memo,
                isNumber: true,
                style: TextStyle(color: red3, fontSize: smallFontSize),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: LangText(
                    bcp.toStringAsFixed(1),
                    isNumber: true,
                    isNum: false,
                    style: TextStyle(color: red3, fontSize: smallFontSize),
                  ),
                ),
                LangText(
                  "%",
                  style: TextStyle(color: red3, fontSize: smallFontSize),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: sttWidget,
          ),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: LangText(
                      price.toStringAsFixed(2),
                      isNumber: true,
                      textAlign: TextAlign.right,
                      style: TextStyle(color: red3, fontSize: smallFontSize),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
