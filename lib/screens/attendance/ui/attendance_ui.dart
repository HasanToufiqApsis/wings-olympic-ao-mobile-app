import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/dashboard_btn_names.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../models/attendance_model.dart';
import '../../../models/location_address_model.dart';
import '../../../models/sr_info_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../services/sync_read_service.dart';
import '../controller/attendance_controller.dart';
import 'attendance_widget.dart';

class AttendanceUI extends ConsumerStatefulWidget {
  const AttendanceUI({Key? key}) : super(key: key);
  static const routeName = "/attendance_ui";

  @override
  ConsumerState<AttendanceUI> createState() => _AttendanceUIState();
}

class _AttendanceUIState extends ConsumerState<AttendanceUI> {
  final _appBarTitle = DashboardBtnNames.attendance;
  late AttendanceController attendanceController;

  @override
  void initState() {
    super.initState();
    attendanceController = AttendanceController(context: context, ref: ref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _appBarTitle,
        titleImage: "attendance.png",
        onLeadingIconPressed: () {
          Navigator.pop(context);
        },
        heroTagTitle: _appBarTitle,
        heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
      ),
      body: Consumer(builder: (context, ref, _) {
        bool isConnected = ref.watch(internetConnectivityProvider);

        if (isConnected == true) {
          return Consumer(builder: (context, ref, _) {
            AsyncValue<AttendanceModel> asyncAttendanceStatus = ref.watch(attendanceStatusCheckProvider);
            return asyncAttendanceStatus.when(
                data: (attendanceModel) {
                  print("attendace ${attendanceModel.status}");
                  return Container(
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
                      children: [
                        20.verticalSpacing,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              ref.watch(languageProvider) == 'en' ? 'Your current location is' : 'আপনার বর্তমান অবস্থান',
                              textAlign: TextAlign.center,
                            ),
                            Consumer(
                              builder: (context, ref, child) {
                                final asyncCurrentAddress = ref.watch(currentAddressProvider);
                                return asyncCurrentAddress.when(data: (locationAddress) {
                                  if (locationAddress == null) {
                                    return const SizedBox();
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 30.0),
                                    child: Text(
                                      getLocationName(address: locationAddress.address),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  );
                                }, error: (e, t) {
                                  return const Padding(
                                    padding: EdgeInsets.only(bottom: 30.0),
                                    child: Center(
                                      child: Text('Unable to get current location\n'),
                                    ),
                                  );
                                }, loading: () {
                                  return const Padding(
                                    padding: EdgeInsets.only(bottom: 30.0),
                                    child: Center(
                                      child: Text(
                                        'Loading location data...',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                });
                              },
                            ),
                            _buildAttendanceStatusBadge(attendanceModel),
                            const SizedBox(height: 18),
                            Consumer(builder: (context, ref, _) {
                              AsyncValue<LocationAddressModel<Placemark?>?> asyncLocation = ref.watch(currentAddressProvider);
                              return asyncLocation.when(
                                  data: (locationData) {
                                    if (locationData == null) {
                                      return Container();
                                    }
                                    return AttendanceWidget(
                                      enabled: attendanceModel.status == AttendanceStatus.noAttendance,
                                      icon: Icons.arrow_downward,
                                      text: '',
                                      color: const Color(0xFFA9FFC1),
                                      dotColor: const Color(0xFF439B46),
                                      width: 192,
                                      height: 117,
                                      onTap: () async {
                                        // if(attendanceModel.status == AttendanceStatus.noAttendance){
                                        //   navigatorKey.currentState?.pushNamed(CheckInOutUI.routeName, arguments:{
                                        //     attendanceStatusKey: AttendanceType.checkIn,
                                        //     attendanceIdKey: attendanceModel.id
                                        //   });
                                        // }
                                        // attendanceController.tryToCheckIn(location: locationData);

                                        SrInfoModel sr = await SyncReadService().getSrInfo();
                                        attendanceController.gotoCheckIn(attendanceModel, locationData);
                                      },
                                    );
                                  },
                                  error: (error, _) => Container(),
                                  loading: () => const Center(
                                    child: CircularProgressIndicator(),
                                  ));
                            }),
                            if (attendanceModel.status == AttendanceStatus.noAttendance)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 22,
                                ),
                                child: Text(
                                  ref.watch(languageProvider) == 'en' ? 'To check in\npress the button' : 'চেক ইন করতে এখানে প্রেস করুন',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            if (attendanceModel.status == AttendanceStatus.checkInDone || attendanceModel.status == AttendanceStatus.attendanceDone)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 35,
                                  vertical: 22,
                                ),
                                child: Text(
                                  ref.watch(languageProvider) == 'en'
                                      ? 'You already checked in from ${attendanceMap[checkedInAddressKey]}' //'You already checked in from ${attendanceMap[checkedInAddressKey]} at ${attendanceModel.inTime?.hourlyDateFormat}'
                                      : 'আপনি ইতিমধ্যে ${attendanceMap[checkedInAddressKey]} থেকে চেক ইন করেছেন',
                                  //'আপনি ইতিমধ্যে ${attendanceMap[checkedInAddressKey]} থেকে ${attendanceModel.inTime?.hourlyDateFormat}-এ চেক ইন করেছেন'
                                  textAlign: TextAlign.center,
                                ),
                              )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Consumer(builder: (context, ref, _) {
                              AsyncValue<LocationAddressModel<Placemark?>?> asyncLocation = ref.watch(currentAddressProvider);
                              return asyncLocation.when(
                                  data: (locationData) {
                                    if (locationData == null) {
                                      return Container();
                                    }
                                    return AttendanceWidget(
                                      enabled: attendanceModel.status == AttendanceStatus.checkInDone,
                                      icon: Icons.arrow_back,
                                      text: 'Check Out',
                                      color: const Color(0xFFFFE2E2),
                                      dotColor: const Color(0xFFA70E13),
                                      width: 192,
                                      height: 117,
                                      onTap: () async {
                                        // attendanceController.tryToCheckIn(location: locationData, checkOut: true);
                                        SrInfoModel sr = await SyncReadService().getSrInfo();
                                        attendanceController.gotoCheckOut(attendanceModel, locationData);
                                      },
                                    );
                                  },
                                  error: (error, _) => Container(),
                                  loading: () => const Center(
                                    child: CircularProgressIndicator(),
                                  ));
                            }),
                            if (attendanceModel.status == AttendanceStatus.checkInDone)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 22,
                                ),
                                child: Text(
                                  ref.watch(languageProvider) == 'en' ? 'To check out\npress the button' : 'চেক আউট করতে এখানে প্রেস করুন',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            if (attendanceModel.status != AttendanceStatus.noAttendance && attendanceModel.status != AttendanceStatus.checkInDone)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 22,
                                  left: 35,
                                  right: 35,
                                ),
                                child: Text(
                                  ref.watch(languageProvider) == 'en'
                                      ? 'You already checked out from ${attendanceMap[checkedOutAddressKey]}' //'You already checked out from ${attendanceMap[checkedOutAddressKey]} at ${attendanceModel.outTime?.hourlyDateFormat}'
                                      : 'আপনি ইতিমধ্যে ${attendanceMap[checkedOutAddressKey]} থেকে চেক আউট করেছেন',
                                  //'আপনি ইতিমধ্যে ${attendanceMap[checkedOutAddressKey]} থেকে ${attendanceModel.outTime?.hourlyDateFormat}-এ চেক আউট করেছেন'
                                  textAlign: TextAlign.center,
                                ),
                              )
                          ],
                        ),
                      ],
                    ),
                  );
                },
                error: (e, s) {
                  return Center(
                    child: LangText("No attendance Data found"),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ));
          });
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.signal_wifi_statusbar_connected_no_internet_4_rounded, size: 64, color: green,),
                LangText("Offline", style: TextStyle(fontWeight: FontWeight.bold, fontSize: largeFontSize),),
                LangText("Please turn on your internet connection"),
                const SizedBox(height: 50,)
              ],
            ),
          );
        }
      }),
    );
  }

  String getLocationName({Placemark? address}) {
    bool location1 = false;
    bool location2 = false;
    bool location3 = false;
    String location1Name = '';
    String location2Name = '';
    String location3Name = '';
    if (address?.subLocality != null) {
      location1 = true;
      location1Name = '${address?.subLocality}, ';
    }
    if (address?.locality != null) {
      location2 = true;
      location2Name = '${address?.locality}\n';
    }
    if (address?.street != null) {
      location3 = true;
      location3Name ='${address?.street}';
    }

    if (location1 || location2 || location3) {
      return '$location1Name$location2Name$location3Name';
    }
    String s = ref.watch(languageProvider);
    if (s == "en") {
      return 'Not found';
    }
    return 'পাওয়া যায়নি';
  }

  Widget _buildAttendanceStatusBadge(AttendanceModel attendanceModel) {
    final status = attendanceModel.status;
    final backgroundColor = _getAttendanceStatusBackground(status);
    final textColor = _getAttendanceStatusTextColor(status);
    final label = _getAttendanceStatusLabel(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: textColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _getAttendanceStatusLabel(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.noAttendance:
        return 'Not Checked In';
      case AttendanceStatus.checkInDone:
        return 'Checked In';
      case AttendanceStatus.attendanceDone:
        return 'Checked Out';
    }
  }

  Color _getAttendanceStatusBackground(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.noAttendance:
        return const Color(0xFFFFF1CC);
      case AttendanceStatus.checkInDone:
        return const Color(0xFFDFF7E5);
      case AttendanceStatus.attendanceDone:
        return const Color(0xFFFFE1E1);
    }
  }

  Color _getAttendanceStatusTextColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.noAttendance:
        return const Color(0xFF8A6300);
      case AttendanceStatus.checkInDone:
        return const Color(0xFF1F7A36);
      case AttendanceStatus.attendanceDone:
        return const Color(0xFFB3261E);
    }
  }
}
