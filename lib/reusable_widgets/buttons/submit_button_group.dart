import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constant_variables.dart';
import '../../constants/enum.dart';
import '../../main.dart';
import '../language_textbox.dart';

class SubmitButtonGroup extends StatelessWidget {
  const SubmitButtonGroup({
    Key? key,
    this.twoButtons = false,
    this.button1Label,
    this.button2Label,
    this.button1Color = primary,
    this.button2Color = primaryRed,
    this.onButton1Pressed,
    this.onButton2Pressed,
    this.button1Icon,
    this.button2Icon,
    this.layout = ButtonLayout.vertical,
  }) : super(key: key);
  final bool twoButtons;
  final String? button1Label;
  final String? button2Label;
  final Color? button1Color;
  final Color? button2Color;
  final VoidCallback? onButton1Pressed;
  final VoidCallback? onButton2Pressed;
  final Widget? button1Icon;
  final Widget? button2Icon;
  final ButtonLayout layout;

  @override
  Widget build(BuildContext context) {
    //button 1
    Widget button1 = SingleCustomButton(
      color: button1Color ?? primary,
      label: button1Label ?? "Save",
      onPressed: onButton1Pressed ??
          () {
            navigatorKey.currentState!.pop();
          },
      icon: button1Icon,
    );

    Widget button2 = SingleCustomButton(
      color: button2Color ?? primaryRed,
      label: button2Label ?? "Cancel",
      onPressed: onButton2Pressed ??
          () {
            navigatorKey.currentState!.pop();
          },
      icon: button2Icon,
    );

    return layout == ButtonLayout.vertical
        ? Column(
            children: [
              //button 1
              button1,
              //button 2
              if (twoButtons) button2
            ],
          )
        : Row(
            children: [
              //button 1
              Expanded(child: button1),
              //button 2
              if (twoButtons) Expanded(child: button2)
            ],
          );
  }
}

class SingleCustomButton extends StatelessWidget {
  const SingleCustomButton({
    super.key,
    required this.color,
    required this.label,
    required this.onPressed,
    required this.icon,
    this.borderColor,
    this.borderRadius,
    this.textColor,
    this.shrinkWrap = false,
    this.smallSize = false,
    this.maxWidth = true,
  });
  final Color color;
  final String label;
  final VoidCallback onPressed;
  final Widget? icon;
  final Color? borderColor;
  final double? borderRadius;
  final Color? textColor;
  final bool shrinkWrap;
  final bool smallSize;
  final bool maxWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: shrinkWrap == true ? 0 : 10.sp, vertical: 5.sp),
      child: SizedBox(
        width: shrinkWrap == true ? null : double.infinity,
        height: 48,
        child: TextButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            side: BorderSide(
              color: borderColor ?? primaryGrey,
              width: 1.5.sp,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? verificationRadius,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: maxWidth ? MainAxisSize.max : MainAxisSize.min,
            children: [
              if (icon != null)
                Padding(
                  padding: EdgeInsets.only(right: 5.sp),
                  child: icon,
                ),
              LangText(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: normalFontSize,
                  color: textColor ?? Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
