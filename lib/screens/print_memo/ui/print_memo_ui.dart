import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/screens/print_memo/ui/print_memo_details_ui.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_variables.dart';
import '../../../main.dart';
import '../../../models/journey_change_route_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../controller/print_memo_controller.dart';

class PrintMemoUI extends ConsumerStatefulWidget {
  const PrintMemoUI({super.key});

  static const routeName = "print_memo_ui";

  @override
  ConsumerState<PrintMemoUI> createState() => _PrintMemoUIState();
}

class _PrintMemoUIState extends ConsumerState<PrintMemoUI> {
  late PrintMemoController printMemoController;

  @override
  void initState() {
    super.initState();
    printMemoController = PrintMemoController(context: context, ref: ref);

    ///take decision about my current route fom [FridaySalesController]
    // fridaySalesController.controllerInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Memo Print",
        titleImage: "print_memo.png",
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: 2.h),
        children: [
          2.h.verticalSpacing,
          InkWell(
            onTap: () async {
              await printMemoController.movementDateRange();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5.sp),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 9.sp),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(verificationRadius),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer(builder: (context, ref, _) {
                      DateTime pickedRange = ref.watch(selectedPrintMemoDateProvider);
                      String dateRange = "Date";
                      Color color = lightMediumGrey;
                      double size = 9.sp;
                        dateRange = uiDateFormat.format(pickedRange);
                        color = Colors.black;
                        size = 11.sp;
                        return Text(
                          dateRange,
                          style: TextStyle(color: color, fontSize: size),
                        );
                    }),
                    Icon(
                      Icons.calendar_month_outlined,
                      color: lightMediumGrey,
                    )
                  ],
                ),
              ),
            ),
          ),
          2.h.verticalSpacing,
          Consumer(
            builder: (
              BuildContext context,
              WidgetRef ref,
              Widget? child,
            ) {
              final asyncLoadSummary = ref.watch(loadSummaryListProvider);
              return asyncLoadSummary.when(
                data: (loadSummary) {
                  if (loadSummary.isEmpty) {
                    return Consumer(builder: (context, ref, _) {
                      final date = ref.watch(selectedPrintMemoDateProvider);
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 64),
                          child: LangText(
                            "No Load-summary available at\n${apiDateFormat.format(date)}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    });
                  }
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: loadSummary.length,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemBuilder: (BuildContext context, int index) {
                      final loadSummaryData = loadSummary[index];
                      return InkWell(
                        onTap: () {
                          navigatorKey.currentState?.pushNamed(
                              PrintMemoDetailsUI.routeName,
                              arguments: loadSummaryData);
                        },
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Column(
                                children: [
                                  _dataWidget(
                                    title: "Vehicle",
                                    data: loadSummaryData.name ?? "",
                                  ),
                                  _dataWidget(
                                    title: "Delivery Date",
                                    data: loadSummaryData.date ?? "",
                                  ),
                                  _dataWidget(
                                    title: "Total SKU",
                                    data: loadSummaryData.totalSku ?? "",
                                    isNumber: true,
                                  ),
                                  _dataWidget(
                                    title: "Total Price",
                                    data: loadSummaryData.totalPrice ?? "",
                                    isNumber: true,
                                  ),
                                  _dataWidget(
                                    title: "Route Cost",
                                    data: (loadSummaryData.routeCost ?? "0")
                                        .toString(),
                                    isNumber: true,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(16),
                                  topLeft: Radius.circular(16),
                                ),
                                color: lightMediumGrey,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 5,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 16);
                    },
                  );
                },
                error: (error, _) {
                  return Center(
                    child: LangText("Nothing to see"),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget heading(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
      child: LangText(
        label,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
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
          Expanded(flex: 2, child: LangText("$title :")),
          Expanded(
            flex: 2,
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
}
