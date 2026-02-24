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

class CreateLeaveUI extends ConsumerStatefulWidget {
  final LeaveManagementModel leaveData;
  const CreateLeaveUI({Key? key, required this.leaveData}) : super(key: key);
  static const routeName = "create_leave_ui";
  @override
  ConsumerState<CreateLeaveUI> createState() => _CreateLeaveUIState();
}

class _CreateLeaveUIState extends ConsumerState<CreateLeaveUI> {
  LeaveManagementModel? updateModel;
  late ScrollController _scrollController;
  late LeaveController leaveController;
  TextEditingController reasonController = TextEditingController();
  TextEditingController fromAddressController = TextEditingController();
  TextEditingController toAddressController = TextEditingController();
  TextEditingController contractPersonPhoneController = TextEditingController();
  TextEditingController contractPersonNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    leaveController = LeaveController(context: context, ref: ref);
    _scrollController = ScrollController();

  }

  @override
  void dispose() {
    super.dispose();
    reasonController.dispose();
    // tadaController.dispose();
    _scrollController.dispose();
    fromAddressController.dispose();
    toAddressController.dispose();
    contractPersonPhoneController.dispose();
    contractPersonNameController.dispose();
  }

  bool _updated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: updateModel==null? "Apply For Leave" : "Update Leave",
        showLeading: true,
        centerTitle: true,
        onLeadingIconPressed: (){
          leaveController.refreshState();
          navigatorKey.currentState?.pop();
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            leaveController.heading("Leave Type"),
            Consumer(builder: (context, ref, _) {
              LeaveManagementTypes? selectedType = ref.watch(selectedLeaveTypeProvider);
              return CustomSingleDropdown<LeaveManagementTypes>(
                items: widget.leaveData.leaveTypes.map<DropdownMenuItem<LeaveManagementTypes>>((e) => DropdownMenuItem(value: e, child: Text(e.type))).toList(),
                onChanged: (LeaveManagementTypes? val) {
                  ref.read(selectedLeaveTypeProvider.notifier).state = val;
                },
                hintText: "Select leave Type",
                value: selectedType,
              );
            }),
            leaveController.heading("Date Range"),
            InkWell(
              onTap: () async {
                await leaveController.leaveDateRange();
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
                      Consumer(builder: (context, ref, _) {
                        DateTimeRange? pickedRange = ref.watch(selectedLeaveDateRangeProvider);
                        String dateRange = "To-Form";
                        Color color = lightMediumGrey;
                        double size = 9.sp;
                        if (pickedRange != null) {
                          dateRange = "${uiDateFormat.format(pickedRange.start)} - ${uiDateFormat.format(pickedRange.end)}";
                          color = Colors.black;
                          size = 11.sp;
                        }
                        return LangText(
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
            leaveController.heading("Number of days"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 9.sp),
                  width: double.infinity,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(verificationRadius), color: Colors.grey),
                  child: Consumer(builder: (context, ref, _) {
                    DateTimeRange? pickedRange = ref.watch(selectedLeaveDateRangeProvider);
                    String rangeStr = "0";
                    if (pickedRange != null) {
                      rangeStr = (pickedRange.end.difference(pickedRange.start).inDays + 1).toString();
                    }
                    return LangText(
                      rangeStr,
                      isNumber: true,
                    );
                  })),
            ),
            leaveController.heading("Reason"),
            Consumer(builder: (context, ref, _) {
              String lang = ref.watch(languageProvider);
              String hint = "Reason";
              if (lang != "en") {
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
            }),
            SizedBox(
              height: 3.h,
            ),
            SubmitButtonGroup(
              twoButtons: true,
              onButton1Pressed: () {
                leaveController.submitLeaveToServer(reasonController.text.trim());
              },
              onButton2Pressed: () {
                navigatorKey.currentState?.pop();
              },
            ),
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
                      itemCount: widget.leaveData.leaveTypes.length,
                      itemBuilder: (context, index1) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: LangText(
                                  widget.leaveData.leaveTypes[index1].type,
                                  style: TextStyle(fontSize: smallFontSize, color: grey),
                                  // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
                                ),
                              ),
                              Expanded(
                                child: LangText(
                                  ((int.tryParse(widget.leaveData.leaveTypes[index1].leaveBalance??'0')??0)-widget.leaveData.leaveTypes[index1].leaveEnjoyed).toString() ?? "N/A",
                                  isNumber: true,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(fontSize: smallFontSize, color: grey),
                                ),
                              ),
                              Expanded(
                                child: LangText(
                                  widget.leaveData.leaveTypes[index1].leaveBalance ?? "N/A",
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
            SizedBox(
              height: 2.h,
            ),
          ],
        ),
      ),
    );
  }

}
