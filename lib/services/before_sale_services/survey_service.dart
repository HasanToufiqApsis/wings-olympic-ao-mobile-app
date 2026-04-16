import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wings_olympic_sr/services/audit_searvice.dart';
import 'package:wings_olympic_sr/utils/sales_type_utils.dart';

import '../../api/global_http.dart';
import '../../api/links.dart';
import '../../constants/constant_keys.dart';
import '../../constants/constant_variables.dart';
import '../../constants/enum.dart';
import '../../constants/sync_global.dart';
import '../../models/outlet_model.dart';
import '../../models/point_model.dart';
import '../../models/returned_data_model.dart';
import '../../models/sr_info_model.dart';
import '../../models/survey/question_model.dart';
import '../digital_learning_searvice.dart';
import '../ff_services.dart';
import '../helper.dart';
import '../outlet_services.dart';
import '../sales_service.dart';
import '../sync_read_service.dart';
import '../sync_service.dart';

class SurveyService {
  static final SurveyService _surveyService = SurveyService._internal();

  factory SurveyService() {
    return _surveyService;
  }
  final SyncReadService _syncReadService = SyncReadService();
  final outletService = OutletServices();

  SurveyService._internal();

  final SyncService _syncService = SyncService();

  ///survey list for retailers
  Future<List<SurveyModel>> getAllSurveyList(
      {required List surveyIdList, required int retailerId}) async {
    List<SurveyModel> surveyList = [];

    await _syncService.checkSyncVariable();
    for (var i in surveyIdList) {
      syncObj['survey_details']['survey_info'].forEach((e) {
        if (e['id'] == i) {
          surveyList.add(SurveyModel.fromJson(e));

        }
      });
    }
    return surveyList;
  }

  ///survey list for retailers
  Future<List<SurveyModel>> getSurveyList({required List surveyIdList, required int retailerId}) async {
    List<SurveyModel> surveyList = [];

    await _syncService.checkSyncVariable();
    for (var i in surveyIdList) {
      syncObj['survey_details']['survey_info'].forEach((e) {
        if (e['id'] == i) {
          bool alreadyCompleted = checkSurveyData(surveyId: i, retailerId: retailerId);

          bool multipleTimeAttempt = false;
          if (e.containsKey('is_multiple') && e['is_multiple'] == 1) {
            multipleTimeAttempt = true;
          }

          if (alreadyCompleted == false) {
            surveyList.add(SurveyModel.fromJson(e));
          }
        }
      });
    }
    return surveyList;
  }

  Future<List<SurveyModel>> getPointWiseSurveyList({required List surveyIdList}) async {
    List<SurveyModel> surveyList = [];

    await _syncService.checkSyncVariable();
    for (var i in surveyIdList) {
      syncObj['survey_details']['survey_info'].forEach((e) {
        if (e['id'] == i) {
          // bool alreadyCompleted = checkSurveyData(surveyId: i, retailerId: retailerId);

          bool multipleTimeAttempt = false;
          if (e.containsKey('is_multiple') && e['is_multiple'] == 1) {
            multipleTimeAttempt = true;
          }

          // if (alreadyCompleted == false) {
            surveyList.add(SurveyModel.fromJson(e));
          // }
        }
      });
    }
    return surveyList;
  }

  ///checking if retailer already did the survey
  bool checkSurveyData({required int surveyId, required int retailerId}) {
    bool checkSurveyData = false;
    if (syncObj.containsKey(surveyDataKey)) {
      if (syncObj[surveyDataKey].containsKey(retailerId.toString())) {
        if (syncObj[surveyDataKey][retailerId.toString()].containsKey(surveyId.toString())) {
          checkSurveyData = true;
        }
      }
    }
    return checkSurveyData;
  }

  ///create list of survey question model
  Future<List<QuestionModel>> getSurveyQuestionList(int surveyId) async {
    List<QuestionModel> questionList = [];

    await _syncService.checkSyncVariable();
    if (syncObj['survey_details']['questions'].containsKey(surveyId.toString())) {
      List temp = syncObj['survey_details']['questions'][surveyId.toString()];
      for (var element in temp) {
        questionList.add(QuestionModel.fromJson(element));
      }
    }
    return questionList;
  }

  ///create list of survey question model
  Future<List<QuestionModel>> getSurveyQuestionListDigitalLearning(int surveyId) async {
    List<QuestionModel> questionList = [];

    await _syncService.checkSyncVariable();
    if (syncObj['rtc_config']['survey_details']['questions'].containsKey(surveyId.toString())) {
      List temp = syncObj['rtc_config']['survey_details']['questions'][surveyId.toString()];
      for (var element in temp) {
        questionList.add(QuestionModel.fromJson(element));
      }
    }
    return questionList;
  }

  Future<bool> saveTheSale() async {
    bool enableConfig = false;

    if(syncObj.containsKey("dashboard_button")){
      if(syncObj["dashboard_button"].containsKey("delivery_summary")){
        enableConfig = syncObj["dashboard_button"]["delivery_summary"] == 1 ? true:false;
      }
    }

    if(enableConfig == false) {
      return false;
    }

    String salesDateFromSync = await FFServices().getSalesDate();
    DateTime salesDate = DateTime.parse(salesDateFromSync);

    DateTime date = await getSaveDate();
    int count = await getSaveCount();

    if(date == salesDate && count == await SalesService().getTotalRetailer(saleType: SaleType.preorder)+1) {
      return true;
    }
    return false;
  }

  Future secure() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('count', -2);
  }

  Future<DateTime> getSaveDate() async {
    String salesDateFromSync = await FFServices().getSalesDate();
    DateTime salesDate = DateTime.parse(salesDateFromSync);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? dateString = prefs.getString('date');
    DateTime date = DateTime.tryParse(dateString ?? "") ?? DateTime.now();
    final int? count = prefs.getInt('count');
    if(date == salesDate && count==null || (date == salesDate && count!=null && count==-2)) {
      setCount();
    }
    return date;
  }

  Future<int> getSaveCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('count') ?? 0;
  }

  setCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final outlets = await OutletServices().getOutletList(true);
    final random = Random();
    final max = (random.nextInt(outlets.length-1))+1;
    await prefs.setInt('count', max);
  }

  checkSyncFileDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? date = prefs.getString('date');
    if(date==null) {
      generateAndSaveDate();
    } else {
      String salesDateFromSync = await FFServices().getSalesDate();
      DateTime salesDateTime = DateTime.parse(salesDateFromSync);
      DateTime dateTime = DateTime.parse(date);
      if(salesDateTime.month != dateTime.month) {
        generateAndSaveDate();
      }
    }
  }

  void generateAndSaveDate() async {
    String salesDateFromSync = await FFServices().getSalesDate();
    debugPrint("---> $salesDateFromSync");
    DateTime dateTime = DateTime.parse(salesDateFromSync);

    DateTime dateTime2 = getRandomDateThisMonth(dateTime);
    if(dateTime2.weekday == 5) {
      generateAndSaveDate();
    } else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('date', apiDateFormat.format(dateTime2));
      await prefs.remove('count');
    }
  }

  DateTime getRandomDateThisMonth(DateTime now) {
    final firstDayOfMonth = DateTime(now.year, now.month, now.day+1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    final random = Random();
    final randomDay = firstDayOfMonth.day + random.nextInt(lastDayOfMonth.day - firstDayOfMonth.day + 1);

    return DateTime(now.year, now.month, randomDay);
  }

  ///submit survey
  submitSurvey(Map answer, int surveyId, int retailerId) async {
    print("----<><<<<<<<<<>> ${answer}");
    try {
      if (!syncObj.containsKey(surveyDataKey)) {
        syncObj[surveyDataKey] = {};
      }

      if (!syncObj[surveyDataKey].containsKey(retailerId.toString())) {
        syncObj[surveyDataKey][retailerId.toString()] = {};
      }

      syncObj[surveyDataKey][retailerId.toString()][surveyId.toString()] = answer;

      await SyncService().writeSync(jsonEncode(syncObj));
      sendSurveyDataToServer(retailerId: retailerId);
    } catch (e, s) {
      print('Survey Service submitSurvey catch block $e');
    }
  }

  ///submit survey
  submitPointSurvey(Map answer, int surveyId, int pointId) async {
    try {
      if (!syncObj.containsKey(surveyPointLocationDataKey)) {
        syncObj[surveyPointLocationDataKey] = {};
      }

      if (!syncObj[surveyPointLocationDataKey].containsKey(pointId.toString())) {
        syncObj[surveyPointLocationDataKey][pointId.toString()] = {};
      }

      syncObj[surveyPointLocationDataKey][pointId.toString()][surveyId.toString()] = answer;

      await SyncService().writeSync(jsonEncode(syncObj));
      sendPointSurveyDataToServer(retailerId: pointId);
    } catch (e, s) {
      print('Survey Service submitSurvey catch block $e');
    }
  }

  Future sendSurveyDataToServer({required int retailerId}) async {
    try {
      final retailer = await outletService.getOutletBuId(retailerId);
      if (retailer != null) {
        final surveyData = await getSurveyDataForARetailer(retailer);
        SrInfoModel srInfo = await _syncReadService.getSrInfo();

        final surveyPayload = { "survey": surveyData};

        print("-------->> come to here ${jsonEncode(surveyPayload)}");

        ReturnedDataModel? returnedDataModel = await GlobalHttp(
            httpType: HttpType.post,
            uri: Links.individualSurveySubmitUrl,
            accessToken: srInfo.accessToken,
            refreshToken: srInfo.refreshToken,
            body: jsonEncode(surveyPayload))
            .fetch();
        if (returnedDataModel.status == ReturnedStatus.success) {
          print("--------->> ${returnedDataModel.data}");
        }
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
  }

  Future sendPointSurveyDataToServer({required int retailerId}) async {
    try {
      final retailer = await AuditService().getPointById(id: retailerId);
      if (retailer != null) {
        final surveyData = await getSurveyDataForAPoint(retailer);
        SrInfoModel srInfo = await _syncReadService.getSrInfo();

        final surveyPayload = { "survey": surveyData};

        print("-------->> come to here ${jsonEncode(surveyPayload)}");

        ReturnedDataModel? returnedDataModel = await GlobalHttp(
            httpType: HttpType.post,
            uri: Links.individualSurveySubmitUrl,
            accessToken: srInfo.accessToken,
            refreshToken: srInfo.refreshToken,
            body: jsonEncode(surveyPayload))
            .fetch();
        if (returnedDataModel.status == ReturnedStatus.success) {
          print("--------->> ${returnedDataModel.data}");
        }
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
  }

  ///submit survey
  Future<ShowMarkModel> submitDigitalLearningSurvey(List<Map> answer, int surveyId) async {
    ShowMarkModel showMarkModel = ShowMarkModel(mark: 0, showMark: false);
    try {
      if (!syncObj.containsKey(surveyDigitalDataKey)) {
        syncObj[surveyDigitalDataKey] = {};
      }

      if (!syncObj[surveyDigitalDataKey].containsKey(surveyId.toString())) {
        syncObj[surveyDigitalDataKey][surveyId.toString()] = {};
      }

      syncObj[surveyDigitalDataKey][surveyId.toString()] = answer;

      await SyncService().writeSync(jsonEncode(syncObj));

      SrInfoModel srInfo = await _syncReadService.getSrInfo();

      List<Map> val = [];

      for (Map v in answer) {
        Map<String, dynamic> myMap = convertMap(v);
        if (v.containsKey('mark')) {
          val.add({
            "sbu_id": myMap['sbu_id'],
            "survey_id": myMap['survey_id'],
            "dep_id": myMap['dep_id'],
            "section_id": myMap['section_id'],
            "ff_id": myMap['ff_id'],
            "date": myMap['date'],
            "question_id": myMap['question_id'],
            "answer_id": myMap['answer_id'],
            "answer": myMap['answer'],
          });
        } else {
          val.add(v);
        }
      }

      Map finalMap = {
        "rtc_survey": val,
      };

      ReturnedDataModel returnedDataModel = await GlobalHttp(
        httpType: HttpType.post,
        uri: Links.submitDigitalLearningSurvey,
        accessToken: srInfo.accessToken,
        refreshToken: srInfo.refreshToken,
        body: jsonEncode(finalMap),
      ).fetch();

      int totalMark = 0;
      bool showMark = false;
      for (var val in answer) {
        if (val.containsKey('mark')) {
          if (showMark == false) {
            showMark = true;
          }
          totalMark += int.tryParse(val['mark'].toString()) ??0;
          print('this mark is::: ${val['mark']}');
        }
      }
      showMarkModel.mark = totalMark;
      showMarkModel.showMark = showMark;
    } catch (e, t) {
      print('Survey Service submitSurvey catch block $e, $t');
    }
    print('total: mark : is: ${showMarkModel.mark} : ${showMarkModel.showMark}');
    return showMarkModel;
  }

  List<Map> getDigitalLearningSurveyData(){
    List<Map> finalMap=[];
    try{
      if (syncObj.containsKey(surveyDigitalDataKey)) {
        print('digital----------------> exist');
        List<String> keys=List<String>.from(syncObj[surveyDigitalDataKey].keys.toList());
        List<Map> tempMap=[];
        if(keys.isNotEmpty){
          for(var val in keys){

            for(var vv in syncObj[surveyDigitalDataKey][val]){

              print('digital----------------> $val');
              tempMap.add(vv);
            }

          }



          for (Map v in tempMap) {
            Map<String, dynamic> myMap = convertMap(v);
            if (v.containsKey('mark')) {
              finalMap.add({
                "sbu_id": myMap['sbu_id'],
                "survey_id": myMap['survey_id'],
                "dep_id": myMap['dep_id'],
                "section_id": myMap['section_id'],
                "ff_id": myMap['ff_id'],
                "date": myMap['date'],
                "question_id": myMap['question_id'],
                "answer_id": myMap['answer_id'],
                "answer": myMap['answer'],
              });
            } else {
              finalMap.add(v);
            }
          }
        }
      }
      print('my final map is:: ${finalMap}');
    } catch (e,t){
      print(e.toString());
      print(t.toString());
    }
    return finalMap;
  }

  Map<String, dynamic> convertMap(Map<dynamic, dynamic> originalMap) {
    Map<String, dynamic> newMap = {};

    originalMap.forEach((key, value) {
      // Convert the key to a string
      String stringKey = key.toString();

      // Add the entry to the new map
      newMap[stringKey] = value;
    });

    return newMap;
  }

  Future<SurveyModel?> getDigitalLearningSurveyInfo(int id) async {
    SurveyModel? surveyModel;
    try {
      DigitalLearningService digitalLearningService = DigitalLearningService();
      if (await digitalLearningService.checkDigitalLearningEnable()) {
        if (syncObj['rtc_config'].containsKey("survey_details")) {
          var surveyDetails = syncObj['rtc_config']['survey_details'];
          if (surveyDetails.containsKey("survey_info")) {
            var surveyInfo = surveyDetails['survey_info'];

            surveyInfo.forEach((v) {
              SurveyModel s = SurveyModel.fromJson(v);
              if (s.id == id) {
                surveyModel = s;
              }
            });
          }
        }
      }
    } catch (e, t) {
      debugPrint('error-> ${e.toString()} ${t.toString()}');
    }
    return surveyModel;
  }


  //get survey data for sending to api
  Future<List> getSurveyDataForARetailer(OutletModel retailer) async {
    List surveyData = [];
    try {
      // bool surveySynced = await _syncDataWithServerServices.checkIfDataSyncedToServerForSpecificRetailerAndSpecificTask(retailer.id, surveySyncKey);
      // if (!surveySynced) {
      SrInfoModel srInfo = await _syncReadService.getSrInfo();
      String salesDate = await _syncReadService.getSalesDate();
      if (syncObj.containsKey(surveyDataKey)) {
        if (syncObj[surveyDataKey].containsKey(retailer.id.toString())) {
          Map retailerWiseSurvey =
          syncObj[surveyDataKey][retailer.id.toString()];
          if (retailerWiseSurvey.isNotEmpty) {
            retailerWiseSurvey.forEach((surveyId, surveyAnswers) {
              if (surveyAnswers.isNotEmpty) {
                surveyAnswers.forEach((questionId, answer) {
                  if (answer[surveyAnswerKey].toString().isNotEmpty) {
                    Map surveyAnswerMap = {
                      "sbu_id": srInfo.sbuId,
                      "survey_id": surveyId,
                      "dep_id": retailer.deplId,
                      "section_id": retailer.sectionId,
                      "ff_id": srInfo.ffId,
                      "outlet_id": retailer.id,
                      "outlet_code": retailer.outletCode,
                      "date": salesDate,
                      "question_id": questionId
                    };
                    if (answer[surveyQuestionTypeKey] == "select") {
                      surveyAnswerMap["answer_id"] = answer[surveyAnswerIdKey];
                      surveyAnswerMap["answer"] = answer[surveyAnswerKey].toString();
                    } else {
                      surveyAnswerMap["answer"] = answer[surveyAnswerKey].toString();
                    }
                    surveyData.add(surveyAnswerMap);
                  }
                });
              }
            });
          }
          // }
        }
      }
    } catch (e, s) {
      Helper.dPrint(
          "inside getSurveyDataForARetailer salesServices catch block $e  $s");
    }

    return surveyData;
  }

  Future<List> getSurveyDataForAPoint(PointDetailsModel retailer) async {
    List surveyData = [];
    try {
      // bool surveySynced = await _syncDataWithServerServices.checkIfDataSyncedToServerForSpecificRetailerAndSpecificTask(retailer.id, surveySyncKey);
      // if (!surveySynced) {
      SrInfoModel srInfo = await _syncReadService.getSrInfo();
      String salesDate = await _syncReadService.getSalesDate();
      if (syncObj.containsKey(surveyPointLocationDataKey)) {
        if (syncObj[surveyPointLocationDataKey].containsKey(retailer.id.toString())) {
          Map retailerWiseSurvey =
          syncObj[surveyPointLocationDataKey][retailer.id.toString()];
          if (retailerWiseSurvey.isNotEmpty) {
            retailerWiseSurvey.forEach((surveyId, surveyAnswers) {
              if (surveyAnswers.isNotEmpty) {
                surveyAnswers.forEach((questionId, answer) {
                  if (answer[surveyAnswerKey].toString().isNotEmpty) {
                    Map surveyAnswerMap = {
                      "sbu_id": srInfo.sbuId,
                      "survey_id": surveyId,
                      "dep_id": srInfo.pointId,
                      // "section_id": srInfo.sectionId,
                      "ff_id": srInfo.ffId,
                      // "outlet_id": retailer.id,
                      // "outlet_code": retailer.outletCode,
                      "date": salesDate,
                      "question_id": questionId
                    };
                    if (answer[surveyQuestionTypeKey] == "select") {
                      surveyAnswerMap["answer_id"] = answer[surveyAnswerIdKey];
                      surveyAnswerMap["answer"] = answer[surveyAnswerKey].toString();
                    } else {
                      surveyAnswerMap["answer"] = answer[surveyAnswerKey].toString();
                    }
                    surveyData.add(surveyAnswerMap);
                  }
                });
              }
            });
          }
          // }
        }
      }
    } catch (e, s) {
      Helper.dPrint(
          "inside getSurveyDataForARetailer salesServices catch block $e  $s");
    }

    return surveyData;
  }
}
