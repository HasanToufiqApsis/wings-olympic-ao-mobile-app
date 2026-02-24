class LeaveManagementModel {
  List<LeaveManagementData> leaveData = [];
  List<LeaveManagementTypes> leaveTypes = [];

  LeaveManagementModel({required this.leaveData, required this.leaveTypes});

  LeaveManagementModel.fromJson(Map<String, dynamic> json) {
    if (json['types'] != null) {
      leaveTypes = <LeaveManagementTypes>[];
      json['types'].forEach((v) {
        leaveTypes.add(LeaveManagementTypes.fromJson(v));
      });
    }
    if (json['leaves'] != null) {
      leaveData = <LeaveManagementData>[];
      json['leaves'].forEach((v) {
        var ld = LeaveManagementData.fromJson(v);
        if (leaveTypes.isNotEmpty) {
          int index = leaveTypes.indexWhere((element) =>
              (element.id == ld.leaveTypeId)); // Match by ID now
          if (index != -1) {
            // Logic for calculating enjoyed leaves might need check
            // assuming approved status string
            if (ld.approveStatus.toLowerCase() == 'approved') {
              leaveTypes[index].leaveEnjoyed += ld.totalDays;
            }
          }
        }
        leaveData.add(ld);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['leaves'] = leaveData.map((v) => v.toJson()).toList();
    data['types'] = leaveTypes.map((v) => v.toJson()).toList();
    return data;
  }
}

class LeaveManagementData {
  late int id;
  late int fieldForceId;
  late int leaveTypeId;
  late String startDate;
  late String endDate;
  late int totalDays;
  late String reason;
  late String approveStatus;
  late String createdAt;
  LeaveType? leaveType;

  // Constructor
  LeaveManagementData({
    required this.id,
    required this.fieldForceId,
    required this.leaveTypeId,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.reason,
    required this.approveStatus,
    required this.createdAt,
    this.leaveType,
  });

  LeaveManagementData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fieldForceId = json['field_force_id'];
    leaveTypeId = json['leave_type_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    totalDays = json['total_days'];
    reason = json['reason'];
    approveStatus = json['approve_status'] ?? 'pending';
    createdAt = json['created_at'];
    leaveType = json['leave_type'] != null
        ? LeaveType.fromJson(json['leave_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['field_force_id'] = fieldForceId;
    data['leave_type_id'] = leaveTypeId;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['total_days'] = totalDays;
    data['reason'] = reason;
    data['approve_status'] = approveStatus;
    data['created_at'] = createdAt;
    if (leaveType != null) {
      data['leave_type'] = leaveType!.toJson();
    }
    return data;
  }
}

class LeaveType {
  late int id;
  late String displayLabel;
  late String slug;

  LeaveType({required this.id, required this.displayLabel, required this.slug});

  LeaveType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayLabel = json['display_label'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['display_label'] = displayLabel;
    data['slug'] = slug;
    return data;
  }
}

class LeaveManagementTypes {
  late int id;
  late String type;
  String? leaveBalance;
  String? slug;
  late int leaveEnjoyed;

  LeaveManagementTypes({
    required this.id,
    required this.type,
    this.leaveBalance,
    this.slug,
    required this.leaveEnjoyed,
  });

  LeaveManagementTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    leaveBalance = json['leave_balance'].toString();
    slug = json['slug'];
    leaveEnjoyed = 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['leave_balance'] = leaveBalance;
    data['slug'] = slug;
    return data;
  }
}


