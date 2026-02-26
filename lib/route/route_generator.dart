import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wings_olympic_sr/screens/resignation/ui/resignation_ui.dart';
import 'package:wings_olympic_sr/screens/stock_check/ui/stock_check_ui.dart';
import '../models/point_model.dart';
import '../screens/audit/ui/audit_ui.dart';
import '../screens/notification/screens/notification_screen.dart';
import '../screens/olympic_tada/ui/olympic_tada_ui.dart';
import '../screens/sale/ui/updated_examine_ui.dart';
import '../screens/survey/survey_point_location_ui.dart';
import '../screens/transfer_bill/ui/transfer_bill_form_ui.dart';
import '../screens/transfer_bill/ui/transfer_bill_list_ui.dart';
import 'package:wings_olympic_sr/screens/retailer_selection/models/selection_nav.dart';
import '../constants/constant_keys.dart';
import '../constants/enum.dart';
import '../models/AvModel.dart';
import '../models/assetModel.dart';
import '../models/bill/bill_data_model.dart';
import '../models/digital_learning/digital_learning_item.dart';
import '../models/leave_model.dart';
import '../models/leave_movement_management_model_tsm.dart';
import '../models/maintanence_model.dart';
import '../models/module.dart';
import '../models/outlet_model.dart';
import '../models/pjp_plan_details.dart';
import '../models/previous_requisition.dart';
import '../models/route_change_model_tsm.dart';
import '../models/sales/formatted_sales_preorder_discount_data_model.dart';
import '../models/sales/memo_information_model.dart';
import '../models/survey/question_model.dart';
import '../models/target/sr_stt_target_model.dart';
import '../reusable_widgets/scaffold_widgets/cameraScreen.dart';
import '../screens/allowance_management/model/created_tada_model.dart';
import '../screens/allowance_management/ui/allowance_management_ui.dart';
import '../screens/allowance_management/ui/create_movement_ui.dart';
import '../screens/allowance_management/ui/create_tada_ui.dart';
import '../screens/allowance_management/ui/movement_edit_ui.dart';
import '../screens/approval/ui/approval_dashboard.dart';
import '../screens/approval/ui/approval_list.dart';
import '../screens/approval/ui/leave_list.dart';
import '../screens/approval/ui/single_approval.dart';
import '../screens/approval/ui/single_leave.dart';
import '../screens/approval/ui/single_movement.dart';
import '../screens/asset_management/ui/asset_ui.dart';
import '../screens/asset_ro/ui/asset_ro_requisition_ui.dart';
import '../screens/asset_ro/ui/asset_ro_ui.dart';
import '../screens/attendance/ui/attendance_ui.dart';
import '../screens/attendance/ui/check_in_out_ui.dart';
import '../screens/aws_stock/model/aws_product_model.dart';
import '../screens/bill/ui/bill_info_ui.dart';
import '../screens/bill/ui/bill_ui.dart';
import '../screens/calender/ui/leave_calender_ui.dart';
import '../screens/delivery/ui/delivery_selection_ui.dart';
import '../screens/delivery/ui/before_delivary_sync_ui.dart';
import '../screens/delivery/ui/delivery_ui.dart';
import '../screens/delivery/ui/delivery_v2_ui.dart';
import '../screens/delivery/ui/multi_select_delivery_ui.dart';
import '../screens/digital_learning/ui/digital_learning_ui.dart';
import '../screens/digital_learning/ui/image_view_digital_learning.dart';
import '../screens/digital_learning/ui/pdf_reader_digital_learning.dart';
import '../screens/digital_learning/ui/video_player_digital_learning.dart';
import '../screens/friday_sell/ui/friday_sales_ui.dart';
import '../screens/leave_management/ui/create_leave_ui.dart';
import '../screens/leave_management/ui/leave_management_ui.dart';
import '../screens/maintenance/ui/maintenance_details_ui.dart';
import '../screens/maintenance/ui/maintenance_ui.dart';
import '../screens/memo/ui/memo_ui.dart';
import '../screens/outlet_informations/ui/check_outlet_sync_ui.dart';
import '../screens/outlet_informations/ui/new_outlet_registration_ui.dart';
import '../screens/outlet_informations/ui/home_dashboard.dart';
import '../screens/outlet_informations/ui/outlet_details_ui.dart';
import '../screens/outlet_informations/ui/outlet_list_ui.dart';
import '../screens/pjp_plan/ui/pjp_plan_explanation_ui.dart';
import '../screens/pjp_plan/ui/pjp_plan_ui.dart';
import '../screens/promotions_list/ui/promotion_list_screen.dart';
import '../screens/qc/ui/qc_entry_ui.dart';
import '../screens/qc/ui/qc_ui.dart';
import '../screens/request_for_change_journey_plan/ui/change_route_ui.dart';
import '../screens/retailer_selection/ui/retailer_details_ui.dart';
import '../screens/retailer_selection/ui/retailer_selection_ui.dart';
import '../screens/sale/ui/examine_ui.dart';
import '../screens/sale/ui/outlet_stock_count.dart';
import '../screens/sale/ui/preview_cooler_image.dart';
import '../screens/sale/ui/sale_ui.dart';
import '../screens/sale/ui/sale_v2_widget/show_sku_ui.dart';
import '../screens/sale/ui/sale_v2_widget/show_sku_ui_v2.dart';
import '../screens/sale/ui/sales_ui_v2.dart';
import '../screens/sale_submit/ui/sale_submit_ui.dart';
import '../screens/sales_summary/ui/sales_summary_ui.dart';
import '../screens/settings/ui/settings_ui.dart';
import '../screens/splash_screen/ui/splash_screen_ui.dart';
import '../screens/stock/ui/stock_ui.dart';
import '../screens/survey/survey_ui.dart';
import '../screens/survey_digital_learning/ui/survey_digital_learning_ui.dart';
import '../screens/target_achievement/ui/target_tab_view_ui.dart';
import '../screens/tsm_dashboard/tsm_team_performance/ui/team_performance_new_ui.dart';
import '../screens/tsm_dashboard/tsm_team_performance/ui/tsm_web_pannel_web_view.dart';
import '../screens/tsm_dashboard/tsm_team_performance/widgets/target_tab_view_ui_tsm.dart';
import '../screens/tsm_dashboard/ui/mandatory_focussed_summary_screen.dart';
import '../screens/update/ui/app_update_found.dart';
import '../screens/update/ui/app_updating_ui.dart';
import '../screens/update/ui/update_found_ui.dart';
import '../screens/update/ui/updating_ui.dart';
import '../screens/update_password/ui/update_password_ui.dart';
import '../screens/verificartions/ui/login_ui.dart';
import '../screens/video_player.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    log("CURRENT SCREEN =====>> ${settings.name}");
    switch (settings.name) {
      case SplashScreenUI.routeName:
        return MaterialPageRoute(builder: (_) => const SplashScreenUI());
      case LoginUI.routeName:
        LoginStatus status = settings.arguments as LoginStatus;
        return MaterialPageRoute(
            builder: (_) => LoginUI(
                  loginStatus: status,
                ));
      case NewOutletRegistrationUI.routeName:
        OutletModel? outletModel = settings.arguments as OutletModel?;
        return MaterialPageRoute(builder: (_) => NewOutletRegistrationUI(outletModel: outletModel));
      case OutletDetailsUI.routeName:
        OutletModel outletModel = settings.arguments as OutletModel;
        return MaterialPageRoute(
            builder: (_) => OutletDetailsUI(
                  outlet: outletModel,
                ));
      case OutletListUI.routeName:
        return MaterialPageRoute(builder: (_) => const OutletListUI());
      case HomeDashboard.routeName:
        return MaterialPageRoute(builder: (_) => const HomeDashboard());
      case AssetUI.routeName:
        return MaterialPageRoute(builder: (_) => const AssetUI());
      case LeaveManagementUI.routeName:
        return MaterialPageRoute(builder: (_) => const LeaveManagementUI());
      case AllowanceManagementUI.routeName:
        return MaterialPageRoute(builder: (_) => const AllowanceManagementUI());
      case ApprovalDashboardScreen.routeName:
        return MaterialPageRoute(builder: (_) => const ApprovalDashboardScreen());
      case ApprovalList.routeName:
        return MaterialPageRoute(builder: (_) => const ApprovalList());
      case SingleApproval.routeName:
        ChangeRouteTSMModel changeRouteTSMModel = settings.arguments as ChangeRouteTSMModel;
        return MaterialPageRoute(
            builder: (_) => SingleApproval(
                  changeRouteTSMModel: changeRouteTSMModel,
                ));
      case LeaveList.routeName:
        return MaterialPageRoute(builder: (_) => const LeaveList());
      case SingleLeave.routeName:
        LeaveMovementManagementModelForTSM leaveMovementManagementModelForTSM = settings.arguments as LeaveMovementManagementModelForTSM;
        return MaterialPageRoute(
            builder: (_) => SingleLeave(
                  leaveMovementManagementModelForTSM: leaveMovementManagementModelForTSM,
                ));
      case SingleMovement.routeName:
        LeaveMovementManagementModelForTSM leaveMovementManagementModelForTSM = settings.arguments as LeaveMovementManagementModelForTSM;
        return MaterialPageRoute(
            builder: (_) => SingleMovement(
                  leaveMovementManagementModelForTSM: leaveMovementManagementModelForTSM,
                ));
      case AttendanceUI.routeName:
        return MaterialPageRoute(builder: (_) => const AttendanceUI());
      case ChangeRouteUI.routeName:
        return MaterialPageRoute(builder: (_) => const ChangeRouteUI());
      case CheckInOutUI.routeName:
        Map data = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => CheckInOutUI(
                  type: data[attendanceStatusKey],
                  id: data[attendanceIdKey],
                  lat: data['lat'] ?? 0,
                  lng: data['lng'] ?? 0,
                  depId: data['depId'],
                ));
      case CameraScreen.routeName:
        return MaterialPageRoute(builder: (_) => const CameraScreen());
      case TargetTabViewUI.routeName:
        Map arg = settings.arguments as Map;
        Module data = arg["data"];
        return MaterialPageRoute(
            builder: (_) => TargetTabViewUI(
                  module: data,
                ));
      case SalesSummaryUI.routeName:
        return MaterialPageRoute(builder: (_) => const SalesSummaryUI());
      case QCUI.routeName:
        return MaterialPageRoute(builder: (_) => QCUI());
      case QCEntryUI.routeName:
        return MaterialPageRoute(builder: (_) => QCEntryUI());
      case MemoUI.routeName:
        return MaterialPageRoute(builder: (_) => const MemoUI());
      case SaleSubmitUI.routeName:
        return MaterialPageRoute(builder: (_) => SaleSubmitUI());
      case AppUpdateFoundUI.routeName:
        return MaterialPageRoute(builder: (_) => AppUpdateFoundUI());
      case CheckDeliverySyncUI.routeName:
        return MaterialPageRoute(builder: (_) => const CheckDeliverySyncUI());
      case MultiSelectDeliveryUI.routeName:
        return MaterialPageRoute(builder: (_) => const MultiSelectDeliveryUI());
      case DeliverySelectionUI.routeName:
        return MaterialPageRoute(builder: (_) => const DeliverySelectionUI());
      case AppUpdatingUI.routeName:
        String url = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => AppUpdatingUI(
                  url: url,
                ));
      // case SaleUI.routeName:
      //   late AllMemoInformationModel allMemo;
      //   if (settings.arguments != null) {
      //     allMemo = settings.arguments as AllMemoInformationModel;
      //   } else {
      //     allMemo = AllMemoInformationModel(preorderMemo: [], saleMemo: []);
      //   }
      //
      //   return MaterialPageRoute(
      //       builder: (_) => SaleUI(
      //             allMemo: allMemo,
      //           ));
      case UpdateFoundUI.routeName:
        List<AssetModel> list = settings.arguments as List<AssetModel>;
        return MaterialPageRoute(builder: (_) => UpdateFoundUI(assetList: list));
      case UpdatingUI.routeName:
        List<AssetModel> list = settings.arguments as List<AssetModel>;
        num count = 0;
        for (AssetModel i in list) {
          count = count + i.assets.length;
        }
        return MaterialPageRoute(builder: (_) => UpdatingUI(bulkList: list, count: count));
      case VideoPlayerUI.routeName:
        Map m = settings.arguments as Map;
        AvModel avModel = m['avModel'];
        File file = m['file'];
        bool skip = false;
        if (m.containsKey('skip')) {
          skip = m['skip'];
        }
        return MaterialPageRoute(
            builder: (_) => VideoPlayerUI(
                  avModel: avModel,
                  file: file,
                  skip: skip,
                ));
      case VideoPlayerDigitalLearningUI.routeName:
        Map m = settings.arguments as Map;
        DigitalLearningItem avModel = m['data'];
        File file = m['file'];
        bool skip = false;
        if (m.containsKey('skip')) {
          skip = m['skip'];
        }
        return MaterialPageRoute(
            builder: (_) => VideoPlayerDigitalLearningUI(
                  item: avModel,
                  file: file,
                  skip: skip,
                ));
      case ImageViewDigitalLearningUI.routeName:
        Map m = settings.arguments as Map;
        DigitalLearningItem avModel = m['data'];
        String file = m['file'];
        bool skip = false;
        if (m.containsKey('skip')) {
          skip = m['skip'];
        }
        return MaterialPageRoute(
            builder: (_) => ImageViewDigitalLearningUI(
                  item: avModel,
                  file: file,
                  skip: skip,
                ));
      case PdfReaderDigitalLearningUI.routeName:
        Map m = settings.arguments as Map;
        DigitalLearningItem avModel = m['data'];
        String file = m['file'];
        bool skip = false;
        if (m.containsKey('skip')) {
          skip = m['skip'];
        }
        return MaterialPageRoute(
            builder: (_) => PdfReaderDigitalLearningUI(
                  item: avModel,
                  file: file,
                  skip: skip,
                ));
      case SurveyUI.routeName:
        Map m = settings.arguments as Map;

        int retailerId = m['retailerId'];
        SurveyModel surveyModel = m['surveyModel'];
        OutletModel outletModel = m['retailer'];
        return MaterialPageRoute(builder: (_) => SurveyUI(retailerId: retailerId, surveyModel: surveyModel, retailer: outletModel));

      case SurveyPointLocationUI.routeName:
        Map m = settings.arguments as Map;

        int retailerId = m['pointId'];
        SurveyModel surveyModel = m['surveyModel'];
        PointDetailsModel outletModel = m['point'];
        return MaterialPageRoute(builder: (_) => SurveyPointLocationUI(retailerId: retailerId, surveyModel: surveyModel, retailer: outletModel));
      case SurveyDigitalLearningUI.routeName:
        Map m = settings.arguments as Map;

        DigitalLearningItem surveyModel = m['surveyModel'];
        return MaterialPageRoute(builder: (_) => SurveyDigitalLearningUI(surveyModel: surveyModel));
      case ExamineUI.routeName:
        Map data = settings.arguments as Map;
        AllKindOfSaleDataModel allKindOfSaleDataModel = data["allKindOfSaleDataModel"];
        bool? firstTime = data["firstTime"];
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => UpdatedExamineUI(
                  allKindOfSaleDataModel: allKindOfSaleDataModel,
                ));
      case CheckOutletSyncUI.routeName:
        return MaterialPageRoute(builder: (_) => CheckOutletSyncUI());
      case SettingsUI.routeName:
        return MaterialPageRoute(builder: (_) => SettingsUI());
      case NotificationScreen.routeName:
        return MaterialPageRoute(builder: (_) => NotificationScreen());
      case DeliveryUI.routeName:
        return MaterialPageRoute(builder: (_) => const DeliveryUI());
      case PreviewCoolerImage.routeName:
        return MaterialPageRoute(
            builder: (_) => PreviewCoolerImage(
                  coolerImage: File(""),
                  onTryAgainPressed: () {},
                  onSubmitPressed: () {},
                ));

      case FridaySalesUI.routeName:
        return MaterialPageRoute(builder: (_) => const FridaySalesUI());
      case AssetRoUI.routeName:
        return MaterialPageRoute(builder: (_) => const AssetRoUI());
      case MaintenanceUI.routeName:
        return MaterialPageRoute(builder: (_) => const MaintenanceUI());

      case AssetRoRequisitionUI.routeName:
        PreviousRequisition? requisition = settings.arguments as PreviousRequisition?;
        return MaterialPageRoute(builder: (_) => AssetRoRequisitionUI(requisition: requisition,));

      case MaintenanceDetailsUI.routeName:
        MaintenanceModel data = settings.arguments as MaintenanceModel;
        return MaterialPageRoute(builder: (_) => MaintenanceDetailsUI(maintenanceModel: data,));

      case BillUI.routeName:
        return MaterialPageRoute(builder: (_) => const BillUI());

      case BillInfoUI.routeName:
        BillDataModel requisition = settings.arguments as BillDataModel;
        return MaterialPageRoute(builder: (_) => BillInfoUI(billDetails: requisition,));

      case DigitalLearningUI.routeName:
        return MaterialPageRoute(builder: (_) => const DigitalLearningUI());

      case AuditUI.routeName:
        return MaterialPageRoute(builder: (_) => const AuditUI());

      case LeaveCalenderUi.routeName:
        return MaterialPageRoute(builder: (_) => const LeaveCalenderUi());
      case MovementEditUi.routeName:
        final movement = settings.arguments as LeaveManagementData;
        return MaterialPageRoute(builder: (_) => MovementEditUi(movement: movement));

      case PjpPlanUI.routeName:
        return MaterialPageRoute(builder: (_) => const PjpPlanUI());

      case PjpPlanExplanationUI.routeName:
        PJPPlanDetails pjpPlan = settings.arguments as PJPPlanDetails;
        return MaterialPageRoute(builder: (_) => PjpPlanExplanationUI(data: pjpPlan,));

      case CreateMovementUI.routeName:
        LeaveManagementData? updateModel;
        if(settings.arguments!=null) {
          updateModel = settings.arguments as LeaveManagementData;
        }
        return MaterialPageRoute(builder: (_) => CreateMovementUI(data: updateModel,));

      case CreateTadaUI.routeName:
        CreatedTaDaModel? updateModel;
        if(settings.arguments!=null) {
          updateModel = settings.arguments as CreatedTaDaModel;
        }
        return MaterialPageRoute(builder: (_) => CreateTadaUI(data: updateModel,));

      case CreateLeaveUI.routeName:
        LeaveManagementModel?updateModel = settings.arguments as LeaveManagementModel;
        return MaterialPageRoute(builder: (_) => CreateLeaveUI(leaveData: updateModel,));

      case UpdatePasswordUI.routeName:
        return MaterialPageRoute(builder: (_) => const UpdatePasswordUI());

      case MandatoryFocussedSummaryScreen.routeName:
        return MaterialPageRoute(builder: (_) => const MandatoryFocussedSummaryScreen());

      case TeamPerformanceNewUI.routeName:
        return MaterialPageRoute(builder: (_) => const TeamPerformanceNewUI());
      case TsmWebPannelWebView.routeName:
        return MaterialPageRoute(builder: (_) => const TsmWebPannelWebView());

      case TargetTabViewUITsm.routeName:
        List<SRDetailTargetModel> arg = settings.arguments as List<SRDetailTargetModel>;

        return  MaterialPageRoute(builder: (_) => TargetTabViewUITsm(targetList :arg));

      case RetailerDetailsScreen.routeName:
        OutletModel retailer = settings.arguments as OutletModel;
        return MaterialPageRoute(builder: (_) => RetailerDetailsScreen(retailer: retailer,));

      case RetailerSelectionUi.routeName:
      ///argument {"forMemo": true, "retailerList": retailerList}
        List<OutletModel>? retailerList;
        bool forMemo = false;
        var selectionType = SelectionNav.backWord;

        if (settings.arguments!=null) {
          final arguments = settings.arguments as Map;
          if(arguments.containsKey("retailerList")) {
            retailerList = arguments["retailerList"] as List<OutletModel>;
          }
          if(arguments.containsKey("forMemo")) {
            forMemo = arguments["forMemo"] as bool;
          }if (arguments.containsKey('nav_type')) {
            selectionType = arguments['nav_type'];
          }
        }
        return MaterialPageRoute(
          builder: (_) => RetailerSelectionUi(
            retailerList: retailerList,
            forMemo: forMemo,
            selectionType: selectionType,
          ),
        );

      case SalesUIv2.routeName:
        return MaterialPageRoute(
            builder: (_) => SalesUIv2(
              selectedRetailer: settings.arguments as OutletModel,
            ));

      case ShowSkuUIV2.routeName:
        final dataMap = settings.arguments as Map;
        final saleType = dataMap['sale_type'];
        AllMemoInformationModel? allMemo = dataMap['all_memo'];
        allMemo = allMemo ?? AllMemoInformationModel(saleMemo: [], preorderMemo: []);

        return MaterialPageRoute(
            builder: (_) => ShowSkuUIV2(
              saleType: saleType,
              allMemo: allMemo!,
            ));

      case PromotionsListScreen.routeName:
        Map<int, Map<dynamic, dynamic>>? promotions;
        if(settings.arguments!=null) {
          promotions = settings.arguments as Map<int, Map<dynamic, dynamic>>;
        }
        return MaterialPageRoute(builder: (_) => PromotionsListScreen(promotions: promotions,));

      case OutletStockCountUI.routeName:
        List<AwsProductModel> productList = settings.arguments as List<AwsProductModel>;
        return  MaterialPageRoute(builder: (_) => OutletStockCountUI(productList: productList,));
      case DeliveryV2UI.routeName:
        return  MaterialPageRoute(builder: (_) => DeliveryV2UI());

      case StockUI.routeName:
        return MaterialPageRoute(builder: (_) => const StockUI());

      case ResignationUI.routeName:
        return MaterialPageRoute(builder: (_) => const ResignationUI());

      case TransferBillListUI.routeName:
        return MaterialPageRoute(builder: (_) => const TransferBillListUI());

      case TransferBillFormUI.routeName:
        return MaterialPageRoute(builder: (_) => const TransferBillFormUI());

      case OlympicTaDaUi.routeName:
        bool visibleSubmitTaDa = settings.arguments as bool;
        return MaterialPageRoute(builder: (_) => OlympicTaDaUi(visibleSubmitTaDa: visibleSubmitTaDa,));

      case StockCheckUI.routeName:
        return MaterialPageRoute(builder: (_) => const StockCheckUI());

      default:
        return MaterialPageRoute(builder: (_) => const SplashScreenUI());
    }
  }
} //
