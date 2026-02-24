import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/utils/extensions/date_extension.dart';
import '../../../api/pjp_plan_api.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/pjp_plan_details.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../widget/pjp_plan_item_widget.dart';

class PjpPlanExplanationUI extends ConsumerStatefulWidget {
  final PJPPlanDetails data;

  const PjpPlanExplanationUI({
    Key? key,
    required this.data,
  }) : super(key: key);
  static const routeName = "/pjp_plan_explanation_ui";

  @override
  ConsumerState<PjpPlanExplanationUI> createState() =>
      _PjpPlanExplanationUIState();
}

class _PjpPlanExplanationUIState extends ConsumerState<PjpPlanExplanationUI> {
  @override
  void initState() {
    super.initState();
  }

  final textEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "PJP Plan",
        titleImage: "pre_order_button.png",
        showLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: widget.data.status == PjpStatusType.waiting
                            ? Colors.green.shade100
                            : widget.data.status == PjpStatusType.todayWaiting
                            ? Colors.transparent
                            : widget.data.status == PjpStatusType.missed
                            ? Colors.red
                            : widget.data.status == PjpStatusType.done
                            ? primary
                            : Colors.white,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: widget.data.status == PjpStatusType.todayWaiting
                          ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: SpinKitDoubleBounce(
                            color: primary,
                            size: 18.0,
                          ),
                        ),
                      )
                          : Icon(
                        widget.data.status == PjpStatusType.waiting
                            ? Icons.hourglass_top_rounded
                            : widget.data.status == PjpStatusType.todayWaiting
                            ? Icons.watch_later_outlined
                            : widget.data.status == PjpStatusType.missed
                            ? Icons.close
                            : widget.data.status == PjpStatusType.done
                            ? Icons.check
                            : Icons.add_chart_sharp,
                        // Icons.check,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    title: LangText("${widget.data.date?.toString().dayMonthYear}"),
                    subtitle: LangText(widget.data.category ?? ''),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          border: Border(
                              top: BorderSide(
                                  width: 1, color: grey.withOpacity(0.2))),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            width: 1,
                                            color: grey.withOpacity(0.2))),
                                    margin: const EdgeInsets.only(top: 18),
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, bottom: 8, top: 26),
                                    child: Column(
                                      children: [
                                        _information(
                                          title: "Schedule",
                                          details:
                                          "${widget.data.morningDepName}",
                                        ),
                                        const SizedBox(height: 10),
                                        _information(
                                          title: "Customer",
                                          details:
                                          "${widget.data.morningCustomerName}",
                                        ),
                                        const SizedBox(height: 10),
                                        _information(
                                          title: "In time",
                                          details: widget.data.inTime
                                              ?.toString()
                                              .hourlyDateFormat ??
                                              "-",
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        width: 1,
                                        color: grey.withOpacity(0.2),
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.sunny,
                                          color: yellow,
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        LangText("Morning schedule"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            width: 1,
                                            color: grey.withOpacity(0.2))),
                                    margin: const EdgeInsets.only(top: 18),
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, bottom: 8, top: 26),
                                    child: Column(
                                      children: [
                                        _information(
                                          title: "Schedule",
                                          details:
                                          "${widget.data.eveningDepName}",
                                        ),
                                        const SizedBox(height: 10),
                                        _information(
                                          title: "Customer",
                                          details:
                                          "${widget.data.eveningCustomerName}",
                                        ),
                                        const SizedBox(height: 10),
                                        _information(
                                          title: "Out time",
                                          details: widget.data.outTime
                                              ?.toString()
                                              .hourlyDateFormat ??
                                              "-",
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        width: 1,
                                        color: grey.withOpacity(0.2),
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.dark_mode,
                                          color: yellow,
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        LangText("Evening schedule"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Visibility(
                      //   visible: widget.data.status == PjpStatusType.missed,
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       border: Border(
                      //           top: BorderSide(
                      //               width: 1, color: grey.withOpacity(0.2))),
                      //     ),
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 16, vertical: 6),
                      //     child: Row(
                      //       children: [
                      //         Expanded(
                      //           child: GlobalWidgets().showInfoFlex(
                      //               message:
                      //               'Explain why you missed the schedule'),
                      //         ),
                      //         SizedBox(
                      //           width: 4.w,
                      //         ),
                      //         TextButton(
                      //           onPressed: () {},
                      //           style: TextButton.styleFrom(
                      //             foregroundColor: Colors.white,
                      //             backgroundColor: primaryRed,
                      //           ),
                      //           child: LangText("Explain"),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: red3)),
                hintText: "....."
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.only(top: 2.sp, right: 10),
              child: SingleCustomButton(
                color: primary,
                label: "Submit",
                onPressed: () {
                  _submit();
                },
                icon: null,
                shrinkWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }



  Widget _information({
    required String title,
    required String details,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: LangText(
            title,
            style: TextStyle(color: grey.withOpacity(0.7)),
          ),
        ),
        const SizedBox(width: 8),
        LangText(
          ":",
          style: TextStyle(color: grey.withOpacity(0.7)),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: LangText(details),
        )
      ],
    );
  }

  void _submit() async {
    try {
      final remarks = textEditingController.text.trim();
      if(remarks.isNotEmpty) {
        Alerts(context: context).floatingLoading();
        final response = await PjpPlanAPI().submitPjpPlanExpAPI(id: widget.data.id??0, text: remarks);
        if(response.status == ReturnedStatus.success) {
          navigatorKey.currentState?.pop();
          Alerts(context: context).customDialog(type: AlertType.success, message: "Explanation updated successfully", onTap1: () {
            navigatorKey.currentState?.pop();
            navigatorKey.currentState?.pop();
            ref.refresh(fullMonthPjpPlanProvider);
          });
        } else {
          navigatorKey.currentState?.pop();
          Alerts(context: context).customDialog(type: AlertType.error);
        }
      } else {
        Alerts(context: context).customDialog(type: AlertType.error, message: "Enter explanation");
      }
    } catch (e,t) {
      log(e.toString());
      log(t.toString());
    }
  }
}
