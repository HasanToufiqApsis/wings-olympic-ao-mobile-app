import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import '../../../../constants/constant_variables.dart';
import '../../../../provider/global_provider.dart';
import '../../../../reusable_widgets/language_textbox.dart';
import '../../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../widgets/target_and_achievement_dashboard_ui_tsm.dart';

class TeamPerformanceNewUI extends ConsumerStatefulWidget {
  static const routeName = "team_performance_new_ui";

  const TeamPerformanceNewUI({super.key});

  @override
  ConsumerState<TeamPerformanceNewUI> createState() => _TeamPerformanceNewUIState();
}

class _TeamPerformanceNewUIState extends ConsumerState<TeamPerformanceNewUI> {
  final List colorsList = [
    {
      'main': primary,
      'color-1': greenOlive.withOpacity(0.1),
      'color-2': greenOlive,
    },
    {
      'main': purple,
      'color-1': redDeep.withOpacity(0.1),
      'color-2': redDeep,
    },
    {
      'main': auroraGreen,
      'color-1': yellowSun.withOpacity(0.1),
      'color-2': yellowSun,
    },
    {
      'main': auroraGreen,
      'color-1': greenPaste.withOpacity(0.1),
      'color-2': greenPaste,
    }
  ];

  @override
  Widget build(BuildContext context) {
    final asyncPerformanceList = ref.watch(targetAchievementListProvider);
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Target vs Achievement',
      ),
      body: asyncPerformanceList.when(
        data: (performanceList) {
          if (performanceList.isNotEmpty) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              itemBuilder: (context, index) {
                return TargetNAchievementUITsm(
                  color: colorsList[1],
                  data: performanceList[index].dashboardTargetModel,
                  dsr: performanceList[index].dsrModel,
                  targetList: performanceList[index].sttTargetList,
                );
              },
              itemCount: performanceList.length,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 1.h,
                );
              },
            );
          }
          return Center(
            child: LangText("No data found"),
          );
        },
        error: (e, s) {
          return const SizedBox();
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
