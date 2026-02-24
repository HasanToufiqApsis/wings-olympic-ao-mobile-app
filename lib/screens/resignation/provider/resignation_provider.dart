
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wings_olympic_sr/main.dart';
import '../../../models/returned_data_model.dart';
import '../controller/resignation_controller.dart';

final resignationStatusProvider =
FutureProvider.autoDispose<ReturnedDataModel>((ref) async {
  final context = navigatorKey.currentContext!;
  final controller = ResignationController(context: context);
  return await controller.getResignationStatus();
});