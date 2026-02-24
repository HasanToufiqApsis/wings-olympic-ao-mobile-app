class LeaveMovementManagementModelForTSM {
  String rowType;
  int id;
  int fieldForceId;
  String fieldForceName;
  int? leaveTypeId;
  String type;
  DateTime startDate;
  DateTime endDate;
  String reason;
  int totalDays;
  int status;
  int? tada;
  String? image;

  LeaveMovementManagementModelForTSM({
   required this.rowType,
   required this.id,
   required this.fieldForceId,
   required this.fieldForceName,
    this.leaveTypeId,
   required this.type,
   required this.startDate,
   required this.endDate,
   required this.reason,
   required this.totalDays,
   required this.status,
    this.tada,
    this.image,
  });

  factory LeaveMovementManagementModelForTSM.fromJson(Map json) {
    return LeaveMovementManagementModelForTSM(
      rowType: json['row_type'],
      id: json['id'],
      fieldForceId: json['field_force_id'],
      fieldForceName: json['field_force_name'],
      leaveTypeId: json['leave_type_id'],
      type: json['type'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      reason: json['reason'],
      totalDays: json['total_days'],
      status: json['status'],
      tada: json['ta_da'],
      image: json['image'],
    );
  }
}
