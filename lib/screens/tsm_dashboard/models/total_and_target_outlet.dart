class TotalAndTargetOutlet {
  String? target;
  String? visited;
  String? totalOutlet;
  String? coolerOutlet;

  TotalAndTargetOutlet({
    this.target,
    this.visited,
    this.totalOutlet,
    this.coolerOutlet,
  });

  TotalAndTargetOutlet.fromJson(Map<String, dynamic> json) {
    target = json['target']?.toString();
    visited = json['visited']?.toString();
    totalOutlet = json['total_outlet']?.toString();
    coolerOutlet = json['cooler_outlet']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['target'] = target;
    data['visited'] = visited;
    data['total_outlet'] = totalOutlet;
    data['cooler_outlet'] = coolerOutlet;
    return data;
  }

  String getTotalVsTargetPercentage() {
    final totalOutletInt = int.tryParse(totalOutlet ?? '0') ?? 0;
    final targetInt = int.tryParse(target ?? '0') ?? 0;
    final result = (targetInt * 100) / totalOutletInt;

    if (totalOutletInt == 0) return '0';

    return result.toStringAsFixed(0);
  }
}
