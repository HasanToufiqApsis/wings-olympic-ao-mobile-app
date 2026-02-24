class AssetRequisitionModel {
  int id;
  String activityType;
  String assetRequestNo;
  String requiredSize;
  String assetNo;
  String nightCover;
  String type;
  int cost;

  AssetRequisitionModel({
    required this.id,
    required this.activityType,
    required this.assetRequestNo,
    required this.requiredSize,
    required this.assetNo,
    required this.nightCover,
    required this.type,
    required this.cost,
  });

  factory AssetRequisitionModel.fromJson(Map json) {
    return AssetRequisitionModel(
      id: json['id'],
      activityType: json['activity_type'],
      assetRequestNo: json['asset_request_no'],
      requiredSize: json['required_size'],
      assetNo: json['asset_no'],
      nightCover: json['night_cover'],
      type: json['type'],
      cost: json['cost']??0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activity_type': activityType,
      'asset_request_no': assetRequestNo,
      'required_size': requiredSize,
      'asset_no': assetNo,
      'night_cover': nightCover,
      'type': type,
      'cost': cost,
    };
  }
}

class AssetPullOutModel {
  String assetNo;
  String nightCover;
  String requiredSize;
  String type;
  num assetCatType;
  num coolerCatType;

  AssetPullOutModel({
    required this.assetNo,
    required this.nightCover,
    required this.requiredSize,
    required this.type,
    required this.assetCatType,
    required this.coolerCatType,
  });

  factory AssetPullOutModel.fromJson(Map json) {
    return AssetPullOutModel(
      assetNo: json['asset_no'],
      nightCover: json['night_cover'],
      requiredSize: json['required_size'] ?? '',
      type: json['type'] ?? '',
      assetCatType: json['asset_cat_type'] ?? 0,
      coolerCatType: json['cooler_cat_type'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'asset_no': assetNo,
      'night_cover': nightCover,
      'required_size': requiredSize,
      'type': type,
    };
  }
}
