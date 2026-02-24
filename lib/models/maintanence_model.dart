import '../constants/constant_variables.dart';

class MaintenanceModel {
  int? id;
  String? assetType;
  String? outletName;
  String? outletCode;
  String? contactNo;
  String? maintainanceId;
  String? assetNo;
  DateTime? date;
  String? description;

  MaintenanceModel({
    this.id,
    this.assetType,
    this.outletName,
    this.outletCode,
    this.contactNo,
    this.maintainanceId,
    this.assetNo,
    this.date,
    this.description,
  });

  MaintenanceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    assetType = json['asset_type'];
    outletName = json['outlet_name'];
    outletCode = json['outlet_code'];
    contactNo = json['contact_no'];
    maintainanceId = json['maintainance_id'];
    assetNo = json['asset_no'];
    date = DateTime.tryParse(json['date']);
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['asset_type'] = assetType;
    data['outlet_name'] = outletName;
    data['outlet_code'] = outletCode;
    data['contact_no'] = contactNo;
    data['maintainance_id'] = maintainanceId;
    data['asset_no'] = assetNo;
    data['date'] = date;
    data['description'] = description;
    return data;
  }

  String get dateTime {
    return maintenanceDateFormat.format(date??DateTime.now());
  }
}
