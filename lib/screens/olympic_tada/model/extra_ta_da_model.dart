class ExtraTaDaType {
  int? id;
  int? parent;
  String? slug;
  double? amount;
  bool? isTextInput;
  int? categoryId;

  ExtraTaDaType({this.id, this.parent, this.slug, this.amount, this.isTextInput = false, this.categoryId});

  ExtraTaDaType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parent = json['parent'];
    slug = json['category_slug'];
    amount = double.tryParse(json['amount']??"0");
    isTextInput = json['category_type'] == 0? true : false;
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent'] = parent;
    data['category_slug'] = slug;
    return data;
  }
}
