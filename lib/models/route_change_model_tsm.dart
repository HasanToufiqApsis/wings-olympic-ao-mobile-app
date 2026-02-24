class ChangeRouteTSMModel {
  int changeRequestId;
  String fieldForceName;
  int fieldForceId;
  String presentRoute;
  String requestRoute;
  int status;
  DateTime effectiveStartDate;
  DateTime effectiveEndDate;
  String depName;
  String sectionName;

  ChangeRouteTSMModel({
   required this.changeRequestId,
   required this.fieldForceName,
   required this.fieldForceId,
   required this.presentRoute,
   required this.requestRoute,
   required this.status,
   required this.effectiveStartDate,
   required this.effectiveEndDate,
   required this.depName,
   required this.sectionName,
  });

  factory ChangeRouteTSMModel.fromJson(Map json) {
    return ChangeRouteTSMModel(
      changeRequestId: json['change_request_id'],
      fieldForceName: json['field_force_name'],
      fieldForceId: json['field_force_id'],
      presentRoute: json['present_route'],
      requestRoute: json['request_route'],
      status: json['status'],
      effectiveStartDate: DateTime.parse(json['effective_startdate']),
      effectiveEndDate: DateTime.parse(json['effective_enddate']),
      depName: json['dep_name'],
      sectionName: json['section_name'],
    );
  }
}
