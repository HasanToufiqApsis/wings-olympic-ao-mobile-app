import 'dart:io';

import 'package:flutter/material.dart';

import '../../../constants/enum.dart';
import '../../../models/AvModel.dart';
import '../../../models/WomModel.dart';
import '../../../models/outlet_model.dart';
import '../../../models/survey/question_model.dart';
import '../../aws_stock/model/aws_product_model.dart';

class SaleDashboardCategoryModel {
  SaleDashboardType type;
  String slug;
  String image;
  String title;
  final dynamic arguments;
  // final bool completed;
  final bool mandatory;
  final bool previouslyComplete;
  final bool forceDisable;
  final bool alreadyComplete;
  final OutletModel? retailer;

  ///stock count item
  final List<AwsProductModel>? stockCountProduct;

  ///for survey
  final List<SurveyModel>? surveyList;

  ///for media
  final List<AvModel>? videoAVs;
  final List<WomModel>? womList;
  final List<WomModel>? kvList;
  final num weight;
  final bool useLocalAsset;

  SaleDashboardCategoryModel({
    required this.type,
    required this.slug,
    required this.image,
    required this.title,
    this.arguments,
    // this.completed = false,
    this.mandatory = false,
    this.previouslyComplete = false,
    this.forceDisable = false,
    this.alreadyComplete = false,
    this.retailer,
    this.stockCountProduct,
    this.surveyList,
    this.videoAVs,
    this.womList,
    this.kvList,
    required this.weight, this.useLocalAsset = false,
  });
}

// class SaleMenuVideo {
//   final AvModel avModel;
//   final File? file;
//
//   SaleMenuVideo({
//     required this.avModel,
//     required this.file,
//   });
// }
