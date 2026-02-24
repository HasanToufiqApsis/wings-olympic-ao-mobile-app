import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/constant_variables.dart';
import 'package:wings_olympic_sr/reusable_widgets/global_widgets.dart';
import 'package:wings_olympic_sr/reusable_widgets/language_textbox.dart';
import 'package:wings_olympic_sr/screens/stock_check/controller/stock_check_controller.dart';
import 'package:wings_olympic_sr/services/Image_service.dart';
import 'package:wings_olympic_sr/utils/stock_check_utils.dart';

import '../../../constants/enum.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../providers/stock_check_providers.dart';

class StockCheckUI extends ConsumerStatefulWidget {
  const StockCheckUI({Key? key}) : super(key: key);
  static const String routeName = "/stock_check";

  @override
  _StockCheckUIState createState() => _StockCheckUIState();
}

class _StockCheckUIState extends ConsumerState<StockCheckUI> {
  late StockCheckController stockCheckController;
  late Alerts alerts;

  @override
  void initState() {
    super.initState();
    stockCheckController = StockCheckController(context: context, ref: ref);
    alerts = Alerts(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final stockCheck = ref.watch(stockCheckProvider);
    final outlet = ref.watch(selectedRetailerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(
        title: "Stock Check",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            children: [
              _buildImageSection(
                context,
                "Before Image",
                stockCheck.beforeImage,
                stockCheck.canRetakeBefore,
                () {
                  if (stockCheck.canRetakeBefore) {
                    stockCheckController.pickBeforeImage(
                      context,
                      StockCheckStatus.beforeImage,
                      outlet!,
                    );
                  } else {
                    alerts.customDialog(
                      type: AlertType.warning,
                      message: "You are not able to retake this image.",
                    );
                  }
                },
                Icons.camera_front_outlined,
              ),
              SizedBox(height: 2.h),
              _buildImageSection(
                context,
                "After Image",
                stockCheck.afterImage,
                stockCheck.canRetakeAfter,
                () {
                  if (stockCheck.canRetakeAfter) {
                    stockCheckController.pickBeforeImage(
                      context,
                      StockCheckStatus.afterImage,
                      outlet!,
                    );
                  } else {
                    alerts.customDialog(
                      type: AlertType.warning,
                      message: "You are not able to retake this image.",
                    );
                  }
                },
                Icons.camera_rear_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(
    BuildContext context,
    String title,
    File? image,
    bool canRetake,
    Function() onPickImage,
    IconData headerIcon,
  ) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(headerIcon, color: Colors.blue, size: 20),
                ),
                SizedBox(width: 12),
                LangText(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                GestureDetector(
                  onTap: onPickImage,
                  child: Container(
                    height: 22.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: image != null ? Colors.black : Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: image != null ? Colors.transparent : Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(image, fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo_rounded, size: 40, color: Colors.grey[400]),
                              SizedBox(height: 8),
                              LangText(
                                "Tap to capture",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                if (image != null && canRetake)
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: onPickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          side: BorderSide(color: primary.withOpacity(0.5)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh_rounded, size: 18, color: primary),
                            SizedBox(width: 8),
                            LangText(
                              "Retake Photo",
                              style: const TextStyle(
                                color: primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
