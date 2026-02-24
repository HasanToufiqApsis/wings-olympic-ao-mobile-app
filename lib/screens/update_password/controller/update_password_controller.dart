import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/log_in_api.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/returned_data_model.dart';
import '../../../models/sr_info_model.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../services/sync_read_service.dart';
import '../../../services/update_password_service.dart';
import '../../settings/controller/settings_controller.dart';

class UpdatePasswordController {
  late BuildContext context;
  late WidgetRef ref;

  UpdatePasswordController({
    required this.context,
    required this.ref,
  }) : _alerts = Alerts(context: context);

  late Alerts _alerts;

  Future updatePassword({
    required String oldPassword,
    required String newPassword,
    required String reNewPassword,
  }) async {
    bool valid = await checkUpdatePasswordValidation(
      oldPassword: oldPassword,
      newPassword: newPassword,
      reNewPassword: reNewPassword,
    );

    if(valid == true) {
      try {
        _alerts.floatingLoading();
        ReturnedDataModel returnedDataModel = await LogInAPI().updatePassword(oldPassword, newPassword);
        if(returnedDataModel.status==ReturnedStatus.success) {
          await UpdatePasswordService().updatePassword(password: newPassword);
          await SettingsController(context: context, ref: ref, ).sendPdaToSupport();
          navigatorKey.currentState?.pop();
          _alerts.customDialog(type: AlertType.success, message: "Password updated successfully", onTap1: (){
            navigatorKey.currentState?.pop();
            navigatorKey.currentState?.pop();
          });
        } else {
          navigatorKey.currentState?.pop();
          _alerts.customDialog(type: AlertType.error, message: returnedDataModel.errorMessage);
        }
      } catch (e,t) {
        log(e.toString());
        log(t.toString());
      }
    }
  }

  Future<bool> checkUpdatePasswordValidation({
    required String oldPassword,
    required String newPassword,
    required String reNewPassword,
  }) async {
    if (oldPassword.isEmpty) {
      _alerts.customDialog(type: AlertType.warning, message: "Enter old password");
      return false;
    }
    // if (oldPassword.length < 3) {
    //   _alerts.customDialog(type: AlertType.warning, message: "Password must be at-least 3 digits long");
    //   return false;
    // }

    SrInfoModel sr = await SyncReadService().getSrInfo();
    if (oldPassword != sr.password) {
      _alerts.customDialog(type: AlertType.warning, message: "Old password not correct");
      return false;
    }
    if (newPassword.isEmpty) {
      _alerts.customDialog(type: AlertType.warning, message: "Enter new password");
      return false;
    }
    if (newPassword.length < 3) {
      _alerts.customDialog(type: AlertType.warning, message: "Password must be at-least 3 digits long");
      return false;
    }
    if (reNewPassword.isEmpty) {
      _alerts.customDialog(type: AlertType.warning, message: "Enter confirm password");
      return false;
    }
    if (reNewPassword.length < 3) {
      _alerts.customDialog(type: AlertType.warning, message: "Password must be at-least 3 digits long");
      return false;
    }
    if (reNewPassword != newPassword) {
      _alerts.customDialog(type: AlertType.warning, message: "New password and confirm password must be same");
      return false;
    }
    return true;
  }
}
