

class SrInfoModel {
  late String accessToken;
  late String refreshToken;
  late int ffId;
  late String sbuId;
  late int? sectionId;
  late int? depId;
  late String? depIds;
  late String? email;
  late String srRoute;
  late int distributionHouseId;
  late String distributionHouseName;
  late String? companyName;
  late String? pointName;
  late String? contactNo;
  late String? pointContactNo;
  late String? nid;
  // late int? visitingFrequency;
  late int userType;
  late int? status;
  late String username;
  late String password;
  late String fullname;
  late int wpf;

  SrInfoModel(
      {required this.accessToken,
      required this.refreshToken,
      required this.ffId,
      required this.sbuId,
      required this.sectionId,
      required this.depId,
      this.email,
      this.contactNo,
      this.nid,
      // this.visitingFrequency,
      required this.userType,
      this.status,
      required this.username,
      required this.password,
      required this.fullname,
      required this.wpf,
      required this.srRoute,
      required this.distributionHouseId,
      required this.distributionHouseName});

  SrInfoModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    ffId = json['id'];
    sbuId = json['sbu_id'].toString();
    sectionId = json['section_id'];
    depId = json['dep_id'];
    depIds = json['dep_ids'].toString();;
    email = json['email'];
    contactNo = json['contact_no'];
    nid = json['nid'];
    // visitingFrequency = json['visiting_frequency'].toString().isEmpty?0 : int.parse(json['visiting_frequency'].toString());
    userType = json['user_type_id'];
    status = json['status'];
    username = json['email'];
    password = json['password'];
    fullname = json['name'];
    wpf = json['wpf'] ?? 0;
    srRoute = json['sr_route'] ?? '';
    // distributionHouseId = json['distribution_house_id'].toString().isEmpty? 0: int.parse(json['distribution_house_id'].toString());
    // distributionHouseName = json['distribution_house_name'];
    pointName = json['point_name'];
    pointContactNo = json['point_contact_no'];
    companyName = json['company_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    data['ff_id'] = ffId;
    data['sbu_id'] = sbuId;
    data['section_id'] = sectionId;
    data['dep_id'] = depId;
    data['email'] = email;
    data['contact_no'] = contactNo;
    data['nid'] = nid;
    // data['visiting_frequency'] = visitingFrequency;
    data['user_type'] = userType;
    data['status'] = status;
    data['username'] = username;
    data['password'] = password;
    data['fullname'] = fullname;
    data['sr_route'] = srRoute;
    data['distribution_house_id'] = distributionHouseId;
    data['distribution_house_name'] = distributionHouseName;
    return data;
  }
}
