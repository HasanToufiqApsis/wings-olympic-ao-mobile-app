enum PayableType { absoluteCash, percentageOfValue, productDiscount, gift }

class PayableTypeUtils {
  static PayableType toType(String str) {
    switch (str) {
      case "Absolute Cash":
        return PayableType.absoluteCash;
      case "Percentage of Value":
        return PayableType.percentageOfValue;
      case "Product Discount":
        return PayableType.productDiscount;
      case "Gift":
        return PayableType.gift;
      default:
        return PayableType.absoluteCash;
    }
  }

  static String toStr(PayableType type){
    switch (type){
      case PayableType.absoluteCash:
        return "Absolute Cash";
      case PayableType.percentageOfValue:
        return "Percentage of Value";
      case PayableType.productDiscount:
        return "Product Discount";
      case PayableType.gift:
        return "Gift";
      default:
        return "Absolute Cash";
    }
  }
}

enum DiscountType { normal, entireMemo, multiBuy, qps }

class DiscountTypeUtils {
  static DiscountType toType(String str) {
    switch (str) {
      case "Normal":
        return DiscountType.normal;
      case "Entire Memo":
        return DiscountType.entireMemo;
      case "Multi Buy":
        return DiscountType.multiBuy;
      case "Qps":
        return DiscountType.qps;
      default:
        return DiscountType.normal;
    }
  }

  static String toStr(DiscountType type){
    switch (type){
      case DiscountType.normal:
        return "Normal";
      case DiscountType.entireMemo:
        return "Entire Memo";
      case DiscountType.multiBuy:
        return "Multi Buy";
      case DiscountType.qps:
        return "Qps";
    }
  }
}

enum QpsTarget { value, volume }

class QpsTargetUtils {
  static QpsTarget toType(String str) {
    switch (str) {
      case "Value":
        return QpsTarget.value;
      case "Volume":
        return QpsTarget.volume;
      default:
        return QpsTarget.value;
    }
  }

  static String toStr(QpsTarget type){
    switch (type){
      case QpsTarget.value:
        return "Value";
      case QpsTarget.volume:
        return "Volume";
    }
  }
}

enum FractionalPromotion { number, decimal }
