import 'products_details_model.dart';
import 'trade_promotions/promotion_model.dart';

class QpsSalesData {
  PromotionModel promotion;
  List<SkuWiseSales> sales;
  num requiredMemo;
  num memoCount;

  QpsSalesData({
    required this.promotion,
    required this.sales,
    required this.requiredMemo,
    required this.memoCount,
  });
}

class SkuWiseSales {
  ProductDetailsModel? sku;
  num volume;
  num value;

  SkuWiseSales({
    this.sku,
    required this.volume,
    required this.value,
  });
}
