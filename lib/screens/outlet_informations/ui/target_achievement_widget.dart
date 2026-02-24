import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/module.dart';
import '../../../models/target/dashboard_target_model.dart';
import '../../../models/target/dashboard_target_model_overall.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../utils/icons/target_icons.dart';
import '../../target_achievement/controller/dashboard_controller.dart';
import '../../target_achievement/ui/target_tab_view_ui.dart';

// ignore: must_be_immutable
class TargetAchievementWidget extends StatelessWidget {
  final List<Module> moduleList;

  TargetAchievementWidget({
    super.key,
    required this.moduleList,
  });

  double totalTarget = 0;
  double achievedTarget = 0;

  @override
  Widget build(BuildContext context) {
    for (var val in moduleList) {
      return Consumer(builder: (context, ref, _) {
        AsyncValue<List<DashboardTargetModelOverall>> asyncTargetList = ref.watch(dashboardTargetListFullValue(val.id));
        return asyncTargetList.when(
            data: (targetData) {
              for (var v in targetData) {
                totalTarget += v.target;
                achievedTarget += v.achieved;
              }
              if (totalTarget == 0 && achievedTarget == 0) {
                return const SizedBox();
              }
              return InkWell(
                onTap: () {
                  DashboardController(context: context, ref: ref).refreshTargetProviders(moduleList.first.id);
                  Navigator.pushNamed(context, TargetTabViewUI.routeName, arguments: {"data": moduleList.first});
                  // print(syncObj[srAchievementKey]);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                  // margin: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          targetWidget(
                            title: 'Total Target',
                            icon: Target.material_symbols_target,
                            totalNumber: totalTarget,
                          ),
                          targetWidget(
                            title: 'Target Achieved!!!',
                            icon: Target.mingcute_target_line,
                            totalNumber: achievedTarget,
                          ),
                        ],
                      ),
                      20.verticalSpacing,
                      LangText('Target Achieved'),
                      10.verticalSpacing,
                      targetAchievedWidget(
                        totalCount: totalTarget.round(),
                        achievedCount: achievedTarget.round(),
                      ),
                    ],
                  ),
                ),
              );
            },
            error: (error, _) => Container(),
            loading: () => Container());
      });
    }

    return SizedBox();
  }

  Widget targetWidget({required String title, required IconData icon, required num totalNumber}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xff1C3726),
              ),
              5.horizontalSpacing,
              LangText(
                title,
                style: const TextStyle(color: Color(0xff1C3726)),
              )
            ],
          ),
          16.verticalSpacing,
          LangText(
            '$totalNumber',
            isNumber: true,
            style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: largeFontSize),
          )
        ],
      ),
    );
  }

  Widget targetAchievedWidget({
    required int totalCount,
    required int achievedCount,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LangText(
          '${(achievedCount * 100) ~/ totalCount}%',
          isNumber: true,
          style: TextStyle(fontSize: bigMediumFontSize, fontWeight: FontWeight.bold),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(1000),
          child: Container(
            color: const Color(0xff006A36).withOpacity(0.1),
            child: Row(
              children: [
                Expanded(
                  flex: (achievedCount * 100) ~/ totalCount,
                  child: Container(
                    height: 15,
                    // width: achievedTarget>0? double.maxFinite : 0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1000),
                      color: primary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 100 - (achievedCount * 100) ~/ totalCount,
                  child: const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
