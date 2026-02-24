import '../constants/constant_keys.dart';

enum SaleType {preorder,delivery, spotSale}

class SalesTypeUtils{
  static String toSaleSaveKey(SaleType saleType){
    switch (saleType){
      case SaleType.preorder:
        return preorderKey;
      case SaleType.delivery:
        return deliveryKey;
      case SaleType.spotSale:
        return spotSaleKey;
    }
  }
  static String toQcSaveKey(SaleType saleType){
    switch(saleType){
      case SaleType.preorder:
        return qcDataKey;
      case SaleType.delivery:
        return deliveryQcDataKey;
      case SaleType.spotSale:
        return spotSaleQcDataKey;
    }
  }
  static String toPromotionSaveKey(SaleType saleType) {
    switch (saleType) {
      case SaleType.preorder:
        return promotionDataKey;
      case SaleType.delivery:
        return deliveryPromotionDataKey;
      case SaleType.spotSale:
        return spotSalePromotionDataKey;
    }
  }

  static String toOutletDataSaleKey(SaleType saleType){
    switch (saleType) {
      case SaleType.preorder:
        return "pre_order";
      case SaleType.delivery:
        return "sales";
      case SaleType.spotSale:
        return 'spot_sales';
    }
  }
}