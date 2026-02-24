class FareChartModel {
  final int id;
  final int depId;
  final int routeId;
  final int sectionId;
  final int clusterIdFrom;
  final int clusterIdTo;
  final num distanceInKm;
  final num fareInAmount;
  final int transportCategoryId;
  final String categorySlug;

  const FareChartModel({
    required this.id,
    required this.depId,
    required this.routeId,
    required this.sectionId,
    required this.clusterIdFrom,
    required this.clusterIdTo,
    required this.distanceInKm,
    required this.fareInAmount,
    required this.transportCategoryId,
    required this.categorySlug,
  });

  factory FareChartModel.fromJson(Map<String, dynamic> json) {
    return FareChartModel(
      id: json['id'] ?? 0,
      depId: json['dep_id'] ?? 0,
      routeId: json['route_id'] ?? 0,
      sectionId: json['section_id'] ?? 0,
      clusterIdFrom: json['cluster_id_from'] ?? 0,
      clusterIdTo: json['cluster_id_to'] ?? 0,
      distanceInKm: json['distance_in_km'] ?? 0,
      fareInAmount: json['fare_in_amount'] ?? 0,
      transportCategoryId: json['transport_category_id'] ?? 0,
      categorySlug: json['category_slug'] ?? '',
    );
  }
}
