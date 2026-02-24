

import '../constants/enum.dart';

class WomModel {
  late int id;
  late String name;
  late WomType type;
  late String content;

  WomModel({
    required this.id,
    required this.name,
    required this.type,
    required this.content,
  });

  WomModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    if (json['type'] == 'wom') {
      type = WomType.wom;
    } else {
      type = WomType.kv;
    }
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    if (type == WomType.wom) {
      map['type'] = 'wom';
    } else {
      map['type'] = 'kv';
    }
    map['content'] = content;
    return map;
  }
}
