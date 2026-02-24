import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';

class PrintMemoController {
  BuildContext context;
  WidgetRef ref;
  late Alerts alerts;

  PrintMemoController({required this.context, required this.ref}) : alerts = Alerts(context: context);

  movementDateRange() async {
    DateTime date = ref.watch(selectedPrintMemoDateProvider);
    DateTime? pickedRange = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2024),
        lastDate: DateTime.now(),
    );
    if (pickedRange != null) {
      ref.read(selectedPrintMemoDateProvider.notifier).state = pickedRange;
    }
  }
}