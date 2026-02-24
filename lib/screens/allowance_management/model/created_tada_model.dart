class CreatedTaDaModel {
  int? taDaId;
  int? status;
  String? startDate;
  String? endDate;
  String? createdDate;
  String? fromAddress;
  String? toAddress;
  String? remark;
  String? contactName;
  String? contactNo;
  List<TaDaCost>? taDaCost;
  List<TaDaImage>? taDaImage;

  int cost = 0;

  CreatedTaDaModel({
    this.taDaId,
    this.status,
    this.startDate,
    this.endDate,
    this.createdDate,
    this.fromAddress,
    this.toAddress,
    this.remark,
    this.contactName,
    this.contactNo,
    this.taDaCost,
    this.taDaImage,
  });

  CreatedTaDaModel.fromJson(Map<String, dynamic> json) {
    taDaId = json['ta_da_id'];
    status = json['status'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    createdDate = json['created_at'];
    fromAddress = json['from_address'];
    toAddress = json['to_address'];
    remark = json['remark'];
    contactName = json['contact_name'];
    contactNo = json['contact_no'];
    if (json['ta_da_cost'] != null) {
      taDaCost = <TaDaCost>[];
      json['ta_da_cost'].forEach((v) {
        taDaCost!.add(TaDaCost.fromJson(v));
      });

      for(var val in taDaCost ??<TaDaCost>[]) {
        cost += (val.cost??0);
      }
    }
    if (json['ta_da_image'] != null) {
      taDaImage = <TaDaImage>[];
      json['ta_da_image'].forEach((v) {
        taDaImage!.add(TaDaImage.fromJson(v));
      });
    }
  }
}

class TaDaCost {
  int? taDaId;
  int? costTypeId;
  String? costType;
  int? cost;

  TaDaCost({this.taDaId, this.costTypeId, this.costType, this.cost});

  TaDaCost.fromJson(Map<String, dynamic> json) {
    taDaId = json['ta_da_id'];
    costTypeId = json['cost_type_id'];
    costType = json['cost_type'];
    cost = json['cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ta_da_id'] = taDaId;
    data['cost_type_id'] = costTypeId;
    data['cost_type'] = costType;
    data['cost'] = cost;
    return data;
  }
}

class TaDaImage {
  int? taDaId;
  String? image;

  TaDaImage({this.taDaId, this.image});

  TaDaImage.fromJson(Map<String, dynamic> json) {
    taDaId = json['ta_da_id'];
    image = json['image'];
  }
}
