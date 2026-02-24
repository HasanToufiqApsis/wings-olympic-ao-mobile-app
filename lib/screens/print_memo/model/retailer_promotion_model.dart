import '../../../models/outlet_model.dart';
import '../../../models/trade_promotions/promotion_model.dart';

class RetailerPromotionModel {
  List<OutletModel> retailerList;
  List<PromotionModel> promotionList;

  RetailerPromotionModel({
    this.retailerList = const [],
    this.promotionList = const [],
  });
}