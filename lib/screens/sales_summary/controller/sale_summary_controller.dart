import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SaleSummaryController {
  late BuildContext context;
  late WidgetRef ref;
  SaleSummaryController({required this.context, required this.ref});

  // Future<Map<String, double>> getCreditData() async {
  //   Map<String, double> data = {};
  //   try {
  //     Map creditMap = await UnnotiServices().getTotalCreditGiven();
  //     double due = await UnnotiServices().getTotalDueCollection();
  //     if (creditMap.isNotEmpty || due != 0.0) {
  //       data["creditGiven"] = creditMap["credit_given"];
  //       data["carry_amount"] = creditMap["carry_amount"];
  //
  //       data["due"] = due;
  //       ref.read(creditDataProvider.state).state = data;
  //     }
  //   } catch (e, s) {
  //     print("inside salesummarycontroller getCreditData error $e, $s");
  //   }
  //   return data;
  // }
}
