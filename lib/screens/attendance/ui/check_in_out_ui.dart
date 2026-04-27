import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../models/location_address_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../controller/attendance_controller.dart';
import '../model/attendance_provider_model.dart';

class CheckInOutUI extends ConsumerStatefulWidget {
  const CheckInOutUI({
    required this.type,
    required this.id,
    required this.lat,
    required this.lng,
    this.depId,
    super.key,
  });
  final AttendanceType type;
  final int id;
  final double lat;
  final double lng;
  final int? depId;
  static const routeName = "/check_in_check_out_ui";

  @override
  ConsumerState<CheckInOutUI> createState() => _CheckInOutUIState();
}

class _CheckInOutUIState extends ConsumerState<CheckInOutUI> {
  late AttendanceController attendanceController;
  late AttendanceProviderModel attendanceProviderModel;

  @override
  void initState() {
    attendanceProviderModel = AttendanceProviderModel(context: context, lat: widget.lat, long:  widget.lng);
    super.initState();
    attendanceController = AttendanceController(context: context, ref: ref);
    attendanceController.clock();
  }

  @override
  void dispose() {
    super.dispose();
    attendanceController.disposeTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBGColor,
      appBar: CustomAppBar(
          title: widget.type == AttendanceType.checkIn ? "Check In" : "Check Out",
          onLeadingIconPressed: () {
            Navigator.pop(context);
          }),
      body: Consumer(builder: (context, ref, _) {
        AsyncValue<LocationAddressModel<Placemark?>?> asyncLocation = ref.watch(currentAddressProvider);
        return asyncLocation.when(
            data: (locationData) {
              if (locationData == null) {
                return const SizedBox();
              }
              return Consumer(builder: (context, ref, _) {
                final asyncDistance = ref.watch(getDistanceProvider(attendanceProviderModel));
                String lang = ref.watch(languageProvider);
                String hint = "";

                return asyncDistance.when(
                    data: (distance) {
                      if(distance!=null && distance > 0) {
                        String finalDistance = GlobalWidgets().numberEnglishToBangla(num: distance.toStringAsFixed(2), lang: lang);
                        if(lang != "en"){
                          hint = "আপনি টার্গেটেড পয়েন্ট থেকে $finalDistance মিটার দূরে আছেন";
                        } else {
                          hint = "You are $finalDistance meters away from the target point";
                        }
                      }

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildInfoCard(locationData, hint),
                              4.h.verticalSpacing,
                              SubmitButtonGroup(
                                twoButtons: false,
                                onButton1Pressed: () {
                                  attendanceController.checkInOutProceed(widget.type, locationData, widget.id, lat: widget.lat, lng: widget.lng, depId: widget.depId);
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    error: (error, _) => const SizedBox(),
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: Colors.black,),
                    ));
              });
            },
            error: (error, _) => const SizedBox(),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                ));
      }),
    );
  }

  Widget _buildInfoCard(LocationAddressModel<Placemark?> locationData, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.access_time, color: primary),
                    2.w.horizontalSpacing,
                    Flexible(
                      child: Consumer(builder: (context, ref, _) {
                        DateTime time = ref.watch(attendanceDateTimeProvider);
                        return LangText(
                          uiTimeFormat.format(time),
                          isNumber: true,
                          isNum: false,
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on, color: primary),
                    2.w.horizontalSpacing,
                    Flexible(
                      child: LangText(
                        locationData.address?.street ?? "N/A",
                        isNumber: true,
                        isNum: false,
                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          3.h.verticalSpacing,
          Visibility(
            visible: widget.lat==0 && widget.lng ==0,
            child: GlobalWidgets().showInfo(message: "Point base location not found"),
          ),
          Visibility(
            visible: widget.lat!=0 && widget.lng !=0,
            child: GlobalWidgets().showInfo(message: hint),
          ),
          2.h.verticalSpacing,
          Consumer(builder: (context, ref, _) {
            String selfie = ref.watch(attendanceSelfiePathProvider);
            if (selfie.isEmpty) {
              return const SizedBox();
            }
            return Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(selfie),
                  height: 16.h,
                  fit: BoxFit.cover,
                ),
              ),
            );
          }),
          InkWell(
            onTap: () {
              attendanceController.takeSelfie(type: widget.type);
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 4.w),
              decoration: BoxDecoration(
                color: lightMediumGrey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LangText(
                    "Take a photo",
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: primaryBlack),
                  ),
                  3.w.horizontalSpacing,
                  Container(
                    decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(50.sp)),
                    padding: EdgeInsets.all(5.sp),
                    child: const Center(
                      child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

