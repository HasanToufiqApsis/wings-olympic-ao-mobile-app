import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../constants/constant_keys.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../models/survey/question_model.dart';

class SurveyController {
  Map? getAnswerMap(List<QuestionModel> list) {
    bool verifyError = false;
    Map finalAnswer = {};
    for (var value in list) {
      if (value.type == AnswerType.multiselect) {
        if (value.selectedAnswers.isNotEmpty) {
          finalAnswer[value.id.toString()] = {
            surveyQuestionTypeKey: "multiselect",
            surveyAnswerIdKey: value.selectedAnswers.map((e) => e.id).toList(),
            surveyAnswerKey: value.selectedAnswers.map((e) => e.name).toList()
          };
        } else {
          if (value.required == true) {
            verifyError = true;
            Fluttertoast.showToast(
              msg: 'Please select an answer for the question "${value.name}"',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 4,
              backgroundColor: darkGreen,
              textColor: Colors.white,
              fontSize: normalFontSize,
            );
            break;
          } else {
            finalAnswer[value.id.toString()] = {
              surveyQuestionTypeKey: "multiselect",
              surveyAnswerIdKey: [],
              surveyAnswerKey: []
            };
          }
        }
      } else if (value.type == AnswerType.image) {
        if (value.selectedAnswers.isNotEmpty) {
          finalAnswer[value.id.toString()] = {
            surveyQuestionTypeKey: "image",
            surveyAnswerKey: value.selectedAnswers[0],
            surveyAnswerIdKey: ""
          };
        } else {
          if (value.required == true) {
            verifyError = true;
            Fluttertoast.showToast(
                msg: 'Please click an image for the question "${value.name}"',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 4,
                backgroundColor: darkGreen,
                textColor: Colors.white,
                fontSize: normalFontSize);
            break;
          } else {
            finalAnswer[value.id.toString()] = {
              surveyQuestionTypeKey: "image",
              surveyAnswerKey: "",
              surveyAnswerIdKey: ""
            };
          }
        }
      } else if (value.type == AnswerType.select) {
        if (value.selectedAnswers.isNotEmpty) {
          finalAnswer[value.id.toString()] = {
            surveyQuestionTypeKey: "select",
            surveyAnswerIdKey: value.selectedAnswers[0].id,
            surveyAnswerKey: value.selectedAnswers[0].name
          };
          if (value.hasDependency) {
            if (value.dependentQuestions
                .containsKey(value.selectedAnswers[0].id)) {
              if (value.dependentQuestions[value.selectedAnswers[0].id]!
                  .isNotEmpty) {
                Map? dependencyAnswer = getAnswerMap(
                    value.dependentQuestions[value.selectedAnswers[0].id] ??
                        []);
                if (dependencyAnswer == null) {
                  verifyError = true;
                  break;
                } else {
                  finalAnswer = {...finalAnswer, ...dependencyAnswer};
                }
              }
            }
          }
        } else {
          if (value.required == true) {
            verifyError = true;
            Fluttertoast.showToast(
                msg: 'Please select an answer for the question "${value.name}"',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 4,
                backgroundColor: darkGreen,
                textColor: Colors.white,
                fontSize: normalFontSize);
            break;
          } else {
            finalAnswer[value.id.toString()] = {
              surveyQuestionTypeKey: "select",
              surveyAnswerKey: "",
              surveyAnswerIdKey: ""
            };
          }
        }
      } else {
        if (value.selectedAnswers.isNotEmpty) {
          finalAnswer[value.id.toString()] = {
            surveyQuestionTypeKey: getQuestionType(value.type),
            surveyAnswerKey: value.selectedAnswers[0],
            surveyAnswerIdKey: ""
          };
        } else {
          finalAnswer[value.id.toString()] = {
            surveyQuestionTypeKey: getQuestionType(value.type),
            surveyAnswerKey: "",
            surveyAnswerIdKey: ""
          };
        }
      }
    }
    if (verifyError) {
      return null;
    } else {
      return finalAnswer;
    }
  }

  String getQuestionType(AnswerType answer) {
    switch (answer) {
      case AnswerType.text:
        return 'text';
      case AnswerType.number:
        return 'number';
      case AnswerType.phone:
        return 'phone';
      case AnswerType.date:
        return 'date';
      case AnswerType.dateRange:
        return 'dateRange';
      default:
        return 'text';
    }
  }
}
