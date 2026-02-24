import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../main.dart';
import '../../../models/general_id_slug_model.dart';
import '../../../models/leave_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/input_fields/dropdowns.dart';
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../controller/leave_controller.dart';
import 'create_leave_ui.dart';

class LeaveUI extends ConsumerStatefulWidget {
  const LeaveUI({Key? key}) : super(key: key);

  @override
  ConsumerState<LeaveUI> createState() => _LeaveUIState();
}

class _LeaveUIState extends ConsumerState<LeaveUI> {
  late LeaveController leaveController;
  TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    leaveController = LeaveController(context: context, ref: ref);
  }

  @override
  void dispose() {
    super.dispose();
    reasonController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<LeaveManagementModel> asyncLeaveModel = ref.watch(leaveDataProvider);
    return asyncLeaveModel.when(
        data: (leaveData) {
          return Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, CreateLeaveUI.routeName, arguments: leaveData);
              },
              label: LangText("Apply For Leave", style: const TextStyle(color: Colors.white),),
              backgroundColor: primary,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Column(
                children: [

                  SizedBox(
                    height: 2.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// sku list
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(5.sp), topLeft: Radius.circular(5.sp)),
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [primary, primaryBlue],
                              ),
                              color: Colors.grey[100]),
                          child: DefaultTextStyle(
                            style: TextStyle(fontSize: normalFontSize, color: Colors.white, fontWeight: FontWeight.bold),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: LangText(
                                      'Leave Type',
                                      style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                                    ),
                                  ),
                                  Expanded(
                                    child: LangText(
                                      'Balance',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                                    ),
                                  ),
                                  Expanded(
                                    child: LangText(
                                      'Total',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Container(
                          color: Colors.white,
                          child: ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: leaveData.leaveTypes.length,
                            itemBuilder: (context, index1) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: LangText(
                                        leaveData.leaveTypes[index1].type,
                                        style: TextStyle(fontSize: smallFontSize, color: grey),
                                        // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
                                      ),
                                    ),
                                    Expanded(
                                      child: LangText(
                                        ((int.tryParse(leaveData.leaveTypes[index1].leaveBalance??'0')??0)-leaveData.leaveTypes[index1].leaveEnjoyed).toString() ?? "N/A",
                                        isNumber: true,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(fontSize: smallFontSize, color: grey),
                                      ),
                                    ),
                                    Expanded(
                                      child: LangText(
                                        leaveData.leaveTypes[index1].leaveBalance ?? "N/A",
                                        isNumber: true,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(fontSize: smallFontSize, color: grey),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                            height: 2.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(5.sp), bottomLeft: Radius.circular(5.sp)),
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [primary, primaryBlue],
                                ),
                                color: Colors.grey[100]))
                      ],
                    ),
                  ),
                  leaveData.leaveData.isNotEmpty
                      ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(5.sp), topLeft: Radius.circular(5.sp)),
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [primary, primaryBlue],
                              ),
                              color: Colors.grey[100]),
                          child: DefaultTextStyle(
                            style: TextStyle(fontSize: normalFontSize, color: Colors.white, fontWeight: FontWeight.bold),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: LangText(
                                      'Leave Type',
                                      style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: LangText(
                                        'Days',
                                        style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: LangText(
                                      'Date Range',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                                    ),
                                  ),
                                  Expanded(
                                    child: LangText(
                                      'Status',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: leaveData.leaveData.length,
                              itemBuilder: (context, index1) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: LangText(
                                          leaveData.leaveData[index1].leaveType?.displayLabel ?? "N/A",
                                          style: TextStyle(fontSize: smallFontSize, color: grey),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: LangText(
                                            leaveData.leaveData[index1].totalDays.toString(),
                                            isNumber: true,
                                            textAlign: TextAlign.end,
                                            style: TextStyle(fontSize: smallFontSize, color: grey),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: LangText(
                                          "${leaveData.leaveData[index1].startDate.split("T").first} - ${leaveData.leaveData[index1].endDate.split("T").first}",
                                          textAlign: TextAlign.end,
                                          style: TextStyle(fontSize: smallFontSize, color: grey),
                                        ),
                                      ),
                                      Expanded(
                                        child: Builder(builder: (context) {
                                          return LangText(
                                            leaveController.statusCheck(leaveData.leaveData[index1].approveStatus ?? "pending"),
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize: smallFontSize,
                                              color: leaveController.setStatusColor(leaveData.leaveData[index1].approveStatus ?? "pending"),
                                            ),
                                          );
                                        }),
                                      )
                                    ],
                                  ),
                                );
                              }),
                        ),
                        Container(
                            height: 2.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(5.sp), bottomLeft: Radius.circular(5.sp)),
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [primary, primaryBlue],
                                ),
                                color: Colors.grey[100]))
                      ],
                    ),
                  )
                      : Column(
                    children: [
                      const SizedBox(height: 56),
                      Image.asset(
                        "assets/not_found.png",
                        height: 10.h,
                      ),
                      const SizedBox(height: 8),
                      LangText("No leave application available."),
                      SizedBox(
                        height: 2.h,
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
        error: (error, _) {
          return Center(
            child: LangText("Nothing to see"),
          );
        },
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ));
  }
}
