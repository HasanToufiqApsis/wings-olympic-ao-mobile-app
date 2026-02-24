class CprRadtCpc {
  double? roi;
  double? he;
  double? pjpPercentage;
  double? vpc;
  double? totalMemo;
  double? cpr;
  double? lpc;
  double? totalVolume;

  CprRadtCpc({
    this.roi,
    this.he,
    this.pjpPercentage,
    this.vpc,
    this.totalMemo,
    this.cpr,
    this.lpc,
    this.totalVolume,
  });

  CprRadtCpc.fromJson(Map<String, dynamic> json) {
    roi = double.tryParse(json['roi']?.toString() ?? '0');
    he = double.tryParse(json['he']?.toString() ?? '0');
    pjpPercentage = double.tryParse(json['pjpPercentage']?.toString() ?? '0');
    vpc = double.tryParse(json['vpc']?.toString() ?? '0');
    totalMemo = double.tryParse(json['total_memo']?.toString() ?? '0');
    cpr = double.tryParse(json['cpr']?.toString() ?? '0');
    lpc = double.tryParse(json['lpc']?.toString() ?? '0');
    totalVolume = double.tryParse(json['total_volume']?.toString() ?? '0');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roi'] = roi;
    data['he'] = he;
    data['pjpPercentage'] = pjpPercentage;
    data['vpc'] = vpc;
    data['total_memo'] = totalMemo;
    data['cpr'] = cpr;
    data['lpc'] = lpc;
    data['total_volume'] = totalVolume;
    return data;
  }
}
