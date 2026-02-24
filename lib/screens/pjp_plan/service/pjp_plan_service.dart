import 'dart:developer';

import '../../../models/pjp_plan_details.dart';

class PJPPlanService {
  List<PJPPlanDetails> getPjpPlanListFromResponse({required Map data}) {
    List<PJPPlanDetails> finalList = [];
    try {
      // log("message>>>>>> ${data}");
      data.forEach((key, d) {
        // log("message>>>>>> ${d} : $key");
        final pjpDetails = PJPPlanDetails.fromJson(d, key);
        finalList.add(pjpDetails);
      });
    } catch(e,t) {
      log(e.toString());
      log(t.toString());
    }
    return finalList;
  }
}