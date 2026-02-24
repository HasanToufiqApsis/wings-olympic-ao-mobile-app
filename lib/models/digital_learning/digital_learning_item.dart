import '../../utils/digital_learning_utils.dart';

class DigitalLearningItem {
  late int id;
  late String videoUrl;
  late DigitalLearningType type;
  late int surveyId;
  late int sort;
  String? name;

  DigitalLearningItem({
    required this.id,
    required this.videoUrl,
    required this.type,
    required this.surveyId,
    required this.sort,
    this.name,
  });

  DigitalLearningItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    videoUrl = json['video_url'];
    String assetName = json['video_url'].toString().split('/').last;
    type = DigitalLearningUtils.toType(assetName.split('.').last);
    surveyId = json['survey_id'];
    sort = json['sort'];
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = <String, dynamic>{};
//   data['id'] = id;
//   data['video_url'] = videoUrl;
//   data['type'] = type;
//   data['survey_id'] = surveyId;
//   data['sort'] = sort;
//   return data;
// }
}
