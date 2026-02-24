import '../constants/enum.dart';

class SalesDashboardUtils{
  static String toSyncFileKey(SaleDashboardType type){
    switch (type){
      case SaleDashboardType.preOrder:
        return "sale";
      case SaleDashboardType.spotSale:
        return 'spot_sale';
      case SaleDashboardType.delivery:
        return "delivery";
      case SaleDashboardType.media:
        return "media";
      case SaleDashboardType.stockCount:
        return "outlet_stock_count";
      case SaleDashboardType.survey:
        return "survey";
      case SaleDashboardType.promotion:
        return "promotion";
      case SaleDashboardType.checkout:
        return "check_out";
      case SaleDashboardType.posm:
        return "posm";
      case SaleDashboardType.stockCheck:
        return "stock_check_image";
    }
  }
}