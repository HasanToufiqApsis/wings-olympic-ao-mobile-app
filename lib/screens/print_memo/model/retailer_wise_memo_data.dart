
import '../../../models/products_details_model.dart';

class RetailerWiseMemoData {
  num qtyPurchase;
  num qtyOffer;
  num total;
  num offer;
  num payable;
  ProductDetailsModel formatedSku;

  RetailerWiseMemoData({
    this.qtyPurchase = 0,
    this.qtyOffer = 0,
    this.total = 0,
    this.offer = 0,
    this.payable = 0,
    required this.formatedSku,
  });
}