import 'dart:convert';
import 'dart:developer';

import '../constants/enum.dart';
import '../models/returned_data_model.dart';
import '../models/sr_info_model.dart';
import '../services/sync_read_service.dart';
import 'global_http.dart';
import 'links.dart';

class PDAApi{
  final syncReadService = SyncReadService();

  Future<ReturnedDataModel> deletePdaFromOnline() async {
    SrInfoModel sr = await syncReadService.getSrInfo();
    String dateStr = await SyncReadService().getSalesDate();
    DateTime date = DateTime.parse(dateStr);
    ReturnedDataModel returnedDataModel = ReturnedDataModel(status: ReturnedStatus.error);
    try {
      log('USER INFO IS::::> ${sr.refreshToken}\n${sr.ffId}\n${sr.sectionId}\n${sr.accessToken}');
      String url = "${Links.baseUrl}${Links.pdaDeleteUrl}";

      String path = 'syncFile/${date.year}/${date.month}/${date.day}';
      Map body = {
        "year": date.year,
        "month": date.month,
        "day": date.day,
        "section_id": sr.sectionId,
        "field_force_id": sr.ffId,
      };

      ReturnedDataModel returnedDataModel = await GlobalHttp(
        uri: url,
        httpType: HttpType.delete,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
        body: jsonEncode(body),
      ).fetch();
      if (returnedDataModel.status == ReturnedStatus.success) {

      }
      //
      return returnedDataModel;
    } catch (e, s) {
      print('inside log in api error: $s');
      returnedDataModel.errorMessage = e.toString();
      return returnedDataModel;
    }
  }
}