class ProductModel {
  final int id;
  final String name;
  final String shortName;
  final int parentId;
  final String? materialCode;

  ProductModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.parentId,
    this.materialCode,
  });

  factory ProductModel.fromJson(Map json) {
    return ProductModel(
      id: json["id"],
      name: json["name"] ?? "N/A",
      shortName: json["short_name"] ?? "N/A",
      parentId: json["parent_id"] ?? 0,
      materialCode: json['material_code'],
    );
  }
}
