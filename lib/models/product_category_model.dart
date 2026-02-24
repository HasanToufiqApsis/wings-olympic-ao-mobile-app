class ProductCategoryModel {
  final int id;
  final String name;
  final String slug;
  final int parentId;
  final int isSku;

  ProductCategoryModel(
      {required this.id,
      required this.name,
      required this.slug,
      required this.isSku,
      required this.parentId});

  factory ProductCategoryModel.fromJson(Map json) {
    return ProductCategoryModel(
        id: json['id'],
        name: json['name'],
        slug: json['slug'],
        isSku: json.containsKey("is_sku") ? json['is_sku'] : 0,
        parentId: json['parent_id']);
  }
}

class ProductCategoryWithAvailableIds {
  List ids;
  ProductCategoryModel category;
  ProductCategoryWithAvailableIds(this.category, this.ids);
}


