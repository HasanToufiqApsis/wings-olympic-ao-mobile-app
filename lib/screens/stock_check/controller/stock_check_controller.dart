import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wings_olympic_sr/screens/stock_check/service/stock_check_service.dart';

import '../../../constants/constant_keys.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/outlet_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/scaffold_widgets/cameraScreen.dart';
import '../../../services/Image_service.dart';
import '../../../utils/stock_check_utils.dart';
import '../../sale/ui/preview_cooler_image.dart';
import '../providers/stock_check_providers.dart';

class StockCheckController {
  BuildContext context;
  WidgetRef ref;

  StockCheckController({required this.context, required this.ref})
      : _alerts = Alerts(context: context);

  late final Alerts _alerts;


  Future<void> pickBeforeImage(BuildContext context, StockCheckStatus source, OutletModel? outlet) async {
    try {
      // final outlet = ref.watch(selectedRetailerProvider);
      if(outlet != null) {
        Navigator.of(context).pushNamed(CameraScreen.routeName).then((value) async {
          if (value != null) {
            ref.read(stockCheckImagePathProvider.notifier).state = value.toString();
            Alerts(context: context).showModalWithWidget(
              margin: EdgeInsets.symmetric(vertical: 100, horizontal: 16),
              child: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  String filePath = ref.watch(stockCheckImagePathProvider);
                  File image = File(filePath);
                  return PreviewCoolerImage(
                    coolerImage: filePath.isEmpty ? File(value.toString()) : image,
                    onTryAgainPressed: () {
                      navigatorKey.currentState?.pop();
                      // manualOverride(outlet, reasonId);
                    },
                    onSubmitPressed: () {
                      final imageName = "${stockCheckImageFolder}_${outlet.id}_${StockCheckUtils.toStr(source)}_${DateTime.now().microsecondsSinceEpoch}";
                      Navigator.pop(context);
                      ImageService().compressFile(
                          context: context,
                          file: filePath.isEmpty ? File(value.toString()) : image,
                          name: imageName
                      )
                          .then(
                            (File? compressedImage) async {
                          ref.read(stockCheckImagePathProvider.notifier).state =
                              value.toString();

                          if (compressedImage != null) {
                            _alerts.floatingLoading();
                            await StockCheckService().sendManualOverrideImageToServer(compressedImage, source, outlet, imageName);
                            this.ref.refresh(stockCheckProvider);
                            navigatorKey.currentState?.pop();
                          } else {
                            _alerts.customDialog(
                              type: AlertType.error,
                              message: 'Skipped capturing image',
                              description: 'You have to capture stock image',
                            );
                          }
                        },
                      );
                    },
                  );
                },
              ),
            );
          } else {
            _alerts.customDialog(
              type: AlertType.error,
              message: 'Skipped capturing image',
              description: 'You have to capture stock image for this outlet',
            );
          }
        });

      }

    } catch (e) {
      debugPrint("Error picking before image: $e");
    }
  }
}




