class AssetModel {
  late String slug;
  late String? version;
  late List assets;

  AssetModel({required this.slug, this.version, required this.assets});

  AssetModel.fromJson(dynamic json) {
    slug = json['slug'];
    version = json['version'];
    assets = json['assets'];
  }
}
