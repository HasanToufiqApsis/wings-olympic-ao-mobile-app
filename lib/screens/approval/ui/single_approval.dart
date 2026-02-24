import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/route_change_model_tsm.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../controller/aproval_controller.dart';

class SingleApproval extends ConsumerStatefulWidget {
  static const routeName = "/approval_view";
  const SingleApproval({required this.changeRouteTSMModel, Key? key}) : super(key: key);
  final ChangeRouteTSMModel changeRouteTSMModel;
  @override
  ConsumerState<SingleApproval> createState() => _SingleApprovalState();
}

class _SingleApprovalState extends ConsumerState<SingleApproval> {

  late ApprovalController approvalController;

  @override
  void initState() {
    super.initState();
    approvalController = ApprovalController(context: context, ref: ref);
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const  CustomAppBar(
        title: "Approval View",
        showLeading: true,
        centerTitle: true,

      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                            LangText('Date'),
                            LangText(uiDateFormat.format(widget.changeRouteTSMModel.effectiveStartDate))
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
                            LangText(widget.changeRouteTSMModel.fieldForceName)
                          ],
                        ),
                      ),
                    ),
                    Container(

                      decoration:const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LangText('Point'),
                            LangText(widget.changeRouteTSMModel.presentRoute)
                          ],
                        ),
                      ),
                    ),
                    Container(

                      decoration: BoxDecoration(
                        color:primary.withOpacity(0.3),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.sp), bottomRight: Radius.circular(5.sp)),

                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LangText('Section'),
                            LangText(widget.changeRouteTSMModel.sectionName)
                          ],
                        ),
                      ),
                    ),

                  ]
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 2.h, left: 5.w, right: 5.w, top: 5.h),
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
                                'Present Route',
                                textAlign: TextAlign.start,
                                style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                              ),
                            ),
                            Expanded(
                              child: LangText(
                                'Requested Route',
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
                        itemCount: 1,
                        itemBuilder: (context, index1) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Expanded(
                                  child: LangText(
                                    widget.changeRouteTSMModel.presentRoute,
                                    style: TextStyle(fontSize: smallFontSize, color: grey),
                                    // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
                                  ),
                                ),
                                Expanded(
                                  child: LangText(
                                    widget.changeRouteTSMModel.requestRoute,
                                    isNumber: true,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: smallFontSize, color: grey),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                  Column(
                    children: [
                      Container(
                        width: 100.w,
                        height: 4.h,
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(5.sp), bottomLeft: Radius.circular(5.sp)),
                          gradient: const LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [primary, primaryBlue],
                          ),
                        ),
                      ),
                    ],
                  ),



                ],
              ),
            ),

            if(widget.changeRouteTSMModel.status == 0)
            SubmitButtonGroup(
              twoButtons: true,
              button1Label: "Approve",
              button2Label: "Reject",
              onButton1Pressed: (){
                approvalController.submitOrRejectChangeRouteRequest(widget.changeRouteTSMModel, 1);
              },
              onButton2Pressed: (){
                approvalController.submitOrRejectChangeRouteRequest(widget.changeRouteTSMModel, 2);
              },
            )
          ],
        ),
      ),

    );
  }
}
