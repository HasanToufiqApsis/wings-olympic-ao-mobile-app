import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/constant_variables.dart';

import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../controller/settings_controller.dart';
import '../model/edit_reason_model.dart';

class SaleResetDialogUI extends ConsumerStatefulWidget {
  const SaleResetDialogUI({required this.salesController, super.key});
  final SettingsController salesController;

  @override
  ConsumerState<SaleResetDialogUI> createState() => _SaleResetDialogUIState();
}

class _SaleResetDialogUIState extends ConsumerState<SaleResetDialogUI> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 3.w, right: 3.w, bottom: 2.h, top: 2.h),
      child: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LangText(
                    "Reason",
                    style: TextStyle(color: black900, fontWeight: FontWeight.bold, fontSize: 10.sp),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.clear, color: grey500, size: 15.sp),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Align(
                alignment: Alignment.centerLeft,
                child: LangText(
                  "Please define why do you want to sale again",
                  style: TextStyle(color: grey500, fontSize: 10.sp),
                ),
              ),
              SizedBox(height: 2.h),
              Align(
                alignment: Alignment.centerLeft,
                child: LangText('Select reason', style: TextStyle(color: black900)),
              ),
              SizedBox(height: 1.h),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.sp),
                  border: Border.all(color: grey300),
                  color: grey50,
                ),
                child: Consumer(
                  builder: (context, ref, _) {
                    String? dropdownSelected = ref.watch(selectedReasonsProvider);
                    AsyncValue<List<EditReasonModel>> asyncReasonList = ref.watch(
                      memoEditReasonsProvider,
                    );
                    return asyncReasonList.when(
                      data: (reasonList) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: Center(
                            child: DropdownButton<String>(
                              borderRadius: BorderRadius.circular(5.sp),
                              hint: LangText(
                                'Select a reason',
                                style: TextStyle(color: grey500, fontSize: smallFontSize),
                              ),
                              iconDisabledColor: Colors.transparent,
                              focusColor: Theme.of(context).primaryColor,
                              isExpanded: true,
                              value: dropdownSelected,
                              iconSize: 15.sp,
                              items: reasonList.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item.slug,
                                  child: LangText(item.slug, style: TextStyle(color: grey500)),
                                );
                              }).toList(),
                              style: const TextStyle(color: Colors.black),
                              underline: Container(height: 0, color: Colors.transparent),
                              onChanged: (val) {
                                ref.read(selectedReasonsProvider.notifier).state = val;
                              },
                            ),
                          ),
                        );
                      },
                      error: (e, s) {
                        return Container();
                      },
                      loading: () {
                        return Container();
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 2.h),
              Align(
                alignment: Alignment.centerLeft,
                child: LangText('Comment', style: TextStyle(color: black900)),
              ),
              SizedBox(height: 1.h),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  String? commentValue = ref.watch(editReasonRemarkProvider);
                  return TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.sp),
                        borderSide: BorderSide(color: grey300),
                      ),
                      labelStyle: TextStyle(color: blue),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.sp),
                        borderSide: BorderSide(color: grey300),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: grey300),
                        borderRadius: BorderRadius.circular(5.sp),
                      ),
                      isDense: true,
                      hintStyle: TextStyle(fontSize: 10.sp, color: grey500),
                      hintText: "Write text here ...",
                    ),
                    onChanged: (value) {
                      ref.read(editReasonRemarkProvider.notifier).state = value;
                    },
                  );
                },
              ),
              SizedBox(height: 2.h),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SubmitButtonGroup(
                          button1Label: "Start sale again",
                          button1Color: darkGreen,
                          onButton1Pressed: () {
                            String? dropdownSelected = ref.read(selectedReasonsProvider);
                            if(dropdownSelected != null) {
                              Navigator.pop(context);
                              widget.salesController.startSaleAgain();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
