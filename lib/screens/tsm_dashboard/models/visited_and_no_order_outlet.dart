class VisitedAndNoOrderOutlet {
  String? noOrderOutlet;
  String? visitedOutlet;

  VisitedAndNoOrderOutlet({this.noOrderOutlet, this.visitedOutlet});

  VisitedAndNoOrderOutlet.fromJson(Map<String, dynamic> json) {
    noOrderOutlet = json['noOrderOutlet'];
    visitedOutlet = json['visitedOutlet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['noOrderOutlet'] = noOrderOutlet;
    data['visitedOutlet'] = visitedOutlet;
    return data;
  }

  String getPercentage() {
    final noOrderInt = int.tryParse(noOrderOutlet ?? '0') ?? 0;
    final visitedInt = int.tryParse(visitedOutlet ?? '0') ?? 0;
    final result = (noOrderInt * 100) / visitedInt;

    if (visitedInt == 0) return '0';

    return result.toStringAsFixed(0);
  }
}
