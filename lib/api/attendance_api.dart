import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';

import '../constants/constant_variables.dart';
import '../constants/enum.dart';
import '../models/attendance_model.dart';
import '../models/location_address_model.dart';
import '../models/returned_data_model.dart';
import '../models/sr_info_model.dart';
import '../services/attendance_location_service.dart';
import '../services/geo_location_service.dart';
import '../services/helper.dart';
import '../services/sync_read_service.dart';
import 'global_http.dart';
import 'links.dart';

class AttendanceAPI {
  SyncReadService syncReadService = SyncReadService();

  Future<AttendanceModel> getAttendanceStatus(DateTime time) async {
    try {
      SrInfoModel sr = await syncReadService.getSrInfo();
      String url =
          "${Links.baseUrl}${Links.attendanceUrlTsm}?date=${apiDateFormat.format(time)}&field_force_id=${sr.ffId}&dep_id=${sr.depId ?? sr.depIds}&user_type=${sr.userType}";
      ReturnedDataModel returnedDataModel = await GlobalHttp(
        uri: url,
        httpType: HttpType.get,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
      if (returnedDataModel.status == ReturnedStatus.success) {
        List<AttendanceLocation> attendanceLocation = [];
        if (returnedDataModel.data.containsKey("data")) {
          Map attendanceData = returnedDataModel.data["data"];

          /// geo fencing info
          if (attendanceData.containsKey("geo_fencing_enable")) {
            if (attendanceData["geo_fencing_enable"] == 1) {
              if (attendanceData.containsKey("depLocation")) {
                attendanceData['depLocation'].forEach((v) {
                  attendanceLocation.add(AttendanceLocation.fromJson(v));
                });
                // attendanceLocation = AttendanceLocation.fromJson(attendanceData["depLocation"]);
              }
            }
          }

          /// attendance info
          if (attendanceData.containsKey('attendance')) {
            try {
              if (attendanceData['attendance'].containsKey('in_time_lat') &&
                  attendanceData['attendance'].containsKey('in_time_long')) {
                if ((attendanceData['attendance']['in_time_lat'] != null &&
                        attendanceData['attendance']['in_time_lat'] != '') &&
                    (attendanceData['attendance']['in_time_long'] != null &&
                        attendanceData['attendance']['in_time_long'] != '')) {
                  LocationAddressModel<Placemark?>? location =
                      await AttendanceLocationService()
                          .getTargetedLocationAndAddress(
                            latitude:
                                double.tryParse(
                                  attendanceData['attendance']['in_time_lat'],
                                ) ??
                                0,
                            longitude:
                                double.tryParse(
                                  attendanceData['attendance']['in_time_long'],
                                ) ??
                                0,
                          );
                  attendanceMap[checkedInAddressKey] =
                      '${location?.address?.street ?? ''}, ${location?.address?.subLocality ?? ''}';
                }
              }
            } catch (e, t) {
              Helper.dPrint(e.toString());
              Helper.dPrint(t.toString());
            }
            try {
              if (attendanceData['attendance'].containsKey('out_time_lat') &&
                  attendanceData['attendance'].containsKey('out_time_long')) {
                if ((attendanceData['attendance']['out_time_lat'] != null &&
                        attendanceData['attendance']['out_time_lat'] != '') &&
                    (attendanceData['attendance']['out_time_long'] != null &&
                        attendanceData['attendance']['out_time_long'] != '')) {
                  LocationAddressModel<Placemark?>? location =
                      await AttendanceLocationService()
                          .getTargetedLocationAndAddress(
                            latitude:
                                double.tryParse(
                                  attendanceData['attendance']['out_time_lat'],
                                ) ??
                                0,
                            longitude:
                                double.tryParse(
                                  attendanceData['attendance']['out_time_long'],
                                ) ??
                                0,
                          );
                  attendanceMap[checkedOutAddressKey] =
                      '${location?.address?.street ?? ''}, ${location?.address?.subLocality ?? ''}';
                }
              }
            } catch (e, t) {
              Helper.dPrint(e.toString());
              Helper.dPrint(t.toString());
            }
            if (attendanceData["attendance"].containsKey("status") &&
                attendanceData["attendance"].containsKey("id")) {
              if (attendanceData["attendance"]["status"] == 2) {
                return AttendanceModel(
                  id: attendanceData["attendance"]["id"],
                  status: AttendanceStatus.attendanceDone,
                  attendanceLocation: attendanceLocation,
                  inTime: attendanceData["attendance"]["in_time"] ?? '',
                  outTime: attendanceData["attendance"]["out_time"] ?? '',
                );
              } else if (attendanceData["attendance"]["status"] == 1) {
                return AttendanceModel(
                  id: attendanceData["attendance"]["id"],
                  status: AttendanceStatus.checkInDone,
                  attendanceLocation: attendanceLocation,
                  inTime: attendanceData["attendance"]["in_time"] ?? '',
                  outTime: attendanceData["attendance"]["out_time"] ?? '',
                );
              }
            }
          } else {
            return AttendanceModel(
              id: -1,
              status: AttendanceStatus.noAttendance,
              attendanceLocation: attendanceLocation,
              inTime: '',
              outTime: '',
            );
          }
        }
      }
    } catch (e, s) {
      print("inside AttendanceAPI getAttendanceStatus $e $s");
    }
    return AttendanceModel(id: -1, status: AttendanceStatus.attendanceDone);
  }

  Future<ReturnedDataModel> checkIn({
    required DateTime time,
    required String selfieData,
    required LocationAddressModel<Placemark?> location,
    required BuildContext context,
    required num checkInLat,
    required num checkInLng,
    int? depId,
  }) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(
      status: ReturnedStatus.error,
    );
    try {
      SrInfoModel sr = await syncReadService.getSrInfo();
      String url = "${Links.baseUrl}${Links.attendanceUrl}";
      num? distance = await LocationService(
        context,
      ).getDistance(checkInLat, checkInLng);
      Map payload = {
        "dep_id": sr.depId ?? 0, //suggested by sarowar vai
        "field_force_id": sr.ffId,
        "date": apiDateFormat.format(time),
        "in_time": apiDateTimeFormat.format(time),
        "in_time_lat": location.lat,
        "in_time_long": location.long,
        "status": 1,
        "in_distance": distance ?? 0,
        "user_type": sr.userType,
        "check_in_dep_id": depId,
      };

      log('attendance payload is :: $payload');
      log('attendance url is :: $url');

      returnedDataModel = await GlobalHttp(
        uri: url,
        httpType: HttpType.file,
        accessToken: sr.accessToken,
        imagePath: selfieData,
        refreshToken: sr.refreshToken,
        otherDataWithImage: payload,
        imageHeader: 'check_in_image'
      ).fetch();
    } catch (e, s) {
      print("inside AttendanceAPI getAttendanceStatus $e $s");
    }
    return returnedDataModel;
  }

  Future<ReturnedDataModel> tryToCheckIn(
    DateTime time,
    LocationAddressModel<Placemark?> location,
    BuildContext context,
    bool checkOut,
    AttendanceModel attendanceModel,
  ) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(
      status: ReturnedStatus.error,
    );
    try {
      SrInfoModel sr = await syncReadService.getSrInfo();

      ///only user 41 (so) can do this check in
      if (sr.userType == 41) {
        String url = "${Links.baseUrl}${Links.attendanceUrl}";
        final locations = attendanceModel.attendanceLocation;
        num? distance = await LocationService(context).getDistance(
          (locations != null && locations.isNotEmpty)
              ? locations[0].lat
              : location.lat,
          (locations != null && locations.isNotEmpty)
              ? locations[0].long
              : location.long,
        );
        Map<String, String> payload = {
          "dep_id": sr.depId.toString(),
          "field_force_id": sr.ffId.toString(),
          "date": apiDateFormat.format(time),
          if (!checkOut) "in_time": apiDateTimeFormat.format(time),
          if (!checkOut) "in_time_lat": location.lat.toString(),
          if (!checkOut) "in_time_long": location.long.toString(),
          if (checkOut) "out_time": apiDateTimeFormat.format(time),
          if (checkOut) "out_time_lat": location.lat.toString(),
          if (checkOut) "out_time_long": location.long.toString(),
          "status": 0.toString(),
          if (!checkOut) "in_distance": (distance ?? 0).toString(),
          if (checkOut) "out_distance": (distance ?? 0).toString(),
        };
        log('check-in response ${payload}\n${returnedDataModel.status}');
        // AttendanceRepository().tryToCheckIn(
        //   body: payload,
        //   uri: url,
        //   accessToken: sr.accessToken,
        //   refreshToken: sr.refreshToken,
        // );
        returnedDataModel = await GlobalHttp(
          uri: url,
          httpType: HttpType.file,
          imageRequestType: HttpType.post,
          accessToken: sr.accessToken,
          refreshToken: sr.refreshToken,
          // body: jsonEncode(payload),
          otherDataWithImage: payload,
        ).fetch();
        log('check-in response ${returnedDataModel.status}');
      }
    } catch (e, s) {
      print("inside AttendanceAPI getAttendanceStatus $e $s");
    }
    return returnedDataModel;
  }

  Future<ReturnedDataModel> checkOut({
    required DateTime time,
    required LocationAddressModel<Placemark?> location,
    required int id,
    required String selfieData,
    required BuildContext context,
    required num checkOutLat,
    required num checkOutLng,
    int? depId,
  }) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(
      status: ReturnedStatus.error,
    );
    try {
      SrInfoModel sr = await syncReadService.getSrInfo();
      String url = "${Links.baseUrl}${Links.attendanceUrl}";
      num? distance = await LocationService(
        context,
      ).getDistance(checkOutLat, checkOutLng);
      Map payload = {
        "id": id,
        "out_time": apiDateTimeFormat.format(time),
        "out_time_lat": location.lat,
        "out_time_long": location.long,
        "status": 2,
        "out_distance": distance ?? 0,
        "check_out_dep_id": depId,
      };

      returnedDataModel = await GlobalHttp(
        uri: url,
        httpType: HttpType.file,
        imageRequestType: HttpType.patch,
        imagePath: selfieData,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
        otherDataWithImage: payload,
        imageHeader: "check_out_image",
      ).fetch();
    } catch (e, s) {
      print("inside AttendanceAPI getAttendanceStatus $e $s");
    }
    return returnedDataModel;
  }
}
