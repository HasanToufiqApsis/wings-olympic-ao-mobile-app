// ================================= read user data =======================
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:wings_olympic_sr/screens/olympic_tada/service/olympic_tada_service.dart';
import 'package:wings_olympic_sr/services/cluster_service.dart';
import 'package:wings_olympic_sr/services/day_close_service.dart';
import 'package:wings_olympic_sr/services/permission_service.dart';
import 'package:wings_olympic_sr/utils/sales_type_utils.dart';

import '../api/asset_management_api.dart';
import '../api/attendance_api.dart';
import '../api/bill_api.dart';
import '../api/leave_management_api.dart';
import '../api/pjp_plan_api.dart';
import '../api/tsm_api.dart';
import '../constants/enum.dart';
import '../constants/sync_global.dart';
import '../models/asset_install_pull_out_get_model.dart';
import '../models/asset_requisition_model.dart';
import '../models/attendance_model.dart';
import '../models/bill/bill_data_model.dart';
import '../models/brand/brand_model.dart';
import '../models/delivery/delivery_summary_model.dart';
import '../models/digital_learning/digital_learning_item.dart';
import '../models/general_id_slug_model.dart';
import '../models/journey_change_route_model.dart';
import '../models/leave_model.dart';
import '../models/leave_movement_management_model_tsm.dart';
import '../models/location_address_model.dart';
import '../models/location_category_models.dart';
import '../models/maintanence_model.dart';
import '../models/module.dart';
import '../models/outlet_model.dart';
import '../models/pjp_plan_details.dart';
import '../models/posm/posm_type_model.dart';
import '../models/previous_requisition.dart';
import '../models/products_details_model.dart';
import '../models/qc_config_model.dart';
import '../models/qc_info_model.dart';
import '../models/qps_sales_data.dart';
import '../models/retailers_mdoel.dart';
import '../models/route_change_model_tsm.dart';
import '../models/sale_summary_model.dart';
import '../models/sales/memo_information_model.dart';

import '../models/sales/sale_data_model.dart';
import '../models/sales/sales_preorder_configuration_model.dart';
import '../models/slab_promotion_selection_model.dart';
import '../models/sr_info_model.dart';
import '../models/survey/question_model.dart';
import '../models/target/dashboard_target_model.dart';
import '../models/target/dashboard_target_model_overall.dart';
import '../models/target/sr_stt_target_model.dart';

import '../models/team_performance/complete_dsr_wise_performance_model.dart';
import '../models/trade_promotions/applied_discount_model.dart';
import '../models/trade_promotions/promotion_model.dart';

import '../models/try_before_buy/try_before_buy_model.dart';
import '../screens/allowance_management/model/created_tada_model.dart';
import '../screens/allowance_management/service/tada_service.dart';
import '../screens/attendance/model/attendance_provider_model.dart';
import '../screens/leave_management/model/selected_vehicle_with_tada.dart';
import '../screens/leave_management/model/ta_da_vehicle_model.dart';
import '../screens/olympic_tada/model/drafted_ta_da.dart';
import '../screens/olympic_tada/model/extra_ta_da_model.dart';
import '../screens/olympic_tada/model/selected_vehicle_with_tada_olympic.dart';
import '../screens/pjp_plan/service/pjp_plan_service.dart';
import '../screens/print_memo/model/load_summaryDetailsModel.dart';
import '../screens/print_memo/model/load_summary_model.dart';
import '../screens/print_memo/model/retailer_wise_memo_data.dart';
import '../screens/print_memo/service/print_memo_service.dart';
import '../screens/sale/model/sale_dashboard_category_model.dart';
import '../screens/sale/service/sales_dashboard_service.dart';
import '../screens/settings/model/edit_reason_model.dart';
import '../services/asset_management_service.dart';

import '../services/attendance_location_service.dart';
import '../services/before_sale_services/survey_service.dart';
import '../services/change_route_service.dart';
import '../services/connectivity_service.dart';
import '../services/coupon_service.dart';
import '../services/delivery_services.dart';
import '../services/digital_learning_searvice.dart';
import '../services/ff_services.dart';
import '../services/geo_location_service.dart';
import '../services/location_category_services.dart';
import '../services/module_services.dart';
import '../services/offline_pda_service.dart';
import '../services/outlet_services.dart';
import '../services/posm_management_service.dart';
import '../services/pre_order_service.dart';
import '../services/price_services.dart';
import '../services/product_category_services.dart';
import '../services/promotion_services.dart';
import '../services/qps_promotion_services.dart';
import '../services/sales_service.dart';
import '../services/search_history_db_service.dart';
import '../services/settings_service.dart';
import '../services/sr_target_services.dart';
import '../services/stock_service.dart';
import '../services/sync_read_service.dart';
import '../services/team_performance_service.dart';
import '../services/trade_promotion_services.dart';
import '../services/try_before_buy_service.dart';
import '../utils/case_piece_type_utils.dart';
import '../utils/promotion_utils.dart';
import 'notifier/delivery_outlet_list_notifier.dart';
import 'notifier/dependency_question_notifier.dart';
import 'notifier/olypmpic_tada_notifier.dart';
import 'notifier/outlet_list_notifier.dart';
import 'notifier/product_stock_notifier.dart';
import 'notifier/qc_sku_notifier.dart';
import 'notifier/requisition_outlet_list_notifier.dart';
import 'notifier/sales_sku_amount_notifier.dart';
import 'notifier/vehicle_tada_notifier.dart';
import 'package:wings_olympic_sr/models/cluster_model.dart' as cluster;

final userDataProvider = FutureProvider.autoDispose<SrInfoModel?>(
  (ref) async => await FFServices().getSrInfo(),
);
final dashboardButtonProvider = FutureProvider.autoDispose.family<bool, String>(
  (ref, slug) async => await SyncReadService().checkButtonAvailability(slug),
);
// =============================== outlet onboarding ====================
final outletImageProvider = StateProvider.family<String?, CapturedImageType>(
  (ref, type) => null,
);
final multipleImageProvider = StateProvider.autoDispose.family<String?, String>(
  (ref, type) => null,
);
final multipleImageListProvider = StateProvider.autoDispose<List<String>>(
  (ref) => ["1"],
);
final selectedClusterProvider = StateProvider.autoDispose<cluster.ClusterModel?>(
  (ref) => null,
);
final clusterListProvider =
    FutureProvider.autoDispose<List<cluster.ClusterModel>>((ref) async {
      final clusters = ClusterService().getAllClusters();
      return clusters;
    });

final businessTypeProvider = FutureProvider<List<GeneralIdSlugModel>>(
  (ref) async => await OutletServices().getBusinessTypeList(),
);
final channelCatsProvider = FutureProvider<List<GeneralIdSlugModel>>(
  (ref) async => await OutletServices().getChannelCategoryList(),
);
final coolersProvider = FutureProvider<List<GeneralIdSlugModel>>(
  (ref) async => await OutletServices().getCoolerList(),
);
final selectedBusinessTypeProvider =
    StateProvider.autoDispose<GeneralIdSlugModel?>((ref) => null);
final selectedChannelCatsProvider =
    StateProvider.autoDispose<GeneralIdSlugModel?>((ref) => null);
final selectedCoolerListProvider =
    StateProvider.autoDispose<GeneralIdSlugModel?>((ref) => null);
final selectedCoolerStatusProvider = StateProvider.autoDispose<String?>(
  (ref) => null,
);

final outletListProvider = StateNotifierProvider.family
    .autoDispose<OutletListNotifier, AsyncValue<List<OutletModel>>, bool>(
      (ref, onlyLive) => OutletListNotifier(ref, onlyLive),
    );
final outletListProviderWithoutDropdown =
    FutureProvider.autoDispose<List<OutletModel>>((ref) async {
      return await OutletServices().getOutletList(true);
    });

final memoCountProviderBySaleType = FutureProvider.autoDispose
    .family<int, SaleType>((ref, saleType) async {
      return await OutletServices().getMemoCountBySaleType(saleType: saleType);
    });

final orderedOutletListProvider = FutureProvider.autoDispose
    .family<List<OutletModel>, SaleType>((ref, saleType) async {
      return await OutletServices().getOrderedOutletList(saleType: saleType);
    });

final memoOutletListProvider = StateNotifierProvider.family
    .autoDispose<OutletListNotifier, AsyncValue<List<OutletModel>>, bool>(
      (ref, onlyLive) => OutletListNotifier(ref, onlyLive, true),
    );

final outletTotalSyncedCountProvider =
    FutureProvider.autoDispose<Map<String, int>>(
      (ref) async => OutletServices().getNewAndUpdatedOutletCount(),
    );
final availableOnboardingFeaturesProvider = FutureProvider.autoDispose<Map>(
  (ref) async => OutletServices().getAvailableOnboardingFeatures(),
);

// =================================== login ===================================================
final hideTextProvider = StateProvider.autoDispose<bool>((ref) => true);

//==================================== SALE ===================================================
//retailer selected from dropdown
final checkRetailerPreorderProvider = FutureProvider.autoDispose
    .family<bool, int>(
      (ref, retailerId) async =>
          await SalesService().checkRetailerHasTakenPreorder(retailerId),
    );
final selectedRetailerProvider = StateProvider.autoDispose<OutletModel?>(
  (ref) => null,
);
final moduleListProvider = FutureProvider.autoDispose<List<Module>>((
  ref,
) async {
  OutletModel? selectedRetailer = ref.watch(selectedRetailerProvider);
  if (selectedRetailer != null) {
    return await ModuleServices().getModuleModelList();
  }
  return [];
});
final allModuleListProvider = FutureProvider.autoDispose<List<Module>>((
  ref,
) async {
  return await ModuleServices().getModuleModelList();
});
final outletSaleStatusProvider = StateProvider.autoDispose<OutletSaleStatus>(
  (ref) => OutletSaleStatus.inactive,
);

final saleEditSkuAmountProvider =
    StateNotifierProvider.family<
      SalesSkuAmountNotifier,
      SaleDataModel,
      ProductDetailsModel
    >((ref, sku) {
      return SalesSkuAmountNotifier(sku, ref);
    });
final productListFutureProvider = FutureProvider.family
    .autoDispose<List<ProductDetailsModel>, Module>((ref, module) async {
      PreorderCategoryFilterButtonType type = ref.watch(
        selectedPreorderFilterTypeProvider,
      );

      return await ProductCategoryServices().getProductDetailsList(
        module,
        type: type,
      );
    });

final deliveryListFutureProvider = FutureProvider.family
    .autoDispose<List<ProductDetailsModel>, Module>((ref, module) async {
      OutletModel? outlet = ref.watch(selectedRetailerProvider);
      if (outlet != null) {
        return await ProductCategoryServices().getDeliveryDetailsList(
          module,
          outlet,
        );
      } else {
        return [];
      }
    });

final promotionsPerSkuAndRetailerProvider = FutureProvider.family
    .autoDispose<List<PromotionModel>, ProductDetailsModel>((ref, sku) async {
      OutletModel? retailer = ref.watch(selectedRetailerProvider);
      if (retailer != null) {
        return await TradePromotionServices().getPromotionPerSku(sku, retailer);
      } else {
        return [];
      }
    });

final comboPromotionPerRetailerProvider =
    FutureProvider.autoDispose<List<PromotionModel>>((ref) async {
      await Future.delayed(Duration(seconds: 5));
      OutletModel? retailer = ref.watch(selectedRetailerProvider);
      if (retailer != null) {
        return TradePromotionServices()
            .getComboAndEntireMemoPromotionForRetailer(retailer);
      } else {
        return [];
      }
    });

///all un-enrolled QPS promotion provider
final unEnrolledQpsPromotionPerRetailerProvider =
    FutureProvider.autoDispose<List<PromotionModel>>((ref) async {
      await Future.delayed(Duration(seconds: 5));
      OutletModel? retailer = ref.watch(selectedRetailerProvider);
      if (retailer != null) {
        Map salesData = await QPSPromotionServices()
            .getSalesDataForQPSPromotionTarget(retailer);
        List<PromotionModel> promotions = await QPSPromotionServices()
            .getAvailableQPSPromotionForRetailer(retailer);

        List<int> suggestions = await QPSPromotionServices()
            .getPromotionWithSuggestion(
              promotions: promotions,
              salesData: salesData,
            );

        ref.read(beforeSuggestedQpsPromotion.notifier).state = [...suggestions];
        final v = ref.watch(beforeSuggestedQpsPromotion);

        return promotions;
      } else {
        return [];
      }
    });

///get sales data for qps target
final salesDataForQpsPromotionTargetProvider = FutureProvider.autoDispose<Map>((
  ref,
) async {
  OutletModel? retailer = ref.watch(selectedRetailerProvider);
  if (retailer != null) {
    //{
    //     "sales_data": {
    //       "1": {
    //         "total_volume": 0,
    //         "total_price": 0
    //       },
    //       "2": {
    //         "total_volume": 0,
    //         "total_price": 0
    //       }
    //     },
    //     "month_count": 6
    //   }
    return QPSPromotionServices().getSalesDataForQPSPromotionTarget(retailer);
  } else {
    return {};
  }
});

///all enrolled QPS promotion provider
final allEnrolledQpsPromotionPerRetailerProvider =
    FutureProvider.autoDispose<List<QpsSalesData>>((ref) async {
      await Future.delayed(Duration(seconds: 5));
      OutletModel? retailer = ref.watch(selectedRetailerProvider);
      if (retailer != null) {
        List<PromotionModel> promotions = await QPSPromotionServices()
            .getAllEnrollAvailableQpsPromotionForARetailer(retailer);

        if (promotions.isNotEmpty) {
          List<QpsSalesData> salesData = await QPSPromotionServices()
              .getSalesDataForSpecificQPSs(
                retailer: retailer,
                qpsIds: promotions.map((e) => e.id).toList(),
                promotions: promotions,
              );

          return salesData;
        } else {
          return [];
        }
      } else {
        return [];
      }
    });
//increment decrement
final saleSkuAmountProvider = StateNotifierProvider.family
    .autoDispose<SalesSkuAmountNotifier, SaleDataModel, ProductDetailsModel>((
      ref,
      sku,
    ) {
      return SalesSkuAmountNotifier(sku, ref);
    });
final totalSoldAmountProvider = StateProvider.autoDispose<num>((ref) => 0);
//selected module
final selectedSalesModuleProvider = StateProvider.autoDispose<Module?>(
  (ref) => null,
);
final selectedReasonsProvider = StateProvider.autoDispose<String?>(
  (ref) => null,
);

final unsoldOutletListProvider =
    FutureProvider.autoDispose<List<GeneralIdSlugModel>>(
      (ref) async => await SalesService().getUnsoldNoButtonsList(),
    );
final unsoldOutlets = FutureProvider.autoDispose<List>(
  (ref) async => await OfflinePdaService().getUnsoldOutletData(),
);
//==============================================================================================

//selected Alphabet
final selectedAlphabetProvider = StateProvider.autoDispose<String>(
  (ref) => "All",
);
final alphabetListProvider = StateProvider<List<String>>((ref) => []);

///================= language provider =================
final languageProvider = StateProvider<String>((ref) {
  return 'en';
});

/// =================== Internet Connectivity ========================

final internetConnectivityProvider = StateProvider<bool>((ref) => true);

///================= download progress provider =======================
final progressProvider = StateProvider.autoDispose<int>((ref) => 0);

/// ======================= survey ===================

final surveyQuestionProvider = FutureProvider.family
    .autoDispose<List<QuestionModel>, SurveyModel>((ref, survey) async {
      return await SurveyService().getSurveyQuestionList(survey.id);
    });

final surveyQuestionProviderDigitalLearning = FutureProvider.family
    .autoDispose<List<QuestionModel>, DigitalLearningItem>((ref, survey) async {
      return await SurveyService().getSurveyQuestionListDigitalLearning(
        survey.surveyId,
      );
    });

final dependencyQuestionProvider = StateNotifierProvider.family
    .autoDispose<
      DependencyQuestionNotifier,
      List<QuestionModel>,
      QuestionModel
    >((ref, questionModel) {
      return DependencyQuestionNotifier(questionModel);
    });

final surveyListProvider = FutureProvider.family
    .autoDispose<List<SurveyModel>, OutletModel>((ref, retailer) async {
      return await SurveyService().getSurveyList(
        surveyIdList: retailer.availableSurvey,
        retailerId: retailer.id ?? 0,
      );
    });
// ========================= memo ==========================================
final checkSaleEditProvider = FutureProvider.autoDispose<bool>((ref) async {
  return await SyncReadService().checkIfSaleEditable();
});
final formattedMemoRetailerListProvider =
    FutureProvider.autoDispose<List<OutletModel>>((ref) async {
      String selected = ref.watch(selectedAlphabetProvider);
      List<OutletModel> mainRetailerList = [];
      Map m = await SyncReadService().getRetailerModelList(true);
      mainRetailerList = m['retailer'];
      List<OutletModel> retailer = [];
      if (selected == 'All') {
        retailer = mainRetailerList;
      } else {
        retailer = mainRetailerList
            .where((f) => f.name.startsWith(selected))
            .toList();
      }
      ref.read(selectedRetailerProvider.state).state = null;

      return retailer;
    });

//formatted retailer list after alphabet selection
final formattedRetailerListProvider =
    FutureProvider.autoDispose<List<OutletModel>>((ref) async {
      final section = ref.watch(selectedSectionProvider);
      String selected = ref.watch(selectedAlphabetProvider);
      List<OutletModel> mainRetailerList = [];
      Map m = await SyncReadService().getRetailerModelListBySection(
        section: section,
      );
      mainRetailerList = m['retailer'];
      List<OutletModel> retailer = [];
      if (selected == 'All') {
        retailer = mainRetailerList;
      } else {
        retailer = mainRetailerList
            .where((f) => f.name.startsWith(selected))
            .toList();
      }
      ref.read(selectedRetailerProvider.notifier).state = null;

      return retailer;
    });

// final alphabetListProvider = FutureProvider.autoDispose<List<String>>((ref) async {
//   Map m = await SyncReadService().getRetailerModelList();
//   List<String> alphabet = m['alphabet'];
//   alphabet.insert(0, 'All');
//   ref.read(selectedAlphabetProvider.state).state = alphabet[0];
//   return alphabet;
// });

final retailerPreorderRecordProvider = FutureProvider.autoDispose
    .family<List<PreorderMemoInformationModel>, SaleType>((
      ref,
      saleType,
    ) async {
      OutletModel? retailer = ref.watch(selectedRetailerProvider.state).state;
      if (retailer != null) {
        List<PreorderMemoInformationModel> memoInfos = await PreOrderService()
            .getPreorderInfoForRetailer(retailer, saleType);

        List<PromotionModel> allPromotionForThisRetailer =
            await TradePromotionServices()
                .getComboAndEntireMemoPromotionForRetailer(retailer);

        List<int> promotionsList = [];
        List<int> allPromotionsIdList = [];
        // List<PromotionModel>? allPromotionForThisRetailer = asyncPromotions.value;
        if (allPromotionForThisRetailer.isNotEmpty) {
          allPromotionsIdList = allPromotionForThisRetailer
              .map((e) => e.id)
              .toList();
        }
        for (var val in memoInfos) {
          for (var v in val.discounts) {
            promotionsList.add(v.promotionId);
          }
        }
        ref.read(beforeSelectedSlabPromotion.notifier).state = [
          ...promotionsList,
        ];

        return memoInfos;
      } else {
        return [];
      }
    });

// final unitListProvider = FutureProvider.autoDispose<List<GeneralIdSlugModel>>((ref) async {
//   List<GeneralIdSlugModel> list = [];
//   List<Module> module = await ModuleServices().getModuleModelList();
//   if (module.isNotEmpty) {
//     list = await ProductCategoryServices().getProductCategoryModelList(module[0].id);
//   }
//   return list;
// });

// =========================== qc =========================
final maxQCProvider = StateProvider<double>((ref) => 0.0);
final finalQcInfoListProvider =
    StateProvider.autoDispose<Map<int, List<SelectedQCInfoModel>>>((ref) => {});
final selectedQCInfoListProvider = StateProvider<List<SelectedQCInfoModel>>(
  (ref) => [],
);
// final qcProductsProvider = FutureProvider<List<List<ProductDetailsModel>>>((ref) async {
//   List<List<ProductDetailsModel>> skuList = [];
//   List<Module> moduleList = await SyncReadService().getModuleModelList();
//   QcConfigurationModel configuration = await SalesService().getQcConfigurations();
//   for (Module module in moduleList) {
//     if (configuration.availableModules.contains(module.id)) {
//       List<ProductDetailsModel> productDetailsModelList = await ProductCategoryServices().getProductDetailsList(module);
//       skuList.add(productDetailsModelList);
//     }
//   }
//   return skuList;
// });
final qcSKUListProvider =
    StateNotifierProvider.autoDispose<
      QCSKUNotifier,
      AsyncValue<List<ProductDetailsModel>>
    >((ref) => QCSKUNotifier());
final totalQCQuantityProvider = StateProvider.autoDispose<int>((ref) {
  int totalQC = 0;
  List<SelectedQCInfoModel> list = ref.watch(selectedQCInfoListProvider);
  for (SelectedQCInfoModel qc in list) {
    for (QCInfoModel qcInfo in qc.qcInfoList) {
      totalQC += qcInfo.totalQuantity();
    }
  }
  return totalQC;
});
final qcValueProvider = FutureProvider.autoDispose<double>((ref) async {
  double totalQCValue = 0.0;
  List<SelectedQCInfoModel> list = ref.watch(selectedQCInfoListProvider);
  for (SelectedQCInfoModel qc in list) {
    int totalQC = 0;
    for (QCInfoModel qcInfo in qc.qcInfoList) {
      totalQC = qcInfo.totalValidQCQuantity();
      totalQCValue += await PriceServices().getQcSkuPriceForASpecificAmount(
        qc.sku,
        qc.retailer,
        totalQC,
      );
    }
  }
  ref.read(qcDoneProvider.state).state = totalQCValue;
  return totalQCValue;
});

final qcDoneProvider = StateProvider<double>((ref) => 0);

final selectedProductForQCProvider = StateProvider<ProductDetailsModel?>(
  (ref) => null,
);

final prevQCAmountProvider = StateProvider<double>((ref) => 0.0);
final qcInfoProvider = FutureProvider.family
    .autoDispose<List<QCInfoModel>, String>((ref, moduleId) async {
      List<QCInfoModel> qcInfoList = await SalesService().getQCInfo(moduleId);
      return qcInfoList;
    });

final qcConfigurationProvider =
    FutureProvider.autoDispose<QcConfigurationModel>((ref) async {
      return await SalesService().getQcConfigurations();
    });

/// ==================================== Sales Summary ====================================
final salesSummaryProvider = FutureProvider.autoDispose
    .family<Map<String, List<SalesSummaryModel>>, SaleType>((
      ref,
      saleType,
    ) async {
      Map<String, List<SalesSummaryModel>> summaryData = await SalesService()
          .getSalesSummaryData(saleType: saleType);
      // List<SalesSummaryModel> summaryList = await SalesService().getSalesSummaryData();
      return summaryData;
      // return summaryList;
    });
final totalRetailerProvider = FutureProvider.autoDispose.family<int, SaleType>((
  ref,
  saleType,
) async {
  return await SalesService().getTotalRetailer(saleType: saleType);
});
final moduleByIdProvider = FutureProvider.family<Module, String>((
  ref,
  id,
) async {
  return await SyncReadService().getModuleById(id);
});
final totalSaleDiscountOthersProvider = FutureProvider.family
    .autoDispose<num, int>((ref, moduleId) async {
      SaleDataModel totalSaleDiscountOthers = await TradePromotionServices()
          .getTotalDiscountForAModule(moduleId);
      print("totalPrice ${totalSaleDiscountOthers.price}");
      return totalSaleDiscountOthers.price;
    });
final totalSaleSummaryProvider = StateProvider.autoDispose<double>(
  (ref) => 0.0,
);
final grandTotalSaleSummaryProvider = StateProvider.autoDispose<double>(
  (ref) => 0.0,
);
final totalDiscountSaleSummaryProvider = StateProvider.autoDispose<double>(
  (ref) => 0.0,
);

/// =================== Sale Submit ========================
final saleSummaryServerDataProvider = StateProvider.autoDispose<Map>(
  (ref) => {},
);
final syncDataProgressProvider = StateProvider.autoDispose<int>((ref) => 0);
final saleSubmitButtonProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);

//=========================== APP update provider =======================
final apkUpdateProgressProvider = StateProvider.autoDispose<int>((ref) => 0);

//========================== Delivery Providers =========================
final deliveryOutletListProvider =
    StateNotifierProvider.autoDispose<
      DeliveryOutletListNotifier,
      AsyncValue<List<OutletModel>>
    >((ref) => DeliveryOutletListNotifier(ref));
final assetOutletListProvider =
    StateNotifierProvider.autoDispose<
      RequisitionOutletListNotifier,
      AsyncValue<List<RetailersModel>>
    >((ref) => RequisitionOutletListNotifier(ref));
final preorderPerRetailerProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
      OutletModel? retailer = ref.read(selectedRetailerProvider);
      Module? module = ref.read(selectedSalesModuleProvider);
      module ??= (await ModuleServices().getModuleModelList()).first;
      if (retailer != null) {
        return await PreOrderService().getPreOrderPerRetailer(
          retailer.id ?? 0,
          module.id,
        );
      } else {
        return {};
      }
    });
final getSkuPriceProvider = FutureProvider.autoDispose
    .family<double, OutletModel>((ref, outlet) async {
      return await ProductCategoryServices().getDeliveryDetailsPrice(outlet);
    });

final selectedMultiOutletProvider =
    StateProvider.autoDispose<List<OutletModel>>((ref) => []);
// final selectedUnitProvider = StateProvider<GeneralIdSlugModel?>((ref) => null);
// final selectedEditedUnitProvider = StateProvider<GeneralIdSlugModel?>((ref) => null);
// final skuCasePieceCountProvider = StateProvider.autoDispose.family<String, ProductDetailsModel>((ref, sku) => "০ কেস, ০ পিস");
// final skuCasePieceEditedCountProvider = StateProvider.autoDispose.family<String, ProductDetailsModel>((ref, sku) => "০ কেস, ০ পিস");
// ======================== cooler image ========================================
final coolerImagePathProvider = StateProvider<String>((ref) => "");
final stockCheckImagePathProvider = StateProvider<String>((ref) => "");
final previewImageProvider = StateProvider<File?>((ref) => null);

//====================== Preorder category filter ==============================
final preorderFilterModelProvider =
    FutureProvider.autoDispose<List<PreorderCategoryFilterButtonType>>(
      (ref) async => PreOrderService().getPreorderFilterModel(),
    );
final selectedPreorderFilterTypeProvider =
    StateProvider.autoDispose<PreorderCategoryFilterButtonType>(
      (ref) => PreorderCategoryFilterButtonType.all,
    );

/// ========================= target and achievements =======================
final enabledModuleListProvider = FutureProvider.autoDispose<List<Module>>((
  ref,
) async {
  return await SrTargetServices().getEnabledSbuModelList();
});
final targetReachedProvider = StateProvider<bool>((ref) => false);
final targetDetailTabList = FutureProvider.autoDispose.family<List, int>((
  ref,
  moduleId,
) async {
  return SrTargetServices().getDetailsTabList(moduleId);
});
final targetDetailTabListStr = FutureProvider.autoDispose<List>((ref) async {
  return ["STT"];
});
final tabTypeProvider = FutureProvider.autoDispose
    .family<String, Map<String, String>>((ref, data) async {
      return await SrTargetServices().getTargetType(
        data["moduleId"]!,
        data["label"]!,
      );
    });

final tabAchievementRateProvider = StateProvider.family<double, String>(
  (ref, label) => 0.0,
);
final tabTargetRateProvider = StateProvider.family<double, String>(
  (ref, label) => 0.0,
);

final sttByTypeProvider = FutureProvider.autoDispose
    .family<List<SRDetailTargetModel>, int>((ref, moduleId) async {
      return await SrTargetServices().getSTTTargetForASpecificModule(moduleId);
    });

final specialSttByTypeProvider = FutureProvider.autoDispose
    .family<List<SRDetailTargetModel>, int>((ref, moduleId) async {
      return await SrTargetServices().getSTTSpecialTargetForASpecificModule(
        moduleId,
      );
    });
final bcpByTypeProvider = FutureProvider.autoDispose
    .family<List<SRDetailTargetModel>, int>((ref, moduleId) async {
      return await SrTargetServices().getBCPTargetForASpecificModule(moduleId);
    });
final dashboardTargetList = FutureProvider.autoDispose
    .family<List<DashboardTargetModel>, int>((ref, moduleId) async {
      return await SrTargetServices().getDashBoardTarget(moduleId);
    });

final dashBoardSaleTypeProvider = StateProvider.autoDispose(
  (ref) => SaleType.preorder,
);

final dashboardTargetListFullValue = FutureProvider.autoDispose
    .family<List<DashboardTargetModelOverall>, int>((ref, moduleId) async {
      return await SrTargetServices().getDashBoardTargetFullValue(moduleId);
    });
// ========================= attendance ====================================
final currentAddressProvider =
    FutureProvider.autoDispose<LocationAddressModel<Placemark?>?>(
      (ref) async =>
          await AttendanceLocationService().getCurrentLocationAndAddress(),
    );
final getDistanceProvider = FutureProvider.autoDispose
    .family<num?, AttendanceProviderModel>(
      (ref, data) async =>
          await LocationService(data.context).getDistance(data.lat, data.long),
    );

final attendanceSelfiePathProvider = StateProvider.autoDispose<String>((ref) => "");

final attendanceDateTimeProvider = StateProvider.autoDispose<DateTime>(
  (ref) => DateTime.now(),
);

final attendanceStatusCheckProvider =
    FutureProvider.autoDispose<AttendanceModel>((ref) async {
      if (await ConnectivityService().checkInternet()) {
        return await AttendanceAPI().getAttendanceStatus(DateTime.now());
      }
      return AttendanceModel(id: -1, status: AttendanceStatus.attendanceDone);
    });
// ============================ change route ==========================================
final selectedDateChangeRouteProvider = StateProvider.autoDispose<DateTime>(
  (ref) => DateTime.now(),
);
final checkIfChangeRouteEnabledProvider = FutureProvider.autoDispose<bool>(
  (ref) async => await ChangeRouteService().checkIfJourneyChangeEnabled(),
);
final checkIfChangeRouteRequestedProvider = FutureProvider.autoDispose<bool>(
  (ref) async => await ChangeRouteService().checkIfBreakdownEnabled(),
);
final getALlRouteListProvider =
    FutureProvider.autoDispose<List<JourneyChangeRouteModel>>(
      (ref) async => await ChangeRouteService().getRouteListForJourneyChange(),
    );
final selectedRouteProvider =
    StateProvider.autoDispose<JourneyChangeRouteModel?>((ref) => null);

//========================== selected dependent discounts ========================
final selectedDependentDiscountsProvider =
    StateProvider.autoDispose<List<AppliedDiscountModel>>((ref) => []);
final totalDiscountCalculationProvider = Provider.autoDispose
    .family<SaleDataModel, List<AppliedDiscountModel>>((ref, discounts) {
      List<AppliedDiscountModel> appliedDiscounts = ref.watch(
        selectedDependentDiscountsProvider,
      );
      int totalQty = 0;
      num totalPrice = 0;
      if (discounts.isNotEmpty) {
        for (AppliedDiscountModel discount in discounts) {
          if (!discount.promotion.isDependent) {
            if (discount.promotion.isFractional == true) {
              totalPrice += discount.appliedDiscount ?? 0;
              totalQty +=
                  (discount.skuWiseAppliedDiscountAmount.first.discountAmount ??
                          0)
                      .toInt();
            } else {
              if (discount.promotion.payableType ==
                      PayableType.productDiscount ||
                  discount.promotion.payableType == PayableType.gift) {
                totalQty += (discount.appliedDiscount.toInt());
              } else {
                if ((discount.promotion.rules?.isNotEmpty ?? false) &&
                    (discount.promotion.payableType ==
                        PayableType.absoluteCash)) {
                  totalPrice += discount.appliedDiscount;
                } else {
                  totalPrice += discount.appliedDiscount;
                }
                print(
                  'discount for this promotion-=>2 ${totalPrice} : ${discount.appliedDiscount}',
                );
              }
            }
          }
        }

        if (appliedDiscounts.isNotEmpty) {
          for (AppliedDiscountModel discount in appliedDiscounts) {
            if (discount.promotion.isDependent) {
              if (discount.promotion.payableType ==
                      PayableType.productDiscount ||
                  discount.promotion.payableType == PayableType.gift) {
                totalQty += (discount.appliedDiscount.toInt());
              } else {
                if ((discount.promotion.rules?.isNotEmpty ?? false) &&
                    (discount.promotion.payableType ==
                        PayableType.absoluteCash)) {
                  totalPrice +=
                      discount.appliedDiscount /
                      discount.promotion.discountSkus.length;
                } else {
                  totalPrice += discount.appliedDiscount;
                }
              }
            }
          }
        }
      }

      return SaleDataModel(qty: totalQty, price: totalPrice);
    });

// ========================= leave management ===========================================
final selectedLeaveManagementTypeProvider =
    StateProvider.autoDispose<LeaveManagementType>(
      (ref) => LeaveManagementType.movement,
    );
final updatedMovementProvider = StateProvider.autoDispose<LeaveManagementData?>(
  (ref) => null,
);
final leaveDataProvider = FutureProvider.autoDispose<LeaveManagementModel>(
  (ref) async => await LeaveManagementAPI().getLeaveData(),
);
final movementDataProvider = FutureProvider.autoDispose<LeaveManagementModel>(
  (ref) async => await LeaveManagementAPI().getMovementData(),
);
final taDaDataProvider = FutureProvider.autoDispose<List<CreatedTaDaModel>>(
  (ref) async => await LeaveManagementAPI().getTaDaData(),
);
final selectedLeaveTypeProvider =
    StateProvider.autoDispose<LeaveManagementTypes?>((ref) => null);
final selectedMovementTypeProvider =
    StateProvider.autoDispose<LeaveManagementTypes?>((ref) => null);
final selectedLeaveDateRangeProvider =
    StateProvider.autoDispose<DateTimeRange?>((ref) => null);
final selectedMovementDateRangeProvider = StateProvider.autoDispose<DateTime?>(
  (ref) => null,
);
final leaveCalenderDataProvider = FutureProvider.autoDispose
    .family<Map, String>((ref, key) async {
      int month = 0;
      int year = 0;
      try {
        month = int.tryParse(key.split('_')[0]) ?? 0;
        year = int.tryParse(key.split('_')[1]) ?? 0;
      } catch (error, stck) {
        debugPrint(error.toString());
        debugPrint(stck.toString());
      }
      return await LeaveManagementAPI().getLeaveCalenderData(
        date: DateTime(year, month),
      );
    });

// ============================= asset management =====================================
final selectedAssetActivityProvider = StateProvider.autoDispose<String?>(
  (ref) => "Requisition",
);
final selectedOutletAssetProvider = StateProvider.autoDispose<OutletModel?>(
  (ref) => null,
);
final selectedAssetTypeProvider =
    StateProvider.autoDispose<GeneralIdSlugModel?>((ref) => null);
final selectedSoRetailerProvider = StateProvider.autoDispose<RetailersModel?>(
  (ref) => null,
);
final selectedCoolerLightBoxTypeProvider =
    StateProvider.autoDispose<GeneralIdSlugModel?>((ref) => null);
final selectedLightBoxBillTypeProvider = StateProvider.autoDispose<String?>(
  (ref) => null,
);
final getSoRetailerListProvider = FutureProvider<List<RetailersModel>>((
  ref,
) async {
  List<RetailersModel> retailers = await AssetManagementService()
      .getSoRetailerListProvider();
  ref.read(selectedSoRetailerProvider.notifier).state = retailers.first;
  return retailers;
});

final getTSMRetailerListProvider =
    FutureProvider.family<List<RetailersModel>, AssetInstallPullOutGetModel>((
      ref,
      data,
    ) async {
      print('data is:: ${data.hashCode}');
      List<int> outletIds = await AssetManagementAPI().getTSMRetailerList(data);
      List<RetailersModel> retailers = await AssetManagementService()
          .getTSMRetailerListProvider(outletIds: outletIds);
      ref.read(selectedSoRetailerProvider.notifier).state = retailers.first;
      return retailers;
    });

final getAssetTypeListProvider =
    FutureProvider.autoDispose<List<GeneralIdSlugModel>>((ref) async {
      List<GeneralIdSlugModel> assetTypeList = await AssetManagementService()
          .getAssetTypeList();
      ref.read(selectedAssetTypeProvider.notifier).state = assetTypeList.first;
      return assetTypeList;
    });

final getCoolerPullOutReasonProvider = FutureProvider.autoDispose<List<String>>(
  (ref) async {
    List<String> assetTypeList = await AssetManagementService()
        .getCoolerPullOutReasonList();
    return assetTypeList;
  },
);
final getCoolerTypeListProvider =
    FutureProvider.autoDispose<List<GeneralIdSlugModel>>((ref) async {
      List<GeneralIdSlugModel> coolerTypeList = await AssetManagementService()
          .getAssetCoolerTypeList();
      return coolerTypeList;
    });
final getLightBoxTypeListProvider =
    FutureProvider.autoDispose<List<GeneralIdSlugModel>>((ref) async {
      List<GeneralIdSlugModel> coolerTypeList = await AssetManagementService()
          .getAssetLightBoxTypeList();
      return coolerTypeList;
    });
final getLightBoxBillTypeProvider = FutureProvider.autoDispose<List<String>>((
  ref,
) async {
  List<String> coolerTypeList = await AssetManagementService()
      .getLightBoxBillCategory();
  return coolerTypeList;
});
final selectedAssetPlacementProvider = StateProvider.autoDispose<String?>(
  (ref) => null,
);
final selectedAssetCoverProvider = StateProvider<String?>((ref) => null);
final selectedCoolerAssetPullOutReasonProvider =
    StateProvider.autoDispose<String?>((ref) => null);
final selectedCurrentBrandingProvider = StateProvider.autoDispose<String?>(
  (ref) => null,
);
final competitorAssetProvider =
    FutureProvider.autoDispose<List<GeneralIdSlugModel>>((ref) async {
      List<GeneralIdSlugModel> coolerList = await OutletServices()
          .getCoolerList();
      for (GeneralIdSlugModel coolers in coolerList) {
        if (coolers.slug == "AFBL") {
          coolerList.remove(coolers);
          break;
        }
      }
      return coolerList;
    });
final selectedCompetitorAssetProvider =
    StateProvider.autoDispose<List<GeneralIdSlugModel>>((ref) => []);

final getAssetRequisitionListByOutletIdProvider = FutureProvider.autoDispose
    .family<List<AssetRequisitionModel>, int>(
      (ref, id) async =>
          await AssetManagementAPI().getAssetRequisitionByOutletId(id),
    );
final selectedAssetRequisitionProvider =
    StateProvider.autoDispose<AssetRequisitionModel?>((ref) => null);
final selectedAssetPullInProvider =
    StateProvider.autoDispose<AssetPullOutModel?>((ref) => null);
final getAssetPullInListByOutletIdProvider = FutureProvider.autoDispose
    .family<List<AssetPullOutModel>, String>(
      (ref, outletCode) async =>
          await AssetManagementAPI().getAssetPullInByOutletCode(outletCode),
    );
final selectedCasePieceTypeProvider = StateProvider.autoDispose<CasePieceType>(
  (ref) => CasePieceType.CASE,
);

// Provider for selected SKU unit configuration (for dynamic unit selection)
final selectedSkuUnitConfigProvider = StateProvider.autoDispose.family<SkuUnitItem?, ProductDetailsModel>((ref, sku) {
  // Default to first unit config if available
  if (sku.unitConfig.isNotEmpty) {
    return sku.unitConfig.first;
  }
  return null;
});

// =============================================== tsm ===============================
final getSrChangeRouteListForTSMProvider =
    FutureProvider.autoDispose<List<ChangeRouteTSMModel>>(
      (ref) async => await TSMAPI().getTSMChangeRouteList(),
    );
final getSrLeaveMovementListForTSMProvider =
    FutureProvider.autoDispose<List<LeaveMovementManagementModelForTSM>>(
      (ref) async => await TSMAPI().getTSMLeaveMovementReqList(),
    );

/// =================== Internet Connectivity ========================

final salesEntryLoadingProvider = StateProvider.autoDispose<bool>(
  (ref) => true,
);

// final getCoolerTypeListProvider2 = FutureProvider.autoDispose<List<GeneralIdSlugModel>>((ref) async {
//   List<GeneralIdSlugModel> coolerTypeList = await AssetManagementService().getAssetCoolerTypeList();
//   return coolerTypeList;
// });
//
// final selectedCompetitorAssetProviderTest = StateProvider.autoDispose<List<GeneralIdSlugModel>>((ref) => []);
// ref.read(selectedCompetitorAssetProvider.notifier).state = [...coolerList];

final selectedSlabPromotion =
    StateProvider.autoDispose<List<SlabPromotionSelectionModel>>((ref) => []);

final slabPromotionDiscount = StateProvider.autoDispose<num>((ref) => 0);

final beforeSelectedSlabPromotion = StateProvider<List<int>>((ref) => []);

final beforeSelectedQpsPromotion = StateProvider<List<int>>((ref) => []);
final beforeSuggestedQpsPromotion = StateProvider<List<int>>((ref) => []);

final getRoRequisitionProvider = FutureProvider.autoDispose
    .family<List<PreviousRequisition>, String>(
      (ref, depId) async =>
          await AssetManagementAPI().getRoAssetRequisitions(depId),
    );

final getAllMaintenanceList =
    FutureProvider.autoDispose<List<MaintenanceModel>>(
      (ref) async => await AssetManagementAPI().assetMaintenanceList(),
    );

///friday sell demo provider
///

final getBrandsListProvider = FutureProvider.autoDispose<List<BrandModel>>((
  ref,
) async {
  List<BrandModel> assetTypeList = await PosmManagementService().getBrandList();
  return assetTypeList;
});

final getPosmTypesProvider = FutureProvider.family
    .autoDispose<List<PosmTypeModel>, int>((ref, brandId) async {
      List<PosmTypeModel> assetTypeList = await PosmManagementService()
          .getPosmTypeList(brandId: brandId);
      return assetTypeList;
    });

final allocatedPOSMListProvider = FutureProvider.autoDispose<List<String>>((
  ref,
) async {
  List<String> assetTypeList = await PosmManagementService()
      .allocatedPOSMList();
  return assetTypeList;
});

final selectedBrandProvider = StateProvider.autoDispose<BrandModel?>(
  (ref) => null,
);

final selectedPosmTypeProvider = StateProvider.autoDispose<PosmTypeModel?>(
  (ref) => null,
);

final getAllBillList = FutureProvider.autoDispose<List<BillDataModel>>(
  (ref) async => await BillAPI().billListAPI(),
);

//digital learning
final getAllDigitalLearnings =
    FutureProvider.autoDispose<List<DigitalLearningItem>>(
      (ref) async => await DigitalLearningService().getDigitalLearningsList(),
    );

final getDigitalSurveyInfo = FutureProvider.family
    .autoDispose<SurveyModel?, DigitalLearningItem>((ref, survey) async {
      return await SurveyService().getDigitalLearningSurveyInfo(
        survey.surveyId,
      );
    });

final visibleCoupon = StateProvider.autoDispose<bool>((ref) => false);

final couponDiscountProvider = StateProvider<num?>((ref) => null);

final disableEditForCouponDiscountProvider = FutureProvider.family
    .autoDispose<bool, OutletModel>((ref, outlet) async {
      return await CouponService().checkRetailerAlreadyUseCoupon(
        retailer: outlet,
      );
    });

final allOutletLastGeoProvider = FutureProvider.family.autoDispose<int, bool>((
  ref,
  inside25m,
) async {
  List list = await OfflinePdaService().getLastGeoData();
  int totalCount = 0;
  for (var val in list) {
    if (val['distance'] <= 25 && inside25m == true) {
      totalCount++;
    } else if (val['distance'] >= 25 && inside25m == false) {
      totalCount++;
    }
  }

  return totalCount;
});

final allTryBeforeBuySkuForSpecificRetailer = FutureProvider.autoDispose
    .family<List<TryBeforeBuyModel>, OutletModel>((ref, outlet) async {
      List<PromotionModel> allTryBeforeBuy = await TryBeforeBuyService()
          .getAllAvailableTryBeforeBuyForARetailer(outlet);
      List<TryBeforeBuyModel> list = [];

      for (var tryBeforeBuy in allTryBeforeBuy) {
        List<ProductDetailsModel> skuList = await TryBeforeBuyService()
            .getAllAvailableSkuForThisTryBeforeBuy(
              tryBeforeBuy: tryBeforeBuy,
              retailer: outlet,
            );

        for (var sku in skuList) {
          list.add(TryBeforeBuyModel(tryBeforeBuy: tryBeforeBuy, sku: sku));
        }
      }

      return list;
    });

final selectedTryBeforeBuyProvider =
    StateProvider.autoDispose<List<TryBeforeBuyModel>>((ref) => []);

// final digitalLearningDummyProvider = StateProvider<Map<String, bool>>((ref) => {'0': true, '1': false});

final selectedDeliverySummary = StateProvider<int>((ref) => 1);

final deliverySummaryProvider =
    FutureProvider.autoDispose<List<DeliverySummaryModel>>((ref) async {
      List<DeliverySummaryModel> list = [];
      DeliveryServices deliveryServices = DeliveryServices();
      var l = await deliveryServices.deliverySummary();
      list.addAll(l.reversed.toList());
      if (list.length == 1) {
        ref.read(selectedDeliverySummary.notifier).state = 0;
      }
      return list;
    });

final selectedDateRangeProvider = StateProvider.autoDispose<DateTimeRange>((
  ref,
) {
  DateTime now = DateTime.now();
  // return DateTimeRange(start: DateTime(now.year, now.month, 1), end: DateTime(now.year, now.month, DateTime(now.year, now.month + 1, 0).day));
  return DateTimeRange(
    start: DateTime(now.year, now.month - 1, 26),
    end: DateTime(now.year, now.month, 25),
  );
});

final fullMonthPjpPlanProvider =
    FutureProvider.autoDispose<List<PJPPlanDetails>>((ref) async {
      List<PJPPlanDetails> list = [];
      final selectedPickedDateRange = ref.watch(selectedDateRangeProvider);
      var l = await PjpPlanAPI().getFullMonthPjpPlanAPI(
        startDate: selectedPickedDateRange.start,
        endDate: selectedPickedDateRange.end,
      );
      if (l.status == ReturnedStatus.success) {
        List<PJPPlanDetails> allPjp = PJPPlanService()
            .getPjpPlanListFromResponse(data: l.data["data"]);
        list.addAll(allPjp);
      }
      return list;
    });

final vehicleCostListProvider =
    FutureProvider.autoDispose<List<TaDaVehicleModel>>((ref) async {
      final list1 = await TaDaService().vehicleTypeList();
      final list2 = await TaDaService().otherTypeList();
      return [...list1, ...list2];
    });

final draftedTaDaProvider = FutureProvider.autoDispose<DraftedTaDaData?>((
  ref,
) async {
  final list1 = await OlympicTaDaService().getDraftTaDa();
  return list1;
});
final selectedVehicleTypeProvider =
    StateProvider.autoDispose<TaDaVehicleModel?>((ref) => null);

// final selectedVehicleListTypeProvider = StateProvider.autoDispose<List<SelectedVehicleWithTaDa>>((ref) => []);

final selectedVehicleListTypeProvider =
    StateNotifierProvider.autoDispose<
      VehicleTaDaNotifier,
      List<SelectedVehicleWithTaDa>
    >((ref) => VehicleTaDaNotifier(ref));

final selectedOtherCostListTypeProvider =
    StateNotifierProvider.autoDispose<
      OtherVehicleTaDaNotifier,
      List<SelectedVehicleWithTaDa>
    >((ref) => OtherVehicleTaDaNotifier(ref));

final otherCostListProvider =
    FutureProvider.autoDispose<List<TaDaVehicleModel>>((ref) async {
      return await TaDaService().otherTypeList();
    });
final selectedOtherCostTypeProvider =
    StateProvider.autoDispose<TaDaVehicleModel?>((ref) => null);

final assetFieldErrorProvider = StateProvider.autoDispose
    .family<bool, RequisitionField>((ref, type) => false);

/// Team performance target vs achievement
final targetAchievementListProvider =
    FutureProvider.autoDispose<List<CompletePerformanceModel>>((ref) async {
      return await TeamPerformanceService().getAllDsrWisePerformanceData();
    });

final sectionListProvider = FutureProvider.autoDispose(
  (ref) async => await LocationCategoryServices().getSectionList(),
);

final plainRetailerListProvider = FutureProvider.autoDispose
    .family<List<OutletModel>, bool>((ref, forMemo) async {
      List<OutletModel> mainRetailerList = [];
      Map m = await SyncReadService().getRetailerModelListBySection(
        section: null,
        isMemoPage: forMemo,
      );
      mainRetailerList = m['retailer'];
      List<OutletModel> retailer = [];
      retailer = mainRetailerList;
      return retailer;
    });

final promotionListProvider = FutureProvider.autoDispose
    .family<List<PromotionModel>, Map<int, Map<dynamic, dynamic>>?>((
      ref,
      promotion,
    ) async {
      log('promotion!=nullpromotion!=null :: ${promotion == null}');
      final allPromotions = promotion == null
          ? await PromotionServices().getAllPromotions()
          : await PromotionServices().getPromotionsById(promotion);

      /// here filter promotions by their title as there could be
      /// duplicate promotion title available due to threshold promotion
      final titleWise = <String, PromotionModel>{};

      for (var pro in allPromotions) {
        titleWise[pro.label] = pro;
      }

      return titleWise.values.toList();
    });

final allRoutesNameProvider = FutureProvider.autoDispose
    .family<List<String>, List<int>>((ref, routes) async {
      return await LocationCategoryServices().getRetailerAllRoutesName(routes);
    });

final saleDashboardMenuProvider = FutureProvider.autoDispose
    .family<List<SaleDashboardCategoryModel>, OutletModel>((
      ref,
      retailer,
    ) async {
      List<SaleDashboardCategoryModel> list = [];
      var l = await SalesDashboardService()
          .checkAllMenuAvailableForSaleDashboard(retailer);
      list.addAll(l);
      return list;
    });

final saleDashboardDeliverySyncProvider = FutureProvider.autoDispose<bool>((
  ref,
) async {
  bool deliveryAvailable = await SalesDashboardService()
      .getButtonVisibilityAsync(type: SaleDashboardType.delivery);
  OutletSaleStatus geoFencingStatus = ref.watch(outletSaleStatusProvider);
  if (geoFencingStatus == OutletSaleStatus.showSkus && deliveryAvailable) {
    return true;
  }
  return false;
});

final salesPreorderModuleIdProvider = FutureProvider.autoDispose
    .family<SalesPreorderConfigurationModel, int?>((ref, retailerId) async {
      return await PreOrderService().getModulesAvailableForPreOrder(retailerId);
    });

final selectedSectionProvider = StateProvider.autoDispose<SectionModel?>(
  (ref) => null,
);

final cameraPermissionProvider = FutureProvider.autoDispose<bool>((ref) async {
  return PermissionService().getCameraPermission();
});

final saleDateProvider = FutureProvider.autoDispose<String>((ref) async {
  return SyncReadService().getSalesDate();
});

final printerConnectedProvider = StateProvider<PrinterStatus>(
  (ref) => PrinterStatus.disconnected,
);

/// print memo providers
final selectedPrintMemoDateProvider = StateProvider.autoDispose<DateTime>(
  (ref) => DateTime.now(),
);

final loadSummaryListProvider =
    FutureProvider.autoDispose<List<LoadSummaryModel>>((ref) async {
      final date = ref.watch(selectedPrintMemoDateProvider);
      return await PrintMemoService().getLoadSummary(date: date);
    });

final loadSummaryDetailsProvider = FutureProvider.autoDispose
    .family<Map<String, List<LoadSummaryDetails>>, LoadSummaryModel>((
      ref,
      loadSummary,
    ) async {
      final date = ref.watch(selectedPrintMemoDateProvider);
      return await PrintMemoService().getLoadSummaryDetails(
        loadSummary: loadSummary,
        date: date,
      );
    });

final printingMemoByOutletProvider = FutureProvider.autoDispose
    .family<List<RetailerWiseMemoData>, List<LoadSummarySkus>?>((
      ref,
      loadSummary,
    ) async {
      return await PrintMemoService().printingMemoByOutlet(
        loadSumSku: loadSummary,
      );
    });

final skuDetailsProvider = FutureProvider.autoDispose
    .family<ProductDetailsModel?, int>((ref, skuId) async {
      return await ProductCategoryServices().getSkuDetailsFromSkuId(skuId);
    });

final productStockProvider = StateNotifierProvider.family
    .autoDispose<ProductStockNotifier, StockModel, ProductDetailsModel>((
      ref,
      sku,
    ) {
      return ProductStockNotifier(sku, false);
    });

final productStockEditProvider = StateNotifierProvider.family
    .autoDispose<ProductStockNotifier, StockModel, ProductDetailsModel>((
      ref,
      sku,
    ) {
      return ProductStockNotifier(sku, true);
    });

final selectedStockSkuCount = StateProvider.family<int, ProductDetailsModel>((
  ref,
  sku,
) {
  if (sku.stocks.currentStock != 0) {
    // int addedAmount = sku.unitConfig[sku.increasedId] as int;
    int addedAmount = 1;
    int pack = sku.stocks.liftingStock ~/ addedAmount;
    if (currentStockData.containsKey(sku.module.id)) {
      if (currentStockData[sku.module.id].containsKey(sku.id)) {
        pack = currentStockData[sku.module.id][sku.id] ~/ addedAmount;
      }
    }
    return pack;
  }
  return 0;
});

final stockAllocationProvider = FutureProvider.autoDispose.family<int?, int>(
  (ref, skuId) async => await StockService().getStockAllocationAmount(skuId),
);

/// =================== pre order ========================
final preorderProvider = FutureProvider.autoDispose<Map<String, int>>((
  ref,
) async {
  return await PreOrderService().getPreOrderStock();
});

final totalIssuedProvider = StateProvider.family<int, int>(
  (ref, moduleId) => 0,
);

final stockProductListFutureProvider = FutureProvider.family
    .autoDispose<Map<String, List<ProductDetailsModel>>, Module>((
      ref,
      module,
    ) async {
      List<ProductDetailsModel> list = await ProductCategoryServices()
          .getProductDetailsList(module);
      for (var sku in list) {
        if (sku.stocks.currentStock != 0) {
          ref.read(selectedStockSkuCount(sku).notifier).state == 30;
        }
      }
      final result = {'All': list};

      for (var p in list) {
        final classification = p.filterType;
        result.putIfAbsent(classification, () => []);
        result[classification]!.add(p);
      }
      return result;
    });

final stockPageProvider = StateProvider.autoDispose<int>((ref) => 0);

final moduleNameProvider = FutureProvider.family<Module, String>(
  (ref, id) => SyncReadService().getModuleById(id),
);

final totalStockedProvider = StateProvider.family<int, int>(
  (ref, moduleId) => 0,
);

final totalIssuedFutureProvider = FutureProvider.autoDispose<void>((ref) async {
  Map modules = await SyncReadService().getModuleList();
  modules.forEach((key, value) async {
    StockModel currentTotalStocks = await StockService()
        .getCurrentTotalStocksByModuleId(value['slug']);
    ref.read(totalIssuedProvider((int.parse(key))).state).state =
        currentTotalStocks.liftingStock;
    ref.read(totalStockedProvider((int.parse(key))).state).state =
        currentTotalStocks.currentStock;
  });

  return;
});

final saleModulePrimaryUnitNameProvider = FutureProvider.family<String, int>((
  ref,
  moduleId,
) {
  return SyncReadService().getModulePrimaryUnitName(moduleId);
});

final isStockSavedProvider = StateProvider<bool>((ref) => true);

final selectedStockEditCount = StateProvider.family
    .autoDispose<int, ProductDetailsModel>((ref, sku) {
      int count = ref.read(selectedStockSkuCount(sku));
      return count;
    });

final stockListProvider = StateProvider<List<ProductDetailsModel>>((ref) => []);
final stockAnalyticProvider = FutureProvider.family
    .autoDispose<Map<String, dynamic>, int>((ref, skuID) async {
      return await StockService().getSkuAnalyticalDataForStock(skuID);
    });

final recentSearchListProvider = FutureProvider.autoDispose<List<String>>((
  ref,
) async {
  return await SearchHistoryDbService().getList();
});

/// ================= Resignation  ==============================
final selectedResignationDateProvider = StateProvider.autoDispose<DateTime>(
  (ref) => DateTime.now(),
);

/// ================= Transfer Bill  ==============================
final selectedTransferBillDateProvider = StateProvider.autoDispose<DateTime>(
  (ref) => DateTime.now(),
);

// selected image path (camera/gallery/file) for transfer bill
final selectedTransferBillImagePathProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);
final selectedTransferBillCashImagePathProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);
final selectedTransferBillImageServerPathProvider =
    StateProvider.autoDispose<String>((ref) => '');

// selected bill copy path (file picker only) for transfer bill
final selectedTransferBillCopyPathProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);
final selectedTransferBillCopyServerPathProvider =
    StateProvider.autoDispose<String>((ref) => '');

final salesSubmittedProvider = FutureProvider.autoDispose<bool>(
  (ref) async => await DayCloseService().checkServiceStatusForToday(),
);

final retailerImageProvider = FutureProvider.autoDispose.family<String, String>(
  (ref, imageName) async =>
      await OutletServices().getOutletImage(imageName: imageName),
);

final memoEditReasonsProvider =
    FutureProvider.autoDispose<List<EditReasonModel>>((ref) async {
      return SettingsService().getSaleResetReasons();
    });
final editReasonRemarkProvider = StateProvider<String?>((ref) => null);

final salesResetProvider = FutureProvider.autoDispose<bool>((ref) async {
  return await SettingsService().getSaleResetEligibility();
});

final selectedOlympicTaDaTypeProvider =
    StateNotifierProvider.autoDispose<
      OlympicTaDaNotifier,
      List<SelectedVehicleWithTaDaOlympic>
    >((ref) => OlympicTaDaNotifier(ref));

final extraTaDaForOlympicTaDaProvider =
    FutureProvider.autoDispose<List<ExtraTaDaType>>((ref) async {
      final list1 = await OlympicTaDaService().taDaVehicleTypeList();
      return list1;
    });

final fixedTaDaForOlympicTaDaProvider =
    FutureProvider.autoDispose<List<ExtraTaDaType>>((ref) async {
      final list1 = await OlympicTaDaService().fixedTaDaVehicleTypeList();
      return list1;
    });
