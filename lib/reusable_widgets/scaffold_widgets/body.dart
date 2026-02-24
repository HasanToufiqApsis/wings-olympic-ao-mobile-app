import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomBody extends StatelessWidget {
  const CustomBody({
    Key? key,
    required this.child,
    this.disableTopPadding = false,
  }) : super(key: key);
  final Widget child;
  final bool disableTopPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: disableTopPadding ? 0 : 2.h),
      child: SafeArea(child: child),
    );
  }
}
