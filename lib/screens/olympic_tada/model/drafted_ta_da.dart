import 'olympic_da_info.dart';

class DraftedTaDa {
  int? costType;
  int? cost;
  String? identity;
  int? vehicleId;
  String? vehicleSlug;
  String? fromLocation;
  String? toLocation;
  String? km;
  String? remarks;

  DraftedTaDa({
    this.costType,
    this.cost,
    this.identity,
    this.vehicleId,
    this.vehicleSlug,
    this.fromLocation,
    this.toLocation,
    this.km,
    this.remarks,
  });

  factory DraftedTaDa.fromJson(Map<String, dynamic> json) {
    final rawCost = json['amount'] ?? json['cost'] ?? 0;

    int parsedCost;
    if (rawCost is int) {
      parsedCost = rawCost;
    } else if (rawCost is double) {
      parsedCost = rawCost.toInt();
    } else {
      parsedCost = double.tryParse(rawCost.toString())?.toInt() ?? 0;
    }

    return DraftedTaDa(
      costType: int.tryParse(
        (json['vehicle_id'] ?? json['cost_type'] ?? 0).toString(),
      ),
      cost: parsedCost,
      identity: json['identity']?.toString() ??
          DateTime.now().toIso8601String(),
      vehicleId: int.tryParse(json['vehicle_id']?.toString() ?? ''),
      vehicleSlug: json['vehicle_slug']?.toString(),
      fromLocation:
          (json['from'] ?? json['from_location'])?.toString(),
      toLocation: (json['to'] ?? json['to_location'])?.toString(),
      km: json['km']?.toString(),
      remarks: (json['remarks'] ?? json['remark'])?.toString(),
    );
  }
}

class DraftedTaDaData {
  List<DraftedTaDa>? draftedTaDa;
  String? remarks;
  bool? submitted;
  OlympicDaInfo? daInfo;
  String? salesDate;

  DraftedTaDaData({
    required this.draftedTaDa,
    required this.remarks,
    required this.submitted,
    this.daInfo,
    this.salesDate,
  });

  factory DraftedTaDaData.fromJson(Map<String, dynamic> json) {
    final List<DraftedTaDa> list = [];
    final rawRows = json['ta_rows'] ?? json['cost_list'] ?? <dynamic>[];
    for (final val in rawRows) {
      if (val is Map<String, dynamic>) {
        list.add(DraftedTaDa.fromJson(val));
      } else if (val is Map) {
        list.add(DraftedTaDa.fromJson(Map<String, dynamic>.from(val)));
      }
    }

    OlympicDaInfo? daInfo;
    final rawDaInfo = json['da_info'];
    if (rawDaInfo is Map<String, dynamic>) {
      daInfo = OlympicDaInfo.fromJson(rawDaInfo);
    } else if (rawDaInfo is Map) {
      daInfo = OlympicDaInfo.fromJson(Map<String, dynamic>.from(rawDaInfo));
    }

    return DraftedTaDaData(
      draftedTaDa: list,
      remarks: json['remarks']?.toString() ?? '',
      submitted: json['submitted'] == true,
      daInfo: daInfo,
      salesDate: json['sales_date']?.toString(),
    );
  }
}
