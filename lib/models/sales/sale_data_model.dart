import '../../constants/constant_variables.dart';
import '../../services/ff_services.dart';
import '../../services/price_services.dart';
import '../../services/sync_read_service.dart';
import '../outlet_model.dart';
import '../products_details_model.dart';

class SaleDataModel {
  int qty;
  num price;
  num discount;
  num qcPrice;
  String salesDate;
  String salesDateTime;

  SaleDataModel({this.qty = 0, this.price = 0.0, this.discount = 0.0, this.salesDate ="" , this.salesDateTime = "", this.qcPrice = 0.0});
  PriceServices _priceServices = PriceServices();

  SyncReadService _syncReadService = SyncReadService();


  //fromJson
  factory SaleDataModel.fromJson(Map<String, dynamic> json) {
    return SaleDataModel(
      qty: json['stt'],
      price: json['price'].toDouble(),
      // discount: json['discount'],
      salesDate: json['sales_date'],
      salesDateTime: json['sales_datetime'],
    );
  }

  //saves quantity and price to sales data model
  saveQty({required OutletModel retailer, required ProductDetailsModel sku, required int quantity}) async {
    num initialPrice = await _priceServices.getSkuPriceForASpecificAmount(sku, retailer, quantity);
    qty = quantity;
    price = initialPrice;
    //initialize sales Date and sales datetime
    String salesDateFromSync = await FFServices().getSalesDate();
    DateTime now = DateTime.now();
    String salesDateTimeString = apiDateTimeFormat.format(now);
    salesDate = salesDateFromSync;
    salesDateTime = salesDateTimeString;
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     salesQtyKey: qty,
  //     salesPriceKey: price,
  //     salesDateKey: salesDate,
  //     salesDateTimeKey: salesDateTime
  //   };
  // }
}
