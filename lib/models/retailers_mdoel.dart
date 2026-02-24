class RetailersModel {
  late int id;
  late String outletName;
  late String outletNameBn;
  late String outletCode;
  late String oWNER;
  late String contact;
  late String nid;
  late String address;
  late int priceGroup;
  // late int qcPriceGroup;
  // late String sbuId;
  late int depId;
  late int sectionId;

  RetailersModel({
    required this.id,
    required this.outletName,
    required this.outletNameBn,
    required this.outletCode,
    required this.oWNER,
    required this.contact,
    required this.nid,
    required this.address,
    required this.priceGroup,
    // required this.qcPriceGroup,
    // required this.sbuId,
    required this.depId,
    required this.sectionId,
  });

  RetailersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    outletName = json['outlet_name'];
    outletNameBn = json['outlet_name_bn'];
    outletCode = json['outlet_code'];
    oWNER = json['OWNER'] ?? json['owner'];
    contact = json['contact'];
    nid = json['nid'];
    address = json['address'];
    priceGroup = json['price_group'];
    // qcPriceGroup = json['qc_price_group'];
    // sbuId = json['sbu_id'].toString();
    depId = json['dep_id'];
    sectionId = json['section_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['outlet_name'] = outletName;
    data['outlet_name_bn'] = outletNameBn;
    data['outlet_code'] = outletCode;
    data['OWNER'] = oWNER;
    data['contact'] = contact;
    data['nid'] = nid;
    data['address'] = address;
    data['price_group'] = priceGroup;
    // data['qc_price_group'] = qcPriceGroup;
    // data['sbu_id'] = sbuId;
    data['dep_id'] = depId;
    data['section_id'] = sectionId;
    return data;
  }
}
