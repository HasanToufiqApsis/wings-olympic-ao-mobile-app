import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../models/assetModel.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../services/connectivity_service.dart';
import '../../../services/sync_service.dart';
import '../../../services/update_service.dart';
import '../ui/app_updating_ui.dart';
import '../ui/updating_ui.dart';

import 'package:path/path.dart' as path;

class UpdateController {
  final BuildContext context;
  final WidgetRef ref;

  UpdateController({required this.context, required this.ref}) : _alerts = Alerts(context: context);
  Alerts _alerts;
  final MethodChannel _channel = const MethodChannel("primsV2/unzip");

  final UpdateService _updateService = UpdateService();

  goToUpdateApp() async {
    try {
      bool isOnline = await ConnectivityService().checkInternet();
      if (isOnline) {
        String? url = await _updateService.getAppUpdateUrl();
        if (url != null) {
          await SyncService().deleteSync();
          Navigator.of(context).pushNamedAndRemoveUntil(AppUpdatingUI.routeName, (route) => false, arguments: url);
        }
      } else {

      }
    } catch (e) {
      print("inside goToUpdateApp updateController catch block $e");
    }
  }

  //check internet and decide the process of downloading
  updateProcessSelection(List<AssetModel> assetList) async {
    bool internet = await ConnectivityService().checkInternet();
    if (internet == true) {
      //==========For downloading assets ==================

      Navigator.pushNamed(context, UpdatingUI.routeName, arguments: assetList);
    } else {
      _alerts.showModalWithWidget(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Icon(
                Icons.warning,
                color: Colors.red,
                size: 25.sp,
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            LangText(
              'You don\'t have internet connection. You can import the zipped asset file Manually or retry',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),

            SubmitButtonGroup(
              button1Label: "Manual Import Asset",
              onButton1Pressed: ()async{
                //TODO:: need to make manual import possible

              },
            ),

            SizedBox(
              height: 1.h,
            ),
            SubmitButtonGroup(
              button1Label: "Retry",
              button1Color: primaryGrey,
              onButton1Pressed: ()async{
                //TODO:: need to make manual import possible

              },
            ),

          ],
        ),
      ));
    }
  }

}
