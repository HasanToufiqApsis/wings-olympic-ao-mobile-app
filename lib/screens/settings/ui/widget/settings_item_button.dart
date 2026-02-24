import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../reusable_widgets/language_textbox.dart';

class SettingsItemButton extends StatelessWidget {
  final Function()? onTap;
  final Widget icon;
  final String title;

  const SettingsItemButton({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      child: SizedBox(
        width: 43.w,
        height: 15.h,
        child: ElevatedButtonTheme(
          data: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[100],
            ),
          ),
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
              ),
            ),
            onPressed: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: icon,
                  // child: AssetService(context).superImage('log_out.png', folder: 'asset', version: SyncReadService().getAssetVersion('asset')),
                ),
                LangText(
                  title,
                  style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
