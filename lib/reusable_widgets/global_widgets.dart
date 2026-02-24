import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants/constant_variables.dart';
import '../services/asset_download/asset_service.dart';
import '../services/sync_read_service.dart';
import 'language_textbox.dart';

class GlobalWidgets {

  String numberEnglishToBangla({required dynamic num, required String lang, bool isNumber = true}) {
    Map numData = {
      'বাংলা': {
        "1": '১',
        "2": '২',
        "3": '৩',
        "4": '৪',
        "5": '৫',
        "6": '৬',
        "7": '৭',
        "8": '৮',
        "9": '৯',
        "0": '০',
      },
      'en': {
        "1": '1',
        "2": '2',
        "3": '3',
        "4": '4',
        "5": '5',
        "6": '6',
        "7": '7',
        "8": '8',
        "9": '9',
        "0": '0',
      }
    };
    String str = num.toString();
    List<String> numList = str.split('.');
    try {
      if (isNumber && int.parse(numList[0]) >= 1) {
        str = int.parse(numList[0]).toString();
      } else {
        str = numList[0];
      }
    } catch (e) {
      str = numList[0];
    }

    String ans = '';
    int length = str.length;

    for (int i = 0; i < str.length; i++) {
      if (numData[lang].containsKey(str[i])) {
        ans += numData[lang][str[i]];
        if (isNumber) {
          if (length > 3) {
            if ((length - (i + 1)) % 3 == 0 && i != length - 1) {
              ans += ',';
            }
          }
        }
      } else {
        ans += str[i];
      }
    }

    if (numList.length > 1) {
      ans += '.';
      for (int i = 0; i < numList[1].length; i++) {
        if (numData[lang].containsKey(numList[1][i])) {
          ans += numData[lang][numList[1][i]];
        } else {
          ans += str[i];
        }
      }
    }

    return ans;
  }
  Widget customChip({required String text, Color? color, Color? textColor}) {
    return Container(
      padding: EdgeInsets.only(
        left: 1.5.w,
        right: 1.5.w,
        top: 0.3.h,
        bottom: 0.3.h,
      ),
      decoration: BoxDecoration(
          color: color ?? Colors.red,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.sp),
            topRight: Radius.circular(8.sp),
            bottomLeft: Radius.circular(8.sp),
            bottomRight: Radius.circular(8.sp),
          )),
      child: LangText(
        text,
        style: TextStyle(color: textColor ?? Colors.white, fontSize: 11.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget setHeadings(String text, {Color? color}) {
    return Align(
      child: LangText(
        text,
        style: TextStyle(color: color ?? darkGrey, fontSize: mediumFontSize, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget showInfo({required String message}) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.sp), border: Border.all(color: lightMediumGrey), color: Colors.white),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info,
              color: grey,
              size: normalFontSize,
            ),
            SizedBox(
              width: 1.w,
            ),
            Expanded(
              child: LangText(
                message,
                style: TextStyle(color: grey, fontSize: smallFontSize),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showInfoFlex({required String message}) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.info,
            color: grey,
            size: normalFontSize,
          ),
          SizedBox(
            width: 1.w,
          ),
          Expanded(
            child: LangText(
              message,
              style: TextStyle(color: grey.withOpacity(0.7), fontSize: smallFontSize),
            ),
          )
        ],
      ),
    );
  }

  Widget showInfoCenter({required String message}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(verificationRadius),
        border: Border.all(color: lightMediumGrey),
        color: Colors.white,
      ),
      alignment: Alignment.center,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.info,
              color: grey,
              size: mediumFontSize,
            ),
            SizedBox(
              width: 1.w,
            ),
            LangText(
              message,
              style: TextStyle(color: grey, fontSize: standardFontSize),
            )
          ],
        ),
      ),
    );
  }

  // PreferredSize customAppBar(
  //     {required String title,
  //       required BuildContext context,
  //       String? iconName,
  //       Color? leadingColor,
  //       bool keepLeadingIcon = false,
  //       bool keepNotificationIcon = false,
  //       bool keepDrawerIcon = false,
  //       double toolbarHeight = 70,
  //       VoidCallback? voidCallback,
  //       IconData? drawerIcon,
  //     }) {
  //   return PreferredSize(
  //     preferredSize: Size.fromHeight(toolbarHeight + 5),
  //     child: AppBar(
  //       automaticallyImplyLeading: false,
  //       toolbarHeight: toolbarHeight,
  //       // leadingWidth: 13.w,
  //       backgroundColor: primary,
  //       centerTitle: true,
  //       elevation: 0,
  //       title: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           iconName != null
  //               ? Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 1.w),
  //             child: AssetService(context).superImage(iconName,
  //                 folder: 'asset', version: SyncReadService().getAssetVersion('asset'), height: 4.h),
  //           )
  //               : Container(),
  //           LangText(
  //             title,
  //             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  //           ),
  //         ],
  //       ),
  //       leading: keepLeadingIcon
  //           ? Padding(
  //         padding:EdgeInsets.only(left: 3.w),
  //         child: Container(
  //           height: 7.h,
  //           decoration: BoxDecoration(
  //               color: greenOlive.withOpacity(0.1),
  //               shape: BoxShape.circle
  //           ),
  //           child: Center(
  //             child: IconButton(
  //               onPressed: voidCallback,
  //               icon: Icon(
  //                 Icons.arrow_back,
  //                 size: 24,
  //                 color: leadingColor ?? Colors.white,
  //               ),
  //             ),
  //           ),
  //         ),
  //       )
  //           : Container(),
  //       actions: [
  //         keepNotificationIcon
  //             ? IconButton(
  //           onPressed: () {},
  //           icon: const Icon(
  //             Icons.notifications,
  //             color: Colors.white,
  //           ),
  //         )
  //             : Container(),
  //         keepDrawerIcon
  //             ? Builder(builder: (context) {
  //           return IconButton(
  //             onPressed: () {
  //               Scaffold.of(context).openEndDrawer();
  //             },
  //             icon: Icon(
  //               drawerIcon ?? Icons.menu,
  //               color: Colors.white,
  //             ),
  //           );
  //         })
  //             : Container(),
  //       ],
  //     ),
  //   );
  // }
}
