import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../sale/controller/sale_controller.dart';
import '../memo_controller/memo_controller.dart';


class MemoEditDialogUI extends StatelessWidget {
  const MemoEditDialogUI({required this.salesController,Key? key}) : super(key: key);
  final SaleController salesController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 3.w, right: 3.w, bottom: 2.h, top: 2.h),
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 1.h,
            ),
            GlobalWidgets()
                .setHeadings('Please specify the reason of editing the sales'),
            SizedBox(
              height: 2.h,
            ),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: LangText(
            //     'Reason',
            //     style: TextStyle(color: darkGrey),
            //   ),
            // ),
            SizedBox(
              height: 1.h,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.sp),
                border: Border.all(color: grey),
                color: Colors.white,
              ),
              child: Consumer(builder: (context, ref, _) {
                String? dropdownSelected = ref.watch(selectedReasonsProvider);

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Center(
                    child: DropdownButton<String>(
                      hint: LangText(
                        'Select a reason',
                        style: TextStyle(color: Colors.grey, fontSize:smallFontSize),
                      ),
                      iconDisabledColor: Colors.transparent,
                      focusColor: Theme.of(context).primaryColor,
                      isExpanded: true,
                      value: dropdownSelected,
                      iconSize: 15.sp,
                      items: MemoController(context: context, ref: ref).reasonList.map((item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: LangText(
                            item,
                            style: TextStyle(color: darkGrey),
                          ),
                        );
                      }).toList(),
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                      onChanged: (val) {
                        ref.read(selectedReasonsProvider.state).state = val;
                      },
                    ),
                  ),
                );
              }),
            ),
            SizedBox(
              height: 2.h,
            ),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: LangText(
            //     'Remarks',
            //     style: TextStyle(color: darkGrey),
            //   ),
            // ),
            // SizedBox(
            //   height: 1.h,
            // ),
            // TextFormField(
            //   keyboardType: TextInputType.multiline,
            //   maxLines: 5,
            //   decoration: InputDecoration(
            //     focusedBorder: OutlineInputBorder(
            //         borderSide: BorderSide(
            //       color: blue,
            //     )),
            //     labelStyle: TextStyle(color: blue),
            //     enabledBorder: OutlineInputBorder(
            //       borderSide: BorderSide(color: blue),
            //     ),
            //     border: OutlineInputBorder(borderSide: BorderSide(color: blue)),
            //     isDense: true,
            //     hintStyle: TextStyle(fontSize: 10.sp, color: darkGrey),
            //   ),
            // ),
            // SizedBox(
            //   height: 3.h,
            // ),
            // Center(
            //   child: Container(
            //     width: 100.w,
            //     height: 5.h,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(5.sp),
            //       gradient: LinearGradient(
            //         begin: Alignment.topCenter,
            //         end: Alignment.bottomCenter,
            //         colors: [lightGreen, darkGreen],
            //       ),
            //     ),
            //     child: ElevatedButton(
            //         onPressed: () {
            //           Navigator.pop(context);
            //         },
            //         style: ElevatedButton.styleFrom(
            //           primary: Colors.transparent,
            //           elevation: 0,
            //         ),
            //         child: SizedBox(
            //           width: 100.w,
            //           height: 5.h,
            //           child: Center(
            //             child: Center(
            //               child: LangText(
            //                 'Submit',
            //                 style:
            //                     TextStyle(color: Colors.white, fontSize: 12.sp),
            //               ),
            //             ),
            //           ),
            //         )),
            //   ),
            // ),
            SizedBox(
              height: 1.h,
            ),
            // Center(
            //   child: Container(
            //     width: 100.w,
            //     height: 5.h,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(5.sp),
            //       gradient: LinearGradient(
            //         begin: Alignment.topCenter,
            //         end: Alignment.bottomCenter,
            //         colors: [superLightGrey, lightMediumGrey],
            //       ),
            //     ),
            //     child: ElevatedButton(
            //         onPressed: () {
            //           Navigator.pop(context);
            //         },
            //         style: ElevatedButton.styleFrom(
            //           primary: Colors.transparent,
            //           elevation: 0,
            //         ),
            //         child: SizedBox(
            //           width: 100.w,
            //           height: 5.h,
            //           child: Center(
            //             child: LangText(
            //               'Cancel',
            //               style: TextStyle(color: grey, fontSize: 12.sp),
            //             ),
            //           ),
            //         )),
            //   ),
            // )
            SizedBox(
              height: 5.h,
              child: SubmitButtonGroup(
                twoButtons: true,
                button1Label: "Cancel",
                button2Label: "Save",
                button1Color: primaryBlue,
                button2Color: darkGreen,
                button1Icon: Icon(Icons.print),
                button2Icon: Icon(Icons.edit),
                layout: ButtonLayout.horizontal,
                onButton1Pressed: (){

                },
                onButton2Pressed: (){

                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
