import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wings_olympic_sr/main.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  bool _isDialogOn = false;
  bool _isOnline = false;
  final validConnectedList = [
    ConnectivityResult.wifi,
    ConnectivityResult.mobile,
    ConnectivityResult.ethernet
  ];

  void initialize() {
    _connectivity.onConnectivityChanged.listen((result) {
      for (var val in result) {
        print("~~#~~> ${val.name.toString()}");
      }
      bool isConnected = result.any((element) => validConnectedList.contains(element));

      final context = navigatorKey.currentContext;
      print(
          "~~~~~~~~~~~~~~~~~~>>>>>>> $isConnected :: $_isDialogOn :: ${context == null}");
      if (!isConnected && !_isDialogOn) {
        _showOfflineDialog(navigatorKey);
        _isDialogOn = true;
      }

      if (isConnected) {
        _isDialogOn = false;
      }
    });

    _connectivity.onConnectivityChanged.listen((result) async {
      if (result.contains(ConnectivityResult.none) == false) {
        _isOnline = await checkInternet();
      } else {
        _isOnline = false;
      }

      if (_isOnline == true) {
        if (_isDialogOn == true) {
          _isDialogOn = false;
          navigatorKey.currentState?.pop();
        }
      } else {
        _isDialogOn = true;

        _showOfflineDialog(navigatorKey);
      }
    });
  }

  void _showOfflineDialog(GlobalKey<NavigatorState> navigatorKey) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('No Internet'),
        content: const Text('Please check your internet connection.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<bool> checkInternet() async {
    bool isConnected = false;
    List<ConnectivityResult> connectedNetwork = await _connectivity.checkConnectivity();
    if (connectedNetwork.contains(ConnectivityResult.none) == false &&
        connectedNetwork.any((element) => validConnectedList.contains(element))) {
      isConnected = true;
    }
    return isConnected;
  }
}
