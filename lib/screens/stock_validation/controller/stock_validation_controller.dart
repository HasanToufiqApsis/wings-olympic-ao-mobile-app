import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/enum.dart';
import '../../../models/returned_data_model.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../services/sync_read_service.dart';
import '../models/stock_validation_model.dart';
import '../providers/stock_validation_providers.dart';
import '../repository/stock_validation_repository.dart';

class StockValidationController {
  final BuildContext context;
  final WidgetRef ref;
  late final Alerts _alerts;

  StockValidationController({required this.context, required this.ref}) {
    _alerts = Alerts(context: context);
  }

  Future<void> onSubmit({
    required List<QcEntryModel> entries,
    required Map<int, TextEditingController> volumeControllers,
    required Map<int, TextEditingController> remarkControllers,
    required String date,
  }) async {
    final srInfo = await SyncReadService().getSrInfo();
    final sbuIdStr = srInfo.sbuId.replaceAll('[', '').replaceAll(']', '');
    final sbuId = int.tryParse(sbuIdStr) ?? 1;

    final List<Map<String, dynamic>> verificationData = [];
    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final editedVolumeStr = volumeControllers[i]?.text;
      if (editedVolumeStr == null || editedVolumeStr.isEmpty) {
        _alerts.customDialog(type: AlertType.error, message: 'Please enter a valid volume for entry ${entry.skuInfo.shortName}');
        return;
      }
      final editedVolume = num.tryParse(editedVolumeStr) ?? 0;
      final remark = remarkControllers[i]?.text ?? '';
      verificationData.add({
        'sbu_id': sbuId,
        'dep_id': entry.depId,
        'section_id': entry.sectionId,
        'outlet_id': entry.outletId,
        'qc_entry_date': entry.qcEntryDate,
        'sku_id': entry.skuId,
        'fault_id': entry.faultId,
        'unit_price': entry.unitPrice,
        'volume': editedVolume,
        'total_value': entry.unitPrice * editedVolume,
        'date': date,
        'remark': remark,
      });
    }
    await submit(verificationData);
  }

  Future<void> onPointSubmit({
    required List<PointQcEntryModel> entries,
    required Map<int, TextEditingController> volumeControllers,
    required Map<int, TextEditingController> remarkControllers,
    required String date,
  }) async {
    final srInfo = await SyncReadService().getSrInfo();
    final sbuIdStr = srInfo.sbuId.replaceAll('[', '').replaceAll(']', '');
    final sbuId = int.tryParse(sbuIdStr) ?? 1;
    final depId = srInfo.depId ?? 0;

    final List<Map<String, dynamic>> verificationData = [];
    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final editedVolumeStr = volumeControllers[i]?.text;
      if (editedVolumeStr == null || editedVolumeStr.isEmpty) {
        _alerts.customDialog(
          type: AlertType.error,
          message: 'Please enter a valid volume for entry ${entry.skuName}',
        );
        return;
      }
      final editedVolume = num.tryParse(editedVolumeStr) ?? 0;
      final remark = remarkControllers[i]?.text ?? '';
      verificationData.add({
        'sbu_id': sbuId,
        'dep_id': depId,
        'sku_id': entry.skuId,
        'fault_id': entry.faultId,
        'unit_price': entry.unitPrice,
        'volume': editedVolume,
        'total_value': entry.unitPrice * editedVolume,
        'date': date,
        'remark': remark,
      });
    }
    await submitPointQcVarification(
      verificationData,
    );
  }

  Future<void> submit(
    List<Map<String, dynamic>> verificationData) async {
    _alerts.floatingLoading();
    try {
      final payload = {'qcVerificationData': verificationData, 'verificationSource': 'app'};
      final ReturnedDataModel result = await StockValidationRepository().submitQcVerification(payload);
      Navigator.of(context).pop(); // dismiss loading
      if (result.status == ReturnedStatus.success) {
        ref.invalidate(stockValidationProvider);
        _alerts.customDialog(
          type: AlertType.success,
          message: 'Verification submitted successfully!',
          button1: 'OK',
          onTap1: () {
            Navigator.of(context).pop(); // dismiss dialog
            Navigator.of(context).pop(); // pop details screen
          },
        );
      } else {
        _alerts.customDialog(type: AlertType.error, message: result.errorMessage ?? 'Submission failed. Please try again.');
      }
    } catch (e) {
      Navigator.of(context).pop(); // dismiss loading
      _alerts.customDialog(type: AlertType.error, message: 'An error occurred: ${e.toString()}');
    }
  }

  Future<void> submitPointQcVarification(
    List<Map<String, dynamic>> verificationData
      ) async {
    _alerts.floatingLoading();
    try {
      final payload = {'qcVerificationData': verificationData};
      final ReturnedDataModel result = await StockValidationRepository().submitPointQcVerification(payload);
      Navigator.of(context).pop(); // dismiss loading
      if (result.status == ReturnedStatus.success) {
          ref.invalidate(pointValidationProvider);
        _alerts.customDialog(
          type: AlertType.success,
          message: 'Verification submitted successfully!',
          button1: 'OK',
          onTap1: () {
            Navigator.of(context).pop();
          },
        );
      } else {
        _alerts.customDialog(type: AlertType.error, message: result.errorMessage ?? 'Submission failed. Please try again.');
      }
    } catch (e) {
      Navigator.of(context).pop(); // dismiss loading
      _alerts.customDialog(type: AlertType.error, message: 'An error occurred: ${e.toString()}');
    }
  }
}
