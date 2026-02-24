

enum StockCheckStatus {beforeImage, afterImage}

class StockCheckUtils {
  static StockCheckStatus toType(String str) {
    switch (str) {
      case "after":
        return StockCheckStatus.afterImage;
      case "before":
        return StockCheckStatus.beforeImage;
      default:
        return StockCheckStatus.afterImage;
    }
  }

  static String toStr(StockCheckStatus type){
    switch (type){
      case StockCheckStatus.beforeImage:
        return "before";
      case StockCheckStatus.afterImage:
        return "after";
    }
  }
}
