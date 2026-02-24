class AnswerModel {
  final int id;
  final String name;
  int? mark = 0;

  AnswerModel({
    required this.id,
    required this.name,
    this.mark,
  });

  factory AnswerModel.fromJson(Map json) {
    return AnswerModel(
      id: json['answer_id'],
      name: json['answer_name'],
      mark: json['mark'] ?? json['score'],
    );
  }
}
