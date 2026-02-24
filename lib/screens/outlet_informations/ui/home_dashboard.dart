import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/constant_keys.dart';
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
import '../../../models/module.dart';
import '../../../models/sr_info_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../services/change_route_service.dart';
import '../../../services/geo_location_service.dart';
import '../../../services/langugae_pack_service.dart';
import '../../../services/sync_service.dart';
import '../../allowance_management/ui/allowance_management_ui.dart';
import '../../approval/ui/approval_dashboard.dart';
import '../../asset_management/ui/asset_ui.dart';
import '../../asset_ro/ui/asset_ro_ui.dart';
import '../../attendance/ui/attendance_ui.dart';
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

  @override
  void initState() {
    super.initState();
    SyncService().printSync();
    LocationService(context).initialize();
    // InternetPopup().initialize(
    //     context: context,
    //     onTapPop: true,
    //     onChange: (value) {
    //       ref.read(internetConnectivityProvider.state).state = value;
    //     },);
    _outletController = OutletController(context: context, ref: ref);
    WidgetsBinding.instance.addPostFrameCallback((val) async {
      final viewComplexityStr = await LocalStorageHelper.read(viewComplexityKey);
      if (viewComplexityStr != null) {
        final viewComplexity = ViewComplexity.fromString(viewComplexityStr.toString());
        log('view complexity => $viewComplexityStr');
        ref.read(productViewTypeProvider.notifier).state = viewComplexity ?? ViewComplexity.complex;
      }
    });
    _welcomeMessage();
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
                      // getDashboardButton(
                      //   assetName: "attendance",
                      //   name: DashboardBtnNames.attendance,
                      //   extraPadding: 0.1.h,
                      //   onPressed: () {
                      //     Navigator.pushNamed(context, AttendanceUI.routeName);
                      //   },
                      // ),
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
                        onPressed: () {
                          ref.refresh(couponDiscountProvider);
                          ref.refresh(selectedRetailerProvider);
                          _outletController.handlePreorderRedirection();
                        },
                      ),
                      getDashboardButton(
                        assetName: "sync",
                        name: DashboardBtnNames.salesSubmit,
                        onPressed: () {
                          Navigator.pushNamed(context, SaleSubmitUI.routeName);
                        },
                      ),
                      // getDashboardButton(
                      //   assetName: "delivery",
                      //   name: DashboardBtnNames.delivery,
                      //   onPressed: () {
                      //     ref.refresh(couponDiscountProvider);
                      //     ref.refresh(selectedRetailerProvider);
                      //     Navigator.pushNamed(context, DeliverySelectionUI.routeName);
                      //   },
                      // ),
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
                      // getDashboardButton(
                      //   assetName: "taDa",
                      //   name: DashboardBtnNames.taDa,
                      //   extraPadding: 0.3.h,
                      //   onPressed: () {
                      //     Navigator.pushNamed(context, OlympicTaDaUi.routeName, arguments: false);
                      //   },
                      // ),
                    ],
                  ),
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
  }

  Widget getDashboardButton({
    required String assetName,
    required String name,
    required VoidCallback onPressed,
    double? extraPadding,
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
                  bool enabled = await ChangeRouteService().checkIfBreakdownEnabled();
                  if (!enabled) {
                    onPressed();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: AspectRatio(
                    aspectRatio: 1,
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
                                  color: primaryBlue,
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

  readLang() async {
    await LanguagePackService().readLang();
  }

  void _welcomeMessage() {
    _outletController.showWelcomeMessage();
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
// import '../../digital_learning/ui/digital_learning_ui.dart';
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