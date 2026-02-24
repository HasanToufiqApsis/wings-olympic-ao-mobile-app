class AvModel {
  late int id;
  late String name;
  late String filename;
  late int autoplay;
  late int mandatory;
  late int skippable;

  AvModel({
    required this.id,
    required this.name,
    required this.filename,
    required this.autoplay,
    required this.mandatory,
    required this.skippable,
  });

  AvModel.fromJson(dynamic json) {
    id = int.parse(json['id'].toString());
    name = json['name'];
    filename = json['filename'];
    autoplay = json['autoplay'];
    mandatory = json['mandatory'];
    skippable = json['skippable'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['filename'] = filename;
    map['autoplay'] = autoplay;
    map['mandatory'] = mandatory;
    map['skippable'] = skippable;
    return map;
  }
}
