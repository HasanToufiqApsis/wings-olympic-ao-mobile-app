class Module {
  int id;
  String name;
  String slug;
  Map dashboardInfos;
  Map units;
  Module(
      {required this.id,
      required this.name,
      required this.slug,
      required this.dashboardInfos,
      required this.units
      });
  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
        id: json['id'],
        name: json['name'],
        slug: json['slug'],
        dashboardInfos: json['dashboard_infos'],
        units: json["units"]
    );
  }
}
