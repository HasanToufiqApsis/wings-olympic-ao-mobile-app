import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/constant_variables.dart';
import '../../tsm_dashboard/providers/tsm_dahboard_providers.dart';
import '../../tsm_dashboard/widgets/cpr_radt_cpc_widget.dart';
import '../../tsm_dashboard/widgets/mandatory_and _focussed_widget.dart';
import '../../tsm_dashboard/widgets/target_vs_achievement_widget.dart';
import '../../tsm_dashboard/widgets/total_and_target_outlet_widget.dart.dart';
import '../../tsm_dashboard/widgets/visited_and_no_order_outlet_widget.dart';
import '../controller/outlet_controller.dart';

class TSMDashboard extends ConsumerStatefulWidget {
  const TSMDashboard({Key? key}) : super(key: key);

  @override
  ConsumerState<TSMDashboard> createState() => _TSMDashboardState();
}

class _TSMDashboardState extends ConsumerState<TSMDashboard> {
  late final OutletController _outletController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  ref.refresh(visitedAndNoOrderOutletDataProvider);
                      ref.refresh(totalAndTargetOutletDataProvider);
                      ref.refresh(targetVsAchievementDataProvider);
                      ref.refresh(cprRadtCpcDataProvider);
                      ref.refresh(radtProvider);
                      ref.refresh(mandatoryFocussedDataProvider);
                },
                child: Icon(Icons.refresh, color: primary,),
              ),
              // IconButton(
              //   onPressed: () {
              //     ref.refresh(visitedAndNoOrderOutletDataProvider);
              //     ref.refresh(totalAndTargetOutletDataProvider);
              //     ref.refresh(targetVsAchievementDataProvider);
              //     ref.refresh(cprRadtCpcDataProvider);
              //     ref.refresh(radtProvider);
              //     ref.refresh(mandatoryFocussedDataProvider);
              //   },
              //   icon: const Icon(Icons.refresh),
              //   color: primaryGreen,
              // ),
            ],
          ),
          const SizedBox(height: 12),
          const TargetVsAchievementWidget(cardHeight: 120),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                child: VisitedAndNoOrderOutletWidget(
                  cardHeight: 145,
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: TotalAndTargetOutletWidget(
                  cardHeight: 145,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              // Expanded(
              //   flex: 2,
              //   child: GeoDataDashboardWidget(
              //     cardHeight: 145,
              //   ),
              // ),
              // SizedBox(width: 6),
              Expanded(
                child: CprRadtCpcWidget(
                  cardHeight: 145,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const MandatoryAndFocussedWidget(cardHeight: 80),
          const SizedBox(height: 56),
        ],
      ),
    );
  }
}
