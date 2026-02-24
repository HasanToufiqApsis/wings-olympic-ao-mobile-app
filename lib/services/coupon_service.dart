import 'dart:developer';

import '../constants/constant_keys.dart';
import '../constants/sync_global.dart';
import '../models/coupon/coupon_model.dart';
import '../models/outlet_model.dart';
import '../models/sales/formatted_sales_preorder_discount_data_model.dart';
import '../models/sales/sale_data_model.dart';
import '../models/sr_info_model.dart';
import '../models/trade_promotions/applied_discount_model.dart';
import '../utils/promotion_utils.dart';
import 'helper.dart';
import 'sync_read_service.dart';
import 'sync_service.dart';

class CouponService {
  final SyncService _syncService = SyncService();
  final SyncReadService _syncReadService = SyncReadService();

  Future<List<CouponModel>> getAllCoupon() async {
    List<CouponModel> list = [];
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(couponKey)) {
        var coupons = syncObj[couponKey];
        if (coupons != null) {
          for (var v in coupons) {
            list.add(CouponModel.fromJson(v));
          }
        }
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return list;
  }

  Future<CouponModel?> getCouponFromCouponCode({
    required String couponCode,
  }) async {
    CouponModel? coupon;
    try {
      List<CouponModel> coupons = await getAllCoupon();
      if (coupons.isNotEmpty) {
        coupon = coupons.firstWhere((element) => element.code.toLowerCase() == couponCode.toLowerCase());
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return coupon;
  }

  Future<bool> checkCouponExist({
    required String couponCode,
  }) async {
    bool exist = false;
    try {
      List<CouponModel> coupons = await getAllCoupon();
      // log('all coupons => ${coupons.map((e) => e.code).join(', ')}');
      if (coupons.isNotEmpty) {
        int index = coupons.indexWhere((element) => element.code.toLowerCase() == couponCode.toLowerCase());
        if (index != -1) {
          exist = true;
        }
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return exist;
  }

  Future<bool> applicableWithPromotion({
    required List<AppliedDiscountModel> discounts,
    required List<List<SlabDiscountModel>> slabList,
    required CouponModel coupon,
  }) async {
    bool applicable = false;
    try {
      if (discounts.isNotEmpty || slabList.isNotEmpty) {
        if (coupon.isStackable == 1) {
          applicable = true;
        } else {
          applicable = false;
        }
      } else {
        applicable = true;
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
    return applicable;
  }

  num getCouponDiscountAmount({
    required SaleDataModel discountSaleData,
    required num slabPromotionsDiscount,
    required SaleDataModel totalSaleData,
    required CouponModel coupon,
  }) {
    num totalCouponDiscount = 0;
    try {
      num totalPrice = totalSaleData.price - discountSaleData.price - slabPromotionsDiscount;
      if (coupon.applicableFor == DiscountType.entireMemo) {
        if (coupon.discType == PayableType.absoluteCash) {
          totalCouponDiscount = coupon.discountValue;
        } else if (coupon.discType == PayableType.percentageOfValue) {
          num percentTotalDis = (coupon.discountValue * totalPrice) / 100;
          if (percentTotalDis > coupon.capValue) {
            totalCouponDiscount = coupon.capValue;
          } else {
            totalCouponDiscount = percentTotalDis;
          }
        }
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }

    return totalCouponDiscount;
  }

  Future<bool> checkRetailerAlreadyUseCoupon({required OutletModel retailer}) async {
    bool alreadyUse = true;

    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey(couponDataKey)) {
        if (syncObj[couponDataKey].containsKey(retailer.id.toString())) {
          alreadyUse = true;
        } else {
          alreadyUse = false;
        }
      } else {
        alreadyUse = false;
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }

    return alreadyUse;
  }

  Future<Map?> checkRetailerCouponCode({required OutletModel retailer}) async {
    Map? alreadyUseCouponCode;

    try {
      if (await checkRetailerAlreadyUseCoupon(retailer: retailer) == true) {
        await _syncService.checkSyncVariable();

        if (syncObj.containsKey(couponDataKey)) {
          if (syncObj[couponDataKey].containsKey(retailer.id.toString())) {
            Map allCouponsData = syncObj[couponDataKey][retailer.id.toString()];
            if (allCouponsData.isNotEmpty) {
              allCouponsData.forEach((key, value) {
                Map targetedCouponData = value.last;
                alreadyUseCouponCode = targetedCouponData;
              });
            }
          }
        }
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }

    return alreadyUseCouponCode;
  }

  // Future<String?> getCouponCodeFromRetailerId({required OutletModel retailer})async{
  //   String? couponCode;
  //   try{
  //     if (syncObj.containsKey(couponDataKey)) {
  //       if (syncObj[couponDataKey].containsKey(retailer.id.toString())) {
  //         Map allCouponsDataForThisRetailer = syncObj[couponDataKey][retailer.id.toString()];
  //         if (allCouponsDataForThisRetailer.isNotEmpty) {
  //           allCouponsDataForThisRetailer.forEach((key, value) {
  //             Map targetedCouponData = value.last;
  //             if(targetedCouponData['code']!=null){
  //               couponCode=targetedCouponData['code'];
  //             }
  //           });
  //         }
  //       }
  //     }
  //   } catch (e,t) {
  //     print(e.toString());
  //     print(t.toString());
  //   }
  //   return couponCode;
  // }
}
