class TaDaVehicleModel {
  int? id;
  int? parent;
  String? slug;

  TaDaVehicleModel({this.id, this.parent, this.slug});

  TaDaVehicleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parent = json['parent'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent'] = parent;
    data['slug'] = slug;
    return data;
  }
}
