import '../products_details_model.dart';
import '../trade_promotions/promotion_model.dart';

class TryBeforeBuyModel {
  final PromotionModel tryBeforeBuy;
  final ProductDetailsModel sku;

  TryBeforeBuyModel({
    required this.tryBeforeBuy,
    required this.sku,
  });
}