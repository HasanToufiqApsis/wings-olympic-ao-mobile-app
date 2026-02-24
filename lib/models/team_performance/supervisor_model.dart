class SupervisorModel {
  final int? id;
  final String? name;
  final int? parentId;
  final int? ffId;
  final String? fullName;
  final String? contactNo;
  final int? totalSr;

  SupervisorModel({
    required this.id,
    required this.name,
    required this.parentId,
    required this.ffId,
    required this.fullName,
    required this.contactNo,
    required this.totalSr,
  });

  factory SupervisorModel.fromJson(Map<String, dynamic> json) {
    return SupervisorModel(
      id: json['id'],
      name: json['name'],
      parentId: json['parent_id'],
      ffId: json['ff_id'],
      fullName: json['fullname'],
      contactNo: json['contact_no'],
      totalSr: json['total_sr'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['parent_id'] = parentId;
    data['ff_id'] = ffId;
    data['fullname'] = fullName;
    data['contact_no'] = contactNo;
    data['total_sr'] = totalSr;
    return data;
  }
}