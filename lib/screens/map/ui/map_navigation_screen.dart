// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:prism_v2/global/global_variables.dart';
// import 'package:prism_v2/global/sync_global.dart';
// import 'package:prism_v2/screens/map/providers/viet_map_providers.dart';
// import 'package:sizer/sizer.dart';
// import 'package:vietmap_flutter_navigation/models/voice_units.dart';
// import 'package:vietmap_flutter_navigation/vietmap_flutter_navigation.dart';
//
// import '../../../main.dart';
// import '../../../model/retailer_model.dart';
// import '../../../reusable widgets/language_textbox.dart';
//
// class MapNavigationScreen extends ConsumerStatefulWidget {
//   static const routeName = "map_navigation_screen";
//
//   final RetailerModel retailerModel;
//   final String mapApiKey;
//   final LatLng initialSrPosition;
//
//   const MapNavigationScreen({
//     super.key,
//     required this.retailerModel,
//     required this.mapApiKey,
//     required this.initialSrPosition,
//   });
//
//   @override
//   ConsumerState<MapNavigationScreen> createState() => _MapNavigationScreenState();
// }
//
// class _MapNavigationScreenState extends ConsumerState<MapNavigationScreen> {
//   MapNavigationViewController? _controller;
//   late MapOptions _navigationOption;
//   final _vietMapNavigationPlugin = VietMapNavigationPlugin();
//   List<LatLng> waypoints = [];
//
//   final _hoChiMinCityDummySrLocation = const LatLng(10.762528, 106.653099);
//   final _hoChiMinCityDummyRetailerLocation = const LatLng(10.773544, 106.627670);
//
//   @override
//   void initState() {
//     super.initState();
//     waypoints = [
//       // _hoChiMinCityDummySrLocation,
//       widget.initialSrPosition,
//       LatLng(widget.retailerModel.lat, widget.retailerModel.lng),
//       // _hoChiMinCityDummyRetailerLocation,
//     ];
//     initialize();
//     // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//     //   Geolocator.requestPermission();
//     // });
//   }
//
//   Future<void> initialize() async {
//     if (!mounted) return;
//
//     _navigationOption = MapOptions(
//       apiKey: widget.mapApiKey,
//       mapStyle: "https://maps.vietmap.vn/api/maps/light/styles.json?apikey=${widget.mapApiKey}",
//       zoom: 18,
//       tilt: 0,
//       bearing: 0,
//       enableRefresh: false,
//       alternatives: true,
//       voiceInstructionsEnabled: true,
//       bannerInstructionsEnabled: true,
//       allowsUTurnAtWayPoints: true,
//       mode: MapNavigationMode.drivingWithTraffic,
//       units: VoiceUnits.imperial,
//       simulateRoute: true,
//       trackCameraPosition: true,
//       animateBuildRoute: true,
//       longPressDestinationEnabled: true,
//       language: 'en',
//       initialLatitude: widget.initialSrPosition.latitude == 0 ? _hoChiMinCityDummySrLocation.latitude : widget.initialSrPosition.latitude,
//       initialLongitude: widget.initialSrPosition.longitude == 0 ? _hoChiMinCityDummySrLocation.longitude : widget.initialSrPosition.longitude,
//     );
//
//     _vietMapNavigationPlugin.setDefaultOptions(_navigationOption);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: LangText(
//           'Map',
//           style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: darkBlue,
//         centerTitle: true,
//         actions: [
//           Consumer(
//             builder: (context, ref, _) {
//               final mapLoading = ref.watch(mapLoadingProvider);
//
//               if (mapLoading) {
//                 return const Align(
//                   child: SizedBox(
//                     height: 16,
//                     width: 16,
//                     child: CircularProgressIndicator(
//                       color: Colors.white30,
//                       strokeWidth: 2,
//                     ),
//                   ),
//                 );
//               }
//
//               return const SizedBox();
//             },
//           ),
//           const SizedBox(
//             width: 16,
//           ),
//         ],
//         leading: Padding(
//           padding: EdgeInsets.only(left: 3.w),
//           child: Container(
//             height: 7.h,
//             decoration: BoxDecoration(
//               color: greenOlive.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: IconButton(
//                 onPressed: () {
//                   navigatorKey.currentState?.pop();
//                 },
//                 icon: const Icon(
//                   Icons.arrow_back,
//                   size: 24,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: SafeArea(
//         top: false,
//         child: Stack(
//           children: [
//             NavigationView(
//               mapOptions: _navigationOption,
//               onMapCreated: (p0) {
//                 _controller = p0;
//               },
//               onRouteBuilt: (p0) {
//                 debugPrint(p0.geometry);
//               },
//               onMapReady: () async {},
//               onMapRendered: () async {
//                 ref.read(mapLoadingProvider.notifier).state = false;
//
//                 await _controller?.addImageMarkers(
//                   [
//                     NavigationMarker(
//                       imagePath: 'assets/map_icons/sr_marker.png',
//                       latLng: widget.initialSrPosition,
//                     ),
//                     NavigationMarker(
//                       imagePath: 'assets/map_icons/retailer_marker.png',
//                       latLng: LatLng(widget.retailerModel.lat, widget.retailerModel.lng),
//                       // latLng: _hoChiMinCityDummyRetailerLocation,
//                     ),
//                   ],
//                 );
//
//                 final routeResult = await _controller?.buildRoute(waypoints: waypoints);
//                 appLog('route result => $routeResult');
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
