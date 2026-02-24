import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wings_olympic_sr/api/settings_api.dart';
import 'package:wings_olympic_sr/services/day_close_service.dart';

import '../../../api/global_http.dart';
import '../../../api/links.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../constants/sync_global.dart';
import '../../../main.dart';
import '../../../models/returned_data_model.dart';
import '../../../models/sr_info_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../services/change_route_service.dart';
import '../../../services/connectivity_service.dart';
import '../../../services/encryption_services.dart';
import '../../../services/helper.dart';
import '../../../services/sync_read_service.dart';
import '../../../services/sync_service.dart';
import '../../splash_screen/ui/splash_screen_ui.dart';

class SettingsController {
  BuildContext context;
  WidgetRef ref;
  late Alerts alerts;

  SettingsController({required this.context, required this.ref})
      : alerts = Alerts(context: context);

  ChangeRouteService changeRouteService = ChangeRouteService();

  checkChangeStatusAndLogout() async {
    alerts.floatingLoading();
    ReturnedDataModel returnedDataModel = await changeRouteService.getCurrentChangeRequestStatus();
    navigatorKey.currentState?.pop();
    print("dadasdasdasd");
    print(returnedDataModel.status);
    if (returnedDataModel.status == ReturnedStatus.success) {
      alerts.customDialog(
          type: AlertType.warning,
          description:
              "You are logging out to get you requested new route's data. Please log in again.",
          onTap1: () async {
            await SyncService().deleteSync();
            navigatorKey.currentState?.popAndPushNamed(SplashScreenUI.routeName);
          });
    } else {
      alerts.customDialog(type: AlertType.info, description: returnedDataModel.data);
    }
  }

  logout() async {
    try {
      alerts.floatingLoading();
      bool internetConnection = ref.watch(internetConnectivityProvider);
      if (internetConnection) {
        bool sendPda = true; // await sendPdaToSupport(); //todo
        // if (kDebugMode) {
        //   sendPda = true;
        // } else {
        //   sendPda = await sendPdaToSupport();
        // }
        log('sendPda is: $sendPda');
        if (sendPda) {
          _finalLogout();
        } else {
          Navigator.pop(context);
        }
      } else {
        Navigator.pop(context);
        // ConnectivityService().initialize(
        //   context: context,
        //   onTapPop: true,
        //   onChange: (value) {},
        // );
      }
    } catch (e, t) {
      Helper.dPrint(e.toString());
      Helper.dPrint(t.toString());
      Navigator.pop(context);
    }
  }

  _finalLogout() async {
    try {
      // alerts.floatingLoading();
      await SyncService().logoutFromSync();
      // navigatorKey.currentState?.pop();
      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil(SplashScreenUI.routeName, (Route<dynamic> route) => false);
    } catch (e, t) {
      Helper.dPrint(e.toString());
      Helper.dPrint(t.toString());
    }
  }

  Future<bool> sendPdaToSupport({
    bool directSendToSupport = false,
  }) async {
    try {
      SyncService().checkSyncVariable();

      SrInfoModel srInfo = await SyncReadService().getSrInfo();
      String? encryptedPda =
          EncryptionServices().encrypt(jsonEncode({"success": true, "data": syncObj}));
      File? file = await writeFile(encryptedPda!);
      String dateStr = await SyncReadService().getSalesDate();
      DateTime date = DateTime.parse(dateStr);
      if (file != null) {
        String path = directSendToSupport
            ? 'syncFile/${date.year}/${date.month}/${date.day}'
            : 'pda/${date.year}/${date.month}/${date.day}/${srInfo.sectionId}/${srInfo.ffId}';
        // print('file path is::: ${file.path}');

        ReturnedDataModel data = await GlobalHttp(
          uri: "${Links.baseUrl}${Links.fileUrl}",
          httpType: HttpType.file,
          imagePath: file.path,
          path: path,
          accessToken: srInfo.accessToken,
          refreshToken: srInfo.refreshToken,
        ).fetch();

        if (data.status == ReturnedStatus.success) {
          if (data.data["success"]) {
            return true;
          }
          return false;
        } else {
          log('status is:: ${data.status} :: ${data.errorMessage} :: ${data.data}');
        }
      }
      return false;
    } catch (e, t) {
      Helper.dPrint(e.toString());
      Helper.dPrint(t.toString());
      return false;
    }
  }

  Future<bool> updatePassword({
    bool directSendToSupport = false,
  }) async {
    try {
      SyncService().checkSyncVariable();

      SrInfoModel srInfo = await SyncReadService().getSrInfo();
      String? encryptedPda =
          EncryptionServices().encrypt(jsonEncode({"success": true, "data": syncObj}));
      File? file = await writeFile(encryptedPda!);
      String dateStr = await SyncReadService().getSalesDate();
      DateTime date = DateTime.parse(dateStr);
      if (file != null) {
        String path = directSendToSupport
            ? 'syncFile/${date.year}/${date.month}/${date.day}'
            : 'pda/${date.year}/${date.month}/${date.day}/${srInfo.sectionId}/${srInfo.ffId}';
        // print('file path is::: ${file.path}');

        ReturnedDataModel data = await GlobalHttp(
          uri: "${Links.baseUrl}${Links.fileUrl}",
          httpType: HttpType.file,
          imagePath: file.path,
          path: path,
          accessToken: srInfo.accessToken,
          refreshToken: srInfo.refreshToken,
        ).fetch();

        if (data.status == ReturnedStatus.success) {
          if (data.data["success"]) {
            return true;
          }
          return false;
        } else {
          log('status is:: ${data.status} :: ${data.errorMessage} :: ${data.data}');
        }
      }
      return false;
    } catch (e, t) {
      Helper.dPrint(e.toString());
      Helper.dPrint(t.toString());
      return false;
    }
  }

  Future<File?> writeFile(String text) async {
    try {
      bool syncExists = await createFile();
      if (syncExists) {
        File? sync = await getFile();
        await sync!.writeAsString(text);
        return sync;
      } else {
        return null;
      }
    } catch (e) {
      print("Setting controller writeFile catch block $e");
      return null;
    }
  }

  //get  file
  Future<File?> getFile() async {
    String path = await getPathForPdaToSupport();
    File sync = File(path);
    if (await sync.exists()) {
      return sync;
    }
  }

  Future<bool> createFile() async {
    try {
      String path = await getPathForPdaToSupport();
      File sync = File(path);
      bool fileExists = await sync.exists();

      if (!fileExists) {
        await sync.create(recursive: true);
        return true;
      } else {
        return true;
      }
    } catch (e) {
      print("inside createSyncFile catch block $e");
      return false;
    }
  }

  Future<String> getPathForPdaToSupport() async {
    SrInfoModel srInfo = await SyncReadService().getSrInfo();
    Directory baseDir = await getApplicationDocumentsDirectory();
    String syncPath = "${baseDir.path}v2/Sync/sync_${srInfo.sectionId}_$todayDate.wings";
    return syncPath;
  }

  void pdaDirectSendToSupport() async {
    try {
      alerts.floatingLoading();
      bool internetConnection = ref.watch(internetConnectivityProvider);
      if (internetConnection) {
        bool sendPda = await sendPdaToSupport();
        log('sendPda is: $sendPda');
        if (sendPda) {
          bool send = await sendPdaToSupport(directSendToSupport: true);
          Navigator.pop(context);
          if (send) {
            alerts.customDialog(
              type: AlertType.success,
              description: "PDA to support sent successfully",
              onTap1: () {
                Navigator.of(context).pop();
              },
            );
          } else {
            alerts.customDialog(
              type: AlertType.warning,
              message: "ERROR",
              onTap1: () {
                Navigator.of(context).pop();
              },
            );
          }
        } else {
          Navigator.pop(context);
        }
      } else {
        Navigator.pop(context);
      }
    } catch (e, t) {
      print(e.toString());
      print(t.toString());
    }
  }

  Future startSaleAgain() async {
    String? saleSubmitReason = ref.read(selectedReasonsProvider);
    String? saleSubmitRemark = ref.read(editReasonRemarkProvider);
    log("sale edit reason: $saleSubmitReason");

    final returnedDataModel = await SettingsApi().requestRestSaleSubmit(reason: saleSubmitReason??"", remark: saleSubmitRemark??"");
    if(returnedDataModel.status == ReturnedStatus.success) {
      await DayCloseService().resetAllServiceForToday();
      alerts.customDialog(type: AlertType.success, description: "You are able to resale again");
    } else {
      alerts.customDialog(type: AlertType.error, description: returnedDataModel.errorMessage);
    }
  }
}
