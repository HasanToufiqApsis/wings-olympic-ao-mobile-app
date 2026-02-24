import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../constants/sync_global.dart';
import '../../../main.dart';
import '../../../models/AvModel.dart';
import '../../../models/module.dart';
import '../../../models/products_details_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../services/before_sale_services/av_service.dart';
import '../../../services/module_services.dart';
import '../../../services/pre_order_service.dart';
import '../../../services/product_category_services.dart';
import '../../../services/stock_service.dart';
import '../../../services/sync_read_service.dart';
import '../../../utils/case_piece_type_utils.dart';
import '../../printer/controllers/printer_controller.dart';
import '../../video_player.dart';
import '../ui/stock_edit_dialog_ui.dart';

class StockController {
  BuildContext context;
  WidgetRef ref;

  // final _rtcService = RTCService();

  StockController({required this.context, required this.ref})
      : _alerts = Alerts(context: context),
        _printerController = PrinterController(context: context, ref: ref);
  late final Alerts _alerts;
  late PrinterController _printerController;

  final ProductCategoryServices _productCategoryServices =
      ProductCategoryServices();
  final SyncReadService _syncReadService = SyncReadService();

  inputFormatting(
      ProductDetailsModel sku, TextEditingController stockEditController) {
    try {
      StockModel stocks = ref.read(productStockEditProvider(sku));
      // int addedAmount = 10;
      // int addedAmount = sku.unitConfig[sku.increasedId] as int;
      int addedAmount = CasePieceTypeUtils.toSize(CasePieceType.PIECE, sku.packSize);
      SkuUnitItem? selectedUnit = ref.watch(selectedSkuUnitConfigProvider(sku));
      if (stockEditController.text.isNotEmpty) {
        final pS = int.parse(stockEditController.text) * (selectedUnit?.packSize ?? 1);
        if (pS % addedAmount != 0) {
          // stocks.liftingStock = int.parse(stockEditController.text);
          int floorStock = pS ~/ addedAmount;
          int finalStock = floorStock * addedAmount;
          stockEditController.text = finalStock.toString();
        }
        // else {
        //
        //   // stocks.liftingStock = finalStock;
        //   // ref.read(productStockEditProvider(sku).notifier).setStockModel(stocks);
        // }
      } else {
        stockEditController.text = "0";
      }
      final pS = int.parse(stockEditController.text) * (selectedUnit?.packSize ?? 1);
      StockModel newStock = StockModel(
          liftingStock: pS,
          currentStock: stocks.currentStock);
      ref.read(productStockEditProvider(sku).notifier).setStockModel(newStock);
      // ref.read(selectedStockEditCount(sku).state).state = int.parse(stockEditController.text) ~/ addedAmount;

      return newStock;
    } catch (e) {
      print('inside stock textformfield onchanged function error: $e');
      return null;
    }
  }

  openStockDialog(ProductDetailsModel sku, Map<String, int> preorderStock, slug,
      GlobalWidgets globalWidgets,
      {int? idealStock}) {
    StockModel stock = ref.read(productStockProvider(sku));

    ref.read(productStockEditProvider(sku).notifier).setStockModel(stock);

    String preorderMessage = '';
    if (preorderStock.containsKey(sku.id.toString())) {
      preorderMessage = '${preorderStock[sku.id.toString()]}';
    }
    StockModel currStock = StockModel(
        liftingStock: sku.stocks.liftingStock,
        currentStock: sku.stocks.currentStock);
    ref.read(productStockEditProvider(sku).notifier).setStockModel(currStock);
    Alerts(context: context).showModalWithWidget(
        child: StockEditDialogUI(sku, globalWidgets, slug, preorderMessage,
            idealStock: idealStock));
  }

  checkSave() {
    Alerts(context: context).customDialog(
        type: AlertType.info,
        message: 'Are you sure?',
        button1: 'Ok',
        button2: 'Cancel',
        twoButtons: true,
        onTap2: () {
          Navigator.pop(context);
        },
        onTap1: () async {
          // bool alreadyCashSettlement = await SubmitSaleService().getCashSettlementStatus();
          // if(alreadyCashSettlement == true) {
          //   navigatorKey.currentState?.pop();
          //   _alerts.endDayBlockadeWarning();
          //   return;
          // }
          await saveStocks();
        });
  }

  /////////////////// checking preorder match each sku ////////////////////

  checkPreorder() async {
    Map<String, int> preorder = await PreOrderService().getPreOrderStock();

    preorder.forEach((key, value) {
      if (currentStockData.containsKey(int.parse(key.toString()))) {
        if (currentStockData[int.parse(key.toString())] != preorder[key]) {}
      }
    });
    // ref.read(selectedStockSkuCount(sku));
  }

  ///////////////// Makes a Map of lifting and current stock
  // for each sku of each module to store in the sync file//////////////
  saveStocks() async {
    try {
      String lang = ref.read(languageProvider);
      Map<String, int> preorder = await PreOrderService().getPreOrderStock();
      Map<String, Map<String, Map<String, int>>> stocks = {};
      List<Module> moduleList = ref.read(allModuleListProvider).value ?? [];
      log("lifting stock for>>> ${moduleList.length}");
      // String salesDate = await SyncReadService().getSalesDate();
      String skuNamesForPreorder = '';
      List<String> invalidSkuNames = [];

      if (moduleList.isNotEmpty) {
        for (Module module in moduleList) {
          if (!stocks.containsKey(module.slug)) {
            stocks[module.slug] = {};
          }

          List<ProductDetailsModel> skus =
              await _productCategoryServices.getProductDetailsList(module);
          log("lifting stock for>>> ${skus.length}");
          if (skus.isNotEmpty) {
            for (ProductDetailsModel sku in skus) {
              if (!stocks[module.slug]!.containsKey(sku.id.toString())) {
                stocks[module.slug]![sku.id.toString()] = {};
              }

              int liftingStock = getLiftingStockFromCurrentStockData(sku);
              int idealStock = getIdealStockFromSync(module, sku);
              log("lifting stock for ${sku.name} $liftingStock");
              if (!checkInputStockForValidation(liftingStock)) {
                invalidSkuNames.add(sku.name);
              }
              int soldStock = sku.stocks.liftingStock - sku.stocks.currentStock;
              int currentStock = liftingStock - soldStock;
              if (preorder.containsKey(sku.id.toString())) {
                if (preorder[sku.id.toString()]! > (liftingStock)) {
                  skuNamesForPreorder += '${sku.name}, ';
                }
              }
              stocks[module.slug]![sku.id.toString()] = {
                "lifting_stock": liftingStock,
                "current_stock": currentStock,
                "ideal_stock": idealStock,
              };
            }
          }
        }
      }
      finalStockSave(stocks);
    } catch (e, s) {
      print("inside saveStocks stockController catch block $e");
      print("inside saveStocks stockController catch block stack trace $s");
    }
  }

  bool checkInputStockForValidation(int liftingStock) {
    if (liftingStock < 2147483647) {
      return true;
    }
    return false;
  }

  finalStockSave(Map<String, Map<String, Map<String, int>>> stocks) async {
    await StockService().saveLiftingStockToSync(stocks);
    ref.refresh(moduleListProvider);
    ref.refresh(allModuleListProvider);
    ref.refresh(totalIssuedFutureProvider);
    ref.refresh(stockPageProvider);
    ref.read(isStockSavedProvider.notifier).state = true;
    navigatorKey.currentState?.pop();
  }

  // showTutorials() async {
  //   List<AvModel> videoList = await SyncReadService().getMandatoryTutorials();
  //
  //   if (videoList.isNotEmpty) {
  //     _alerts.floatingLoading();
  //
  //     for (AvModel video in videoList) {
  //       await Navigator.pushNamed(context, VideoPlayerUI.routeName, arguments: {
  //         "avModel": video,
  //         "file": await AvService(context).getTutorial(video.filename)
  //       }).then((value) async {
  //         await _syncReadService.submitTutorialData(video.id);
  //       });
  //     }
  //
  //     Navigator.pop(context);
  //   }
  // }

  //get lifting stock value from global variable currentStockData
  int getLiftingStockFromCurrentStockData(ProductDetailsModel sku) {
    int currentLiftingStock = sku.stocks.liftingStock;
    try {
      if (currentStockData.containsKey(sku.module.id)) {
        if (currentStockData[sku.module.id].containsKey(sku.id)) {
          return currentStockData[sku.module.id][sku.id];
        }
      }
    } catch (e) {}

    return currentLiftingStock;
  }

  ///todo
  addingStock(
    ProductDetailsModel sku,
    StockModel currentStock,
    String increasedId, {
    bool stockEditIsOpen = false,
  }) {
    try {
      ref.read(isStockSavedProvider.state).state = false;
      // int addedAmount = sku.unitConfig[increasedId] as int;
      int addedAmount = 1;

      addSpecificAmountOfStock(
        sku,
        currentStock,
        1,
        addedAmount,
        stockEditIsOpen: stockEditIsOpen,
      );
    } catch (e, t) {
      debugPrint("adding error !!!!!");
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
  }

  addSpecificAmountOfStock(
    ProductDetailsModel sku,
    StockModel currentStock,
    int count,
    int addedAmount, {
    bool stockEditIsOpen = false,
  }) {
    try {
      if (stockEditIsOpen) {
        ref.read(productStockEditProvider(sku).notifier).addStock(currentStock, addedAmount);

        ref.read(selectedStockEditCount(sku).state).state += count;
      } else {
        // int counts = ref.read(selectedStockSkuCount(sku));
        // print('Current count for $sku: $counts');
        ref.read(productStockProvider(sku).notifier).addStock(currentStock, addedAmount);
        int totalIssued = ref.read(totalIssuedProvider(sku.module.id).notifier).state;
        totalIssued += addedAmount;
        ref.read(totalIssuedProvider(sku.module.id).notifier).state = totalIssued;
        ref.read(selectedStockSkuCount(sku).notifier).state += count;
      }
    } catch (e, t) {
      debugPrint("addSpecificAmountOfStock error !!!!!");
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
  }

  ///todo
  removingStock(
      ProductDetailsModel sku, StockModel currentStock, String increasedId,
      {bool stockEditIsOpen = false}) {
    ref.read(isStockSavedProvider.state).state = false;
    // int subtractedAmount = sku.unitConfig[increasedId] as int;
    int subtractedAmount = 1;
    removeSpecificAmountOfStock(sku, currentStock, 1, subtractedAmount,
        stockEditIsOpen: stockEditIsOpen);
  }

  removeSpecificAmountOfStock(ProductDetailsModel sku, StockModel currentStock,
      int count, int subtractedAmount,
      {bool stockEditIsOpen = false}) {
    int soldStock = sku.stocks.liftingStock - sku.stocks.currentStock;
    int stockAfterSubtraction = currentStock.liftingStock - subtractedAmount;
    if (stockAfterSubtraction >= soldStock) {
      if (stockEditIsOpen) {
        ref
            .read(productStockEditProvider(sku).notifier)
            .removeStock(currentStock, subtractedAmount);
        ref.read(selectedStockEditCount(sku).state).state -= count;
      } else {
        ref
            .read(productStockProvider(sku).notifier)
            .removeStock(currentStock, subtractedAmount);
        int totalIssued =
            ref.read(totalIssuedProvider(sku.module.id).state).state;
        totalIssued -= subtractedAmount;
        ref.read(totalIssuedProvider(sku.module.id).state).state = totalIssued;
        ref.read(selectedStockSkuCount(sku).state).state -= count;
      }
    } else {
      String lang = ref.read(languageProvider);
      String desc = "Cannot decrease more than $soldStock";
      String font = englishFont;
      if (lang != 'en') {
        desc =
            "${GlobalWidgets().numberEnglishToBangla(num: soldStock, lang: lang)} এর চেয়ে কম কমানো সম্ভব নয়";
      }
      _alerts.customDialog(
          type: AlertType.warning,
          description: desc,
          fontFamily: lang == 'en' ? englishFont : banglaFont);
    }
  }

  bool isProductExistInStockList(ProductDetailsModel item) {
    List<ProductDetailsModel> stockList = ref.read(stockListProvider);
    for (ProductDetailsModel val in stockList) {
      if (val.id == item.id) {
        return true;
      }
    }
    return false;
  }

  List<ProductDetailsModel> removeProductFromStockList(
      ProductDetailsModel item) {
    List<ProductDetailsModel> stockList = ref.read(stockListProvider);
    for (ProductDetailsModel val in stockList) {
      if (val.id == item.id) {
        stockList.remove(val);
        break;
      }
    }
    return stockList;
  }

  printStock() async {
    try {
      Map<int, List<Map<String, dynamic>>> stocks = {};
      List<Module> moduleList = ref.read(moduleListProvider).value ?? [];
      if (moduleList.isNotEmpty) {
        for (Module module in moduleList) {
          if (!stocks.containsKey(module.id)) {
            stocks[module.id] = [];
          }

          List<ProductDetailsModel> skus =
              await _productCategoryServices.getProductDetailsList(module);

          if (skus.isNotEmpty) {
            for (ProductDetailsModel sku in skus) {
              int liftingStock = getLiftingStockFromCurrentStockData(sku);
              int soldStock = liftingStock - sku.stocks.currentStock;
              int currentStock = liftingStock - soldStock;
              if (liftingStock > 0) {
                stocks[module.id]!.add({
                  "name": sku.shortName,
                  "lifting": liftingStock,
                  "current": currentStock
                });
              }
            }
          }
        }
      }
      // _printerController.printStockMemo(moduleList, stocks);
    } catch (e) {
      print("Inside printStock stocksController catch block $e");
    }
  }

  saveStockEditDialog(ProductDetailsModel sku, int prevLiftingStock) {
    ref.read(isStockSavedProvider.state).state = false;
    int soldStock = sku.stocks.liftingStock - sku.stocks.currentStock;
    StockModel stock = ref.read(productStockEditProvider(sku));
    if (stock.liftingStock >= soldStock) {
      ref.read(productStockProvider(sku).notifier).setStockModel(stock);
      int count = ref.read(selectedStockEditCount(sku));
      ref.read(selectedStockSkuCount(sku).state).state = count;

      int totalIssued =
          ref.read(totalIssuedProvider(sku.module.id).state).state;
      totalIssued += stock.liftingStock;
      ref.read(totalIssuedProvider(sku.module.id).state).state =
          totalIssued - prevLiftingStock;

      Navigator.pop(context);
    } else {
      String lang = ref.read(languageProvider);
      String desc = "Cannot decrease more than $soldStock";
      if (lang != 'en') {
        desc =
            "${GlobalWidgets().numberEnglishToBangla(num: soldStock, lang: lang)} চেয়ে কম কমানো সম্ভব নয়";
      }
      _alerts.customDialog(
          type: AlertType.warning,
          description: desc,
          fontFamily: lang == 'en' ? englishFont : banglaFont);
    }
  }

  // void showRTCVideo() async {
  //   final todayVideo = await _rtcService.getTodayVideo();
  //   final alreadyShowed = _rtcService.todayVideoAlreadyShowed();
  //
  //   if (alreadyShowed) return;
  //   if (todayVideo == null) return;
  //
  //   final pillar = await _rtcService.getPillarByVideo(todayVideo);
  //
  //   if (pillar == null) return;
  //
  //   final language = ref.read(languageProvider);
  //
  //   Alerts(context: context).customDialog(
  //       type: AlertType.warning,
  //       // message: "Last week your Sales Performance is lower than expected. Please watch this tutorial and answer the questions accordingly.",
  //       message: language == 'বাংলা'
  //           ? "গত সপ্তাহে আপনার ${pillar.name} প্রত্যাশার চেয়ে কম। অনুগ্রহ করে এই টিউটোরিয়ালটি দেখুন এবং সেই অনুযায়ী কুইজ দিন।"
  //           : 'According to last week your ${pillar.name} is less than expected. Please watch the tutorial and perform the quiz accordingly.',
  //       onTap1: () async {
  //         Navigator.pop(context);
  //
  //         if (todayVideo.videoUrl == null) {
  //           return;
  //         }
  //
  //         if (todayVideo.videoUrl?.isEmpty == true) {
  //           return;
  //         }
  //
  //         final pathList = todayVideo.videoUrl?.split('/') ?? <String>[];
  //         if (pathList.isNotEmpty) {
  //           await Navigator.pushNamed(
  //             context,
  //             RTCVideoPlayerUI.routeName,
  //             // arguments: {"avModel": video, "file": await AvService(context).getTutorial('sr_av.mp4')},
  //             arguments: {
  //               "avModel": todayVideo,
  //               "file": await AvService(context)
  //                   .getRtcTutorial(pathList[pathList.length - 1])
  //             },
  //           ).then((result) {
  //             if (result.runtimeType == bool && result == true) {
  //               Navigator.pushNamed(context, RTCSurveyUI.routeName,
  //                   arguments: {'video': todayVideo});
  //             }
  //           });
  //         }
  //       });
  // }

  int getIdealStockFromSync(Module module, ProductDetailsModel sku) {
    int idealStock = 0;
    try {
      idealStock = _syncReadService.getIdealStockFromSync(module, sku);
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return idealStock;
  }
// StockModel stockPrev = ref.read(productStockProvider(sku));
// print(sku.stocks.liftingStock);
}
