import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../constants/constant_keys.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../constants/sync_global.dart';
import '../../../models/sr_info_model.dart';
import '../../../models/survey/question_model.dart';
import '../../../services/sync_read_service.dart';
import '../../../services/sync_service.dart';

class SurveyDigitalLearningController {
  Future<List<Map>>? getAnswerMap(
      List<QuestionModel> list, int surveyId) async {
    bool verifyError = false;
    SyncReadService _syncReadService = SyncReadService();
    SrInfoModel srInfo = await _syncReadService.getSrInfo();
    List<Map> finalAnswer = [];
    for (var value in list) {
      if (value.type == AnswerType.multiselect) {
        if (value.selectedAnswers.isNotEmpty) {
          finalAnswer.add({
            "sbu_id": srInfo.sbuId,
            "survey_id": surveyId,
            "dep_id": srInfo.depId,
            "section_id": srInfo.sectionId,
            "ff_id": srInfo.ffId,
            "date": syncObj['date'],
            "question_id": value.id,
            // surveyQuestionTypeKey: "multiselect",
            surveyAnswerIdKey: value.selectedAnswers.map((e) => e.id).toList(),
            surveyAnswerKey: value.selectedAnswers.map((e) => e.name).toList(),
            "mark": value.selectedAnswers
                .map((e) => e.mark)
                .toList()
                .reduce((a, b) => a + b)
          });
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
            return [];
            break;
          } else {
            finalAnswer.add({
              "sbu_id": srInfo.sbuId,
              "survey_id": surveyId,
              "dep_id": srInfo.depId,
              "section_id": srInfo.sectionId,
              "ff_id": srInfo.ffId,
              "date": syncObj['date'],
              "question_id": value.id,
              // surveyQuestionTypeKey: "multiselect",
              surveyAnswerIdKey: [],
              surveyAnswerKey: [],
            });
          }
        }
      } else if (value.type == AnswerType.image) {
        if (value.selectedAnswers.isNotEmpty) {
          finalAnswer.add({
            "sbu_id": srInfo.sbuId,
            "survey_id": surveyId,
            "dep_id": srInfo.depId,
            "section_id": srInfo.sectionId,
            "ff_id": srInfo.ffId,
            "date": syncObj['date'],
            "question_id": value.id,
            // surveyQuestionTypeKey: "image",
            surveyAnswerKey: value.selectedAnswers[0],
            surveyAnswerIdKey: "",
            //todo
          });
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
            return [];
            break;
          } else {
            finalAnswer.add({
              "sbu_id": srInfo.sbuId,
              "survey_id": surveyId,
              "dep_id": srInfo.depId,
              "section_id": srInfo.sectionId,
              "ff_id": srInfo.ffId,
              "date": syncObj['date'],
              "question_id": value.id,
              // surveyQuestionTypeKey: "image",
              surveyAnswerKey: "",
              surveyAnswerIdKey: "",
            });
          }
        }
      } else if (value.type == AnswerType.select) {
        if (value.selectedAnswers.isNotEmpty) {
          finalAnswer.add({
            "sbu_id": srInfo.sbuId,
            "survey_id": surveyId,
            "dep_id": srInfo.depId,
            "section_id": srInfo.sectionId,
            "ff_id": srInfo.ffId,
            "date": syncObj['date'],
            "question_id": value.id,
            // surveyQuestionTypeKey: "select",
            surveyAnswerIdKey: value.selectedAnswers[0].id,
            surveyAnswerKey: value.selectedAnswers[0].name,
            "mark": value.selectedAnswers[0].mark,
          });
          if (value.hasDependency) {
            if (value.dependentQuestions
                .containsKey(value.selectedAnswers[0].id)) {
              if (value.dependentQuestions[value.selectedAnswers[0].id]!
                  .isNotEmpty) {
                List<Map>? dependencyAnswer = await getAnswerMap(
                  value.dependentQuestions[value.selectedAnswers[0].id] ?? [],
                  value.selectedAnswers[0].id,
                );
                if (dependencyAnswer == null || dependencyAnswer.isEmpty) {
                  verifyError = true;
                  return [];
                  break;
                } else {
                  try {
                    // finalAnswer.addAll(finalAnswer);
                    finalAnswer.addAll(dependencyAnswer);
                  } catch (e, t) {
                    log(e.toString());
                    log(t.toString());
                  }
                  // finalAnswer = {...finalAnswer, ...dependencyAnswer};
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
            return [];
            break;
          } else {
            finalAnswer.add({
              "sbu_id": srInfo.sbuId,
              "survey_id": surveyId,
              "dep_id": srInfo.depId,
              "section_id": srInfo.sectionId,
              "ff_id": srInfo.ffId,
              "date": syncObj['date'],
              "question_id": value.id,
              // surveyQuestionTypeKey: "select",
              surveyAnswerKey: "",
              surveyAnswerIdKey: "",
            });
          }
        }
      } else {
        if (value.selectedAnswers.isNotEmpty) {
          finalAnswer.add({
            "sbu_id": srInfo.sbuId,
            "survey_id": surveyId,
            "dep_id": srInfo.depId,
            "section_id": srInfo.sectionId,
            "ff_id": srInfo.ffId,
            "date": syncObj['date'],
            "question_id": value.id,
            // surveyQuestionTypeKey: getQuestionType(value.type),
            surveyAnswerKey: value.selectedAnswers[0],
            surveyAnswerIdKey: "",
          });
        } else {
          finalAnswer.add({
            "sbu_id": srInfo.sbuId,
            "survey_id": surveyId,
            "dep_id": srInfo.depId,
            "section_id": srInfo.sectionId,
            "ff_id": srInfo.ffId,
            "date": syncObj['date'],
            "question_id": value.id,
            // surveyQuestionTypeKey: getQuestionType(value.type),
            surveyAnswerKey: "",
            surveyAnswerIdKey: "",
          });
        }
      }
    }
    if (verifyError) {
      return [];
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
