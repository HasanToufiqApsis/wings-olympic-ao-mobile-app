import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/journey_change_route_model.dart';
import '../../../models/trade_promotions/applied_discount_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../utils/promotion_utils.dart';
import '../../printer/controllers/printer_controller.dart';
import '../../printer/printer_connect_widget.dart';
import '../controller/print_memo_controller.dart';
import '../model/load_summaryDetailsModel.dart';
import '../model/load_summary_model.dart';
import '../service/print_memo_service.dart';

class PrintMemoDetailsUI extends ConsumerStatefulWidget {
  final LoadSummaryModel loadSummaryModel;

  const PrintMemoDetailsUI({
    super.key,
    required this.loadSummaryModel,
  });

  static const routeName = "print_memo_details_ui";

  @override
  ConsumerState<PrintMemoDetailsUI> createState() => _PrintMemoDetailsUIState();
}

class _PrintMemoDetailsUIState extends ConsumerState<PrintMemoDetailsUI> {
  late PrintMemoController _printMemoController;
  late PrinterController _printerController;
  final _printService = PrintMemoService();
  late Alerts _alerts;

  @override
  void initState() {
    _alerts = Alerts(context: context);
    super.initState();
    _printMemoController = PrintMemoController(context: context, ref: ref);
    _printerController = PrinterController(context: context, ref: ref);
  }

  int indexCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Details",
      ),
      floatingActionButton: const PrinterConnectWidget(),
      body: Consumer(
        builder: (
          BuildContext context,
          WidgetRef ref,
          Widget? child,
        ) {
          final asyncLoadSummary = ref.watch(
            loadSummaryDetailsProvider(widget.loadSummaryModel),
          );
          return asyncLoadSummary.when(data: (loadSummary) {
            return ListView(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    PrinterStatus printerConnected =
                        ref.watch(printerConnectedProvider);
                    return Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                backgroundColor: red3,
                              ),
                              onPressed: () {
                                if (printerConnected !=
                                    PrinterStatus.connected) {
                                  _alerts.customDialog(
                                      type: AlertType.warning,
                                      message: "Printer not connected",
                                      onTap1: () {
                                        Navigator.of(context).pop();
                                      });
                                  return;
                                }
                                _alerts.customDialog(
                                  type: AlertType.warning,
                                  message: "Are you sure?",
                                  description: "Are you want to print the memo?",
                                  twoButtons: true,
                                  onTap1: () {
                                    Navigator.of(context).pop();
                                    _printerController.printMemo(
                                      loadSummary: loadSummary,
                                      loadSummaryModel: widget.loadSummaryModel,
                                    );
                                  },
                                  onTap2: () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  LangText(
                                    "Print Memo",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  // Right text
                                ],
                              )),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                backgroundColor: red3,
                              ),
                              onPressed: () {
                                if (printerConnected !=
                                    PrinterStatus.connected) {
                                  _alerts.customDialog(
                                      type: AlertType.warning,
                                      message: "Printer not connected",
                                      onTap1: () {
                                        Navigator.of(context).pop();
                                      });
                                  return;
                                }
                                _alerts.customDialog(
                                  type: AlertType.warning,
                                  message: "Are you sure?",
                                  description: "Are you want to print the summary?",
                                  twoButtons: true,
                                  onTap1: () {
                                    Navigator.of(context).pop();
                                    _printerController.printLoadSummary(
                                      loadSummary: loadSummary,
                                      loadSummaryModel: widget.loadSummaryModel,
                                    );
                                  },
                                  onTap2: () {
                                    Navigator.of(context).pop();
                                  },
                                );

                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // const Icon(Icons.document_scanner_outlined,
                                  //     color: Colors.white),
                                  // // Left icon
                                  // const SizedBox(width: 10),
                                  LangText(
                                    "Print Summary",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  // Right text
                                ],
                              )),
                        ),
                      ],
                    );
                    if (printerConnected == PrinterStatus.connected) {
                      return const Icon(
                        Icons.print,
                        color: Colors.white,
                      );
                    } else if (printerConnected == PrinterStatus.disconnected) {
                      return const Icon(Icons.print_disabled,
                          color: Colors.red);
                    } else {
                      return Stack(
                        children: [
                          Center(
                              child: Icon(
                            Icons.print,
                            color: grey,
                          )),
                          Center(
                              child: CircularProgressIndicator(
                            strokeWidth: 2.sp,
                          )),
                        ],
                      );
                    }
                    // return printerConnected?
                    // Icon(Icons.print, color: green,)
                    //     :
                    // const Icon(Icons.print_disabled, color: Colors.red);
                  },
                ),
                const SizedBox(height: 10),
                ...loadSummary.entries.map((entry) {
                  int index = loadSummary.keys.toList().indexOf(
                      entry.value.first.loadSummaryId.toString() ?? "");
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: primaryBlue,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LangText(
                                "Trip",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                              LangText(
                                " ",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                              LangText(
                                (index + 1).toString(),
                                isNum: true,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: entry.value.length,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          itemBuilder: (BuildContext context, int index) {
                            final loadSummaryModel = entry.value[index];
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.symmetric(
                                // horizontal: 16,
                                vertical: 12,
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 6,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _dataWidget(
                                          title: "Outlet Name",
                                          data:
                                              loadSummaryModel.outletName ?? "",
                                        ),
                                        const SizedBox(height: 2),
                                        _dataWidget(
                                          title: "Outlet Code",
                                          data:
                                              loadSummaryModel.outletCode ?? "",
                                        ),
                                        const SizedBox(height: 2),
                                        _dataWidget(
                                          title: "Owner Name",
                                          data:
                                              loadSummaryModel.ownerName ?? "",
                                        ),
                                        const SizedBox(height: 2),
                                        _dataWidget(
                                          title: "Address",
                                          data: loadSummaryModel.address ?? "",
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            LangText(
                                              "Preorder: ${widget.loadSummaryModel.orderDate}",
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                            LangText(
                                              "Delivery: ${widget.loadSummaryModel.date}",
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            LangText(
                                              "Rout: ${loadSummaryModel.route}",
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                            LangText(
                                              "Mob No.: ${loadSummaryModel.contactNumber}",
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                  dividerWidget(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 4),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 2,
                                            child: LangText(
                                              "SKU ",
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            )),
                                        Expanded(
                                            child: LangText(
                                          "QTY ",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 13),
                                        )),
                                        Expanded(
                                            child: LangText(
                                          "Total ",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 13),
                                        )),
                                        Expanded(
                                            child: LangText(
                                          "Offer ",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 13),
                                        )),
                                        Expanded(
                                            child: LangText(
                                          "Payable ",
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(fontSize: 13),
                                        )),
                                      ],
                                    ),
                                  ),
                                  dividerWidget(),
                                  Consumer(
                                    builder: (
                                      BuildContext context,
                                      WidgetRef ref,
                                      Widget? child,
                                    ) {
                                      final asyncSkuList = ref.watch(
                                        printingMemoByOutletProvider(
                                            loadSummaryModel.skus),
                                      );
                                      return asyncSkuList.when(
                                        data: (skuList) {
                                          return ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: skuList.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              final sku = skuList[index];
                                              return Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 4),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: LangText(
                                                            (sku.formatedSku
                                                                        .name ??
                                                                    "")
                                                                .trim(),
                                                            textAlign:
                                                                TextAlign.start,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        13),
                                                          ),
                                                        ),
                                                        Expanded(
                                                            child: LangText(
                                                          _printService.getFormatedQty(sku),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 13),
                                                        )),
                                                        Expanded(
                                                            child: LangText(
                                                          "${sku.total}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 13),
                                                        )),
                                                        Expanded(
                                                            child: LangText(
                                                          sku.offer == 0
                                                              ? "-"
                                                              : "-${sku.offer}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 13),
                                                        )),
                                                        Expanded(
                                                            child: LangText(
                                                          "${sku.payable}",
                                                          textAlign:
                                                              TextAlign.right,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 13),
                                                        )),
                                                      ],
                                                    ),
                                                    // _checkCrossProductPromotion(sku),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        error: (error, _) {
                                          return const SizedBox();
                                        },
                                        loading: () {
                                          return const SizedBox();
                                        },
                                      );
                                    },
                                  ),
                                  // ListView.builder(
                                  //   physics: const NeverScrollableScrollPhysics(),
                                  //   itemCount: loadSummaryModel.skus?.length ?? 0,
                                  //   shrinkWrap: true,
                                  //   itemBuilder: (context, index) {
                                  //     final sku = loadSummaryModel.skus![index];
                                  //     return Container(
                                  //       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                  //       child: Column(
                                  //         children: [
                                  //           Row(
                                  //             children: [
                                  //               Expanded(
                                  //                 flex: 2,
                                  //                 child: LangText(
                                  //                   (sku.formatedSku?.nameBn ??
                                  //                       "").trim(),
                                  //                   textAlign: TextAlign.start,
                                  //                   style: const TextStyle(fontSize: 13),
                                  //                 ),
                                  //               ),
                                  //               Expanded(child: LangText(_printService.getFormatedQTY(sku),
                                  //                 textAlign: TextAlign.center,
                                  //                 style: const TextStyle(fontSize: 13),)),
                                  //               Expanded(child: LangText(_printService.getFormatedTotal(sku).toString(),
                                  //                 textAlign: TextAlign.center,
                                  //                 style: const TextStyle(fontSize: 13),)),
                                  //               Expanded(child: LangText(_printService.getFormatedOffer(sku).toString(),
                                  //                 textAlign: TextAlign.center,
                                  //                 style: const TextStyle(fontSize: 13),)),
                                  //               Expanded(child: LangText(_printService.getFormatedPayable(sku).toString(),
                                  //                 textAlign: TextAlign.right,
                                  //                 style: const TextStyle(fontSize: 13),)),
                                  //             ],
                                  //           ),
                                  //           _checkCrossProductPromotion(sku),
                                  //         ],
                                  //       ),
                                  //     );
                                  //   },
                                  // ),

                                  dividerWidget(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 4),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 2,
                                            child: LangText(
                                              "Total ",
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            )),
                                        Expanded(
                                            child: LangText(
                                          _printService.getFormatedTotalQTY(
                                              loadSummaryModel),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 13),
                                        )),
                                        Expanded(
                                            child: LangText(
                                          _printService.getFormatedTotalTotal(
                                              loadSummaryModel),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 13),
                                        )),
                                        Expanded(
                                            child: LangText(
                                          _printService.getFormatedTotalOffer(
                                              loadSummaryModel),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 13),
                                        )),
                                        Expanded(
                                            child: LangText(
                                          _printService.getFormatedTotalPayable(
                                              loadSummaryModel),
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(fontSize: 13),
                                        )),
                                      ],
                                    ),
                                  ),
                                  dividerWidget(),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 6);
                          },
                        ),
                      ],
                    ),
                  );
                  indexCount++;
                }).toList()
              ],
            );
          }, error: (error, _) {
            return Center(
              child: LangText("Nothing to see"),
            );
          }, loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
        },
      ),
    );
  }

  Widget _dataWidget({
    required String title,
    required String data,
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          LangText("$title : "),
          Expanded(
            child: LangText(
              data,
              isNum: true,
              isNumber: isNumber,
            ),
          ),
        ],
      ),
    );
  }

  Widget dividerWidget({double? size}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(children: [
        Expanded(
            child: Text(
                "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------",
                maxLines: 1,
                style: TextStyle(fontSize: size ?? 10, color: Colors.grey)))
      ]),
    );
  }

  Widget _checkCrossProductPromotion(LoadSummarySkus sku) {
    List<AppliedDiscountModel> discounts = sku.discount ?? [];
    if (discounts.isNotEmpty) {
      for (var discount in discounts) {
        if (discount.promotion.payableType == PayableType.productDiscount) {
          if (discount.promotion.appliedSkus.isNotEmpty &&
              discount.promotion.discountSkus.isNotEmpty &&
              discount.promotion.appliedSkus.length == 1 &&
              discount.promotion.discountSkus.length == 1) {
            final appliedSkus = discount.promotion.appliedSkus.first;
            final discountSkus = discount.promotion.discountSkus.first;
            if (appliedSkus.skuId != discountSkus.skuId) {
              return Consumer(
                builder: (
                  BuildContext context,
                  WidgetRef ref,
                  Widget? child,
                ) {
                  final asyncSkuDetails = ref.watch(
                    skuDetailsProvider(discountSkus.skuId),
                  );
                  return asyncSkuDetails.when(data: (skuDetails) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: LangText(
                              (skuDetails?.name ?? "").trim(),
                              textAlign: TextAlign.start,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          Expanded(
                              child: LangText(
                            "0(${discount.appliedDiscount})",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 13),
                          )),
                          Expanded(
                              child: LangText(
                            "0",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 13),
                          )),
                          Expanded(
                              child: LangText(
                            "-",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 13),
                          )),
                          Expanded(
                              child: LangText(
                            "0",
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 13),
                          )),
                        ],
                      ),
                    );
                  }, error: (error, _) {
                    return const SizedBox();
                  }, loading: () {
                    return const SizedBox();
                  });
                },
              );
            }
          }
        }
      }
    }

    return const SizedBox();
  }
}
