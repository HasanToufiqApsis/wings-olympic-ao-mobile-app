import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/returned_data_model.dart';
import '../../../models/sr_info_model.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../services/connectivity_service.dart';
import '../../../services/product_category_services.dart';
import '../../../services/sync_read_service.dart';
import '../model/aws_product_model.dart';
import '../services/aws_services.dart';

class AwsStockController{
  final BuildContext context;
  final WidgetRef ref;

  AwsStockController({required this.context, required this.ref}) : _alerts = Alerts(context: context);

  late final Alerts _alerts;
  final ProductCategoryServices productCategoryServices = ProductCategoryServices();
  final SyncReadService syncReadService = SyncReadService();
  final AwsService awsService = AwsService();

  Future<bool> saveAllSkuCountDataForAws(List<AwsProductModel> productList)async{
    _alerts.floatingLoading();
    List<Map> payload = [];
    SrInfoModel srInfoModel = await syncReadService.getSrInfo();
    try{
      for(AwsProductModel sku in productList){
        Map singleItem = {
          "ff_id": srInfoModel.ffId,
          "sbu_id": sku.moduleId,
          "dep_id": srInfoModel.depId,
          "sku_id": sku.id,
          "quantity": sku.stockCount,
          "damage": sku.damagedCount,
          "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        };
        payload.add(singleItem);
      }
      log("payload for aws stock count: ${jsonEncode(payload)}");
      bool internetOn = await ConnectivityService().checkInternet();
      if(internetOn){
        ReturnedDataModel returnedDataModel = await awsService.sendAwsStockDataToApi(payload);
        navigatorKey.currentState?.pop();
        if(returnedDataModel.status == ReturnedStatus.success){
          _alerts.customDialog(type: AlertType.success, message: returnedDataModel.data['message'], onTap1: (){
            Navigator.pop(context);
            Navigator.pop(context);
          });
        }
        else{
          _alerts.customDialog(type: AlertType.error, message: returnedDataModel.errorMessage);
        }


        return returnedDataModel.status == ReturnedStatus.success;
      }
      else{
        navigatorKey.currentState?.pop();
        _alerts.customDialog(type: AlertType.error, message: "Please turn on your internet.");
      }

    }
    catch(e,s){
      debugPrint(e.toString());
      debugPrint(s.toString());
    }

    return false;

  }
}