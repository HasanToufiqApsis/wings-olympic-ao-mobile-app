import 'constants/constant_variables.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'route/route_generator.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import 'services/connectivity_service.dart';

//route observer
final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() async {
  final connectivityService = ConnectivityService();
  WidgetsFlutterBinding.ensureInitialized();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  appVersionDeviceLog = packageInfo.version;
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint("inside main camera exception $e");
  }

  connectivityService.initialize();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: "Olympic AO",
        theme: ThemeData(
          fontFamily: "NotoSansBengali",
          primaryColor: primary,
          scaffoldBackgroundColor: scaffoldBGColor,
          iconTheme: IconThemeData(
            color: primary,
          ),
          progressIndicatorTheme: ProgressIndicatorThemeData(
            color: primary,
          ),
        ),
        navigatorObservers: [routeObserver],
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.generateRoute,
      );
    });
  }
}
