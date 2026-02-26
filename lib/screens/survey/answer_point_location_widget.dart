import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constant_keys.dart';
import '../../constants/constant_variables.dart';
import '../../constants/enum.dart';
import '../../models/outlet_model.dart';
import '../../models/point_model.dart';
import '../../models/retailers_mdoel.dart';
import '../../models/survey/answer_model.dart';
import '../../models/survey/question_model.dart';
import '../../provider/global_provider.dart';
import '../../reusable_widgets/language_textbox.dart';
import '../../reusable_widgets/scaffold_widgets/cameraScreen.dart';
import '../../services/Image_service.dart';
import '../../services/connectivity_service.dart';

class AnswerPointLocationWidget extends StatefulWidget {
  final QuestionModel questionModel;
  final PointDetailsModel retailer;

  const AnswerPointLocationWidget({
    Key? key,
    required this.questionModel,
    required this.retailer,
  }) : super(key: key);

  @override
  _AnswerPointLocationWidgetState createState() => _AnswerPointLocationWidgetState();
}

class _AnswerPointLocationWidgetState extends State<AnswerPointLocationWidget> {
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.questionModel.type != AnswerType.select && widget.questionModel.type != AnswerType.multiselect && widget.questionModel.type != AnswerType.image) {
        if (widget.questionModel.selectedAnswers.isNotEmpty) {
          controller.text = widget.questionModel.selectedAnswers[0];
        } else {
          if (controller.text.isNotEmpty) {
            controller.clear();
          }
        }
      }
    });

    switch (widget.questionModel.type) {
      case AnswerType.select:
        return Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: Row(
            children: [
              LangText(
                'Ans:',
                style: TextStyle(fontSize: normalFontSize),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Consumer(builder: (context, ref, _) {
                  return Container(
                    // height: 7.h,
                    // width: 80.w,
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.sp),
                      border: Border.all(color: green),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<AnswerModel>(
                        isExpanded: true,
                        hint: LangText('Select ans', style: TextStyle(color: Colors.grey, fontSize: normalFontSize)),
                        value: widget.questionModel.selectedAnswers.isNotEmpty ? widget.questionModel.selectedAnswers[0] : null,
                        items: widget.questionModel.options.map<DropdownMenuItem<AnswerModel>>((item) {
                          return DropdownMenuItem<AnswerModel>(
                            value: item,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                              child: LangText(item.name, maxLine: 2, overflow: TextOverflow.ellipsis,),
                            ),
                          );
                        }).toList(),
                        style: TextStyle(color: Colors.black, fontSize: normalFontSize),
                        onChanged: (val) {
                          if (val != null) {
                            widget.questionModel.selectedAnswers = [val];
                            ref.read(dependencyQuestionProvider(widget.questionModel).notifier).addDependentQuestion(val);
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  );
                }),
              )
            ],
          ),
        );

      case AnswerType.multiselect:
        return Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: Row(
            children: [
              LangText(
                'Ans:',
                style: TextStyle(fontSize: normalFontSize),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: green),
                    borderRadius: BorderRadius.circular(2.sp),
                  ),
                  child: Center(
                    child: ExpansionTile(
                      iconColor: grey,
                      tilePadding: const EdgeInsets.all(0),
                      title: widget.questionModel.selectedAnswers.isEmpty
                          ? LangText(
                              "Select ans",
                              style: TextStyle(color: Colors.grey, fontSize: 10.sp),
                            )
                          : dropDownHintText(),
                      children: <Widget>[
                        SizedBox(
                          height: 20.h,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.questionModel.options.length,
                            itemBuilder: (BuildContext context, int index) {
                              AnswerModel answer = widget.questionModel.options[index];
                              return CheckboxListTile(
                                controlAffinity: ListTileControlAffinity.trailing,
                                title: Text(answer.name, style: TextStyle(fontSize: normalFontSize)),
                                value: itemExists(answer),
                                onChanged: (val) {
                                  if (itemExists(answer)) {
                                    widget.questionModel.selectedAnswers.removeWhere((element) => element == answer);
                                  } else {
                                    widget.questionModel.selectedAnswers.add(answer);
                                  }

                                  setState(() {});
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );

      case AnswerType.text:
        return Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: Row(
            children: [
              LangText(
                'Ans:',
                style: TextStyle(fontSize: normalFontSize),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Container(
                  // height: 6.h,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: green),
                    borderRadius: BorderRadius.circular(2.sp),
                  ),
                  child: TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value) {
                      widget.questionModel.selectedAnswers = [value];
                    },
                    validator: (val) {
                      if (widget.questionModel.required) {
                        if (val == '') {
                          return 'Give an input';
                        }
                      }
                      return null;
                    },
                  ),
                ),
              )
            ],
          ),
        );

      case AnswerType.number:
        return Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: Row(
            children: [
              LangText(
                'Ans:',
                style: TextStyle(fontSize: normalFontSize),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Container(
                  // height: 6.h,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: green),
                    borderRadius: BorderRadius.circular(2.sp),
                  ),
                  child: TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value) {
                      widget.questionModel.selectedAnswers = [value];
                    },
                    validator: (val) {
                      if (widget.questionModel.required) {
                        if (val == '') {
                          return 'Give an input';
                        }
                      }
                      return null;
                    },
                  ),
                ),
              )
            ],
          ),
        );

      case AnswerType.phone:
        return Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: Row(
            children: [
              LangText(
                'Ans:',
                style: TextStyle(fontSize: normalFontSize),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Container(
                  height: 6.h,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: green),
                    borderRadius: BorderRadius.circular(2.sp),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value) {
                      widget.questionModel.selectedAnswers = [value];
                    },
                    validator: (val) {
                      if (widget.questionModel.required) {
                        if (val == '' || val == null) {
                          return 'Give an input';
                        }
                      }
                      if (val != null && val != '' && val.length > 1) {
                        if (val.substring(0, 2) == '01') {
                          if (val.length != 11) {
                            return 'The number should be exactly 11 characters';
                          } else {
                            return null;
                          }
                        }
                        return 'The number will start with 01';
                      }
                      return null;
                    },
                  ),
                ),
              )
            ],
          ),
        );

      case AnswerType.date:
        return Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: Row(
            children: [
              LangText(
                'Ans:',
                style: TextStyle(fontSize: normalFontSize),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Container(
                  height: 6.h,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: green),
                    borderRadius: BorderRadius.circular(2.sp),
                  ),
                  child: TextFormField(
                    onTap: () async {
                      // Below line stops keyboard from appearing
                      FocusScope.of(context).requestFocus(FocusNode());

                      await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now()).then((value) {
                        if (value != null) {
                          String picked = DateFormat('yyyy-MM-dd').format(value);
                          widget.questionModel.selectedAnswers = [picked];
                          controller.text = picked;
                        }
                      });
                    },
                    controller: controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: TextStyle(fontSize: normalFontSize),
                    validator: (val) {
                      if (widget.questionModel.required) {
                        if (val == '') {
                          return 'Select the date';
                        }
                      }
                      return null;
                    },
                  ),
                ),
              )
            ],
          ),
        );

      case AnswerType.dateRange:
        return Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: Row(
            children: [
              LangText(
                'Ans:',
                style: TextStyle(fontSize: normalFontSize),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Container(
                  height: 6.h,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: green),
                    borderRadius: BorderRadius.circular(2.sp),
                  ),
                  child: TextFormField(
                    onTap: () async {
                      // Below line stops keyboard from appearing
                      FocusScope.of(context).requestFocus(FocusNode());

                      await showDateRangePicker(context: context, firstDate: DateTime(1900), lastDate: DateTime.now()).then((value) {
                        if (value != null) {
                          String startDate = DateFormat('yyyy-MM-dd').format(value.start);
                          String endDate = DateFormat('yyyy-MM-dd').format(value.end);
                          String picked = '$startDate , $endDate';
                          widget.questionModel.selectedAnswers = [picked];
                          controller.text = picked;
                        }
                      });
                    },
                    controller: controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: TextStyle(fontSize: normalFontSize),
                    validator: (val) {
                      if (widget.questionModel.required) {
                        if (val == '') {
                          return 'Select the date';
                        }
                      }
                      return null;
                    },
                  ),
                ),
              )
            ],
          ),
        );

      case AnswerType.image:
        return Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LangText(
                'Ans:',
                style: TextStyle(fontSize: normalFontSize),
              ),
              SizedBox(width: 2.w),
              Container(
                height: 15.h,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: green),
                  borderRadius: BorderRadius.circular(2.sp),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0.sp),
                  child: widget.questionModel.selectedAnswers.isEmpty
                      ?
                      //before capture
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 5.0.w),
                              child: IconButton(
                                  onPressed: () async {
                                    Navigator.of(context).pushNamed(CameraScreen.routeName).then((value) async {
                                      if(value == null) {
                                        return;
                                      }
                                      ImageService()
                                          .compressFile(context: context, file: File(value.toString()), name: '${widget.questionModel.id}_${apiDateFormat.format(DateTime.now())}')
                                          .then((compressedImage) async {
                                        if (compressedImage != null) {
                                          if (await ConnectivityService().checkInternet()) {
                                            // bool done = await ImageService().sendImage(compressedImage.path, "$answerFolder/${widget.questionModel.id}");
                                            DateTime date = DateTime.now();

                                            // print(
                                            //     'image saved path is:: surveyImage/${widget.questionModel.id}/${date.year}/${date.month}/${date.day}/${widget.retailer.deplId}/${widget.retailer
                                            //         .sectionId}/${widget.retailer.outletCode}/${widget.retailer.outletCode}.jpeg');
                                            bool done = await ImageService().sendImage(compressedImage.path, "surveyImage/${widget.questionModel.id}/${date.year}/${date.month}/${date.day}/${widget.retailer.id}.jpeg");
                                            if (done) {
                                              if (await compressedImage.exists()) {
                                                await compressedImage.delete();
                                              }
                                            }
                                          }
                                        }
                                        setState(() {
                                          widget.questionModel.selectedAnswers = ['${widget.retailer.id}.jpeg'];
                                          widget.questionModel.image = value.toString();
                                        });
                                      });
                                    });
                                  },
                                  icon: Icon(
                                    Icons.camera_alt_outlined,
                                    color: primary,
                                    size: 30.0.sp,
                                  ),
                              ),
                            ),
                          ],
                        )
                      :
                      //after capture
                      Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.file(
                              File(widget.questionModel.image??''),
                              errorBuilder: (_, __, ___) {
                                return SizedBox();
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  widget.questionModel.selectedAnswers = [];
                                });
                              },
                            ),
                          ],
                        ),
                ),
              )
            ],
          ),
        );

      default:
        return Container();
    }
  }

  /// for multiselect answer type
  bool itemExists(AnswerModel answer) {
    if (widget.questionModel.selectedAnswers.isNotEmpty) {
      for (AnswerModel e in widget.questionModel.selectedAnswers) {
        if (e.id == answer.id) {
          return true;
        }
      }
    }
    return false;
  }

  dropDownHintText() {
    String text = '';
    List<String> selectedLabel = [];

    if (widget.questionModel.selectedAnswers.isEmpty) {
      return TextFormField(
        readOnly: true,
        decoration: const InputDecoration(border: InputBorder.none, hintText: 'উত্তর নির্বাচন করুন'),
        style: TextStyle(color: Colors.grey, fontSize: normalFontSize),
        validator: (val) {
          if (widget.questionModel.required) {
            return 'একটি ভ্যালু নির্বাচন করুন';
          }
          return null;
        },
      );
    } else {
      for (AnswerModel element in widget.questionModel.selectedAnswers) {
        if (itemExists(element)) {
          selectedLabel.add(element.name);
        }
      }
      if (selectedLabel.isNotEmpty) {
        text = selectedLabel.join(", ");
      }
      return Text(text);
    }
  }
}
