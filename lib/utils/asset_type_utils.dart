enum AssetType { cooler, lightBox, }

class AssetTypeUtils {
  static AssetType toType(String str) {
    switch (str) {
      case "Cooler":
        return AssetType.cooler;
      default:
        return AssetType.lightBox;
    }
  }

  // static String toStr(AssetType type){
  //   switch (type){
  //     case AssetType.absoluteCash:
  //       return "Absolute Cash";
  //     case PayableType.percentageOfValue:
  //       return "Percentage of Value";
  //     case PayableType.productDiscount:
  //       return "Product Discount";
  //     case PayableType.gift:
  //       return "Gift";
  //     default:
  //       return "Absolute Cash";
  //   }
  // }
}
