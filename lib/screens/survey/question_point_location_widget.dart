import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/screens/survey/answer_point_location_widget.dart';

import '../../constants/constant_variables.dart';
import '../../models/outlet_model.dart';
import '../../models/point_model.dart';
import '../../models/survey/question_model.dart';
import '../../provider/global_provider.dart';
import '../../reusable_widgets/language_textbox.dart';
import 'answer_widget.dart';

class QuestionPointLocationWidget extends StatefulWidget {
  final List<QuestionModel> questionList;
  final String? serial;
  final PointDetailsModel retailer;

  const QuestionPointLocationWidget({
    Key? key,
    required this.questionList,
    this.serial,
    required this.retailer,
  }) : super(key: key);

  @override
  _QuestionPointLocationWidgetState createState() => _QuestionPointLocationWidgetState();
}

class _QuestionPointLocationWidgetState extends State<QuestionPointLocationWidget> {
  @override
  Widget build(BuildContext context) {
    List<QuestionModel> data = widget.questionList;

    return Column(
        children: List.generate(data.length, (index) {
      return Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: questionAnswerBox(data[index], widget.serial != null ? '${widget.serial}.${index + 1}' : '${index + 1}'),
      );
    }));
  }

  Widget questionAnswerBox(QuestionModel questionModel, String index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.sp),
        color: Colors.white,
      ),
      child: Column(
        children: [
          ///question
          questionWidget(isRequired: questionModel.required, id: index, text: questionModel.name),

          SizedBox(height: 2.h),

          ///answer
          Padding(
            padding: EdgeInsets.only(
              left: 2.w,
              right: 2.w,
            ),
            child: AnswerPointLocationWidget(
              questionModel: questionModel,
              retailer: widget.retailer,
            ),
          ),

          Consumer(builder: (context, ref, _) {
            List<QuestionModel> dependencyQuestionList = ref.watch(dependencyQuestionProvider(questionModel));
            return dependencyQuestionList.isNotEmpty
                ? QuestionPointLocationWidget(
                    questionList: dependencyQuestionList,
                    serial: index.toString(),
                    retailer: widget.retailer,
                  )
                : Container();
          }),
        ],
      ),
    );
  }

  Widget questionWidget({required bool isRequired, required String text, required String id}) {
    return Padding(
      padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LangText(
            'Q.',
            style: TextStyle(fontSize: normalFontSize),
          ),
          LangText(
            id.toString(),
            style: TextStyle(fontSize: normalFontSize),
          ),
          isRequired ? LangText('*', style: TextStyle(fontSize: normalFontSize, color: Colors.red)) : const SizedBox(),
          SizedBox(width: 2.w),
          SizedBox(
            width: 60.w,
            child: LangText(
              text,
              style: TextStyle(fontSize: normalFontSize),
            ),
          ),
        ],
      ),
    );
  }
}
