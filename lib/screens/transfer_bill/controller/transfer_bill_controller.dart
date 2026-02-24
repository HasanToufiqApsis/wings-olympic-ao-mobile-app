import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:io';
import '../../../api/global_http.dart';
import '../../../api/links.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../models/returned_data_model.dart';
import '../../../models/sr_info_model.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../services/ff_services.dart';
import '../../../services/helper.dart';
import '../../../services/image_service.dart';
import '../../../services/connectivity_service.dart';

class TransferBillController {
  BuildContext context;
  late Alerts alerts;
  final FFServices _ffServices = FFServices();

  TransferBillController({required this.context}) : alerts = Alerts(context: context);

  Future<ReturnedDataModel> submitTransferBill({
    required String fromLocation,
    required String toLocation,
    required num amount,
    required String description,
    String? imagePath,
    String? billCopyPath,
    required DateTime selectedDate,
  }) async {
    ReturnedDataModel returned = ReturnedDataModel(status: ReturnedStatus.error);
    try {
      SrInfoModel? srInfo = await _ffServices.getSrInfo();
      if (srInfo != null) {
        String serverImagePath = imagePath ?? "";
        String serverBillPath = billCopyPath ?? "";


        bool looksLikeLocalImage = serverImagePath.isNotEmpty && !(serverImagePath.contains('transferBill') );
        bool looksLikeLocalBill = serverBillPath.isNotEmpty && !(serverBillPath.contains('transferBill') );

        if (looksLikeLocalImage) {
          return ReturnedDataModel(status: ReturnedStatus.error, errorMessage: 'Selected image path appears local; please wait for instant upload to complete.');
        }
        if (looksLikeLocalBill) {
          return ReturnedDataModel(status: ReturnedStatus.error, errorMessage: 'Selected bill copy path appears local; please wait for instant upload to complete.');
        }

        Map payload = {
          "field_force_id": srInfo.ffId,
          "from_location": fromLocation,
          "to_location": toLocation,
          "transfer_date": apiDateFormat.format(selectedDate),
          "amount": amount,
          "description": description,
          "image_path": serverImagePath,
          "bill_copy_path": serverBillPath,
        };
        log(jsonEncode(payload));
        String url = Links.baseUrl + Links.transferBill;
        returned = await GlobalHttp(
          uri: url,
          httpType: HttpType.post,
          body: jsonEncode(payload),
          accessToken: srInfo.accessToken,
          refreshToken: srInfo.refreshToken,
        ).fetch();
      }
    } catch (e) {
      Helper.dPrint("inside transfer bill controller catch block $e");
    }
    return returned;
  }

  Future<ReturnedDataModel> getTransferBills() async {
    ReturnedDataModel returned = ReturnedDataModel(status: ReturnedStatus.error);
    try {
      SrInfoModel? srInfo = await _ffServices.getSrInfo();
      if (srInfo != null) {
        String url = "${Links.baseUrl}${Links.allTransferBills}";
        returned = await GlobalHttp(
          uri: url,
          httpType: HttpType.get,
          accessToken: srInfo.accessToken,
          refreshToken: srInfo.refreshToken,
        ).fetch();
      }
    } catch (e) {
      Helper.dPrint("inside transfer bill controller catch block $e");
    }
    return returned;
  }

  Future<String?> sendTransferImageToServer(File compressedImage) async {
    try {
        SrInfoModel? sr = await _ffServices.getSrInfo();
        String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
        String path = "transferBill/${sr?.ffId}/$timeStamp";
        bool done = await ImageService().sendImage(compressedImage.path, path);
        if (done) {
          if (await compressedImage.exists()) {
            await compressedImage.delete();
          }
          // return full server path: path + filename
          return '$path/${basename(compressedImage.path)}';
      }
    } catch (e) {
      Helper.dPrint('sendTransferImageToServer error: $e');
    }
    return null;
  }

  Future<String?> sendTransferBillFileToServer(File file) async {
    try {
        SrInfoModel? sr = await _ffServices.getSrInfo();
        String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
        String path = "transferBill/${sr?.ffId}/$timeStamp";
        bool done = await ImageService().sendImage(file.path, path);
        if (done) {
          if (await file.exists()) {
            await file.delete();
          }
          return '$path/${basename(file.path)}';
        }
    } catch (e) {
      Helper.dPrint('sendTransferBillFileToServer error: $e');
    }
    return null;
  }
}
