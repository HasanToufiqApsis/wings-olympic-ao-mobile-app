import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wings_olympic_sr/screens/tsm_dashboard/widgets/title_value_column.dart';

import '../../../constants/constant_variables.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/shapes/circular_progress_painter.dart';
import '../models/total_and_target_outlet.dart';
import '../providers/tsm_dahboard_providers.dart';

class TotalAndTargetOutletWidget extends ConsumerStatefulWidget {
  final double? cardHeight;

  const TotalAndTargetOutletWidget({Key? key, this.cardHeight}) : super(key: key);

  @override
  ConsumerState<TotalAndTargetOutletWidget> createState() => _WingsSalesWidgetState();
}

class _WingsSalesWidgetState extends ConsumerState<TotalAndTargetOutletWidget>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  AnimationController? controller;

  // double _animFraction = 0.0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    final Animation curve = CurvedAnimation(
      parent: controller!,
      curve: Curves.decelerate,
    );
    animation = Tween<double>(begin: 50, end: 50).animate(
      curve as Animation<double>,
    )..addListener(
        () {
          // setState(() {
          //   _animFraction = animation.value;
          // });
        },
      );
    controller?.forward();
  }

  @override
  void dispose() {
    controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final asyncData = ref.watch(totalAndTargetOutletDataProvider);

        return asyncData.when(
          data: (data) => getWidget(data: data),
          error: (error, stck) => getWidget(),
          loading: () => getWidget(),
        );
      },
    );
  }

  Widget getWidget({TotalAndTargetOutlet? data}) {
    return Container(
      height: widget.cardHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: primaryBlue,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TitleValueColumn(
                  title: 'Total Outlet',
                  value: data?.totalOutlet ?? '0',
                  isNumericValue: true,
                ),
                TitleValueColumn(
                  title: 'Target Outlet',
                  value: data?.target ?? '0',
                  isNumericValue: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 60,
            width: 60,
            child: CustomPaint(
              painter: CircularProgressPainter(
                lineColor: Colors.white.withOpacity(.2),
                completeColor: const Color(0xFF59F39B),
                completedGradientColor: const [
                  Colors.white,
                  Colors.white,
                ],
                completePercent: double.tryParse(data?.getTotalVsTargetPercentage() ?? '0') ?? 0,
                width: 6,
                showProgressShadow: true,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LangText(
                      data?.getTotalVsTargetPercentage() ?? '0',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      isNumber: true,
                      isNum: true,
                    ),
                    LangText(
                      '%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
