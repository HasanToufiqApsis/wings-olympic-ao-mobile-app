import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/models/fare_chart_model.dart';
import 'package:wings_olympic_sr/screens/olympic_tada/service/olympic_tada_service.dart';

import '../../../api/leave_management_api.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/leave_model.dart';
import '../../../models/returned_data_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/cameraScreen.dart';
import '../../../services/Image_service.dart';
import '../../../services/ff_services.dart';

class OlympicTaDaController {
  BuildContext context;
  WidgetRef ref;
  late Alerts alerts;

  LeaveManagementAPI leaveManagementAPI = LeaveManagementAPI();

  OlympicTaDaController({required this.context, required this.ref})
      : alerts = Alerts(context: context);

  final _service = OlympicTaDaService();

  Future draftTaDa({required String remarks}) async {
    try {
      final vehicleTaDa = ref.watch(selectedOlympicTaDaTypeProvider);
      for (var v in vehicleTaDa) {
        if (v.selectedTaDa == null || (v.textEditingController?.text.isEmpty ?? false)) {
          alerts.customDialog(
              type: AlertType.warning,
              description: "Enter all vehicle type and cost");
          return;
        }
      }
      await _service.draftTaDa(vehicleTaDa: vehicleTaDa, remarks: remarks);
      alerts.customDialog(
        type: AlertType.success,
        description: "Your Ta/Da successfully saved as draft",
      );
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
  }


  Future<void> submitTaDaToServer({
    required List<FareChartModel> fareCharts,
    required String remarks,
  }) async {

    final vehicleTaDa = ref.watch(selectedOlympicTaDaTypeProvider);
    for (var v in vehicleTaDa) {
      if (v.selectedTaDa == null ||
          (v.textEditingController?.text.isEmpty ?? false)) {
        alerts.customDialog(
            type: AlertType.warning,
            description: "Enter all vehicle type and cost");
        return;
      }
    }

    alerts.floatingLoading();

    List<String> imagesPathList = [];
    final list = ref.watch(multipleImageListProvider);
    for (int a = 0; a != list.length; a++) {
      var imagePath = ref
          .watch(multipleImageProvider("${CapturedMultipleImageType.taDa}-$a"));
      if (imagePath != null) {
        imagesPathList.add(imagePath);
      }
    }

    final taDaExpense =  await _service.taDaVehicleTypeList();
    final fixedTaDaExpense =  await _service.fixedTaDaVehicleTypeList();

    ReturnedDataModel returnedDataModel = await leaveManagementAPI.sendOlympicTaDaData(
      extraTaDa: vehicleTaDa,
      fareCharts: fareCharts,
      images: imagesPathList,
      remarks: remarks,
      taDaExpense: taDaExpense,
      fixedTaDaExpense: fixedTaDaExpense,
    );

    navigatorKey.currentState?.pop();
    if (returnedDataModel.status == ReturnedStatus.success) {
      _service.taDaSubmitted();
      navigatorKey.currentState?.pop();
      // ref.refresh(taDaDataProvider);
      alerts.customDialog(
        type: AlertType.success,
        description: "Your Ta/Da request has been successfully submitted",
      );
    } else {
      alerts.customDialog(
          type: AlertType.error, description: returnedDataModel.errorMessage);
    }
  }
}
