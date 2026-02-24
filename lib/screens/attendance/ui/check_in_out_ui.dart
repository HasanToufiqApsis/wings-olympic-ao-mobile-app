import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

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
  Completer<GoogleMapController> mapController = Completer();
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

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _onMapCreated() {

    if(widget.lat!=0 && widget.lng !=0) {
      final marker = Marker(
        markerId: const MarkerId('place_name'),
        position: LatLng(widget.lat, widget.lng),
        // icon: BitmapDescriptor.,
        infoWindow: const InfoWindow(
          title: 'title',
          snippet: 'address',
        ),
      );

      setState(() {
        markers[MarkerId('place_name')] = marker;
      });
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                return Container();
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

                      return Column(
                        children: [
                          Container(
                            width: 100.w,
                            // height: 30.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(appBarRadius), bottomLeft: Radius.circular(appBarRadius)),
                              boxShadow: [
                                BoxShadow(
                                  color: lightMediumGrey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: const Offset(0, 1), // changes position of shadow
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.access_time),
                                        Consumer(builder: (context, ref, _) {
                                          DateTime time = ref.watch(attendanceDateTimeProvider);
                                          return LangText(
                                            uiTimeFormat.format(time),
                                            isNumber: true,
                                            isNum: false,
                                          );
                                        })
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.location_on_outlined),
                                        LangText(
                                          locationData.address?.street ?? "N/A",
                                          isNumber: true,
                                          isNum: false,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Visibility(
                                  visible: widget.lat==0 && widget.lng ==0,
                                  child: GlobalWidgets().showInfo(message: "Point base location not found"),
                                ),
                                Visibility(
                                  visible: widget.lat!=0 && widget.lng !=0,
                                  child: GlobalWidgets().showInfo(message: hint),
                                ),
                                SizedBox(height: 14),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                //   children: [
                                //     Row(
                                //       mainAxisSize: MainAxisSize.min,
                                //       children: [
                                //         const Icon(Icons.access_time),
                                //         LangText(
                                //           "$distance",
                                //           isNumber: true,
                                //           isNum: false,
                                //         )
                                //       ],
                                //     ),
                                //   ],
                                // ),
                                Consumer(builder: (context, ref, _) {
                                  String selfie = ref.watch(attendanceSelfiePathProvider);
                                  if (selfie.isEmpty) {
                                    return SizedBox(
                                      height: 6.h,
                                    );
                                  }
                                  return Image.file(
                                    File(selfie),
                                    height: 16.h,
                                  );
                                }),
                                SizedBox(
                                  height: 2.h,
                                ),
                                InkWell(
                                  onTap: () {
                                    attendanceController.takeSelfie(type: widget.type);
                                  },
                                  child: SizedBox(
                                    width: 100.w,
                                    child: Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          LangText("Take a photo"),
                                          SizedBox(
                                            width: 2.w,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(color: lightMediumGrey, borderRadius: BorderRadius.circular(50.sp)),
                                            padding: EdgeInsets.all(5.sp),
                                            child: const Center(
                                              child: Icon(Icons.camera_alt),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                               /* Container(
                                  width: 100.w,
                                  height: 30.h,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(appBarRadius)),
                                  child: GoogleMap(
                                    onMapCreated: (GoogleMapController controller) {
                                      mapController.complete(controller);
                                      _onMapCreated();
                                    },
                                    initialCameraPosition: CameraPosition(
                                      // bearing: 180.8334901395799,
                                      // target: LatLng(23.827060, 90.375589),
                                      target: LatLng(locationData.lat, locationData.long),
                                      // tilt: 180.440717697143555,
                                      zoom: 14,
                                    ),
                                    markers: markers.values.toSet(),
                                    myLocationEnabled: true,
                                    zoomControlsEnabled: true,
                                    zoomGesturesEnabled: true,
                                    rotateGesturesEnabled: true,
                                    scrollGesturesEnabled: true,
                                  ),
                                )*/
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          SubmitButtonGroup(
                            twoButtons: false,
                            onButton1Pressed: () {
                              attendanceController.checkInOutProceed(widget.type, locationData, widget.id, lat: widget.lat, lng: widget.lng, depId: widget.depId);
                            },
                          )
                        ],
                      );
                    },
                    error: (error, _) => Container(),
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: Colors.black,),
                    ));
              });
            },
            error: (error, _) => Container(),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                ));
      }),
    );
  }
}
