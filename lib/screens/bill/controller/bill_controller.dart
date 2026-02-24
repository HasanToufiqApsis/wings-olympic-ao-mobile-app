import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/bill_api.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/bill/bill_data_model.dart';
import '../../../models/returned_data_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';

class BillController {
  BuildContext context;
  WidgetRef ref;
  late Alerts _alerts;

  BillController({
    required this.context,
    required this.ref,
  })  : _alerts = Alerts(context: context),
        lang = ref.read(languageProvider);
  String lang = "বাংলা";

  void disburseBill({required BillDataModel bill}) async {
    try{
      BillAPI api = BillAPI();

      _alerts.floatingLoading();
      ReturnedDataModel returnedDataModel = await api.billDisburseAPI(bill.billId);
      navigatorKey.currentState?.pop();

      if (returnedDataModel.status == ReturnedStatus.success) {
        navigatorKey.currentState?.pop();
        String desc = "Bill disburse for ${bill.outletName}";
        if (lang != "en") {
          desc = "${bill.outletName} এর জন্য বিল বিতরণ হয়েছে";
        }
        _alerts.customDialog(type: AlertType.success, description: desc);
        ref.refresh(getAllBillList);
      } else {
        _alerts.customDialog(type: AlertType.error, description: returnedDataModel.errorMessage);
      }
    } catch (e,t){
      log(e.toString());
      log(t.toString());
    }
  }


}
