import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../api/leave_management_api.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/leave_model.dart';
import '../../../models/returned_data_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/cameraScreen.dart';
import '../../../services/Image_service.dart';
import '../../../services/ff_services.dart';
import '../../allowance_management/model/created_tada_model.dart';
import '../../asset_management/controller/asset_controller.dart';

class LeaveController {
  BuildContext context;
  WidgetRef ref;
  late Alerts alerts;

  LeaveManagementAPI leaveManagementAPI = LeaveManagementAPI();

  LeaveController({required this.context, required this.ref})
      : alerts = Alerts(context: context);

  Widget heading(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
        child: LangText(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.sp),
        ),
      ),
    );
  }

  leaveDateRange() async {
    LeaveManagementTypes? leaveType = ref.read(selectedLeaveTypeProvider);
    if (leaveType != null) {
      DateTimeRange? pickedRange = await showDateRangePicker(
        context: context,
        firstDate:
            leaveType.slug == "Medical" ? DateTime(2000) : DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365 ~/ 1)),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
              scaffoldBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        },
      );
      if (pickedRange != null) {
        int inDays = pickedRange.end.difference(pickedRange.start).inDays;
        print(
            '${leaveType.leaveBalance} :: ${(int.parse(leaveType.leaveBalance ?? "0") - leaveType.leaveEnjoyed)}');
        if ((int.parse(leaveType.leaveBalance ?? "0") -
                leaveType.leaveEnjoyed) <
            inDays + 1) {
          alerts.customDialog(
              type: AlertType.warning,
              description: "You can not provide more days than balance");
        } else {
          ref.read(selectedLeaveDateRangeProvider.notifier).state = pickedRange;
        }
      }
    }
  }

  taDaDateRange() async {
    DateTime? pickedRange = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
        lastDate: DateTime.now());
    if (pickedRange != null) {
      bool haveMovement =
          await getTodayMovementForCreateTaDa(pickedDate: pickedRange);
      if (haveMovement) {
        ref.read(selectedMovementDateRangeProvider.notifier).state =
            pickedRange;
      } else {
        ref.refresh(selectedMovementDateRangeProvider);
      }
    }
  }

  movementDateRange() async {
    DateTime? pickedRange = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now().add(const Duration(days: 1)),
        lastDate: DateTime(3000));
    if (pickedRange != null) {
      ref.read(selectedMovementDateRangeProvider.notifier).state = pickedRange;
    }
  }

  Future<bool> getTodayMovementForCreateTaDa(
      {required DateTime pickedDate}) async {
    log("----------->>>>> $pickedDate");

    alerts.floatingLoading();

    ReturnedDataModel returnedDataModel =
        await leaveManagementAPI.getMovementForThisData(
      dateRange: pickedDate ?? DateTime.now(),
    );

    navigatorKey.currentState?.pop();
    if (returnedDataModel.status == ReturnedStatus.success) {
      List availableDataList = returnedDataModel.data["data"]["data"] ?? [];
      if (availableDataList.isNotEmpty) {
        return true;
      } else {
        alerts.customDialog(
            type: AlertType.error,
            description: "No created movement at your selected data.");
      }
    } else {
      alerts.customDialog(
          type: AlertType.error,
          description: "No created movement at your selected data.");
    }
    return false;
  }

  captureMovementImage() {
    Navigator.of(context).pushNamed(CameraScreen.routeName).then((value) async {
      ImageService()
          .compressFile(
              context: context,
              file: File(value.toString()),
              name: 'movement_image_${DateTime.now().millisecondsSinceEpoch}')
          .then((File? compressedImage) async {
        if (compressedImage != null) {
          ref
              .read(outletImageProvider(CapturedImageType.leaveManagementImage)
                  .state)
              .state = compressedImage.path;
        } else {
          // Navigator.pop(context);
          alerts.customDialog(
            type: AlertType.error,
            message: 'Skipped capturing image',
            // description: 'You have to capture retailers image',
          );
        }
      });
    });
  }

  captureTaDaImage({
    required int index,
    required CapturedMultipleImageType type,
  }) {
    ImageService().showImageBottomSheet(
      context: context,
      filePicker: true,
      fromGallery: () async {
        XFile? file = await AssetController(context: context, ref: ref).getImageGallery(context);
        imageProcessing(value: file?.path.toString() ?? '', name: "tada_image_${DateTime.now().millisecondsSinceEpoch}", index: index);
      },
      fromCamera: () async {
        await Future.delayed(const Duration(microseconds: 100));
        Navigator.of(context).pushNamed(CameraScreen.routeName).then((value) async {
          imageProcessing(value: value.toString(), name: "tada_image_${DateTime.now().millisecondsSinceEpoch}", index: index);
        });
      },
      fromFile: () async {
        await Future.delayed(const Duration(microseconds: 100));
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'xlsx', 'xlsm'],
        );

        if (result != null) {
          fileProcessing(value: result.files.single.path!, name: "tada_file_${DateTime.now().millisecondsSinceEpoch}", index: index);
        } else {
          // User canceled the picker
          alerts.customDialog(
            type: AlertType.error,
            message: 'Skipped picked file',
            // description: 'You have to capture retailers image',
          );
        }
        // Navigator.of(context).pushNamed(CameraScreen.routeName).then((value) async {
        //   imageProcessing(value: value.toString(), name: "tada_image_${DateTime.now().millisecondsSinceEpoch}", index: index);
        // });
      },
    );
    // Navigator.of(context).pushNamed(CameraScreen.routeName).then((value) async {
    //   ImageService()
    //       .compressFile(
    //           context: context,
    //           file: File(value.toString()),
    //           name: 'tada_image_${DateTime.now().millisecondsSinceEpoch}')
    //       .then((File? compressedImage) async {
    //     if (compressedImage != null) {
    //       ref.read(multipleImageProvider("${CapturedMultipleImageType.taDa}-$index").notifier).state = compressedImage.path;
    //     } else {
    //       // Navigator.pop(context);
    //       alerts.customDialog(
    //         type: AlertType.error,
    //         message: 'Skipped capturing image',
    //         // description: 'You have to capture retailers image',
    //       );
    //     }
    //   });
    // });
  }

  void imageProcessing({
    required String value,
    required String name,
    required int index,
  }) {
    ImageService().compressFile(context: context, file: File(value.toString()), name: name).then((File? compressedImage) async {
      if (compressedImage != null) {
        ref.read(multipleImageProvider("${CapturedMultipleImageType.taDa}-$index").notifier).state = compressedImage.path;
      } else {
        // Navigator.pop(context);
        alerts.customDialog(
          type: AlertType.error,
          message: 'Skipped capturing image',
          // description: 'You have to capture retailers image',
        );
      }
    });
  }

  void fileProcessing({
    required String value,
    required String name,
    required int index,
  }) {
    final file = File(value.toString());
        ref.read(multipleImageProvider("${CapturedMultipleImageType.taDa}-$index").notifier).state = file.path;
  }

  submitLeaveToServer(String reason) async {
    LeaveManagementTypes? leaveManagementTypes =
        ref.watch(selectedLeaveTypeProvider);
    if (leaveManagementTypes == null) {
      alerts.customDialog(
          type: AlertType.warning,
          description: "You have to select a leave type");
      return;
    }
    DateTimeRange? dateRange = ref.watch(selectedLeaveDateRangeProvider);
    if (dateRange == null) {
      alerts.customDialog(
          type: AlertType.warning,
          description: "You have to select a date range");
      return;
    }
    if (reason.isEmpty) {
      alerts.customDialog(
          type: AlertType.warning, description: "Please provide reason");
      return;
    }
    alerts.floatingLoading();
    ReturnedDataModel returnedDataModel =
        await leaveManagementAPI.sendLeaveData(
            leaveManagementTypes: leaveManagementTypes,
            dateTimeRange: dateRange,
            reason: reason);
    navigatorKey.currentState?.pop();
    if (returnedDataModel.status == ReturnedStatus.success) {
      refreshState();
      navigatorKey.currentState?.pop();
      ref.refresh(leaveDataProvider);
      alerts.customDialog(
          type: AlertType.success,
          description: "Your leave request has been successfully submitted");
    } else {
      alerts.customDialog(
          type: AlertType.error, description: returnedDataModel.errorMessage);
    }
  }

  submitMovementToServer(String reason, String tada) async {
    LeaveManagementTypes? leaveManagementTypes =
        ref.watch(selectedMovementTypeProvider);
    if (leaveManagementTypes == null) {
      alerts.customDialog(
          type: AlertType.warning,
          description: "You have to select a movement type");
      return;
    }
    DateTime? dateRange = ref.watch(selectedMovementDateRangeProvider);
    if (dateRange == null) {
      alerts.customDialog(
          type: AlertType.warning,
          description: "You have to select a date range");
      return;
    }
    if (reason.isEmpty) {
      alerts.customDialog(
          type: AlertType.warning, description: "Please provide reason");
      return;
    }
    // if (tada.isEmpty) {
    //   alerts.customDialog(type: AlertType.warning, description: "Please provide TA/DA");
    //   return;
    // }
    // String? imagePath =
    //     ref.read(outletImageProvider(CapturedImageType.leaveManagementImage).state).state;
    // if (imagePath == null) {
    //   alerts.customDialog(type: AlertType.warning, description: "Please take a photo of the memo");
    //   return;
    // }
    alerts.floatingLoading();
    ReturnedDataModel returnedDataModel =
        await leaveManagementAPI.sendMovementData(
            leaveManagementTypes: leaveManagementTypes,
            dateTimeRange: dateRange,
            reason: reason,
            tada: "",
            imagePath: "");
    navigatorKey.currentState?.pop();
    if (returnedDataModel.status == ReturnedStatus.success) {
      refreshState();
      navigatorKey.currentState?.pop();
      ref.refresh(movementDataProvider);
      alerts.customDialog(
          type: AlertType.success,
          description: "Your movement request has been successfully submitted");
    } else {
      alerts.customDialog(
          type: AlertType.error, description: returnedDataModel.errorMessage);
    }
  }

  updateMovementToServer(
      String reason, String tada, LeaveManagementData updateModel) async {
    LeaveManagementTypes? leaveManagementTypes =
        ref.watch(selectedMovementTypeProvider);
    if (leaveManagementTypes == null) {
      alerts.customDialog(
          type: AlertType.warning,
          description: "You have to select a movement type");
      return;
    }
    DateTime? dateRange = ref.watch(selectedMovementDateRangeProvider);
    if (dateRange == null) {
      alerts.customDialog(
          type: AlertType.warning,
          description: "You have to select a date range");
      return;
    }
    if (reason.isEmpty) {
      alerts.customDialog(
          type: AlertType.warning, description: "Please provide reason");
      return;
    }
    // if (tada.isEmpty) {
    //   alerts.customDialog(type: AlertType.warning, description: "Please provide TA/DA");
    //   return;
    // }
    // String? imagePath =
    //     ref.read(outletImageProvider(CapturedImageType.leaveManagementImage).state).state;
    // if (imagePath == null) {
    //   alerts.customDialog(type: AlertType.warning, description: "Please take a photo of the memo");
    //   return;
    // }
    alerts.floatingLoading();
    ReturnedDataModel returnedDataModel =
        await leaveManagementAPI.sendEditFullMovementData(
      leaveManagementTypes: leaveManagementTypes,
      dateTimeRange: dateRange,
      reason: reason,
      tada: "",
      imagePath: "",
      movement: updateModel,
    );

    navigatorKey.currentState?.pop();
    if (returnedDataModel.status == ReturnedStatus.success) {
      refreshState();
      navigatorKey.currentState?.pop();
      ref.refresh(movementDataProvider);
      alerts.customDialog(
          type: AlertType.success,
          description: "Your movement request has been successfully submitted");
    } else {
      alerts.customDialog(
          type: AlertType.error, description: returnedDataModel.errorMessage);
    }
  }

  refreshState() {
    ref.refresh(outletImageProvider(CapturedImageType.leaveManagementImage));
  }

  String statusCheck(String statusKey) {
    if (statusKey.toLowerCase() == 'approved') {
      return "Approved";
    } else if (statusKey.toLowerCase() == 'rejected') {
      return "Rejected";
    }
    return "Pending";
  }

  Color setStatusColor(String statusKey) {
    Color color = yellow;
    if (statusKey.toLowerCase() == 'approved') {
      color = primary;
    } else if (statusKey.toLowerCase() == 'rejected') {
      color = primaryRed;
    }
    return color;
  }

  void submitMovementEditRequestToServer(
      {required String taDaAmount,
      required LeaveManagementData movement}) async {
    try {
      if (taDaAmount.isEmpty) {
        alerts.customDialog(
            type: AlertType.warning, description: "Please provide TA/DA");
        return;
      }

      final value = int.tryParse(taDaAmount) ?? 0;

      alerts.floatingLoading(message: 'Loading...');
      final result = await leaveManagementAPI.sendEditMovementData(
          value: value, movement: movement);
      navigatorKey.currentState?.pop();

      if (result.status == ReturnedStatus.success) {
        alerts.customDialog(
          type: AlertType.success,
          onTap1: () {
            ref.invalidate(movementDataProvider);
            navigatorKey.currentState?.pop();
            navigatorKey.currentState?.pop();
          },
        );
      } else {
        alerts.customDialog(
            type: AlertType.error,
            message: result.errorMessage,
            onTap1: () {
              navigatorKey.currentState?.pop();
            });
      }
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }
  }

  submitTaDaToServer({
    required String fromAddress,
    required String toAddress,
    required String contactPerson,
    required String contactNumber,
    required String reason,
  }) async {
    DateTime? dateRange = ref.watch(selectedMovementDateRangeProvider);
    if (dateRange == null) {
      alerts.customDialog(
          type: AlertType.warning,
          description: "You have to select a date range");
      return;
    }
    if (fromAddress.isEmpty) {
      alerts.customDialog(
          type: AlertType.warning, description: "Enter from address");
      return;
    }
    if (toAddress.isEmpty) {
      alerts.customDialog(
          type: AlertType.warning, description: "Enter from toAddress");
      return;
    }

    final vehicleTaDa = ref.watch(selectedVehicleListTypeProvider);
    for (var v in vehicleTaDa) {
      if (v.selectedTaDa == null ||
          (v.textEditingController?.text.isEmpty ?? false)) {
        alerts.customDialog(
            type: AlertType.warning,
            description: "Enter all vehicle type and cost");
        return;
      }
    }

    // final otherTaDa = ref.watch(selectedOtherCostListTypeProvider);
    // for(var v in otherTaDa) {
    //   if(v.selectedTaDa ==null || (v.textEditingController?.text.isEmpty ?? false)) {
    //     alerts.customDialog(type: AlertType.warning, description: "Enter all other type and cost");
    //     return;
    //   }
    // }

    if (contactPerson.isEmpty) {
      alerts.customDialog(
          type: AlertType.warning, description: "Enter contact person name");
      return;
    }
    if (contactNumber.isEmpty) {
      alerts.customDialog(
          type: AlertType.warning,
          description: "Enter contact person phone number");
      return;
    }
    if (reason.isEmpty) {
      alerts.customDialog(
          type: AlertType.warning, description: "Please provide reason");
      return;
    }

    alerts.floatingLoading();

    List<String> imagesPathList = [];
    final list = ref.watch(multipleImageListProvider);
    for (int a = 0; a != list.length; a++) {
      var imagePath = ref
          .watch(multipleImageProvider("${CapturedMultipleImageType.taDa}-$a"));
      if (imagePath != null) {
        imagesPathList.add(imagePath);
      }
    }

    ReturnedDataModel returnedDataModel = await leaveManagementAPI.sendTaDaData(
      fromAddress: fromAddress,
      toAddress: toAddress,
      contactPerson: contactPerson,
      contactNumber: contactNumber,
      reason: reason,
      vehicleTaDa: vehicleTaDa,
      otherTaDa: [],
      dateRange: dateRange,
      images: imagesPathList,
    );

    navigatorKey.currentState?.pop();
    if (returnedDataModel.status == ReturnedStatus.success) {
      refreshState();
      navigatorKey.currentState?.pop();
      ref.refresh(taDaDataProvider);
      alerts.customDialog(
          type: AlertType.success,
          description: "Your movement request has been successfully submitted");
    } else {
      alerts.customDialog(
          type: AlertType.error, description: returnedDataModel.errorMessage);
    }
  }

  updateTaDaToServer({
    required String fromAddress,
    required String toAddress,
    required String contactPerson,
    required String contactNumber,
    required String reason,
    required CreatedTaDaModel? updated,
  }) async {
    DateTimeRange? dateRange = ref.watch(selectedLeaveDateRangeProvider);
    if (dateRange == null) {
      alerts.customDialog(
          type: AlertType.warning,
          description: "You have to select a date range");
      return;
    }
    if (fromAddress.isEmpty) {
      alerts.customDialog(
          type: AlertType.warning, description: "Enter from address");
      return;
    }
    if (toAddress.isEmpty) {
      alerts.customDialog(
          type: AlertType.warning, description: "Enter from toAddress");
      return;
    }

    final vehicleTaDa = ref.watch(selectedVehicleListTypeProvider);
    for (var v in vehicleTaDa) {
      if (v.selectedTaDa == null ||
          (v.textEditingController?.text.isEmpty ?? false)) {
        alerts.customDialog(
            type: AlertType.warning,
            description: "Enter all vehicle type and cost");
        return;
      }
    }

    // final otherTaDa = ref.watch(selectedOtherCostListTypeProvider);
    // for(var v in otherTaDa) {
    //   if(v.selectedTaDa ==null || (v.textEditingController?.text.isEmpty ?? false)) {
    //     alerts.customDialog(type: AlertType.warning, description: "Enter all other type and cost");
    //     return;
    //   }
    // }

    if (contactPerson.isEmpty) {
      alerts.customDialog(
          type: AlertType.warning, description: "Enter contact person name");
      return;
    }
    if (contactNumber.isEmpty) {
      alerts.customDialog(
          type: AlertType.warning,
          description: "Enter contact person phone number");
      return;
    }
    if (reason.isEmpty) {
      alerts.customDialog(
          type: AlertType.warning, description: "Please provide reason");
      return;
    }

    alerts.floatingLoading();

    List<String> imagesPathList = [];
    final list = ref.watch(multipleImageListProvider);
    for (int a = 0; a != list.length; a++) {
      var imagePath = ref
          .watch(multipleImageProvider("${CapturedMultipleImageType.taDa}-$a"));
      if (imagePath != null) {
        imagesPathList.add(imagePath);
      }
    }

    ReturnedDataModel returnedDataModel =
        await leaveManagementAPI.updateTaDaData(
      fromAddress: fromAddress,
      toAddress: toAddress,
      contactPerson: contactPerson,
      contactNumber: contactNumber,
      reason: reason,
      vehicleTaDa: vehicleTaDa,
      otherTaDa: [],
      dateRange: dateRange,
      images: imagesPathList,
      tada: updated,
    );

    navigatorKey.currentState?.pop();
    if (returnedDataModel.status == ReturnedStatus.success) {
      refreshState();
      navigatorKey.currentState?.pop();
      ref.refresh(taDaDataProvider);
      alerts.customDialog(
          type: AlertType.success,
          description: "Your movement request has been successfully submitted");
    } else {
      alerts.customDialog(
          type: AlertType.error, description: returnedDataModel.errorMessage);
    }
  }
}
