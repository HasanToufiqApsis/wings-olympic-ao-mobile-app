class ZoneModel {
  final int id;
  final String name;
  final int parentId;

  ZoneModel({required this.id, required this.name, required this.parentId});

  factory ZoneModel.fromJson(Map json) {
    return ZoneModel(
      id: json['id'],
      name: json['name'],
      parentId: json['parent_id'] ?? 0,
    );
  }
}

class RegionModel {
  final int id;
  final String name;
  final int parentId;

  RegionModel({required this.id, required this.name, required this.parentId});

  factory RegionModel.fromJson(Map json) {
    return RegionModel(
      id: json['id'],
      name: json['name'],
      parentId: json['parent_id'] ?? 0,
    );
  }
}

class AreaModel {
  final int id;
  final String name;
  final int parentId;

  AreaModel({required this.id, required this.name, required this.parentId});

  factory AreaModel.fromJson(Map json) {
    return AreaModel(
      id: json['id'],
      name: json['name'],
      parentId: json['parent_id'] ?? 0,
    );
  }
}

class PointModel {
  final int id;
  final String name;
  final int parentId;

  PointModel({required this.id, required this.name, this.parentId = 0});

  factory PointModel.fromJson(Map json) {
    return PointModel(
      id: json['id'],
      name: json['name'],
      parentId: json['parent_id'] ?? 0,
    );
  }
}

class SectionModel {
  final int id;
  final String name;
  final parentId;
  final bool? isActive;

  SectionModel({
    required this.id,
    required this.name,
    required this.parentId,
    required this.isActive,
  });

  factory SectionModel.fromJson(Map json) {
    return SectionModel(
      id: json['id'],
      name: json['name'],
      parentId: json['parent_id'],
      isActive: json['is_active'],
    );
  }
}

class ClusterModel {
  late int id;
  late String name;
  late int parentId;

  ClusterModel({required this.id, required this.name, required this.parentId});

  ClusterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['parent_id'] = parentId;
    return data;
  }
}
