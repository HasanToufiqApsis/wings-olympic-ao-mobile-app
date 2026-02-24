import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wings_olympic_sr/utils/sales_type_utils.dart';

import '../../../constants/constant_keys.dart';
import '../../../constants/enum.dart';
import '../../../constants/sync_global.dart';
import '../../../main.dart';
import '../../../models/module.dart';
import '../../../models/outlet_model.dart';
import '../../../models/sales/memo_information_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../services/geo_location_service.dart';
import '../../../services/pre_order_service.dart';
import '../../../services/sales_service.dart';
import '../../../services/sync_read_service.dart';
import '../../sale/ui/sale_ui.dart';
import '../../sale/ui/sale_v2_widget/show_sku_ui.dart';
import '../../sale/ui/sale_v2_widget/show_sku_ui_v2.dart';

class MemoController {
  late BuildContext context;
  late WidgetRef ref;

  MemoController({required this.context, required this.ref}):_alerts = Alerts(context: context);
  List<String> reasonList = ['Wrong SKU Selected', 'Wrong SKU Amount', 'Promotion Issue'];

   late Alerts _alerts;

  final SalesService _salesService = SalesService();

  onEdit({required SaleType saleType})async{
    OutletModel? outletModel = ref.read(selectedRetailerProvider);
    if(outletModel != null){
      _alerts.floatingLoading();
      bool canEdit = await checkIfSaleEditCanBeDoneInAParticularMemo();
      Navigator.of(context).pop();
      if(canEdit){
        List<PreorderMemoInformationModel> memoInfos = await PreOrderService().getPreorderInfoForRetailer(outletModel, saleType);
        print("preordered is ::: ${memoInfos.length}");
        AllMemoInformationModel allMemo = AllMemoInformationModel(preorderMemo: memoInfos, saleMemo: []);
        // {"memoInformationModel": allMemo, "outletModel": outletModel}

        // navigatorKey.currentState?.pushNamed(SaleUI.routeName, arguments: allMemo);
        navigatorKey.currentState?.pushNamed(ShowSkuUIV2.routeName, arguments: {'sale_type': saleType, 'all_memo': allMemo});
      }

    }
  }
  onPrint() async {
    OutletModel? selectedRetailer = ref.watch(selectedRetailerProvider);
    List<Module> moduleList = await SyncReadService().getModuleModelList();
    if (selectedRetailer != null) {

      List<PreorderMemoInformationModel> memoPreorderInfos = await PreOrderService().getPreorderInfoForRetailer(selectedRetailer, SaleType.preorder);
      Map<String, dynamic> data = {};


      Alerts(context: context).floatingLoading();
      // await PrinterController(context: context, ref: ref).printMemoFromMemoPage(selectedRetailer, memoSalesInfos, memoPreorderInfos, data);
      Navigator.pop(context);
    } else {
      Alerts(context: context).customDialog(type: AlertType.error, message: 'Please select a retailer');
    }
  }

  bool checkQCExist(int retailerId) {
    bool exists = false;
    try{
      if(syncObj.containsKey(qcDataKey)){
        if(syncObj[qcDataKey].containsKey(retailerId.toString())){
          exists = true;
        }
      }
    }catch(e){

    }
    return exists;
    // List<double> qcValue = ref.read(totalQCListProvider);
    // if (qcValue.isEmpty || qcValue.reduce(max) > 0) {
    //   return true;
    // }
    // return false;
  }

  Future<bool> checkGeoFencing(OutletModel retailer) async {
    bool insideFence = await LocationService(context).geoFencing(lat: retailer.outletLocation.longitude, lng: retailer.outletLocation.latitude, allowedDistance: retailer.outletLocation.allowableDistance);
    return insideFence;
  }

  // =========== Sale Edit Related Function =====================
  Future<bool> checkIfSaleEditCanBeDoneInAParticularMemo()async{
    bool success = false;
    try{
      OutletModel? retailer = ref.read(selectedRetailerProvider);
      if(retailer !=null){
        bool saleEditAlreadyDone = false;//await _salesService.checkIfSaleEditAlreadyDoneForARetailer(retailer.id!);
        if(!saleEditAlreadyDone){
          bool geoFencing = true ;// await checkGeoFencing(retailer);
          if(geoFencing==true){

            bool hasPromotion = false;//await SyncReadService().checkPromotionForRetailer(retailer.id.toString());
            if(!hasPromotion){
              bool qcExist = false; // checkQCExist(retailer.id!);
              print("qc data $qcExist");
              if (qcExist) {
                Navigator.pop(context);
                _alerts.customDialog(type: AlertType.warning, message: 'As this outlet has Damage, And so this sale can not be edited.');
              }else{
                success = true;
              }
            }
            else {
              Navigator.pop(context);
              _alerts.customDialog(type: AlertType.warning, message: 'As this outlet has promotion, And so this sale can not be edited.');
            }
          }else {
            Navigator.pop(context);
            _alerts.customDialog(type: AlertType.error, message: 'You are not in the range of selected retailer');
          }

        }
        else{
          _alerts.customDialog(type: AlertType.warning, message: 'Sale edit is already done.');
        }


      }
    }catch(e){
      print("inside checkIfSaleEditCanBeDoneInAParticularMemo memoController catch block $e");
    }
    return success;
  }
  //===========================================================


}
