import '../constants/constant_keys.dart';
import '../constants/enum.dart';
import '../constants/sync_global.dart';
import '../models/module.dart';
import '../models/outlet_model.dart';
import '../models/products_details_model.dart';
import '../models/sales/memo_information_model.dart';
import '../models/sales/sale_data_model.dart';
import '../models/sales/sales_preorder_configuration_model.dart';
import '../models/trade_promotions/promotion_model.dart';
import '../utils/case_piece_type_utils.dart';
import '../utils/sales_type_utils.dart';
import 'helper.dart';
import 'product_category_services.dart';
import 'promotion_services.dart';
import 'sync_read_service.dart';
import 'sync_service.dart';
import 'trade_promotion_services.dart';

class PreOrderService {
  final SyncService _syncService = SyncService();
  final TradePromotionServices _tradePromotionServices = TradePromotionServices();
  final PromotionServices _promotionServices = PromotionServices();

  Future<List<PreorderMemoInformationModel>> getPreorderInfoForRetailer(OutletModel retailer, SaleType saleType) async {
    List<PreorderMemoInformationModel> memoInfos = [];
    try {
      await _syncService.checkSyncVariable();

      final dataKey = saleType == SaleType.preorder ? preorderKey: spotSaleKey;

      Map saleInfo = syncObj.containsKey(dataKey)
          ? syncObj[dataKey].containsKey(retailer.id.toString())
              ? syncObj[dataKey][retailer.id.toString()]
              : {}
          : {};
      if (saleInfo.isNotEmpty) {
        List<Module> modules = await SyncReadService().getModuleModelList();
        if (modules.isNotEmpty) {
          for (Module module in modules) {
            if (saleInfo.containsKey(module.id.toString())) {
              List<ProductDetailsModel> products = [];
              List<ProductDetailsModel> allProductForModule = await ProductCategoryServices().getProductDetailsList(module);

              Map soldSkuInfos = saleInfo[module.id.toString()];

              //initialize total SaleData For A module
              int totalQty = 0;
              double totalPrice = 0.0;
              int totalCase = 0;
              int totalPiece = 0;
              if (allProductForModule.isNotEmpty) {
                for (ProductDetailsModel sku in allProductForModule) {
                  if (soldSkuInfos.containsKey(sku.id.toString())) {
                    SaleDataModel data = SaleDataModel.fromJson(soldSkuInfos[sku.id.toString()]);
                    sku.preorderData = data;
                    products.add(sku);

                    totalQty += soldSkuInfos[sku.id.toString()]['stt'] as int;
                    totalPrice += soldSkuInfos[sku.id.toString()]["price"] as double;

                    int packCount = sku.packSize > 1 ? soldSkuInfos[sku.id.toString()]['stt'] ~/ sku.packSize : 0;
                    int pieceCount = sku.packSize > 1
                        ? soldSkuInfos[sku.id.toString()]['stt'] - (packCount * sku.packSize)
                        : soldSkuInfos[sku.id.toString()]['stt'];
                    totalCase += packCount;
                    totalPiece += pieceCount;
                  }
                }
              }
              SaleDataModel totalPreorderData = SaleDataModel(qty: totalQty, price: totalPrice);
              List<DiscountPreviewModel> discounts = await _tradePromotionServices.getTotalDiscountForARetailerAndModule(
                retailer.id ?? 0,
                saleType,
                module,
              );
              SaleDataModel totalQc = await _promotionServices.getTotalQcForAModuleAndARetailer(retailer.id ?? 0, module.id.toString());
              Map<CasePieceType, int> unitWiseCount = {CasePieceType.CASE: totalCase, CasePieceType.PIECE: totalPiece};
              PreorderMemoInformationModel memo = PreorderMemoInformationModel(
                  module: module,
                  skus: products,
                  totalPreorderData: totalPreorderData,
                  discounts: discounts,
                  totalQcAmount: totalQc,
                  totalCount: unitWiseCount);
              memoInfos.add(memo);
            }
          }
        }
      }
    } catch (e, s) {
      print("inside getPreorderInfoForRetailer PreorderServices catch block $e $s");
    }

    return memoInfos;
  }

  //calculates total preorder quantity per module
  Future<Map> totalPreorderQuanityPerModule(int moduleId) async {
    int totalQty = 0;
    double totalPrice = 0.0;
    int totalVisitedOutlet = 0;
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(preorderKey)) {
        if (syncObj[preorderKey].isNotEmpty) {
          for (var retailerId in syncObj[preorderKey].keys) {
            Map moduleWisePreorderData = syncObj[preorderKey][retailerId];
            if (moduleWisePreorderData.isNotEmpty) {
              if (moduleWisePreorderData.containsKey(moduleId.toString())) {
                if (moduleWisePreorderData[moduleId.toString()].isNotEmpty) {
                  totalVisitedOutlet++;
                  for (var skuId in moduleWisePreorderData[moduleId.toString()].keys) {
                    var preorderData = moduleWisePreorderData[moduleId.toString()][skuId];
                    if (preorderData.isNotEmpty) {
                      try {
                        totalQty += int.parse(preorderData[preorderSttKey].toString());
                        totalPrice += double.parse(preorderData[preorderPriceKey].toString());
                      } catch (e) {
                        print("inside totalPreorderQuanityPerModule addition of total stt catch block $e");
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print("inside totalPreorderQuantityPerModule catch block $e");
    }
    return {"qty": totalQty, "amount": totalPrice, "visited": totalVisitedOutlet};
  }

  //for previous preorder calculation
  Map getPreorderForRetailerModuleAndSku(int retailerId, int moduleId, int skuId, SaleType saleType) {
    Map preorder = {};
    try {
      final dataKey = saleType == SaleType.preorder ? preorderKey: spotSaleKey;
      if (syncObj.containsKey(dataKey)) {
        if (syncObj[dataKey].containsKey(retailerId.toString())) {
          if (syncObj[dataKey][retailerId.toString()].containsKey(moduleId.toString())) {
            if (syncObj[dataKey][retailerId.toString()][moduleId.toString()].containsKey(skuId.toString())) {
              preorder = syncObj[dataKey][retailerId.toString()][moduleId.toString()][skuId.toString()];
            }
          }
        }
      }
    } catch (e) {
      print("inside getPreorderForRetailerModuleAndSku PreorderServices catch block $e");
    }
    return preorder;
  }

  //for previous preorder calculation
  Map getPreorderForARetailerAndModule(int retailerId, int moduleId, SaleType saleType) {
    Map preorder = {};
    try {
      final dataKey = saleType == SaleType.preorder ? preorderKey: spotSaleKey;
      if (syncObj.containsKey(dataKey)) {
        if (syncObj[dataKey].containsKey(retailerId.toString())) {
          if (syncObj[dataKey][retailerId.toString()].containsKey(moduleId.toString())) {
            preorder = syncObj[dataKey][retailerId.toString()][moduleId.toString()];
          }
        }
      }
    } catch (e) {
      print("inside getPreorderForARetailerAndModule preorderServices catch block $e");
    }
    return preorder;
  }

  bool checkIfPreorderTakenForARetailer(int retailerId) {
    bool taken = false;
    try {
      if (syncObj.containsKey(preorderKey)) {
        taken = syncObj[preorderKey].containsKey(retailerId.toString());
      }
    } catch (e) {
      print("inside checkIfPreorderTakenForARetailer preorderServices catch block $e");
    }
    return taken;
  }

  bool checkIfSpotSalesTakenForARetailer(int retailerId) {
    bool taken = false;
    try {
      if (syncObj.containsKey(spotSaleKey)) {
        taken = syncObj[spotSaleKey].containsKey(retailerId.toString());
      }
    } catch (e) {
      print("inside checkIfPreorderTakenForARetailer preorderServices catch block $e");
    }
    return taken;
  }

  Future<Map<String, dynamic>> getPreOrderPerRetailer(int retailerId, int moduleId) async {
    try {
      await _syncService.checkSyncVariable();
      Map<String, dynamic> preorderPreRetailer = {};
      if (syncObj.containsKey("delivery_configurations")) {
        if (syncObj["delivery_configurations"]["delivery_enabled"] == 1) {
          if (syncObj["delivery_configurations"].containsKey("existing_preorders")) {
            if (syncObj["delivery_configurations"]["existing_preorders"].containsKey(retailerId.toString())) {
              preorderPreRetailer = syncObj["delivery_configurations"]["existing_preorders"][retailerId.toString()][moduleId.toString()];
            }
          }
        }
      }

      return preorderPreRetailer;
    } catch (e, s) {
      print("inside pre order Services get preorder per retailer config catch block $e $s");
    }
    return {};
  }

  Future<bool> checkIfCoolerImageNeedsToBeCaptured() async {
    bool needed = false;
    try {
      await _syncService.checkSyncVariable();
      if (syncObj["preorder_configurations"]?["capture_cooler_image"] != null) {
        needed = syncObj["preorder_configurations"]?["capture_cooler_image"] == 1;
      }
    } catch (e) {
      Helper.dPrint("inside checkIfCoolerImageNeedsToBeCaptured PerorderServices catch block $e");
    }
    return needed;
  }

  Future<List<PreorderCategoryFilterButtonType>> getPreorderFilterModel() async {
    List<PreorderCategoryFilterButtonType> types = [];
    try {
      await _syncService.checkSyncVariable();
      Map preorderFilterMap = syncObj["preorder_configurations"]?["preorder_filter_buttons"] ?? {};
      if (preorderFilterMap.isNotEmpty) {
        bool preorderFilterEnabled = (preorderFilterMap["filter_enabled"] ?? 0) == 1;
        if (preorderFilterEnabled) {
          if ((preorderFilterMap["all"] ?? 0) == 1) {
            types.add(PreorderCategoryFilterButtonType.all);
          }

          if ((preorderFilterMap["mandatory"] ?? 0) == 1) {
            types.add(PreorderCategoryFilterButtonType.mandatory);
          }

          if ((preorderFilterMap["focused"] ?? 0) == 1) {
            types.add(PreorderCategoryFilterButtonType.focused);
          }

          if ((preorderFilterMap["others"] ?? 0) == 1) {
            types.add(PreorderCategoryFilterButtonType.others);
          }
        }
      }
    } catch (e) {
      Helper.dPrint("inside getPreorderFilterModel PreorderServices catch block $e");
    }
    return types;
  }


  Future<SalesPreorderConfigurationModel> getModulesAvailableForPreOrder([int? retailerId]) async {
    List availableModuleForSales = [];
    List availableModuleForPreorder = [];
    List availableModuleForEdit = [];
    try {
      await _syncService.checkSyncVariable();

      //calculate sales_configurations
      List<String> moduleIds = syncObj["modules"].keys.toList();
      availableModuleForSales = moduleIds.map(int.parse).toList();
      if (syncObj.containsKey("sales_configurations")) {
        if (syncObj["sales_configurations"].containsKey("available_sales_modules")) {
          availableModuleForSales = syncObj["sales_configurations"]["available_sales_modules"];
        }
      }

      if (syncObj.containsKey("preorder_configurations")) {
        if (syncObj["preorder_configurations"].containsKey("available_preorder_modules")) {
          if (syncObj["preorder_configurations"]["available_preorder_modules"].isNotEmpty) {
            availableModuleForPreorder = syncObj["preorder_configurations"]["available_preorder_modules"];
          }
        }
      }

      if (retailerId != null) {
        List sbuAvailableForEditAfterPromotion = syncObj["sales_configurations"]?["sbu_available_for_edit_after_promotion"] ??[];
        List sbuListThatHavePromotion = await _promotionServices.getModuleListThatHavePromotionForARetailer(retailerId);
        if (availableModuleForSales.isNotEmpty) {
          availableModuleForSales.forEach((val) {
            if (sbuListThatHavePromotion.contains(val)) {
              if (sbuAvailableForEditAfterPromotion.contains(val)) {
                availableModuleForEdit.add(val);
              }
            } else {
              availableModuleForEdit.add(val);
            }
          });
        }
        availableModuleForSales = availableModuleForEdit;
      }

    } catch (e, s) {
      print("inside getModulesAvailableForPreorder preorderServices catch block $e $s");
    }
    return SalesPreorderConfigurationModel(availableModuleForSales: availableModuleForSales, availableModuleForPreoderder: availableModuleForPreorder, );
  }



  Future<Map<String, int>> getPreOrderStock() async {
    try {
      await _syncService.checkSyncVariable();
      Map<String, int> preorderStock = {};
      SalesPreorderConfigurationModel salesPreorder = await getModulesAvailableForPreOrder();
      if (syncObj.containsKey("existing_preorders")) {
        syncObj["existing_preorders"].forEach((retailerID, modules) {
          modules.forEach((moduleID, skus) {
            if (salesPreorder.availableModuleForSales.contains(int.parse(moduleID))) {
              skus.forEach((skuID, quantity) {
                if (preorderStock.containsKey(skuID)) {
                  int prev = preorderStock[skuID]!;
                  int newQuantity = quantity as int;
                  preorderStock[skuID] = prev + newQuantity;
                } else {
                  preorderStock[skuID] = quantity as int;
                }
              });
            }
          });
        });
      }
      return preorderStock;
    } catch (e) {
      print("inside pre order Services get preorder config catch block $e");
    }
    return {};
  }
}
