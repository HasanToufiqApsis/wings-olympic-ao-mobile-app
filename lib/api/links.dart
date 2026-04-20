class Links {
  static String wingsUrl = "https://my.wingssfa.net";
  static String devUrl = "http://192.168.20.16:2080";
  static String publicUrl = "https://olympic-dev.wingssfa.net";
  static String baseUrl = publicUrl;


  static String salesDateUrl = "/sync-file/get-enable-sales-date";
  static String logInAssets = "/auth/login";
  static String updatePassword = "/app-api/ff-auth/change-password";
  static String syncAssets = "/sync-file";
  static String fileUrl = "/app-api/common/upload-file";
  // static String fileUrl = "/app-api/static-file/upload";
  static String retailerUrl = "/app-api/retailer";
  static String bulkDisableUrl = "/app-api/retailer/bulk-disable";
  static String outletEditUrl = "/app-api/retailer/";
  static String saveSalesDataUrl = "/app-api/sales/save-sales-data";
  static String saveSpotSaleDataUrl = '/app-api/sales/save-spot-sale-data-new';
  static String salesSubmitServerData({required int depId, required String date}) => '$baseUrl/sync-file/get-server-count?dep_id=$depId&date=$date';
  static String salesSubmit = "/app-api/sales/sales-submit";
  static String saveSaleSectionDataUrl = "/sync-file/save-point-data";
  static String saveSpotSaleSectionDataUrl = "/app-api/sales/save-spot-sales-section-data";
  static String saveDeliverySectionDataUrl = "/app-api/sales/save-delivery-section-data-new";
  static String getRetailerListUrl = "/app-api/sync-file/get-retailer-list";
  static String languagePack = '/app-api/localization';
  static String saveDeliveryDataUrl = "/app-api/sales/save-delivery-data-new";
  static String checkStockUrl = "/app-api/sales/check-available-stock";
  static String checkStockForBulkUrl = "/app-api/sales/check-available-stock-new";
  static String deviceLogUrl = '/app-api/sales/save-device-log-data';
  static String deliveryRetailerUrl = '/app-api/sync-file/get-available-pre-order';
  static String deliverySummaryUrl(int ffId) => '/app-api/sales/delivery-summary?ff_id=$ffId';
  static String attendanceUrl = '/app-api/attendance';
  static String attendanceUrlTsm = '/app-api/attendance/tsm';
  static String sectionChangeUrl = "/app-api/section-change";
  static String getLeaveDataUrl({required int ffId}) => "app-api/leave/my-leaves?field_force_id=$ffId&include_approval_info=true";
  static String setLeaveDataUrl = "/app-api/leave";
  static String setMovementDataUrl = "/app-api/movement";
  static String createTaDaDataUrl = "/app-api/movement/ta-da";
  static String checkTodayMovementDataUrl (int userId, int userType, String date) => "/app-api/movement/movement-availability?user_id=$userId&user_type_id=$userType&date=$date";
  static String updateTaDaDataUrl(int id) => "/app-api/movement/ta-da/$id";
  static String getTaDaDataUrl (int userId, int userTypeId) => "/app-api/movement/ta-da?user_id=$userId&user_type_id=$userTypeId";
  static String getMovementDataUrl = "/app-api/movement?field_force_id=";
  static String submitAssetRequisitionDataUrl = "/app-api/asset-requisition/new-requisition";
  static String submitAssetInstallationDataUrl = "/app-api/asset-requisition/new-installation";
  static String submitAssetPullOutDataUrl = "/app-api/asset-requisition/pull-out";
  static String getAssetRequisitionDataForInstallationUrl = "/app-api/asset-requisition/get-outlet-asset-requisition/";
  static String pdaDeleteUrl = "/app-api/common/delete-pda-file";

  static String srTracking = '/app-api/common/save-geo-tracking-data';

  static String getInstallPullOutRetailers({required String depIds, required String activity, required int assetType}) {
    return "/app-api/asset-requisition/outlet-ids-pending-installation-pullout?dep_ids=$depIds&activity_type=${getActivity(activity: activity)}&asset_cat_type=$assetType";
  }

  static String getAssetPullInDataForInstallationUrl = "/app-api/asset-requisition/get-outlet-asset-list?outlet_code=";
  static String getRouteChangeRequestTSMUrl = "/section-change";
  static String getLeaveMovementRequestTSMUrl({required String depIds, required String startDate, required String endDate}) => "/leave-movement?depIds=$depIds&start_date=$startDate&end_date=$endDate";
  static String approveRejectTSMUrl = "/leave-movement";
  static String sendUnsoldOutletDataUrl = "/app-api/sales/save-unsold-outlet-sales-data";

  static String sectionChangeStatusUrl(int id) => "/app-api/section-change/request-status?field_force_id=$id";

  static String roAllRequisitionUrl(String depId) => "/app-api/asset-requisition/ro-asset-list?dep_ids=$depId";

  static String approveAssetRequisitionRoDataUrl = "/app-api/asset-requisition/approve-by-ro";
  static String approveCreatedAssetRequisitionRoDataUrl = "/app-api/asset-requisition/create-requisition-by-ro";
  static String rejectRequisitionRoDataUrl = "/app-api/asset-requisition/reject-requisition/";

  static String maintenanceTasksListUrl({required String userId}) => "/app-api/maintainance/request-list/$userId";
  static String maintenanceCompleteUrl = "/app-api/maintainance/task-update";

  static String billListUrl(String depId) => "/app-api/bill/outdoor-bill?dep_ids=$depId";
  static String billDisburse(int id) => "/app-api/bill/disburse-outdoor-bill/$id";

  static String submitDigitalLearningSurvey = "$baseUrl/app-api/rtc/save-rtc-live-survey";

  static String tryBeforeYouBuySubmit = "$baseUrl/app-api/sales/save-try-before-buy-data";


  static String qpsEnroll = "/app-api/promotion/save-qps-enroll-data";
  static String salesDataForQps = "/app-api/promotion/qps-wise-sale-data";
  static String salesDataForQpsTarget = "/app-api/sales/get-outlet-wise-sales-data";

  static String leaveCalenderUrl = '/app-api/leave/calendar';
  static String movementEditUrl = '/app-api/movement';

  static String updatePjpUrl = '/app-api/movement/update_pjp';

  static String getPjpPlansUrl({required DateTime startDate, required DateTime endDate, required int userId, required int userType}) {
    return "/app-api/movement/pjp?start_date=${startDate.year}-${startDate.month}-${startDate.day}&end_date=${endDate.year}-${endDate.month}-${endDate.day}&user_id=$userId&user_type=$userType";
  }

  static String tsmDashVisitedAndNoOrderOutletUrl (String depIds, String startDate, String endDate) {
    return  '/afbl-dashboard/no-order-and-visited-outlet?dep_ids=$depIds&start_date=$startDate&end_date=$endDate';
  }
  static String tsmDashTargetVsAchievementUrl (String depIds, String startDate, String endDate) {
    return  '/afbl-dashboard/by-date-monthly-target-archievement?dep_ids=$depIds&start_date=$startDate&end_date=$endDate';
  }
  static String cprRadtCpcUrl (String depIds, String startDate, String endDate) {
    return  '/afbl-dashboard/dashboard-summary?dep_ids=$depIds&start_date=$startDate&end_date=$endDate';
  }
  static String mandatoryAndFocussedUrl (String depIds, String startDate, String sbuIds) {
    return  '/afbl-dashboard/tsm-app-dashboard?dep_ids=$depIds&date=$startDate&sbu_id=$sbuIds';
  }
  static String tsmDashTotalAndTargetOutletUrl = '/afbl-dashboard/get-outlet-info';

  static String getTeamPerformanceUrl({required depIds, required String date, required String sbuIds}) {
    return "/afbl-dashboard/get-sr-live-target-achievement?dep_ids=$depIds&date=$date&sbu_ids=$sbuIds";
  }
  // AWS Stock Count
  static String awsStockUrl = "/app-api/stock/dep-stock-count";
  static String outletStockCountUrl = "/app-api/sales/save-stock-count-by-outlet";

  static String getLoadSummary(int depId, String date) => "/vehicle-load/load-summary?date=$date&dep_ids=$depId";
  static String getLoadSummaryDetails(
      {required int vehicleId,
        required int depId,
        required String date,
        required String selectedDate,
      }) =>
      "/vehicle-load/load-summary-details?vehicle_id=$vehicleId&dep_id=$depId&date=$selectedDate&delivery_date=$date";

  static String preorderPrintMemoRetailerUrl = '/app-api/sync-file/get-available-pre-order-print-memo';

  static final String submitLiftingStock = '/app-api/stock/submit-lifting-stock';

  static final String checkoutFromSales = '/app-api/sales/checkout';

  static final String resignation = '/app-api/resignations';
  static final String resignationStatus = '/app-api/resignations/my-resignations';

  static final String transferBill = '/app-api/transfer-bill';
  static final String allTransferBills = '/app-api/transfer-bill/my-claims/';

  static String getMaxLimitForPreorder({
    required String sbuId,
    required int depId,
    required int routeId}) =>
      '/app-api/sales/get-max-order-limit?sbuId=$sbuId&depId=$depId&routeId=$routeId';

  static final String submitStockImage = '/app-api/sales/stock-check-images';

  static String getImageUrl({required String imageName}) => '$baseUrl/app-api/static-file/info/signed-url/$imageName';

  static final String resetSaleUrl = '$baseUrl/app-api/sales/save-sales-reset-log';

  static final String flashServerDataUrl = '$baseUrl/app-api/sales/sync-file-data-flash';

  static final String individualSurveySubmitUrl = '$baseUrl/app-api/sales/survey-submit';
  static String getOutletWiseQcUrl({required int depId}) => '$baseUrl/qc-management/get-qc-app-summary?qc_type=1&dep_id=$depId';
  static String getPointWiseQcUrl({required int depId}) => '$baseUrl/qc-management/last-submitted-point-wise-qc?dep_id=$depId';
  static String getPointWiseOutletUrl({required int pointId, required String saleDate}) => '$baseUrl/sync-file/retailers?dep_id=$pointId&sale_date=$saleDate';
  static final String submitOutletWiseQcUrl = '$baseUrl/qc-management/qc-ao-verification';
  static final String submitPointWiseQcUrl = '$baseUrl/qc-management/qc-verification';
}

String getActivity({required String activity}){
  if(activity=='Installation'){
    return 'Asset Installation';
  } return 'Asset Pull-out';
}





