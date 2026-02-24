import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/leave_movement_management_model_tsm.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../controller/aproval_controller.dart';

class SingleMovement extends ConsumerStatefulWidget {
  static const routeName = "/movement_view";
  const SingleMovement({Key? key, required this.leaveMovementManagementModelForTSM}) : super(key: key);
  final LeaveMovementManagementModelForTSM leaveMovementManagementModelForTSM;
  @override
  ConsumerState<SingleMovement> createState() => _SingleMovementState();
}

class _SingleMovementState extends ConsumerState<SingleMovement> {

  late ApprovalController approvalController;
  late TextEditingController tadaEditingController;
  @override
  void initState() {
    super.initState();
    approvalController = ApprovalController(context: context, ref: ref);
    tadaEditingController = TextEditingController(text: widget.leaveMovementManagementModelForTSM.tada == null? null :  widget.leaveMovementManagementModelForTSM.tada.toString());
  }


  @override
  Widget build(BuildContext context) {
    print(widget.leaveMovementManagementModelForTSM.tada);
    return  Scaffold(
      appBar: const CustomAppBar(
        title: "Movement Details",
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
                              LangText('Movement Type'),
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
                              LangText("Date"),
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
                          color: Colors.white,

                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: LangText('TA/DA')),
                              Expanded(
                                child: TextFormField(
                                  controller: tadaEditingController,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]*')),
                                    TextInputFormatter.withFunction(
                                          (oldValue, newValue) => newValue.copyWith(
                                        text: newValue.text.replaceAll('.', ','),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              // Expanded(
                              //     child: Align(
                              //       alignment: Alignment.centerRight,
                              //         child: LangText(widget.leaveMovementManagementModelForTSM.tada.toString())
                              //     )
                              // )
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
                // if(tadaEditingController.text.isNotEmpty ){
                //   // if(int.parse(tadaEditingController.text) > 0){
                //   //   approvalController.submitOrRejectLeaveMovementRequest(widget.leaveMovementManagementModelForTSM, "movement", 1, tadaEditingController.text);
                //   // }
                //
                // }
                approvalController.submitOrRejectLeaveMovementRequest(widget.leaveMovementManagementModelForTSM, "movement", 1, tadaEditingController.text);

              },
              onButton2Pressed: (){
                approvalController.submitOrRejectLeaveMovementRequest(widget.leaveMovementManagementModelForTSM, "movement", 2, tadaEditingController.text);
              },
            )

          ],
        ),
      )

    );
  }
}
