class BillDataModel {
  late int billStatus;
  late int billId;
  late int outletId;
  late String outletName;
  late String ownerName;
  late String billType;
  late int billTypeId;
  late String assetNo;
  late int skuId;
  late String assetType;
  late int assetTypeId;
  late int totalLight;
  late int total;

  BillDataModel({
    required this.billStatus,
    required this.billId,
    required this.outletId,
    required this.outletName,
    required this.ownerName,
    required this.billType,
    required this.billTypeId,
    required this.assetNo,
    required this.skuId,
    required this.assetType,
    required this.assetTypeId,
    required this.totalLight,
    required this.total,
  });

  BillDataModel.fromJson(Map<String, dynamic> json) {
    billStatus = json['bill_status'];
    billId = json['bill_id'];
    outletId = json['outlet_id'];
    outletName = json['outlet_name'];
    ownerName = json['owner_name'];
    billType = json['bill_type'];
    billTypeId = json['bill_type_id'];
    assetNo = json['asset_no'];
    skuId = json['sku_id'];
    assetType = json['asset_type'];
    assetTypeId = json['asset_type_id'];
    totalLight = json['total_light'];
    total = json['total'];
  }
}
