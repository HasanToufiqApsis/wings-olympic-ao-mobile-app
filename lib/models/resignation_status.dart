class ResignationModel {
  final bool success;
  final List<ResignationData> data;
  final Meta meta;

  ResignationModel({
    required this.success,
    required this.data,
    required this.meta,
  });

  factory ResignationModel.fromJson(Map<String, dynamic> json) {
    return ResignationModel(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? List<ResignationData>.from(
          json['data'].map((x) => ResignationData.fromJson(x)))
          : [],
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : Meta.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((x) => x.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

class ResignationData {
  final int id;
  final int fieldForceId;
  final String employeeName;
  final String employeeEmail;
  final String remarks;
  final String supervisorRemarks;
  final String submissionDate;
  final String lastWorkingDate;
  final String noticePeriodEndDate;
  final String status;
  final int currentApprovalStage;
  final int totalApprovalStages;
  final dynamic approvalSummary;
  final String createdAt;
  final String updatedAt;

  ResignationData({
    required this.id,
    required this.fieldForceId,
    required this.employeeName,
    required this.employeeEmail,
    required this.remarks,
    required this.supervisorRemarks,
    required this.submissionDate,
    required this.lastWorkingDate,
    required this.noticePeriodEndDate,
    required this.status,
    required this.currentApprovalStage,
    required this.totalApprovalStages,
    this.approvalSummary,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ResignationData.fromJson(Map<String, dynamic> json) {
    return ResignationData(
      id: json['id'] ?? 0,
      fieldForceId: json['field_force_id'] ?? 0,
      employeeName: json['employee_name'] ?? '',
      employeeEmail: json['employee_email'] ?? '',
      remarks: json['remarks'] ?? '',
      supervisorRemarks: json['approval_remarks'] ?? '',
      submissionDate: json['submission_date'] ?? '',
      lastWorkingDate: json['last_working_date'] ?? '',
      noticePeriodEndDate: json['notice_period_end_date'] ?? '',
      status: json['status'] ?? '',
      currentApprovalStage: json['current_approval_stage'] ?? 0,
      totalApprovalStages: json['total_approval_stages'] ?? 0,
      approvalSummary: json['approvalSummary'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'field_force_id': fieldForceId,
      'employee_name': employeeName,
      'employee_email': employeeEmail,
      'remarks': remarks,
      'approval_remarks': supervisorRemarks,
      'submission_date': submissionDate,
      'last_working_date': lastWorkingDate,
      'notice_period_end_date': noticePeriodEndDate,
      'status': status,
      'current_approval_stage': currentApprovalStage,
      'total_approval_stages': totalApprovalStages,
      'approvalSummary': approvalSummary,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Meta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  Meta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
    );
  }

  factory Meta.empty() => Meta(total: 0, page: 1, limit: 1, totalPages: 1);

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
    };
  }
}