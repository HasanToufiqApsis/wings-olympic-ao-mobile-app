import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_luban/flutter_luban.dart';

import '../../../api/asset_management_api.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/maintanence_model.dart';
import '../../../models/returned_data_model.dart';
import '../../../models/sr_info_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/scaffold_widgets/cameraScreen.dart';
import '../../../services/Image_service.dart';
import '../../../services/sync_read_service.dart';

class MaintenanceController {
  BuildContext context;
  WidgetRef ref;
  late Alerts _alerts;

  MaintenanceController({
    required this.context,
    required this.ref,
  })  : _alerts = Alerts(context: context),
        lang = ref.read(languageProvider);

  String lang = "বাংলা";

  String maintenancePhotoName = "";

  void installData({
    required MaintenanceModel maintenance,
    required String partsDetails,
    required String totalCost,
    required String reason,
  }) async {
    if (partsDetails.isEmpty) {
      _alerts.customDialog(type: AlertType.warning, description: "Please enter spear parts details");
      return;
    }
    if (totalCost.isEmpty) {
      _alerts.customDialog(type: AlertType.warning, description: "Please enter total cost");
      return;
    }
    if (reason.isEmpty) {
      _alerts.customDialog(type: AlertType.warning, description: "Please enter reason");
      return;
    }

    String? maintenancePath = ref.read(outletImageProvider(CapturedImageType.maintenance).notifier).state;

    if (maintenancePhotoName.isEmpty || maintenancePath == null) {
      _alerts.customDialog(type: AlertType.warning, description: "Please capture photo");
      return;
    }

    SrInfoModel sr = await SyncReadService().getSrInfo();
    Map payload = {
      "task_id": maintenance.id,
      "spare_parts": partsDetails,
      "cost": int.tryParse(totalCost),
      "remark": reason,
      "image": maintenancePhotoName,
      "user_id": sr.ffId,
    };
    _alerts.floatingLoading();


    await ImageService().sendImage(maintenancePath, "asset/maintenance_image/${maintenance.id}");

    ReturnedDataModel returnedDataModel = await AssetManagementAPI().maintenanceCompleteAPI(payload, sr);
    navigatorKey.currentState?.pop();
    if (returnedDataModel.status == ReturnedStatus.success) {
      navigatorKey.currentState?.pop();
      String desc = "Asset Maintenance for ${maintenance.outletName} is successfully done.";
      if (lang != "en") {
        desc = "${maintenance.outletName} এর জন্য অ্যাসেট মেইন্টেনেন্স সফল হয়েছে।";
      }
      ref.refresh(getAllMaintenanceList);
      ref.refresh(outletImageProvider(CapturedImageType.maintenance));
      _alerts.customDialog(type: AlertType.success, description: desc);
    } else {
      _alerts.customDialog(type: AlertType.error, description: returnedDataModel.errorMessage);
    }
  }


  void imageProcessing({
    required String value,
    required String name,
    required CapturedImageType type,
  }) {
    ImageService().compressFile(context: context, file: File(value.toString()), name: name).then((File? compressedImage) async {
      if (compressedImage != null) {
        ref.read(outletImageProvider(type).notifier).state = compressedImage.path;
        if (type == CapturedImageType.maintenance) {
          maintenancePhotoName = "$name.jpg";
        }
      } else {
        // Navigator.pop(context);
        _alerts.customDialog(
          type: AlertType.error,
          message: 'Skipped capturing image',
        );
      }
    });
  }


  Future<XFile?> getImageGallery(context) async {
    ImagePicker picker = ImagePicker();

    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    return pickedImage;
  }

  void getCapturePhoto(CapturedImageType type) async {
    SrInfoModel? sr = await SyncReadService().getSrInfo();
    String name = "maintenance_image_${sr.ffId}_${DateTime.now().millisecondsSinceEpoch}";
    if (type == CapturedImageType.assetInstallationPhoto) {
      Navigator.of(context).pushNamed(CameraScreen.routeName).then((value) async {
        imageProcessing(value: value.toString(), name: name, type: type);
      });
    } else {
      ImageService().showImageBottomSheet(
        context: context,
        fromGallery: () async {
          XFile? file = await getImageGallery(context);
          imageProcessing(value: file?.path.toString() ?? '', name: name, type: type);
        },
        fromCamera: () async {
          await Future.delayed(const Duration(microseconds: 100));
          Navigator.of(context).pushNamed(CameraScreen.routeName).then((value) async {
            imageProcessing(value: value.toString(), name: name, type: type);
          });
        },
      );
    }
  }
}
