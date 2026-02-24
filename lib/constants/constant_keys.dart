
//id slug key
/*
* {
*  "id":11,
*  "slug":"slug"
* }
* */
const idKey = "id";
const slugKey = "slug";

//=====================================================


// new outlet add constant key
/*
* {
*   "onboarded_outlet_info":{
*     "new_outlets":{
*       "#outletCoode":{
*         "outlet_id": #outlet_id
*         "outlet_code": "#outletCoode"
*         "outlet_name":"outlet name",
*         "outlet_name_bn":"outlet_name_bn",
*         "outlet_cover_photo":"cover_photo_path",
*         "owner_name":"owner name",
*         "contact_number":"contact number",
*         "nid_number":"nid number",
*         "address": "address",
*         "lat":23.795244217,
*         "lng":90.415031433,
*         "has_synced": true,
*         "outlet_mum": 1
*         "available_onboarding_info":{
*           "business_type":{"id":2, "slug":"Grocery"},
*           "channel_category":{"id":2, "slug":"GOLD"},
*           "cooler_status":"Yes",
*           "cooler":{"id":2, "slug":"GOLD"},
*           "cooler_image":"cooler image path"
*         }
*       }
*     }
*   },
*
* },
*/
/// inactive outlet
/*
* inactive_outlet:{
*     "#outlet_id":{
*       inactive_outlet_id: #outlet_id,
*       inactive_outlet_reason: reason
*     }
*   },
* */
const onboardingOutletInfoKey = "onboarded_outlet_info";
const onboardingNewOutletKey = "new_outlets";
const onboardingNewOutletStatusKey = "approval_status";
const onboardingOutletNameKey = "outlet_name";
const onboardingOutletNameBnKey = "outlet_name_bn";
const onboardingOutletCoverPhotoPathKey = "outlet_cover_photo";
const onboardingOwnerNameKey = "owner";
const onboardingManufacturerIdKey = "manufacturer_id";
const onboardingSectionIdKey = "section_id";
const onboardingOutletIdKey = "outlet_id";
const onboardingDepIdKey = "dep_id";
const onboardingContactNumberKey = "contact";
const onboardingNIDNumberKey = "nid";
const sbuIdKey = "sbu_id";
const onboardingAddressKey = "address";
const onboardingLatitudeKey = "lat";
const onboardingLongitudeKey = "long";
const onboardingAvailableOnboardingInfoKey = "available_onboarding_info";
const onboardingBusinessTypeKey = "business_type";
const onboardingChannelCategoryKey = "channel_category";
const onboardingCoolerStatusKey = "cooler_status";
const onboardingCoolerKey = "cooler";
const onboardingCoolerImagePathKey = "cooler_photo_url";
const onboardingOutletCodeKey = "outlet_code";
const onboardingNewOutletNumKey = "outlet_mum";
const onboardingHasSyncedKey = "has_synced";
const onboardingInactiveOutletKey = "inactive_outlet";
const onboardingInactiveOutletCodeKey = "inactive_outlet_code";
const onboardingInactiveReasonKey = "inactive_outlet_reason";
const onboardingNewOutletCountKey = "inactive_outlet_reason";
const onboardingClusterKey='onboard_cluster';

//==========================================================================


//========================== IMAGE FOLDER NAME ============================
const manualOverrideFolder = "geoFencingImages";
const unsoldOutletFolder = "unsold-outlet";
const answerFolder = "surveyImages";
const coolerImageFolder = "coolerImages";
const stockCheckImageFolder = "stockCheckImages";
//============================Manual Override================================
/*
* Manual Override data format
* {
*     "manual-override":{
*       "#retailer_id": {
*           "retailerId":"#retailer_id",
*           "sr_lat":"#sr_lat",
*           "sr_lng":"#sr_lng",
*           "image":"#manual override image path",
*           "timestamp":"#manual override time",
*         }
*     }
* }
* **/

const manualOverrideKey = "manual-override";
const manualOverrideRetailerIdKey = "retailerId";
const manualOverrideSrLatKey = "sr_lat";
const manualOverrideSrLngKey = "sr_lng";
const manualOverrideImageKey = "image";
const manualOverrideTimestampKey = "timestamp";
const manualOverrideReasoningKey = "reasoning";
//=============================================================================

// =================== unsold outlet data ====================================
/*
{
    "unsold_sales_data": [
        {
            "sbu_id": 1,
            "dep_id": 82,
            "ff_id": 148,
            "section_id": 414,
            "outlet_id": 22993,
            "outlet_code": "R148020623-002",
            "date": "2023-01-19",
            "reason":"Outlet Close",
            "image":"image1.jpg",
            "unsold_datetime": "2023-01-19 15:26:15"
        }
    ]
}
 */

const unsoldOutletKey = "unsold_sales_data";
const sbuIdUnsoldOutletKey = "sbu_id";
const depIdUnsoldOutletKey = "dep_id";
const ffIdUnsoldOutletKey = "ff_id";
const sectionIdUnsoldOutletKey = "section_id";
const outletIdUnsoldOutletKey = "outlet_id";
const outletCodeUnsoldOutletKey = "outlet_code";
const dateUnsoldOutletKey = "date";
const reasonUnsoldOutletKey = "reason";
const imageUnsoldOutletKey = "image";
const dateTimeUnsoldOutletKey = "unsold_datetime";

//======================================================================
// ================ AV DATA ======================================
/*
* {
*   "av-data":{
*    "#retailer_id":{
*       "#av_id":{}
*     }
*   }
* }
* */
const avDataKey = "av-data";

//====================================================================

//========================== Survey ==============================================
/* Survey data store format
* {"survey-data":{
*   "#retailer_id":{
*     "#survey_id":{
*       "#question_id":{
*         "questionType":"select",
*         "answer":"not good" ,//can be id or string
*          "answer_id": 1,
*           }
*         }
*        }
*      }
*   }
* */

//surveyDataKey stores key "survey-data". inside survey-data, there is retailer wise survey-id wise survey answer stored
const surveyDataKey = "survey-data";
const surveyQuestionTypeKey = "questionType";
const surveyAnswerKey = "answer";
const surveyAnswerIdKey = "answer_id";

const surveyDigitalDataKey = "survey-data-digital-learning";

//=========================== WOM/KV ================================
/*
* {
*   "wom-data":{
*     "#retailer_id":{
*       "#wom_id":{}
*     }
*   }
* }
* */

const womDataKey = "wom-data";
//=====================================================================

//========================Pre Order ===========================================
// pre order data storing format
/*
* {
*   "preorder-data":{
*     "#retailer_id":{
*       "#module_id":{
*         "#sku_id":{
*           "stt":1222,
*           "price":100000,
*           "sales_date":"2022-10-22",
*           "sales_datetime":"2022-10-22 10:11:12"
*         }
*       }
*     }
*   }
* }
* */

const preorderKey = "preorder-data";
const preorderSttKey = "stt";
const preorderPriceKey = "price";
const preorderSalesDateKey = "sales_date";
const preorderSalesDateTimeKey = "sales_datetime";

///same format will be used for delivery as well
const deliveryKey = "delivery-key";
const spotSaleKey = 'spot_sale';
//=============================================================================

//=========================== Sale Geo Data ================================================
/*
* Geo data format
* {
*   "geo-data":{
*      "#retailer_id":[{
*          "dep_id": 1,
*          "section_id": 1,
*          "outlet_id": 1010000,
*          "outlet_code": "DHK-20-123456",
*          "ff_id": 1,
*          "date": "2021-05-25",
*          "latitude": 12.125154,
*          "longitude": 11.125154,
*          "allowable_distance": 100,
*          "distance": 20,
*          "accuracy": 0.954,
*          "geo_validation": 1,
*          "photo_validation": 0,
*          "image_url":"image_name.jpg",
*          "cooler_image_url":"cooler_image_name.jpg"
*          "reasoning": 5,
*          "status": 3,
*          "altitude": 0.255555,
*          "heading": "",
*          "speed": 3.544,
*          "internet_speed": 20,
*          "connection_type": "wifi",
*          "capture_time": "2021-05-25 13:30:50"
*     }
*    ]
*   }
* }
* **/

const geoDataKey = "geo-data";
const geoDataDepIdKey = "dep_id";
const geoDataSectionIdKey = "section_id";
const geoDataRetailerIdKey = "outlet_id";
const geoDataRetailerCodeKey = "outlet_code";
const geoDataFFIdKey = "ff_id";
const geoDataDateKey = "date";
const geoDataLatKey = "latitude";
const geoDataLngKey = "longitude";
const geoDataAllowableDistanceKey = "allowable_distance";
const geoDataDistanceKey = "distance";
const geoDataAccuracyKey = "accuracy";
const geoDataGeoValidationKey = "geo_validation";
const geoDataPhotoValidationKey = "photo_validation";
const geoDataImageUrlKey = "image_url";
const geoDataCoolerImageUrlKey = "cooler_image_url";
const geoDataCoolerPurityScoreKey = "cooler_purity_score";
const geoDataReasoningKey = "reasoning";
const geoDataStatusKey = "status";
const geoDataAltitudeKey = "altitude";
const geoDataHeadingKey = "heading";
const geoDataSpeedKey = "speed";
const geoDataInternetSpeedKey = "internet_speed";
const geoDataConnectionTypeKey = "connection_type";
const geoDataCaptureTime = "capture_time";
//=============================================================================
//===================Call Time=================================================
/*
* Call time data format
* {
*     "call-time-data":{
*       "#retailer_id":[
*         {
*           "dep_id":1,
*           "section_id":1,
*           "ff_id":1,
*           "outlet_id":1,
*           "outlet_code":1,
*           "date":"2022-10-20",
*           "call_start_datetime":"2022-10-12 10:11:11",
*           "call_end_datetime":"2022-10-12 10:24:12",
*           "duration":100
*         }
*       ]
*     }
* }
* **/
const callTimeKey = "call-time-data";
const callTimeDepIdKey = "dep_id";
const callTimeSectionIdKey = "section_id";
const callTimeffIdKey = "ff_id";
const callTimeOutletIdKey = "outlet_id";
const callTimeOutletCodeKey = "outlet_code";
const callTimeDateKey = "date";
const callStartDatetimeKey = "call_start_datetime";
const callEndDatetimeKey = "call_end_datetime";
const callTimeDurationKey = "duration";
//=============================================================================
//================================== QC =======================================
/* QC data format
* {
*   "qc-data":{
*    "#retailer_id":{
*      "#module_id": {
*         "#sku_id":[
*            {
*              "fault_id":1,
*              "volume":20,
*               "saleable_return": 1,
*              "unit_price":15,
*              "total_value":200,
*              "entry_type":1, //default 1
*              "qc_type":1,  //default 1
*              "status":1    //default 1
*              }
*           ]
*        }
*     }
*   }
* }
* */
// qcDataKey stores retailer wise qc info
const qcDataKey = "qc-data";

//stores the fault id of a qc item for a retailer
const faultIdKey = "fault_id";
//qcVolumeKey contains the quantity of a particular qc fault of a particular sku for a specific retailer
const qcVolumeKey = "volume";
//qcUnitKeyKey contains unit price of particular sku which is returned for qc for a specific retailer
const qcUnitPriceKey = "unit_price";
//qcTotalValueKey contains totalValue of a specific qc for a specific fault for a specific retailer
const qcTotalValueKey = "total_value";
//static keys in qc entry
const qcEntryTypeKey = "entry_type";
const qcTypeKey = "qc_type";
const qcStatusKey = "status";

const deliveryQcDataKey = "delivery-qc-data";
const spotSaleQcDataKey = "spot_sale-qc-data";
//==============================================================================

//========================= Preorder Activity Log ==============================
/*
*  {
*    "preorder-activity":{
*      "#retailer_id":[
*       {
*         "edit_log_id":"#retailerId-timestamp(millisecondSinceEpoch)"
*         "edit_type": "edited",  //sales-type options = new,added,edited
*         "reason":"", // reason to edit the sale.  for types other than edit, it will be empty
*         "preorder-activity-datetime":"2022-08-29 12:06:00"
*         "preorder-data":{
*           "#module_id":{
*             "#sku_id":{
*                "stt":1222,
*                "price":100000,
*                "sales_date":"2022-10-22",
*                "sales_datetime":"2022-10-22 10:11:12"
*             }
*           }
*          }
*        }
*      ]
*    }
*  }
* */

const preorderActivityKey = "preorder-activity";
const preorderEditLogIdKey = "edit_log_id";
const preorderTypeKey = "edit_type";
const editReasonKey = "reason";
const preorderActivityDatetimeKey = "sale-activity-datetime";
const preorderDataKey = "sale-data";
//other keys initialized before
/*
const salesQtyKey = "stt";
const salesPriceKey = "price";
const salesDateKey = "sales_date";
const salesDateTimeKey = "sales_datetime";
* */
//==========================================================================


//=======================================================================
//promotionDataKey contains promotion data for a retailer. this is a high level key that contains promotion data per retailer
// {
//  "promotion-data":{
//    "retailer_id":{
//      "promotion_id":{
//        "payable_type":"",
//        "discount_type":"",
//        "discount_amount":100,
//        "discount_skus":{
//         "#sku_id":{
//            "sku_id":1,
//            "sku_name":"hello",
//            "discount_amount":100
//          }
//        }
//      }
//    }
//  }
// }
const promotionDataKey = "promotion-data";
const promotionDataPayableTypeKey = "payable_type";
const isFractionalKey = "is_fractional";
const promotionDataDiscountTypeKey = "discount_type";
const promotionDataDiscountSkusKey = "discount_skus";
const promotionDataSkuIdKey = "sku_id";
const promotionDataSkuNameKey = "sku_name";
const promotionDataDiscountAmountKey = "discount_amount";
const deliveryPromotionDataKey = "delivery-promotion-data";
const spotSalePromotionDataKey = "spot_sale-promotion-data";
const selectedSlabId = "selected-slab-promotion-id";
//=======================================================================


//=============Zero Sale Data ===================================
/*
* "zero-sale-data":{
*   "#retailer_id":[
*     {
*     "sbu_id":1,
*     "dep_id":344,
*     "ff_id":52,
*     "section_id":1,
*     "outlet_id": 1010000,
      "outlet_code": "DHK-20-123456",
      "sku_id": 2,
      "unit_price": 12.5,
      "volume": 2000,
      "total_price": 4000,
      "sales_date": "2022-10-02",
      "sales_datetime": "2022-05-28 18:35:20"
*  }
*  ]
* }
* */

const zeroSaleDataKey = "zero-sale-data";
const zeroSaleSbuIdKey = "sbu_id";
const zeroSaleDepIdKey = "dep_id";
const zeroSaleFFIdKey = "ff_id";
const zeroSaleSectionIdKey = "section_id";
const zeroSaleOutletIdKey = "outlet_id";
const zeroSaleOutletCodeKey = "outlet_code";
const zeroSaleSkuIdKey = "sku_id";
const zeroSaleUnitPriceKey = "unit_price";
const zeroSaleVolumeKey = "volume";
const zeroSaleTotalPriceKey = "total_price";
const zeroSaleSalesDateKey = "sales_date";
const zeroSaleSalesDatetimeKey = "sales_datetime";
//=================================================================

//================= Cooler Image Save On Preorder =================
/*
* {
*   "cooler_image_key":{
*    "#retailer_id":"#image_Path"
*  }
* }
* */
const coolerImageKey= "cooler-image";
const coolerPurityScoreKey= "cooler-purity-score";

//=========================== Device Log ================================================
/*
* Device Log data format
* {
*   "device-log":
*         {
*          "sbu_id": 1,
*          "dep_id": 1,
*          "section_id": 1,
*          "ff_id": 1,
*          "date": "2022-07-24",
*          "device_brand": "MI",
*          "device_model": "",
*          "device_os": 11.125154,
*          "device_imei": 0.954,
*          "app_version":"1.0.3"
*     }
* }
* **/

const deviceLogKey = "device-log";
const deviceLogSbuIdKey = "sbu_id";
const deviceLogDepIdKey = "dep_id";
const deviceLogSectionIdKey = "section_id";
const deviceLogFFIdKey = "ff_id";
const deviceLogDateKey = "date";
const deviceLogDeviceBrandKey = "device_brand";
const deviceLogDeviceModelKey = "device_model";
const deviceLogDeviceOsKey = "device_os";
const deviceLogDeviceImeiKey = "device_imei";

const deviceLogSyncKey = "device-log-sync";

//==================== Local storage Key =======
const localStorageUsernameKey = "username";
//======================= SR Achievement ==========================
/*
* {
*   "sr-achievement":{
      "STT":{
         "#module_id":{
*           "#product_category_type_id":{
*             "#product_category_id":#achiement_for_this_category
*           }
          }
       },
       BCP: {
        "#module_id":{
          "#product_category_type_id":{
             "#product_type_id": #bcp_achievement_for_this_category
            }
           }
          }
*   },
*
* }
* */
const srAchievementKey = "sr-achievement";
const sttTargetTypeKey = "STT";
const sttSpecialTargetTypeKey = "Special Target";
const bcpTargetTypeKey = "BCP";
//================================================================ attendance==================
const attendanceStatusKey = "status";
const attendanceIdKey = "id";

//========================== BreakDown =======================
const breakdownKey = "breakdown";
const breakdownEnabledKey = "breakdown_enabled";

//========================== Coupon =======================
const couponKey = "coupons";
const couponDataKey = "coupon-data";

//========================== Coupon =======================
const tryBeforeBuyKey = "try-before-buy-data";

//========================== Digital learning =======================
const digitalLearningKey = "digital-learning-data";
const digitalLearningAlreadyView = "digital_learning_view";
const digitalLearningId = "digital_learning_id";

//=============================================================================

//=========================== Sr Tracking Geo Data ================================================
/*
* Sr Tracking data format
* {
*   "sr-tracking":[
*         {
*          "sbu_id": 1,
*          "dep_id": 1,
*          "section_id": 1,
*          "ff_id": 1,
*          "date": "2022-07-24",
*          "pin_date_time": "2022-07-24 14:49:50",
*          "latitude": 12.125154,
*          "longitude": 11.125154,
*          "accuracy": 0.954,
*          "altitude": 0.255555,
*          "altitudeAccuracy":"",
*          "heading": "",
*          "speed": 3.544,
*          "internet_speed": "",
*          "connection_type": "",
*     }
*   ]
* }
* **/

const srTrackingKey = "sr-tracking";
const srTrackingSbuIdKey = "sbu_id";
const srTrackingDepIdKey = "dep_id";
const srTrackingSectionIdKey = "section_id";
const srTrackingFFIdKey = "ff_id";
const srTrackingDateKey = "date";
const srTrackingTimestampKey = "pin_date_time";
const srTrackingLatKey = "latitude";
const srTrackingLngKey = "longitude";
const srTrackingAccuracyKey = "accuracy";
const srTrackingAltitudeKey = "altitude";
const srTrackingAltitudeAccuracyKey = "altitudeAccuracy";
const srTrackingHeadingKey = "heading";
const srTrackingSpeedKey = "speed";
const srTrackingInternetSpeedKey = "internet_speed";
const srTrackingConnectionTypeKey = "connection_type";

//========================= Sale Summary data for Retailer ================
/*
* {
*   "total-sale-summary-for-retailer":{
*      "#retailer_id":{
*         "total-stt":100,
*         "total-sale-price":10000
*      }
*    }
* }
* */
const totalSaleSummaryForRetailerKey = "total-sale-summary-for-retailer";
const totalSttKey = "total-stt";
const totalSalePriceKey = "total-sale-price";


const outletStockConfiguration = "outlet_stock_configuration";
const outletStockEnable = "is_enable";
const outletStockCountKey = "outlet_stock_count";
const outletStockCountSkuIdKey = "id";
const outletStockCountSkuNameKey = "name";
const outletStockCountSkuShortNameKey = "short_name";
const outletStockCountDamageKey = "damage";
const outletStockCountStockKey = "stock";
const outletStockCountDateKey = "date";


///======================Sales===========================================

// sales key contains all the sales related information for a retailer
/* stored sales format
* {
*   "sales":{
*    "#retailer_id":{
*     "#module_id":{
*       "#sku_id":{
*          "stt":1222,
*          "price":100000,
*          "sales_date":"2022-10-22",
*          "sales_datetime":"2022-10-22 10:11:12"
*           }
*         }
*      }
*    }
* }
* */
const salesKey = "sales";

//salesKey contains volume of sku sold
const salesQtyKey = "stt";

//salesPriceKey contains price of the sku sold
const salesPriceKey = "price";

//salesDateKey contains sales Date
const salesDateKey = "sales_date";

//salesDateTimeKey contains date and time the sales was recorded
const salesDateTimeKey = "sales_datetime";


const syncDataKey = "sync-data";

//stockSyncKey contains a confirmation if lifting stock have been synced from mobile to server
const stockSyncKey = "stock-sync";

const viewComplexityKey = 'view_complexity_key';

const taDaKey = 'taDa-data';

const stockCheckDaya = 'stock_check-data';