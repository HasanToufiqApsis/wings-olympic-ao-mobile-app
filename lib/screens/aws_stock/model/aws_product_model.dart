class AwsProductModel {
  int id;
  String name;
  String shortName;
  int damagedCount;
  int stockCount;
  late int moduleId;
  int saleEnabled;

  AwsProductModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.damagedCount,
    required this.stockCount,
    required this.saleEnabled,
  });

  factory AwsProductModel.fromJson(Map json) {
    // appLog('stock count json => ${jsonEncode(json)}');
    return AwsProductModel(
      id: json["id"],
      name: json["name"],
      shortName: json["short_name"],
      damagedCount: 0,
      stockCount: 0,
      saleEnabled: json['sales_enable'] ?? 1,
    );
  }

  setDamagedCount(int count) {
    damagedCount = count;
  }

  setStockCount(int count) {
    stockCount = count;
  }

  setModuleId(int moduleID) {
    moduleId = moduleID;
  }
}
