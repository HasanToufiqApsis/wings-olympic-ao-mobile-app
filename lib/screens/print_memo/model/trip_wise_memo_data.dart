import '../../../models/products_details_model.dart';

class TripWiseMemoData {
  Map<num, num> qtyPurchase;
  Map<num, num> qtyOffer;
  num total;
  num offer;
  num payable;
  ProductDetailsModel formatedSku;

  TripWiseMemoData({
    this.qtyPurchase = const {},
    this.qtyOffer = const {},
    this.total = 0,
    this.offer = 0,
    this.payable = 0,
    required this.formatedSku,
  });
}