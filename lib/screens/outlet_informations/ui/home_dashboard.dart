import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/constant_keys.dart';
import 'package:wings_olympic_sr/constants/enum.dart';
import 'package:wings_olympic_sr/constants/dashboard_btn_names.dart';
import 'package:wings_olympic_sr/screens/olympic_tada/ui/olympic_tada_ui.dart';
import 'package:wings_olympic_sr/screens/outlet_informations/ui/statistics_widget.dart';
import 'package:wings_olympic_sr/screens/outlet_informations/ui/strike_rate_widget.dart';
import 'package:wings_olympic_sr/screens/outlet_informations/ui/target_achievement_widget.dart';
import 'package:wings_olympic_sr/screens/outlet_informations/ui/tsm_dashboard.dart';
import 'package:wings_olympic_sr/screens/resignation/ui/resignation_ui.dart';
import 'package:wings_olympic_sr/screens/sale/model/product_view.dart';
import 'package:wings_olympic_sr/screens/sale/providers/sale_providers.dart';
import 'package:wings_olympic_sr/screens/stock/ui/stock_ui.dart';
import 'package:wings_olympic_sr/screens/transfer_bill/ui/transfer_bill_list_ui.dart';
import 'package:wings_olympic_sr/services/shared_storage_services.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/location_category_models.dart';
import '../../../models/module.dart';
import '../../../models/sr_info_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../services/change_route_service.dart';
import '../../../services/connectivity_service.dart';
import '../../../services/ff_services.dart';
import '../../../services/geo_location_service.dart';
import '../../../services/langugae_pack_service.dart';
import '../../../services/location_category_services.dart';
import '../../../services/outlet_services.dart';
import '../../../services/sync_service.dart';
import '../../../api/attendance_api.dart';
import '../../allowance_management/ui/allowance_management_ui.dart';
import '../../approval/ui/approval_dashboard.dart';
import '../../asset_management/ui/asset_ui.dart';
import '../../asset_ro/ui/asset_ro_ui.dart';
import '../../attendance/ui/attendance_ui.dart';
import '../../audit/ui/audit_ui.dart';
import '../../bill/ui/bill_ui.dart';
import '../../delivery/ui/before_delivary_sync_ui.dart';
import '../../delivery/ui/delivery_selection_ui.dart';
import '../../digital_learning/ui/digital_learning_ui.dart';
import '../../friday_sell/ui/friday_sales_ui.dart';
import '../../leave_management/ui/leave_management_ui.dart';
import '../../maintenance/ui/maintenance_ui.dart';
import '../../memo/ui/memo_ui.dart';
import '../../notification/model/notification_model.dart';
import '../../notification/providers/notification_provider.dart';
import '../../notification/screens/notification_screen.dart';
import '../../pjp_plan/ui/pjp_plan_ui.dart';
import '../../promotions_list/ui/promotion_list_screen.dart';
import '../../request_for_change_journey_plan/ui/change_route_ui.dart';
import '../../sale_submit/ui/sale_submit_ui.dart';
import '../../sales_summary/ui/sales_summary_ui.dart';
import '../../settings/ui/settings_ui.dart';
import '../../stock_validation/ui/stock_validation_ui.dart';
import '../../target_achievement/ui/target_and_achievement_dashboard_ui.dart';
import '../../tsm_dashboard/providers/tsm_dahboard_providers.dart';
import '../../tsm_dashboard/tsm_team_performance/ui/tsm_web_pannel_web_view.dart';
import '../controller/outlet_controller.dart';
import 'outlet_list_ui.dart';

class HomeDashboard extends ConsumerStatefulWidget {
  static const routeName = "/outlet_dashboard";

  const HomeDashboard({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends ConsumerState<HomeDashboard> {
  late final OutletController _outletController;
  final _useHero = false;
  final _outletServices = OutletServices();
  final _locationServices = LocationCategoryServices();
  final _ffServices = FFServices();

  @override
  void initState() {
    super.initState();
    SyncService().printSync();
    LocationService(context).initialize();
    _outletController = OutletController(context: context, ref: ref);
    WidgetsBinding.instance.addPostFrameCallback((val) async {
      // await _syncAttendanceRestrictionForHome();
      final viewComplexityStr = await LocalStorageHelper.read(viewComplexityKey);
      if (viewComplexityStr != null) {
        final viewComplexity = ViewComplexity.fromString(viewComplexityStr.toString());
        log('view complexity => $viewComplexityStr');
        ref.read(productViewTypeProvider.notifier).state = viewComplexity ?? ViewComplexity.complex;
      }
      await _checkAndShowOutletSelectionPopup();
    });
    _welcomeMessage();
  }

  Future<void> _checkAndShowOutletSelectionPopup() async {
    final isEmpty = await _outletServices.isOutletListEmpty();
    if (isEmpty && mounted) {
      await _showOutletSelectionPopup();
    }
  }

  String _getSrRouteSubTitle(SrInfoModel? srInfo) {
    if (srInfo == null) return "";

    final route = srInfo.srRoute;
    final wpf = srInfo.wpf;

    if (route.isEmpty) return "";

    if (wpf == 1) {
      return " $route (WPF*)";
    }

    return " ($route)";
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<SrInfoModel?> asyncSrInfo = ref.watch(userDataProvider);
    final attendanceLockedProvider = ref.watch(homeDashboardAttendanceLockedProvider);

    return attendanceLockedProvider.when(
      data: (attendanceLocked) {
        return asyncSrInfo.when(
          data: (srInfo) {
            return Scaffold(
              // backgroundColor: Colors.white,
              appBar: CustomAppBar(
                title: srInfo != null ? " ${srInfo.fullname}" : "",
                subTitle: _getSrRouteSubTitle(srInfo),
                titleImage: "person.png",
                showLeading: false,
                centerTitle: false,
                actions: [
                  Consumer(
                    builder: (context, ref, child) {
                      AsyncValue<List<NotificationModel>> asyncnotificationData = ref.watch(
                        notificationProvider,
                      );
                      return asyncnotificationData.when(
                        // skipLoadingOnRefresh: false,
                        data: (notifications) {
                          final count = notifications.where((e) => !(e.read ?? false)).toList().length;
                          return Stack(
                            alignment: Alignment.topRight,
                            children: [
                              if (count > 0)
                                Badge(
                                  backgroundColor: Colors.yellow,
                                  textColor: primary,
                                  label: Text(count.toString()),
                                ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, NotificationScreen.routeName);
                                },
                                icon: const Icon(Icons.notifications_none, color: Colors.white),
                              ),
                            ],
                          );
                        },
                        error: (error, t) {
                          return SizedBox();
                        },
                        loading: () {
                          return IconButton(
                            onPressed: null,
                            icon: const Icon(Icons.notifications_none, color: Colors.white),
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SettingsUI.routeName);
                    },
                    icon: const Icon(Icons.settings, color: Colors.white),
                  ),
                  SizedBox(width: 12),
                ],
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  ref.refresh(visitedAndNoOrderOutletDataProvider);
                  ref.refresh(totalAndTargetOutletDataProvider);
                  ref.refresh(targetVsAchievementDataProvider);
                  ref.refresh(cprRadtCpcDataProvider);
                  ref.refresh(radtProvider);
                  ref.refresh(mandatoryFocussedDataProvider);
                },
                child: ListView(
                  children: [
                    Container(
                      width: 100.w,
                      padding: EdgeInsets.only(top: 1.5.h, bottom: 0.5.h, left: 3.w, right: 3.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(appBarRadius),
                          bottomRight: Radius.circular(appBarRadius),
                        ),
                      ),
                      child: Wrap(
                        // mainAxisSize: MainAxisSize.min,
                        // runSpacing: 10,
                        children: [
                          getDashboardButton(
                            assetName: "attendance",
                            name: DashboardBtnNames.attendance,
                            extraPadding: 0.1.h,
                            onPressed: () {
                              Navigator.pushNamed(context, AttendanceUI.routeName);
                            },
                          ),
                          // getDashboardButton(
                          //   assetName: "outlet",
                          //   name: DashboardBtnNames.outlets,
                          //   extraPadding: 0.2.h,
                          //   onPressed: () {
                          //     Navigator.pushNamed(context, OutletListUI.routeName);
                          //   },
                          // ),
                          getDashboardButton(
                            assetName: "outlet",
                            name: DashboardBtnNames.preorder,
                            isAttendanceRestricted: attendanceLocked,
                            onPressed: () {
                              ref.refresh(couponDiscountProvider);
                              ref.refresh(selectedRetailerProvider);
                              _outletController.handlePreorderRedirection();
                            },
                          ),
                          getDashboardButton(
                            assetName: "audit",
                            name: DashboardBtnNames.audit,
                            isAttendanceRestricted: attendanceLocked,
                            onPressed: () {
                              Navigator.pushNamed(context, AuditUI.routeName);
                            },
                          ),
                          getDashboardButton(
                            assetName: "stock_verification",
                            name: DashboardBtnNames.stockVerification,
                            isAttendanceRestricted: attendanceLocked,
                            onPressed: () {
                              Navigator.pushNamed(context, StockValidationUI.routeName);
                            },
                          ),
                          getDashboardButton(
                            assetName: "sync",
                            name: DashboardBtnNames.salesSubmit,
                            isAttendanceRestricted: attendanceLocked,
                            onPressed: () {
                              Navigator.pushNamed(context, SaleSubmitUI.routeName);
                            },
                          ),
                          // getDashboardButton(
                          //   assetName: "memo",
                          //   name: DashboardBtnNames.memo,
                          //   onPressed: () {
                          //     ref.refresh(couponDiscountProvider);
                          //     ref.refresh(selectedRetailerProvider);
                          //     Navigator.pushNamed(context, MemoUI.routeName);
                          //   },
                          // ),
                          // getDashboardButton(
                          //   assetName: "stock",
                          //   name: DashboardBtnNames.stock,
                          //   extraPadding: 0.1.h,
                          //   onPressed: () {
                          //     Navigator.pushNamed(context, StockUI.routeName);
                          //   },
                          // ),
                          // getDashboardButton(
                          //   assetName: "summary",
                          //   name: DashboardBtnNames.summary,
                          //   extraPadding: 0.2.h,
                          //   onPressed: () {
                          //     Navigator.pushNamed(context, SalesSummaryUI.routeName);
                          //   },
                          // ),
                          // getDashboardButton(
                          //   assetName: "promotion",
                          //   name: DashboardBtnNames.promotions,
                          //   extraPadding: 0.2.h,
                          //   onPressed: () {
                          //     Navigator.pushNamed(context, PromotionsListScreen.routeName);
                          //   },
                          // ),
                          // Consumer(
                          //   builder: (context, ref, _) {
                          //     AsyncValue<bool> asyncEnabled = ref.watch(
                          //       checkIfChangeRouteEnabledProvider,
                          //     );
                          //
                          //     return asyncEnabled.when(
                          //       data: (enable) {
                          //         if (enable) {
                          //           return getDashboardButton(
                          //             assetName: "route_change",
                          //             name: DashboardBtnNames.changeRoute,
                          //             extraPadding: 0.3.h,
                          //             onPressed: () {
                          //               Navigator.pushNamed(context, ChangeRouteUI.routeName);
                          //             },
                          //           );
                          //         }
                          //         return const SizedBox(width: 0, height: 0);
                          //       },
                          //       error: (error, _) => const SizedBox(width: 0, height: 0),
                          //       loading: () => const SizedBox(width: 0, height: 0),
                          //     );
                          //   },
                          // ),
                          // getDashboardButton(
                          //   assetName: "sync",
                          //   name: DashboardBtnNames.salesSubmit,
                          //   onPressed: () {
                          //     Navigator.pushNamed(context, SaleSubmitUI.routeName);
                          //   },
                          // ),
                          // getDashboardButton(
                          //   assetName: "leave_management",
                          //   name: DashboardBtnNames.leaveManagement,
                          //   onPressed: () {
                          //     Navigator.pushNamed(context, LeaveManagementUI.routeName);
                          //   },
                          // ),
                          // getDashboardButton(
                          //   assetName: "tsm",
                          //   name: DashboardBtnNames.approval,
                          //   onPressed: () {
                          //     Navigator.pushNamed(context, ApprovalDashboardScreen.routeName);
                          //   },
                          // ),
                          // getDashboardButton(
                          //   assetName: "resignation",
                          //   name: DashboardBtnNames.resignation,
                          //   extraPadding: 0.3.h,
                          //   onPressed: () {
                          //     Navigator.pushNamed(context, ResignationUI.routeName);
                          //   },
                          // ),
                          // getDashboardButton(
                          //   assetName: "digital_learning",
                          //   name: DashboardBtnNames.transferBill,
                          //   extraPadding: 0.3.h,
                          //   onPressed: () {
                          //     Navigator.pushNamed(context, TransferBillListUI.routeName);
                          //   },
                          // ),
                          getDashboardButton(
                            assetName: "taDa",
                            name: DashboardBtnNames.taDa,
                            extraPadding: 0.3.h,
                            isAttendanceRestricted: attendanceLocked,
                            onPressed: () {
                              Navigator.pushNamed(context, OlympicTaDaUi.routeName, arguments: false);
                            },
                          ),
                        ],
                      ),
                    ),
                    if (attendanceLocked)
                      Padding(
                        padding: EdgeInsets.fromLTRB(3.w, 1.5.h, 3.w, 0),
                        child: _buildAttendanceLockBanner(),
                      ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 16, bottom: 16, right: 3.w, left: 3.w),
                    //   child: Consumer(
                    //     builder: (context, ref, _) {
                    //       AsyncValue<List<Module>> asyncModule = ref.watch(enabledModuleListProvider);
                    //       return asyncModule.when(
                    //         data: (moduleList) {
                    //           return ListView.builder(
                    //             itemCount: moduleList.length,
                    //             shrinkWrap: true,
                    //             physics: const NeverScrollableScrollPhysics(),
                    //             itemBuilder: (context, index) {
                    //               return TargetNAchievementUI(
                    //                 color: const {
                    //                   'main': primaryBlue,
                    //                   'color-1': red3,
                    //                   'color-2': primaryBlue,
                    //                 },
                    //                 module: moduleList[index],
                    //               );
                    //             },
                    //           );
                    //         },
                    //         error: (error, _) => Container(),
                    //         loading: () => Container(),
                    //       );
                    //     },
                    //   ),
                    // ),
                    // Consumer(
                    //   builder: (BuildContext context, WidgetRef ref, Widget? child) {
                    //     SrInfoModel? profile = ref.watch(userDataProvider).value;
                    //     final dashSaleType = ref.watch(dashBoardSaleTypeProvider);
                    //     if (profile != null && profile.userType == 41) {
                    //       return Column(
                    //         children: [
                    //           Padding(
                    //             padding: EdgeInsets.symmetric(horizontal: 3.w),
                    //             child: StrikeRateWidget(saleType: dashSaleType),
                    //           ),
                    //           Padding(
                    //             padding: EdgeInsets.symmetric(horizontal: 3.w),
                    //             child: StatisticsWidget(saleType: dashSaleType),
                    //           ),
                    //         ],
                    //       );
                    //     }
                    //     return const SizedBox();
                    //   },
                    // ),
                  ],
                ),
              ),
            );
          },
          error: (error, _) {
            print(error);
            return Container();
          },
          loading: () => const Center(child: CircularProgressIndicator()),
        );
      }, error: (error, _) {
      print(error);
      return Container();
    },
      loading: () => const Center(child: CircularProgressIndicator()),);
  }

  Widget getDashboardButton({
    required String assetName,
    required String name,
    required VoidCallback onPressed,
    double? extraPadding,
    bool isAttendanceRestricted = false,
  }) {
    AsyncValue<bool> asyncExist = ref.watch(dashboardButtonProvider(assetName));
    return asyncExist.when(
      data: (exist) {
        // log("-------->>> $assetName");
        if (!exist) {
          return const SizedBox();
        }
        return SizedBox(
          width: (100.w - (3.w * 2)) / 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  if (isAttendanceRestricted) {
                    _showAttendanceRequiredMessage();
                    return;
                  }
                  bool enabled = await ChangeRouteService().checkIfBreakdownEnabled();
                  if (!enabled) {
                    onPressed();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Opacity(
                      opacity: isAttendanceRestricted ? 0.45 : 1,
                      child: Container(
                        height: 10.h,
                        width: 18.w,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: dashboaedItemColor),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.2.h + (extraPadding ?? 0)),
                          child: _useHero
                              ? Hero(tag: '${name}img', child: Image.asset("assets/$assetName.png"))
                              : Image.asset("assets/$assetName.png", height: 24, width: 24),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                child: SizedBox(
                  width: 18.w,
                  child: Center(
                    child: Stack(
                      children: [
                        _useHero
                            ? Hero(
                                tag: name,
                                child: LangText(
                                  name,
                                  maxLine: 2,
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.bold,
                                    color: primaryBlue,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : LangText(
                                name,
                                maxLine: 2,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isAttendanceRestricted ? Colors.grey : primaryBlue,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                        LangText(
                          ".\n.",
                          maxLine: 2,
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.transparent,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      error: (error, _) => const SizedBox(height: 0, width: 0),
      loading: () => const SizedBox(height: 0, width: 0),
    );
  }

  // Future<void> _syncAttendanceRestrictionForHome() async {
  //   await SyncService().checkSyncVariable();
  //   final syncService = SyncService();
  //   ref.read(homeDashboardAttendanceLockedProvider.notifier).state =
  //       await syncService.shouldLockHomeMenusForAttendance();
  //
  //   if (!await ConnectivityService().checkInternet()) {
  //     return;
  //   }
  //
  //   final attendanceModel = await AttendanceAPI().getAttendanceStatus(DateTime.now());
  //   final bool? checkedIn;
  //   if (attendanceModel.status == AttendanceStatus.noAttendance) {
  //     checkedIn = false;
  //   } else if (attendanceModel.id != -1 &&
  //       (attendanceModel.status == AttendanceStatus.checkInDone ||
  //           attendanceModel.status == AttendanceStatus.attendanceDone)) {
  //     checkedIn = true;
  //   } else {
  //     return;
  //   }
  //
  //   await syncService.updateAttendanceCheckInStatus(checkedIn: checkedIn);
  //   ref.read(homeDashboardAttendanceLockedProvider.notifier).state =
  //       await syncService.shouldLockHomeMenusForAttendance();
  // }

  void _showAttendanceRequiredMessage() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: LangText('Please complete check-in first.'),
        ),
      );
  }

  Widget _buildAttendanceLockBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFC107)),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline, color: Color(0xFFB26A00)),
          SizedBox(width: 10),
          Expanded(
            child: LangText(
              'Attendance is mandatory. Please check in first to do service.',
              style: TextStyle(
                color: Color(0xFF7A4B00),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  readLang() async {
    await LanguagePackService().readLang();
  }

  void _welcomeMessage() {
    _outletController.showWelcomeMessage();
  }

  // =====================================================================
  // Outlet Selection Popup (Zone > Region > Area > Point)
  // =====================================================================

  Future<void> _showOutletSelectionPopup() async {
    // State holders inside the popup
    ZoneModel? selectedZone;
    RegionModel? selectedRegion;
    AreaModel? selectedArea;
    PointModel? selectedPoint;

    List<ZoneModel> zones = await _locationServices.getZoneList();
    List<RegionModel> regions = [];
    List<AreaModel> areas = [];
    List<PointModel> points = [];

    bool isLoading = false;
    String? errorMsg;

    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.location_on, color: primary, size: 22),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Select Location',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Zone dropdown
                    _buildDropdownField<ZoneModel>(
                      label: 'Zone',
                      icon: Icons.map_outlined,
                      value: selectedZone,
                      items: zones,
                      itemLabel: (z) => z.name,
                      onChanged: (z) async {
                        setDialogState(() {
                          selectedZone = z;
                          selectedRegion = null;
                          selectedArea = null;
                          selectedPoint = null;
                          regions = [];
                          areas = [];
                          points = [];
                          errorMsg = null;
                        });
                        if (z != null) {
                          final r = await _locationServices.getRegionList(zoneId: z.id);
                          setDialogState(() => regions = r);
                        }
                      },
                    ),

                    const SizedBox(height: 12),

                    // Region dropdown
                    _buildDropdownField<RegionModel>(
                      label: 'Region',
                      icon: Icons.terrain_outlined,
                      value: selectedRegion,
                      items: regions,
                      itemLabel: (r) => r.name,
                      enabled: selectedZone != null,
                      onChanged: (r) async {
                        setDialogState(() {
                          selectedRegion = r;
                          selectedArea = null;
                          selectedPoint = null;
                          areas = [];
                          points = [];
                          errorMsg = null;
                        });
                        if (r != null) {
                          final a = await _locationServices.getAreaList(regionId: r.id);
                          setDialogState(() => areas = a);
                        }
                      },
                    ),

                    const SizedBox(height: 12),

                    // Area dropdown
                    _buildDropdownField<AreaModel>(
                      label: 'Area',
                      icon: Icons.location_city_outlined,
                      value: selectedArea,
                      items: areas,
                      itemLabel: (a) => a.name,
                      enabled: selectedRegion != null,
                      onChanged: (a) async {
                        setDialogState(() {
                          selectedArea = a;
                          selectedPoint = null;
                          points = [];
                          errorMsg = null;
                        });
                        if (a != null) {
                          final p = await _locationServices.getPointListByArea(areaId: a.id);
                          setDialogState(() => points = p);
                        }
                      },
                    ),

                    const SizedBox(height: 12),

                    // Point dropdown
                    _buildDropdownField<PointModel>(
                      label: 'Point',
                      icon: Icons.place_outlined,
                      value: selectedPoint,
                      items: points,
                      itemLabel: (p) => p.name,
                      enabled: selectedArea != null,
                      onChanged: (p) {
                        setDialogState(() {
                          selectedPoint = p;
                          errorMsg = null;
                        });
                      },
                    ),

                    if (errorMsg != null) ...
                      [
                        const SizedBox(height: 10),
                        Text(
                          errorMsg!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ],

                    const SizedBox(height: 16),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (selectedPoint == null) {
                              setDialogState(
                                () => errorMsg = 'Please select a point to continue.',
                              );
                              return;
                            }
                            setDialogState(() {
                              isLoading = true;
                              errorMsg = null;
                            });
                            final saleDate = await _ffServices.getSalesDate();
                            final result =
                                await _outletServices.fetchAndUpdateRetailersFromApi(
                              pointId: selectedPoint!.id,
                              saleDate: saleDate,
                            );
                            setDialogState(() => isLoading = false);
                            if (result.status == ReturnedStatus.success) {
                              if (dialogContext.mounted) {
                                Navigator.of(dialogContext).pop();
                              }
                            } else {
                              setDialogState(
                                () =>
                                    errorMsg = result.errorMessage ??
                                        'Failed to load outlets. Please check your connection.',
                              );
                            }
                          },
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Load Outlets',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<T> items,
    required String Function(T) itemLabel,
    required ValueChanged<T?> onChanged,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: enabled ? primaryBlue : Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: enabled ? primaryBlue.withOpacity(0.4) : Colors.grey.shade300,
            ),
            color: enabled ? Colors.white : Colors.grey.shade100,
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<T>(
                value: value,
                isExpanded: true,
                hint: Row(
                  children: [
                    Icon(icon, size: 16, color: enabled ? Colors.grey : Colors.grey.shade400),
                    const SizedBox(width: 6),
                    Text(
                      enabled ? 'Select $label' : 'Select ${_getPreviousLabel(label)} first',
                      style: TextStyle(
                        color: enabled ? Colors.grey : Colors.grey.shade400,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                onChanged: enabled ? onChanged : null,
                items: items
                    .map(
                      (item) => DropdownMenuItem<T>(
                        value: item,
                        child: Text(
                          itemLabel(item),
                          style: const TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getPreviousLabel(String label) {
    switch (label) {
      case 'Region':
        return 'Zone';
      case 'Area':
        return 'Region';
      case 'Point':
        return 'Area';
      default:
        return '';
    }
  }
}


// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sizer/sizer.dart';
// import 'package:wings_olympic_sr/constants/constant_keys.dart';
// import 'package:wings_olympic_sr/constants/dashboard_btn_names.dart';
// import 'package:wings_olympic_sr/screens/olympic_tada/ui/olympic_tada_ui.dart';
// import 'package:wings_olympic_sr/screens/outlet_informations/ui/statistics_widget.dart';
// import 'package:wings_olympic_sr/screens/outlet_informations/ui/strike_rate_widget.dart';
// import 'package:wings_olympic_sr/screens/outlet_informations/ui/target_achievement_widget.dart';
// import 'package:wings_olympic_sr/screens/outlet_informations/ui/tsm_dashboard.dart';
// import 'package:wings_olympic_sr/screens/resignation/ui/resignation_ui.dart';
// import 'package:wings_olympic_sr/screens/sale/model/product_view.dart';
// import 'package:wings_olympic_sr/screens/sale/providers/sale_providers.dart';
// import 'package:wings_olympic_sr/screens/stock/ui/stock_ui.dart';
// import 'package:wings_olympic_sr/screens/transfer_bill/ui/transfer_bill_list_ui.dart';
// import 'package:wings_olympic_sr/services/shared_storage_services.dart';
//
// import '../../../constants/constant_variables.dart';
// import '../../../models/module.dart';
// import '../../../models/sr_info_model.dart';
// import '../../../provider/global_provider.dart';
// import '../../../reusable_widgets/language_textbox.dart';
// import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
// import '../../../services/change_route_service.dart';
// import '../../../services/geo_location_service.dart';
// import '../../../services/langugae_pack_service.dart';
// import '../../../services/sync_service.dart';
// import '../../allowance_management/ui/allowance_management_ui.dart';
// import '../../approval/ui/approval_dashboard.dart';
// import '../../asset_management/ui/asset_ui.dart';
// import '../../asset_ro/ui/asset_ro_ui.dart';
// import '../../attendance/ui/attendance_ui.dart';
// import '../../bill/ui/bill_ui.dart';
// import '../../delivery/ui/before_delivary_sync_ui.dart';
// import '../../delivery/ui/delivery_selection_ui.dart';
// import '../../digital_learning/ui/audit_ui.dart';
// import '../../friday_sell/ui/friday_sales_ui.dart';
// import '../../leave_management/ui/leave_management_ui.dart';
// import '../../maintenance/ui/maintenance_ui.dart';
// import '../../memo/ui/memo_ui.dart';
// import '../../notification/model/notification_model.dart';
// import '../../notification/providers/notification_provider.dart';
// import '../../notification/screens/notification_screen.dart';
// import '../../pjp_plan/ui/pjp_plan_ui.dart';
// import '../../promotions_list/ui/promotion_list_screen.dart';
// import '../../request_for_change_journey_plan/ui/change_route_ui.dart';
// import '../../sale_submit/ui/sale_submit_ui.dart';
// import '../../sales_summary/ui/sales_summary_ui.dart';
// import '../../settings/ui/settings_ui.dart';
// import '../../target_achievement/ui/target_and_achievement_dashboard_ui.dart';
// import '../../tsm_dashboard/providers/tsm_dahboard_providers.dart';
// import '../../tsm_dashboard/tsm_team_performance/ui/tsm_web_pannel_web_view.dart';
// import '../controller/outlet_controller.dart';
// import 'outlet_list_ui.dart';
//
// class HomeDashboard extends ConsumerStatefulWidget {
//   static const routeName = "/outlet_dashboard";
//
//   const HomeDashboard({Key? key}) : super(key: key);
//
//   @override
//   ConsumerState<HomeDashboard> createState() => _HomeDashboardState();
// }
//
// class _HomeDashboardState extends ConsumerState<HomeDashboard> {
//   late final OutletController _outletController;
//   final _useHero = false;
//
//   @override
//   void initState() {
//     super.initState();
//     SyncService().printSync();
//     LocationService(context).initialize();
//
//     _outletController = OutletController(context: context, ref: ref);
//     WidgetsBinding.instance.addPostFrameCallback((val) async {
//       final viewComplexityStr = await LocalStorageHelper.read(viewComplexityKey);
//       if (viewComplexityStr != null) {
//         final viewComplexity = ViewComplexity.fromString(viewComplexityStr.toString());
//         log('view complexity => $viewComplexityStr');
//         ref.read(productViewTypeProvider.notifier).state = viewComplexity ?? ViewComplexity.complex;
//       }
//     });
//     _welcomeMessage();
//   }
//
//   String _getSrRouteSubTitle(SrInfoModel? srInfo) {
//     if (srInfo == null) return "";
//
//     final route = srInfo.srRoute;
//     final wpf = srInfo.wpf;
//
//     if (route.isEmpty) return "";
//
//     if (wpf == 1) {
//       return " $route (WPF*)";
//     }
//
//     return " ($route)";
//   }
//
//   IconData _getIconForAsset(String assetName) {
//     switch (assetName) {
//       case 'outlet':
//         return Icons.storefront_rounded;
//       case 'pre_order_button':
//         return Icons.shopping_cart_checkout_rounded;
//       case 'delivery':
//         return Icons.local_shipping_rounded;
//       case 'memo':
//         return Icons.receipt_long_rounded;
//       case 'stock':
//         return Icons.inventory_2_rounded;
//       case 'attendance':
//         return Icons.co_present_rounded;
//       case 'summary':
//         return Icons.analytics_rounded;
//       case 'promotion':
//         return Icons.campaign_rounded;
//       case 'route_change':
//         return Icons.alt_route_rounded;
//       case 'sync':
//         return Icons.sync_rounded;
//       case 'leave_management':
//         return Icons.event_busy_rounded;
//       case 'tsm':
//         return Icons.fact_check_rounded;
//       case 'resignation':
//         return Icons.person_remove_rounded;
//       case 'taDa':
//         return Icons.account_balance_wallet_rounded;
//       case 'digital_learning':
//         return Icons.swap_horiz_rounded;
//       default:
//         return Icons.grid_view_rounded;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     AsyncValue<SrInfoModel?> asyncSrInfo = ref.watch(userDataProvider);
//     return asyncSrInfo.when(
//       data: (srInfo) {
//         return Scaffold(
//           appBar: CustomAppBar(
//             title: srInfo != null ? " ${srInfo.fullname}" : "",
//             subTitle: _getSrRouteSubTitle(srInfo),
//             titleImage: "person.png",
//             showLeading: false,
//             centerTitle: false,
//             actions: [
//               Consumer(
//                 builder: (context, ref, child) {
//                   AsyncValue<List<NotificationModel>> asyncnotificationData = ref.watch(
//                     notificationProvider,
//                   );
//                   return asyncnotificationData.when(
//                     data: (notifications) {
//                       final count = notifications.where((e) => !(e.read ?? false)).toList().length;
//                       return Stack(
//                         alignment: Alignment.topRight,
//                         children: [
//                           if (count > 0)
//                             Badge(
//                               backgroundColor: Colors.yellow,
//                               textColor: primary,
//                               label: Text(count.toString()),
//                             ),
//                           IconButton(
//                             onPressed: () {
//                               Navigator.pushNamed(context, NotificationScreen.routeName);
//                             },
//                             icon: const Icon(Icons.notifications_none, color: Colors.white),
//                           ),
//                         ],
//                       );
//                     },
//                     error: (error, t) {
//                       return SizedBox();
//                     },
//                     loading: () {
//                       return IconButton(
//                         onPressed: null,
//                         icon: const Icon(Icons.notifications_none, color: Colors.white),
//                       );
//                     },
//                   );
//                 },
//               ),
//               IconButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, SettingsUI.routeName);
//                 },
//                 icon: const Icon(Icons.settings, color: Colors.white),
//               ),
//               SizedBox(width: 12),
//             ],
//           ),
//           body: RefreshIndicator(
//             onRefresh: () async {
//               ref.refresh(visitedAndNoOrderOutletDataProvider);
//               ref.refresh(totalAndTargetOutletDataProvider);
//               ref.refresh(targetVsAchievementDataProvider);
//               ref.refresh(cprRadtCpcDataProvider);
//               ref.refresh(radtProvider);
//               ref.refresh(mandatoryFocussedDataProvider);
//             },
//             child: ListView(
//               children: [
//                 Container(
//                   width: 100.w,
//                   padding: EdgeInsets.only(top: 2.h, bottom: 1.h, left: 3.w, right: 3.w),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(appBarRadius),
//                       bottomRight: Radius.circular(appBarRadius),
//                     ),
//                   ),
//                   child: Wrap(
//                     runSpacing: 2.h,
//                     children: [
//                       getDashboardButton(
//                         assetName: "outlet",
//                         name: DashboardBtnNames.outlets,
//                         onPressed: () {
//                           Navigator.pushNamed(context, OutletListUI.routeName);
//                         },
//                       ),
//                       getDashboardButton(
//                         assetName: "pre_order_button",
//                         name: DashboardBtnNames.preorder,
//                         onPressed: () {
//                           ref.refresh(couponDiscountProvider);
//                           ref.refresh(selectedRetailerProvider);
//                           _outletController.handlePreorderRedirection();
//                         },
//                       ),
//                       getDashboardButton(
//                         assetName: "delivery",
//                         name: DashboardBtnNames.delivery,
//                         onPressed: () {
//                           ref.refresh(couponDiscountProvider);
//                           ref.refresh(selectedRetailerProvider);
//                           Navigator.pushNamed(context, DeliverySelectionUI.routeName);
//                         },
//                       ),
//                       getDashboardButton(
//                         assetName: "memo",
//                         name: DashboardBtnNames.memo,
//                         onPressed: () {
//                           ref.refresh(couponDiscountProvider);
//                           ref.refresh(selectedRetailerProvider);
//                           Navigator.pushNamed(context, MemoUI.routeName);
//                         },
//                       ),
//                       getDashboardButton(
//                         assetName: "stock",
//                         name: DashboardBtnNames.stock,
//                         onPressed: () {
//                           Navigator.pushNamed(context, StockUI.routeName);
//                         },
//                       ),
//                       getDashboardButton(
//                         assetName: "attendance",
//                         name: DashboardBtnNames.attendance,
//                         onPressed: () {
//                           Navigator.pushNamed(context, AttendanceUI.routeName);
//                         },
//                       ),
//                       getDashboardButton(
//                         assetName: "summary",
//                         name: DashboardBtnNames.summary,
//                         onPressed: () {
//                           Navigator.pushNamed(context, SalesSummaryUI.routeName);
//                         },
//                       ),
//                       getDashboardButton(
//                         assetName: "promotion",
//                         name: DashboardBtnNames.promotions,
//                         onPressed: () {
//                           Navigator.pushNamed(context, PromotionsListScreen.routeName);
//                         },
//                       ),
//                       Consumer(
//                         builder: (context, ref, _) {
//                           AsyncValue<bool> asyncEnabled = ref.watch(
//                             checkIfChangeRouteEnabledProvider,
//                           );
//
//                           return asyncEnabled.when(
//                             data: (enable) {
//                               if (enable) {
//                                 return getDashboardButton(
//                                   assetName: "route_change",
//                                   name: DashboardBtnNames.changeRoute,
//                                   onPressed: () {
//                                     Navigator.pushNamed(context, ChangeRouteUI.routeName);
//                                   },
//                                 );
//                               }
//                               return const SizedBox(width: 0, height: 0);
//                             },
//                             error: (error, _) => const SizedBox(width: 0, height: 0),
//                             loading: () => const SizedBox(width: 0, height: 0),
//                           );
//                         },
//                       ),
//                       getDashboardButton(
//                         assetName: "sync",
//                         name: DashboardBtnNames.salesSubmit,
//                         onPressed: () {
//                           Navigator.pushNamed(context, SaleSubmitUI.routeName);
//                         },
//                       ),
//                       getDashboardButton(
//                         assetName: "leave_management",
//                         name: DashboardBtnNames.leaveManagement,
//                         onPressed: () {
//                           Navigator.pushNamed(context, LeaveManagementUI.routeName);
//                         },
//                       ),
//                       getDashboardButton(
//                         assetName: "tsm",
//                         name: DashboardBtnNames.approval,
//                         onPressed: () {
//                           Navigator.pushNamed(context, ApprovalDashboardScreen.routeName);
//                         },
//                       ),
//                       getDashboardButton(
//                         assetName: "resignation",
//                         name: DashboardBtnNames.resignation,
//                         onPressed: () {
//                           Navigator.pushNamed(context, ResignationUI.routeName);
//                         },
//                       ),
//                       getDashboardButton(
//                         assetName: "digital_learning",
//                         name: DashboardBtnNames.transferBill,
//                         onPressed: () {
//                           Navigator.pushNamed(context, TransferBillListUI.routeName);
//                         },
//                       ),
//                       getDashboardButton(
//                         assetName: "taDa",
//                         name: DashboardBtnNames.taDa,
//                         onPressed: () {
//                           Navigator.pushNamed(context, OlympicTaDaUi.routeName, arguments: false);
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: 16, bottom: 16, right: 3.w, left: 3.w),
//                   child: Consumer(
//                     builder: (context, ref, _) {
//                       AsyncValue<List<Module>> asyncModule = ref.watch(enabledModuleListProvider);
//                       return asyncModule.when(
//                         data: (moduleList) {
//                           return ListView.builder(
//                             itemCount: moduleList.length,
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemBuilder: (context, index) {
//                               return TargetNAchievementUI(
//                                 color: const {
//                                   'main': primaryBlue,
//                                   'color-1': red3,
//                                   'color-2': primaryBlue,
//                                 },
//                                 module: moduleList[index],
//                               );
//                             },
//                           );
//                         },
//                         error: (error, _) => Container(),
//                         loading: () => Container(),
//                       );
//                     },
//                   ),
//                 ),
//                 Consumer(
//                   builder: (BuildContext context, WidgetRef ref, Widget? child) {
//                     SrInfoModel? profile = ref.watch(userDataProvider).value;
//                     final dashSaleType = ref.watch(dashBoardSaleTypeProvider);
//                     if (profile != null && profile.userType == 41) {
//                       return Column(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 3.w),
//                             child: StrikeRateWidget(saleType: dashSaleType),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 3.w),
//                             child: StatisticsWidget(saleType: dashSaleType),
//                           ),
//                         ],
//                       );
//                     }
//                     return const SizedBox();
//                   },
//                 ),
//                 Consumer(
//                   builder: (context, ref, child) {
//                     SrInfoModel? profile = ref.watch(userDataProvider).value;
//                     if (profile != null && profile.userType == 12) {
//                       return const TSMDashboard();
//                     }
//                     return const SizedBox();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//       error: (error, _) {
//         print(error);
//         return Container();
//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//     );
//   }
//
//   Widget getDashboardButton({
//     required String assetName,
//     required String name,
//     required VoidCallback onPressed,
//     double? extraPadding,
//   }) {
//     AsyncValue<bool> asyncExist = ref.watch(dashboardButtonProvider(assetName));
//     return asyncExist.when(
//       data: (exist) {
//         if (!exist) {
//           return const SizedBox();
//         }
//         return SizedBox(
//           width: (100.w - (3.w * 2)) / 4,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               InkWell(
//                 onTap: () async {
//                   bool enabled = await ChangeRouteService().checkIfBreakdownEnabled();
//                   if (!enabled) {
//                     onPressed();
//                   }
//                 },
//                 borderRadius: BorderRadius.circular(100),
//                 child: Container(
//                   padding: EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: primary.withOpacity(0.08),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Center(
//                     child: _useHero
//                         ? Hero(
//                       tag: '${name}img',
//                       child: Icon(
//                         _getIconForAsset(assetName),
//                         color: primary,
//                         size: 7.w,
//                       ),
//                     )
//                         : Icon(
//                       _getIconForAsset(assetName),
//                       color: primary,
//                       size: 7.w,
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(top: 1.h, bottom: 0.5.h, left: 1.w, right: 1.w),
//                 child: SizedBox(
//                   width: 20.w,
//                   child: Center(
//                     child: Stack(
//                       children: [
//                         _useHero
//                             ? Hero(
//                           tag: name,
//                           child: LangText(
//                             name,
//                             maxLine: 2,
//                             style: TextStyle(
//                               fontSize: 9.sp,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.grey[800],
//                               height: 1.2,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                             textAlign: TextAlign.center,
//                           ),
//                         )
//                             : LangText(
//                           name,
//                           maxLine: 2,
//                           style: TextStyle(
//                             fontSize: 9.sp,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.grey[800],
//                             height: 1.2,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                           textAlign: TextAlign.center,
//                         ),
//                         LangText(
//                           ".\n.",
//                           maxLine: 2,
//                           style: TextStyle(
//                             fontSize: 9.sp,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.transparent,
//                             height: 1.2,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//       error: (error, _) => const SizedBox(height: 0, width: 0),
//       loading: () => const SizedBox(height: 0, width: 0),
//     );
//   }
//
//   readLang() async {
//     await LanguagePackService().readLang();
//   }
//
//   void _welcomeMessage() {
//     _outletController.showWelcomeMessage();
//   }
// }
