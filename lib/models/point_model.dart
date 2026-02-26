class PointDetailsModel {
  int? id;
  String? name;
  int? parentId;
  List<int>? availableSurveys;

  PointDetailsModel({this.id, this.name, this.parentId, this.availableSurveys});

  PointDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
    availableSurveys = json['available_surveys'].cast<int>();
  }
}
