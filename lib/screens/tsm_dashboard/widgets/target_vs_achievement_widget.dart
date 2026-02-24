import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/constant_variables.dart';
import '../../../main.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../models/target_vs_achivement.dart';
import '../providers/tsm_dahboard_providers.dart';
import '../tsm_team_performance/ui/team_performance_new_ui.dart';

class TargetVsAchievementWidget extends StatelessWidget {
  final double cardHeight;

  const TargetVsAchievementWidget({
    super.key,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final asyncData = ref.watch(targetVsAchievementDataProvider);

        return asyncData.when(
          data: (data) {
            Future.delayed(const Duration(seconds: 2)).then((val) {
              ref.read(radtProvider.notifier).state = data.radt?.toStringAsFixed(2) ?? '0.0';
            });

            return getWidget(data: data);
          },
          error: (error, stck) => getWidget(),
          loading: () => getWidget(),
        );
      },
    );
  }

  Widget getWidget({TargetVsAchievement? data}) {
    double progressValue = 0;
    if (data?.getTargetAchievementPercentage() != null) {
      if ((data?.getTargetAchievementPercentage() ?? 0) > 0) {
        progressValue = data!.getTargetAchievementPercentage() / 100;
      }
    }

    return Container(
      height: cardHeight,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: tealBlue,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LangText(
                'Target vs Achievement',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkResponse(
                onTap: () {
                  navigatorKey.currentState?.pushNamed(TeamPerformanceNewUI.routeName);
                },
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LangText(
                    'Sale',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    children: [
                      LangText(
                        data?.getTargetAchievementPercentage().toStringAsFixed(2) ?? '0.0',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                        isNum: true,
                        isNumber: true,
                      ),
                      LangText(
                        '%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progressValue,
                backgroundColor: Colors.white.withOpacity(.2),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                minHeight: 8,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ],
      ),
    );
  }
}
