class SkuInfoModel {
  final int id;
  final String shortName;
  final String materialCode;

  SkuInfoModel({
    required this.id,
    required this.shortName,
    required this.materialCode,
  });

  factory SkuInfoModel.fromJson(Map json) {
    return SkuInfoModel(
      id: json['id'] ?? 0,
      shortName: json['short_name'] ?? '',
      materialCode: json['material_code'] ?? '',
    );
  }
}

class QcEntryModel {
  final int depId;
  final int sectionId;
  final int outletId;
  final String outletCode;
  final int skuId;
  final int faultId;
  final String faultType;
  final num volume;
  final num value;
  final num unitPrice;
  final String qcEntryDate;
  final SkuInfoModel skuInfo;

  QcEntryModel({
    required this.depId,
    required this.sectionId,
    required this.outletId,
    required this.outletCode,
    required this.skuId,
    required this.faultId,
    required this.faultType,
    required this.volume,
    required this.value,
    required this.unitPrice,
    required this.qcEntryDate,
    required this.skuInfo,
  });

  factory QcEntryModel.fromJson(Map json) {
    return QcEntryModel(
      depId: json['dep_id'] ?? 0,
      sectionId: json['section_id'] ?? 0,
      outletId: json['outlet_id'] ?? 0,
      outletCode: json['outlet_code'] ?? '',
      skuId: json['sku_id'] ?? 0,
      faultId: json['fault_id'] ?? 0,
      faultType: json['fault_type'] ?? '',
      volume: num.tryParse(json['volume'].toString()) ?? 0,
      value: json['value'] ?? 0,
      unitPrice: json['unit_price'] ?? 0,
      qcEntryDate: json['qc_entry_date'] ?? '',
      skuInfo: SkuInfoModel.fromJson(json['sku_info'] ?? {}),
    );
  }
}

/// qcData structure: { outletId: { date: [QcEntryModel, ...] } }
class StockValidationResponseModel {
  final Map<String, Map<String, List<QcEntryModel>>> qcData;
  final String lastSubmittedDate;

  StockValidationResponseModel({
    required this.qcData,
    required this.lastSubmittedDate,
  });

  factory StockValidationResponseModel.fromJson(Map json) {
    final Map<String, Map<String, List<QcEntryModel>>> parsed = {};

    final rawQcData = json['qcData'] as Map? ?? {};
    rawQcData.forEach((outletId, dateMap) {
      parsed[outletId.toString()] = {};
      (dateMap as Map).forEach((date, entries) {
        parsed[outletId.toString()]![date.toString()] =
            (entries as List).map((e) => QcEntryModel.fromJson(e)).toList();
      });
    });

    return StockValidationResponseModel(
      qcData: parsed,
      lastSubmittedDate: json['lastSubmittedDate'] ?? '',
    );
  }
}
