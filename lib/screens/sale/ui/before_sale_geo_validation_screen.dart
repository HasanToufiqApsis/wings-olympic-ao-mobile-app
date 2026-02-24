import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../constants/sync_global.dart';
import '../../../models/outlet_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../controller/sale_controller.dart';
import 'capture_cooler_image.dart';
import 'cooler_purity_score.dart';
import 'manual_override_ui.dart';
import 'reasoning_check.dart';
import 'sale_v2_widget/sale_v2_dashboard.dart';
import 'sale_yes_no.dart';
import 'take_product_ui.dart';
import 'unsold_outlet_ui.dart';

class BeforeSaleGeoValidationScreenUI extends ConsumerStatefulWidget {
  const BeforeSaleGeoValidationScreenUI({required this.saleEdit, Key? key}) : super(key: key);
  final bool saleEdit;

  @override
  ConsumerState<BeforeSaleGeoValidationScreenUI> createState() => _BeforeSaleGeoValidationScreenUIState();
}

class _BeforeSaleGeoValidationScreenUIState extends ConsumerState<BeforeSaleGeoValidationScreenUI> {
  late final SaleController _saleController;

  @override
  void initState() {
    super.initState();
    _saleController = SaleController(context: context, ref: ref);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.saleEdit) {
        ref.read(outletSaleStatusProvider.notifier).state = OutletSaleStatus.showSkus;
      }
    });
  }


  late TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    OutletModel? outlet = ref.watch(selectedRetailerProvider);
    OutletSaleStatus geoFencingStatus = ref.watch(outletSaleStatusProvider);
    switch (geoFencingStatus) {
      case OutletSaleStatus.inactive:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 16,
              ),
              LangText(
                'Please select a retailer..',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      case OutletSaleStatus.checkingGeoFencing:
        return Center(
          child: Hero(
            tag: "background",
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(
                      color: Colors.blue[600],
                      strokeWidth: 3,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  const SizedBox(height: 24),
                  LangText(
                    'Validating your location with outlet location...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      case OutletSaleStatus.manualOverride:
        return ManualOverrideUI(
          onGeoFencingRefresh: () {
            _saleController.checkGeoFencing(outlet);
          },
          onManualOverride: () {
            if (outlet!.outletLocation.reasoningCheck == true) {
              ref.read(outletSaleStatusProvider.notifier).state = OutletSaleStatus.reasoning;
            } else {
              _saleController.manualOverride(outlet, -1);
            }
          },
        );
      case OutletSaleStatus.reasoning:
        return ReasoningCheckUI(onManualOverrideDone: (int reason) {
          _saleController.manualOverride(outlet!, reason);
        });
      // case OutletSaleStatus.preview:
      //   String imagePath = ref.read(coolerImagePathProvider);
      //   File image = File(imagePath);
      //   return PreviewCoolerImage()
      case OutletSaleStatus.callStart:
        return SaleYesNoUI(onCallStart: () {
          //start call
          callStartTime = DateTime.now();
          _saleController.handlePreorderCallStart(outlet!);
          // _saleController.handleAVKVWOMSurveys(outlet!);
          // ref.read(outletSaleStatusProvider.notifier).state = OutletSaleStatus.showSkus;
        });
      case OutletSaleStatus.showSkus:
        return SalesUIv2Dashboard();
        // return TakePreorderUI();
      case OutletSaleStatus.captureCoolerImage:
        return CaptureCoolerImage(
          onCaptureCoolerImage: () {
            _saleController.captureCoolerImageBeforePreorder(outlet!);
          },
        );
      case OutletSaleStatus.coolerPurityScore:
        return CoolerPurityScore(
          onSubmit: (v) {
            _saleController.submitCoolerPurityScore(outlet!, v);
          },
        );
      case OutletSaleStatus.onUnsoldOutletPressed:
        return const UnsoldOutletUI();
      default:
        return Container();
    }
  }
}
