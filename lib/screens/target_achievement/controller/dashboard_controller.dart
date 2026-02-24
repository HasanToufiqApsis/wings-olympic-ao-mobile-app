
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/constant_variables.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../ui/target_tab_view_ui.dart';

class DashboardController{
  final BuildContext context;
  final WidgetRef ref;

  DashboardController({required this.context, required this.ref}): _alerts = Alerts(context: context);

  late final Alerts _alerts;




  Color getTargetColor({required double achievement, required double minimumTarget}){
    Color color = Colors.red;
    if(achievement >= (minimumTarget * 0.71) && achievement <= (minimumTarget * 0.85)){
      color = Colors.amber;
    }
    else if(achievement > (minimumTarget * 0.85)){
      color = darkGreen;
    }
    return color;
  }


  refreshTargetProviders(int moduleId){
    ref.refresh(sttByTypeProvider(moduleId));
    ref.refresh(specialSttByTypeProvider(moduleId));
    ref.refresh(bcpByTypeProvider(moduleId));
  }

}