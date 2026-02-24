//===========================================================
//=====================QuestionModel=========================
//===========================================================

import '../../constants/enum.dart';
import 'answer_model.dart';

class QuestionModel {
  final int id;
  final String name;
  final AnswerType type;
  final bool required;
  final bool hasDependency;
  final List<AnswerModel> options;
  final Map<int, List<QuestionModel>> dependentQuestions;
  List selectedAnswers;
  String? image = '';
  int? mark = 0;

  QuestionModel({
    required this.id,
    required this.name,
    required this.type,
    required this.required,
    required this.hasDependency,
    required this.options,
    required this.dependentQuestions,
    required this.selectedAnswers,
    this.image,
    this.mark,
  });

  factory QuestionModel.fromJson(Map json) {
    List<AnswerModel> optionList = [];
    try {
      if (json.containsKey("options")) {
        List optionsJson = json['options'];
        if (optionsJson.isNotEmpty) {
          for (Map answerJson in optionsJson) {
            AnswerModel a = AnswerModel.fromJson(answerJson);
            optionList.add(a);
          }
        }
      }
    } catch (e, s) {
      print("inside getOptions QuestionModel catch block $e,$s");
    }
    Map<int, List<QuestionModel>> dependentQuestionMap = {};
    try {
      if (json.containsKey("dependent_questions")) {
        Map dependentQuestionJson = json['dependent_questions'];
        if (dependentQuestionJson.isNotEmpty) {
          dependentQuestionJson.forEach((key, value) {
            List<QuestionModel> dependentQuestionList = [];
            for (Map singleDependentQuestionJson in value) {
              QuestionModel q = QuestionModel.fromJson(singleDependentQuestionJson);
              dependentQuestionList.add(q);
            }
            dependentQuestionMap[int.parse(key)] = dependentQuestionList;
          });
        }
      }
    } catch (e) {
      print("inside getDependencyQuestion QuestionModel catch block $e");
    }

    //determin answerType
    late AnswerType questionType;
    if (json['question_type'] == "select") {
      questionType = AnswerType.select;
    } else if (json['question_type'] == "yes_no") {
      questionType = AnswerType.select;
    } else if (json['question_type'] == "multiselect") {
      questionType = AnswerType.multiselect;
    } else if (json['question_type'] == "text") {
      questionType = AnswerType.text;
    } else if (json['question_type'] == "number") {
      questionType = AnswerType.number;
    } else if (json['question_type'] == "phone") {
      questionType = AnswerType.phone;
    } else if (json['question_type'] == "date") {
      questionType = AnswerType.date;
    } else if (json['question_type'] == "dateRange") {
      questionType = AnswerType.dateRange;
    } else if (json['question_type'] == "image" || json['question_type'] == "camera") {
      questionType = AnswerType.image;
    } else if (json['question_type'] == "yes_no") {
      questionType = AnswerType.select;
    } else {
      questionType = AnswerType.text;
    }

    return QuestionModel(
      id: json['question_id'],
      name: json['question_name'],
      type: questionType,
      required: json['required'] == 1,
      hasDependency: json['has_dependency'] == 1,
      options: optionList,
      dependentQuestions: dependentQuestionMap,
      selectedAnswers: [],
      mark: json['mark'],
    );
  }
}

//===========================================================
//=====================surveyModel===========================
//===========================================================
class SurveyModel {
  final int id;
  final String name;
  final int mandatory;
  int? totalMark;

  // final int isMultiple;

  SurveyModel({
    required this.id,
    required this.name,
    required this.mandatory,
    this.totalMark,
    // required this.isMultiple,
  });

  factory SurveyModel.fromJson(Map<String, dynamic> json) {
    return SurveyModel(
      id: json['id'],
      name: json['name'],
      mandatory: json['mandatory'],
      totalMark: json['total_mark'],
      // isMultiple: json['is_multiple'],
    );
  }
}
//===========================================================
class ShowMarkModel {
  int mark;
  bool showMark;

  ShowMarkModel({
    required this.mark,
    required this.showMark,
  });
}
