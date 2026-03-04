import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/enum.dart';
import '../../../models/returned_data_model.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../models/stock_validation_model.dart';
import '../repository/stock_validation_repository.dart';

class StockValidationController {
  final BuildContext context;
  final WidgetRef ref;
  late final Alerts _alerts;

  StockValidationController({required this.context, required this.ref}) {
    _alerts = Alerts(context: context);
  }

  Future<void> submit(List<Map<String, dynamic>> verificationData) async {
    _alerts.floatingLoading();
    try {
      final payload = {
        'qcVerificationData': verificationData,
        'verificationSource': 'app',
      };
      final ReturnedDataModel result =
          await StockValidationRepository().submitQcVerification(payload);
      Navigator.of(context).pop(); // dismiss loading
      if (result.status == ReturnedStatus.success) {
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
        _alerts.customDialog(
          type: AlertType.error,
          message: result.errorMessage ?? 'Submission failed. Please try again.',
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // dismiss loading
      _alerts.customDialog(
        type: AlertType.error,
        message: 'An error occurred: ${e.toString()}',
      );
    }
  }
}
