import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/outlet_model.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../services/geo_location_service.dart';
import '../../map/service/map_service.dart';

class RetailerSelectionController {
  Alerts alerts;
  final _mapService = MapService();
  final LocationService _locationService;

  RetailerSelectionController({
    required this.alerts,
    required LocationService locationService,
  }) : _locationService = locationService;

  Future retailerLocationNavigator({required OutletModel retailer}) async {
    if (retailer.outletLocation.latitude == 0 ||
        retailer.outletLocation.longitude == 0) {
      alerts.customDialog(
        type: AlertType.warning,
        message: 'Retailer location not available.',
      );
      return;
    }

    alerts.floatingLoading(message: 'Getting location...');
    final location = await _locationService.determinePosition();
    navigatorKey.currentState?.pop();

    if (location == null) return;

    _mapService
        .navigateToMapScreen(
      retailer: retailer,
      srPosition: LatLng(location.latitude ?? 0, location.longitude ?? 0),
    )
        .then(
      (status) {
        if (status == false) {
          alerts.customDialog(
            type: AlertType.error,
            message:
                'Location permission not given. go to your setting and give the location permission.',
          );
        }
      },
    );
  }
}
