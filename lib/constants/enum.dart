enum ButtonLayout { horizontal, vertical }

enum LoginStatus { login_with_api, login_with_sync_file, login_with_sync_and_go_to_pda_upload, go_to_dashboard_automatically }

enum ReturnedStatus { success, info, error, warning }

enum AlertType { success, info, error, warning, lal }

enum HttpType { get, post, file, patch, patchWithoutFile, delete }

enum CapturedImageType { newOutlet, coolerImage, leaveManagementImage, assetOwnerPassportSizePhoto, assetLicensePhoto, assetOwnerNIDPhoto, assetInstallationPhoto, assetPullOutPhoto, maintenance,
  posmPhoto }

enum CapturedMultipleImageType { taDa}

enum ImageType { file, network }

enum SendOutletInfoType { create, edit }

enum OutletSaleStatus { inactive, checkingGeoFencing, manualOverride, callStart, showSkus, reasoning, captureCoolerImage, coolerPurityScore, preview, onUnsoldOutletPressed, showV2sales }

enum AnswerType { select, multiselect, text, number, phone, date, dateRange, image }

enum WomType { wom, kv }

enum SaleStatus { newSale, addedSale, editedSale }

enum PromotionType { absoluteCash, percentageOfValueWithCap }

enum PreorderCategoryFilterButtonType {mandatory,focused,others,all}

enum AttendanceType {checkIn, checkOut}

enum AttendanceStatus {checkInDone, noAttendance, attendanceDone}

enum LeaveManagementType {tada, movement}

enum AssetActivityType {requisition, installation, pull_in}

enum PjpStatusType {done, missed, waiting, todayWaiting, todayDone, }

enum DayEvent {morning, noon, afternoon, evening, night}

enum RequisitionField {outlet, assetType, size, lightBoxBillType, assetPlacement, assetCover, competitor, totalBeverageSale, presentSales, afterSales, currentBranding, nameOfBrand, passportImage, utilityImage, nidImage, cost }


enum SaleDashboardType { preOrder, spotSale, delivery, media, stockCount, survey, promotion, posm, checkout, stockCheck }

enum SaleDashboardCompleteStatus { init, inProgress, done }

enum PrinterStatus {connected, disconnected, reconnecting}

