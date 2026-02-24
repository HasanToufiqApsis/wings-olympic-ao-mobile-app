import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../api/log_in_api.dart';
import '../../../api/pda_api.dart';
import '../../../api/sales_date_api.dart';
import '../../../constants/enum.dart';
import '../../../constants/sync_global.dart';
import '../../../main.dart';
import '../../../models/assetModel.dart';
import '../../../models/returned_data_model.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../services/Image_service.dart';
import '../../../services/app_version_service.dart';
import '../../../services/asset_download/asset_download_service.dart';
import '../../../services/connectivity_service.dart';
import '../../../services/device_info_services.dart';
import '../../../services/ff_services.dart';
import '../../../services/helper.dart';
import '../../../services/langugae_pack_service.dart';
import '../../../services/sync_service.dart';
import '../../outlet_informations/ui/home_dashboard.dart';
import '../../sale_submit/ui/sale_submit_ui.dart';
import '../../splash_screen/ui/splash_screen_ui.dart';
import '../../update/ui/app_update_found.dart';
import '../../update/ui/update_found_ui.dart';
import '../ui/login_ui.dart';

class VerificationController {
  final BuildContext context;
  final WidgetRef ref;

  VerificationController({required this.context, required this.ref})
      : _alerts = Alerts(context: context);

  final SyncService _syncService = SyncService();
  late final Alerts _alerts;
  LanguagePackService languagePackService = LanguagePackService();
  final DeviceInfoService _deviceInfoService = DeviceInfoService();
  final FFServices _ffServices = FFServices();

  checkLogin() async {
    LoginStatus loginStatus = await _syncService.checkLogin();
    print("login status $loginStatus");
    if (loginStatus == LoginStatus.go_to_dashboard_automatically) {
      await LanguagePackService().readLang();
      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil(HomeDashboard.routeName, (route) => false);
    } else {
      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil(LoginUI.routeName, (route) => false, arguments: loginStatus);
    }
  }

  Future doLogin(String userId, String password, LoginStatus loginStatus) async {
    // if (kDebugMode) {
    //   userId = userId.isNotEmpty ? userId : "SOKarwanbazar";
    //   password = password.isNotEmpty ? password : "123";
    // }

    if (userId.isNotEmpty && password.isNotEmpty) {
      userId = userId.trim();
      password = password.trim();
      if (loginStatus == LoginStatus.login_with_api) {
        await doLoginWithApiCall(userId, password);
      } else if (loginStatus == LoginStatus.login_with_sync_file) {
        await doLoginWithSyncFile(userId, password);
      } else if (loginStatus == LoginStatus.login_with_sync_and_go_to_pda_upload) {
        await doLoginWithSyncFileAndGotoPdaUpload(userId, password);
      }
    } else {
      _alerts.customDialog(
          type: AlertType.warning, message: "Username or password is empty", button1: "ok");
    }
  }

  Future doLoginWithApiCall(String userId, String password) async {
    try {
      _alerts.floatingLoading(message: "Checking internet...");
      bool isConnected = await ConnectivityService().checkInternet();
      navigatorKey.currentState?.pop();

      if (isConnected) {
        _alerts.floatingLoading(message: "Logging In. Please wait");
        ReturnedDataModel syncDataModel = await LogInAPI().fetchLoginInfo(userId, password);
        if (syncDataModel.status == ReturnedStatus.success) {
          await languagePackService.removePreviousLanguagePack();
          await languagePackService.readLang();

          ImageService().deleteAllImages();
          String txt = '';
          if (kDebugMode == false) {
            txt = jsonEncode(syncDataModel.data);
          } else {
            txt = jsonEncode(syncDataModel.data);
            // txt = jsonEncode(dummyData);
          }
          await _syncService.writeSync(txt);
          // await LocalStorageHelper.save('timeStampList', jsonEncode([]));
          await _syncService.readSync();
          _ffServices.setUsernameToLocal();
          await _deviceInfoService.sendDeviceLog();
          await checkAppVersion();
          // await checkAssetExists();
          // await checkAppVersion();
        } else {
          log('error from server :: ${syncDataModel.errorMessage}');
          Navigator.pop(context);
          _alerts.customDialog(
            type: AlertType.error,
            message: "ERROR",
            description: syncDataModel.errorMessage,
            button1: 'Done',
            onTap1: () {
              Navigator.pop(context);
            },
          );
        }
      } else {
        // _alerts.showModalWithWidget(
        //     child: Padding(
        //       padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        //       child: Column(
        //         mainAxisSize: MainAxisSize.min,
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           Center(
        //             child: Icon(
        //               Icons.warning,
        //               color: Colors.red,
        //               size: 25.sp,
        //             ),
        //           ),
        //           SizedBox(
        //             height: 1.h,
        //           ),
        //           LangText(
        //             "You don't have internet connection. You can import the sync file Manually or retry",
        //             textAlign: TextAlign.center,
        //             style: TextStyle(
        //               fontSize: 12.sp,
        //               fontWeight: FontWeight.bold,
        //               color: Theme.of(context).primaryColorDark,
        //             ),
        //           ),
        //           SizedBox(
        //             height: 2.h,
        //           ),
        //           GlobalWidgets().button(
        //               colors: [blue, darkBlue],
        //               text: 'Manual Import',
        //               callback: () async {
        //                 Navigator.pop(context);
        //                 FilePickerResult? result = await FilePicker.platform.pickFiles();
        //                 if (result != null) {
        //                   File file = File(result.files.single.path!);
        //                   String text = await file.readAsString();
        //                   // log("text $text");
        //                   print("dssd");
        //                   print(text);
        //                   String? decrypted = EncryptionServices().decrypt(text);
        //                   print("decrypted =====================");
        //                   print(jsonEncode(decrypted));
        //                   if (decrypted != null) {
        //                     Map syncResult = jsonDecode(decrypted);
        //                     // if (syncResult["success"]) {
        //                     ImageService().deleteAllImages();
        //
        //                     if(syncResult.containsKey("success")){
        //                       if(syncResult["success"] && syncResult.containsKey("data")){
        //                         await SyncService().writeSync(jsonEncode(syncResult["data"]));
        //                         await SyncService().readSync();
        //                         await doLoginWithSyncFile(userId, password);
        //                       }else {
        //                         _alerts.customDialog(type: AlertType.error, message: "Wrong file picked", button1: "ok");
        //                       }
        //                     }else {
        //                       _alerts.customDialog(type: AlertType.error, message: "Wrong file picked", button1: "ok");
        //                     }
        //
        //                     // }
        //                   } else {
        //                     _alerts.customDialog(type: AlertType.error, message: "Wrong file picked", button1: "ok");
        //                   }
        //                 } else {
        //                   _alerts.customDialog(type: AlertType.error, message: "No File Picked", button1: "ok");
        //                 }
        //               }),
        //           SizedBox(
        //             height: 1.h,
        //           ),
        //           GlobalWidgets().button(
        //               colors: [grey, darkGrey],
        //               text: 'Retry',
        //               callback: () {
        //                 Navigator.pop(context);
        //                 doLoginWithApiCall(userId, password);
        //               }),
        //         ],
        //       ),
        //     ));
      }
    } catch (e, s) {
      // print("inside sssssss $e, $s");
      Navigator.pop(context);
      // _alerts.customDialog(type: AlertType.error, description: e.toString());
    }
  }

  Future doLoginWithSyncFile(String userId, String password) async {
    try {
      bool checkIdAndPasswordFormSync =
          await _syncService.checkIdAndPasswordFormSync(userId, password);
      if (checkIdAndPasswordFormSync) {
        await checkAppVersion();
      } else {
        _alerts.customDialog(
          type: AlertType.warning,
          message: "You have an un uploaded PDA please delete them",
          twoButtons: true,
          button1: 'Close',
          button2: 'Delete',
          onTap1: () {
            Navigator.pop(context);
          },
          onTap2: () async {
            bool isConnected = await ConnectivityService().checkInternet();

            if (isConnected == true) {
              await deletePdaFromServer();
              await SyncService().deleteSync();
              // await deletePdaFromServer();
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                  SplashScreenUI.routeName, (Route<dynamic> route) => false);
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
                        "You don't have internet connection.",
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
                      // GlobalWidgets().button(
                      //     colors: [blue, darkBlue],
                      //     text: 'Manual Import',
                      //     callback: () async {
                      //       Navigator.pop(context);
                      //       FilePickerResult? result = await FilePicker.platform.pickFiles();
                      //       if (result != null) {
                      //         File file = File(result.files.single.path!);
                      //         String text = await file.readAsString();
                      //         // log("text $text");
                      //         print("dssd");
                      //         print(text);
                      //         String? decrypted = EncryptionServices().decrypt(text);
                      //         print("decrypted =====================");
                      //         print(jsonEncode(decrypted));
                      //         if (decrypted != null) {
                      //           Map syncResult = jsonDecode(decrypted);
                      //           // if (syncResult["success"]) {
                      //           ImageService().deleteAllImages();
                      //
                      //           if(syncResult.containsKey("success")){
                      //             if(syncResult["success"] && syncResult.containsKey("data")){
                      //               await SyncService().writeSync(jsonEncode(syncResult["data"]));
                      //               await SyncService().readSync();
                      //               await doLoginWithSyncFile(userId, password);
                      //             }else {
                      //               _alerts.customDialog(type: AlertType.error, message: "Wrong file picked", button1: "ok");
                      //             }
                      //           }else {
                      //             _alerts.customDialog(type: AlertType.error, message: "Wrong file picked", button1: "ok");
                      //           }
                      //
                      //           // }
                      //         } else {
                      //           _alerts.customDialog(type: AlertType.error, message: "Wrong file picked", button1: "ok");
                      //         }
                      //       } else {
                      //         _alerts.customDialog(type: AlertType.error, message: "No File Picked", button1: "ok");
                      //       }
                      //     }),
                      SubmitButtonGroup(
                        button1Label: 'Cancel',
                        button2Label: "Delete device's PDA only",
                        twoButtons: true,
                        onButton1Pressed: () {
                          Navigator.pop(context);
                        },
                        onButton2Pressed: () async {
                          await deletePdaFromServer();
                          await SyncService().deleteSync();
                          // await deletePdaFromServer();
                          navigatorKey.currentState?.pushNamedAndRemoveUntil(
                              SplashScreenUI.routeName, (Route<dynamic> route) => false);
                        },
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      }
    } catch (e, s) {
      print("inside login controller error $e, $s");
      _alerts.customDialog(type: AlertType.error, description: e.toString());
    }
  }

  Future doLoginWithSyncFileAndGotoPdaUpload(String userId, String password) async {
    try {
      bool currentDateMatch = await SalesDateApi().checkIfSalesDateMatchesWithSync();
      bool checkIdAndPasswordFormSync =
          await _syncService.checkIdAndPasswordFormSync(userId, password);

      if (checkIdAndPasswordFormSync && !currentDateMatch) {
        _alerts.customDialog(
            message: "You have a previous version sync file, Please upload/delete the file.",
            button2: 'Delete',
            twoButtons: true,
            button1: 'Upload',
            onTap1: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, SaleSubmitUI.routeName);
            },
            onTap2: () async {
              await SyncService().deleteSync();
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                  SplashScreenUI.routeName, (Route<dynamic> route) => false);
            });
        // Navigator.of(context).pushNamedAndRemoveUntil(DashBoardUI.routeName, (route) => false);
      } else {
        String desc =
            "Previous Un uploaded PDA found. please provide correct username/password to upload them";
        if (!currentDateMatch) {
          desc = "You have a previous version sync file, Please delete the sync file.";
        }
        _alerts.customDialog(
            type: AlertType.error,
            description: desc,
            twoButtons: true,
            button2: 'Delete',
            button1: 'Upload',
            onTap1: () {
              Navigator.pop(context);
              _alerts.customDialog(
                  message: "Please use correct ID and PASSWORD to upload the data.");
            },
            onTap2: () async {
              await SyncService().deleteSync();
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                  SplashScreenUI.routeName, (Route<dynamic> route) => false);
            });
      }
    } catch (e, s) {
      _alerts.customDialog(type: AlertType.error, description: e.toString());
    }
  }

  checkAppVersion() async {
    bool matched = true; // await AppVersionService().checkVersionMatched();
    if (matched) {
      await checkAssetExists();
      bool isConnected = await ConnectivityService().checkInternet();

      if (isConnected) {
        await LanguagePackService().readLang();
      }
    } else {
      // bool ifMandatory = await AppVersionService().checkVersionIfMandatory();
      // if (!ifMandatory) {
      //   Alerts(context: context).customDialog(
      //       type: AlertType.warning,
      //       message: "You should update your to current version of app",
      //       onTap1: () async {
      //         Navigator.of(context).pop();
      //         await checkAssetExists();
      //         // navigatorKey.currentState?.pushNamed(AppUpdateFoundUI.routeName);
      //       });
      // } else {
      //   syncObj['logged_in'] = 0;
      //   await SyncService().writeSync(jsonEncode(syncObj));
      //   Alerts(context: context).customDialog(
      //       type: AlertType.warning,
      //       message: "You have to update your to current version of app",
      //       onTap1: () {
      //         syncRead = false;
      //         navigatorKey.currentState?.pushNamed(AppUpdateFoundUI.routeName);
      //       });
      // }
    }
  }

  checkAssetExists() async {
    List<AssetModel> assetDownloadList = await AssetDownloadService(context).getSyncAssetList();
    Helper.dPrint("asset download list :: ${assetDownloadList.length}");
    for (var val in assetDownloadList) {
      Helper.dPrint('${val.slug} : ${val.version} : ${val.assets}');
    }
    if (assetDownloadList.isEmpty) {
      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil(HomeDashboard.routeName, (route) => false);
    } else {
      navigatorKey.currentState
          ?.popAndPushNamed(UpdateFoundUI.routeName, arguments: assetDownloadList);
    }
  }

  setPreviouslySavedUsername(TextEditingController usernameController) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      String username = await _ffServices.getUsernameFromLocal();
      if (username.isNotEmpty) {
        usernameController.text = username;
      }
    });
  }

  ///delete sync file from server
  Future deletePdaFromServer() async {
    try {
      PDAApi().deletePdaFromOnline();
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
  }
}
