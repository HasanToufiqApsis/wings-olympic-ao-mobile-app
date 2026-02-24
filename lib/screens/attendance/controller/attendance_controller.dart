import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sizer/sizer.dart';

import '../../../api/attendance_api.dart';
import '../../../api/pjp_plan_api.dart';
import '../../../constants/constant_keys.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/attendance_model.dart';
import '../../../models/location_address_model.dart';
import '../../../models/pjp_plan_details.dart';
import '../../../models/returned_data_model.dart';
import '../../../models/sr_info_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/cameraScreen.dart';
import '../../../services/ff_services.dart';
import '../../../services/geo_location_service.dart';
import '../../../services/helper.dart';
import '../../../services/sync_read_service.dart';
import '../../pjp_plan/service/pjp_plan_service.dart';
import '../model/inside_fensing.dart';
import '../ui/check_in_out_ui.dart';

class AttendanceController {
  BuildContext context;
  WidgetRef ref;
  late Alerts alerts;
  late Timer timer;

  AttendanceController({required this.context, required this.ref}) {
    alerts = Alerts(context: context);
  }

  AttendanceAPI attendanceAPI = AttendanceAPI();

  disposeTimer() {
    timer.cancel();
  }

  clock() {
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      ref.refresh(attendanceDateTimeProvider);
    });
  }

  gotoCheckIn(AttendanceModel attendanceModel, LocationAddressModel<Placemark?> locationData) async {
    try{
      if (attendanceModel.status == AttendanceStatus.noAttendance) {
        bool inside = true;
        int allowedIndex = 0;
        InsideFencing insideFencing= InsideFencing(distance: 0, inside: false);

        String nearbyPointName = "";
        num nearbyPointDistance = -1;

        final locations = attendanceModel.attendanceLocation;
        if (locations != null && locations.isNotEmpty) {
          alerts.floatingLoading();
          inside = false;
          allowedIndex = 0;
          for (var val in locations) {
            insideFencing = await LocationService(context).geoFencingWithDistanceReturn(
              lat: val.lat,
              lng: val.long,
              allowedDistance: val.allowableDistance,
            );

            inside = insideFencing.inside;
            if(nearbyPointDistance == -1) {
              nearbyPointDistance = insideFencing.distance;
            }
            log("previous distance :::: ${nearbyPointDistance} ::: ${insideFencing.distance}");
            if(nearbyPointDistance >= insideFencing.distance) {
              nearbyPointDistance = insideFencing.distance;
              nearbyPointName = val.dep_name ??'';
            }

            if (inside) break;
            allowedIndex++;
          }

          print('inside data is::::: $inside');
          navigatorKey.currentState?.pop();
        }

        if (inside) {
          print('inside index is $allowedIndex');
          navigatorKey.currentState?.pushNamed(CheckInOutUI.routeName, arguments: {
            attendanceStatusKey: AttendanceType.checkIn,
            attendanceIdKey: attendanceModel.id,
            "lat": (locations != null && locations.isNotEmpty && allowedIndex < locations.length)
                ? locations[allowedIndex].lat
                : locationData.lat,
            "lng": (locations != null && locations.isNotEmpty && allowedIndex < locations.length)
                ? locations[allowedIndex].long
                : locationData.long,
            "depId" : (locations != null && locations.isNotEmpty && allowedIndex < locations.length)
                ? locations[allowedIndex].depId
                : 0
          });
        } else {
          tryToCheckIn(location: locationData, attendanceModel: attendanceModel);
          String lang = ref.watch(languageProvider);
          String distance = GlobalWidgets().numberEnglishToBangla(num: nearbyPointDistance.toStringAsFixed(2), lang: lang, isNumber: true);

          String hint = "You are $distance meters away from your nearby point location";
          if (lang != "en") {
            hint = "আপনি আপনার নিকটস্থ পয়েন্ট লোকেশন $nearbyPointName থেকে $distance মিটার দূরে আছেন";
          }

          alerts.customDialog(type: AlertType.warning, description: hint);
        }
      }
    } catch (e,t){
      log(e.toString());
      log(t.toString());
    }
  }

  gotoCheckInTsm(AttendanceModel attendanceModel, LocationAddressModel<Placemark?> locationData) async {
    try{
      if (attendanceModel.status == AttendanceStatus.noAttendance) {
        bool inside = true;

          alerts.floatingLoading();
          List<PJPPlanDetails> list = [];
          var l = await PjpPlanAPI().getFullMonthPjpPlanAPI(forTodayOnly: true);
          if(l.status == ReturnedStatus.success) {
            List<PJPPlanDetails> allPjp = PJPPlanService().getPjpPlanListFromResponse(data: l.data["data"]);
            list.addAll(allPjp);

            InsideFencing insideFencing = InsideFencing(distance: 0, inside: true);
            if (list.isNotEmpty) {
              insideFencing = await LocationService(context).geoFencingWithDistanceReturn(
                lat: list.first.morningLat ?? 0,
                lng: list.first.morningLong ?? 0,
                allowedDistance: list.first.intTimeAllowableDistance ?? 0,
              );
            }

            inside = insideFencing.inside;

            print('inside data is::::: $inside');

            navigatorKey.currentState?.pop();


            if (inside) {
              // print('inside index is $allowedIndex');
              debugPrint("check-in tem from pjp plan::::>>>>");
              navigatorKey.currentState?.pushNamed(CheckInOutUI.routeName, arguments: {
                attendanceStatusKey: AttendanceType.checkIn,
                attendanceIdKey: attendanceModel.id,
                "lat": list.isNotEmpty ? (list.first.morningLat ?? 0) : locationData.lat,
                "lng": list.isNotEmpty ? (list.first.morningLong ?? 0) : locationData.long,
                "depId": list.isNotEmpty ? (list.first.morningDepId ?? 0) : 0,
              });
            } else {
              tryToCheckIn(location: locationData, attendanceModel: attendanceModel);
              String lang = ref.watch(languageProvider);
              String distance = GlobalWidgets().numberEnglishToBangla(num: insideFencing.distance.toStringAsFixed(2), lang: lang, isNumber: true);

              String hint = "You are $distance meters away from your point location";
              if (lang != "en") {
                hint = "আপনি আপনার পয়েন্ট লোকেশন থেকে $distance মিটার দূরে আছেন";
              }

              alerts.customDialog(type: AlertType.warning, description: hint);
            }
          } else {
            navigatorKey.currentState?.pop();
            gotoCheckIn(attendanceModel, locationData);
            return;
          }
      }
    } catch (e,t){
      log(e.toString());
      log(t.toString());
    }
  }

  gotoCheckOut(AttendanceModel attendanceModel, LocationAddressModel<Placemark?> locationData) async {
    try{
      InsideFencing insideFencing= InsideFencing(distance: 0, inside: false);
      if (attendanceModel.status == AttendanceStatus.checkInDone) {
        bool inside = true;
        int allowedIndex = 0;
        String nearbyPointName = "";
        num nearbyPointDistance = -1;

        final locations = attendanceModel.attendanceLocation;
        if (locations != null && locations.isNotEmpty) {
          alerts.floatingLoading();
          inside = false;
          allowedIndex = 0;
          for (var val in locations) {
            insideFencing = await LocationService(context).geoFencingWithDistanceReturn(
              lat: val.lat,
              lng: val.long,
              allowedDistance: val.allowableDistance,
            );

            inside = insideFencing.inside;
            if(nearbyPointDistance == -1) {
              nearbyPointDistance = insideFencing.distance;
            }
            log("previous distance :::: ${nearbyPointDistance} ::: ${insideFencing.distance}");
            if(nearbyPointDistance >= insideFencing.distance) {
              nearbyPointDistance = insideFencing.distance;
              nearbyPointName = val.dep_name ??'';
            }

            if (inside) break;
            allowedIndex++;
          }

          navigatorKey.currentState?.pop();
        }

        if (inside) {
          navigatorKey.currentState?.pushNamed(CheckInOutUI.routeName, arguments: {
            attendanceStatusKey: AttendanceType.checkOut,
            attendanceIdKey: attendanceModel.id,
            "lat": (locations != null && locations.isNotEmpty && allowedIndex < locations.length)
                ? locations[allowedIndex].lat
                : locationData.lat,
            "lng": (locations != null && locations.isNotEmpty && allowedIndex < locations.length)
                ? locations[allowedIndex].long
                : locationData.long,
            "depId": (locations != null && locations.isNotEmpty && allowedIndex < locations.length)
                ? locations[allowedIndex].depId
                : 0,
          });
        } else {
          tryToCheckIn(location: locationData, checkOut: true, attendanceModel: attendanceModel);
          String lang = ref.watch(languageProvider);
          String distance = GlobalWidgets().numberEnglishToBangla(num: nearbyPointDistance.toStringAsFixed(2), lang: lang, isNumber: true);

          String hint = "You are $distance meters away from your nearby point location}";
          if (lang != "en") {
            hint = "আপনি আপনার নিকটস্থ পয়েন্ট লোকেশন $nearbyPointName থেকে $distance মিটার দূরে আছেন";
          }

          alerts.customDialog(type: AlertType.warning, description: hint);
        }
      }
    } catch (e,t){
      log(e.toString());
      log(t.toString());
    }
  }

  gotoCheckOutTsm(AttendanceModel attendanceModel, LocationAddressModel<Placemark?> locationData) async {
    try{
      if (attendanceModel.status == AttendanceStatus.checkInDone) {
        bool inside = true;
        // SrInfoModel sr = await SyncReadService().getSrInfo();
        int allowedIndex = 0;
        // if (attendanceModel.attendanceLocation != null && sr.userType == 41) {
        alerts.floatingLoading();
        List<PJPPlanDetails> list = [];
        var l = await PjpPlanAPI().getFullMonthPjpPlanAPI(forTodayOnly: true);
        if(l.status == ReturnedStatus.success) {
          List<PJPPlanDetails> allPjp = PJPPlanService().getPjpPlanListFromResponse(data: l.data["data"]);
          list.addAll(allPjp);

          InsideFencing insideFencing = InsideFencing(distance: 0, inside: true);
          if (list.isNotEmpty) {
            insideFencing = await LocationService(context).geoFencingWithDistanceReturn(
              lat: list.first.eveningLat ?? 0,
              lng: list.first.eveningLong ?? 0,
              allowedDistance: list.first.outTimeAllowableDistance ?? 0,
            );
          }

          inside = insideFencing.inside;

          print('inside data is::::: $inside');

          navigatorKey.currentState?.pop();

          if (inside) {
            navigatorKey.currentState?.pushNamed(CheckInOutUI.routeName, arguments: {
              attendanceStatusKey: AttendanceType.checkOut,
              attendanceIdKey: attendanceModel.id,
              "lat": list.isNotEmpty ? (list.first.eveningLat ?? 0) : locationData.lat,
              "lng": list.isNotEmpty ? (list.first.eveningLong ?? 0) : locationData.long,
              "depId": list.isNotEmpty ? (list.first.eveningDepId ?? 0) : 0,
            });
          } else {
            tryToCheckIn(location: locationData, checkOut: true, attendanceModel: attendanceModel);
            String lang = ref.watch(languageProvider);
            String distance = GlobalWidgets().numberEnglishToBangla(num: insideFencing.distance.toStringAsFixed(2), lang: lang, isNumber: true);

            String hint = "You are $distance meters away from your point location";
            if (lang != "en") {
              hint = "আপনি আপনার পয়েন্ট লোকেশন থেকে $distance মিটার দূরে আছেন";
            }

            alerts.customDialog(type: AlertType.warning, description: hint);
          }
        } else {
          navigatorKey.currentState?.pop();
          gotoCheckOut(attendanceModel, locationData);
          return;
        }
      }
    } catch (e,t){
      log(e.toString());
      log(t.toString());
    }
  }

  takeSelfie({required AttendanceType type}) async {
    SrInfoModel? sr = await FFServices().getSrInfo();
    Navigator.of(context).pushNamed(CameraScreen.routeName).then((value) async {
      if (value != null) {
        ref.read(attendanceSelfiePathProvider.notifier).state = value.toString();
      } else {
        alerts.customDialog(
          type: AlertType.error,
          message: 'Skipped capturing image',
          description: type == AttendanceType.checkIn ? 'You have to take a selfie for check in' : 'You have to take a selfie for check out',
        );
      }
    });
  }

  void tryToCheckIn({LocationAddressModel<Placemark?>? location, bool? checkOut, required AttendanceModel attendanceModel}) async {
    try {
      DateTime time = ref.read(attendanceDateTimeProvider);
      if (location != null) {
        await attendanceAPI.tryToCheckIn(time, location, context, checkOut ?? false, attendanceModel);
      }
    } catch (e, t) {
      Helper.dPrint(e.toString());
      Helper.dPrint(t.toString());
    }
  }

  void checkInOutProceed(
    AttendanceType type,
    LocationAddressModel<Placemark?>? location,
    int id, {
    required num lat,
    required num lng,
        int? depId,
  }) async {
    if (location != null) {
      ReturnedDataModel ret = ReturnedDataModel(status: ReturnedStatus.error);
      DateTime time = ref.read(attendanceDateTimeProvider);
      String desc = "Check In Completed";
      Color color = primary;
      IconData icon = Icons.location_on_outlined;
      String selfieData = ref.read(attendanceSelfiePathProvider);
      if (selfieData.isEmpty) {
        alerts.customDialog(type: AlertType.error, description: "Please provide a selfie");
        return;
      }

      alerts.floatingLoading();
      if (type == AttendanceType.checkIn) {
        ret = await attendanceAPI.checkIn(time:time,
            selfieData: selfieData,
            location:location, context:context, checkInLat:lat, checkInLng: lng, depId:depId);
      } else {
        if (id == -1) {
          return;
        }
        ret = await attendanceAPI.checkOut(
          selfieData: selfieData,
            time:time, location:location, id:id, context:context, checkOutLat: lat, checkOutLng: lng, depId:depId);
        desc = "Check Out Completed";
        color = primaryRed;
        icon = Icons.logout;
      }
      navigatorKey.currentState?.pop();
      if (ret.status == ReturnedStatus.success) {
        alerts.showModalWithWidget(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 3.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 46.sp,
                  color: color,
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                LangText(
                  desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: color, fontSize: 16.sp),
                ),
                SizedBox(
                  height: 5.h,
                ),
                TextButton(
                    onPressed: () {
                      navigatorKey.currentState?.pop();
                      navigatorKey.currentState?.pop();
                      navigatorKey.currentState?.pop();
                    },
                    child: LangText("Go back to home"))
              ],
            ),
          ),
        );
      } else {
        alerts.customDialog(type: AlertType.error, description: ret.errorMessage);
      }
    } else {
      alerts.customDialog(type: AlertType.error, description: "Location not found");
    }
  }
}
