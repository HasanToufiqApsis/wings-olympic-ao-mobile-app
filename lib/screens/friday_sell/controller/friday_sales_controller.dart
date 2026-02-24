import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../api/log_in_api.dart';
import '../../../constants/enum.dart';
import '../../../constants/sync_global.dart';
import '../../../main.dart';
import '../../../models/journey_change_route_model.dart';
import '../../../models/returned_data_model.dart';
import '../../../models/sr_info_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../services/Image_service.dart';
import '../../../services/device_info_services.dart';
import '../../../services/ff_services.dart';
import '../../../services/langugae_pack_service.dart';
import '../../../services/sync_service.dart';
import '../../settings/controller/settings_controller.dart';
import '../../verificartions/controller/verification_controller.dart';

class FridaySalesController {
  BuildContext context;
  WidgetRef ref;
  late Alerts alerts;

  FridaySalesController({required this.context, required this.ref}) : alerts = Alerts(context: context);

  refreshState() {
    ref.refresh(selectedRouteProvider);
    ref.refresh(userDataProvider);
  }

  ///take decision about my current route fom [UI]
  void controllerInit() async {
    await Future.delayed(Duration.zero);
    SrInfoModel? userInfo = ref.watch(userDataProvider).value;
    changeCurrentRout(user: userInfo);
  }

  ///my initial rout
  ///assign data after [controllerInit] process or change data after [changeCurrentRout]
  JourneyChangeRouteModel? initialRout;

  void changeCurrentRout({required SrInfoModel? user}) async {
    if (user != null && user.srRoute.isNotEmpty) {
      AsyncValue<List<JourneyChangeRouteModel>> asyncRouteList = ref.watch(getALlRouteListProvider);
      List<JourneyChangeRouteModel> routesList = asyncRouteList.value ?? [];

      if (routesList.isNotEmpty) {
        int todayRouteId = user.sectionId ?? 0;

        for (var val in routesList) {
          int routeId = val.id;
          if (routeId == todayRouteId) {
            ref.read(selectedRouteProvider.notifier).state = val;
            initialRout = val;
            break;
          }
        }
      }
    }
  }

  void changeRoute() {
    try {
      JourneyChangeRouteModel? selectedRout = ref.read(selectedRouteProvider.notifier).state;
      if (selectedRout == null) {
        alerts.customDialog(
          type: AlertType.error,
          message: 'Please select a route',
          onTap1: Navigator.of(context).pop,
        );
        return;
      } else if (selectedRout == initialRout) {
        alerts.customDialog(
          type: AlertType.error,
          message: 'Please select another route',
          onTap1: Navigator.of(context).pop,
        );
        return;
      } else {
        alerts.customDialog(
          type: AlertType.warning,
          description: "Are you sure to change route plan?",
          button1: "Yes",
          onTap1: () async {
            navigatorKey.currentState?.pop();
            alerts.floatingLoading();

            await Future.delayed(const Duration(seconds: 1));
            bool result = await fetchAllData(route: selectedRout);
            if (result) {
              navigatorKey.currentState?.pop();
              alerts.customDialog(
                  type: AlertType.success,
                  message: 'Your route changed successfully',
                  onTap1: () async {
                    navigatorKey.currentState?.pop();
                    refreshState();
                    await VerificationController(context: context, ref: ref).checkAppVersion();
                  });
            }
          },
          twoButtons: true,
          onTap2: Navigator.of(context).pop,
        );
      }
    } catch (e, t) {
      print(e.toString());
      print(t.toString());
    }
  }

  Future<bool> fetchAllData({required JourneyChangeRouteModel route}) async {
    AsyncValue<SrInfoModel?> asyncSrInfo = ref.watch(userDataProvider);
    SrInfoModel? user = asyncSrInfo.value;
    print(user?.toJson());
    LanguagePackService languagePackService = LanguagePackService();
    final DeviceInfoService _deviceInfoService = DeviceInfoService();
    final SyncService _syncService = SyncService();
    final FFServices _ffServices = FFServices();

    bool savePda = false;
    savePda = await SettingsController(context: context, ref: ref).sendPdaToSupport();

    if (savePda) {
      ReturnedDataModel syncDataModel = await LogInAPI().fetchSyncFileWithRout(
        useData: syncObj['userData'],
        password: user?.password ?? '',
        routId: route.routeId,
        sectionId: route.id,
      );
      if (syncDataModel.status == ReturnedStatus.success) {
        //upload pda to server

        await _syncService.deleteSync();
        await languagePackService.removePreviousLanguagePack();
        await languagePackService.readLang();

        ImageService().deleteAllImages();
        String txt = jsonEncode(syncDataModel.data);
        // String txt = jsonEncode(dummyData);
        await _syncService.writeSync(txt);
        // await LocalStorageHelper.save('timeStampList', jsonEncode([]));
        await _syncService.readSync();
        _ffServices.setUsernameToLocal();
        await _deviceInfoService.sendDeviceLog();
        // await VerificationController(context: context, ref: ref).checkAppVersion();
        // await checkAssetExists();
        return true;
        // }
      } else {
        return false;
      }
    } else {
      alerts.customDialog(
        type: AlertType.error,
        message: 'Unable to change route',
        onTap1: Navigator.of(context).pop,
      );
      return false;
    }
  }
}
