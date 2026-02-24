import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../constants/constant_variables.dart';
import '../constants/enum.dart';
import '../utils/day_event_utils.dart';
import 'language_textbox.dart';

class Alerts {
  final BuildContext context;

  Alerts({required this.context});

  void floatingLoading({String? message}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                decoration:
                    BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.sp)),
                height: 25.w,
                width: 10.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Center(
                      child: CircularProgressIndicator(
                      ),
                    ),
                    SizedBox(
                      height: 2.w,
                    ),
                    Padding(
                      padding: EdgeInsets.all(3.sp),
                      child: LangText(
                        message ?? "Loading",
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future? showModalWithWidget({
    required Widget child,
    bool dismissible = false,
    Color? backgroundColor,
    EdgeInsets? margin,
  }) {
    showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (BuildContext context) {
        return PopScope(
          canPop: dismissible,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: backgroundColor,
              insetPadding: margin ?? EdgeInsets.all(32),
              child: child,
            ),
          ),
        );
      },
    );
  }

  void customDialog({
    AlertType? type,
    String? message,
    String? fontFamily,
    String? description,
    String? button1,
    String? button2,
    bool twoButtons = false,
    VoidCallback? onTap1,
    VoidCallback? onTap2,
  }) {
    IconData iconData;
    String defaultMessage = "";
    Color color;

    if (type == AlertType.success) {
      iconData = Icons.check_circle;
      defaultMessage = "SUCCESS";
      color = Colors.green;
    } else if (type == AlertType.error) {
      iconData = Icons.cancel;
      defaultMessage = "ERROR";
      color = Colors.red;
    } else if (type == AlertType.warning) {
      iconData = Icons.warning;
      defaultMessage = "WARNING";
      color = Colors.yellow;
    } else if (type == AlertType.info) {
      iconData = Icons.info;
      defaultMessage = "INFO";
      color = Colors.blue;
    } else {
      iconData = Icons.ac_unit;
      defaultMessage = "";
      color = Colors.blue;
    }
    message = message ?? defaultMessage;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.sp),
                ),
                backgroundColor: Colors.transparent,
                child: Stack(
                  children: [
                    Positioned(
                      child: Container(
                        width: 40.h,
                        padding:
                            EdgeInsets.only(left: 1.5.h, top: 6.w, right: 1.5.h, bottom: 2.5.w),
                        margin: EdgeInsets.only(top: 5.6.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.sp),
                          border: Border.all(color: Colors.white, width: 1.5.sp),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              offset: const Offset(0, 10),
                              blurRadius: 20.sp,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            type != null
                                ? Center(
                                    child: Icon(
                                      iconData,
                                      color: color,
                                      size: 25.sp,
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: 2.w,
                            ),
                            message != null
                                ? LangText(
                                    message,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: fontFamily,
                                      color: primaryBlack,
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: 2.0.w,
                            ),
                            (description == null)
                                ? const SizedBox()
                                : Flexible(
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        Center(
                                          child: LangText(
                                            description,
                                            style: TextStyle(
                                              fontSize: 10.0.sp,
                                              color: Colors.black,
                                              fontFamily: fontFamily,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            SizedBox(
                              height: 32,
                            ),
                            (twoButtons == false)
                                ? SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    // height: 7.h,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primary,
                                          side: BorderSide(color: primary, width: 1.0.sp),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.sp), // <-- Radius
                                          ),
                                        ),
                                        onPressed: onTap1 ??
                                            () {
                                              Navigator.pop(context);
                                            },
                                        child: LangText(
                                          button1 ?? 'Ok',
                                          style: TextStyle(
                                            fontSize: 8.5.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: primary,
                                              side: BorderSide(color: primary, width: 1.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10), // <-- Radius
                                              ),
                                            ),
                                            onPressed: onTap1 ??
                                                () {
                                                  Navigator.pop(context);
                                                },
                                            child: LangText(
                                              button1 ?? 'Yes',
                                              style: TextStyle(
                                                fontSize: 8.5.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2.0.w,
                                        ),
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: primaryRed,
                                              side: BorderSide(color: primaryRed, width: 1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10), // <-- Radius
                                              ),
                                            ),
                                            onPressed: onTap2 ??
                                                () {
                                                  Navigator.pop(context);
                                                },
                                            child: LangText(
                                              button2 ?? 'No',
                                              style: TextStyle(
                                                fontSize: 8.5.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void goodMorningDialogue() {
    DayEvent dayEvent = DayEventUtils.getDayEvent();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return PopScope(
            canPop: false,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.sp),
                ),
                backgroundColor: Colors.transparent,
                child: Stack(
                  children: [
                    Positioned(
                      child: Container(
                        width: 40.h,
                        // padding: EdgeInsets.only(left: 1.5.h, top: 6.w, right: 1.5.h, bottom: 2.5.w),
                        padding: EdgeInsets.only(bottom: 2.5.w),
                        margin: EdgeInsets.only(top: 5.6.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.sp),
                          // border: Border.all(color: Colors.white, width: 1.5.sp),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              offset: const Offset(0, 10),
                              blurRadius: 20.sp,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.sp),
                              child: Container(
                                height: 160.0,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  color: Colors.lightBlueAccent.withOpacity(0.1),
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.elliptical(
                                      MediaQuery.of(context).size.width,
                                      100.0,
                                    ),
                                  ),
                                ),
                                child: Lottie.asset('assets/welcome.json'),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            LangText(
                              dayEvent == DayEvent.morning
                                  ? "Good Morning"
                                  : dayEvent == DayEvent.noon
                                      ? "Good Noon"
                                      : dayEvent == DayEvent.afternoon
                                          ? "Good Afternoon"
                                          : dayEvent == DayEvent.evening
                                              ? "Good Evening"
                                              : "Good Night",
                              style: TextStyle(
                                  fontSize: largeFontSize,
                                  fontWeight: FontWeight.w300,
                                  color: primary),
                            ),
                            LangText(
                              "Thank you for being with WINGS",
                              style: TextStyle(fontSize: smallFontSize),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primary,
                                    side: BorderSide(color: primary, width: 1.0.sp),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.sp), // <-- Radius
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: LangText(
                                    "Lets Start",
                                    style: TextStyle(
                                      fontSize: 8.5.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void dayCloserDialogue() {
    DayEvent dayEvent = DayEventUtils.getDayEvent();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.sp),
                ),
                backgroundColor: Colors.transparent,
                child: Stack(
                  children: [
                    Positioned(
                      child: Container(
                        width: 40.h,
                        // padding: EdgeInsets.only(left: 1.5.h, top: 6.w, right: 1.5.h, bottom: 2.5.w),
                        padding: EdgeInsets.only(bottom: 2.5.w),
                        margin: EdgeInsets.only(top: 5.6.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.sp),
                          // border: Border.all(color: Colors.white, width: 1.5.sp),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              offset: const Offset(0, 10),
                              blurRadius: 20.sp,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.sp),
                              child: Container(
                                height: 160.0,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  color: Colors.lightBlueAccent.withOpacity(0.1),
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.elliptical(
                                      MediaQuery.of(context).size.width,
                                      100.0,
                                    ),
                                  ),
                                ),
                                child: Lottie.asset('assets/welcome.json'),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            LangText(
                              dayEvent == DayEvent.morning
                                  ? "Good Morning"
                                  : dayEvent == DayEvent.noon
                                      ? "Good Noon"
                                      : dayEvent == DayEvent.afternoon
                                          ? "Good Afternoon"
                                          : dayEvent == DayEvent.evening
                                              ? "Good Evening"
                                              : "Good Night",
                              style: TextStyle(
                                  fontSize: largeFontSize,
                                  fontWeight: FontWeight.w300,
                                  color: primary),
                            ),
                            LangText(
                              "Thank you for being with WINGS",
                              style: TextStyle(fontSize: smallFontSize),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            SizedBox(
                              width: 100.w,
                              height: 7.h,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primary,
                                    side: BorderSide(color: primary, width: 1.0.sp),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.sp), // <-- Radius
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: LangText(
                                    "Good Bye",
                                    style: TextStyle(
                                      fontSize: 8.5.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void snackBar({required String massage, int duration = 3, bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: EdgeInsets.only(bottom: 40.h),
      content: LangText(
        massage,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: duration),
      behavior: SnackBarBehavior.floating,
      backgroundColor: isSuccess ? primary : Colors.red,
    ));
  }
}
