import 'dart:convert';
import 'dart:developer';

// import 'package:firebase_messaging/firebase_messaging.dart';

import '../api/global_http.dart';
import '../api/links.dart';
import '../api/section_change_status_api.dart';
import '../constants/constant_keys.dart';
import '../constants/constant_variables.dart';
import '../constants/enum.dart';
import '../constants/sync_global.dart';
import '../models/general_id_slug_model.dart';
import '../models/journey_change_route_model.dart';
import '../models/returned_data_model.dart';
import '../models/sr_info_model.dart';
import 'ff_services.dart';
import 'helper.dart';
import 'sync_read_service.dart';
import 'sync_service.dart';

class ChangeRouteService {
  SyncReadService _syncReadService = SyncReadService();
  SyncService _syncService = SyncService();
  FFServices _ffServices = FFServices();
  // handlePushNotification(RemoteMessage message) async {
  //   try {
  //     // await _syncService.readSync();
  //     // if(message.data.containsKey("type")){
  //     //   if(message.data["type"]=="midday_update"){
  //     //     changeMiddayUpdateKey(true);
  //     //     await _syncService.writeSync(jsonEncode(syncObj));
  //     //   }
  //     //   else if(message.data["type"]=="my-market"){
  //     //     if(message.data.containsKey("delegation_message")){
  //     //       await ToInstructionService().setInstructionsFromNotifications(message.data);
  //     //     }
  //     //   }
  //     // }
  //   } catch (e) {
  //     print("inside handlePushNotification MidDayConfigurationUpdateServices catch block $e");
  //   }
  // }

  Future<bool> checkIfJourneyChangeEnabled() async {
    bool enabled = false;
    try {
      await _syncService.checkSyncVariable();
      Map journeyMap = syncObj["journey_plan_configurations"] ?? {};
      if (journeyMap.isNotEmpty) {
        enabled = journeyMap["enabled"] == 1;
      }
    } catch (e) {
      Helper.dPrint("inside checkIfJourneyChangeENabled changeRouteServices catch block $e");
    }
    return enabled;
  }

  Future<List<JourneyChangeRouteModel>> getRouteListForJourneyChange() async {
    List<JourneyChangeRouteModel> routeList = [];
    try {
      await _syncService.checkSyncVariable();
      Map journeyMap = syncObj["journey_plan_configurations"] ?? {};
      if (journeyMap.isNotEmpty) {
        if (journeyMap["enabled"] == 1) {
          if (journeyMap["routes"].isNotEmpty) {
            for (Map route in journeyMap["routes"]) {
              try {
                routeList.add(JourneyChangeRouteModel.fromJson(route));
              } catch (e) {
                Helper.dPrint("inside getRouteListForJourneyChange changeRouteServices fromJson catch block $e");
              }
            }
          }
        }
      }
    } catch (e) {
      Helper.dPrint("inside getRouteListForJourneyChange changeRouteService catch block $e");
    }
    return routeList;
  }

  Future<ReturnedDataModel> checkIfExistingRouteIsSelectedForJourneyChange(DateTime selectedDate, JourneyChangeRouteModel selectedRoute) async {
    ReturnedDataModel returned = ReturnedDataModel(status: ReturnedStatus.success);

    try {
      int? previousRoute = getPreviousRouteForADate(selectedDate);
      if (previousRoute == selectedRoute.id) {
        returned.status = ReturnedStatus.error;
        returned.errorMessage = "Selected route already exists in your route plan";

        return returned;
      }

      bool sameDayRequested = await checkIfSameDayJourneyChangeRequested(selectedDate);
      if (sameDayRequested) {
        returned.status = ReturnedStatus.warning;
        returned.errorMessage = "Are you sure to change today's journey plan?";
      }
    } catch (e) {
      Helper.dPrint("inside checkIfExistingRouteIsSelectedForJourneyChange changeRouteServices catch block $e");
    }

    return returned;
  }

  Future<bool> checkIfSameDayJourneyChangeRequested(DateTime selectedDate) async {
    bool sameDayRequested = false;
    try {
      String salesDate = await _ffServices.getSalesDate();
      sameDayRequested = salesDate == apiDateFormat.format(selectedDate);
    } catch (e) {
      Helper.dPrint("inside checkIfSameDayJourneyChangeRequested changeRouteServices catch block $e");
    }
    return sameDayRequested;
  }

  int? getPreviousRouteForADate(DateTime date) {
    int? previousRoute;
    try {
      List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', "Fri", 'Sat', 'Sun'];
      String weekDay = weekDays[date.weekday - 1];
      Map dayWiseRoute = syncObj['journey_plan_configurations']?['day_wise'] ?? {};
      previousRoute = dayWiseRoute[weekDay];
      print("day wise route $dayWiseRoute  week day $weekDay  week number ${date.day}");
    } catch (e) {
      Helper.dPrint("inside getPreviousRouteForADate ChangeRouteServices catch block $e");
    }
    return previousRoute;
  }

  Future<ReturnedDataModel> submitJourneyChangeRequest(DateTime selectedDate, JourneyChangeRouteModel selectedRoute, String reason) async {
    ReturnedDataModel returned = ReturnedDataModel(status: ReturnedStatus.error);
    try {
      SrInfoModel? srInfo = await _ffServices.getSrInfo();
      if (srInfo != null) {
        int? previousRoute = getPreviousRouteForADate(selectedDate);
        Map payload = {
          "current_section_id": previousRoute,
          "dep_id": srInfo.depId,
          "effective_startdate": apiDateFormat.format(selectedDate),
          "effective_enddate": apiDateFormat.format(selectedDate),
          "field_force_id": srInfo.ffId,
          ...selectedRoute.toJson()
        };
        log(jsonEncode(payload));
        String url = Links.baseUrl + Links.sectionChangeUrl;
        returned = await GlobalHttp(uri: url, httpType: HttpType.post, body: jsonEncode(payload), accessToken: srInfo.accessToken, refreshToken: srInfo.refreshToken).fetch();
        if (returned.status == ReturnedStatus.success) {
          await enableOrDisableBreakdown(selectedDate, true);
        }
      }
    } catch (e) {
      Helper.dPrint("inside submitJourneyChangeRequest ChangeRouteServices catch block $e");
    }
    return returned;
  }

  enableOrDisableBreakdown(DateTime selectedDate, bool enable) async {
    try {
      bool sameDay = await checkIfSameDayJourneyChangeRequested(selectedDate);
      if (sameDay) {
        if (!syncObj.containsKey(breakdownKey)) {
          syncObj[breakdownKey] = {};
        }
        syncObj[breakdownKey][breakdownEnabledKey] = enable;
        await _syncService.writeSync();
      }
    } catch (e) {
      Helper.dPrint("inside enableBreakdown ChangeRouteServices catch block $e ");
    }
  }

  Future<bool> checkIfBreakdownEnabled() async {
    bool enabled = false;
    try {

      await _syncService.checkSyncVariable();
      enabled = syncObj[breakdownKey]?[breakdownEnabledKey] ?? false;

    } catch (e) {
      Helper.dPrint("inside checkIfBreakdownEnabled ChangeRouteServices catch block $e");
    }
    return enabled;
  }

  Future<ReturnedDataModel> getCurrentChangeRequestStatus() async {
    ReturnedDataModel returned = ReturnedDataModel(status: ReturnedStatus.error, errorMessage: "Something Went Wrong");
    try {
      SrInfoModel? srInfo = await _ffServices.getSrInfo();
      if (srInfo != null) {
        returned = await SectionChangeStatusApi.fetch(srInfo);

        if (returned.status == ReturnedStatus.warning) {
          await enableOrDisableBreakdown(DateTime.now(), false);
        }
      }
    } catch (e) {
      Helper.dPrint("inside getCurrentChangeRequestStatus ChangeRouteServices catch block $e");
    }
    return returned;
  }
}
