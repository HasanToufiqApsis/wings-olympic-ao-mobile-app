import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/constant_variables.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/shapes/circular_progress_painter.dart';
import '../models/visited_and_no_order_outlet.dart';
import '../providers/tsm_dahboard_providers.dart';
import 'title_value_column.dart';

class VisitedAndNoOrderOutletWidget extends ConsumerStatefulWidget {
  final double? cardHeight;

  const VisitedAndNoOrderOutletWidget({Key? key, this.cardHeight}) : super(key: key);

  @override
  ConsumerState<VisitedAndNoOrderOutletWidget> createState() => _WingsSalesWidgetState();
}

class _WingsSalesWidgetState extends ConsumerState<VisitedAndNoOrderOutletWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(visitedAndNoOrderOutletDataProvider);

    return asyncData.when(
      data: (data) {
        return getWidget(data: data);
      },
      error: (error, stck) => getWidget(),
      loading: () => getWidget(),
    );
  }

  Widget getWidget({VisitedAndNoOrderOutlet? data}) {
    return Container(
      height: widget.cardHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: primary,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TitleValueColumn(
                  title: 'Visited Outlet',
                  value: data?.visitedOutlet ?? '0',
                  isNumericValue: true,
                ),
                TitleValueColumn(
                  title: 'No Order Outlet',
                  value: data?.noOrderOutlet ?? '0',
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
                completePercent: double.tryParse(data?.getPercentage() ?? '0') ?? 0,
                width: 6,
                showProgressShadow: true,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LangText(
                      data?.getPercentage() ?? '0',
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
