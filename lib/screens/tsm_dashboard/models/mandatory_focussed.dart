class MandatoryFocussed {
  int? skuId;
  String? materialCode;
  String? filterType;
  num? volume;

  MandatoryFocussed({
    this.skuId,
    this.materialCode,
    this.filterType,
    this.volume,
  });

  MandatoryFocussed.fromJson(Map<String, dynamic> json) {
    skuId = json['sku_id'];
    materialCode = json['material_code'];
    filterType = json['filter_type'];
    volume = json['volume'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sku_id'] = skuId;
    data['material_code'] = materialCode;
    data['filter_type'] = filterType;
    data['volume'] = volume;
    return data;
  }
}
