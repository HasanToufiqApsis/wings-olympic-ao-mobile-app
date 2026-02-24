import 'package:flutter/foundation.dart';

import '../../utils/performance_util.dart';

class PerformanceModel {
  STTModel? sttModel;
  TotalSTTModel? totalSTTModel;
  StrikeRateModel? strikeRateModel;
  StrikeRateModel? geoFencingModel;
  BCPModel? bcpModel;

  PerformanceModel({
    required this.sttModel,
  });

  List<PerformanceType> performanceTypeList() {
    return [
      ...sttModel == null ? [] : [PerformanceType.stt],
      ...totalSTTModel == null ? [] : [PerformanceType.totalStt],
      ...strikeRateModel == null ? [] : [PerformanceType.strikeRate],
      ...geoFencingModel == null ? [] : [PerformanceType.geoFencing],
      ...bcpModel == null ? [] : [PerformanceType.bcp],
    ];
  }

  bool get isNull => _isNull();

  bool _isNull() {
    return sttModel == null &&
        totalSTTModel == null &&
        strikeRateModel == null &&
        geoFencingModel == null &&
        bcpModel == null;
  }

  PerformanceModel.fromJson(Map<String, dynamic> json) {
    try {
      sttModel = STTModel.fromJson(json['STT']);
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }
    try {
      totalSTTModel = TotalSTTModel.fromJson(json['Total STT']);
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }
    try {
      strikeRateModel = StrikeRateModel.fromJson(json['Strike Rate']);
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }
    try {
      geoFencingModel = StrikeRateModel.fromJson(json['Geo Fencing']);
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }
    try {
      bcpModel = BCPModel.fromJson(json['BCP']);
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }
  }
}

/// ------------------------------------------------------------------------

class STTModel {
  String? type;
  STTData? data;

  STTModel({this.type, this.data});

  STTModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = json['data'] != null ? STTData.fromJson(json['data']) : null;
  }
}

class STTData {
  num? totalTarget;
  num? totalAchievement;
  List<STTDetails>? details;

  STTData({this.totalTarget, this.totalAchievement, this.details});

  STTData.fromJson(Map<String, dynamic> json) {
    totalTarget = json['total_target'];
    totalAchievement = json['total_achievement'];
    if (json['details'] != null) {
      details = <STTDetails>[];
      json['details'].forEach((v) {
        details!.add(STTDetails.fromJson(v));
      });
    }
  }
}

class STTDetails {
  String? label;
  num? target;
  num? achievement;
  int? product_id;
  int? category_id;

  STTDetails({
    this.label,
    this.target,
    this.achievement,
    this.product_id,
    this.category_id,
  });

  STTDetails.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    target = json['target'];
    achievement = json['achievement'];
    product_id = json['product_id'];
    category_id = json['category_id'];
  }
}

/// -------------------------------------------------------------------------

class TotalSTTModel {
  String? type;
  TotalSTTData? data;

  TotalSTTModel({this.type, this.data});

  TotalSTTModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = json['data'] != null ? TotalSTTData.fromJson(json['data']) : null;
  }
}

class TotalSTTData {
  num? totalTarget;
  num? totalAchievement;

  TotalSTTData({this.totalTarget, this.totalAchievement});

  TotalSTTData.fromJson(Map<String, dynamic> json) {
    totalTarget = json['total_target'];
    totalAchievement = json['total_achievement'];
  }
}

/// ------------------------------------------------------------------------

class StrikeRateModel {
  String? type;
  StrikeRateData? data;

  StrikeRateModel({this.type, this.data});

  StrikeRateModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = json['data'] != null ? StrikeRateData.fromJson(json['data']) : null;
  }
}

class StrikeRateData {
  num? totalTarget;
  num? totalAchievement;
  List<int>? details;

  StrikeRateData({this.totalTarget, this.totalAchievement, this.details});

  StrikeRateData.fromJson(Map<String, dynamic> json) {
    totalTarget = json['total_target'];
    totalAchievement = json['total_achievement'];
    details = json['details'].cast<int>();
  }
}

/// ------------------------------------------------------------------------

class BCPModel {
  String? type;
  BCPData? data;

  BCPModel({this.type, this.data});

  BCPModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = json['data'] != null ? BCPData.fromJson(json['data']) : null;
  }
}

class BCPData {
  List<BCPDetails>? details;

  BCPData({this.details});

  BCPData.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = <BCPDetails>[];
      json['details'].forEach((v) {
        details!.add(BCPDetails.fromJson(v));
      });
    }
  }
}

class BCPDetails {
  String? label;
  int? target;
  int? achievement;
  int? productId;
  int? categoryId;

  BCPDetails({this.label, this.target, this.achievement, this.productId, this.categoryId});

  BCPDetails.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    target = json['target'];
    achievement = json['achievement'];
    productId = json['product_id'];
    categoryId = json['category_id'];
  }
}
