import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_keys.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../models/outlet_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/cameraScreen.dart';
import '../../../services/Image_service.dart';

class CoolerPurityScore extends StatefulWidget {
  const CoolerPurityScore({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);
  final Function(String) onSubmit;

  @override
  State<CoolerPurityScore> createState() => _CoolerPurityScoreState();
}

class _CoolerPurityScoreState extends State<CoolerPurityScore> {
  late TextEditingController purityScoreEditingController;
  late Alerts _alerts;

  @override
  void initState() {
    _alerts = Alerts(context: context);
    purityScoreEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    purityScoreEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3.h, left: 7.5.w, right: 7.5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Padding(
          //   padding: EdgeInsets.only(left: 40.w, bottom: 1.h),
          //   child: SizedBox(
          //     height: 30.sp,
          //     width: 30.sp,
          //     child: Image.asset(
          //       'assets/sell_out_of_selected_outlet_icon.png',
          //     ),
          //   ),
          // ),

          Icon(Icons.warning_amber_rounded, size: 56, color: yellow,),
          8.verticalSpacing,
          Center(
            child: LangText(
              'Need to input cooler Purity Score',
              style: const TextStyle(
                color: primaryRed,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'NotoSansBengali',
              ),
            ),
          ),
          SizedBox(height: 1.5.h),
          // NormalTextField(
          //   textEditingController: purityScoreEditingController,
          //   hintText: "10",
          //   inputType: TextInputType.number,
          // ),
          Consumer(builder: (context, ref, _) {
            String lang = ref.watch(languageProvider);
            String hint = "Purity score";
            if (lang != "en") {
              hint = "পিউরিটি স্কোর";
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: InputTextFields(
                textEditingController: purityScoreEditingController,
                hintText: hint,
                inputType: TextInputType.number,
                suffixIcon: Icons.percent_rounded,
                prefixIcon: const Icon(
                  Icons.kitchen,
                  color: primary,
                ),
                autofocus: true,
              ),
            );
          }),
          SizedBox(height: 1.5.h),
          SubmitButtonGroup(
            button1Icon: const Icon(
              Icons.check_rounded,
              color: Colors.white,
            ),
            button1Label: "Submit",
            onButton1Pressed: () {
              String score = purityScoreEditingController.text;
              if (score.isNotEmpty) {
                if (containsOnlyNumbers(score)) {
                  num scoreNumber = num.tryParse(score) ?? 0;
                  if (scoreNumber < 0 || scoreNumber > 100) {
                    _alerts.customDialog(
                      type: AlertType.error,
                      message: 'Purity Score must be between 0 and 100',
                    );
                  } else {
                    widget.onSubmit(score);
                  }
                } else {
                  _alerts.customDialog(
                    type: AlertType.error,
                    message: 'Purity Score must be a number',
                  );
                }
              } else {
                _alerts.customDialog(
                  type: AlertType.error,
                  message: 'Need to input cooler Purity Score',
                );
              }
            },
          )
        ],
      ),
    );
  }

  bool containsOnlyNumbers(String text) {
    RegExp regex = RegExp(r'^[0-9]+$');
    return regex.hasMatch(text);
  }
}
