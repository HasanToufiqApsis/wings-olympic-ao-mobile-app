import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/screens/approval/ui/single_leave.dart';
import 'package:wings_olympic_sr/screens/approval/ui/single_movement.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/leave_movement_management_model_tsm.dart';
import '../../../models/products_details_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../sale/ui/sku_case_piece_show_widget.dart';

class LeaveList extends ConsumerStatefulWidget {
  static const routeName = "/leave_list";
  const LeaveList({Key? key}) : super(key: key);

  @override
  ConsumerState<LeaveList> createState() => _LeaveListState();
}

class _LeaveListState extends ConsumerState<LeaveList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Leave & Movement Approval",
        showLeading: true,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(1, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 2.h, left: 5.w, right: 5.w, top: 5.h),
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
                                'Type',
                                style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: LangText(
                                  'SO Name',
                                  style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                                ),
                              ),
                            ),
                            Expanded(
                              child: LangText(
                                'Date Range',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                              ),
                            ),
                            Expanded(
                              child: LangText(
                                'Days',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                              ),
                            ),
                            Expanded(
                              child: LangText(
                                'Action',
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
                    child: Consumer(
                      builder: (context,ref,_) {
                        AsyncValue<List<LeaveMovementManagementModelForTSM>> asyncLeaveMovementList = ref.watch(getSrLeaveMovementListForTSMProvider);
                        return asyncLeaveMovementList.when(
                            data: (leaveMomentList){
                              if(leaveMomentList.isEmpty){
                                return Center(
                                  child: LangText(
                                      "Nothing to show"
                                  ),
                                );
                              }
                              return ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: leaveMomentList.length,
                                  itemBuilder: (context, index1) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: LangText(
                                              leaveMomentList[index1].rowType,
                                              style: TextStyle(fontSize: smallFontSize, color: grey),
                                              // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
                                            ),
                                          ),
                                          Expanded(
                                            child: LangText(
                                              leaveMomentList[index1].fieldForceName,
                                              style: TextStyle(fontSize: smallFontSize, color: grey),
                                              // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
                                            ),
                                          ),
                                          Expanded(
                                            child: LangText(
                                          "${uiDateFormat.format(leaveMomentList[index1].startDate)} - ${uiDateFormat.format(leaveMomentList[index1].endDate)}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: smallFontSize, color: grey),
                                              // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
                                            ),
                                          ),
                                          Expanded(
                                            child: LangText(
                                              leaveMomentList[index1].totalDays.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: smallFontSize, color: grey),
                                              // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
                                            ),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                if(leaveMomentList[index1].rowType == "Leave"){
                                                  Navigator.pushNamed(context, SingleLeave.routeName, arguments: leaveMomentList[index1]);
                                                }
                                                else{
                                                  Navigator.pushNamed(context, SingleMovement.routeName, arguments: leaveMomentList[index1]);
                                                }
                                              },
                                              child: LangText(
                                                'view',
                                                isNumber: true,
                                                textAlign: TextAlign.end,
                                                style: TextStyle(fontSize: smallFontSize, color: grey),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            },
                            error: (error, _)=> Container(),
                            loading: ()=> const Center(child: CircularProgressIndicator(),)
                        );

                      }
                    ),
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
            );
          }),
        ),
      ),
    );
  }
}
