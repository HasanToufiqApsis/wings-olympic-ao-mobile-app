import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../constants/constant_variables.dart';
import '../constants/enum.dart';
import '../models/leave_movement_management_model_tsm.dart';
import '../models/returned_data_model.dart';
import '../models/route_change_model_tsm.dart';
import '../models/sr_info_model.dart';
import '../services/ff_services.dart';
import '../services/helper.dart';
import '../services/sync_read_service.dart';
import 'global_http.dart';
import 'links.dart';

class SettingsApi {
  final _ffServices = FFServices();

  Future<ReturnedDataModel> requestRestSaleSubmit({required String reason, required String remark}) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(status: ReturnedStatus.error);
    try {
      SrInfoModel sr = await SyncReadService().getSrInfo();
      String salesDate = await _ffServices.getSalesDate();
      final sbuId = sr.sbuId.replaceAll('[', '').replaceAll(']', '');

      Map payload = {
        "sbu_id": num.tryParse(sbuId),
        "dep_id": sr.depId,
        "section_id": sr.sectionId,
        "ff_id": sr.ffId,
        "date": salesDate,
        "image": "-",
        "reason": reason,
        "remark": remark
      };

      returnedDataModel = await GlobalHttp(
        uri: Links.resetSaleUrl,
        httpType: HttpType.post,
        body: jsonEncode(payload),
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }

    return returnedDataModel;
  }
}
