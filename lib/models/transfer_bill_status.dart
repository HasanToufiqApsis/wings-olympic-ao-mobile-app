class TransferBillModel {
  final String? message;
  final bool? success;
  final List<TransferBillData>? data;

  TransferBillModel({this.message, this.success, this.data});

  factory TransferBillModel.fromJson(Map<String, dynamic> json) {
    return TransferBillModel(
      message: json['message'] as String?,
      success: json['success'] as bool?,
        data: (json['data'] as List?)
            ?.map((e) => TransferBillData.fromJson(e))
            .toList() ??
            [],
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'success': success,
    if (data != null) 'data': data!.map((e) => e.toJson()).toList(),
  };
}

class TransferBillData {
  final int? id;
  final int? fieldForceId;
  final String? fromLocation;
  final String? toLocation;
  final String? transferDate;
  final String? amount;
  final String? description;
  final String? imagePath;
  final String? billCopyPath;
  final String? approvalRequestRefId;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final FieldForce? fieldForce;

  TransferBillData({
    this.id,
    this.fieldForceId,
    this.fromLocation,
    this.toLocation,
    this.transferDate,
    this.amount,
    this.description,
    this.imagePath,
    this.billCopyPath,
    this.approvalRequestRefId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.fieldForce,
  });

  factory TransferBillData.fromJson(Map<String, dynamic> json) {
    return TransferBillData(
      id: json['id'] as int?,
      fieldForceId: json['field_force_id'] as int?,
      fromLocation: json['from_location'] as String?,
      toLocation: json['to_location'] as String?,
      transferDate: json['transfer_date'] as String?,
      amount: json['amount'] as String?,
      description: json['description'] as String?,
      imagePath: json['image_path'] as String?,
      billCopyPath: json['bill_copy_path'] as String?,
      approvalRequestRefId: json['approval_request_ref_id'] as String?,
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      fieldForce: json['fieldForce'] != null
          ? FieldForce.fromJson(json['fieldForce'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'field_force_id': fieldForceId,
    'from_location': fromLocation,
    'to_location': toLocation,
    'transfer_date': transferDate,
    'amount': amount,
    'description': description,
    'image_path': imagePath,
    'bill_copy_path': billCopyPath,
    'approval_request_ref_id': approvalRequestRefId,
    'status': status,
    'created_at': createdAt,
    'updated_at': updatedAt,
    if (fieldForce != null) 'fieldForce': fieldForce!.toJson(),
  };
}

class FieldForce {
  final int? id;
  final String? sbuId;
  final int? depId;
  final String? fullname;
  final String? email;
  final String? password;
  final String? username;
  final String? contactNo;
  final String? enroll;
  final String? nid;
  final String? birthCertificateNo;
  final String? visitingFrequency;
  final int? userType;
  final String? employeeId;
  final String? joiningDate;
  final String? dob;
  final int? referrerId;
  final int? status;
  final String? employmentStatus;
  final String? resignationDate;
  final String? lastWorkingDate;
  final int? createdBy;
  final int? updatedBy;
  final int? isPermanent;
  final String? permanentDate;
  final String? createdAt;
  final String? updatedAt;

  FieldForce({
    this.id,
    this.sbuId,
    this.depId,
    this.fullname,
    this.email,
    this.password,
    this.username,
    this.contactNo,
    this.enroll,
    this.nid,
    this.birthCertificateNo,
    this.visitingFrequency,
    this.userType,
    this.employeeId,
    this.joiningDate,
    this.dob,
    this.referrerId,
    this.status,
    this.employmentStatus,
    this.resignationDate,
    this.lastWorkingDate,
    this.createdBy,
    this.updatedBy,
    this.isPermanent,
    this.permanentDate,
    this.createdAt,
    this.updatedAt,
  });

  factory FieldForce.fromJson(Map<String, dynamic> json) {
    return FieldForce(
      id: json['id'] as int?,
      sbuId: json['sbu_id'] as String?,
      depId: json['dep_id'] as int?,
      fullname: json['fullname'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      username: json['username'] as String?,
      contactNo: json['contact_no'] as String?,
      enroll: json['enroll'] as String?,
      nid: json['nid'] as String?,
      birthCertificateNo: json['birth_certificate_no'] as String?,
      visitingFrequency: json['visiting_frequency'] as String?,
      userType: json['user_type'] as int?,
      employeeId: json['employee_id'] as String?,
      joiningDate: json['joining_date'] as String?,
      dob: json['dob'] as String?,
      referrerId: json['referrer_id'] as int?,
      status: json['status'] as int?,
      employmentStatus: json['employment_status'] as String?,
      resignationDate: json['resignation_date'] as String?,
      lastWorkingDate: json['last_working_date'] as String?,
      createdBy: json['created_by'] as int?,
      updatedBy: json['updated_by'] as int?,
      isPermanent: json['is_permanent'] as int?,
      permanentDate: json['permanent_date'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sbu_id': sbuId,
    'dep_id': depId,
    'fullname': fullname,
    'email': email,
    'password': password,
    'username': username,
    'contact_no': contactNo,
    'enroll': enroll,
    'nid': nid,
    'birth_certificate_no': birthCertificateNo,
    'visiting_frequency': visitingFrequency,
    'user_type': userType,
    'employee_id': employeeId,
    'joining_date': joiningDate,
    'dob': dob,
    'referrer_id': referrerId,
    'status': status,
    'employment_status': employmentStatus,
    'resignation_date': resignationDate,
    'last_working_date': lastWorkingDate,
    'created_by': createdBy,
    'updated_by': updatedBy,
    'is_permanent': isPermanent,
    'permanent_date': permanentDate,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

