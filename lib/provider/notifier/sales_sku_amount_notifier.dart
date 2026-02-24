import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/sync_global.dart';
import '../../models/general_id_slug_model.dart';
import '../../models/module.dart';
import '../../models/outlet_model.dart';
import '../../models/products_details_model.dart';
import '../../models/sales/sale_data_model.dart';
import '../../services/price_services.dart';
import '../global_provider.dart';

class SalesSkuAmountNotifier extends StateNotifier<SaleDataModel> {
  final ProductDetailsModel sku;
  final Ref ref;
  SalesSkuAmountNotifier(this.sku, this.ref) : super(SaleDataModel()) {
    _init();
  }

  _init() async {
    makeCurrentPreOrderModule();
    if (currentPreorderData[sku.module.id].containsKey(sku.id)) {
      SaleDataModel saleDataModel = await getCurrentSaleData(currentPreorderData[sku.module.id][sku.id]);
      state = saleDataModel;
    }
  }



  setState(int amount) {
    state = SaleDataModel(qty: amount, price: state.price, discount: state.discount, salesDate: state.salesDate, salesDateTime: state.salesDateTime, qcPrice: state.qcPrice);
  }



  Future<SaleDataModel> getCurrentSaleData(int quantity) async {

    SaleDataModel saleDataModel = SaleDataModel();
    try {
      OutletModel? retailer = ref.read(selectedRetailerProvider);
      if (retailer != null) {
       await saleDataModel.saveQty(retailer: retailer, sku: sku, quantity: quantity);

      }
    } catch (e) {
      debugPrint("inside calculate Price salesSkuAmountNotifier catch block $e");
    }

    return saleDataModel;
  }

  incrementDecrementAmount(int amount, bool added) async {

      SaleDataModel currentSaleData = state;
      int currentQty = currentSaleData.qty;

      if (added) {
        currentQty += amount;
      } else {
        currentQty -= amount;
      }
      //changed price calculation
      SaleDataModel changedSaleData = await getCurrentSaleData(amount);
      num totalSalePrice = ref.read(totalSoldAmountProvider);
      if(added){
        totalSalePrice+=changedSaleData.price;
      }else{
        totalSalePrice -=changedSaleData.price;
      }
      ref.read(totalSoldAmountProvider.notifier).state = totalSalePrice;
      SaleDataModel saleDataModel = await getCurrentSaleData(currentQty);

      currentPreorderData[sku.module.id][sku.id] = saleDataModel.qty;
      state = saleDataModel;

  }

  increment(int addedAmount) async {
    incrementDecrementAmount(addedAmount, true);
  }

  decrement(int subtractedAmount) async {
    incrementDecrementAmount(subtractedAmount, false);
  }

  makeCurrentPreOrderModule() {
    if (!currentPreorderData.containsKey(sku.module.id)) {
      currentPreorderData[sku.module.id] = {};
    }
  }

  setSalesAmount(int amount, int prevAmount) async {
    // , double totalPrevPrice
    OutletModel? retailer = ref.read(selectedRetailerProvider.notifier).state;
    num totalPrevPrice = ref.read(totalSoldAmountProvider.notifier).state;

    if (retailer != null) {
      num curPrice = await PriceServices().getSkuPriceForASpecificAmount(sku, retailer, amount);

      num prevPrice = await PriceServices().getSkuPriceForASpecificAmount(sku, retailer, prevAmount);

      num amountDifference = prevPrice - curPrice;

      ref.read(totalSoldAmountProvider.state).state = totalPrevPrice - amountDifference;

      makeCurrentPreOrderModule();
      currentPreorderData[sku.module.id][sku.id] = amount;
      state = SaleDataModel(qty: amount, price: curPrice, discount: state.discount, salesDate: state.salesDate, salesDateTime: state.salesDateTime, qcPrice: state.qcPrice);
    }
  }

  decrementEdit(int subtractedAmount) async {
    state = SaleDataModel(qty: state.qty - subtractedAmount, price: state.price, discount: state.discount, salesDate: state.salesDate, salesDateTime: state.salesDateTime, qcPrice: state.qcPrice);

  }
  incrementEdit(int addedAmount) async {
    state = SaleDataModel(qty: state.qty + addedAmount, price: state.price, discount: state.discount, salesDate: state.salesDate, salesDateTime: state.salesDateTime, qcPrice: state.qcPrice);
  }
  bulkEdit(int addedAmount) async {
    state = SaleDataModel(qty: addedAmount, price: state.price, discount: state.discount, salesDate: state.salesDate, salesDateTime: state.salesDateTime, qcPrice: state.qcPrice);
  }

}
