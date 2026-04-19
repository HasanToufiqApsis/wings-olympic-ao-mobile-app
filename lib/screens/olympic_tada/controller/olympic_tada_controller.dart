import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/leave_management_api.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/returned_data_model.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../model/olympic_da_info.dart';
import '../model/olympic_tada_entry.dart';
import '../service/olympic_tada_service.dart';

class OlympicTaDaController {
  OlympicTaDaController({required this.context, required this.ref})
      : alerts = Alerts(context: context);

  final BuildContext context;
  final WidgetRef ref;
  final Alerts alerts;
  final LeaveManagementAPI leaveManagementAPI = LeaveManagementAPI();
  final OlympicTaDaService _service = OlympicTaDaService();

  String? validateEntries({
    required List<OlympicTaDaEntry> entries,
    required OlympicDaInfo? daInfo,
  }) {
    if (daInfo == null) {
      return 'Complete the required survey first to get DA.';
    }

    final filledEntries = entries.where((entry) => !entry.isEmpty).toList();
    if (filledEntries.isEmpty) {
      return 'Add at least one TA row before saving or submitting.';
    }

    for (final entry in filledEntries) {
      if (!entry.isComplete) {
        return 'Complete vehicle, from, to, and amount for every TA row.';
      }
    }

    return null;
  }

  Future<void> draftTaDa({
    required List<OlympicTaDaEntry> entries,
    required OlympicDaInfo? daInfo,
    required String remarks,
  }) async {
    final validationMessage =
        validateEntries(entries: entries, daInfo: daInfo);
    if (validationMessage != null) {
      alerts.customDialog(
        type: AlertType.warning,
        description: validationMessage,
      );
      return;
    }

    await _service.draftTaDa(
      entries: entries,
      remarks: remarks,
      daInfo: daInfo,
    );

    alerts.customDialog(
      type: AlertType.success,
      description: 'Your Ta/Da has been saved as draft.',
    );
  }

  Future<void> submitTaDaToServer({
    required List<OlympicTaDaEntry> entries,
    required OlympicDaInfo? daInfo,
    required String remarks,
  }) async {
    final validationMessage =
        validateEntries(entries: entries, daInfo: daInfo);
    if (validationMessage != null) {
      alerts.customDialog(
        type: AlertType.warning,
        description: validationMessage,
      );
      return;
    }

    alerts.floatingLoading();

    final ReturnedDataModel returnedDataModel =
        await leaveManagementAPI.sendOlympicTaDaData(
      taEntries: entries.where((entry) => !entry.isEmpty).toList(),
      daInfo: daInfo!,
      remarks: remarks,
    );

    navigatorKey.currentState?.pop();
    if (returnedDataModel.status == ReturnedStatus.success) {
      _service.taDaSubmitted();
      navigatorKey.currentState?.pop();
      alerts.customDialog(
        type: AlertType.success,
        description: 'Your Ta/Da request has been successfully submitted.',
      );
    } else {
      alerts.customDialog(
        type: AlertType.error,
        description:
            returnedDataModel.errorMessage ?? 'Failed to submit Ta/Da.',
      );
    }
  }
}
