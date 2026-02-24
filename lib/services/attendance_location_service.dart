import 'package:geocoding/geocoding.dart';

import 'package:location/location.dart' as loc;

import '../models/location_address_model.dart';

class AttendanceLocationService {
  Future<loc.LocationData?> _getCurrentLocation() async {
    try {
      loc.Location location = loc.Location();
      loc.PermissionStatus _permissionGranted;

      bool _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return null;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == loc.PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != loc.PermissionStatus.granted) {
          return null;
        }
      }

      final _locationData = await location.getLocation();

      return _locationData;
    } catch (error, stck) {
      print('$error');
      print('$stck');
    }

    return null;
  }

  Future<LocationAddressModel<Placemark?>?> getCurrentLocationAndAddress() async {
    final locationData = await _getCurrentLocation();
    if (locationData == null) {
      return null;
    }

    try {
      final placeList = await placemarkFromCoordinates(
        locationData.latitude ?? 0,
        locationData.longitude ?? 0,
      );

      return LocationAddressModel(
        lat: locationData.latitude ?? 0,
        long: locationData.longitude ?? 0,
        address: placeList.first,
      );
    } catch (error, stck) {
      print('$error');
      print('$stck');
      return LocationAddressModel(
        lat: locationData.latitude ?? 0,
        long: locationData.longitude ?? 0,
        address: null,
      );
    }
  }

  Future<LocationAddressModel<Placemark?>?> getTargetedLocationAndAddress({
    required double latitude ,
    required double longitude,
  }) async {
    final locationData = await _getCurrentLocation();
    if (locationData == null) {
      return null;
    }

    try {
      final placeList = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      return LocationAddressModel(
        lat: locationData.latitude ?? 0,
        long: locationData.longitude ?? 0,
        address: placeList.first,
      );
    } catch (error, stck) {
      print('$error');
      print('$stck');
      return LocationAddressModel(
        lat: locationData.latitude ?? 0,
        long: locationData.longitude ?? 0,
        address: null,
      );
    }
  }

  Future<loc.LocationData?> getCurrentLocation() async {
    return await _getCurrentLocation();
  }
}
