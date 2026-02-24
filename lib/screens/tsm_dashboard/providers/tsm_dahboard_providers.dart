import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/tsm_dashboard_repository.dart';

final visitedAndNoOrderOutletDataProvider = FutureProvider.autoDispose((ref) async {
  return TsmDashboardRepository().getVisitedAndNoOrderOutletData();
});

final totalAndTargetOutletDataProvider = FutureProvider.autoDispose((ref) async {
  return TsmDashboardRepository().getTotalAndTargetOutletData();
});

final targetVsAchievementDataProvider = FutureProvider.autoDispose((ref) async {
  return TsmDashboardRepository().getTargetVsAchievementData();
});

final cprRadtCpcDataProvider = FutureProvider.autoDispose((ref) async {
  return TsmDashboardRepository().getCprRadtCpcData();
});

final radtProvider = StateProvider((ref) => '0');

final mandatoryFocussedDataProvider = FutureProvider((ref) async {
  return TsmDashboardRepository().getMandatoryAndFocussedData();
});
