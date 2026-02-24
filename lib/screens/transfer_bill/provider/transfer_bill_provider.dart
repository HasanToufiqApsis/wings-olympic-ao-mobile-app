import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wings_olympic_sr/main.dart';
import '../../../models/returned_data_model.dart';
import '../controller/transfer_bill_controller.dart';

final transferBillStatusProvider =
    FutureProvider.autoDispose<ReturnedDataModel>((ref) async {
  final context = navigatorKey.currentContext!;
  final controller = TransferBillController(context: context);
  return await controller.getTransferBills();
});
