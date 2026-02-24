class JourneyChangeRouteModel{
  final int id;
  final String slug;
  final String sectionCode;
  final int sectionConfigId;
  final int routeId;

  JourneyChangeRouteModel({required this.id, required this.slug, required this.sectionCode, required this.sectionConfigId, required this.routeId});

  factory JourneyChangeRouteModel.fromJson(Map json){
    return JourneyChangeRouteModel(id: json['id'], slug: json['slug']??'N/A', sectionCode: json['section_code'], sectionConfigId: json['section_config_id'], routeId: json['route_id']);
  }
  Map toJson(){
    return {
      "requested_section_id":id,
      "section_code":sectionCode,
      "section_config_id":sectionConfigId,
      "route_id":routeId,
    };
  }
}