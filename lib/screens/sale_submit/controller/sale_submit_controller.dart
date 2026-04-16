import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/main.dart';
import 'package:wings_olympic_sr/services/day_close_service.dart';

import '../../../api/global_http.dart';
import '../../../api/links.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../models/outlet_model.dart';
import '../../../models/returned_data_model.dart';
import '../../../models/sale_submit_table_model.dart';
import '../../../models/sr_info_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../services/connectivity_service.dart';
import '../../../services/encryption_services.dart';
import '../../../services/export_pda_service.dart';
import '../../../services/offline_pda_service.dart';
import '../../../services/outlet_services.dart';
import '../../../services/stock_service.dart';
import '../../../services/sync_read_service.dart';
import '../../../utils/sales_type_utils.dart';
import '../../olympic_tada/service/olympic_tada_service.dart';
import '../../olympic_tada/ui/olympic_tada_ui.dart';
import '../../settings/controller/settings_controller.dart';

class SaleSubmitController {
  late WidgetRef ref;
  late BuildContext context;
  late Alerts _alert;

  SaleSubmitController({required this.context, required this.ref}) {
    checkInternet();
    _alert = Alerts(context: context);
  }

  final _dayCloseService = DayCloseService();

  checkInternet()async{
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.read(internetConnectivityProvider.state).state = await ConnectivityService().checkInternet();
    });
  }

  OfflinePdaService offlinePdaService = OfflinePdaService();

  // syncData()async{
  //   _alert.floatingLoading();
  //   await OutletServices().syncOutletInfo();
  //   navigatorKey.currentState?.pop();
  //   ref.refresh(outletTotalSyncedCountProvider);
  // }

  /// get server data for table
  getSaleSubmitServerData() async {
    SrInfoModel srInfo = await SyncReadService().getSrInfo();
    String date = await SyncReadService().getSalesDate();
    ReturnedDataModel returnedDataModel = await GlobalHttp(
      httpType: HttpType.get,
      uri: Links.salesSubmitServerData(depId: srInfo.pointId, date: date),
      accessToken: srInfo.accessToken,
      refreshToken: srInfo.refreshToken,
    ).fetch();
    if (returnedDataModel.status == ReturnedStatus.success) {
      Map map = returnedDataModel.data['data'];
      if(map.containsKey("promotion") && map["promotion"]!=0) {
        if(map["promotion"].runtimeType == double) {
          map["promotion"] = double.tryParse(map["promotion"].toStringAsFixed(2));
        }
      }
      ref.read(saleSummaryServerDataProvider.state).state = map;
    } else {
      _alert.customDialog(
        type: AlertType.error,
        message: 'Couldn\'t fetch server data',
        description: returnedDataModel.errorMessage,
      );
    }
  }

  /// get device data for table
  Future<List<SaleSubmitTableModel>> getSubmittedSaleData() async {
    List<SaleSubmitTableModel> saleSubmittedData = await offlinePdaService.getSaleSubmittedData();

    return saleSubmittedData;
  }

  showAlertForSync() {
    int allProgress = 100;

    _alert.showModalWithWidget(
        dismissible: true,
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.sp)),
          padding: EdgeInsets.only(left: 1.5.h, top: 6.w, right: 1.5.h, bottom: 2.5.w),
          height: 25.h,
          width: 40.w,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                LangText(
                  'Data is Syncing. Please do not close the process',
                  style: TextStyle(color: red3),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Container(
                  height: 2.h,
                  width: 100.w,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.sp), color: Colors.grey[200]),
                  child: Stack(
                    children: [
                      Consumer(builder: (context, ref, _) {
                        int currentProgress = ref.watch(syncDataProgressProvider.state).state;
                        return Container(
                          height: 2.h,
                          width: (currentProgress * 100 / allProgress).w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.sp),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [darkGreen, green],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  bool _saleSubmitInProgress = false;

  syncAllDataForASectionToServer(List<SaleSubmitTableModel> deviceData) async {
    if (_saleSubmitInProgress) {
      return;
    }
    ///check draft tada
    if (await OlympicTaDaService().checkUnSubmittedDraftedTaDa()) {
      _alert.customDialog(type: AlertType.warning,
        description: "Drafted Ta/Da available. Submit the Ta/Da first.",
        twoButtons: true,
        button2: "Submit Ta/Da",
        button1: "Cancel",
        onTap2: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, OlympicTaDaUi.routeName, arguments: true);
        },
      );
      return;
    }
    _saleSubmitInProgress = true;
    try {
      _alert.customDialog(type: AlertType.warning,
        description: "Are you really want to close your day? You are not able to sale again today after Day Close.",
        twoButtons: true,
        onTap2: ()  {
          Navigator.pop(context);
        },
        onTap1: () async {
          Navigator.pop(context);
          int currentProgress = 0;
          int retailerDataDoneProgress = 40;
          int deliveryDataDoneProgress = 80;
          int outletDataDoneProgress = 100;

          _alert.floatingLoading();
          bool isConnected = await ConnectivityService().checkInternet();
          navigatorKey.currentState?.pop();
          if (isConnected) {
            bool savePda = false;
            //upload pda to server
            savePda = await SettingsController(context: context, ref: ref).sendPdaToSupport();
            print('-----> upload sync status is $savePda');
            if (savePda==true) {
              List<OutletModel> unsentRetailerList = await offlinePdaService.checkUnsentSyncData();
              showAlertForSync();
              Timer t = Timer.periodic(const Duration(seconds: 2), (timer) {
                if (currentProgress < 40) {
                  currentProgress++;
                  ref.read(syncDataProgressProvider.notifier).state = currentProgress;
                }
              });

              // await offlinePdaService.flashAllServerData();
              await offlinePdaService.getAllOutletDataForSync(unsentRetailerList, SaleType.preorder);
              // await offlinePdaService.getAllOutletDataForSync(unsentRetailerList, SaleType.spotSale);
              ref.read(syncDataProgressProvider.notifier).state = retailerDataDoneProgress;
              if (t.isActive) {
                t.cancel();
              }

              // await StockService().sendStockDataToServer();
              List<OutletModel> deliveryRetailerList = await offlinePdaService.getDeliveryRetailerList();
              Timer t2 = Timer.periodic(const Duration(seconds: 2), (timer) {
                if (currentProgress < 80) {
                  currentProgress++;
                  ref.read(syncDataProgressProvider.notifier).state = currentProgress;
                }
              });

              // await offlinePdaService.getAllOutletDataForSync(deliveryRetailerList, SaleType.delivery, disableSalesSummary: true);
              ref.read(syncDataProgressProvider.notifier).state = deliveryDataDoneProgress;
              if (t2.isActive) {
                t2.cancel();
              }

              // await OutletServices().syncOutletInfo();
              ref.read(syncDataProgressProvider.notifier).state = outletDataDoneProgress;
              //for npi survey sync
              // bool npiSurveyUploadDone = await NpiSurveyService().syncAllNpiSurveyData();

              await getSaleSubmitServerData();
              if (unsentRetailerList.isNotEmpty) {
                Navigator.pop(context);
              }

              checkIfSyncIsSuccessful(deviceData);
            } else {
              _alert.customDialog(type: AlertType.error, description: "Data Sync Failed");
            }
          }
        },
      );
    } catch (e, s) {
      print("inside syncAllDataForASectionToServer submitSalesController catch block $e $s");
    }
    _saleSubmitInProgress = false;
  }

  checkIfSyncIsSuccessful(List<SaleSubmitTableModel> deviceData) async {
    try {
      Map serverData = ref.read(saleSummaryServerDataProvider.state).state;
      bool synced = true;
      if (deviceData.isNotEmpty) {
        for (SaleSubmitTableModel d in deviceData) {
          if (serverData.containsKey(d.key)) {
            if(d.key=="promotion") {
              synced = true;
            } else {
              if (d.value != serverData[d.key]) {
                print("${d.key} >===> ${d.value} : ${serverData[d.key]}");
                synced = false;
              }
            }
          } else {
            synced = false;
          }
          if (!synced) {
            break;
          }
        }
      }
      if (!synced) {
        _alert.customDialog(type: AlertType.error, description: "Data Sync Failed!");
      } else {
        closeYourDay();
        ref.invalidate(salesSubmittedProvider);
        ref.read(saleSubmitButtonProvider.state).state = true;
        _alert.customDialog(type: AlertType.success, description: "Data Sync Successfully");
      }
    } catch (e) {
      print("inside checkIfSyncIsSuccessful SubmitSalesController catch block $e");
    }
  }

  void showUnEditableWarning(){
    _alert.customDialog(type: AlertType.error, description: "You can't edit coupon code used order");
  }

  void closeYourDay() {
    _dayCloseService.closeAllServiceForToday();
  }

  ///final sale submit
// saleSubmit() async {
//   _alert.customDialog(
//       type: AlertType.warning,
//       message: 'Do you want to submit your sale?',
//       twoButtons: true,
//       onTap1: () async {
//         Navigator.pop(context); // বিক্রয় জমা হচ্ছে
//         _alert.floatingLoading(message: 'Submitting Sale Data');
//
//         ReturnedDataModel bikroyjomaReturndData = await offlinePdaService.sendBikroyJoma();
//         Navigator.pop(context);
//         if (bikroyjomaReturndData.status == ReturnedStatus.success) {
//           _alert.customDialog(type: AlertType.success, message: "Sale Successfully Submitted");
//         } else {
//           _alert.customDialog(type: AlertType.error, message: "Sale submission failed", description: bikroyjomaReturndData.errorMessage);
//         }
//       });
// }

  ///export pda
// exportPda() async {
//   Map pdaData = await offlinePdaService.formatPdaData();
//   String? encryptedPda = EncryptionServices().encrypt(jsonEncode(pdaData));
//   if (encryptedPda != null) {
//     ReturnedDataModel returnedDataModel =
//     await ExportPdaService(encryptedPda).exportPdaFile();
//     if (returnedDataModel.status == ReturnedStatus.success) {
//       _alert.customDialog(
//         type: AlertType.success,
//         message: 'Pda File exported to location ${returnedDataModel.data}',
//       );
//     } else {
//       _alert.customDialog(
//         type: AlertType.error,
//         message: 'Couldn\'t export Pda File',
//       );
//     }
//   }
// }


}
