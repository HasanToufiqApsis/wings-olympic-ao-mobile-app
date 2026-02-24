class BrandModel {
  late int id;
  late String name;
  late String shortName;
  late int parentId;
  int? quantity;

  BrandModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.parentId,
    this.quantity,
  });

  BrandModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortName = json['short_name'];
    parentId = json['parent_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['short_name'] = shortName;
    data['parent_id'] = parentId;
    return data;
  }
}
