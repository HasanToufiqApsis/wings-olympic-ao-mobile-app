import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constant_variables.dart';
import '../language_textbox.dart';

class NormalTextField extends StatelessWidget {
  const NormalTextField({
    Key? key,
    required this.textEditingController,
    this.hintText,
    this.inputType,
    this.label,
    this.enable = true,
    this.error = false,
  }) : super(key: key);
  final TextEditingController textEditingController;
  final String? hintText;
  final TextInputType? inputType;
  final String? label;
  final bool enable;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: LangText(
                label!,
                style: TextStyle(color: primaryBlack, fontSize: 9.sp, fontWeight: FontWeight.bold),
              ),
            ),
          InputTextFields(
            textEditingController: textEditingController,
            hintText: hintText,
            inputType: inputType,
            enable: enable,
            error: error,
          ),
        ],
      ),
    );
  }
}

class VerificationTextField extends StatelessWidget {
  const VerificationTextField({
    super.key,
    required this.textEditingController,
    this.hintText,
    this.obscureText = false,
    this.suffix,
    this.onTap,
    this.error = false,
  });

  final TextEditingController textEditingController;
  final String? hintText;
  final bool obscureText;
  final IconData? suffix;
  final Function()? onTap;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: InputTextFields(
        textEditingController: textEditingController,
        hintText: hintText,
        suffixIcon: suffix,
        onTap: onTap,
        obscureText: obscureText,
        error: error,
      ),
    );
  }
}

class InputTextFields extends StatelessWidget {
  const InputTextFields({
    super.key,
    this.textEditingController,
    this.hintText,
    this.initialValue,
    this.suffixIcon,
    this.maxLine,
    this.inputType,
    this.obscureText = false,
    this.onTap,
    this.enable = true,
    this.autofocus = false,
    this.prefixIcon,
    this.onChanged,
    this.error = false,
  });

  final TextEditingController? textEditingController;
  final String? hintText;
  final String? initialValue;
  final IconData? suffixIcon;
  final TextInputType? inputType;
  final int? maxLine;
  final VoidCallback? onTap;
  final Widget? prefixIcon;

  final bool obscureText;
  final bool enable;
  final bool autofocus;
  final Function(String)? onChanged;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(verificationRadius),
        border: Border.all(width: 1, color: error ? primaryRed : Colors.transparent),
      ),
      child: TextFormField(
        initialValue: initialValue,
        controller: textEditingController,
        keyboardType: inputType,
        maxLines: !obscureText ? maxLine : 1,
        obscureText: obscureText,
        inputFormatters: inputType == TextInputType.number || inputType == TextInputType.phone
            ? [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]*')),
                TextInputFormatter.withFunction(
                  (oldValue, newValue) => newValue.copyWith(
                    text: newValue.text.replaceAll('.', ','),
                  ),
                ),
              ]
            : [],
        enabled: enable,
        autofocus: autofocus,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xffD1D5DB),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(verificationRadius),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xffD1D5DB),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(verificationRadius),
          ),
          focusColor: Colors.black,
          fillColor: enable ? Colors.white : lightMediumGrey2,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 9.sp),
          isDense: true,
          suffixIcon: suffixIcon != null
              ? GestureDetector(
                  onTap: onTap ?? () {},
                  child: Icon(suffixIcon),
                )
              : null,
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}
