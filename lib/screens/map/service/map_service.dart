import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/sync_global.dart';
import '../../../main.dart';
import '../../../models/outlet_model.dart';
import '../../../services/sync_service.dart';
import '../ui/map_navigation_screen.dart';

class MapService {
  final SyncService _syncService = SyncService();

  Future<String> getApiKey() async {
    String apiKey = "";
    try {
      await _syncService.checkSyncVariable();
      if (syncObj.containsKey("map_config")) {
        if (syncObj["map_config"].isNotEmpty) {
          if (syncObj["map_config"].containsKey("kmeayp")) {
            apiKey = syncObj["map_config"]["kmeayp"];
          }
        }
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    return apiKey;
  }

  Future<bool> navigateToMapScreen({
    required OutletModel retailer,
    required LatLng srPosition,
  }) async {
    openMapDirections(
      destinationLat: retailer.outletLocation.latitude.toDouble(),
      destinationLong: retailer.outletLocation.longitude.toDouble(),
      sourceLat: srPosition.latitude,
      sourceLong: srPosition.longitude,
    );

    return true;
  }

  Future<void> openMapDirections(
      {required double destinationLat,
      required double destinationLong,
      required double sourceLat,
      required double sourceLong}) async {
    // Uri url = Uri.parse('https://www.google.com/maps/dir/?api=1&origin=$sourceLat,$sourceLong&destination=$destinationLat,$destinationLong&travelmode=walking');
    Uri url = Uri.parse('https://www.google.com/maps/dir/?api=1&origin=$sourceLat,$sourceLong&destination=$destinationLat,$destinationLong&travelmode=walking');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch Maps for navigation';
    }
  }
}
