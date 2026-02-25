import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/screens/sale/service/sales_dashboard_service.dart';
import 'package:wings_olympic_sr/screens/stock_check/ui/stock_check_ui.dart';

import '../../../constants/constant_keys.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../constants/sync_global.dart';
import '../../../main.dart';
import '../../../models/AvModel.dart';
import '../../../models/WomModel.dart';
import '../../../models/brand/brand_model.dart';
import '../../../models/coupon/coupon_model.dart';
import '../../../models/general_id_slug_model.dart';
import '../../../models/location_category_models.dart';
import '../../../models/module.dart';
import '../../../models/outlet_model.dart';
import '../../../models/posm/added_posm_model.dart';
import '../../../models/posm/posm_type_model.dart';
import '../../../models/products_details_model.dart';
import '../../../models/qc_info_model.dart';
import '../../../models/retailers_mdoel.dart';
import '../../../models/returned_data_model.dart';
import '../../../models/sales/formatted_sales_preorder_discount_data_model.dart';
import '../../../models/sales/memo_information_model.dart';
import '../../../models/sales/sale_data_model.dart';
import '../../../models/sales/sales_delivery_response.dart';
import '../../../models/slab_promotion_selection_model.dart';
import '../../../models/sr_info_model.dart';
import '../../../models/trade_promotions/applied_discount_model.dart';
import '../../../models/trade_promotions/promotion_model.dart';
import '../../../models/try_before_buy/try_before_buy_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/input_fields/custome_image_picker_button.dart';
import '../../../reusable_widgets/input_fields/dropdowns.dart';
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/cameraScreen.dart';
import '../../../services/Image_service.dart';
import '../../../services/before_sale_services/av_helper_service.dart';
import '../../../services/before_sale_services/av_service.dart';
import '../../../services/before_sale_services/survey_service.dart';
import '../../../services/before_sale_services/wom_service.dart';
import '../../../services/coupon_service.dart';
import '../../../services/delivery_services.dart';
import '../../../services/ff_services.dart';
import '../../../services/geo_location_service.dart';
import '../../../services/helper.dart';
import '../../../services/outlet_services.dart';
import '../../../services/posm_management_service.dart';
import '../../../services/pre_order_service.dart';
import '../../../services/price_services.dart';
import '../../../services/sync_service.dart';
import '../../../services/wings_geo_data_service.dart';
import '../../../services/product_category_services.dart';
import '../../../services/qps_promotion_services.dart';
import '../../../services/sales_service.dart';
import '../../../services/sync_read_service.dart';
import '../../../services/trade_promotion_services.dart';
import '../../../services/try_before_buy_service.dart';
import '../../../utils/case_piece_type_utils.dart';
import '../../../utils/sales_type_utils.dart';
import '../../aws_stock/model/aws_product_model.dart';
import '../../delivery/ui/delivery_v2_ui.dart';
import '../../outlet_informations/controller/outlet_controller.dart';
import '../../promotions_list/ui/promotion_list_screen.dart';
import '../../stock_check/service/stock_check_service.dart';
import '../../survey/survey_ui.dart';
import '../../video_player.dart';
import '../model/sale_dashboard_category_model.dart';
import '../ui/examine_ui.dart';
import '../ui/kv_ui.dart';
import '../ui/outlet_stock_count.dart';
import '../ui/preview_cooler_image.dart';
import '../ui/sale_v2_widget/show_sku_ui.dart';
import '../ui/sale_v2_widget/show_sku_ui_v2.dart';
import '../ui/wom_ui.dart';

class SaleController {
  final BuildContext context;
  final WidgetRef ref;

  SaleController({required this.context, required this.ref})
      : _alerts = Alerts(context: context),
        _locationService = LocationService(context),
        _outletController = OutletController(context: context, ref: ref);
  final Alerts _alerts;

  final LocationService _locationService;
  final SalesService _salesService = SalesService();
  final ProductCategoryServices _productCategoryServices = ProductCategoryServices();
  final PreOrderService _preOrderService = PreOrderService();
  final DeliveryServices _deliveryServices = DeliveryServices();
  final TradePromotionServices _tradePromotionServices = TradePromotionServices();
  final QPSPromotionServices _qpsPromotionServices = QPSPromotionServices();
  final TryBeforeBuyService _tryBeforeBuyService = TryBeforeBuyService();
  final _syncService = SyncService();
  final _outletServices = OutletServices();
  final OutletController _outletController;
  final salesDashboardService = SalesDashboardService();
  final _stockCheckService = StockCheckService();

  int getPackWiseCount(ProductDetailsModel sku, int count) {
    return count ~/ sku.packSize;
  }

  saveEditedPreorder(ProductDetailsModel sku, int editedSku) async {
    SaleDataModel preorderPrevData = ref.read(saleSkuAmountProvider(sku));
    int prevSku = preorderPrevData.qty;
    await ref.read(saleSkuAmountProvider(sku).notifier).setSalesAmount(editedSku, prevSku);
    Navigator.pop(context);
  }

  addSpecificAmountOfSales(ProductDetailsModel sku, int skuCount, int amount, SaleType saleType) {
    // SkuUnitItem? selectedUnit = ref.watch(selectedSkuUnitConfigProvider(sku));
    // amount = amount == 1 ? sku.packSize : amount;
    // int addedAmount = skuCount * amount;
    //
    // int currentQty = ref.read(saleEditSkuAmountProvider(sku)).qty;
    // int newQty = currentQty + addedAmount;
    SkuUnitItem? selectedUnit = ref.watch(selectedSkuUnitConfigProvider(sku));

    amount = amount == 1 ? sku.packSize : amount;
    int addedAmount = skuCount * amount;

    int currentQty = ref.read(saleEditSkuAmountProvider(sku)).qty;

    final int packSize = selectedUnit?.packSize ?? 1;

    if (packSize > 0) {
      final int targetQty = currentQty + addedAmount;
      final int flooredQty = (targetQty ~/ packSize) * packSize;

      addedAmount = flooredQty - currentQty;
      if (addedAmount < 0) addedAmount = 0;
    }

    int newQty = currentQty + addedAmount;
    if(saleType == SaleType.spotSale) {
      if(newQty > sku.stocks.currentStock) {
        String desc = "It is not possible to take more than the current stock of ${sku.stocks.currentStock}";
        String lang = ref.read(languageProvider);
        if (lang != "en") {
          String count = GlobalWidgets().numberEnglishToBangla(num: sku.stocks.currentStock, lang: lang);
          desc = "বর্তমান স্টক $count - এর চেয়ে বেশি নেওয়া সম্ভব নয়";
        }
        Alerts(context: context).customDialog(message: desc);
      } else {
        ref.read(saleEditSkuAmountProvider(sku).notifier).incrementEdit(addedAmount);
      }
    } else if(saleType == SaleType.preorder) {
      final currentStock = (sku.preOrderStocks?.maxOrderLimit ?? 0) - (sku.preOrderStocks?.liftingStock ?? 0);
      if(sku.preOrderStocks!=null && newQty > currentStock) {
        String desc = "It is not possible to take more than the current point stock of $currentStock";
        String lang = ref.read(languageProvider);
        if (lang != "en") {
          String count = GlobalWidgets().numberEnglishToBangla(num: currentStock, lang: lang);
          desc = "বর্তমান পয়েন্ট স্টক $count - এর চেয়ে বেশি নেওয়া সম্ভব নয়";
        }
        Alerts(context: context).customDialog(message: desc);
      } else {
        ref.read(saleEditSkuAmountProvider(sku).notifier).incrementEdit(addedAmount);
      }
    } else {
      ref.read(saleEditSkuAmountProvider(sku).notifier).incrementEdit(addedAmount);
    }
  }

  bool? bulkInsertOfSales(ProductDetailsModel sku, int amount, SaleType saleType) {
    int addedAmount = amount;

    int newQty = addedAmount;
    if(saleType == SaleType.spotSale) {
      if(newQty > sku.stocks.currentStock) {
        String desc = "It is not possible to take more than the current stock of ${sku.stocks.currentStock}";
        String lang = ref.read(languageProvider);
        if (lang != "en") {
          String count = GlobalWidgets().numberEnglishToBangla(num: sku.stocks.currentStock, lang: lang);
          desc = "বর্তমান স্টক $count - এর চেয়ে বেশি নেওয়া সম্ভব নয়";
        }
        Alerts(context: context).customDialog(message: desc);
      } else {
        ref.read(saleEditSkuAmountProvider(sku).notifier).bulkEdit(addedAmount);
      }
      return false;
    } else if(saleType == SaleType.preorder) {
      final currentStock = (sku.preOrderStocks?.maxOrderLimit ?? 0) - (sku.preOrderStocks?.liftingStock ?? 0);
      if(sku.preOrderStocks!=null && newQty > currentStock) {
        String desc = "It is not possible to take more than the current point stock of $currentStock";
        String lang = ref.read(languageProvider);
        if (lang != "en") {
          String count = GlobalWidgets().numberEnglishToBangla(num: currentStock, lang: lang);
          desc = "বর্তমান পয়েন্ট স্টক $count - এর চেয়ে বেশি নেওয়া সম্ভব নয়";
        }
        Alerts(context: context).customDialog(message: desc);
      } else {
        ref.read(saleEditSkuAmountProvider(sku).notifier).bulkEdit(addedAmount);
      }
      return false;
    } else {
      ref.read(saleEditSkuAmountProvider(sku).notifier).bulkEdit(addedAmount);
    }
  }

  removeSpecificAmountOfSales(ProductDetailsModel sku, int skuCount, int amount) {
    SkuUnitItem? selectedUnit = ref.watch(selectedSkuUnitConfigProvider(sku));
    SaleDataModel preorderEditData = ref.read(saleEditSkuAmountProvider(sku));
    int count = preorderEditData.qty;
    int reminder = (count % (selectedUnit?.packSize??1));
    amount = amount == 1 ? sku.packSize : amount;
    int subtractedAmount = (skuCount * amount)+reminder;
    if (0 <= (count - subtractedAmount) && count != 0) {
      ref.read(saleEditSkuAmountProvider(sku).notifier).decrementEdit(subtractedAmount);
    } else if (count != 0) {
      ref.read(saleEditSkuAmountProvider(sku).notifier).decrementEdit(count);
    } else {
      String lang = ref.read(languageProvider);
      int countInPack = getPackWiseCount(sku, count);
      String desc = 'Can not decrease less than $countInPack';
      if (lang != 'en') {
        String number = GlobalWidgets().numberEnglishToBangla(num: countInPack, lang: lang);
        desc = '$number এর চেয়ে কম কমানো সম্ভব নয়';
      }

      Alerts(context: context).customDialog(
          type: AlertType.warning,
          message: desc,
          fontFamily: lang == 'en' ? englishFont : banglaFont);
    }
  }

  //check if sr is in range of retailer
  Future<void> checkGeoFencing(OutletModel? outlet) async {
    if (outlet != null) {
      ref.read(outletSaleStatusProvider.notifier).state = OutletSaleStatus.checkingGeoFencing;

      bool geoFencing = await _locationService.geoFencing(
        lat: outlet.outletLocation.latitude,
        lng: outlet.outletLocation.longitude,
        allowedDistance: outlet.outletLocation.allowableDistance,
      );
      if (geoFencing == true) {
        ref.read(outletSaleStatusProvider.notifier).state = OutletSaleStatus.callStart;
      } else {
        ref.read(outletSaleStatusProvider.notifier).state = OutletSaleStatus.manualOverride;
      }
    }
  }

  Future<void> manualOverride(OutletModel outlet, int reasonId) async {
    _alerts.floatingLoading(message: 'Please wait for a moment');
    LocationData? position = await LocationService(context).determinePosition(checkLocal: true);
    String timeStamp = apiDateFormat.format(DateTime.now());
    if (position == null) {
      Navigator.pop(context);
    }
    Navigator.pop(context);
    SrInfoModel? sr = await FFServices().getSrInfo();
    Navigator.of(context).pushNamed(CameraScreen.routeName).then((value) async {
      if (value != null) {
        ref.read(coolerImagePathProvider.notifier).state = value.toString();
        Alerts(context: context).showModalWithWidget(
          margin: EdgeInsets.symmetric(vertical: 100, horizontal: 16),
          child: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              String filePath = ref.watch(coolerImagePathProvider);
              File image = File(filePath);
              return PreviewCoolerImage(
                coolerImage: filePath.isEmpty ? File(value.toString()) : image,
                onTryAgainPressed: () {
                  navigatorKey.currentState?.pop();
                  manualOverride(outlet, reasonId);
                },
                onSubmitPressed: () {
                  Navigator.pop(context);
                  ImageService()
                      .compressFile(
                          context: context,
                          file: filePath.isEmpty ? File(value.toString()) : image,
                          name: '${manualOverrideFolder}_${outlet.id}_$timeStamp')
                      .then(
                    (File? compressedImage) async {
                      // ref.read(coolerImagePathProvider.notifier).state =
                      //     value.toString();

                      if (compressedImage != null) {
                        _salesService.sendManualOverrideImageToServer(compressedImage, sr!);
                        _salesService.saveManualOverride(
                          retailerId: outlet.id!,
                          imagePath: compressedImage.path,
                          lat: position != null ? position.latitude : '0.00',
                          long: position != null ? position.longitude : '0.00',
                          timestamp: timeStamp,
                          reasonId: reasonId,
                        );

                        this.ref.read(outletSaleStatusProvider.notifier).state =
                            OutletSaleStatus.callStart;
                      } else {
                        _alerts.customDialog(
                          type: AlertType.error,
                          message: 'Skipped capturing image',
                          description: 'You have to capture retailers image for Manual Override',
                        );
                      }
                    },
                  );
                },
              );
            },
          ),
        );
      } else {
        _alerts.customDialog(
          type: AlertType.error,
          message: 'Skipped capturing image',
          description: 'You have to capture retailers image for Manual Override',
        );
      }
    });
  }

  onTryAgainPressed() {
    Navigator.of(context).pushNamed(CameraScreen.routeName).then((value) async {
      if (value != null) {
        ref.read(coolerImagePathProvider.notifier).state = value.toString();
      } else {
        _alerts.customDialog(
          type: AlertType.error,
          message: 'Skipped capturing image',
          description: 'You have to capture retailers image for Manual Override',
        );
      }
    });
  }

  handleRetailerChange(OutletModel? outlet, {bool fromDelivery = false}) {
    if (outlet != null) {
      ref.read(selectedRetailerProvider.notifier).state = outlet;
      if (fromDelivery) {
        ref.read(outletSaleStatusProvider.notifier).state = OutletSaleStatus.callStart;

        // getAllSlabPromotionForDelivery(outletId: outlet.id);
      } else {
        checkGeoFencing(outlet);
      }
    }

    refreshPreviousSaleData();
  }

  handleAVKVWOMSurveys(OutletModel retailer) async {
    List _list = [];
    _list.add({
      'type': 'av',
      'list': await AvService(context)
          .getAvList(avIdList: retailer.availableAv, retailerId: retailer.id ?? 0)
    });
    _list.add({
      'type': 'wom',
      'list': await WomService(context)
          .getWomList(womIdList: retailer.availableWOM, retailerId: retailer.id ?? 0)
    });
    _list.add({
      'type': 'survey',
      'list': await SurveyService()
          .getSurveyList(surveyIdList: retailer.availableSurvey, retailerId: retailer.id ?? 0)
    });

    for (var i in _list) {
      if (i['type'] == 'av') {
        if (i['list'].isNotEmpty) {
          for (AvModel avModel in i['list']) {
            if (avModel.mandatory == 1) {
              await Navigator.pushNamed(context, VideoPlayerUI.routeName, arguments: {
                "avModel": avModel,
                "file": await AvService(context).getAv(avModel.filename)
              }).then((value) {
                if (value == true) {
                  AvService(context).submitAvData(avModel, retailer.id!);
                }
              });
            }
          }
        }
      }

      if (i['type'] == 'wom') {
        if (i['list'].isNotEmpty) {
          for (WomModel womModel in i['list']) {
            if (womModel.type == WomType.wom) {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (BuildContext context) {
                        return WOMUI(womModel: womModel, retailer: retailer);
                      }));
            } else {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (BuildContext context) {
                        return KVUI(womModel: womModel, retailer: retailer);
                      }));
            }
          }
        }
      }

      if (i['type'] == 'survey') {
        if (i['list'].isNotEmpty) {
          for (var surveyModel in i['list']) {
            await Navigator.pushNamed(context, SurveyUI.routeName, arguments: {
              'retailerId': retailer.id,
              'surveyModel': surveyModel,
              'retailer': retailer
            });
          }
        }
      }
    }

    ref.read(outletSaleStatusProvider.notifier).state = OutletSaleStatus.showSkus;
  }

  handleNavToCoolerPurityScore(OutletModel retailer) async {
    ////
    ref.read(outletSaleStatusProvider.notifier).state = OutletSaleStatus.coolerPurityScore;
  }

  //==============//increment decrement sku//====================
  increment(
    ProductDetailsModel sku, {
    bool edit = false,
    CasePieceType? casePieceType,
        SaleType saleType = SaleType.preorder,
  }) {
    print("MY SALE TYPE IS ::: ${saleType}");
    CasePieceType type = casePieceType ?? ref.read(selectedCasePieceTypeProvider);

    int addedAmount = CasePieceTypeUtils.toSize(type, sku.packSize);

    int currentQty = edit ? ref.read(saleEditSkuAmountProvider(sku)).qty : ref.read(saleSkuAmountProvider(sku)).qty;
    int newQty = currentQty + addedAmount;
    if(saleType == SaleType.spotSale) {
      if(newQty > sku.stocks.currentStock) {
        String desc = "It is not possible to take more than the current stock of ${sku.stocks.currentStock}";
        String lang = ref.read(languageProvider);
        if (lang != "en") {
          String count = GlobalWidgets().numberEnglishToBangla(num: sku.stocks.currentStock, lang: lang);
          desc = "বর্তমান স্টক $count - এর চেয়ে বেশি নেওয়া সম্ভব নয়";
        }
        Alerts(context: context).customDialog(message: desc);
      } else {
        if (edit) {
          ref.read(saleEditSkuAmountProvider(sku).notifier).incrementEdit(addedAmount);
        } else {
          ref.read(saleSkuAmountProvider(sku).notifier).increment(addedAmount);
        }
      }
    } else if(saleType == SaleType.preorder) {
      final currentStock = (sku.preOrderStocks?.maxOrderLimit ?? 0) - (sku.preOrderStocks?.liftingStock ?? 0);
      if(sku.preOrderStocks!=null && newQty > currentStock) {
        String desc = "It is not possible to take more than the point stock of $currentStock";
        String lang = ref.read(languageProvider);
        if (lang != "en") {
          String count = GlobalWidgets().numberEnglishToBangla(num: currentStock, lang: lang);
          desc = "বর্তমান পয়েন্ট স্টক $count - এর চেয়ে বেশি নেওয়া সম্ভব নয়";
        }
        Alerts(context: context).customDialog(message: desc);
      } else {
        if (edit) {
          ref.read(saleEditSkuAmountProvider(sku).notifier).incrementEdit(addedAmount);
        } else {
          ref.read(saleSkuAmountProvider(sku).notifier).increment(addedAmount);
        }
      }
    } else {
      if (edit) {
        ref.read(saleEditSkuAmountProvider(sku).notifier).incrementEdit(addedAmount);
      } else {
        ref.read(saleSkuAmountProvider(sku).notifier).increment(addedAmount);
      }
    }
  }

  decrement(
    ProductDetailsModel sku, {
    bool edit = false,
    CasePieceType? casePieceType,
  }) {
    SaleDataModel currentSaleData =
        edit ? ref.read(saleEditSkuAmountProvider(sku)) : ref.read(saleSkuAmountProvider(sku));
    CasePieceType type = casePieceType ?? ref.read(selectedCasePieceTypeProvider);
    int subtractedAmount = CasePieceTypeUtils.toSize(type, sku.packSize);
    if (currentSaleData.qty - subtractedAmount >= 0) {
      if (edit) {
        ref.read(saleEditSkuAmountProvider(sku).notifier).decrementEdit(subtractedAmount);
      } else {
        ref.read(saleSkuAmountProvider(sku).notifier).decrement(subtractedAmount);
      }
    } else {
      String desc = "Can not decrease less than ${currentSaleData.qty}";
      String lang = ref.read(languageProvider);
      if (lang != "en") {
        String count = GlobalWidgets().numberEnglishToBangla(num: currentSaleData.qty, lang: lang);
        desc = "$count - এর চেয়ে কমানো সম্ভব নয়";
      }
      Alerts(context: context).customDialog(message: desc);
    }
  }

  //=============================================================
  refreshPreviousSaleData() {
    log('refresh beforeSelectedSlabPromotion all --> ');
    ref.refresh(unEnrolledQpsPromotionPerRetailerProvider);
    ref.refresh(beforeSelectedSlabPromotion);
    ref.refresh(beforeSelectedQpsPromotion);
    ref.refresh(totalSoldAmountProvider);
    final retailer = ref.watch(selectedRetailerProvider);
    if (retailer != null) {
      ref.refresh(saleDashboardMenuProvider(retailer));
    }
    currentPreorderData = {};
    currentPromotionData = {};
  }

  List<List<SlabDiscountModel>> slabOffers = [];

  //================== formatting saleData  ========================
  Future<AllKindOfSaleDataModel?> formattingSaleData(
      {required List<Module> module, required OutletModel retailer, required bool saleEdit}) async {
    try {
      Map<int, List<ProductDetailsModel>> preorderData = {};
      Map<int, List<AppliedDiscountModel>> discountData = {};
      //total data
      int totalQty = 0;
      double totalPrice = 0.0;

      int totalCase = 0;
      int totalPiece = 0;

      bool skuSelectedForSale = false;

      for (var i in module) {
        List<ProductDetailsModel> productList =
            await _productCategoryServices.getProductDetailsList(i);
        List<ProductDetailsModel> preorderProductList = [];
        Map<int, SaleDataModel> skuWiseCount = {};
        Map<int, ProductDetailsModel> discountRelatedSkuInformation = {};

        for (var j in productList) {
          discountRelatedSkuInformation[j.id] = j;
          //preorder
          int preorderCount = getSoldSkuAmountFromPreorderData(j);
          if (preorderCount > 0) {
            skuSelectedForSale = true;
            SaleDataModel saleDataModel = SaleDataModel();
            await saleDataModel.saveQty(retailer: retailer, sku: j, quantity: preorderCount);
            totalQty += saleDataModel.qty;
            totalPrice += saleDataModel.price;
            j.savePreorderData(saleDataModel);

            skuWiseCount[j.id] = saleDataModel;

            preorderProductList.add(j);

            int packCount = j.packSize > 1 ? getPackWiseCount(j, saleDataModel.qty) : 0;
            int pieceCount =
                j.packSize > 1 ? saleDataModel.qty - (packCount * j.packSize) : saleDataModel.qty;
            totalCase += packCount;
            totalPiece += pieceCount;
          }
        }

        List<int> selectedBeforePromotions = ref.read(beforeSelectedSlabPromotion);

        //calculate all discounts start
        List<AppliedDiscountModel> discounts =
            await _tradePromotionServices.getAppliedDiscountsForARetailer(
          retailer,
          skuWiseCount,
          discountRelatedSkuInformation,
          preorderProductList,
          selectedBeforePromotions,
        );

        //calculate all discounts end

        preorderData[i.id] = preorderProductList;
        discountData[i.id] = discounts;
      }

      if (skuSelectedForSale) {
        SaleDataModel totalSaleData = SaleDataModel(qty: totalQty, price: totalPrice, discount: 0);
        Map<CasePieceType, int> unitWiseQty = {};
        if (totalCase > 0) {
          unitWiseQty[CasePieceType.CASE] = totalCase;
        }
        if (totalPiece > 0) {
          unitWiseQty[CasePieceType.PIECE] = totalPiece;
        }
        FormattedSalesPreorderDiscountDataModel salesPreorderDiscountDataModel =
            FormattedSalesPreorderDiscountDataModel(
          preorderData: preorderData,
          discountData: discountData,
          totalSaleData: totalSaleData,
          unitWiseTotalQty: unitWiseQty,
        );

        ///slab list
        ///get all slab list for this retailer from sync file
        List<List<SlabDiscountModel>> slabList = getAllSlabList(
          retailerId: retailer.id ?? 0,
          purchaseSkq: salesPreorderDiscountDataModel.preorderData[1],
        );

        ///first of all need to refresh the provider
        ///before add available offer on this provider
        // ref.refresh(selectedSlabPromotion);

        slabOffers = slabList;

        List<int> beforeSelectedSlabPromotionList = ref.read(beforeSelectedSlabPromotion);

        ref.refresh(selectedSlabPromotion);
        for (var val in slabList) {
          for (var v in val) {
            List<SlabPromotionSelectionModel> applicableSlabPromotions = [];
            print('want to try add :: ${v.id} $beforeSelectedSlabPromotionList');
            if (beforeSelectedSlabPromotionList.contains(v.id)) {
              applicableSlabPromotions.add(
                SlabPromotionSelectionModel(slabGroupId: v.slabGroupId ?? 0),
              );
              ref.read(selectedSlabPromotion.notifier).state = applicableSlabPromotions;
            }
          }
        }

        CouponModel? couponModel;
        if (saleEdit == false) {
          Map? couponCode = await CouponService().checkRetailerCouponCode(retailer: retailer);
          if (couponCode != null) {
            couponModel =
                await CouponService().getCouponFromCouponCode(couponCode: couponCode['code']);
            print('coupon model is:: ${couponModel?.code}');

            SaleDataModel discountSaleData = ref.watch(totalDiscountCalculationProvider(
                salesPreorderDiscountDataModel.discountData[module[0].id] ?? []));

            num slabPromotionsDiscount = couponCode['achievedAmount'];
            ref.read(couponDiscountProvider.notifier).state =
                CouponService().getCouponDiscountAmount(
              discountSaleData: discountSaleData,
              slabPromotionsDiscount: slabPromotionsDiscount,
              totalSaleData: salesPreorderDiscountDataModel.totalSaleData,
              coupon: couponModel!,
            );
          }
        }

        AllKindOfSaleDataModel allKindOfSaleDataModel = AllKindOfSaleDataModel(
          retailer: retailer,
          modules: module,
          salesPreorderDiscountDataModel: salesPreorderDiscountDataModel,
          saleEdit: saleEdit,
          slabsList: slabList,
          coupon: couponModel,
        );

        return allKindOfSaleDataModel;
      }
    } catch (e, s) {
      print('inside formattingsaleData function of sales_controller error: $e $s');
    }
  }

  int getSoldSkuAmountFromPreorderData(ProductDetailsModel sku) {
    int currentPreorder = 0;
    try {
      if (currentPreorderData.containsKey(sku.module.id)) {
        if (currentPreorderData[sku.module.id].containsKey(sku.id)) {
          currentPreorder = currentPreorderData[sku.module.id][sku.id];
        }
      }
    } catch (e) {
      print("inside getSoldSkuAmountFromPreorderData catch block $e");
    }
    return currentPreorder;
  }

  sendToExaminPage(AllKindOfSaleDataModel allKindOfSaleDataModel) async {
    Navigator.pushNamed(context, ExamineUI.routeName, arguments: {
      "allKindOfSaleDataModel": allKindOfSaleDataModel,
    });
  }

  onPrint(
    AllKindOfSaleDataModel allKindOfSaleDataModel,
    num? couponDiscountAmount,
  ) {
    try {
      _alerts.customDialog(
        message: 'Are you sure?',
        description: 'This sale will be saved',
        twoButtons: true,
        onTap1: () async {
          bool validate = validateForSlabPromotion();
          if (!validate) {
            Navigator.of(context).pop();
            _alerts.customDialog(
              message: 'ERROR',
              description: 'You must select one offer from all offer groups',
              type: AlertType.error,
              onTap1: () async {
                Navigator.of(context).pop();
              },
            );
          } else {
            Navigator.of(context).pop();
            startSubmittingSales(allKindOfSaleDataModel, couponDiscountAmount);
          }
        },
        onTap2: () {
          Navigator.pop(context);
        },
      );
    } catch (e) {
      print("inside onPrint SalesController catch block $e");
    }
  }

  startSubmittingSales(
    AllKindOfSaleDataModel allKindOfSaleDataModel,
    num? couponDiscountAmount,
  ) async {
    //  [bool fromCreditSales = false],
    _alerts.floatingLoading();
    SalesDeliveryResponse success = await submitSales(allKindOfSaleDataModel, couponDiscountAmount);
    if (success.status) {
      // print(syncObj[scratchCardKey]);
      Navigator.pop(context);

      _alerts.customDialog(
          type: AlertType.success,
          description: "Sale Saved Successfully",
          onTap1: () {
            Navigator.of(context).pop();
            refreshPreviousSaleData();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            if (allKindOfSaleDataModel.saleEdit) {
              Navigator.of(context).pop();
            }
          });
    } else {
      Navigator.pop(context);
      if (success.message.isNotEmpty) {
        String lang = ref.watch(languageProvider);
        String messageStart = "Stock not available for SKU:";
        if (lang != "en") {
          messageStart = "এই SKU এর/গুলোর পর্যাপ্ত স্টক নেই:";
        }
        _alerts.customDialog(
            type: AlertType.error,
            description: allKindOfSaleDataModel.saleType == SaleType.delivery
                ? success.message.replaceAll("Stock not available for sku:", messageStart)
                : "Sale Saved Failed",
            onTap1: () {
              Navigator.of(context).pop();
              refreshPreviousSaleData();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              if (allKindOfSaleDataModel.saleEdit) {
                Navigator.of(context).pop();
              }
            });
      }
    }

    for (Module module in allKindOfSaleDataModel.modules) {
      ref.refresh(dashboardTargetList(module.id));
    }

    ref.refresh(outletListProvider(true));
    // ref.refresh(selectedRetailerProvider);
    ref.refresh(visibleCoupon);
    ref.refresh(couponDiscountProvider);
    ref.refresh(outletListProviderWithoutDropdown);
    ref.refresh(unsoldOutlets);
    ref.refresh(allOutletLastGeoProvider(true));
    ref.refresh(allOutletLastGeoProvider(false));
    ref.refresh(memoOutletListProvider(true));
    ref.refresh(userDataProvider);
    ref.refresh(orderedOutletListProvider(SaleType.preorder));
    ref.refresh(orderedOutletListProvider(SaleType.spotSale));
    ref.refresh(dashBoardSaleTypeProvider);
    // ref.read(dashBoardSaleTypeProvider.notifier).state = SaleType.spotSale;
  }

  //changeQc In ExamineUI
  saveToFinalQcInfo(List<SelectedQCInfoModel> qcList) {
    try {
      if (qcList.isNotEmpty) {
        Map<int, List<SelectedQCInfoModel>> qcByModule = {};
        for (SelectedQCInfoModel qc in qcList) {
          if (!qcByModule.containsKey(qc.sku.module.id)) {
            qcByModule[qc.sku.module.id] = [];
          }
          qcByModule[qc.sku.module.id]!.add(qc);
        }
        if (qcByModule.isNotEmpty) {
          ref.read(finalQcInfoListProvider.state).state = qcByModule;
        }
      }
    } catch (e) {
      print("inside saveToFinalQcInfo salesController catch block $e");
    }
  }

  /*=====================Save QC ========================*/

  Future<Map> checkQCForARetailer() async {
    Map qcInfoMap = {};
    try {
      Map<int, List<SelectedQCInfoModel>> qcByModule = ref.read(finalQcInfoListProvider);
      if (qcByModule.isNotEmpty) {
        qcByModule.forEach((moduleId, selectedQcInfos) async {
          if (selectedQcInfos.isNotEmpty) {
            for (SelectedQCInfoModel selectedQcinfo in selectedQcInfos) {
              if (selectedQcinfo.qcInfoList.isNotEmpty) {
                for (QCInfoModel qcInfo in selectedQcinfo.qcInfoList) {
                  if (qcInfo.types.isNotEmpty) {
                    for (QCTypesModel qcType in qcInfo.types) {
                      if (!qcInfoMap.containsKey(moduleId.toString())) {
                        qcInfoMap[moduleId.toString()] = {};
                      }

                      if (!qcInfoMap[moduleId.toString()]
                          .containsKey(selectedQcinfo.sku.id.toString())) {
                        qcInfoMap[moduleId.toString()][selectedQcinfo.sku.id.toString()] = [];
                      }

                      if (qcType.quantity > 0) {
                        num price = 0;
                        if (qcInfo.saleableReturn != 1) {
                          price = await PriceServices().getQcSkuPriceForASpecificAmount(
                              selectedQcinfo.sku, selectedQcinfo.retailer, qcType.quantity);
                        }

                        Map qcMapToStoreInSync = {
                          faultIdKey: qcType.id,
                          qcVolumeKey: qcType.quantity,
                          qcUnitPriceKey: price / qcType.quantity,
                          qcTotalValueKey: price,
                          qcEntryTypeKey: 1,
                          qcTypeKey: 1,
                          qcStatusKey: 1
                        };

                        await qcInfoMap[moduleId.toString()][selectedQcinfo.sku.id.toString()]
                            .add(qcMapToStoreInSync);
                      }
                    }
                  }
                }
              }
            }
          }
        });
      }
    } catch (e) {
      print("inside checkQCForARetailer salesController catch block $e");
    }

    return qcInfoMap;
  }

  Future<SalesDeliveryResponse> submitSales(
    AllKindOfSaleDataModel allKindOfSaleDataModel,
    num? couponDiscountAmount,
  ) async {
    try {
      //initialize sale status
      SaleStatus saleStatus =
          allKindOfSaleDataModel.saleEdit ? SaleStatus.editedSale : SaleStatus.newSale;

      if (allKindOfSaleDataModel.modules.isNotEmpty) {
        //check preorder data
        Map qcData = await checkQCForARetailer();

        ///TODO: spot sale
        Map preorderData = await checkPreorderForARetailer(
          allKindOfSaleDataModel.salesPreorderDiscountDataModel.preorderData,
          saleStatus,
          allKindOfSaleDataModel.retailer.id ?? 0,
          allKindOfSaleDataModel.saleType,
        );
        Map geoData = allKindOfSaleDataModel.saleType == SaleType.preorder
            ? await WingsGeoDataService()
                .createGeoDataMap(retailer: allKindOfSaleDataModel.retailer, context: context)
            : {};
        await Future.delayed(const Duration(milliseconds: 10));

        String? saleEditReason = ref.read(selectedReasonsProvider);

        List<AppliedDiscountModel> totalDiscounts = getAllAppliedDiscountForASale(
            allKindOfSaleDataModel.salesPreorderDiscountDataModel.discountData);

        List<SlabPromotionSelectionModel> slabPromotions = [];

        List<int> slabPromotionsNew = ref.watch(beforeSelectedSlabPromotion);

        List<int> sListId = [];

        for (List<SlabDiscountModel> val in allKindOfSaleDataModel.slabsList ?? []) {
          for (SlabDiscountModel v in val) {
            sListId.add(v.id ?? 0);
          }
        }

        if (slabPromotionsNew.isNotEmpty) {
          for (var val in slabPromotionsNew) {
            if (syncObj.containsKey('promotions')) {
              if (syncObj['promotions'].containsKey('$val')) {
                if (sListId.contains(val)) {
                  Map promotion = syncObj['promotions']['$val'];
                  slabPromotions.add(SlabPromotionSelectionModel(
                      slabGroupId: promotion['slab_group_id'],
                      discountAmount: promotion['discount_amount'],
                      selectedPromotion: val));
                }
              }
            }
          }
        }

        ReturnedDataModel? saved = await _salesService.saveAllDataForARetailer(
          retailer: allKindOfSaleDataModel.retailer,
          preorderData: preorderData,
          geoData: geoData,
          saleStatus: saleStatus,
          qcInfo: qcData,
          appliedDiscounts: totalDiscounts,
          reason: saleEditReason,
          saleType: allKindOfSaleDataModel.saleType,
          slabPromotions: slabPromotions,
          coupon: allKindOfSaleDataModel.coupon,
          selectedSkuWithCount: allKindOfSaleDataModel.salesPreorderDiscountDataModel.preorderData,
          couponDiscountAmount: couponDiscountAmount,
        );

        if (saved != null &&
            saved.status != ReturnedStatus.success &&
            allKindOfSaleDataModel.saleType == SaleType.delivery) {
          return SalesDeliveryResponse(status: false, message: saved.errorMessage ?? "");
        }
        return SalesDeliveryResponse(status: true, message: '');
      }
    } catch (e, s) {
      print("inside submitSales SalesController catch block $e $s");
    }
    return SalesDeliveryResponse(status: false, message: '');
  }

  List<AppliedDiscountModel> getAllAppliedDiscountForASale(
      Map<int, List<AppliedDiscountModel>> discounts) {
    List<AppliedDiscountModel> totalDiscounts = [];
    try {
      if (discounts.isNotEmpty) {
        List<AppliedDiscountModel> dependentDiscount = ref.read(selectedDependentDiscountsProvider);
        for (MapEntry discountEntry in discounts.entries) {
          if (discountEntry.value.isNotEmpty) {
            for (AppliedDiscountModel discount in discountEntry.value) {
              if (!discount.promotion.isDependent) {
                totalDiscounts.add(discount);
              }
            }
          }
        }
        if (dependentDiscount.isNotEmpty) {
          totalDiscounts.addAll(dependentDiscount);
        }
      }
    } catch (e) {
      Helper.dPrint("inside getAllAppiedDiscountForASale SaleController catch block $e");
    }
    return totalDiscounts;
  }

  /*====================save preorder======================*/
  Future<Map> checkPreorderForARetailer(Map<int, List<ProductDetailsModel>> preorderSkusByModule,
      SaleStatus saleStatus, int retailerId, SaleType saleType) async {
    Map preorderMap = {};
    try {
      if (preorderSkusByModule.isNotEmpty) {
        preorderSkusByModule.forEach((moduleId, preorderSkus) {
          if (preorderSkus.isNotEmpty) {
            preorderSkus.forEach((sku) {
              if (sku.preorderData != null) {
                if (!preorderMap.containsKey(moduleId.toString())) {
                  preorderMap[moduleId.toString()] = {};
                }
                int qty = sku.preorderData!.qty;
                num price = sku.preorderData!.price;
                try {
                  if (saleStatus != SaleStatus.editedSale && (saleType == SaleType.preorder || saleType == SaleType.spotSale)) {
                    Map previousPreorderData = _preOrderService.getPreorderForRetailerModuleAndSku(
                        retailerId, moduleId, sku.id, saleType);
                    if (previousPreorderData.isNotEmpty) {
                      qty += int.parse(previousPreorderData[preorderSttKey].toString());
                      price += previousPreorderData[preorderPriceKey];
                    }
                  }
                } catch (e) {
                  print("add previous preorder in repeat memo $e");
                }

                preorderMap[moduleId.toString()][sku.id.toString()] = {
                  preorderSttKey: qty,
                  preorderPriceKey: price,
                  preorderSalesDateKey: sku.preorderData!.salesDate,
                  preorderSalesDateTimeKey: sku.preorderData!.salesDateTime,
                };
              }
            });
          }

          //get previous preorder in repeat memo
          if (saleStatus != SaleStatus.editedSale && (saleType == SaleType.preorder || saleType == SaleType.spotSale)) {
            Map previousPreorderData =
                _preOrderService.getPreorderForARetailerAndModule(retailerId, moduleId, saleType);
            if (previousPreorderData.isNotEmpty) {
              for (MapEntry previousPreorderMapEntry in previousPreorderData.entries) {
                if (!preorderMap.containsKey(moduleId.toString())) {
                  preorderMap[moduleId.toString()] = {};
                }

                if (!preorderMap[moduleId.toString()].containsKey(previousPreorderMapEntry.key)) {
                  preorderMap[moduleId.toString()][previousPreorderMapEntry.key] =
                      previousPreorderMapEntry.value;
                }
              }
            }
          }
        });
      }
    } catch (e) {
      print("inside checkPreorderForARetailer salesController catch block $e");
    }

    return preorderMap;
  }

  //===================== Zero Sale =============================
  handleZeroSale(OutletModel retailer) async {
    try {
      bool zeroSaleEnabled = await _deliveryServices.checkIfZeroSaleEnabled();
      if (zeroSaleEnabled) {
        _alerts.customDialog(
            type: AlertType.warning,
            message: "No SKU selected for sale",
            description: "Do you want to cancel Pre-Order?",
            twoButtons: true,
            onTap1: () {
              Navigator.of(context).pop();
              _deliveryServices.doZeroSale(retailer);
              _alerts.customDialog(
                  type: AlertType.success,
                  description: "Preorder canceled successfully",
                  onTap1: () {
                    refreshPreviousSaleData();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  });
            });
      } else {
        _alerts.customDialog(type: AlertType.warning, message: "No SKU selected for sale");
      }
    } catch (e) {
      print("inside handleZeroSale SalesController catch block $e");
    }
  }

  handlePreorderCallStart(OutletModel outlet) async {
    bool coolerImageConfigured = await _preOrderService.checkIfCoolerImageNeedsToBeCaptured();
    bool coolerImageNeeded = OutletServices.showCoolerIcon(outlet);
    if (coolerImageNeeded && coolerImageConfigured) {
      ref.read(outletSaleStatusProvider.notifier).state = OutletSaleStatus.captureCoolerImage;
    } else {
      ref.read(outletSaleStatusProvider.notifier).state = OutletSaleStatus.showSkus;
      // handleAVKVWOMSurveys(outlet);
    }
  }

  captureCoolerImageBeforePreorder(OutletModel outlet) {
    String timeStamp = apiDateFormat.format(DateTime.now());
    Navigator.of(context).pushNamed(CameraScreen.routeName).then((value) async {
      if (value != null) {
        ref.read(coolerImagePathProvider.notifier).state = value.toString();
        Alerts(context: context).showModalWithWidget(child: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            String filePath = ref.read(coolerImagePathProvider);
            File image = File(filePath);
            return PreviewCoolerImage(
                coolerImage: filePath.isEmpty ? File(value.toString()) : image,
                onTryAgainPressed: onTryAgainPressed,
                onSubmitPressed: () {
                  Navigator.pop(context);
                  ImageService()
                      .compressFile(
                          context: context,
                          file: File(value.toString()),
                          name: '${coolerImageFolder}_${outlet.id}_$timeStamp')
                      .then((File? compressedImage) async {
                    if (compressedImage != null) {
                      this.ref.read(coolerImagePathProvider.notifier).state = compressedImage.path;
                      _salesService.sendCoolerImageToServer(compressedImage);
                      _salesService.saveCoolerImage(
                        outlet.id!,
                        compressedImage.path,
                      );
                      // handleAVKVWOMSurveys(outlet);
                      handleNavToCoolerPurityScore(outlet);
                    } else {
                      _alerts.customDialog(
                        type: AlertType.error,
                        message: 'Skipped capturing image',
                        description: 'You have to capture cooler image before taking preorder',
                      );
                    }
                  });
                });
          },
        ));
      } else {
        _alerts.customDialog(
          type: AlertType.error,
          message: 'Skipped capturing image',
          description: 'You have to capture retailers image for Manual Override',
        );
      }
    });
  }

  submitCoolerPurityScore(OutletModel outlet, String score) {
    ///save score
    _salesService.saveCoolerPurityScore(
      outlet.id!,
      score,
    );
    // handleAVKVWOMSurveys(outlet);
    ref.read(outletSaleStatusProvider.notifier).state = OutletSaleStatus.showSkus;
  }

  onNoButtonPressedUnsoldRetailer() async {
    OutletModel? outlet = ref.read(selectedRetailerProvider);
    if (outlet != null) {
      bool buttonListExists = await _salesService.checkUnsoldInfoExist();
      if (!buttonListExists) {
        ref.read(outletSaleStatusProvider.notifier).state = OutletSaleStatus.onUnsoldOutletPressed;
      } else {
        navigatorKey.currentState?.pop();
      }
    }
  }

  onUnsoldButtonPressed(GeneralIdSlugModel unsoldData) async {
    DateTime time = DateTime.now();
    String timeStamp = apiDateFormat.format(time);

    SrInfoModel? sr = await FFServices().getSrInfo();
    OutletModel? outlet = ref.read(selectedRetailerProvider);
    if (outlet == null) {
      navigatorKey.currentState?.pop();
      return;
    }
    Navigator.of(context).pushNamed(CameraScreen.routeName).then((value) async {
      if (value != null) {
        ref.read(coolerImagePathProvider.notifier).state = value.toString();
        Alerts(context: context).showModalWithWidget(child: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            String filePath = ref.read(coolerImagePathProvider);
            File image = File(filePath);
            return PreviewCoolerImage(
                coolerImage: filePath.isEmpty ? File(value.toString()) : image,
                onTryAgainPressed: onTryAgainPressed,
                onSubmitPressed: () {
                  Navigator.pop(context);
                  ImageService()
                      .compressFile(
                          context: context,
                          file: filePath.isEmpty ? File(value.toString()) : image,
                          name: '${unsoldOutletFolder}_${outlet.id}_$timeStamp')
                      .then((File? compressedImage) async {
                    if (compressedImage != null) {
                      _alerts.floatingLoading();
                      _salesService.sendUnsoldOutletImageToServer(compressedImage, sr!);
                      Map geoData = await WingsGeoDataService()
                          .createGeoDataMap(retailer: outlet, context: context);

                      await _salesService.saveUnsoldOutletData(sr, outlet, time, unsoldData,
                          '${unsoldOutletFolder}_${outlet.id}_$timeStamp.jpg', geoData);
                      navigatorKey.currentState?.pop();
                      navigatorKey.currentState?.pop();
                    } else {
                      _alerts.customDialog(
                        type: AlertType.error,
                        message: 'Skipped capturing image',
                        description: 'You have to capture retailers image for Manual Override',
                      );
                    }
                  });
                });
          },
        ));
      } else {
        _alerts.customDialog(
          type: AlertType.error,
          message: 'Skipped capturing image',
          description: 'You have to capture retailers image for Manual Override',
        );
      }
    });
  }

  ///find all slab offer
  List<List<SlabDiscountModel>> getAllSlabList({
    required int retailerId,
    List<ProductDetailsModel>? purchaseSkq,
    bool preOrder = true,
  }) {
    List<List<SlabDiscountModel>> slabList = [];

    try {
      int retailerIndex = 0;
      int count = 0;

      for (var val in syncObj['retailers']) {
        if (val['id'].toString() == retailerId.toString()) {
          retailerIndex = count;
          break;
        }
        count++;
      }

      List<int> beforeSelectedSlabPromotionList = ref.read(beforeSelectedSlabPromotion);
      log('beforeSelectedSlabPromotionList $beforeSelectedSlabPromotionList');

      for (int a = 0; a != slabList.length; a++) {
        for (SlabDiscountModel v in slabList[a]) {
          print('slab---------> ${slabList.length} ${v.id} $beforeSelectedSlabPromotionList');
        }
      }

      for (var val in syncObj['retailers'][retailerIndex]['available_promotions']) {
        if (syncObj['promotions']['${val['id']}'] != null) {
          if (syncObj['promotions']['${val['id']}']['discount_type'] != null &&
              syncObj['promotions']['${val['id']}']['discount_type'] == 'Multi Buy') {
            SlabDiscountModel model =
                SlabDiscountModel.fromJson(syncObj['promotions'][val['id'].toString()]);

            if (beforeSelectedSlabPromotionList.contains(model.id) || preOrder == false) {
              if (validateForSlabDiscount(slab: model, purchaseSkq: purchaseSkq!)) {
                if (slabList.isNotEmpty) {
                  if (slabList[slabList.length - 1][0].slabGroupId == model.slabGroupId) {
                    slabList[slabList.length - 1].add(model);
                  } else {
                    if (beforeSelectedSlabPromotionList.contains(model.id) && preOrder == true) {
                      slabList.add([model]);
                    } else if (preOrder == false) {
                      slabList.add([model]);
                    }
                  }
                } else {
                  if (beforeSelectedSlabPromotionList.contains(model.id) && preOrder == true) {
                    slabList.add([model]);
                  } else if (preOrder == false) {
                    slabList.add([model]);
                  }
                }
              }
            }
          }
        }
      }
      print('--------------------------------------------------');

      for (int a = 0; a != slabList.length; a++) {
        for (SlabDiscountModel v in slabList[a]) {
          print('slab---------> ${slabList.length} ${v.id} $beforeSelectedSlabPromotionList');
        }
      }

      return slabList;
    } catch (e, t) {
      print(e.toString());
      print(t.toString());
      return slabList;
    }
  }

  ///we cal validate is the slab valid for our purchased sku list
  bool validateForSlabDiscount({
    required SlabDiscountModel slab,
    required List<ProductDetailsModel> purchaseSkq,
  }) {
    List<bool> validateList = [];
    int minimumReruiredUniqueSku = 0;
    int totalCasePurchase = 0;
    List<int?> slabSkuList = [];

    ///check the rules
    if (slab.rules?.isNotEmpty ?? false) {
      slabSkuList = slab.skus?.map((e) => e.skuId).toList() ?? []; //main slab sku
      List<int> purchaseSkuList = purchaseSkq.map((e) => e.id).toList(); //main slab sku
      minimumReruiredUniqueSku = slab.totalApplicableQuantity ?? 0;

      List<int> checkedItem = [];

      slab.rules?.map((e) => validateList.add(false)).toList();
      for (int rule = 0; rule != (slab.rules ?? []).length; rule++) {
        if (slab.rules?[rule].skuId == '%') {
          for (int purchaseSku = 0; purchaseSku != purchaseSkuList.length; purchaseSku++) {
            if (slabSkuList.contains(purchaseSkuList[purchaseSku]) &&
                !checkedItem.contains(purchaseSkuList[purchaseSku])) {
              if ((purchaseSkq[purchaseSku].preorderData?.qty ?? 0) ~/
                      purchaseSkq[purchaseSku].packSizeCases >=
                  1) {
                checkedItem.add(purchaseSkuList[purchaseSku]);
                validateList[rule] = true;
                break;
              }
              // else {
              //   checkedItem.add(purchaseSkuList[b]);
              //   validateList[a] = false;
              //   break;
              // }
            }
          }
        } else {
          int rulesSkuId = int.tryParse(slab.rules?[rule].skuId ?? '0') ?? 0;
          if (purchaseSkuList.contains(rulesSkuId) && !checkedItem.contains(rulesSkuId)) {
            int index = purchaseSkuList.indexWhere((element) => element == rulesSkuId);

            ///this segment checked with real data
            if ((purchaseSkq[index].preorderData?.qty ?? 0) ~/ purchaseSkq[index].packSizeCases >=
                1) {
              checkedItem.add(rulesSkuId);
              validateList[rule] = true;
              // break; ///this [break;] destroy my 3 hours
            }
          }
        }
      }
    }

    for (var v in purchaseSkq) {
      if (slabSkuList.contains(v.id)) {
        var sku = purchaseSkq.firstWhere((element) => element.id == v.id);
        // print('is sku purchase is one case ${(sku.preorderData?.qty ?? 0) ~/ sku.packSizeCases} :::::: ${((sku.preorderData?.qty ?? 0) / (sku.packSize)).floor()}');
        if (sku.packSizeCases > sku.packSize) {
          ///pcs config
          totalCasePurchase += ((sku.preorderData?.qty ?? 0) / (sku.packSizeCases)).floor();
        } else if (sku.packSizeCases == sku.packSize && sku.packSize >= 1) {
          ///case config
          totalCasePurchase += (sku.preorderData?.qty ?? 0) ~/ sku.packSizeCases;
        }

        ///this was only
        // totalCasePurchase += ((purchaseSkq.firstWhere((element) => element.id == v.id).preorderData?.qty ?? 0) / (purchaseSkq.firstWhere((element) => element.id == v.id).packSize)).floor();
      }
    }

    // print('-------------> $minimumUniqueSku ::: $totalCasePurchase <---------------------');
    if (validateList.where((element) => element == true).length == validateList.length &&
        totalCasePurchase >= minimumReruiredUniqueSku) {
      return true;
    }

    return false;
  }

  // void selectSlabPromotion({
  //   required int slabGroupId,
  //   required int promotionId,
  // }) async {
  //   List<SlabPromotionSelectionModel> slabPromotions = ref.watch(selectedSlabPromotion);
  //   int ind = slabPromotions.indexWhere((element) => element.slabGroupId == slabGroupId);
  //   slabPromotions[ind].selectedPromotion = promotionId;
  //
  //   num totalDiscount = 0;
  //
  //   for (var val in slabPromotions) {
  //     if (val.selectedPromotion != null) {
  //       slabPromotions[ind].discountAmount = syncObj['promotions'][val.selectedPromotion.toString()]['discount_amount'];
  //       totalDiscount += syncObj['promotions'][val.selectedPromotion.toString()]['discount_amount'];
  //     }
  //   }
  //
  //   ref.refresh(selectedSlabPromotion);
  //   print('refresh selected slab promotion 2');
  //   ref.refresh(slabPromotionDiscount);
  //   ref.read(selectedSlabPromotion.notifier).state = slabPromotions;
  //   await Future.delayed(const Duration(milliseconds: 30));
  //   ref.read(slabPromotionDiscount.notifier).state = totalDiscount;
  // }

  void selectSlabPromotionNew({
    required List<List<SlabDiscountModel>> slabs,
  }) async {
    num totalDiscount = 0;

    for (var val in slabs) {
      for (var v in val) {
        totalDiscount += v.discountAmount ?? 0;
      }
    }

    print('refresh selected slab promotion 3');
    ref.refresh(slabPromotionDiscount);
    await Future.delayed(Duration.zero);
    ref.read(slabPromotionDiscount.notifier).state = totalDiscount;
    num dis = ref.read(slabPromotionDiscount);
    print('total discount is:::: ${dis}');
  }

  ///check is this retailer already have a preorder or not
  bool checkAlreadyHavePreOrderAndPromotion({
    required int retailerId,
    required String promotionId,
  }) {
    try {
      print('retailer id is:::: ${retailerId}');
      bool alreadyHave = false;
      alreadyHave = syncObj.containsKey('promotion-data');
      if (alreadyHave) {
        alreadyHave = syncObj['promotion-data'].containsKey('$retailerId');
        if (alreadyHave) {
          alreadyHave = syncObj['promotion-data']['$retailerId'].containsKey(promotionId);
        }
      }
      return alreadyHave;
    } catch (e, t) {
      print(e.toString());
      print(t.toString());
      return false;
    }
  }

  bool validateForSlabPromotion() {
    List<SlabPromotionSelectionModel> slabPromotions = ref.read(selectedSlabPromotion);

    print('all slab promotions is ::: ${slabPromotions.length}');

    List<int> uniqueSlab = [];
    List<bool> uniqueSlabSelected = [];

    for (var val in slabPromotions) {
      if (!uniqueSlab.contains(val.slabGroupId)) {
        uniqueSlab.add(val.slabGroupId);
        uniqueSlabSelected.add(false);
      }
    }

    for (int a = 0; a != uniqueSlab.length; a++) {
      List<SlabPromotionSelectionModel> thisSlabs = [];
      thisSlabs = slabPromotions.where((element) => element.slabGroupId == uniqueSlab[a]).toList();

      for (var v in thisSlabs) {
        if (v.selectedPromotion != null) {
          uniqueSlabSelected[a] = true;
          break;
        }
      }
    }

    List<bool> finalSelectedList = uniqueSlabSelected.where((element) => element == true).toList();

    return finalSelectedList.length == uniqueSlabSelected.length;
  }

  ///before select special offer
  ///from special offer dialogue
  void selectBeforeSpecialOffer({
    required PromotionModel promotion,
    required List<PromotionModel> promotions,
  }) {
    try {
      List<int> selectedPromotions = ref.read(beforeSelectedSlabPromotion);

      if (selectedPromotions.contains(promotion.id)) {
        selectedPromotions.removeWhere((element) => element == promotion.id);
      } else {
        if (promotion.slabGroupId == null) {
          selectedPromotions.add(promotion.id);
        } else {
          List<int> promotionInThisSlab = promotions
              .where((element) => element.slabGroupId == promotion.slabGroupId)
              .toList()
              .map((e) => e.id)
              .toList();
          bool exist = false;
          int existId = 0;
          for (var val in promotionInThisSlab) {
            if (selectedPromotions.contains(val)) {
              exist = true;
              existId = val;
              break;
            }
          }
          if (exist) {
            selectedPromotions.removeWhere((element) => element == existId);
          }
          selectedPromotions.add(promotion.id);
        }
      }

      print('---->>>>>> $selectedPromotions');

      ref.refresh(beforeSelectedSlabPromotion);
      ref.read(beforeSelectedSlabPromotion.notifier).state = selectedPromotions;
    } catch (e, t) {
      print(e.toString());
      print(t.toString());
    }
  }

  ///before select QPS offer
  ///from QPS offer dialogue
  void selectBeforeQPSOffer({
    required PromotionModel promotion,
    required List<PromotionModel> promotions,
  }) {
    try {
      List<int> selectedPromotions = ref.watch(beforeSelectedQpsPromotion);

      if (selectedPromotions.contains(promotion.id)) {
        selectedPromotions.removeWhere((element) => element == promotion.id);
      } else {
        if (promotion.slabGroupId == null) {
          selectedPromotions.add(promotion.id);
        } else {
          List<int> promotionInThisSlab = promotions
              .where((element) => element.slabGroupId == promotion.slabGroupId)
              .toList()
              .map((e) => e.id)
              .toList();
          bool exist = false;
          int existId = 0;
          for (var val in promotionInThisSlab) {
            if (selectedPromotions.contains(val)) {
              exist = true;
              existId = val;
              break;
            }
          }
          if (exist) {
            selectedPromotions.removeWhere((element) => element == existId);
          }
          selectedPromotions.add(promotion.id);
        }
      }

      // ref.refresh(beforeSelectedQpsPromotion);
      ref.read(beforeSelectedQpsPromotion.notifier).state = [...selectedPromotions];
    } catch (e, t) {
      print(e.toString());
      print(t.toString());
    }
  }

  ///check and do all operation with before selected offers
  Future<bool> checkBeforeSelectedOffers() async {
    try {
      List<int> selectedBeforePromotions = ref.read(beforeSelectedSlabPromotion);
      List<bool> promotionValidate = [];
      for (var v in selectedBeforePromotions) {
        promotionValidate.add(false);
      }

      for (int a = 0; a != slabOffers.length; a++) {
        for (var v in slabOffers[a]) {
          if (selectedBeforePromotions.contains(v.id)) {
            promotionValidate[a] = true;
            break;
          }
        }
      }

      if (promotionValidate.contains(false)) {
        return false;
      }
      return true;
    } catch (e, t) {
      print(e.toString());
      print(t.toString());
      return false;
    }
  }

  Future<bool> checkBeforeSelectedOffers2(
      FormattedSalesPreorderDiscountDataModel salesPreorderDiscountDataModel) async {
    try {
      List<int> selectedBeforePromotions = ref.read(beforeSelectedSlabPromotion);
      List<bool> promotionValidate = [];

      List<PromotionModel> list = [];

      salesPreorderDiscountDataModel.discountData.forEach((key, value) {
        for (var v in value) {
          list.add(v.promotion);
        }
      });

      List<int> allPromotionsIdList = list.map((e) => e.id).toList();

      for (var v in selectedBeforePromotions) {
        promotionValidate.add(false);
      }

      for (int a = 0; a != selectedBeforePromotions.length; a++) {
        if (allPromotionsIdList.contains(selectedBeforePromotions[a])) {
          promotionValidate[a] = true;
        }
      }

      if (promotionValidate.contains(false)) {
        return false;
      }
      return true;
    } catch (e, t) {
      print(e.toString());
      print(t.toString());
      return false;
    }
  }

  void selectBeforeSpecialOfferNew({
    required int retailerId,
    List<ProductDetailsModel>? skus,
  }) async {
    // Module? selectedModule = ref.watch(selectedSalesModuleProvider);
    // AsyncValue<List<ProductDetailsModel>> asyncSkus = ref.watch(deliveryListFutureProvider(selectedModule!));

    List<List<SlabDiscountModel>> slabList =
        getAllSlabList(retailerId: retailerId, purchaseSkq: skus!, preOrder: false);

    List<int> beforeSelectedSlabPromotionList = ref.read(beforeSelectedSlabPromotion);

    slabOffers = slabList;

    ///todo ----------> pcs configuration
    ///this loop looks for eligible slab promotions for selected SKUS/Products
    for (var val in slabList) {
      for (var v in val) {
        bool alreadyExist = checkAlreadyHavePreOrderAndPromotion(
          retailerId: retailerId,
          promotionId: (v.id ?? 0).toString(),
        );

        if (alreadyExist) {
          beforeSelectedSlabPromotionList.add(v.id ?? 0);
        }
      }
    }
    ref.read(beforeSelectedSlabPromotion.notifier).state = beforeSelectedSlabPromotionList;
  }

  // int deliveryOutletId = 0;

  void getAllSlabPromotionForDelivery({required int outletId}) async {
    // deliveryOutletId = outletId ?? 0;
    await Future.delayed(const Duration(milliseconds: 100));
    // if(outletId==null) {
    List<int> outletPromotion = [];
    if (syncObj.containsKey('promotion-data')) {
      if (syncObj['promotion-data'].containsKey('$outletId')) {
        Map promotionsData = syncObj['promotion-data']['$outletId'];
        for (var element in promotionsData.keys) {
          outletPromotion.add(int.tryParse(element) ?? 0);
        }
      }
    }

    List<PromotionModel>? asyncPromotions = ref.read(comboPromotionPerRetailerProvider).value;

    print('-------->> ${asyncPromotions?.length}');

    List<int> beforeSelectedSlabPromotionList = ref.read(beforeSelectedSlabPromotion);

    for (PromotionModel promotion in asyncPromotions ?? []) {
      if (outletPromotion.contains(promotion.id)) {
        beforeSelectedSlabPromotionList.add(promotion.id);
      }
    }

    ref.refresh(beforeSelectedSlabPromotion);
    ref.read(beforeSelectedSlabPromotion.notifier).state = beforeSelectedSlabPromotionList;
    // }
  }

  void getCapturePhoto(CapturedImageType type) async {
    BrandModel? selected = ref.watch(selectedBrandProvider);
    if (selected == null) {
      _alerts.customDialog(
        type: AlertType.error,
        message: 'Please select brand first',
        // description: 'You have to capture retailers image',
      );
      return;
    }

    OutletModel? selectedOutlet = ref.watch(selectedRetailerProvider);
    SrInfoModel? sr = await SyncReadService().getSrInfo();
    String name = "posmManagement_${sr.ffId}_${DateTime.now().millisecondsSinceEpoch}";
    if (type == CapturedImageType.assetInstallationPhoto) {
      Navigator.of(context).pushNamed(CameraScreen.routeName).then((value) async {
        imageProcessing(value: value.toString(), name: name, type: type);
      });
    } else {
      ImageService().showImageBottomSheet(
        context: context,
        fromGallery: () async {
          XFile? file = await getImageGallery(context);
          imageProcessing(value: file?.path.toString() ?? '', name: name, type: type);
        },
        fromCamera: () async {
          await Future.delayed(const Duration(microseconds: 100));
          Navigator.of(context).pushNamed(CameraScreen.routeName).then((value) async {
            imageProcessing(value: value.toString(), name: name, type: type);
          });
        },
      );
    }
  }

  String posmPhotoName = "";

  void imageProcessing({
    required String value,
    required String name,
    required CapturedImageType type,
  }) {
    ImageService()
        .compressFile(context: context, file: File(value.toString()), name: name)
        .then((File? compressedImage) async {
      if (compressedImage != null) {
        ref.read(outletImageProvider(type).notifier).state = compressedImage.path;
        if (type == CapturedImageType.posmPhoto) {
          posmPhotoName = "$name.jpg";
        }
      } else {
        _alerts.customDialog(
          type: AlertType.error,
          message: 'Skipped capturing image',
        );
      }
    });
  }

  Future<XFile?> getImageGallery(context) async {
    ImagePicker picker = ImagePicker();

    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    return pickedImage;
  }

  AddedPosmModel? addedPosmModel;

  Future<bool> submitPosm({required String quantity}) async {
    BrandModel? selectedBrand = ref.watch(selectedBrandProvider);
    String? posmPhotoPath =
        ref.read(outletImageProvider(CapturedImageType.posmPhoto).notifier).state;
    PosmTypeModel? posmType = ref.watch(selectedPosmTypeProvider);

    if (selectedBrand == null) {
      _alerts.customDialog(
        type: AlertType.error,
        message: 'Please select a brand',
        // description: 'You have to capture retailers image',
      );
      return false;
    }
    if (posmType == null) {
      _alerts.customDialog(
        type: AlertType.error,
        message: 'Please enter posm type',
        // description: 'You have to capture retailers image',
      );
      return false;
    }
    if (quantity.isEmpty) {
      _alerts.customDialog(
        type: AlertType.error,
        message: 'Please enter quantity',
        // description: 'You have to capture retailers image',
      );
      return false;
    }
    int availableQuantity = 0;
    int inputQuantity = 0;
    availableQuantity = await PosmManagementService().getAvailableQuantity(
      brandId: selectedBrand.id.toString(),
      posmTypeId: posmType.posmTypeId,
    );
    inputQuantity = int.tryParse(quantity) ?? 0;

    print('entered posm is::: $quantity $availableQuantity $inputQuantity');
    if (inputQuantity > availableQuantity) {
      _alerts.customDialog(
        type: AlertType.error,
        message: 'You have not enough posm that you entered',
        // description: 'You have to capture retailers image',
      );

      return false;
    }

    if (posmPhotoName.isEmpty || posmPhotoPath == null) {
      _alerts.customDialog(type: AlertType.warning, description: "Please capture photo");
      return false;
    }

    OutletModel retailer = ref.read(selectedRetailerProvider)!;

    _alerts.floatingLoading();
    await ImageService()
        .sendImage(posmPhotoPath, "asset/posm_image/${retailer.outletCode}/${selectedBrand.id}");

    AddedPosmModel posmModel = AddedPosmModel(
      brandId: selectedBrand.id,
      outlet: retailer,
      quantity: int.tryParse(quantity) ?? 0,
      imageName: posmPhotoName,
      imagePath: posmPhotoPath,
      posmTypeId: posmType.posmTypeId,
      posmConfigId: posmType.posmConfigId,
    );

    bool savedPosmData = await PosmManagementService().addPosm(posmModel: posmModel);
    navigatorKey.currentState?.pop();
    return savedPosmData;
  }

  final CouponService _couponService = CouponService();

  Future<CouponModel?> checkAndApplyCouponCode({
    required String coupon,
    required AllKindOfSaleDataModel salesData,
  }) async {
    try {
      bool existCoupon = await _couponService.checkCouponExist(couponCode: coupon);
      // log('coupon exists $existCoupon ${coupon.length} $coupon');
      if (existCoupon == true) {
        CouponModel? couponModel = await _couponService.getCouponFromCouponCode(couponCode: coupon);
        if (couponModel == null) {
          _alerts.customDialog(
              type: AlertType.warning,
              description: "You coupon code not applicable at this moment");
        } else {
          bool applicableWithPromotion = await _couponService.applicableWithPromotion(
            discounts: salesData.salesPreorderDiscountDataModel.discountData[0] ?? [],
            slabList: salesData.slabsList ?? [],
            coupon: couponModel,
          );

          if (applicableWithPromotion == false) {
            _alerts.customDialog(
                type: AlertType.warning,
                description: "You coupon code not applicable with exiting promotion");
          } else {
            ref.read(visibleCoupon.notifier).state = true;
            return couponModel;
          }
        }
      } else {
        _alerts.customDialog(type: AlertType.warning, description: "You are trying with a invalid coupon code.");
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
  }

  void selectTryBeforeBuy(WidgetRef ref, {required TryBeforeBuyModel tryBeforeBuy}) {
    try {
      List<TryBeforeBuyModel> selectedTryBeforeBuy = ref.watch(selectedTryBeforeBuyProvider);
      List<TryBeforeBuyModel> newList = [];
      if (selectedTryBeforeBuy.contains(tryBeforeBuy)) {
        newList = [...selectedTryBeforeBuy];
        newList.remove(tryBeforeBuy);
      } else {
        newList = [...selectedTryBeforeBuy];
        newList.add(tryBeforeBuy);
      }

      ref.read(selectedTryBeforeBuyProvider.notifier).state = [...newList];
      newList.clear();
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
  }

  Future submitTryBeforeBuy() async {
    List<TryBeforeBuyModel> selectedTryBeforeBuy = ref.watch(selectedTryBeforeBuyProvider);

    if (selectedTryBeforeBuy.isEmpty) {
      _alerts.customDialog(
        type: AlertType.error,
        message: 'Please, select SKU for try before buy',
      );
      return;
    }

    _alerts.floatingLoading(message: "Saving...");

    OutletModel? selectedRetailer = ref.watch(selectedRetailerProvider);

    if (selectedRetailer != null) {
      bool saveTryBeforeYouBuyToSync = await _tryBeforeBuyService.saveAllTryBeforeYouBuy(
        tryBeforeBuyList: selectedTryBeforeBuy,
        retailer: selectedRetailer,
      );

      if (saveTryBeforeYouBuyToSync == true) {
        _tryBeforeBuyService.sendTryBeforeYouBuyToApi(
          retailer: selectedRetailer,
          tryBeforeYouBuys: selectedTryBeforeBuy,
        );
      }

      if (saveTryBeforeYouBuyToSync == true) {
        ref.refresh(selectedTryBeforeBuyProvider);
        ref.refresh(allTryBeforeBuySkuForSpecificRetailer(selectedRetailer));
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    }
  }

  Future enrollQPSPromotion() async {
    OutletModel? retailer = ref.watch(selectedRetailerProvider);

    if (retailer != null) {
      List<int> selectedPromotionIds = ref.watch(beforeSelectedQpsPromotion);

      if (selectedPromotionIds.isEmpty) {
        _alerts.customDialog(
          type: AlertType.error,
          message: 'Please, select minimum one promotion',
        );
      } else {
        _alerts.floatingLoading(message: "Saving...");

        Map finalMap = await _qpsPromotionServices.saveEnrollQpsPromotionForARetailer(
            retailer: retailer, selectedPromotionIds: selectedPromotionIds);

        ReturnedDataModel returnedDataModel = await _qpsPromotionServices.sendQpsEnrollToApi(
          finalMap: finalMap,
          retailer: retailer,
          selectedPromotionIds: selectedPromotionIds,
        );

        Navigator.pop(context);

        if (returnedDataModel.status == ReturnedStatus.success) {
          _alerts.customDialog(
            type: AlertType.success,
            description: returnedDataModel.errorMessage,
            onTap1: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        } else {
          _alerts.customDialog(
            type: AlertType.error,
            description: returnedDataModel.errorMessage,
            onTap1: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        }

        ///re-write sync file
        Map promotions = retailer.availablePromotions;
        Map qpsPromotions = retailer.availableQpsPromotions;
        for (var val in selectedPromotionIds) {
          if (selectedPromotionIds.contains(val)) {
            Map a = qpsPromotions[val];
            promotions[val] = a;
          }
        }

        await _salesService.saveRetailerPromotionData(
          retailer: retailer,
          newPromotionDataForRetailer: promotions,
        );

        ///TODO TODO
        // await _syncService.writeSync(jsonEncode(syncObj));

        ref.refresh(allEnrolledQpsPromotionPerRetailerProvider);
        ref.refresh(unEnrolledQpsPromotionPerRetailerProvider);
        ref.refresh(beforeSelectedQpsPromotion);
      }
    }
  }

  handleSectionChange(SectionModel? section) {
    // ref.refresh(retailerSaleStatusProvider);
    // if (section != null) {
    //   // print(retailer.retailerName);
    //   ref.read(selectedSectionProvider.notifier).state = section;
    //   // ref.read(retailerOkForSaleProvider.state).state = false;
    // } else {
    //   ref.read(selectedSectionProvider.notifier).state = null;
    // }
    // refreshPreviousSaleData();
  }

  void navigateToPage({
    required SaleDashboardCategoryModel item,
    OutletModel? retailer,
    required List<SaleDashboardCategoryModel> allItems,
  }) async {
    switch (item.type) {
      case SaleDashboardType.checkout:
        _doCheckout();
        return;
      case SaleDashboardType.preOrder:
        if (item.forceDisable) {
          _completeMandatoryPopup();
          return;
        }

        _alerts.floatingLoading();

        Navigator.of(context).pop();
        await _stockCheckService.getAndUpdateMaxStockLimitForPreorder();
        Navigator.of(context).pushNamed(
          ShowSkuUIV2.routeName,
          arguments: {'sale_type': SaleType.preorder},
        );
        return;
      case SaleDashboardType.spotSale:
        bool checkSpotSalesEnable = await salesDashboardService.checkSpotSalesEnable(retailer: retailer);
        if(checkSpotSalesEnable == false) {
          _alerts.customDialog(
            type: AlertType.warning,
            description: "Sales are not enable right now",
          );
          return;
        }

        if (item.forceDisable) {
          _completeMandatoryPopup();
          return;
        }

        Navigator.of(context).pushNamed(
          ShowSkuUIV2.routeName,
          arguments: {'sale_type': SaleType.spotSale},
        );
        return;
      case SaleDashboardType.delivery:
        if (item.alreadyComplete) {
          _alerts.customDialog(
            type: AlertType.warning,
            description: "Delivery completed for this retailer.",
          );
        }
        if (item.forceDisable) {
          _completeMandatoryPopup();
          return;
        }

        currentSaleData = {};
        currentPreorderData = {};
        navigateToDeliveryPage(retailer!);
        return;
      case SaleDashboardType.survey:
        if (item.alreadyComplete || item.forceDisable) {
          _alerts.customDialog(
              type: AlertType.warning, description: "You already complete all your survey");
          return;
        }
        for (var survey in item.surveyList ?? []) {
          Navigator.of(context).pushNamed(
            SurveyUI.routeName,
            arguments: {
              'retailerId': item.retailer?.id,
              'surveyModel': survey,
              'retailer': item.retailer,
            },
          );
        }
        return;
      case SaleDashboardType.stockCount:
        log("click for stock count ${DateTime.now()}");
        if (item.forceDisable) {
          _alerts.customDialog(
              type: AlertType.warning, description: "You already submit Stock count");
          return;
        }
        Navigator.pushNamed(
          context,
          OutletStockCountUI.routeName,
          arguments: item.stockCountProduct,
        );
        return;
      case SaleDashboardType.media:
        navigateToMediaPage(item: item, retailer: retailer);
        return;
      case SaleDashboardType.promotion:
        Navigator.pushNamed(
          context,
          PromotionsListScreen.routeName,
          arguments: item.arguments,
        );
        return;
      case SaleDashboardType.posm:
        // Navigator.pushNamed(
        //   context,
        //   item.screen,
        // );
        // TODO: Handle this case.
        return;
      case SaleDashboardType.stockCheck:
        Navigator.pushNamed(
          context,
          StockCheckUI.routeName,
        );
    }
  }

  void _doCheckout() async {
    try {
      _alerts.floatingLoading(message: 'Loading...');
      OutletModel? retailer =
          ref.read(selectedRetailerProvider.notifier).state;
      bool isSave = await _salesService.doCheckoutAndSendDataToServer(retailer: retailer);
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    } finally {
      navigatorKey.currentState?.pop();
      navigatorKey.currentState?.pop();
    }
  }

  ///Save outlet stock count to sync
  Future<void> saveOutletStockCount({required List<AwsProductModel> productList}) async {
    log('product list is:::: ${productList.length}');
    Map<String, Map<String, Map<String, dynamic>>> stock = {};
    List<Module> moduleList = await SyncReadService().getModuleModelList();
    OutletModel? retailerModel = ref.read(selectedRetailerProvider);
    try {
      /// prepare stock map from current data module and sku wise
      log('module list is:::: ${moduleList.length}');
      if (moduleList.isNotEmpty) {
        for (Module module in moduleList) {
          if (!stock.containsKey(module.id.toString())) {
            stock[module.id.toString()] = {};
          }

          if (productList.isNotEmpty) {
            for (AwsProductModel sku in productList) {
              if (module.id == sku.moduleId) {
                if (!stock[module.id.toString()]!.containsKey(sku.id.toString())) {
                  stock[module.id.toString()]?[sku.id.toString()] = {};
                }
                Map<String, dynamic> inputStock = {
                  outletStockCountSkuIdKey: sku.id,
                  outletStockCountSkuNameKey: sku.name,
                  outletStockCountSkuShortNameKey: sku.shortName,
                  outletStockCountDamageKey: sku.damagedCount,
                  outletStockCountStockKey: sku.stockCount,
                  outletStockCountDateKey: DateTime.now().toString(),
                };
                stock[module.id.toString()]?[sku.id.toString()] = inputStock;
              }
            }
          }
        }
      }

      await _syncService.checkSyncVariable();
      if (!syncObj.containsKey(outletStockCountKey)) {
        syncObj[outletStockCountKey] = {};
      }

      if (!syncObj[outletStockCountKey].containsKey(retailerModel?.id.toString())) {
        syncObj[outletStockCountKey][retailerModel?.id.toString()] = {};
      }

      syncObj[outletStockCountKey][retailerModel?.id.toString()] = stock;

      await _syncService.writeSync(jsonEncode(syncObj));

      await _saveOutletStockCountToServer(retailerModel!);
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }

  Future<void> _saveOutletStockCountToServer(OutletModel retailerModel) async {
    SalesService salesService = SalesService();
    await salesService.saveOutletStockCountToServer(retailer: retailerModel);
  }

  Future<void> navigateToDeliveryPage(OutletModel retailer) async {
    bool deliveryAvailable = await _outletServices.getDeliveryAvailableThisOutlet(outlet: retailer);
    if (deliveryAvailable == true) {
      Navigator.of(context).pushNamed(
        DeliveryV2UI.routeName,
      );
    } else {
      await _outletController.handleOutletSyncAndRedirectToDelivery(true,
          navigateDeliveryScreen: false);
      bool deliveryAvailable =
          await _outletServices.getDeliveryAvailableThisOutlet(outlet: retailer);
      if (deliveryAvailable == true) {
        Navigator.of(context).pushNamed(
          DeliveryV2UI.routeName,
        );
      } else {
        _alerts.customDialog(
          type: AlertType.error,
          message: "No delivery data available for this outlet right now",
        );
      }
    }
  }

  void _completeMandatoryPopup() {
    _alerts.customDialog(
      type: AlertType.warning,
      description: "Please complete all the mandatory (*) task before start sale",
    );
  }

  void navigateToMediaPage(
      {required SaleDashboardCategoryModel item, OutletModel? retailer}) async {
    if (item.videoAVs != null && (item.videoAVs?.isNotEmpty ?? false)) {
      for (var avModel in item.videoAVs ?? []) {
        await Navigator.pushNamed(context, VideoPlayerUI.routeName, arguments: {
          "avModel": avModel,
          "file": await AvHelperService().getAv(avModel.filename),
          "skip": item.alreadyComplete || item.forceDisable,
        }).then((value) async {
          if (value == true) {
            await AvService(context).submitAvData(
              avModel,
              item.retailer?.id ?? 0,
            );

            ref.refresh(saleDashboardMenuProvider(retailer!));
          }
        });
      }
    }
    if (item.kvList != null && (item.kvList?.isNotEmpty ?? false)) {
      for (var kv in item.kvList ?? []) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return KVUI(womModel: kv, retailer: item.retailer!);
            },
          ),
        );
      }
    }
    if (item.womList != null && (item.womList?.isNotEmpty ?? false)) {
      for (var wom in item.womList ?? []) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return WOMUI(womModel: wom, retailer: item.retailer!);
            },
          ),
        );
      }
    }
  }

  // changeStockWhenEditingStock2(List<ProductDetailsModel> skus, List<MemoInformationModel> memoInfo) {
  //   try {
  //     for (ProductDetailsModel sku in skus) {
  //       int previousSoldSku = getPreviousSaleDataFromMemoInfo2(memoInfo, sku);
  //       print("-->><<>>> ${previousSoldSku}");
  //       sku.stocks.currentStock += previousSoldSku;
  //       if (sku.stocks.currentStock > sku.stocks.liftingStock) {
  //         sku.stocks.currentStock = sku.stocks.liftingStock;
  //       }
  //     }
  //   } catch (e) {
  //     print("inside changeStockWhenEditingStock salesController catch block $e");
  //   }
  // }
  //
  // int getPreviousSaleDataFromMemoInfo2(List<MemoInformationModel> memoInfo, ProductDetailsModel sku) {
  //   int saleData = 0;
  //   try {
  //     for (MemoInformationModel memo in memoInfo) {
  //       print("COme to here::: ");
  //       if (memo.module.id == sku.module.id) {
  //         if (memo.skus.isNotEmpty) {
  //           for (ProductDetailsModel s in memo.skus) {
  //             if (s.id == sku.id) {
  //               if (s.preorderData != null) {
  //                 saleData = s.preorderData!.qty;
  //               }
  //               break;
  //             }
  //           }
  //         }
  //         break;
  //       }
  //     }
  //   } catch (e) {
  //     print("inside getPreviousSaleDataFromMemoInfo saleController catch block $e");
  //   }
  //   return saleData;
  // }

  changeStockWhenEditingStock(List<ProductDetailsModel> skus, List<PreorderMemoInformationModel> memoInfo) {
    try {
      for (ProductDetailsModel sku in skus) {
        int previousSoldSku = getPreviousSaleDataFromMemoInfo(memoInfo, sku);
        sku.stocks.currentStock += previousSoldSku;
        print("-->><<>>> ${previousSoldSku} : ${sku.stocks.currentStock}");
        if (sku.stocks.currentStock > sku.stocks.liftingStock) {
          sku.stocks.currentStock = sku.stocks.liftingStock;
        }
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
  }

  int getPreviousSaleDataFromMemoInfo(List<PreorderMemoInformationModel> memoInfo, ProductDetailsModel sku) {
    int saleData = 0;
    try {
      for (PreorderMemoInformationModel memo in memoInfo) {
        if (memo.module.id == sku.module.id) {
          if (memo.skus.isNotEmpty) {
            for (ProductDetailsModel s in memo.skus) {
              if (s.id == sku.id) {
                if (s.preorderData != null) {
                  saleData = s.preorderData!.qty;
                }
                break;
              }
            }
          }
          break;
        }
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return saleData;
  }

  changePreorderStockWhenEditingStock(List<ProductDetailsModel> skus, List<PreorderMemoInformationModel> memoInfo) {
    try {
      for (ProductDetailsModel sku in skus) {
        int previousSoldSku = getPreviousPreorderDataFromMemoInfo(memoInfo, sku);
        sku.preOrderStocks?.liftingStock -= previousSoldSku;
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
  }

  int getPreviousPreorderDataFromMemoInfo(List<PreorderMemoInformationModel> memoInfo, ProductDetailsModel sku) {
    int saleData = 0;
    try {
      for (PreorderMemoInformationModel memo in memoInfo) {
        if (memo.module.id == sku.module.id) {
          if (memo.skus.isNotEmpty) {
            for (ProductDetailsModel s in memo.skus) {
              if (s.id == sku.id) {
                if (s.preorderData != null) {
                  saleData = s.preorderData!.qty;
                }
                break;
              }
            }
          }
          break;
        }
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return saleData;
  }
}
