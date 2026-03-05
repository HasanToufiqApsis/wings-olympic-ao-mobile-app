import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:wings_olympic_sr/services/pre_order_service.dart';
import 'package:wings_olympic_sr/utils/sales_dashboard_utils.dart';
import 'package:wings_olympic_sr/utils/sales_type_utils.dart';

import '../../../constants/constant_keys.dart';
import '../../../constants/enum.dart';
import '../../../constants/sync_global.dart';
import '../../../models/AvModel.dart';
import '../../../models/WomModel.dart';
import '../../../models/outlet_model.dart';
import '../../../models/survey/question_model.dart';
import '../../../services/before_sale_services/av_helper_service.dart';
import '../../../services/before_sale_services/survey_service.dart';
import '../../../services/before_sale_services/wom_helper_service.dart';
import '../../../services/outlet_services.dart';
import '../../../services/product_category_services.dart';
import '../../../services/sync_service.dart';
import '../../../services/trade_promotion_services.dart';
import '../../aws_stock/model/aws_product_model.dart';
import '../../delivery/ui/delivery_v2_ui.dart';
import '../../promotions_list/ui/promotion_list_screen.dart';
import '../../survey/survey_ui.dart';
import '../../video_player.dart';
import '../model/sale_dashboard_category_model.dart';
import '../ui/outlet_stock_count.dart';
import '../ui/sale_v2_widget/show_sku_ui.dart';
import '../ui/sale_v2_widget/show_sku_ui_v2.dart';

class SalesDashboardService {
  final _avHelperService = AvHelperService();
  final _womHelperService = WomHelperService();
  final _surveyService = SurveyService();
  final _syncService = SyncService();
  final _productCategoryServices = ProductCategoryServices();
  final _tradePromotionServices = TradePromotionServices();
  final _outletServices = OutletServices();

  Future<List<SaleDashboardCategoryModel>>
      checkAllMenuAvailableForSaleDashboard(
    OutletModel? retailer,
  ) async {
    if(retailer==null) return [];
    await _syncService.checkSyncVariable();

    List<SaleDashboardCategoryModel> finalList = [];

    try {
      List list = [];

      list.add({
        'type': 'av',
        'list': await _avHelperService.getAvList(
          avIdList: retailer.availableAv,
          retailerId: retailer.id ?? 0,
        ),
        'all_list': await _avHelperService.getAvList(
          avIdList: retailer.availableAv,
          retailerId: retailer.id ?? 0,
          all: true,
        ),
      });
      list.add({
        'type': 'wom',
        'list': await _womHelperService.getWomList(
            womIdList: retailer.availableWOM, retailerId: retailer.id ?? 0)
      });
      list.add({
        'type': 'survey',
        'list': await _surveyService.getSurveyList(
          surveyIdList: retailer.availableSurvey,
          retailerId: retailer.id ?? 0,
        ),
        'all_list': await _surveyService.getAllSurveyList(
          surveyIdList: retailer.availableSurvey,
          retailerId: retailer.id ?? 0,
        )
      });

      for (var i in list) {
        if (i['type'] == 'survey') {
          // log('active survey is :: ${i['list'].length}');
          // log('already survey is :: ${i['all_list'].length}');

          if (i['list'].isNotEmpty) {
            List<SurveyModel> surveys = [];
            bool isMandatory = false;
            for (var surveyModel in i['list']) {
              /// add survey menu
              bool mandatory =
                  (surveyModel as SurveyModel).mandatory == 1 ? true : false;

              if (isMandatory == false) {
                if (mandatory == true) {
                  isMandatory = true;
                }
              }
              surveys.add(surveyModel);
            }

            if (surveys.isNotEmpty) {
              finalList.add(SaleDashboardCategoryModel(
                type: SaleDashboardType.survey,
                slug: 'survey',
                image: "survey.png",
                title: "Survey",
                surveyList: surveys,
                mandatory: isMandatory,
                retailer: retailer,
                weight: getButtonSequence(
                  type: SaleDashboardType.survey,
                ),
              ));
            }
          } else if (i["list"].isEmpty && i["all_list"].isNotEmpty) {
            bool isMandatory = false;
            for (var surveyModel in i['all_list']) {
              bool mandatory =
                  (surveyModel as SurveyModel).mandatory == 1 ? true : false;

              if (isMandatory == false) {
                if (mandatory == true) {
                  isMandatory = true;
                }
              }
            }
            finalList.add(SaleDashboardCategoryModel(
              type: SaleDashboardType.survey,
              slug: 'survey',
              image: "survey.png",
              title: "Survey",
              mandatory: isMandatory,
              forceDisable: true,
              alreadyComplete: true,
              weight: getButtonSequence(
                type: SaleDashboardType.survey,
              ),
            ));
          }
        }
      }


      finalList.add(SaleDashboardCategoryModel(
        type: SaleDashboardType.checkout,
        slug: 'check_out',
        image: "logout.png",
        title: "Check out",
        weight: getButtonSequence(
          type: SaleDashboardType.checkout,
        ),
      ));
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    finalList.sort((a, b) => a.weight.compareTo(b.weight));
    return finalList;
  }

  Future<bool> checkOutletStockCountDoneForARetailer({
    required OutletModel? retailerModel,
  }) async {
    bool done = false;

    try {
      await _syncService.checkSyncVariable();
      done = syncObj[outletStockCountKey]?[retailerModel?.id.toString()]
              ?.isNotEmpty ??
          false;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }

    return done;
  }

  bool checkCurrentItemAvailable(
    List<SaleDashboardCategoryModel> existingList,
    String slug,
  ) {
    try {
      List<String> slugList = existingList.map((e) => e.slug).toList();
      if (slugList.contains(slug)) {
        return true;
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }

    return false;
  }

  bool getAlreadySaleOnThisRetailer({
    required OutletModel? retailer,
    required SaleType saleType,
  }) {
    bool saleAvailable = false;
    try {
      final key = saleType == SaleType.preorder ? preorderKey : spotSaleKey;
      Map saleData = syncObj[key]?[retailer?.id.toString()] ?? {};
      if (saleData.isNotEmpty) {
        saleAvailable = true;
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return saleAvailable;
  }

  bool getAlreadyDeliveredOnThisRetailer({
    required OutletModel? retailer,
  }) {
    bool saleAvailable = false;
    try {
      Map saleData = syncObj["delivery-key"]?[retailer?.id.toString()] ?? {};
      if (saleData.isNotEmpty) {
        saleAvailable = true;
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return saleAvailable;
  }

  bool getButtonVisibility({
    required SaleDashboardType type,
  }) {
    bool visible = false;
    try {
      Map buttons = syncObj["sales_configurations"]?["sales_dashboard_buttons"] ?? {};
      String key = SalesDashboardUtils.toSyncFileKey(type);
      if (buttons.isNotEmpty && buttons.containsKey(key)) {
        visible = buttons[key] == 1;
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return visible;
  }

  Future<bool> getButtonVisibilityAsync({
    required SaleDashboardType type,
  }) async {
    bool visible = false;
    try {

      await _syncService.checkSyncVariable();
      Map buttons = syncObj["sales_configurations"]?["sales_dashboard_buttons"] ?? {};
      String key = SalesDashboardUtils.toSyncFileKey(type);
      if (buttons.isNotEmpty && buttons.containsKey(key)) {
        visible = buttons[key] == 1;
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return visible;
  }

  bool getMandatoryTasks({
    required SaleDashboardType type,
  }) {
    bool mandatory = false;
    try {
      Map buttons = syncObj["sales_configurations"]?["mandatory_tasks"] ?? {};
      String key = SalesDashboardUtils.toSyncFileKey(type);
      if (buttons.isNotEmpty && buttons.containsKey(key)) {
        mandatory = buttons[key] == 1;
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return mandatory;
  }

  num getButtonSequence({
    required SaleDashboardType type,
  }) {
    num sequence = 0;
    try {
      Map buttons = syncObj["sales_configurations"]?["dashboard_button_sequence"] ?? {};
      String key = SalesDashboardUtils.toSyncFileKey(type);
      if (buttons.isNotEmpty && buttons.containsKey(key)) {
        sequence = buttons[key];

        // log("sequence :: ${type.name} == $sequence $buttons");
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return sequence;
  }



  Future<bool> checkSpotSalesEnable({required OutletModel? retailer}) async {
    bool enable = true;
    try {
      if(retailer==null) return false;
      await _syncService.checkSyncVariable();
      bool preorderExist = PreOrderService().checkIfPreorderTakenForARetailer(retailer.id ?? 0);
      bool deliveryDataExist = await _outletServices.getDeliveryAvailableThisOutlet(outlet: retailer);
      if (preorderExist == true && deliveryDataExist == true) {
        enable = false;
      }
    } catch (e,t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return enable;
  }
}
