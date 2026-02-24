import 'package:flutter/material.dart';

import '../models/outlet_model.dart';
import '../services/outlet_services.dart';

class CoolerAvailableImageWidget extends StatelessWidget {
  const CoolerAvailableImageWidget({Key? key, required this.outlet}) : super(key: key);
  final OutletModel outlet;
  @override
  Widget build(BuildContext context) {
    if (OutletServices.showCoolerIcon(outlet)) {
      return const Icon(
        Icons.kitchen,
        color: Colors.green,
      );
    }
    return Container();
  }
}
