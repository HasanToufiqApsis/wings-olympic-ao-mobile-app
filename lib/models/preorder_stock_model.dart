class PreorderStockModel {
  int availableStock;
  int inTransitStock;
  int allocatedStockPercentage;
  num maxOrderLimit;
  num liftingStock;

  PreorderStockModel({
    required this.availableStock,
    required this.inTransitStock,
    required this.allocatedStockPercentage,
    required this.maxOrderLimit,
    required this.liftingStock,
  });

  factory PreorderStockModel.fromJson(Map<String, dynamic> json, int stock) {
    return PreorderStockModel(
      availableStock: json['available_stock'] ?? 0,
      inTransitStock: json['in_transit_stock'] ?? 0,
      allocatedStockPercentage: json['allocated_stock_percentage'] ?? 0,
      maxOrderLimit: json['max_order_limit'] ?? 0,
      liftingStock: stock,
    );
  }
}
