import 'dart:async';
import 'dart:math';
import 'dart:developer' as lg;

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/enum.dart';
import '../constants/sync_global.dart';
import '../reusable_widgets/custom_dialog.dart';
import '../screens/attendance/model/inside_fensing.dart';
import 'wings_geo_data_service.dart';

class LocationService {
  final BuildContext context;
  StreamSubscription? positionStream;

  LocationService(this.context);

  Location location = Location();

  Future<void> openMapDirections({required double destinationLat,required double destinationLong, required double sourceLat,required double sourceLong}) async {
    Uri url = Uri.parse('https://www.google.com/maps/dir/?api=1&origin=$sourceLat,$sourceLong&destination=$destinationLat,$destinationLong&travelmode=driving');



    if (true) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<bool> isLocationEnabled() async {
    // Test if location services are enabled.
    bool locationEnabled = await location.serviceEnabled();

    if (!locationEnabled) {
      Alerts(context: context).customDialog(
        type: AlertType.warning,
        message: 'Location Service Disabled!',
        description: 'Please enable your location service and press Try again',
        button1: 'Try Again',
        onTap1: () async {
          if (await location.serviceEnabled() == true) {
            Navigator.of(context).pop();
          }
        },
      );
      return Future.error('location error');
    }
    return locationEnabled;
  }

  Future<bool> locationEnabled() async {
    bool locationEnabled = await location.serviceEnabled();
    return locationEnabled;
  }

  isPermissionEnabled() async {
    PermissionStatus permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission == PermissionStatus.denied) {
        Alerts(context: context).customDialog(
          type: AlertType.warning,
          message: 'Location Permission Denied!',
          description: 'Please give location permission and press Try again',
          button1: 'Try Again',
          onTap1: () async {
            permission = await location.requestPermission();
            if ((permission == PermissionStatus.granted)) {
              Navigator.of(context).pop();
            } else if (permission == PermissionStatus.deniedForever) {
              Alerts(context: context).customDialog(
                  type: AlertType.warning,
                  message: 'Location Permission Denied Forever!',
                  description: 'Please give location permission from Settings and press Try again',
                  button1: 'Try Again',
                  button2: 'Go To Settings',
                  twoButtons: true,
                  onTap1: () async {
                    permission = await location.requestPermission();

                    if (permission == PermissionStatus.granted) {
                      Navigator.of(context).pop();
                    }
                  },
                  onTap2: () async {
                    // await openAppSettings();
                  });
              return Future.error('Location permissions are permanently denied, we cannot request permissions.');
            }
          },
        );
        return Future.error('Location permissions are denied');
      }
    }
  }

  Future<LocationData?> determinePosition({bool checkLocal = false}) async {
    try {
      await isLocationEnabled();
      await isPermissionEnabled();
      LocationData? position;
      if (checkLocal && currentPositionOfSR != null) {
        position = currentPositionOfSR;
      } else {
        // position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium, timeLimit: const Duration(seconds: 10));

        position = await location.getLocation().timeout(Duration(seconds: 10));
        print("real time position ${position.latitude} ${position.longitude}");
        if (position == null && currentPositionOfSR != null) {
          position = currentPositionOfSR;
        }
        currentPositionOfSR = position;
      }

      return position;
    } catch (e, s) {
      print('Inside geolocation determine position catch block $e');
      if (currentPositionOfSR != null) {
        return currentPositionOfSR;
      }
      Alerts(context: context).customDialog(
        type: AlertType.error,
        message: 'Location issue',
        description: "Couldn't get location. Please check GPS",
      );
      return null;
    }
  }

  Future<bool> geoFencing({required num lat, required num lng, required num allowedDistance}) async {
    bool insideFence = false;
    try {
      if (lat != 0.0 && lng != 0.0) {
        num? distance = await getDistance(lat, lng, checkLocal: false);
        if (distance != null && distance < allowedDistance.toDouble()) {
          insideFence = true;
        } else if (distance == null) {
          insideFence = true;
        }
      } else {
        insideFence = true;
      }
    } catch (e) {}
    return insideFence;
  }

  Future<InsideFencing> geoFencingWithDistanceReturn({required num lat, required num lng, required num allowedDistance}) async {
    InsideFencing insideFence = InsideFencing(distance: 0, inside: false);
    try {
      if (lat != 0.0 && lng != 0.0) {
        num? distance = await getDistance(lat, lng, checkLocal: false);
        print("Distance is::::::::::::::::::::::::::: $distance");
        insideFence.distance = distance ?? 0;
        if (distance != null && distance < allowedDistance.toDouble()) {
          insideFence.inside = true;
        } else if (distance == null) {
          insideFence.inside = true;
        }
      } else {
        insideFence.inside = true;
      }
    } catch (e) {}
    return insideFence;
  }

  Future<num?> getDistance(num lat, num lng, {num? currentLat, num? currentLng, bool checkLocal = false}) async {
    num? distance;
    try {
      if (currentLat == null || currentLng == null) {
        LocationData? position = await determinePosition(checkLocal: checkLocal);

        lg.log('get distance location: ${position?.latitude} ${position?.longitude} ---> position');
        lg.log('get distance location: $currentLat $currentLng ---> current');

        if (position != null) {
          currentLat = position.latitude;
          currentLng = position.longitude;
        }
      }
      if (currentLat != null && currentLng != null) {
        var p = 0.017453292519943295;
        var c = cos;
        var a = 0.5 - c((currentLat - lat) * p) / 2 + c(lat * p) * c(currentLat * p) * (1 - c((currentLng - lng) * p)) / 2;
        distance = (12742 * asin(sqrt(a))) * 1000;
        // distance = location.distanceBetween(lat, lng, currentLat, currentLng);
      }
    } catch (e, s) {
      print("distance calculation error $e $s");
    }

    print("distance in meter $distance");
    return distance;
  }

  void initialize() async {
    await isLocationEnabled();
    await isPermissionEnabled();
    try {
      await location.enableBackgroundMode();
    } catch (e) {
      print('Background location permission denied: $e');
    }
    int interval = await WingsGeoDataService().getTrackingInterval();
    print('geo intervel :: $interval');
    Timer? locationTimer;

    positionStream = location.onLocationChanged.listen((LocationData currentLocation) {
      currentPositionOfSR = currentLocation;
      locationTimer ??= Timer.periodic(Duration(seconds: interval), (Timer t) {
        locationTimer?.cancel();
        locationTimer = null;
        // Alerts(context: context).customDialog(type: AlertType.info, description: "SR Current location Latitude:${currentLocation.latitude} Longitude:${currentLocation.longitude}");
        // todo prism location submit
        bool insideBD = _insideBangladesh(currentLocation: currentLocation);
        if(insideBD) {
          WingsGeoDataService().submitLocation(currentLocation);
        } else {
          // Alerts(context: context).customDialog(type: AlertType.warning, message: "Location error", description: "");
        }
      });
    })
      ..onError((e) async {
        if (await location.serviceEnabled() == true) {
          PermissionStatus permission = await location.requestPermission();
          if (permission == PermissionStatus.granted) {
            Navigator.of(context).pop();
          } else if (permission == PermissionStatus.deniedForever) {
            Alerts(context: context).customDialog(
                type: AlertType.warning,
                message: 'Location Permission Denied Forever!',
                description: 'Please give location permission from Settings and press Try again',
                button1: 'Try Again',
                button2: 'Go To Settings',
                twoButtons: true,
                onTap1: () async {
                  permission = await location.requestPermission();

                  if (permission == PermissionStatus.granted) {
                    Navigator.of(context).pop();
                  }
                },
                onTap2: () async {
                  // await openAppSettings();
                });
          } else {
            Alerts(context: context).customDialog(
              type: AlertType.warning,
              message: e.toString(),
              description: 'Please enable your location service and press done',
              button1: 'Done',
              onTap1: () async {
                if (await location.serviceEnabled() == true) {
                  Navigator.of(context).pop();
                }
              },
            );
          }
        } else {
          Alerts(context: context).customDialog(
            type: AlertType.warning,
            message: 'Location Service Disabled!',
            description: 'Please enable your location service and press Try again',
            button1: 'Try Again',
            onTap1: () async {
              if (await location.serviceEnabled() == true) {
                Navigator.of(context).pop();
              }
            },
          );
        }
      });
  }

  bool _insideBangladesh({required LocationData currentLocation}) {
    bool inside = false;
    if((currentLocation.latitude??0) <= 26.79 && (currentLocation.latitude??0) >= 20.45 &&
        (currentLocation.longitude??0) <= 92.78 && (currentLocation.longitude??0) >= 87.85) {
      inside = true;
    }
    return inside;
  }

  closeSrTracking() {
    if (positionStream != null) {
      positionStream?.cancel();
    }
  }

// StreamSubscription<Position>? getLocationStream() {
//   return Geolocator.getPositionStream(
//     locationSettings: const LocationSettings(
//       accuracy: LocationAccuracy.medium,
//       // distanceFilter: 1,
//     ),
//   ).listen((Position position) {
//     var v = Geolocator.distanceBetween(initialPosition!.latitude, initialPosition!.longitude, position.latitude, position.longitude);
//     if (v >= 5) {
//       initialPosition = position;
//       submitLocation(position);
//     }
//   });
// }
}
