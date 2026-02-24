

import 'outlet_model.dart';
import 'products_details_model.dart';

class QCInfoModel {
  late int id;
  late String name;
  late List<QCTypesModel> types;
  int totalQCQuantity = 0;
  late int saleableReturn;
  QCInfoModel({required this.id, required this.name, required this.types, required this.saleableReturn});

  QCInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    saleableReturn = json["saleable_return"] ?? 0;
    if (json['types'] != null) {
      types = <QCTypesModel>[];
      json['types'].forEach((v) {
        types.add(QCTypesModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['types'] = types.map((v) => v.toJson()).toList();
    return data;
  }

  int totalQuantity() {
    int total = 0;
    for (QCTypesModel qcType in types) {
      // if(saleableReturn != 1){
      //   total += qcType.quantity;
      // }
      total += qcType.quantity;
    }
    totalQCQuantity = total;
    return total;
  }
  int totalValidQCQuantity(){
    int total = 0;
    for (QCTypesModel qcType in types) {
      if(saleableReturn != 1){
        total += qcType.quantity;
      }
    }
    totalQCQuantity = total;
    return total;
  }
}

class QCTypesModel {
  late int id;
  late String name;
  late int quantity;
  QCTypesModel({required this.id, required this.name, required this.quantity});

  QCTypesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    quantity = json['quantity'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['quantity'] = quantity;
    return data;
  }
}

class SelectedQCInfoModel {
  late ProductDetailsModel sku;
  late OutletModel retailer;
  late List<QCInfoModel> qcInfoList;
  SelectedQCInfoModel(
      {required this.sku, required this.retailer, required this.qcInfoList});
}

