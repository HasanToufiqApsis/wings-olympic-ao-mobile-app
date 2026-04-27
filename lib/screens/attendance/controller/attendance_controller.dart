import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/services/sync_service.dart';

import '../../../api/attendance_api.dart';
import '../../../constants/constant_keys.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/attendance_model.dart';
import '../../../models/location_address_model.dart';
import '../../../models/returned_data_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/cameraScreen.dart';
import '../../../services/geo_location_service.dart';
import '../../../services/helper.dart';
import '../ui/check_in_out_ui.dart';

class AttendanceController {
  BuildContext context;
  WidgetRef ref;
  late Alerts alerts;
  late Timer timer;
  final AttendanceAPI attendanceAPI = AttendanceAPI();

  AttendanceController({required this.context, required this.ref}) {
    alerts = Alerts(context: context);
  }

  void disposeTimer() {
    timer.cancel();
  }

  void clock() {
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      ref.refresh(attendanceDateTimeProvider);
    });
  }

  Future<void> gotoCheckIn(
    AttendanceModel attendanceModel,
    LocationAddressModel<Placemark?> locationData,
  ) async {
    try {
      if (attendanceModel.status != AttendanceStatus.noAttendance) {
        return;
      }

      final geoFenceResult = await _resolveGeoFenceForAttendance(
        attendanceModel: attendanceModel,
        fallbackLocation: locationData,
      );

      if (geoFenceResult.inside) {
        navigatorKey.currentState?.pushNamed(
          CheckInOutUI.routeName,
          arguments: {
            attendanceStatusKey: AttendanceType.checkIn,
            attendanceIdKey: attendanceModel.id,
            "lat": geoFenceResult.lat,
            "lng": geoFenceResult.lng,
            "depId": geoFenceResult.depId,
          },
        );
        return;
      }

      tryToCheckIn(location: locationData, attendanceModel: attendanceModel);
      _showDistanceWarning(
        distance: geoFenceResult.distance,
        nearbyPointName: geoFenceResult.nearbyPointName,
        fallbackMessage: "You are outside your nearby point location",
      );
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
  }

  Future<void> gotoCheckOut(
    AttendanceModel attendanceModel,
    LocationAddressModel<Placemark?> locationData,
  ) async {
    try {
      if (attendanceModel.status != AttendanceStatus.checkInDone) {
        return;
      }

      final geoFenceResult = await _resolveGeoFenceForAttendance(
        attendanceModel: attendanceModel,
        fallbackLocation: locationData,
      );

      if (geoFenceResult.inside) {
        navigatorKey.currentState?.pushNamed(
          CheckInOutUI.routeName,
          arguments: {
            attendanceStatusKey: AttendanceType.checkOut,
            attendanceIdKey: attendanceModel.id,
            "lat": geoFenceResult.lat,
            "lng": geoFenceResult.lng,
            "depId": geoFenceResult.depId,
          },
        );
        return;
      }

      tryToCheckIn(
        location: locationData,
        checkOut: true,
        attendanceModel: attendanceModel,
      );
      _showDistanceWarning(
        distance: geoFenceResult.distance,
        nearbyPointName: geoFenceResult.nearbyPointName,
        fallbackMessage: "You are outside your nearby point location",
      );
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
  }

  Future<_AttendanceGeoFenceResult> _resolveGeoFenceForAttendance({
    required AttendanceModel attendanceModel,
    required LocationAddressModel<Placemark?> fallbackLocation,
  }) async {
    bool inside = true;
    int allowedIndex = 0;
    num nearestDistance = -1;
    String nearbyPointName = "";
    final locations = attendanceModel.attendanceLocation;

    if (locations != null && locations.isNotEmpty) {
      alerts.floatingLoading();
      inside = false;

      for (var i = 0; i < locations.length; i++) {
        final val = locations[i];
        final insideFencing = await LocationService(context)
            .geoFencingWithDistanceReturn(
              lat: val.lat,
              lng: val.long,
              allowedDistance: val.allowableDistance,
            );

        if (nearestDistance == -1 ||
            nearestDistance >= insideFencing.distance) {
          nearestDistance = insideFencing.distance;
          nearbyPointName = val.dep_name ?? '';
        }

        if (insideFencing.inside) {
          inside = true;
          allowedIndex = i;
          break;
        }
      }

      navigatorKey.currentState?.pop();
    }

    final hasLocations = locations != null && locations.isNotEmpty;
    final targetLocation = hasLocations && allowedIndex < locations.length
        ? locations[allowedIndex]
        : null;

    return _AttendanceGeoFenceResult(
      inside: inside,
      lat: targetLocation?.lat ?? fallbackLocation.lat,
      lng: targetLocation?.long ?? fallbackLocation.long,
      depId: targetLocation?.depId ?? 0,
      distance: nearestDistance,
      nearbyPointName: nearbyPointName,
    );
  }

  void _showDistanceWarning({
    required num distance,
    required String nearbyPointName,
    required String fallbackMessage,
  }) {
    final lang = ref.watch(languageProvider);

    if (distance < 0) {
      alerts.customDialog(
        type: AlertType.warning,
        description: fallbackMessage,
      );
      return;
    }

    final formattedDistance = GlobalWidgets().numberEnglishToBangla(
      num: distance.toStringAsFixed(2),
      lang: lang,
      isNumber: true,
    );

    String hint =
        "You are $formattedDistance meters away from your nearby point location";
    if (lang != "en") {
      hint =
          "আপনি আপনার নিকটস্থ পয়েন্ট লোকেশন $nearbyPointName থেকে $distance মিটার দূরে আছেন";
    }

    alerts.customDialog(type: AlertType.warning, description: hint);
  }

  Future<void> takeSelfie({required AttendanceType type}) async {
    Navigator.of(context).pushNamed(CameraScreen.routeName, arguments: CameraLensDirection.front).then((value) async {
      if (value != null) {
        ref.read(attendanceSelfiePathProvider.notifier).state = value
            .toString();
      } else {
        alerts.customDialog(
          type: AlertType.error,
          message: 'Skipped capturing image',
          description: type == AttendanceType.checkIn
              ? 'You have to take a selfie for check in'
              : 'You have to take a selfie for check out',
        );
      }
    });
  }

  void tryToCheckIn({
    LocationAddressModel<Placemark?>? location,
    bool? checkOut,
    required AttendanceModel attendanceModel,
  }) async {
    try {
      final time = ref.read(attendanceDateTimeProvider);
      if (location != null) {
        await attendanceAPI.tryToCheckIn(
          time,
          location,
          context,
          checkOut ?? false,
          attendanceModel,
        );
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
      final time = ref.read(attendanceDateTimeProvider);
      String desc = "Check In Completed";
      Color color = primary;
      IconData icon = Icons.location_on_outlined;
      final selfieData = ref.read(attendanceSelfiePathProvider);
      if (selfieData.isEmpty) {
        alerts.customDialog(
          type: AlertType.error,
          description: "Please provide a selfie",
        );
        return;
      }

      alerts.floatingLoading();
      if (type == AttendanceType.checkIn) {
        ret = await attendanceAPI.checkIn(
          time: time,
          selfieData: selfieData,
          location: location,
          context: context,
          checkInLat: lat,
          checkInLng: lng,
          depId: depId,
        );
        if(ret.status == ReturnedStatus.success) {
          SyncService().updateAttendanceCheckInStatus(checkedIn: true);
          ref.refresh(homeDashboardAttendanceLockedProvider);
        }
      } else {
        if (id == -1) {
          return;
        }
        ret = await attendanceAPI.checkOut(
          selfieData: selfieData,
          time: time,
          location: location,
          id: id,
          context: context,
          checkOutLat: lat,
          checkOutLng: lng,
          depId: depId,
        );
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
                Icon(icon, size: 46.sp, color: color),
                SizedBox(height: 1.5.h),
                LangText(
                  desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: color, fontSize: 16.sp),
                ),
                SizedBox(height: 5.h),
                TextButton(
                  onPressed: () {
                    navigatorKey.currentState?.pop();
                    navigatorKey.currentState?.pop();
                    navigatorKey.currentState?.pop();
                  },
                  child: LangText("Go back to home"),
                ),
              ],
            ),
          ),
        );
      } else {
        alerts.customDialog(
          type: AlertType.error,
          description: ret.errorMessage,
        );
      }
    } else {
      alerts.customDialog(
        type: AlertType.error,
        description: "Location not found",
      );
    }
  }
}

class _AttendanceGeoFenceResult {
  final bool inside;
  final num lat;
  final num lng;
  final int depId;
  final num distance;
  final String nearbyPointName;

  const _AttendanceGeoFenceResult({
    required this.inside,
    required this.lat,
    required this.lng,
    required this.depId,
    required this.distance,
    required this.nearbyPointName,
  });
}
