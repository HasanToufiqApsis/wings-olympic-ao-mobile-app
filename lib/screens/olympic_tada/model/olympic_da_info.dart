class OlympicDaInfo {
  final String surveyType;
  final int pointId;
  final int? sectionId;
  final String allowanceType;
  final double amount;
  final String salesDate;

  const OlympicDaInfo({
    required this.surveyType,
    required this.pointId,
    required this.sectionId,
    required this.allowanceType,
    required this.amount,
    required this.salesDate,
  });

  factory OlympicDaInfo.fromJson(Map<String, dynamic> json) {
    return OlympicDaInfo(
      surveyType: json['survey_type']?.toString() ?? '',
      pointId: int.tryParse(json['point_id']?.toString() ?? '') ?? 0,
      sectionId: int.tryParse(json['section_id']?.toString() ?? ''),
      allowanceType: json['allowance_type']?.toString() ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      salesDate: json['sales_date']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'survey_type': surveyType,
      'point_id': pointId,
      'section_id': sectionId,
      'allowance_type': allowanceType,
      'amount': amount,
      'sales_date': salesDate,
    };
  }
}

class OlympicDaResolution {
  final OlympicDaInfo? daInfo;
  final String? message;

  const OlympicDaResolution({this.daInfo, this.message});
}
