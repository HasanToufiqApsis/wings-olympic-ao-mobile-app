import 'package:flutter/material.dart';

import '../../../constants/constant_variables.dart';

class GeoDataDashboardWidget extends StatelessWidget {
  final double cardHeight;
  const GeoDataDashboardWidget({super.key, required this.cardHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cardHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // TitleValueColumn(title: 'Within 25m Outlet', value: '44K'),
          // TitleValueColumn(title: 'Out of 25m Outlet', value: '55K'),
        ],
      ),
    );
  }
}
