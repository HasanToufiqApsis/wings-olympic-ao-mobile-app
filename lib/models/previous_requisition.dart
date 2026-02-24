class PreviousRequisition {
  int? assetId;
  int? assetSbuId;
  int? assetFfId;
  int? assetDepId;
  int? assetSectionId;
  int? assetOutletId;
  String? assetOutletCode;
  String? assetActivityType;
  String? assetActivityId;
  String? assetRequiredSize;
  int? assetRequiredQty;
  String? assetPlacement;
  String? assetAssetCover;
  int? assetTotalBeverageSales;
  int? assetMonthlyPresentAfblSales;
  int? salesAfterCoolerPlacement;
  String? assetCurrentBranding;
  String? assetNameOfBrand;
  String? assetOwnerImage;
  String? assetNidImage;
  String? assetBusinessIdentityImage;
  DateTime? assetDate;
  String? assetCatType;
  String? coolerCatType;
  String? outletName;
  String? route;
  String? billCategory;
  int? assetSalesAfterCoolerPlacement;
  int? assetStatus;
  int? assetCost;
  List<int>? competitorAsset;

  PreviousRequisition({
    this.assetId,
    this.assetSbuId,
    this.assetFfId,
    this.assetDepId,
    this.assetSectionId,
    this.assetOutletId,
    this.assetOutletCode,
    this.assetActivityType,
    this.assetActivityId,
    this.assetRequiredSize,
    this.assetRequiredQty,
    this.assetPlacement,
    this.assetAssetCover,
    this.assetTotalBeverageSales,
    this.assetMonthlyPresentAfblSales,
    this.salesAfterCoolerPlacement,
    this.assetCurrentBranding,
    this.assetNameOfBrand,
    this.assetOwnerImage,
    this.assetNidImage,
    this.assetBusinessIdentityImage,
    this.assetDate,
    this.assetCatType,
    this.coolerCatType,
    this.outletName,
    this.route,
    this.billCategory,
    this.competitorAsset,
    this.assetStatus,
    this.assetCost,
    this.assetSalesAfterCoolerPlacement,
  });

  PreviousRequisition.fromJson(Map<String, dynamic> json) {
    assetId = json['asset_id'];
    assetSbuId = json['asset_sbu_id'];
    assetFfId = json['asset_ff_id'];
    assetDepId = json['asset_dep_id'];
    assetSectionId = json['asset_section_id'];
    assetOutletId = json['asset_outlet_id'];
    assetOutletCode = json['asset_outlet_code'];
    assetActivityType = json['asset_activity_type'];
    assetActivityId = json['asset_activity_id'];
    assetRequiredSize = json['asset_required_size'];
    assetRequiredQty = json['asset_required_qty'];
    assetPlacement = json['asset_placement'];
    assetAssetCover = json['asset_asset_cover'];
    assetTotalBeverageSales = json['asset_total_beverage_sales'];
    assetMonthlyPresentAfblSales = json['asset_monthly_present_afbl_sales'];
    salesAfterCoolerPlacement = json['sales_after_cooler_placement'];
    assetCurrentBranding = json['asset_current_branding'];
    assetNameOfBrand = json['asset_name_of_brand'];
    assetOwnerImage = json['asset_owner_image'];
    assetNidImage = json['asset_nid_image'];
    assetBusinessIdentityImage = json['asset_business_identity_image'];
    assetDate = DateTime.tryParse(json['asset_date']);
    assetCatType = json['asset_cat_type'];
    coolerCatType = json['cooler_cat_type'];
    outletName = json['outlet_name'];
    route = json['route'];
    billCategory = json['asset_bill_category'];
    assetSalesAfterCoolerPlacement = json['asset_sales_after_cooler_placement'];
    assetStatus = json['asset_status'];
    assetCost = json['asset_cost'];
    competitorAsset = json['competitor_asset'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['asset_id'] = assetId;
    data['asset_sbu_id'] = assetSbuId;
    data['asset_ff_id'] = assetFfId;
    data['asset_dep_id'] = assetDepId;
    data['asset_section_id'] = assetSectionId;
    data['asset_outlet_id'] = assetOutletId;
    data['asset_outlet_code'] = assetOutletCode;
    data['asset_activity_type'] = assetActivityType;
    data['asset_activity_id'] = assetActivityId;
    data['asset_required_size'] = assetRequiredSize;
    data['asset_required_qty'] = assetRequiredQty;
    data['asset_placement'] = assetPlacement;
    data['asset_asset_cover'] = assetAssetCover;
    data['asset_total_beverage_sales'] = assetTotalBeverageSales;
    data['asset_monthly_present_afbl_sales'] = assetMonthlyPresentAfblSales;
    data['sales_after_cooler_placement'] = salesAfterCoolerPlacement;
    data['asset_current_branding'] = assetCurrentBranding;
    data['asset_name_of_brand'] = assetNameOfBrand;
    data['asset_owner_image'] = assetOwnerImage;
    data['asset_nid_image'] = assetNidImage;
    data['asset_business_identity_image'] = assetBusinessIdentityImage;
    data['asset_date'] = assetDate;
    data['asset_cat_type'] = assetCatType;
    data['cooler_cat_type'] = coolerCatType;
    data['outlet_name'] = outletName;
    data['route'] = route;
    data['asset_bill_category'] = billCategory;
    data['asset_sales_after_cooler_placement'] = assetSalesAfterCoolerPlacement;
    data['asset_status'] = assetStatus;
    data['asset_cost'] = assetCost;
    data['competitor_asset'] = competitorAsset;
    return data;
  }
}
