import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/survey/answer_model.dart';
import '../../models/survey/question_model.dart';


class DependencyQuestionNotifier extends StateNotifier<List<QuestionModel>> {
  DependencyQuestionNotifier(this.questionModel) : super([]);
  final QuestionModel questionModel;

  addDependentQuestion(AnswerModel answer) {
    if (questionModel.dependentQuestions.containsKey(answer.id)) {
      List<QuestionModel> dependentQuestion =
          questionModel.dependentQuestions[answer.id] ?? [];
      state = dependentQuestion;
    } else {
      state = [];
    }
  }

}
