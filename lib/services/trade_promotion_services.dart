import 'dart:convert';
import 'dart:developer';

import '../constants/constant_keys.dart';
import '../constants/sync_global.dart';
import '../models/outlet_model.dart';
import '../models/products_details_model.dart';
import '../models/sales/formatted_sales_preorder_discount_data_model.dart';
import '../models/sales/sale_data_model.dart';
import '../models/slab_promotion_selection_model.dart';
import '../models/trade_promotions/applied_discount_model.dart';
import '../models/trade_promotions/promotion_model.dart';
import '../utils/promotion_utils.dart';
import '../utils/sales_type_utils.dart';
import 'helper.dart';
import 'price_services.dart';
import 'sync_service.dart';

class TradePromotionServices {
  final SyncService _syncService = SyncService();

  //Returns All available promotion for a retailer
  Future<List<PromotionModel>> getAllAvailablePromotionForARetailer(OutletModel retailer) async {
    List<PromotionModel> list = [];
    try {
      await _syncService.checkSyncVariable();
      Map promotionList = syncObj.containsKey("promotions") ? syncObj['promotions'] : {};
      if (retailer.availablePromotions.isNotEmpty) {
        retailer.availablePromotions.forEach((key, value) {
          if (promotionList.containsKey(key.toString())) {
            Map<String, dynamic> p = promotionList[key.toString()] as Map<String, dynamic>;
            list.add(PromotionModel.fromJson(p));
          }
        });
      }
    } catch (e) {
      Helper.dPrint("inside getAllAvailablePromotionForARetailer PromotionServices catch block $e");
    }
    return list;
  }

  List<PromotionModel> getAvailablePromotionForARetailerFromPromotions(OutletModel retailer, List<PromotionModel> allPromotions) {
    List<PromotionModel> list = [];
    try {
      if (retailer.availablePromotions.isNotEmpty) {
        retailer.availablePromotions.forEach((key, value) {
          if (allPromotions.isNotEmpty) {
            int a = allPromotions.indexWhere((e) => e.id == int.parse(key.toString()));
            if (a != -1) {
              list.add(allPromotions[a]);
            }
          }
        });
      }
    } catch (e) {
      Helper.dPrint("inside getAllAvailablePromotionForARetailer PromotionServices catch block $e");
    }
    return list;
  }

  //Get All Promotions for a specific sku and retailer
  Future<List<PromotionModel>> getPromotionPerSku(ProductDetailsModel sku, OutletModel retailer) async {
    List<PromotionModel> list = [];
    try {
      await _syncService.checkSyncVariable();
      Map promotionList = syncObj.containsKey("promotions") ? syncObj['promotions'] : {};

      if (retailer.availablePromotions.isNotEmpty) {
        retailer.availablePromotions.forEach((key, value) {
          if (promotionList.containsKey(key.toString())) {
            Map<String, dynamic> p = promotionList[key.toString()] as Map<String, dynamic>;
            if (p.containsKey("skus")) {
              if (p['skus'].isNotEmpty) {
                p["skus"].forEach((e) {
                  // Helper.dPrint('ASASASAS--->> ${p["payable_type"] != 'Try Before You Buy'}');
                  if (e["sku_id"] == sku.id && p["payable_type"] != 'Try Before You Buy') {
                    list.add(PromotionModel.fromJson(p));
                    return;
                  }
                });
              }
            }
          }
        });
      }
    } catch (e) {
      Helper.dPrint("inside getPromotionPerSku TradePromotionServices catch block $e");
    }

    return list;
  }

  // Get all promotions For a Retailer that are specifically combo or discount on entire memo
  Future<List<PromotionModel>> getComboAndEntireMemoPromotionForRetailer(OutletModel retailer) async {
    List<PromotionModel> list = [];
    try {
      await _syncService.checkSyncVariable();
      Map promotionList = syncObj.containsKey("promotions") ? syncObj['promotions'] : {};
      if (retailer.availablePromotions.isNotEmpty) {
        retailer.availablePromotions.forEach((key, value) {
          if (promotionList.containsKey(key.toString())) {
            Map<String, dynamic> p = promotionList[key.toString()] as Map<String, dynamic>;
            if ((p["discount_type"] == "Entire Memo" || p['skus'].length > 1) && DiscountTypeUtils.toType(p["discount_type"]) != DiscountType.qps && p["payable_type"] != 'Try Before You Buy') {
              list.add(PromotionModel.fromJson(p));
            }
          }
        });
      }
    } catch (e) {
      Helper.dPrint("inside getComboAndEntireMemoPromotionForRetailer TradePromotionServices catch block $e");
    }
    return list;
  }

  ///todo from delivery soledProductList is empty
  Future<List<AppliedDiscountModel>> getAppliedDiscountsForARetailer(
    OutletModel retailer,
    Map<int, SaleDataModel> counts,
    Map<int, ProductDetailsModel> skus,
    List<ProductDetailsModel> soledProductList,
    List<int> selectedBeforePromotions,
  ) async {
    List<AppliedDiscountModel> list = [];
    final specialPromotionsList = await getComboAndEntireMemoPromotionForRetailer(retailer);
    selectedBeforePromotions = specialPromotionsList.map((user) => user.id).toList();
    try {
      await _syncService.checkSyncVariable();
      List<PromotionModel> promotions = await getAllAvailablePromotionForARetailer(retailer);
      if (promotions.isNotEmpty) {
        for (PromotionModel promotion in promotions) {
          int multiplier = checkIfPrerequisiteMetForAPromotionToApply(promotion, counts, soledProductList);

          if (promotion.isFractional) {
            multiplier = 1;
          }

          if (multiplier > 0) {
            AppliedDiscountModel? discount;
            if (promotion.discountType == DiscountType.entireMemo) {
              discount = calculateAppliedDiscountForEntireMemo(multiplier, promotion, counts, skus);
            } else {
              discount = calculateAppliedDiscount(multiplier, promotion, counts, skus);
            }

            if (promotion.isFractional) {
              for (int a = 0; a != 2; a++) {
                if (a == 0) {
                  discount = calculateAppliedDiscount(
                    multiplier,
                    promotion,
                    counts,
                    skus,
                    isFractional: true,
                    fractionalType: a == 0 ? FractionalPromotion.number : FractionalPromotion.decimal,
                  );
                  if (discount != null) {
                    list.add(discount);
                  }
                } else {
                  discount = calculateAppliedDiscount(
                    multiplier,
                    promotion,
                    counts,
                    skus,
                    isFractional: true,
                    fractionalType: a == 0 ? FractionalPromotion.number : FractionalPromotion.decimal,
                  );
                  if (discount != null) {
                    list.last.appliedDiscount = discount.appliedDiscount;
                  }
                }
              }
            } else {
              if (discount != null) {
                if (promotion.rules?.isNotEmpty ?? false) {
                  if (selectedBeforePromotions.contains(promotion.id)) {
                    Helper.dPrint('are you there???>>3 ${promotion.label} : ${discount.appliedDiscount}');
                    list.add(discount);
                  }
                } else {
                  list.add(discount);
                }
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside getAppliedDiscountsForARetailer tradePromotionServices catch block $e $s");
    }

    /// filter duplicate slab promotions
    Map<int, List<AppliedDiscountModel>> slabWisePromotion = {};

    for (var promo in list) {
      if(promo.promotion.slabGroupId != null && promo.promotion.appliedSkus.length == 1) {
        if (!slabWisePromotion.containsKey(promo.promotion.slabGroupId)) {
          slabWisePromotion[promo.promotion.slabGroupId!] = [promo];
        } else {
          slabWisePromotion[promo.promotion.slabGroupId]!.add(promo);
        }
      }
    }

    if(slabWisePromotion.isNotEmpty) {
      // Set<int> duplicateSlabGroups = slabWisePromotion.entries
      //     .map((entry) => entry.key)
      //     .toSet();

      ///remove all promotion from list which are duplicate slab promotions
      for (var promo in slabWisePromotion.entries) {
        ///if slab has only one promotion then no need to remove. that means ist only the best promotion
        if(promo.value.length > 1) {
          list.removeWhere((e) => e.promotion.slabGroupId == promo.key);
          final bestPromo = promo.value.reduce((curr, next) => curr.promotion.discountAmount > next.promotion.discountAmount ? curr : next);
          list.add(bestPromo);
        }

      }
    }

    return list;
  }


  Future<List<AppliedDiscountModel>> getAppliedDiscountsForARetailerFromPromotions(
      OutletModel retailer,
      Map<int, SaleDataModel> counts,
      Map<int, ProductDetailsModel> skus,
      List<ProductDetailsModel> soledProductList,
      List<int> selectedBeforePromotions,
      List<PromotionModel> allPromotions,
      ) async {
    List<AppliedDiscountModel> list = [];
    try {
      await _syncService.checkSyncVariable();
      List<PromotionModel> promotions = getAvailablePromotionForARetailerFromPromotions(retailer, allPromotions);

      if (promotions.isNotEmpty) {
        for (PromotionModel promotion in promotions) {
          int multiplier = checkIfPrerequisiteMetForAPromotionToApply(promotion, counts, soledProductList);

          if (promotion.isFractional) {
            multiplier = 1;
          }

          if (multiplier > 0) {
            AppliedDiscountModel? discount;
            if (promotion.discountType == DiscountType.entireMemo) {
              discount = calculateAppliedDiscountForEntireMemo(multiplier, promotion, counts, skus);
            } else {
              discount = calculateAppliedDiscount(multiplier, promotion, counts, skus);
            }

            if (promotion.isFractional) {
              for (int a = 0; a != 2; a++) {
                if (a == 0) {
                  discount = calculateAppliedDiscount(
                    multiplier,
                    promotion,
                    counts,
                    skus,
                    isFractional: true,
                    fractionalType: a == 0 ? FractionalPromotion.number : FractionalPromotion.decimal,
                  );
                  if (discount != null) {
                    list.add(discount);
                  }
                } else {
                  discount = calculateAppliedDiscount(
                    multiplier,
                    promotion,
                    counts,
                    skus,
                    isFractional: true,
                    fractionalType: a == 0 ? FractionalPromotion.number : FractionalPromotion.decimal,
                  );
                  if (discount != null) {
                    list.last.appliedDiscount = discount.appliedDiscount;
                  }
                }
              }
            } else {
              if (discount != null) {
                if (promotion.rules?.isNotEmpty ?? false) {
                  if (selectedBeforePromotions.contains(promotion.id)) {
                    list.add(discount);
                  }
                } else {
                  list.add(discount);
                }
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside getAppliedDiscountsForARetailer tradePromotionServices catch block $e $s");
    }

    /// filter duplicate slab promotions
    Map<int, List<AppliedDiscountModel>> slabWisePromotion = {};

    for (var promo in list) {
      if(promo.promotion.slabGroupId != null && promo.promotion.appliedSkus.length == 1) {
        log("promotion ___> ${promo.promotion.id}");
        if (!slabWisePromotion.containsKey(promo.promotion.slabGroupId)) {
          slabWisePromotion[promo.promotion.slabGroupId!] = [promo];
        } else {
          slabWisePromotion[promo.promotion.slabGroupId]!.add(promo);
        }
      }
    }

    if(slabWisePromotion.isNotEmpty) {
      // Set<int> duplicateSlabGroups = slabWisePromotion.entries
      //     .map((entry) => entry.key)
      //     .toSet();

      ///remove all promotion from list which are duplicate slab promotions
      for (var promo in slabWisePromotion.entries) {
        ///if slab has only one promotion then no need to remove. that means ist only the best promotion
        if(promo.value.length > 1) {
          list.removeWhere((e) => e.promotion.slabGroupId == promo.key);
          final bestPromo = promo.value.reduce((curr, next) => curr.promotion.discountAmount > next.promotion.discountAmount ? curr : next);
          list.add(bestPromo);
        }

      }
    }

    return list;
  }


  // calculates NORMAL promotion applied to a Retailer For a single promotion
  AppliedDiscountModel? calculateAppliedDiscount(
    int multiplier,
    PromotionModel promotion,
    Map<int, SaleDataModel> counts,
    Map<int, ProductDetailsModel> skus, {
    bool? isFractional,
    FractionalPromotion? fractionalType,
  }) {
    AppliedDiscountModel? discount;
    try {
      switch (promotion.payableType) {
        case PayableType.absoluteCash:
        case PayableType.productDiscount:
          discount = calculateAppliedDiscountForAbsoluteCashAndProductDiscount(multiplier, promotion, skus,
              isFractional: isFractional, fractionalType: fractionalType, counts: counts);
          break;
        case PayableType.percentageOfValue:
          discount = calculateAppliedDiscountForPercentageOfValue(multiplier, promotion, counts, skus);
          break;
        case PayableType.gift:
          discount = calculateAppliedDiscountForGift(multiplier, promotion);
          break;
      }
    } catch (e) {
      Helper.dPrint("inside calculateAppliedDiscount TradePromotionServices catch block $e");
    }
    return discount;
  }

  // calculates ENTIRE MEMO Promotion applied to a Retailer for a single sale
  AppliedDiscountModel? calculateAppliedDiscountForEntireMemo(
      int multiplier, PromotionModel promotion, Map<int, SaleDataModel> counts, Map<int, ProductDetailsModel> skus) {
    AppliedDiscountModel? discount;
    try {
      if (promotion.payableType == PayableType.percentageOfValue) {
        discount = calculateAppliedDiscountForPercentageOfValueAndEntireMemo(multiplier, promotion, counts, skus);
      } else {
        discount = calculateAppliedDiscountForAbsoluteCashAndProductDiscount(multiplier, promotion, skus);
      }
    } catch (e) {
      Helper.dPrint("inside calculateAppliedDiscountForEntireMemo TradePromotionServices catch block $e");
    }
    return discount;
  }

  // Calculates ENTIRE MEMO Promotion when Payable type is PERCENTAGE OF VALUE
  AppliedDiscountModel? calculateAppliedDiscountForPercentageOfValueAndEntireMemo(
      int multiplier, PromotionModel promotion, Map<int, SaleDataModel> counts, Map<int, ProductDetailsModel> skus) {
    AppliedDiscountModel? discount;
    try {
      num discountAmount = promotion.discountAmount;
      multiplier = 1; //TODO:: may be changed if logic changes
      num totalDiscountAmountPer = (discountAmount * multiplier) / 100;
      num totalDiscount = 0;

      if (counts.isNotEmpty) {
        counts.forEach((key, value) {
          num draftDiscount = (value.price * totalDiscountAmountPer) + totalDiscount;

          if (promotion.capValue > 0 && (draftDiscount > promotion.capValue)) {
            totalDiscount = promotion.capValue;
            return;
          } else {
            totalDiscount = draftDiscount;
          }
        });
      }

      discount = AppliedDiscountModel(promotion: promotion, appliedDiscount: totalDiscount, skuWiseAppliedDiscountAmount: []);
    } catch (e) {
      Helper.dPrint("inside calculateAppliedDiscountForPercentageOfValueAndEntireMemo TradePromotionModel catch block $e");
    }

    return discount;
  }

  //calculates Promotion if Payable Type is ABSOLUTE CASH or PRODUCT DISCOUNT. works for both NORMAL discount and ENTIRE MEMO discount
  AppliedDiscountModel? calculateAppliedDiscountForAbsoluteCashAndProductDiscount(
    int multiplier,
    PromotionModel promotion,
    Map<int, ProductDetailsModel> skus, {
    bool? isFractional,
    FractionalPromotion? fractionalType,
    Map<int, SaleDataModel>? counts,
  }) {
    AppliedDiscountModel? discount;
    try {
      num totalDiscount = 0;
      List<SkuWiseAppliedDiscountAmountModel> skuWiseAppliedDiscounts = [];

      if (isFractional != null && isFractional == true) {
        if (promotion.discountSkus.isNotEmpty) {
          for (SkuWiseQtyModel discountSku in promotion.discountSkus) {
            ProductDetailsModel? sku = skus[discountSku.skuId];
            SaleDataModel? saleData = counts![discountSku.skuId];

            if (saleData == null && promotion.discountType != DiscountType.multiBuy) return null;

            double basePrice = PriceServices().getBasePriceForASku(sku?.id ?? 0);

            num fractionalDiscountAmount = 0;

            int offerApplicableOnQty = 0;

            if (promotion.appliedSkus.isNotEmpty) {
              for (SkuWiseQtyModel sku in promotion.appliedSkus) {
                int currentMultiplier = sku.appliedUnit;
                if (currentMultiplier > 0) {
                  offerApplicableOnQty = offerApplicableOnQty > 0
                      ? offerApplicableOnQty > currentMultiplier
                          ? currentMultiplier
                          : offerApplicableOnQty
                      : currentMultiplier;
                } else {
                  offerApplicableOnQty = 0;
                }
              }
            }

            if (fractionalType == FractionalPromotion.number) {
              num salesQuantity = saleData?.qty ?? 0;
              fractionalDiscountAmount = (salesQuantity * promotion.discountAmount / promotion.totalApplicableQuantity).floor();

              if (promotion.capValue > 0 && fractionalDiscountAmount > promotion.capValue) {
                fractionalDiscountAmount = promotion.capValue;
              }
            } else {
              num fullCasePrice = (promotion.totalApplicableQuantity) * basePrice;
              num perPeacePrice = fullCasePrice / (promotion.totalApplicableQuantity + promotion.discountAmount);

              num salesQuantity = saleData?.qty ?? 0;

              fractionalDiscountAmount = ((salesQuantity * promotion.discountAmount / promotion.totalApplicableQuantity) -
                      (salesQuantity * promotion.discountAmount / promotion.totalApplicableQuantity).floor()) *
                  perPeacePrice;
            }

            SkuWiseAppliedDiscountAmountModel skuWiseAppliedDiscountAmountModel = SkuWiseAppliedDiscountAmountModel(
              skuId: sku?.id ?? 0,
              skuName: sku?.shortName ?? '',
              discountAmount: fractionalDiscountAmount,
            );
            skuWiseAppliedDiscounts.add(skuWiseAppliedDiscountAmountModel);
          }
        } else {
          log('nothing');
        }
      } else {
        if (promotion.discountSkus.isNotEmpty) {
          if (promotion.payableType == PayableType.absoluteCash && promotion.rules != null && (promotion.rules?.isNotEmpty ?? false)) {
            num skuWiseDiscount = promotion.discountAmount * multiplier;
            if (promotion.capValue > 0 && (totalDiscount + skuWiseDiscount) > promotion.capValue) {
              skuWiseDiscount = promotion.capValue - totalDiscount;
            }
            totalDiscount += skuWiseDiscount;

            for (SkuWiseQtyModel discountSku in promotion.discountSkus) {
              ProductDetailsModel? sku = skus[discountSku.skuId];

              if (sku != null) {
                SkuWiseAppliedDiscountAmountModel skuWiseAppliedDiscountAmountModel = SkuWiseAppliedDiscountAmountModel(
                  skuId: sku.id,
                  skuName: sku.shortName,
                  discountAmount: skuWiseDiscount,
                );
                skuWiseAppliedDiscounts.add(skuWiseAppliedDiscountAmountModel);
              }
            }
          } else {
            for (SkuWiseQtyModel discountSku in promotion.discountSkus) {
              ProductDetailsModel? sku = skus[discountSku.skuId];

              if (sku != null && promotion.discountType == DiscountType.multiBuy) return null;
              if (sku != null) {
                num skuWiseDiscount = discountSku.discountQty * multiplier;
                if (promotion.capValue > 0 && (totalDiscount + skuWiseDiscount) > promotion.capValue) {
                  skuWiseDiscount = promotion.capValue - totalDiscount;
                }
                totalDiscount += skuWiseDiscount;
                SkuWiseAppliedDiscountAmountModel skuWiseAppliedDiscountAmountModel = SkuWiseAppliedDiscountAmountModel(
                  skuId: sku.id,
                  skuName: sku.shortName,
                  discountAmount: skuWiseDiscount,
                );
                skuWiseAppliedDiscounts.add(skuWiseAppliedDiscountAmountModel);

                if (promotion.capValue > 0 && totalDiscount >= promotion.capValue) {
                  break;
                }
              }
            }
          }
        } else {
          if (promotion.payableType == PayableType.absoluteCash) {
            num discountAmount = promotion.discountAmount;
            totalDiscount = discountAmount * multiplier;
            if (promotion.capValue > 0) {
              totalDiscount = totalDiscount > promotion.capValue ? promotion.capValue : totalDiscount;
            }
          }
        }
      }

      if (isFractional != null && isFractional == true) {
        if (fractionalType == FractionalPromotion.number) {
          num appliedDiscount = 0;
          for (var val in skuWiseAppliedDiscounts) {
            appliedDiscount += val.discountAmount ?? 0;
          }

          discount = AppliedDiscountModel(
            promotion: promotion,
            appliedDiscount: appliedDiscount,
            skuWiseAppliedDiscountAmount: skuWiseAppliedDiscounts,
          );
        } else {
          PromotionModel promotionModel = PromotionModel(
            id: promotion.id,
            sbuId: promotion.sbuId,
            label: promotion.label,
            payableType: PayableType.absoluteCash,
            discountType: promotion.discountType,
            capValue: promotion.capValue,
            discountAmount: promotion.discountAmount,
            isDependent: promotion.isDependent,
            slabGroupId: promotion.slabGroupId,
            appliedSkus: promotion.appliedSkus,
            discountSkus: promotion.discountSkus,
            isFractional: isFractional,
            totalApplicableQuantity: promotion.totalApplicableQuantity,
            rules: promotion.rules,
          );
          num appliedDiscount = 0;
          for (var val in skuWiseAppliedDiscounts) {
            appliedDiscount += val.discountAmount ?? 0;
          }

          discount = AppliedDiscountModel(
            promotion: promotionModel,
            appliedDiscount: appliedDiscount,
            skuWiseAppliedDiscountAmount: skuWiseAppliedDiscounts,
          );
        }
      } else {
        discount = AppliedDiscountModel(
          promotion: promotion,
          appliedDiscount: totalDiscount,
          skuWiseAppliedDiscountAmount: skuWiseAppliedDiscounts,
        );
      }
    } catch (e) {
      Helper.dPrint("inside calculateAppliedDiscountForAbsoluteCash TradePromotionServices catch block $e");
    }

    return discount;
  }

  // calculates Payable Type PERCENTAGE OF VALUE for NORMAL discount
  AppliedDiscountModel? calculateAppliedDiscountForPercentageOfValue(
      int multiplier, PromotionModel promotion, Map<int, SaleDataModel> counts, Map<int, ProductDetailsModel> skus) {
    AppliedDiscountModel? discount;
    try {
      num totalDiscount = 0;
      List<SkuWiseAppliedDiscountAmountModel> skuWiseAppliedDiscounts = [];

      // multiplier = 1; //TODO:: may change if logic change dont be coi
      if (promotion.discountSkus.isNotEmpty) {
        if (promotion.rules?.isNotEmpty ?? false) {
          num totalBuyPrice = 0;
          for (SkuWiseQtyModel discountSku in promotion.discountSkus) {
            SaleDataModel? saleData = counts[discountSku.skuId];
            ProductDetailsModel? sku = skus[discountSku.skuId];
            if (saleData != null && sku != null) {
              totalBuyPrice += saleData.price;
            }
          }
          for (SkuWiseQtyModel discountSku in promotion.discountSkus) {
            SaleDataModel? saleData = counts[discountSku.skuId];
            ProductDetailsModel? sku = skus[discountSku.skuId];
            if (saleData != null && sku != null) {
              totalDiscount = (totalBuyPrice * promotion.discountAmount) / 100;

              SkuWiseAppliedDiscountAmountModel skuWiseAppliedDiscountAmountModel = SkuWiseAppliedDiscountAmountModel(
                skuId: sku.id,
                skuName: sku.shortName,
                discountAmount: totalDiscount,
              );
              skuWiseAppliedDiscounts.add(skuWiseAppliedDiscountAmountModel);
            }
          }
        } else {
          for (SkuWiseQtyModel discountSku in promotion.discountSkus) {
            SaleDataModel? saleData = counts[discountSku.skuId];
            ProductDetailsModel? sku = skus[discountSku.skuId];
            if (saleData != null && sku != null) {
              num appliedUnit = 0;
              if (discountSku.appliedUnit > 0) {
                multiplier = saleData.qty ~/ discountSku.appliedUnit;
                appliedUnit = discountSku.appliedUnit;
              } else {
                if (promotion.appliedSkus.isNotEmpty) {
                  for (SkuWiseQtyModel appliedSku in promotion.appliedSkus) {
                    if (appliedSku.skuId == discountSku.skuId) {
                      appliedUnit = appliedSku.appliedUnit;
                      break;
                    }
                  }
                }
              }

              num discountPrice = (((saleData.price * appliedUnit * multiplier) / saleData.qty) * (discountSku.discountQty / 100));
              if (promotion.capValue > 0 && (totalDiscount + discountPrice) > promotion.capValue) {
                discountPrice = promotion.capValue - totalDiscount;
              }
              totalDiscount += discountPrice;
              SkuWiseAppliedDiscountAmountModel skuWiseAppliedDiscountAmountModel =
                  SkuWiseAppliedDiscountAmountModel(skuId: sku.id, skuName: sku.shortName, discountAmount: discountPrice);

              skuWiseAppliedDiscounts.add(skuWiseAppliedDiscountAmountModel);
              if (promotion.capValue > 0 && totalDiscount >= promotion.capValue) {
                break;
              }
            }
          }
        }
        if (totalDiscount > 0) {
          discount =
              AppliedDiscountModel(promotion: promotion, appliedDiscount: totalDiscount, skuWiseAppliedDiscountAmount: skuWiseAppliedDiscounts);
        }
      }
    } catch (e) {
      Helper.dPrint("inside calculateAppliedDiscountForPercentageOfValue TradePromotionServices catch block $e");
    }

    return discount;
  }

  //calculates GIFT . GIFT is only available for NORMAL discount.
  AppliedDiscountModel? calculateAppliedDiscountForGift(int multiplier, PromotionModel promotion) {
    AppliedDiscountModel? discount;
    try {
      num totalDiscount = 0;
      List<SkuWiseAppliedDiscountAmountModel> skuWiseAppliedDiscounts = [];
      if (promotion.discountSkus.isNotEmpty) {
        for (SkuWiseQtyModel discountSku in promotion.discountSkus) {
          Map gift = getGiftInfoFromGiftId(discountSku.skuId);
          if (gift.isNotEmpty) {
            num discountAmount = discountSku.discountQty * multiplier;
            if (promotion.capValue > 0 && (totalDiscount + discountAmount) > promotion.capValue) {
              discountAmount = promotion.capValue - totalDiscount;
            }
            totalDiscount += discountAmount;
            SkuWiseAppliedDiscountAmountModel skuWiseAppliedDiscountAmountModel =
                SkuWiseAppliedDiscountAmountModel(skuId: gift["id"], skuName: gift['name'], discountAmount: discountAmount);
            skuWiseAppliedDiscounts.add(skuWiseAppliedDiscountAmountModel);
            if (promotion.capValue > 0 && totalDiscount >= promotion.capValue) {
              break;
            }
          }
        }

        discount = AppliedDiscountModel(promotion: promotion, appliedDiscount: totalDiscount, skuWiseAppliedDiscountAmount: skuWiseAppliedDiscounts);
      }
    } catch (e) {
      Helper.dPrint("inside calculateAppliedDiscountForGift TradePromotionServices catch block $e");
    }

    return discount;
  }

  Map getGiftInfoFromGiftId(int id) {
    return syncObj["gifts"]?[id.toString()] ?? {};
  }

  int checkIfPrerequisiteMetForAPromotionToApply(
    PromotionModel promotion,
    Map<int, SaleDataModel> counts,
    List<ProductDetailsModel> soledProductList,
  ) {
    int multiplier = 0;
    try {
      if (promotion.discountType == DiscountType.entireMemo && promotion.appliedSkus.isEmpty) {
        multiplier = 1;
        return multiplier;
      } else {
        if (promotion.appliedSkus.isNotEmpty) {
          if (promotion.rules?.isNotEmpty ?? false) {
            if (validateForSlabDiscount(slab: promotion, purchaseSkq: soledProductList)) {
              // List<int> promotionSkusList = promotion.appliedSkus.map((e) => e.skuId).toList();
              // int targetedSkusSoledCount = 0;
              // for (var val in soledProductList) {
              //   if (promotionSkusList.contains(val.id)) {
              //     targetedSkusSoledCount += (val.preorderData?.qty ?? 0) ~/ val.packSizeCases;
              //   }
              // }
              //
              // multiplier = targetedSkusSoledCount ~/ promotion.totalApplicableQuantity;


              multiplier = getMinimumTimeMultiplier(slab: promotion, purchaseSkq: soledProductList);
            }
          } else {
            for (SkuWiseQtyModel sku in promotion.appliedSkus) {
              int soldCount = counts[sku.skuId]?.qty ?? 0;
              int currentMultiplier = soldCount ~/ sku.appliedUnit;
              if (currentMultiplier > 0) {
                multiplier = multiplier > 0
                    ? multiplier > currentMultiplier
                        ? currentMultiplier
                        : multiplier
                    : currentMultiplier;
              } else {
                multiplier = 0;
                break;
              }
            }
          }
        }
      }
    } catch (e, s) {
      Helper.dPrint("inside checkIfPrerequisiteMetForAPromotionToApply TradePromotionServices catch block $e $s");
    }
    return multiplier;
  }



  int getMinimumTimeMultiplier({
    required PromotionModel slab,
    required List<ProductDetailsModel> purchaseSkq,
  }) {
    if(slab.qpsTarget == QpsTarget.volume) {
      return getMinimumTimeMultiplierForVolume(slab: slab, purchaseSkq: purchaseSkq);
    }
    return getMinimumTimeMultiplierForValue(slab: slab, purchaseSkq: purchaseSkq);
  }

  int getMinimumTimeMultiplierForValue({
    required PromotionModel slab,
    required List<ProductDetailsModel> purchaseSkq,
  }) {
    int combineSkuSum = 0;
    final mandatorySkuIds = <int>[];

    ///filter mandatory skus id
    for (var rule in slab.rules ?? <Rules>[]) {
      if (rule.skuId != "%") {
        final skuId = int.tryParse(rule.skuId ?? '0') ?? 0;
        if (skuId > 0) {
          mandatorySkuIds.add(skuId);
        }
      }
    }

    final appliedSkuIds = slab.appliedSkus.map((e) => e.skuId).toList();

    for (var pSku in purchaseSkq) {
      if (appliedSkuIds.contains(pSku.id) && !mandatorySkuIds.contains(pSku.id)) {
        combineSkuSum += ((pSku.preorderData?.price ?? 0)).floor();
      }
    }

    final multiplayerList = <int>[];

    for (var rule in slab.rules ?? <Rules>[]) {
      if (rule.skuId != "%") {
        int saleQtyForThisSku = 0;
        for (var pSku in purchaseSkq) {
          if (pSku.id == int.tryParse(rule.skuId ?? '')) {
            saleQtyForThisSku += ((pSku.preorderData?.price ?? 0)).floor();
          }
        }

        final multiplayer = saleQtyForThisSku == 0 ? 0 : saleQtyForThisSku ~/ (rule.cases ?? 1);
        log("-------------->>>>>>>>>> >>>>> multiplayer !% :: $multiplayer");
        multiplayerList.add(multiplayer);
      } else if (rule.skuId == "%") {
        final multiplayer = combineSkuSum == 0 ? 0 : combineSkuSum ~/ (rule.cases ?? 1);
        log("-------------->>>>>>>>>> >>>>> multiplayer % :: $multiplayer");
        multiplayerList.add(multiplayer);
      }
    }

    if(multiplayerList.isEmpty) {
      return 0;
    }

    int minMultiplayer = multiplayerList.reduce((curr, next) => curr < next ? curr : next);
    log("-------------->>>>>>>>>> >>>>> multiplayer % :: $minMultiplayer");
    return minMultiplayer;
  }

  int getMinimumTimeMultiplierForVolume({
    required PromotionModel slab,
    required List<ProductDetailsModel> purchaseSkq,
  }) {
    int combineSkuSum = 0;
    final mandatorySkuIds = <int>[];

    ///filter mandatory skus id
    for (var rule in slab.rules ?? <Rules>[]) {
      if (rule.skuId != "%") {
        final skuId = int.tryParse(rule.skuId ?? '0') ?? 0;
        if (skuId > 0) {
          mandatorySkuIds.add(skuId);
        }
      }
    }

    final appliedSkuIds = slab.appliedSkus.map((e) => e.skuId).toList();

    for (var pSku in purchaseSkq) {
      if (appliedSkuIds.contains(pSku.id) && !mandatorySkuIds.contains(pSku.id)) {
        combineSkuSum += ((pSku.preorderData?.qty ?? 0)/(pSku.packSizeCases)).floor();
      }
    }

    final multiplayerList = <int>[];

    for (var rule in slab.rules ?? <Rules>[]) {
      if (rule.skuId != "%") {
        int saleQtyForThisSku = 0;
        for (var pSku in purchaseSkq) {
          if (pSku.id == int.tryParse(rule.skuId ?? '')) {
            saleQtyForThisSku += ((pSku.preorderData?.qty ?? 0)/(pSku.packSizeCases)).floor();
          }
        }

        final multiplayer = saleQtyForThisSku == 0 ? 0 : saleQtyForThisSku ~/ (rule.cases ?? 1);
        multiplayerList.add(multiplayer);
      } else if (rule.skuId == "%") {
        final multiplayer = combineSkuSum == 0 ? 0 : combineSkuSum ~/ (rule.cases ?? 1);
        multiplayerList.add(multiplayer);
      }
    }

    if(multiplayerList.isEmpty) {
      return 0;
    }

    int minMultiplayer = multiplayerList.reduce((curr, next) => curr < next ? curr : next);
    return minMultiplayer;
  }

  //==================CALCULATE TRADE PROMOTION END =====================================================

  //=================================================================================================
  //=================  SAVE TRADE PROMOTION =========================================================
//=================================================================================================
  saveAllPromotionDataForASingleSale(
    OutletModel retailer,
    List<AppliedDiscountModel> appliedDiscounts,
    SaleType saleType,
    List<SlabPromotionSelectionModel>? slabPromotions, [
    bool replace = false,
  ]) async {
    try {
      if (replace) {
        clearPreviousDiscountForARetailer(retailer.id ?? 0, saleType);
      }
      if (appliedDiscounts.isNotEmpty) {
        for (AppliedDiscountModel discount in appliedDiscounts) {
          saveSingleTradePromotionDataToSync(retailerId: retailer.id ?? 0, discount: discount, saleType: saleType);
        }
      }

      if (slabPromotions != null && slabPromotions.isNotEmpty) {
        for (var val in slabPromotions) {
          if (val.selectedPromotion != null) {
            saveSingleTradePromotionDataToSync(retailerId: retailer.id ?? 0, saleType: saleType);
          }
        }
      }
    } catch (e) {
      Helper.dPrint("inside saveAllPromotionDataForASingleSale salesServices catch block $e");
    }
  }

  //
  // //clear previous discount for a retailer
  //
  clearPreviousDiscountForARetailer(int retailerId, SaleType saleType) {
    try {
      String promotionKey = SalesTypeUtils.toPromotionSaveKey(saleType);
      if (syncObj.containsKey(promotionKey)) {
        if (syncObj[promotionKey].containsKey(retailerId.toString())) {
          syncObj[promotionKey][retailerId.toString()] = {};
        }
      }
    } catch (e) {
      Helper.dPrint("inside clearPreviousDiscountForARetailer promotionServices catch block $e");
    }
  }

  saveSingleTradePromotionDataToSync({
    required int retailerId,
    AppliedDiscountModel? discount,
    required SaleType saleType,
    SlabPromotionSelectionModel? slabPromotions,
  }) async {
    try {
      String promotionKey = SalesTypeUtils.toPromotionSaveKey(saleType);
      if (!syncObj.containsKey(promotionKey)) {
        syncObj[promotionKey] = {};
      }

      if (!syncObj[promotionKey].containsKey(retailerId.toString())) {
        syncObj[promotionKey][retailerId.toString()] = {};
      }

      Map discountSkus = {};
      if (discount != null) {
        if (discount.skuWiseAppliedDiscountAmount.isNotEmpty) {
          if (discount.promotion.isFractional == true) {
            Map discountMap = discount.skuWiseAppliedDiscountAmount.last.toJson();

            num previousDiscountAmount = syncObj[promotionKey]?[retailerId.toString()]?[discount.promotion.id.toString()]
                    ?[promotionDataDiscountSkusKey]?[discount.skuWiseAppliedDiscountAmount.last.skuId.toString()]?[promotionDataDiscountAmountKey] ??
                0;

            discountMap[promotionDataDiscountAmountKey] += previousDiscountAmount;
            discountSkus[discount.skuWiseAppliedDiscountAmount.last.skuId.toString()] = discountMap;
          } else {
            for (SkuWiseAppliedDiscountAmountModel discountSku in discount.skuWiseAppliedDiscountAmount) {
              try {
                Map discountMap = discountSku.toJson();
                num previousDiscountAmount = syncObj[promotionKey]?[retailerId.toString()]?[discount.promotion.id.toString()]
                        ?[promotionDataDiscountSkusKey]?[discountSku.skuId.toString()]?[promotionDataDiscountAmountKey] ??
                    0;

                discountMap[promotionDataDiscountAmountKey] += previousDiscountAmount;
                if (discount.promotion.payableType == PayableType.absoluteCash && discount.promotion.discountSkus.length > 1) {
                  discountMap[promotionDataDiscountAmountKey] = 0;
                }
                discountSkus[discountSku.skuId.toString()] = discountMap;
              } catch (e) {
                Helper.dPrint("inside saveSingleTradePromotionDataToSync for single sku PromotionServices catch block $e");
              }

            }
          }
        }

        num previousDiscountAmount =
            syncObj[promotionKey]?[retailerId.toString()]?[discount.promotion.id.toString()]?[promotionDataDiscountAmountKey] ?? 0;

        num singlePicePrice = 0;
        bool priceGraterPackSize = false;
        if (discount.promotion.isFractional == true) {
          previousDiscountAmount += discount.appliedDiscount;

          singlePicePrice = await getPackSizePriceForThisSku(sku: discount.skuWiseAppliedDiscountAmount.first);

          if (previousDiscountAmount >= singlePicePrice) {
            previousDiscountAmount = previousDiscountAmount - singlePicePrice;
            priceGraterPackSize = true;
          }
        }
        try {
          if (discount.promotion.isFractional == true && priceGraterPackSize) {
            num discountAmount = discountSkus[discount.skuWiseAppliedDiscountAmount.first.skuId.toString()][promotionDataDiscountAmountKey];
            discountSkus[discount.skuWiseAppliedDiscountAmount.first.skuId.toString()][promotionDataDiscountAmountKey] = discountAmount + 1;
          }
          Map promotionMap = discount.promotion.isFractional == true
              ? {
                  promotionDataPayableTypeKey: PayableTypeUtils.toStr(PayableType.productDiscount),
                  promotionDataDiscountTypeKey: DiscountTypeUtils.toStr(discount.promotion.discountType),
                  promotionDataDiscountAmountKey: previousDiscountAmount,
                  promotionDataDiscountSkusKey: discountSkus,
                  'is_fractional': true
                }
              : {
                  promotionDataPayableTypeKey: PayableTypeUtils.toStr(discount.promotion.payableType),
                  promotionDataDiscountTypeKey: DiscountTypeUtils.toStr(discount.promotion.discountType),
                  promotionDataDiscountAmountKey: discount.appliedDiscount + previousDiscountAmount,
                  promotionDataDiscountSkusKey: discountSkus,
                };
          log('promotion data is::::: ${jsonEncode(promotionMap)}');

          syncObj[promotionKey][retailerId.toString()][discount.promotion.id.toString()] = promotionMap;
        } catch (e, t) {
          log(e.toString());
          log(t.toString());
        }
      } else if (slabPromotions != null) {

        Map promotionMap = {
          promotionDataPayableTypeKey: 'Absolute Cash',
          promotionDataDiscountTypeKey: 'Multi Buy',
          promotionDataDiscountAmountKey: slabPromotions.discountAmount ?? 0,
          selectedSlabId: slabPromotions.selectedPromotion,
        };

        int slabGroupId = checkInSameSlbGroup(slabId: slabPromotions.selectedPromotion ?? 0);

        if (slabGroupId != -1) {
          List<int> allSlabInThisGroup = getAllSameSlbGroup(slabGroupId: slabGroupId);

          Map a = syncObj[promotionKey][retailerId.toString()];
          for (var val in allSlabInThisGroup) {
            a.remove('$val');
          }
          a['${slabPromotions.selectedPromotion}'] = promotionMap;
          syncObj[promotionKey][retailerId.toString()] = a;
        } else {
          syncObj[promotionKey][retailerId.toString()][slabPromotions.selectedPromotion.toString()] = promotionMap;
        }
      }
    } catch (e) {
      Helper.dPrint("inside saveSingleTradePromotionDataToSync PromotionServices catch block $e");
    }
  }

  int checkInSameSlbGroup({required int slabId}) {
    int slabGroupId = -1;
    if (syncObj.containsKey('promotions')) {
      Map promotion = syncObj['promotions'];
      if (promotion.containsKey('$slabId')) {
        Map slabPromotion = promotion['$slabId'];
        if (slabPromotion.containsKey('slab_group_id')) {
          slabGroupId = slabPromotion['slab_group_id'];
        }
      }
    }
    return slabGroupId;
  }

  List<int> getAllSameSlbGroup({required int slabGroupId}) {
    List<int> slabGroupIds = [];
    if (syncObj.containsKey('promotions')) {
      Map promotion = syncObj['promotions'];
      promotion.forEach((key, value) {
        Map v = value;
        if (v.containsKey('slab_group_id')) {
          if (v['slab_group_id'] == slabGroupId) {
            slabGroupIds.add(v['id']);
          }
        }
      });
    }
    return slabGroupIds;
  }

  Future<List<DiscountPreviewModel>> getTotalDiscountForARetailerAndModule(int retailerId, SaleType saleType, module) async {
    List<DiscountPreviewModel> list = [];
    try {
      String promotionKey = SalesTypeUtils.toPromotionSaveKey(saleType);
      Map retailerWisePromotionData = syncObj[promotionKey]?[retailerId.toString()] ?? {};
      if (retailerWisePromotionData.isNotEmpty) {
        for (MapEntry retailerWisePromotionDataMapEntry in retailerWisePromotionData.entries) {
          Map promotion = syncObj['promotions'][retailerWisePromotionDataMapEntry.key.toString()] ?? {};

          if(promotion['sbu_id'] == module.id) {
            list.add(DiscountPreviewModel.fromJson(retailerWisePromotionDataMapEntry.value, int.parse(retailerWisePromotionDataMapEntry.key)));
          }
        }
      }
    } catch (e) {
      Helper.dPrint("inside getTotalDiscountForARetailerAndModule PromotionServices catch block $e");
    }
    return list;
  }

  // returns total discount for a module
  Future<SaleDataModel> getTotalDiscountForAModule(int moduleId) async {
    SaleDataModel discountData = SaleDataModel();
    try {
      int totalVolume = 0;
      double totalValue = 0.0;

      if (syncObj.containsKey(promotionDataKey)) {
        if (syncObj[promotionDataKey].isNotEmpty) {
          syncObj[promotionDataKey].forEach((retailerId, promotionInfoPerPromotionId) {
            if (promotionInfoPerPromotionId.isNotEmpty) {
              promotionInfoPerPromotionId.forEach((promotionId, promotionInfo) {
                if (promotionInfo[promotionDataPayableTypeKey] == PayableTypeUtils.toStr(PayableType.percentageOfValue) ||
                    promotionInfo[promotionDataPayableTypeKey] == PayableTypeUtils.toStr(PayableType.absoluteCash)) {
                  totalValue += num.tryParse(promotionInfo[promotionDataDiscountAmountKey].toString()) ?? 0.0;
                }
              });
            }
          });
        }
      }

      discountData.qty = totalVolume;
      discountData.price = totalValue;
    } catch (e) {
      Helper.dPrint("inside getTotalDiscountForAModule salesServices catch block $e");
    }

    return discountData;
  }

  bool validateForSlabDiscount({
    required PromotionModel slab,
    required List<ProductDetailsModel> purchaseSkq,
  }) {
    List<bool> validateList = [];
    int minimumRequiredUniqueSku = 0;
    int totalCasePurchase = 0;
    List<int?> slabSkuList = [];

    ///check the rules
    if (slab.rules?.isNotEmpty ?? false) {
      slabSkuList = slab.appliedSkus.map((e) => e.skuId).toList(); //main slab sku
      List<int> purchaseSkuList = purchaseSkq.map((e) => e.id).toList(); //main slab sku
      minimumRequiredUniqueSku = slab.totalApplicableQuantity; //"total_applicable_quantity": 250,

      List<int> checkedItem = [];

      slab.rules?.map((e) => validateList.add(false)).toList();
      for (int a = 0; a != (slab.rules ?? []).length; a++) {
        if (slab.rules?[a].skuId == '%') {
          for (int b = 0; b != purchaseSkuList.length; b++) {
            if (slabSkuList.contains(purchaseSkuList[b]) && !checkedItem.contains(purchaseSkuList[b])) {
              if ((purchaseSkq[b].preorderData?.qty ?? 0) ~/ (purchaseSkq[b].packSizeCases) >= 1) {
                checkedItem.add(purchaseSkuList[b]);
                validateList[a] = true;
                break;
              }
            }
          }
        } else {
          int rulesSkuId = int.tryParse(slab.rules?[a].skuId ?? '0') ?? 0;
          if (purchaseSkuList.contains(rulesSkuId) && !checkedItem.contains(rulesSkuId)) {
            int index = purchaseSkuList.indexWhere((element) => element == rulesSkuId);

            if ((purchaseSkq[index].preorderData?.qty ?? 0) ~/ (purchaseSkq[index].packSizeCases) >= 1) {
              checkedItem.add(rulesSkuId);
              validateList[a] = true;
            }
          }
        }
      }
    }

    for (var v in purchaseSkq) {
      if (slabSkuList.contains(v.id)) {
        var sku = purchaseSkq.firstWhere((element) => element.id == v.id);
        totalCasePurchase += ((sku.preorderData?.qty ?? 0) ~/ (sku.packSizeCases));
      }
    }

    // print('-------------> $minimumUniqueSku ::: $totalCasePurchase <---------------------');
    if (validateList.where((element) => element == true).length == validateList.length && totalCasePurchase >= minimumRequiredUniqueSku) {
      return true;
    }

    return false;
  }

  Future<num> getPackSizePriceForThisSku({required SkuWiseAppliedDiscountAmountModel sku}) async {
    num singleSkuPrice = 0;
    try {
      singleSkuPrice = PriceServices().getBasePriceForASku(sku.skuId);
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return singleSkuPrice;
  }



  Future<bool> getSalesModuleV2PromotionEnable() async {
    // return true;
    bool saleModulePromotionEnable = false;
    try {
      await _syncService.checkSyncVariable();
      int available = syncObj['sales_configurations']["sales_dashboard_buttons"]?["promotion"]??0;
      if(available == 1) {
        saleModulePromotionEnable = true;
      }
    } catch (e,t) {
      log(e.toString());
      log(t.toString());
    }
    return saleModulePromotionEnable;
  }
}
