import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constant_variables.dart';
import '../../constants/enum.dart';
import '../../main.dart';
import '../../models/outlet_model.dart';
import '../../models/point_model.dart';
import '../../models/survey/question_model.dart';
import '../../provider/global_provider.dart';
import '../../reusable_widgets/buttons/submit_button_group.dart';
import '../../reusable_widgets/custom_dialog.dart';
import '../../reusable_widgets/global_widgets.dart';
import '../../reusable_widgets/language_textbox.dart';
import '../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../services/before_sale_services/survey_service.dart';
import 'controller/survey_controller.dart';
import 'question_point_location_widget.dart';
import 'question_widget.dart';

class SurveyPointLocationUI extends StatefulWidget {
  static const routeName = "/survey-point-location-ui";
  final SurveyModel surveyModel;
  final int retailerId;
  final PointDetailsModel retailer;

  const SurveyPointLocationUI({
    super.key,
    required this.surveyModel,
    required this.retailerId,
    required this.retailer,
  });

  @override
  _SurveyPointLocationUIState createState() => _SurveyPointLocationUIState();
}

class _SurveyPointLocationUIState extends State<SurveyPointLocationUI> {
  GlobalWidgets globalWidgets = GlobalWidgets();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Survey",
        // titleImage: "pre_order_button.png",
        showLeading: true,
        onLeadingIconPressed: () {
          if (widget.surveyModel.mandatory == 1) {
            Alerts(context: context).customDialog(
              type: AlertType.warning,
              message: 'You must need to complete this survey?',
            );
          } else {
            navigatorKey.currentState?.pop();
          }
        },
        actions: [
          if (widget.surveyModel.mandatory == 0)
            TextButton(
              onPressed: () {
                Alerts(context: context).customDialog(
                    type: AlertType.info,
                    message: 'Are you sure you want to skip survey?',
                    twoButtons: true,
                    onTap1: () async {
                      await SurveyService().submitSurvey({}, widget.surveyModel.id, widget.retailerId);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
              },
              child: LangText(
                'Skip',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                height: 75.h,
                child: Consumer(builder: (context, ref, _) {
                  AsyncValue<List<QuestionModel>> questionList = ref.watch(surveyQuestionProvider(widget.surveyModel));
                  return questionList.when(
                      data: (data) {
                        if (data.isNotEmpty) {
                          return SingleChildScrollView(
                              child: Column(
                            children: [
                              // Padding(
                              //   padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                              //   child: Align(alignment: Alignment.center, child: globalWidgets.setHeadings(widget.surveyModel.name, color: darkGreen)),
                              // ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                                child: SizedBox(width: 100.w, height: 8.h, child: globalWidgets.showInfo(message: widget.surveyModel.name??'')),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.sp),
                                ),
                                child: Form(
                                    key: _formKey,
                                    child: QuestionPointLocationWidget(
                                      questionList: data,
                                      retailer: widget.retailer,
                                    )),
                              ),
                            ],
                          ));
                        } else {
                          return Center(
                              child: LangText(
                            "This question doesn\'t have any answer",
                            style: TextStyle(fontSize: normalFontSize),
                          ));
                        }
                      },
                      error: (e, s) => LangText('$e'),
                      loading: () => const Center(child: CircularProgressIndicator()));
                }),
              ),
            ),

            ///=========== submit button ==========================
            Consumer(builder: (context, ref, _) {
              AsyncValue<List<QuestionModel>> questionList = ref.watch(surveyQuestionProvider(widget.surveyModel));
              return questionList.when(
                  data: (data) {
                    if (data.isNotEmpty) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [primary, primaryBlue],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                                width: 48.w,
                                child: SubmitButtonGroup(
                                  button1Label: "Submit",
                                  onButton1Pressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      Map? answer = SurveyController().getAnswerMap(data);
                                      if (answer != null) {
                                        Alerts(context: context).customDialog(
                                            type: AlertType.info,
                                            message: 'Are you sure you want to submit survey?',
                                            twoButtons: true,
                                            onTap1: () async {
                                              await SurveyService().submitPointSurvey(answer, widget.surveyModel.id, widget.retailerId);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            });
                                      }
                                    }
                                  },
                                )),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                  error: (e, s) => LangText(e.toString()),
                  loading: () => const SizedBox());
            }),
          ],
        ),
      ),
    );
  }
}
