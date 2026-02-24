class DraftedTaDa {
  // {
  // "cost_type": "201",
  // "cost": "60"
  // }

  int? costType;
  int? cost;
  String? identity;

  DraftedTaDa({required this.costType, required this.cost});

  DraftedTaDa.fromJson(Map<String, dynamic> json) {
    final ct = json['cost_type'] ?? "0";
    final c = json['cost'] ?? "0";
    costType = int.tryParse(ct) ?? 0;

    if (c is int) {
      cost = c;
    } else if (c is double) {
      cost = c.toInt();
    } else if (c is String) {
      cost = double.tryParse(c)?.toInt() ?? 0;
    } else {
      cost = 0;
    }

    identity = json['identity'] ?? DateTime.now().toIso8601String();
  }
}

class DraftedTaDaData {
  List<DraftedTaDa>? draftedTaDa;
  String? remarks;
  bool? submitted;

  DraftedTaDaData({required this.draftedTaDa, required this.remarks, required this.submitted});

  DraftedTaDaData.fromJson(Map<String, dynamic> json) {
    submitted = json['submitted'] ?? false;
    remarks = json['remarks'] ?? "";

    List<DraftedTaDa> list = [];
    for(var val in json['cost_list'] ?? []) {
      list.add(DraftedTaDa.fromJson(val));
    }

    draftedTaDa = list;
  }
}