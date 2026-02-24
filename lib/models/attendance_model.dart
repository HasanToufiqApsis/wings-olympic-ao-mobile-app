import '../constants/enum.dart';

class AttendanceModel {
  int id;
  AttendanceStatus status;
  List<AttendanceLocation>? attendanceLocation;
  String? inTime;
  String? outTime;

  AttendanceModel({
    required this.id,
    required this.status,
    this.attendanceLocation,
    this.inTime,
    this.outTime,
  });
}

class AttendanceLocation {
  // late bool enable;
  late int depId;
  late double lat;
  late double long;
  late double allowableDistance;
  String? dep_name;

  AttendanceLocation({
    // required this.enable,
    required this.depId,
    required this.lat,
    required this.long,
    required this.allowableDistance,
    this.dep_name,
  });

  AttendanceLocation.fromJson(Map json) {
    // , this.enable
    depId = json['dep_id'];
    dep_name = json['dep_name'];
    lat = double.parse(json['lat'].toString());
    long = double.parse(json['long'].toString());
    allowableDistance = double.parse(json['allowable_distance'].toString());
  }
}
