import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/enum.dart';
import '../../../models/outlet_model.dart';
import '../../../models/products_details_model.dart';
import '../../../models/qc_info_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../services/price_services.dart';

class QCController {
  late WidgetRef ref;
  late BuildContext context;
  List<QCInfoModel> qcList = [];
  QCController({required this.context, required this.ref});

  saveQC(List<QCInfoModel> qcList) async {
    ProductDetailsModel? sku = ref.read(selectedProductForQCProvider);
    OutletModel? retailer = ref.read(selectedRetailerProvider);
    double maxQCValue = ref.read(maxQCProvider);
    double qcDoneValue = ref.read(qcDoneProvider);
    List<SelectedQCInfoModel> list = ref.read(selectedQCInfoListProvider);
    bool notExist = true;
    int totalQC = 0;
    for (SelectedQCInfoModel val in list) {
      if (val.sku == sku) {
        list.remove(val);
        break;
      }
    }

    if (notExist) {
      for (QCInfoModel qc in qcList) {
        totalQC += qc.totalValidQCQuantity();
      }
      num qcValue = await PriceServices().getSkuPriceForASpecificAmount(sku!, retailer!, totalQC);

      ref.read(qcDoneProvider.state).state = qcValue.toDouble();
      SelectedQCInfoModel selectedQCInfoModel = SelectedQCInfoModel(
          sku: sku, retailer: retailer, qcInfoList: qcList);
      list.add(selectedQCInfoModel);
      ref.read(selectedQCInfoListProvider.state).state = [...list];
      Navigator.pop(context);
      // if ((qcValue + qcDoneValue) <= maxQCValue) {
      //   ref.read(qcDoneProvider.state).state = qcValue.toDouble();
      //   SelectedQCInfoModel selectedQCInfoModel = SelectedQCInfoModel(
      //       sku: sku, retailer: retailer, qcInfoList: qcList);
      //   list.add(selectedQCInfoModel);
      //   ref.read(selectedQCInfoListProvider.state).state = [...list];
      //   Navigator.pop(context);
      // } else {
      //   Alerts(context: context).customDialog(
      //       type: AlertType.warning,
      //       message: 'You can not add more SKU than maximum Damage limit!',
      //       button1: 'Ok',
      //       onTap1: () {
      //         Navigator.pop(context);
      //       });
      // }
    }
  }

  removeQC()async{
    ProductDetailsModel? sku = ref.read(selectedProductForQCProvider);
    OutletModel? retailer = ref.read(selectedRetailerProvider);
    // double maxQCValue = ref.read(maxQCProvider);
    double qcDonePrev = ref.read(qcDoneProvider);
    List<SelectedQCInfoModel> list = ref.read(selectedQCInfoListProvider);
    // bool notExist = true;
    int totalQC = 0;
    for (SelectedQCInfoModel val in list) {
      if (val.sku == sku) {
        for(QCInfoModel qcinfo in val.qcInfoList){
          totalQC += qcinfo.totalQCQuantity;
        }
        num qcForThisSKUValue = await PriceServices().getSkuPriceForASpecificAmount(sku!, retailer!, totalQC);
        ref.read(qcDoneProvider.state).state = qcDonePrev - qcForThisSKUValue;
        list.remove(val);

        break;
      }
    }
    ref.read(selectedQCInfoListProvider.state).state = [...list];
    Navigator.pop(context);
  }
  Map<int, int> getQcQuantityData(ProductDetailsModel sku) {
    Map<int, int> data = {};
    List<SelectedQCInfoModel> list = ref.read(selectedQCInfoListProvider);
    for (SelectedQCInfoModel selectedQCInfoModel in list) {
      if (selectedQCInfoModel.sku.id == sku.id) {
        for (QCInfoModel qcInfoModel in selectedQCInfoModel.qcInfoList) {
          for (QCTypesModel qcTypesModel in qcInfoModel.types) {
            if(qcInfoModel.saleableReturn != 1){
              if (qcTypesModel.quantity > 0) {
                data[qcTypesModel.id] = qcTypesModel.quantity;
              }
            }
          }
        }
        break;
      }
    }
    return data;
  }

  List<QCInfoModel> getQCInfoList() {
    return qcList;
  }

  navigateSKUForQC(ProductDetailsModel sku) async {
    ref.read(selectedProductForQCProvider.state).state = sku;
    OutletModel? retailer = ref.read(selectedRetailerProvider.state).state;
    Map<int, int> qcPrevData = getQcQuantityData(sku);

    int totalPrevQC = 0;
    qcPrevData.forEach((key, value) {
      totalPrevQC += value;
    });
    num totalQCValue = await PriceServices()
        .getQcSkuPriceForASpecificAmount(sku, retailer!, totalPrevQC);
    ref.read(prevQCAmountProvider.state).state = totalQCValue.toDouble();
  }

  onChangeQCEntry(String quantity, List<QCInfoModel> qcList, QCInfoModel qc,
      QCTypesModel qcFault) {
    try {
      if (quantity.isNotEmpty) {
        if (int.parse(quantity) == 0) {
          qcFault.quantity = 0;
          if (qcList.contains(qc) && qc.totalQuantity() <= 0) {
            qcList.remove(qc);
          }
        } else if (int.parse(quantity) < 0) {
          throw 'Negative value';
        } else {
          if (!qcList.contains(qc)) {
            qcList.add(qc);
          }
        }
        qcFault.quantity = int.parse(quantity);
        // totalQC += (int.parse(quantity));

      } else {
        qcFault.quantity = 0;
        if (qcList.contains(qc) && qc.totalQuantity() <= 0) {
          qcList.remove(qc);
        }
      }
    } catch (e) {
      Alerts(context: context).customDialog(
          type: AlertType.error, message: 'Please provider proper input.');
    }
  }
}
