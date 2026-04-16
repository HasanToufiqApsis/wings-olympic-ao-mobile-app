import 'dart:developer';
import 'dart:ui';

import 'package:wings_olympic_sr/services/cluster_service.dart';

import '../constants/enum.dart';
import '../services/pre_order_service.dart';
import '../services/sales_service.dart';
import 'cluster_model.dart';
import 'general_id_slug_model.dart';
import 'image_model.dart';

class OutletModel {
  int? id;
  String? outletCode;
  String name;
  String nameBn;
  String owner;
  String? contact;
  String? nid;
  String? address;
  String? outletStatus;
  int? manufacturerlId;
  int? sectionId;
  int? clusterId;
  int? deplId;
  List sbuId;
  bool synced;
  int? newOutletIndex;
  OutletLocationModel outletLocation;
  AvailableOnboardingInfoModel? availableOnboardingInfo;
  ImageModel? outletCoverImage;
  int? priceGroup;
  late int qcPriceGroup;
  List availableAv;
  List availableWOM;
  List availableSurvey;
  bool hasPreOrdered;
  bool hasZeroSales;
  Map<int, Map> availablePromotions;
  Map<int, Map> availableQpsPromotions;
  Map<int, Map> availableTryBeforeBuy;
  late double totalSale;
  late bool preorderExists;
  late bool spotSalesExists;
  ClusterModel? cluster;
  String? outlet_cover_image;
  String? outletCoolerImage;

  OutletModel({
    this.id,
    this.outletCode,
    required this.name,
    required this.nameBn,
    required this.owner,
    this.contact,
    this.nid,
    this.address,
    this.availableOnboardingInfo,
    required this.outletLocation,
    required this.sbuId,
    this.manufacturerlId,
    this.sectionId,
    this.clusterId,
    this.deplId,
    required this.synced,
    this.newOutletIndex,
    required this.priceGroup,
    required this.qcPriceGroup,
    this.outletCoverImage,
    required this.availableAv,
    required this.availableWOM,
    required this.availableSurvey,
    this.hasPreOrdered = false,
    this.hasZeroSales = false,
    required this.availablePromotions,
    required this.availableQpsPromotions,
    required this.availableTryBeforeBuy,
    required this.totalSale,
    required this.preorderExists,
    required this.spotSalesExists,
    this.cluster,
    required this.outletStatus,
    this.outlet_cover_image,
    this.outletCoolerImage,
  }) : assert(id != null || outletCode != null);

  factory OutletModel.fromJson(Map json) {
    AvailableOnboardingInfoModel? ao;
    if (json.containsKey("available_onboarding_info")) {
      if (json["available_onboarding_info"] != null) {
        ao = AvailableOnboardingInfoModel.fromJson(json["available_onboarding_info"]);
      }
    }

    ImageModel? cp;
    if (json.containsKey("outlet_cover_photo")) {
      if (json["outlet_cover_photo"].toString().substring(0, 4) == "http") {
        cp = ImageModel(image: json["outlet_cover_photo"] + "?v=", imageType: ImageType.network);
      } else {
        cp = ImageModel(image: json["outlet_cover_photo"], imageType: ImageType.file);
      }
    }

    //for initializing available promotion for retailer
    Map<int, Map> p = {};
    if (json.containsKey("available_promotions")) {
      if (json['available_promotions'].isNotEmpty) {
        json['available_promotions'].forEach((e) {
          p[e['id']] = e;
        });
      }
    }

    // log("available promotion:::: ${json["outlet_code"]} $p");

    //for initializing available QPS promotion for retailer
    Map<int, Map> qpsPromotions = {};
    if (json.containsKey("available_qps_promotions")) {
      if (json['available_qps_promotions'].isNotEmpty) {
        json['available_qps_promotions'].forEach((e) {
          qpsPromotions[e['id']] = e;
        });
      }
    }

    //for initializing available try before buy for retailer
    Map<int, Map> tb = {};
    if (json.containsKey("available_try_before_you_buy")) {
      if (json['available_try_before_you_buy'].isNotEmpty) {
        json['available_try_before_you_buy'].forEach((e) {
          tb[e['id']] = e;
        });
      }
    }
    // double totalSalePrice = json['id']==null? 0 : SalesService().getTotalSalePriceForARetailer(json['id']);
    double totalSalePrice = 0;
    bool preorderExists = false;
    bool spotSalesExists = false;
    final cluster = ClusterService().getClusterFromId(clusterId: json["cluster_id"] ?? 0);

    return OutletModel(
      id: json["id"],
      outletCode: json["outlet_code"],
      name: json["outlet_name"],
      nameBn: json["outlet_name_bn"],
      owner: json["owner"],
      contact: json["contact"],
      nid: json["nid"],
      address: json["address"],
      outletStatus: json['approval_status']??"",
      availableOnboardingInfo: ao,
      outletLocation: OutletLocationModel.fromJson(json),
      sbuId: json["sbu_id"] ?? [1],
      manufacturerlId: json["manufacturer_id"] ?? 6,
      sectionId: json["section_id"],
      clusterId: json["cluster_id"],
      deplId: json["dep_id"],
      synced: json["has_synced"] ?? true,
      newOutletIndex: json["outlet_mum"],
      priceGroup: json["price_group"],
      qcPriceGroup: json["qc_price_group"] ?? 0,
      outletCoverImage: cp,
      availablePromotions: p,
      availableAv: json.containsKey("available_av") ? json["available_av"] : [],
      availableWOM: json.containsKey("available_wom") ? json["available_wom"] : [],
      availableSurvey: json.containsKey("available_surveys") ? json["available_surveys"] : [],
      availableTryBeforeBuy: tb,
      availableQpsPromotions: qpsPromotions,
      totalSale: totalSalePrice,
      preorderExists: preorderExists,
      spotSalesExists: spotSalesExists,
      cluster: cluster,
      outlet_cover_image: json["outlet_cover_image"],
      outletCoolerImage: json["outlet_cooler_image"],
    );
  }

  setCoverImage(String imagePath) {
    ImageModel? cp;
    if (imagePath.substring(0, 4) == "http") {
      cp = ImageModel(image: "$imagePath?v=", imageType: ImageType.network);
    } else {
      cp = ImageModel(image: imagePath, imageType: ImageType.file);
    }
    outletCoverImage = cp;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data["outlet_code"] = outletCode;
    data["has_synced"] = synced;
    data["outlet_num"] = newOutletIndex;
    data['outlet_name'] = name;
    data['outlet_name_bn'] = nameBn;
    data['approval_status']=outletStatus;
    data['outlet_cover_photo'] = outletCoverImage?.image;
    data['owner'] = owner;
    data['contact'] = contact;
    data['nid'] = nid;
    data['address'] = address;
    data['manufacturer_id'] = manufacturerlId;
    data['sbu_id'] = sbuId;
    data['dep_id'] = deplId;
    data['section_id'] = sectionId;
    data['lat'] = outletLocation.latitude;
    data['long'] = outletLocation.longitude;
    data['price_group'] = priceGroup;
    data['qc_price_group'] = qcPriceGroup;
    data['allowable_distance'] = outletLocation.allowableDistance;
    data['reasoning_check'] = outletLocation.reasoningCheck;
    data['outlet_cover_image'] = outlet_cover_image;
    data['outlet_cooler_image'] = outletCoolerImage;
    data['cluster_id'] = clusterId;
    if (availableOnboardingInfo != null) {
      data['available_onboarding_info'] = availableOnboardingInfo!.toJson();
    }
    return data;
  }
}

class AvailableOnboardingInfoModel {
  final GeneralIdSlugModel? businessType;
  final GeneralIdSlugModel? channelCategory;
  final String coolerStatus;
  final GeneralIdSlugModel? cooler;
  late final ImageModel? coolerPhotoImage;

  AvailableOnboardingInfoModel({
    this.businessType,
    this.channelCategory,
    required this.coolerStatus,
    this.cooler,
    this.coolerPhotoImage,
  });

  factory AvailableOnboardingInfoModel.fromJson(Map json) {
    GeneralIdSlugModel? bt;
    GeneralIdSlugModel? cg;
    GeneralIdSlugModel? c;
    ImageModel? cp;
    if (json.containsKey("business_type")) {
      if (json["business_type"] != null) {
        bt = GeneralIdSlugModel.fromJson(json["business_type"]);
      }
    }

    if (json.containsKey("channel_category")) {
      if (json["channel_category"] != null) {
        cg = GeneralIdSlugModel.fromJson(json["channel_category"]);
      }
    }

    if (json.containsKey("cooler")) {
      if (json["cooler"] != null) {
        c = GeneralIdSlugModel.fromJson(json["cooler"]);
      }
    }
    if (json.containsKey("cooler_photo_url")) {
      if (json["cooler_photo_url"] != null) {
        if (json["cooler_photo_url"].toString().substring(0, 4) == "http") {
          cp = ImageModel(image: json["cooler_photo_url"] + "?v=", imageType: ImageType.network);
          cp = ImageModel(image: json["cooler_photo_url"] + "?v=", imageType: ImageType.network);
        } else {
          cp = ImageModel(image: json["cooler_photo_url"], imageType: ImageType.file);
        }
      }
    }

    return AvailableOnboardingInfoModel(businessType: bt, channelCategory: cg, coolerStatus: json["cooler_status"], cooler: c, coolerPhotoImage: cp);
    return AvailableOnboardingInfoModel(businessType: bt, channelCategory: cg, coolerStatus: json["cooler_status"], cooler: c, coolerPhotoImage: cp);
  }

  setCoolerImage(String? imagePath) {
    if (imagePath == null) {
      return;
    }
    ImageModel? cp;
    if (imagePath.substring(0, 4) == "http") {
      cp = ImageModel(image: "$imagePath?v=", imageType: ImageType.network);
    } else {
      cp = ImageModel(image: imagePath, imageType: ImageType.file);
    }
    coolerPhotoImage = cp;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (businessType != null) {
      data['business_type'] = businessType!.toJson();
    }
    if (channelCategory != null) {
      data['channel_category'] = channelCategory!.toJson();
    }
    data['cooler_status'] = coolerStatus;
    if (cooler != null) {
      data['cooler'] = cooler!.toJson();
    }
    data["cooler_photo_url"] = coolerPhotoImage?.image;
    return data;
  }
}

class OutletLocationModel {
  num latitude;
  num longitude;
  final num allowableDistance;
  final bool reasoningCheck;

  OutletLocationModel({required this.latitude, required this.longitude, required this.allowableDistance, required this.reasoningCheck});

  factory OutletLocationModel.fromJson(Map json) {
    return OutletLocationModel(
        latitude: json["lat"] ?? 0.0,
        longitude: json["long"] ?? 0.0,
        allowableDistance: json["allowable_distance"] ?? 0.0,
        reasoningCheck: json["reasoning_check"] == 1);
  }
}
