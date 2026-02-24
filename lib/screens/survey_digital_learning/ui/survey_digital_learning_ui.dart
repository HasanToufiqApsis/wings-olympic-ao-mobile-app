import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/digital_learning/digital_learning_item.dart';
import '../../../models/survey/question_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../services/before_sale_services/survey_service.dart';
import '../controller/syrvey_digital_learning_controller.dart';
import 'question_widget_digital_learning.dart';

class SurveyDigitalLearningUI extends StatefulWidget {
  static const routeName = "/survey_digital_learning";
  final DigitalLearningItem surveyModel;

  // final OutletModel retailer;

  const SurveyDigitalLearningUI({
    Key? key,
    required this.surveyModel,
    // required this.retailer,
  }) : super(key: key);

  @override
  _SurveyDigitalLearningUIState createState() => _SurveyDigitalLearningUIState();
}

class _SurveyDigitalLearningUIState extends State<SurveyDigitalLearningUI> {
  GlobalWidgets globalWidgets = GlobalWidgets();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      AsyncValue<SurveyModel?> surveyC = ref.watch(getDigitalSurveyInfo(widget.surveyModel));
      return surveyC.when(
          data: (survey) {
            if (survey != null) {
              return Scaffold(
                appBar: CustomAppBar(
                  title: "Digital Learning",
                  // titleImage: "pre_order_button.png",
                  showLeading: true,
                  onLeadingIconPressed: () {
                    if (survey.mandatory == 1) {
                      Alerts(context: context).customDialog(
                        type: AlertType.warning,
                        message: 'You must need to complete this survey?',
                      );
                    } else {
                      navigatorKey.currentState?.pop();
                    }
                  },
                  actions: [
                    if (survey.mandatory == 0)
                      TextButton(
                        onPressed: () {
                          Alerts(context: context).customDialog(
                              type: AlertType.info,
                              message: 'Are you sure you want to skip survey?',
                              twoButtons: true,
                              onTap1: () async {
                                // await SurveyService().submitSurvey({}, widget.surveyModel.id, widget.retailerId);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
                        },
                        child: LangText(
                          'Skip',
                          style: const TextStyle(
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
                            AsyncValue<List<QuestionModel>> questionList = ref.watch(surveyQuestionProviderDigitalLearning(widget.surveyModel));
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
                                          child: SizedBox(width: 100.w, height: 8.h, child: globalWidgets.showInfo(message: 'You must fill (*) marked questions')),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8.sp),
                                          ),
                                          child: Form(
                                              key: _formKey,
                                              child: QuestionWidgetDigitalLearning(
                                                questionList: data,
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
                        AsyncValue<List<QuestionModel>> questionList = ref.watch(surveyQuestionProviderDigitalLearning(widget.surveyModel));
                        return questionList.when(
                            data: (data) {
                              if (data.isNotEmpty) {
                                return Container(
                                  height: 10.h,
                                  padding: EdgeInsets.symmetric(horizontal: 3.w),
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
                                      Consumer(builder: (context, ref, _) {
                                        String lang = ref.watch(languageProvider);
                                        String hint = "Required Size";
                                        if (lang != "en") {
                                          hint = "নির্ধারিত সাইজ";
                                        }
                                        return SizedBox(
                                            width: 48.w,
                                            child: SubmitButtonGroup(
                                              button1Label: "Submit",
                                              onButton1Pressed: () async {
                                                if (_formKey.currentState!.validate()) {
                                                  List<Map>? answer = await SurveyDigitalLearningController().getAnswerMap(data, survey.id ?? 0);
                                                  log(">>---->>> $answer");
                                                  if (answer != null && answer.isNotEmpty) {
                                                    print(jsonEncode(answer));
                                                    Alerts(context: context).customDialog(
                                                        type: AlertType.info,
                                                        message: 'Are you sure you want to submit survey?',
                                                        twoButtons: true,
                                                        onTap1: () async {
                                                          print("answer is::: ${jsonEncode(answer)}");
                                                          ShowMarkModel mark = await SurveyService().submitDigitalLearningSurvey(answer, widget.surveyModel.surveyId);
                                                          if (mark.showMark == true) {
                                                            Navigator.pop(context);
                                                            Alerts(context: context).customDialog(
                                                                type: mark.mark > 0 ? AlertType.success : AlertType.error,
                                                                message: lang != "en" ? 'আপনি পেয়েছেন সর্বমোট ${mark.mark} নাম্বার' : 'You got total ${mark.mark} number',
                                                                onTap1: () async {
                                                                  Navigator.pop(context);
                                                                  Navigator.pop(context);
                                                                });
                                                          } else {
                                                            Navigator.pop(context);
                                                            Navigator.pop(context);
                                                          }
                                                        });
                                                  }
                                                }
                                              },
                                            ));
                                      }),
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
            } else {
              return Scaffold(
                appBar: CustomAppBar(
                  title: "Digital Learning ->",
                  // titleImage: "pre_order_button.png",
                  showLeading: true,
                  onLeadingIconPressed: () {
                      navigatorKey.currentState?.pop();

                  },
                ),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Center(
                    //   child: SizedBox(
                    //     height: 30.sp,
                    //     width: 30.sp,
                    //     child: Image.asset(
                    //       'assets/sell_out_of_selected_outlet_icon.png',
                    //     ),
                    //   ),
                    // ),

                    Icon(Icons.warning_amber_rounded, size: 56, color: yellow,),
                    8.verticalSpacing,
                    Padding(
                      padding: const EdgeInsets.only(left: 16,top: 10),
                      child: LangText(
                        'No question available for this digital learning...',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 5.h),

                  ],
                ),
              );
            }
          },
          error: (e, s) => LangText('$e'),
          loading: () => const Center(child: CircularProgressIndicator()));
    });
  }
}
