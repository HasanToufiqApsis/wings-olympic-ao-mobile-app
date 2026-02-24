import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import '../../../api/global_http.dart';
import '../../../api/links.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../models/returned_data_model.dart';
import '../../../models/sr_info_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../services/ff_services.dart';
import '../../../services/helper.dart';

class ResignationController {
  BuildContext context;
  late Alerts alerts;
  final FFServices _ffServices = FFServices();
  ResignationController({required this.context})
    : alerts = Alerts(context: context);
  Future<ReturnedDataModel> submitResignation(String remarks,DateTime selectedDate) async {
    ReturnedDataModel returned = ReturnedDataModel(
      status: ReturnedStatus.error,
    );
    try {
      SrInfoModel? srInfo = await _ffServices.getSrInfo();
      if (srInfo != null) {
        Map payload = {
          "field_force_id": srInfo.ffId,
          "last_working_date": apiDateFormat.format(selectedDate),
          "remarks": remarks,
        };
        log(jsonEncode(payload));
        String url = Links.baseUrl + Links.resignation;
        returned = await GlobalHttp(
          uri: url,
          httpType: HttpType.post,
          body: jsonEncode(payload),
          accessToken: srInfo.accessToken,
          refreshToken: srInfo.refreshToken,
        ).fetch();
      }
    } catch (e) {
      Helper.dPrint("inside resignation controller catch block $e");
    }
    return returned;
  }

  Future<ReturnedDataModel> getResignationStatus() async {
    ReturnedDataModel returned = ReturnedDataModel(
      status: ReturnedStatus.error,
    );
    try {
      SrInfoModel? srInfo = await _ffServices.getSrInfo();
      if (srInfo != null) {
        String url = Links.baseUrl + Links.resignationStatus;
        returned = await GlobalHttp(
          uri: url,
          httpType: HttpType.get,
          accessToken: srInfo.accessToken,
          refreshToken: srInfo.refreshToken,
        ).fetch();
      }
    } catch (e) {
      Helper.dPrint("inside resignation controller catch block $e");
    }
    return returned;
  }
}
