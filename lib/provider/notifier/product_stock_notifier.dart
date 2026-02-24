import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/sync_global.dart';
import '../../models/products_details_model.dart';

class ProductStockNotifier extends StateNotifier<StockModel> {
  final ProductDetailsModel sku;
  bool stockEditIsOpen;

  ProductStockNotifier(this.sku, this.stockEditIsOpen) : super(sku.stocks) {
    makeCurrentStockModule();
    if (currentStockData[sku.module.id].containsKey(sku.id)) {
      state = StockModel(
          liftingStock: currentStockData[sku.module.id][sku.id],
          currentStock: sku.stocks.currentStock);
    }
  }

  addStock(StockModel currentStock, int addedAmount) {
    if (!stockEditIsOpen) {
      makeCurrentStockModule();
      currentStockData[sku.module.id][sku.id] =
          currentStock.liftingStock + addedAmount;
    }

    state = StockModel(
        liftingStock: currentStock.liftingStock + addedAmount,
        currentStock: currentStock.currentStock);
  }

  removeStock(StockModel currentStock, int subtractedAmount) {
    if (!stockEditIsOpen) {
      makeCurrentStockModule();
      currentStockData[sku.module.id][sku.id] =
          currentStock.liftingStock - subtractedAmount;
    }
    state = StockModel(
        liftingStock: currentStock.liftingStock - subtractedAmount,
        currentStock: currentStock.currentStock);
  }

  makeCurrentStockModule() {
    if (!currentStockData.containsKey(sku.module.id)) {
      currentStockData[sku.module.id] = {};
    }
  }

  setStockModel(StockModel stockModel) {
    state = stockModel;
    if (!stockEditIsOpen) {
      makeCurrentStockModule();
      currentStockData[sku.module.id][sku.id] = stockModel.liftingStock;
    }
  }
}
