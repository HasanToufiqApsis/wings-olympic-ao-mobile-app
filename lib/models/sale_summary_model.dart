import 'products_details_model.dart';

class SalesSummaryModel {
  late ProductDetailsModel sku;
  int memo = 0;
  late int stt;
  late double price;
  late double discount;

  SalesSummaryModel(
      {required this.stt, required this.price, required this.discount});

  SalesSummaryModel.fromJson(Map<String, dynamic> json) {
    stt = json['stt'].toInt();
    price = json['price'].toDouble();
    discount = 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stt'] = stt;
    data['price'] = price;
    return data;
  }

  setSKU(ProductDetailsModel sku) {
    this.sku = sku;
  }

  double getBCP(int totalRetailer) {
    double bcp = (memo / totalRetailer) * 100;
    return bcp;
  }
}
