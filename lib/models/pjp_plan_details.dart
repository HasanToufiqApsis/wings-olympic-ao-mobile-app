import 'dart:developer';

import '../constants/enum.dart';

// class PJPPlanDetails {
//   int? id;
//   DateTime? date;
//   int? morningDepId;
//   int? eveningDepId;
//   int? userId;
//   String? name;
//   String? morningCustomerName;
//   String? eveningCustomerName;
//   String? morningDepName;
//   String? eveningDepName;
//   String? inTime;
//   String? outTime;
//   double? inTimeLat;
//   double? inTimeLong;
//   double? outTimeLat;
//   double? outTimeLong;
//   PjpStatusType? status;
//
//   PJPPlanDetails(
//       {this.id,
//       this.date,
//       this.morningDepId,
//       this.eveningDepId,
//       this.userId,
//       this.name,
//       this.morningCustomerName,
//       this.eveningCustomerName,
//       this.morningDepName,
//       this.eveningDepName,
//       this.inTime,
//       this.outTime,
//       this.inTimeLat,
//       this.inTimeLong,
//       this.outTimeLat,
//       this.outTimeLong,
//       this.status = PjpStatusType.waiting});
//
//   PJPPlanDetails.fromJson(Map<String, dynamic> json, String dateKey) {
//     id = json['id'];
//     date = DateTime.parse(dateKey);
//     morningDepId = json['morning_dep_id'];
//     eveningDepId = json['evening_dep_id'];
//     userId = json['user_id'];
//     name = json['name'];
//     morningCustomerName = json['morning_customer_name'];
//     eveningCustomerName = json['evening_customer_name'];
//     morningDepName = json['morning_dep_name'];
//     eveningDepName = json['evening_dep_name'];
//     inTime = json['in_time'];
//     outTime = json['out_time'];
//     inTimeLat = json['in_time_lat'];
//     inTimeLong = json['in_time_long'];
//     outTimeLat = json['out_time_lat'];
//     outTimeLong = json['out_time_long'];
//
//     if (inTime == null && outTime == null) {
//       status = PjpStatusType.waiting;
//     }
//     if (inTime == null &&
//         outTime == null &&
//         date?.month == DateTime.now().month &&
//         date?.day == DateTime.now().day) {
//       status = PjpStatusType.todayWaiting;
//     }
//   }
// }

class PJPPlanDetails {
  int? id;
  DateTime? date;
  int? morningDepId;
  int? eveningDepId;
  double? morningLat;
  double? morningLong;
  double? eveningLat;
  double? eveningLong;
  int? userId;
  String? name;
  String? morningCustomerName;
  String? eveningCustomerName;
  String? morningDepName;
  String? eveningDepName;
  DateTime? inTime;
  DateTime? outTime;
  String? inTimeLat;
  String? inTimeLong;
  String? outTimeLat;
  String? outTimeLong;
  String? category;
  String? remark;
  PjpStatusType? status;
  int? intTimeAllowableDistance;
  int? outTimeAllowableDistance;

  PJPPlanDetails({
    this.id,
    this.date,
    this.morningDepId,
    this.eveningDepId,
    this.morningLat,
    this.morningLong,
    this.eveningLat,
    this.eveningLong,
    this.userId,
    this.name,
    this.morningCustomerName,
    this.eveningCustomerName,
    this.morningDepName,
    this.eveningDepName,
    this.inTime,
    this.outTime,
    this.inTimeLat,
    this.inTimeLong,
    this.outTimeLat,
    this.outTimeLong,
    this.category,
    this.remark,
    this.intTimeAllowableDistance,
    this.outTimeAllowableDistance,
    this.status = PjpStatusType.waiting
  });

  PJPPlanDetails.fromJson(Map<String, dynamic> json, String dateKey) {
    id = json['id'];
    date = DateTime.parse(dateKey);
    morningDepId = json['morning_dep_id'];
    eveningDepId = json['evening_dep_id'];
    morningLat = json['morning_lat']==null ? null : double.parse(json['morning_lat']);
    morningLong = json['morning_long']==null ? null : double.parse(json['morning_long']);
    eveningLat = json['evening_lat']==null ? null : double.parse(json['evening_lat']);
    eveningLong = json['evening_long']==null ? null : double.parse(json['evening_long']);
    userId = json['user_id'];
    name = json['name'];
    morningCustomerName = json['morning_customer_name'];
    eveningCustomerName = json['evening_customer_name'];
    morningDepName = json['morning_dep_name'];
    eveningDepName = json['evening_dep_name'];
    inTime = json['in_time'] ==null? null : DateTime.parse(json['in_time']);
    outTime = json['out_time'] ==null? null : DateTime.parse(json['out_time']);
    // outTime = json['out_time'];
    inTimeLat = json['in_time_lat'];
    inTimeLong = json['in_time_long'];
    outTimeLat = json['out_time_lat'];
    outTimeLong = json['out_time_long'];
    category = json['category'];
    remark = json['remark'];
    intTimeAllowableDistance = json['int_time_allowable_distance'] ?? 100;
    outTimeAllowableDistance = json['out_time_allowable_distance'] ?? 100;

    final now = DateTime.now();

    if (inTime != null && outTime != null) {
      status = PjpStatusType.done;
    }

    if ((inTime == null || outTime == null) && (DateTime(now.year, now.month, now.day).isAfter(DateTime(date?.year??0, date?.month??0, date?.day??0)))) {
      status = PjpStatusType.missed;
    }

    if (DateTime(now.year, now.month, now.day).isBefore(DateTime(date?.year??0, date?.month??0, date?.day??0))) {
      status = PjpStatusType.waiting;
    }

    if ((inTime == null ||
        outTime == null) &&
        date?.year == DateTime.now().year &&
        date?.month == DateTime.now().month &&
        date?.day == DateTime.now().day) {
      status = PjpStatusType.todayWaiting;
    }

    log("message ::: ${date} : $status");
  }
}
