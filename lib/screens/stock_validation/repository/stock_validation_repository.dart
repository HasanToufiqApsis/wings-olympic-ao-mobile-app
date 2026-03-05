import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../api/global_http.dart';
import '../../../api/links.dart';
import '../../../constants/enum.dart';
import '../../../models/returned_data_model.dart';
import '../../../services/sync_read_service.dart';

class StockValidationRepository {
  Future<ReturnedDataModel> getQcVerificationData() async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(
      status: ReturnedStatus.error,
    );
    try {
      final sr = await SyncReadService().getSrInfo();
      final url = Links.getOutletWiseQcUrl(depId: sr.depId??0);
      returnedDataModel = await GlobalHttp(
        uri: url,
        httpType: HttpType.get,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
      ).fetch();
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    // return ReturnedDataModel(
    //   status: ReturnedStatus.success,
    //   data: {
    //     "message": "Data fetched successfully!",
    //     "success": true,
    //     "data": {
    //       "qcData": {
    //         "1166": {
    //           "2025-08-16": [
    //             {
    //               "dep_id": 125,
    //               "section_id": 205,
    //               "outlet_id": 1166,
    //               "outlet_code": "CBD-G1-21",
    //               "sku_id": 81,
    //               "fault_id": 109,
    //               "fault_type": "Test Child QC Fault",
    //               "volume": "1",
    //               "value": 40000,
    //               "unit_price": 40000,
    //               "qc_entry_date": "2025-08-17",
    //               "sku_info": {
    //                 "id": 81,
    //                 "short_name": "Energy Plus",
    //                 "material_code": "Energy"
    //               }
    //             }
    //           ],
    //           "2025-08-17": [
    //             {
    //               "dep_id": 125,
    //               "section_id": 205,
    //               "outlet_id": 1166,
    //               "outlet_code": "CBD-G1-21",
    //               "sku_id": 81,
    //               "fault_id": 109,
    //               "fault_type": "Test Child QC Fault",
    //               "volume": "1",
    //               "value": 40000,
    //               "unit_price": 40000,
    //               "qc_entry_date": "2025-08-17",
    //               "sku_info": {
    //                 "id": 81,
    //                 "short_name": "Energy Plus",
    //                 "material_code": "Energy"
    //               }
    //             }
    //           ]
    //         },
    //         "1171": {
    //           "2025-08-17": [
    //             {
    //               "dep_id": 125,
    //               "section_id": 205,
    //               "outlet_id": 1171,
    //               "outlet_code": "CBD-G1-22",
    //               "sku_id": 81,
    //               "fault_id": 109,
    //               "fault_type": "Test Child QC Fault",
    //               "volume": "1",
    //               "value": 40000,
    //               "unit_price": 40000,
    //               "qc_entry_date": "2025-08-17",
    //               "sku_info": {
    //                 "id": 81,
    //                 "short_name": "Energy Plus",
    //                 "material_code": "Energy"
    //               }
    //             },
    //             {
    //               "dep_id": 125,
    //               "section_id": 205,
    //               "outlet_id": 1171,
    //               "outlet_code": "CBD-G1-22",
    //               "sku_id": 81,
    //               "fault_id": 109,
    //               "fault_type": "Test Child QC Fault",
    //               "volume": "1",
    //               "value": 40000,
    //               "unit_price": 40000,
    //               "qc_entry_date": "2025-08-17",
    //               "sku_info": {
    //                 "id": 82,
    //                 "short_name": "Energy Plus2",
    //                 "material_code": "Energy2"
    //               }
    //             }
    //           ]
    //         }
    //       },
    //       "lastSubmittedDate": "2026-03-04T05:01:27.000Z"
    //     }
    //   }
    // );
    return returnedDataModel;
  }

  Future<ReturnedDataModel> submitQcVerification(Map payload) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(
      status: ReturnedStatus.error,
    );
    try {
      final sr = await SyncReadService().getSrInfo();
      final url = Links.submitOutletWiseQcUrl;
      returnedDataModel = await GlobalHttp(
        uri: url,
        httpType: HttpType.post,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
        body: jsonEncode(payload),
      ).fetch();
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return returnedDataModel;
  }

  Future<ReturnedDataModel> submitPointQcVerification(Map payload) async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(
      status: ReturnedStatus.error,
    );
    try {
      final sr = await SyncReadService().getSrInfo();
      final url = Links.submitPointWiseQcUrl;
      print("-->> ${url}");
      print("-->> ${jsonEncode(payload)}");
      returnedDataModel = await GlobalHttp(
        uri: url,
        httpType: HttpType.post,
        accessToken: sr.accessToken,
        refreshToken: sr.refreshToken,
        body: jsonEncode(payload),
      ).fetch();
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return returnedDataModel;
  }

  Future<ReturnedDataModel> getPointQcVerificationData() async {
    ReturnedDataModel returnedDataModel = ReturnedDataModel(
      status: ReturnedStatus.error,
    );
    try {
      final sr = await SyncReadService().getSrInfo();
      final url = Links.getPointWiseQcUrl(depId: sr.depId ?? 0);
      returnedDataModel = await GlobalHttp(
        uri: url,
        httpType: HttpType.get,
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
