
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wings_olympic_sr/screens/olympic_tada/service/olympic_tada_service.dart';

import '../../../models/fare_chart_model.dart';

final getServicesClustersProvider = FutureProvider.autoDispose<List<FareChartModel>>((ref) async {
  return await OlympicTaDaService().getServicesClusters();
});