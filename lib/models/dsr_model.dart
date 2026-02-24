class DsrModel {
  int? id;
  String? fullname;
  String? username;
  String? contactNo;

  DsrModel({this.id, this.fullname, this.username, this.contactNo});

  DsrModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    username = json['username'];
    contactNo = json['contact_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullname'] = this.fullname;
    data['username'] = this.username;
    data['contact_no'] = this.contactNo;
    return data;
  }
}
