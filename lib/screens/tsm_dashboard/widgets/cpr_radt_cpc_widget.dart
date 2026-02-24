import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/constant_variables.dart';
import '../models/cpr_radt_cpc.dart';
import '../providers/tsm_dahboard_providers.dart';
import 'title_value_column.dart';

class CprRadtCpcWidget extends StatelessWidget {
  final double cardHeight;

  const CprRadtCpcWidget({super.key, required this.cardHeight});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final asyncData = ref.watch(cprRadtCpcDataProvider);

        return asyncData.when(
          data: (data) => getWidget(data: data),
          error: (error, stck) => getWidget(),
          loading: () => getWidget(),
        );
      },
    );
  }

  Widget getWidget({CprRadtCpc? data}) {
    return Container(
      height: cardHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: tealBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TitleValueColumn(
                  title: 'CPR',
                  value: data?.cpr?.toStringAsFixed(2) ?? '0',
                  isNumericValue: true,
                ),
                Consumer(
                  builder: (context, ref, _) {
                    final radt = ref.watch(radtProvider);

                    return TitleValueColumn(
                      title: 'RADT',
                      value: radt,
                      isNumericValue: true,
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TitleValueColumn(
                  title: 'LPC',
                  value: data?.lpc?.toStringAsFixed(2) ?? '0',
                  isNumericValue: true,
                ),
                TitleValueColumn(
                  title: 'Total Memo',
                  value: data?.totalMemo?.toStringAsFixed(0) ?? '0',
                  isNumericValue: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
