import 'package:wings_olympic_sr/models/preorder_stock_model.dart';
import 'package:wings_olympic_sr/models/sales/sale_data_model.dart';
import 'module.dart';

class ProductDetailsModel {
  late int id;
  late String name;
  late String shortName;
  late String slug;
  late int parentId;
  late Map parents;
  late StockModel stocks;
  PreorderStockModel? preOrderStocks;
  late String increasedId;
  late Module module;
  SaleDataModel? preorderData;
  late String filterType;

  /// changed here
  List<SkuUnitItem> unitConfig = [];
  late num sort;
  late int uomType;
  late int packSize;
  late int packSizeCases;

  ProductDetailsModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.parentId,
    required this.parents,
    required this.uomType,
    required this.unitConfig,
    required this.packSize,
    required this.packSizeCases,
    required this.filterType,
  });

  ProductDetailsModel.fromJson(Map json, this.slug, this.increasedId, {required List<SkuUnitItem> unitConfiguration}) {
    id = json['id'];
    name = json['name'];
    unitConfig = unitConfiguration;
    shortName = json['short_name'];
    parentId = json['parent_id'];
    parents = json["parents"];
    sort = json["sort"];
    uomType = json["uom_type_default"];
    packSize = json["pack_size_value"] ?? 1;
    packSizeCases = json["pack_size_cases"] ?? 1;
    filterType = json['filter_type'];
  }

  setStocks(StockModel stockModel) {
    stocks = stockModel;
  }

  setPreorderStocks(PreorderStockModel stockModel) {
    preOrderStocks = stockModel;
  }

  setModule(Module modules) {
    module = modules;
  }

  savePreorderData(SaleDataModel data) {
    preorderData = data;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['short_name'] = shortName;
    data['parent_id'] = parentId;
    return data;
  }
}

class StockModel {
  late int liftingStock;
  late int currentStock;
  int? ideaStock;

  StockModel({
    required this.liftingStock,
    required this.currentStock,
    this.ideaStock,
  });

  StockModel.fromJson(Map<String, dynamic> json) {
    liftingStock = json['lifting_stock'];
    currentStock = json['current_stock'];
    ideaStock = json['ideal_stock'];
  }

  consumeORAddAdditionalStock(ProductDetailsModel sku, Map previousSaleData) {
    int previousSale = previousSaleData.containsKey(sku.id.toString())
        ? previousSaleData[sku.id.toString()]['stt']
        : 0;
    // if (sku.saleData != null) {
    //   currentStock =
    //       sku.stocks.currentStock - (sku.saleData!.qty - previousSale);
    // }
    // else {
    //   currentStock = sku.stocks.currentStock - previousSale;
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lifting_stock'] = liftingStock;
    data['current_stock'] = currentStock;
    return data;
  }
}

class SkuUnitItem {
  final String? packType;
  final int? packSize;
  final String? uomType;

  SkuUnitItem({
    this.packType,
    this.packSize,
    this.uomType,
  });

  factory SkuUnitItem.fromJson(Map<String, dynamic> json) {
    return SkuUnitItem(
      packType: json['pack_type'],
      packSize: json['pack_size'] as int?,
      uomType: json['uom_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pack_type': packType,
      'pack_size': packSize,
      'uom_type': uomType,
    };
  }
}