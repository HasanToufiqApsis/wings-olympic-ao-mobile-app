class GeneralIdSlugModel{
  final int id;
  final String slug;

  GeneralIdSlugModel({required this.id, required this.slug});

  factory GeneralIdSlugModel.fromJson(Map json){
    return GeneralIdSlugModel(id: int.parse(json["id"].toString()), slug: json["slug"]);
  }

  Map toJson(){
    return {
      "id":id,
      "slug":slug
    };
  }
}



