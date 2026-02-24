import 'dart:developer';

import 'dart:developer';

class ClusterModel {
  int? id;
  int? clusterTypeId;
  int? depId;
  String? slug;
  int sequence;

  ClusterModel({
    this.id,
    this.clusterTypeId,
    this.depId,
    this.slug,
    required this.sequence,
  });

  factory ClusterModel.fromJson(Map<String, dynamic> json, {required int sequence}) {
    // log(json.toString());
    return ClusterModel(
      id: json['id'] ?? json['cluster_id'] ?? 0,
      clusterTypeId: json['cluster_type_id'] ?? 0,
      depId: json['dep_id'] ?? 0,
      slug: json['slug'] ?? '',
      sequence: sequence,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cluster_type_id': clusterTypeId,
      'dep_id': depId,
      'slug': slug,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClusterModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}


class ClusterSet{
  final ClusterModel fromClusters;
  final ClusterModel toClusters;

  ClusterSet({required this.fromClusters, required this.toClusters});
}
