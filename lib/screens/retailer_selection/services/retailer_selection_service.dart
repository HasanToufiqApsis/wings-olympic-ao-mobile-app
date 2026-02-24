import 'package:flutter/foundation.dart';

import '../../../constants/sync_global.dart';
import '../models/retailer_selection_config.dart';

class RetailerSelectionService {
  Future<RetailerSelectionConfig> getRetailerSelectionConfig () async {
    try {
      if (syncObj.containsKey('retailer_selection_config')) {
        return RetailerSelectionConfig(showAllRoutes: false, tabMode: true, showNavButtons: true);
        // return RetailerSelectionConfig.fromJson(syncObj['retailer_selection_config']);
      }
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }
    return RetailerSelectionConfig(showAllRoutes: true, tabMode: true, showNavButtons:  true);
  }
}