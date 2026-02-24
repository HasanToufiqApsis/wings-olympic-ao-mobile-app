class EditReasonModel {
  final int id;
  final String slug;

  EditReasonModel({
    required this.id,
    required this.slug,
  });

  factory EditReasonModel.fromJson(Map<String, dynamic> json){
    return EditReasonModel(id: json['id'], slug: json["slug"]);
  }
}
