import 'package:flutter/foundation.dart';

class TargetVsAchievement {
  TargetData? targetData;
  List<AchievementData> achievementData = const [];
  num? radt;

  TargetVsAchievement({
    this.targetData,
    this.achievementData = const [],
    this.radt,
  });

  TargetVsAchievement.fromJson(Map<String, dynamic> json) {
    targetData = json['targetData'] != null ? new TargetData.fromJson(json['targetData']) : null;
    if (json['achievementData'] != null) {
      achievementData = <AchievementData>[];
      json['achievementData'].forEach((v) {
        achievementData.add(AchievementData.fromJson(v));
      });
    }
    radt = json['radt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (targetData != null) {
      data['targetData'] = targetData!.toJson();
    }
    data['achievementData'] = achievementData.map((v) => v.toJson()).toList();
    data['radt'] = radt;
    return data;
  }

  num getTargetInVolume() => targetData?.target ?? 0;
  num getTargetValue() => targetData?.value ?? 0;

  num getAchievementVolume () {
    try {
      return achievementData.last.cumulativeVolume ?? 0;
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
      return 0;
    }
  }

  num getAchievementValue () {
    try {
      return achievementData.last.cumulativeValue ?? 0;
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
      return 0;
    }
  }

  num getTargetAchievementPercentage() {
    final target = getTargetInVolume();
    final achievement = getAchievementVolume();

    if (target == 0) return 0;
    if (achievement == 0) return 0;

    return (achievement * 100) / target;
  }
}

class TargetData {
  num? target;
  num? value;
  String? startDate;
  String? endDate;

  TargetData({this.target, this.value, this.startDate, this.endDate});

  TargetData.fromJson(Map<String, dynamic> json) {
    target = json['target'];
    value = json['value'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['target'] = target;
    data['value'] = value;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    return data;
  }
}

class AchievementData {
  String? date;
  num? volume;
  num? value;
  num? cumulativeVolume;
  num? cumulativeValue;

  AchievementData({
    this.date,
    this.volume,
    this.value,
    this.cumulativeVolume,
    this.cumulativeValue,
  });

  AchievementData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    volume = json['volume'];
    value = json['value'];
    cumulativeVolume = json['cumulativeVolume'];
    cumulativeValue = json['cumulativeValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['volume'] = volume;
    data['value'] = value;
    data['cumulativeVolume'] = cumulativeVolume;
    data['cumulativeValue'] = cumulativeValue;
    return data;
  }
}
