import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../main.dart';
import '../../../models/leave_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/input_fields/dropdowns.dart';
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../leave_management/controller/leave_controller.dart';

class CreateMovementUI extends ConsumerStatefulWidget {
  final LeaveManagementData? data;
  const CreateMovementUI({Key? key, this.data}) : super(key: key);
  static const routeName = "create_movement_ui";
  @override
  ConsumerState<CreateMovementUI> createState() => _CreateMovementUIState();
}

class _CreateMovementUIState extends ConsumerState<CreateMovementUI> {
  LeaveManagementData? updateModel;
  late LeaveController leaveController;
  TextEditingController reasonController = TextEditingController();
  TextEditingController tadaController = TextEditingController();
  @override
  void initState() {
    super.initState();
    leaveController = LeaveController(context: context, ref: ref);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(widget.data!=null) {
        updateModel= widget.data;

        ref.read(updatedMovementProvider.notifier).state = updateModel;
        reasonController.text = updateModel!.reason;
        LeaveManagementTypes? selectedType = ref.watch(selectedMovementTypeProvider);

        ref.read(selectedMovementDateRangeProvider.notifier).state = DateTime.parse(updateModel!.startDate);
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
    reasonController.dispose();
    tadaController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: updateModel==null? "Create Movement" : "Update Movement",
        showLeading: true,
        centerTitle: true,
        onLeadingIconPressed: (){
          leaveController.refreshState();
          navigatorKey.currentState?.pop();
        },
      ),
      body: Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
        AsyncValue<LeaveManagementModel> asyncLeaveModel = ref.watch(movementDataProvider);
        LeaveManagementData? updateModel = ref.watch(updatedMovementProvider);
        return asyncLeaveModel.when(
            data: (leaveData){
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                if(widget.data!=null) {
                  leaveData.leaveTypes.forEach((e) {
                    if(e.id == updateModel!.leaveTypeId) {
                      ref.read(selectedMovementTypeProvider.notifier).state = e;
                    }
                  });
                }
              });

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Visibility(
                    //   visible: updateModel!=null,
                    //   child: Column(
                    //     children: [
                    //       leaveController.heading("Updatable Movement"),
                    //       Container(
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(5.sp),
                    //           color: Colors.white,
                    //         ),
                    //         margin: EdgeInsets.only(left: 10.sp, right: 10.sp, bottom: 10.sp, top: 5.sp),
                    //         child: Padding(
                    //           padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.5.h),
                    //           child: Column(
                    //             children: [
                    //               Row(
                    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                 children: [
                    //                   Expanded(
                    //                     child: LangText(
                    //                       updateModel?.type ?? "",
                    //                       style: TextStyle(fontSize: smallFontSize, color: grey),
                    //                       // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
                    //                     ),
                    //                   ),
                    //                   Expanded(
                    //                     child: Center(
                    //                       child: LangText(
                    //                         updateModel?.totalDays.toString() ?? "",
                    //                         isNumber: true,
                    //                         textAlign: TextAlign.end,
                    //                         style: TextStyle(fontSize: smallFontSize, color: grey),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Expanded(
                    //                     child: Center(
                    //                       child: LangText(
                    //                         updateModel?.tada == null? "N/A": updateModel?.tada.toString()??"",
                    //                         isNumber: true,
                    //                         textAlign: TextAlign.end,
                    //                         style: TextStyle(fontSize: smallFontSize, color: grey),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Expanded(
                    //                     child: LangText(
                    //                       updateModel?.startDate ?? "",
                    //                       textAlign: TextAlign.end,
                    //                       style: TextStyle(fontSize: smallerFontSize, color: grey),
                    //                     ),
                    //                   ),
                    //                   Expanded(
                    //                     child: Align(
                    //                       alignment: Alignment.centerRight,
                    //                       child: InkWell(
                    //                         onTap: () {
                    //                           // navigatorKey.currentState?.pushNamed(MovementEditUi.routeName, arguments: leaveData.leaveData[index1]);
                    //                           // ref.read(updatedMovementProvider.notifier).state = leaveData.leaveData[index1];
                    //                           ref.read(updatedMovementProvider.notifier).state = null;
                    //                         },
                    //                         child: const Icon(Icons.close, color: Colors.orange,),
                    //                       ),
                    //                     ),
                    //                   )
                    //                 ],
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    leaveController.heading("Movement Type"),
                    Consumer(
                        builder: (context,ref,_) {
                          LeaveManagementTypes? selectedType = ref.watch(selectedMovementTypeProvider);
                          return CustomSingleDropdown<LeaveManagementTypes>(
                            items: leaveData.leaveTypes.map<DropdownMenuItem<LeaveManagementTypes>>((e) => DropdownMenuItem(value: e, child: Text(e.type))).toList(),
                            onChanged: (LeaveManagementTypes? val) {
                              ref.read(selectedMovementTypeProvider.notifier).state = val;
                            },
                            hintText: "Movement Type",
                            value: selectedType,
                          );
                        }
                    ),
                    leaveController.heading("Date"),
                    InkWell(
                      onTap: ()async{
                        await leaveController.movementDateRange();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 9.sp),
                          width: double.infinity,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(verificationRadius), color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Consumer(
                                  builder: (context,ref,_) {
                                    DateTime? pickedRange = ref.watch(selectedMovementDateRangeProvider);
                                    String dateRange = "Date";
                                    Color color = lightMediumGrey;
                                    double size = 9.sp;
                                    if(pickedRange != null){
                                      dateRange = uiDateFormat.format(pickedRange);
                                      color = Colors.black;
                                      size = 11.sp;
                                      return Text(
                                        dateRange,
                                        style: TextStyle(color: color, fontSize: size),
                                      );
                                    }
                                    return LangText(
                                      dateRange,
                                      style: TextStyle(color: color, fontSize: size),
                                    );
                                  }
                              ),
                              Icon(
                                Icons.calendar_month_outlined,
                                color: lightMediumGrey,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    leaveController.heading("Day"),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 9.sp),
                          width: double.infinity,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(verificationRadius), color: Colors.grey),
                          child: Consumer(
                              builder: (context,ref,_) {
                                DateTime? pickedRange = ref.watch(selectedMovementDateRangeProvider);
                                String rangeStr = "0";
                                if(pickedRange != null){
                                  rangeStr = "1";
                                }
                                return LangText(
                                  rangeStr,
                                  isNumber: true,
                                );
                              }
                          )
                      ),
                    ),
                    // leaveController.heading("TA/DA"),
                    // Consumer(
                    //   builder: (context,ref,_) {
                    //     String lang = ref.watch(languageProvider);
                    //     String hint = "টিএ/ডিএ";
                    //     if(lang == "en"){
                    //       hint = "TA/DA";
                    //     }
                    //     return NormalTextField(
                    //       textEditingController: tadaController,
                    //       hintText: hint,
                    //       inputType: TextInputType.number,
                    //     );
                    //   }
                    // ),
                    leaveController.heading("Reason"),
                    Consumer(
                        builder: (context,ref,_) {
                          String lang = ref.watch(languageProvider);
                          String hint = "Reason";
                          if(lang != "en"){
                            hint = "কারন লিখুন";
                          }
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                            child: InputTextFields(
                              textEditingController: reasonController,
                              hintText: hint,
                              inputType: TextInputType.text,
                              maxLine: 5,
                            ),
                          );
                        }
                    ),
                    // leaveController.heading("Attachment"),
                    // SizedBox(
                    //   width: 100.w,
                    //   child: CustomImagePickerButton(
                    //     type: CapturedImageType.leaveManagementImage,
                    //     onPressed: () {
                    //       leaveController.captureMovementImage();
                    //     },
                    //   ),
                    // ),
                    SizedBox(height: 3.h,),
                    SubmitButtonGroup(
                      button1Label: updateModel!=null?"Update":null,
                      twoButtons: true,
                      onButton1Pressed: (){
                        if(updateModel==null) {
                          leaveController.submitMovementToServer(reasonController.text.trim(), tadaController.text.trim());
                        } else {
                          leaveController.updateMovementToServer(reasonController.text.trim(), tadaController.text.trim(), updateModel!);
                        }
                      },
                      onButton2Pressed: (){
                        navigatorKey.currentState?.pop();
                      },
                    ),
                    SizedBox(height: 2.h,),
                  ],
                ),
              );
            },
            error: (error, _){
              return Center(
                child: LangText("Nothing to see"),
              );
            },
            loading: ()=> const Center(child: CircularProgressIndicator(),)
        );
      },),
    );
  }

}
