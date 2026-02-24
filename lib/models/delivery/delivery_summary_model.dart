import '../products_details_model.dart';

class DeliverySummaryModel {
  List<Sales>? sales;
  int? totalMemoCount;
  double? discountVolume;
  double? discountPrice;
  String? route;
  String? date;

  DeliverySummaryModel({
    this.sales,
    this.totalMemoCount,
    this.discountVolume,
    this.discountPrice,
    this.route,
    this.date,
  });

  DeliverySummaryModel.fromJson(Map<String, dynamic> json) {
    if (json['sales'] != null) {
      sales = <Sales>[];
      json['sales'].forEach((v) {
        sales!.add(Sales.fromJson(v));
      });
      // sales?.reversed.toList();
    }
    totalMemoCount = json['total_memo_count'];
    discountVolume = json['discount_volume'].toDouble();
    discountPrice = json['discount_price'].toDouble();
    route = json['route'];
    date = json['date'];
  }
}

class Sales {
  int? skuId;
  String? skuName;
  int? quantity;
  double? price;
  int? outletCount;
  ProductDetailsModel? sku;

  Sales({this.skuId, this.skuName, this.quantity, this.price, this.outletCount, this.sku});

  Sales.fromJson(Map<String, dynamic> json) {
    skuId = json['sku_id'];
    skuName = json['sku_name'];
    quantity = int.tryParse(json['quantity'] ?? '0');
    price = double.tryParse(json['price'].toString());
    outletCount = int.tryParse(json['outlet_count'] ?? '0');
  }
}
