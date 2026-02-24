

import '../dsr_model.dart';
import '../target/dashboard_target_model.dart';
import '../target/sr_stt_target_model.dart';

class CompletePerformanceModel {
  DsrModel dsrModel;
  DashboardTargetModel dashboardTargetModel;
  List<SRDetailTargetModel> sttTargetList;

  CompletePerformanceModel({
    required this.dashboardTargetModel,
    required this.sttTargetList,
    required this.dsrModel,
  });
}
