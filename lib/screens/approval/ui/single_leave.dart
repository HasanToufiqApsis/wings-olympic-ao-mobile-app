

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/leave_movement_management_model_tsm.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../controller/aproval_controller.dart';

class SingleLeave extends ConsumerStatefulWidget {
  static const routeName = "/leave_view";
  const SingleLeave({required this.leaveMovementManagementModelForTSM, Key? key}) : super(key: key);
  final LeaveMovementManagementModelForTSM leaveMovementManagementModelForTSM;
  @override
  ConsumerState<SingleLeave> createState() => _SingleLeaveState();
}

class _SingleLeaveState extends ConsumerState<SingleLeave> {

  late ApprovalController approvalController;

  @override
  void initState() {
    super.initState();
    approvalController = ApprovalController(context: context, ref: ref);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const CustomAppBar(
        title: "Leave Details",
        showLeading: true,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children:[
            Padding(
              padding: EdgeInsets.only(bottom: 2.h, left: 5.w, right: 5.w, top: 5.h),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),

                ),
                child: Column(
                  children: [
                    Container(

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(5.sp), topLeft: Radius.circular(5.sp),),

                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LangText('Type'),
                            LangText('Leave')
                          ],
                        ),
                      ),
                    ),
                    Container(

                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LangText('SO Name'),
                            LangText(widget.leaveMovementManagementModelForTSM.fieldForceName)
                          ],
                        ),
                      ),
                    ),
                    Container(

                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LangText('Leave Type'),
                            LangText(widget.leaveMovementManagementModelForTSM.type)
                          ],
                        ),
                      ),
                    ),
                    Container(

                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LangText("Date Range"),
                            LangText("${maintenanceDateFormat.format(widget.leaveMovementManagementModelForTSM.startDate)} - ${maintenanceDateFormat.format(widget.leaveMovementManagementModelForTSM.endDate)}",)
                          ],
                        ),
                      ),
                    ),
                    Container(

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(5.sp), topLeft: Radius.circular(5.sp),),

                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LangText('Days'),
                            LangText(widget.leaveMovementManagementModelForTSM.totalDays.toString(), isNumber: true,)
                          ],
                        ),
                      ),
                    ),
                    Container(

                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.3),
                        borderRadius: BorderRadius.only(topRight: Radius.circular(5.sp), topLeft: Radius.circular(5.sp),),

                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: LangText('Reason')),
                            Expanded(child: LangText(widget.leaveMovementManagementModelForTSM.reason, textAlign: TextAlign.end,))
                          ],
                        ),
                      ),
                    ),
                    Container(

                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.3),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.sp), bottomRight: Radius.circular(5.sp),),

                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LangText('Status'),
                            LangText(
                              approvalController.statusCheck(widget.leaveMovementManagementModelForTSM.status),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:  approvalController.setStatusColor(widget.leaveMovementManagementModelForTSM.status)
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                  ]
                ),
              ),
            ),

            if(widget.leaveMovementManagementModelForTSM.status == 0)
            SubmitButtonGroup(
              twoButtons: true,
              button1Label: "Approve",
              button2Label: "Reject",
              onButton1Pressed: (){
                approvalController.submitOrRejectLeaveMovementRequest(widget.leaveMovementManagementModelForTSM, "leave", 1);
              },
              onButton2Pressed: (){
                approvalController.submitOrRejectLeaveMovementRequest(widget.leaveMovementManagementModelForTSM, "leave", 2);
              },
            )

          ],
        ),
      ),

    );
  }
}
