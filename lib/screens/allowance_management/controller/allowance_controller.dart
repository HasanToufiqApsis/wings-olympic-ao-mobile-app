import 'dart:io';

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

class AllowanceController {
  BuildContext context;
  WidgetRef ref;
  late Alerts alerts;

  LeaveManagementAPI leaveManagementAPI = LeaveManagementAPI();

  AllowanceController({required this.context, required this.ref}) : alerts = Alerts(context: context);

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
        firstDate: leaveType.slug == "Medical" ? DateTime(2000) : DateTime.now(),
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
        if ((int.parse(leaveType.leaveBalance ?? "0") - leaveType.leaveEnjoyed) < inDays + 1) {
          alerts.customDialog(
              type: AlertType.warning, description: "You can not provide more days than balance");
        } else {
          ref.read(selectedLeaveDateRangeProvider.notifier).state = pickedRange;
        }
      }
    }
  }

  movementDateRange() async {
    LeaveManagementTypes? leaveType = ref.read(selectedMovementTypeProvider);
    if (leaveType != null) {
      // DateTimeRange? pickedRange = await showDateRangePicker(
      //   context: context,
      //   firstDate: DateTime.now(),
      //   lastDate: DateTime.now().add(
      //       const Duration(days: 365~/1)),
      //   builder: (BuildContext context, Widget? child) {
      //     return Theme( data:ThemeData( scaffoldBackgroundColor: Colors.white, ), child: child!,);
      //   },
      // );
      DateTime? pickedRange = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(3000));
      if (pickedRange != null) {
        ref.read(selectedMovementDateRangeProvider.notifier).state = pickedRange;
      }
    }
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
          ref.read(outletImageProvider(CapturedImageType.leaveManagementImage).state).state =
              compressedImage.path;
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

  submitLeaveToServer(String reason) async {
    LeaveManagementTypes? leaveManagementTypes = ref.watch(selectedLeaveTypeProvider);
    if (leaveManagementTypes == null) {
      alerts.customDialog(type: AlertType.warning, description: "You have to select a leave type");
      return;
    }
    DateTimeRange? dateRange = ref.watch(selectedLeaveDateRangeProvider);
    if (dateRange == null) {
      alerts.customDialog(type: AlertType.warning, description: "You have to select a date range");
      return;
    }
    if (reason.isEmpty) {
      alerts.customDialog(type: AlertType.warning, description: "Please provide reason");
      return;
    }
    alerts.floatingLoading();
    ReturnedDataModel returnedDataModel = await leaveManagementAPI.sendLeaveData(
        leaveManagementTypes: leaveManagementTypes, dateTimeRange: dateRange, reason: reason);
    navigatorKey.currentState?.pop();
    if (returnedDataModel.status == ReturnedStatus.success) {
      refreshState();
      navigatorKey.currentState?.pop();
      alerts.customDialog(
          type: AlertType.success,
          description: "Your leave request has been successfully submitted");
    } else {
      alerts.customDialog(type: AlertType.error, description: returnedDataModel.errorMessage);
    }
  }

  submitMovementToServer(String reason, String tada) async {
    LeaveManagementTypes? leaveManagementTypes = ref.watch(selectedMovementTypeProvider);
    if (leaveManagementTypes == null) {
      alerts.customDialog(
          type: AlertType.warning, description: "You have to select a movement type");
      return;
    }
    DateTime? dateRange = ref.watch(selectedMovementDateRangeProvider);
    if (dateRange == null) {
      alerts.customDialog(type: AlertType.warning, description: "You have to select a date range");
      return;
    }
    if (reason.isEmpty) {
      alerts.customDialog(type: AlertType.warning, description: "Please provide reason");
      return;
    }
    if (tada.isEmpty) {
      alerts.customDialog(type: AlertType.warning, description: "Please provide TA/DA");
      return;
    }
    String? imagePath =
        ref.read(outletImageProvider(CapturedImageType.leaveManagementImage).state).state;
    if (imagePath == null) {
      alerts.customDialog(type: AlertType.warning, description: "Please take a photo of the memo");
      return;
    }
    alerts.floatingLoading();
    ReturnedDataModel returnedDataModel = await leaveManagementAPI.sendMovementData(
        leaveManagementTypes: leaveManagementTypes,
        dateTimeRange: dateRange,
        reason: reason,
        tada: tada,
        imagePath: imagePath);
    navigatorKey.currentState?.pop();
    if (returnedDataModel.status == ReturnedStatus.success) {
      refreshState();
      navigatorKey.currentState?.pop();
      alerts.customDialog(
          type: AlertType.success,
          description: "Your movement request has been successfully submitted");
    } else {
      alerts.customDialog(type: AlertType.error, description: returnedDataModel.errorMessage);
    }
  }

  refreshState() {
    ref.refresh(outletImageProvider(CapturedImageType.leaveManagementImage));
  }

  String statusCheck(int statusKey) {
    String status = "Pending";
    if (statusKey == 1) {
      status = "Approved";
    } else if (statusKey == 2) {
      status = "Rejected";
    }
    return status;
  }

  Color setStatusColor(int statusKey) {
    Color color = yellow;
    if (statusKey == 1) {
      color = primary;
    } else if (statusKey == 2) {
      color = primaryRed;
    }
    return color;
  }

  void submitMovementEditRequestToServer({required String taDaAmount, required LeaveManagementData movement}) async {
    try {
      if (taDaAmount.isEmpty) {
        alerts.customDialog(type: AlertType.warning, description: "Please provide TA/DA");
        return;
      }

      final value = int.tryParse(taDaAmount) ?? 0;

      alerts.floatingLoading(message: 'Loading...');
      final result = await leaveManagementAPI.sendEditMovementData(value: value, movement: movement);
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
          }
        );
      }
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }
  }
}
