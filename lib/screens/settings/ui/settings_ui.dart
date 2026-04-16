import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/screens/settings/ui/start_reset_dialog.dart';
import 'package:wings_olympic_sr/services/permission_service.dart';

import '../../../constants/enum.dart';
import '../../../constants/language_global.dart';
import '../../../models/sr_info_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../services/shared_storage_services.dart';
import '../../update_password/ui/update_password_ui.dart';
import '../controller/settings_controller.dart';
import 'widget/settings_item_button.dart';

import '../../../models/location_category_models.dart';
import '../../../services/ff_services.dart';
import '../../../services/location_category_services.dart';
import '../../../services/outlet_services.dart';
import '../../../constants/constant_variables.dart';

// class SettingsUI extends ConsumerStatefulWidget {
//   const SettingsUI({Key? key}) : super(key: key);
//   static const routeName = "settings_ui";
//
//   @override
//   ConsumerState<SettingsUI> createState() => _SettingsUIState();
// }
//
// class _SettingsUIState extends ConsumerState<SettingsUI> {
//   late SettingsController controller;
//
//   @override
//   void initState() {
//     super.initState();
//
//     controller = SettingsController(context: context, ref: ref);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     AsyncValue<SrInfoModel?> asyncSrInfo = ref.watch(userDataProvider);
//     return asyncSrInfo.when(
//         data: (srInfo) {
//           return Scaffold(
//             appBar: const CustomAppBar(
//               title: "Settings",
//               // titleImage: "",
//               showLeading: true,
//               centerTitle: true,
//             ),
//             body: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Container(
//                 //   decoration: BoxDecoration(
//                 //     borderRadius: BorderRadius.circular(16),
//                 //     color: Colors.white,
//                 //   ),
//                 //   margin: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
//                 //   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
//                 //   child: Row(
//                 //     children: [
//                 //       Image.asset(
//                 //         "assets/person.png",
//                 //         height: 42,
//                 //         width: 42,
//                 //         color: Colors.grey,
//                 //       ),
//                 //       Expanded(
//                 //         child: Column(
//                 //           mainAxisAlignment: MainAxisAlignment.start,
//                 //           crossAxisAlignment: CrossAxisAlignment.start,
//                 //           children: [
//                 //             LangText(
//                 //               srInfo != null ? " ${srInfo.fullname}" : "",
//                 //               style: Theme.of(context).textTheme.titleLarge,
//                 //             ),
//                 //             LangText(
//                 //               srInfo != null
//                 //                   ? srInfo.srRoute.isNotEmpty
//                 //                       ? " (${srInfo.srRoute})"
//                 //                       : ""
//                 //                   : "",
//                 //               style: Theme.of(context).textTheme.labelSmall,
//                 //             )
//                 //           ],
//                 //         ),
//                 //       )
//                 //     ],
//                 //   ),
//                 // ),
//                 // Padding(
//                 //   padding: const EdgeInsets.only(left: 18, top: 18, bottom: 8),
//                 //   child: LangText(
//                 //     "Preferences",
//                 //     style: Theme.of(context)
//                 //         .textTheme
//                 //         .labelMedium
//                 //         ?.copyWith(color: Colors.grey),
//                 //   ),
//                 // ),
//                 // Container(
//                 //   decoration: BoxDecoration(
//                 //     borderRadius: BorderRadius.circular(12),
//                 //     color: Colors.white,
//                 //   ),
//                 //   margin: EdgeInsets.symmetric(horizontal: 18),
//                 //   child: Column(
//                 //     children: [
//                 //       ListTile(
//                 //         title: LangText("Language"),
//                 //         onTap: () {
//                 //           showModalBottomSheet(
//                 //               context: context,
//                 //               builder: (builder) {
//                 //                 return _languageBottomSheet();
//                 //               });
//                 //         },
//                 //         contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                 //         leading: Container(
//                 //           decoration: BoxDecoration(
//                 //             borderRadius: BorderRadius.circular(8),
//                 //             color: Colors.grey[400],
//                 //           ),
//                 //           padding: EdgeInsets.all(6),
//                 //           child: Icon(
//                 //             Icons.translate_rounded,
//                 //             color: Colors.white,
//                 //           ),
//                 //         ),
//                 //         trailing: Consumer(builder: (context, ref, _) {
//                 //           String lang = ref.watch(languageProvider);
//                 //           return Row(
//                 //             mainAxisSize: MainAxisSize.min,
//                 //             children: [
//                 //               LangText(
//                 //                 lang == 'en' ? 'English' : lang,
//                 //                 style: Theme.of(context)
//                 //                     .textTheme
//                 //                     .labelSmall
//                 //                     ?.copyWith(color: Colors.grey[500]),
//                 //               ),
//                 //               SizedBox(width: 12),
//                 //               Icon(Icons.keyboard_arrow_right_rounded),
//                 //             ],
//                 //           );
//                 //         }),
//                 //         // trailing: Consumer(builder: (context, ref, _) {
//                 //         //   String lang = ref.watch(languageProvider);
//                 //         //   return DropdownButton<String>(
//                 //         //     value: lang,
//                 //         //     icon: const Icon(
//                 //         //       Icons.keyboard_arrow_right_rounded,
//                 //         //     ),
//                 //         //     // elevation: 16,
//                 //         //     // style: const TextStyle(
//                 //         //     //   color: Colors.deepPurple,
//                 //         //     // ),
//                 //         //     underline: Container(
//                 //         //       height: 0,
//                 //         //       color: Colors.transparent,
//                 //         //     ),
//                 //         //     onChanged: (String? newValue) async {
//                 //         //       ref.read(languageProvider.state).state = newValue!;
//                 //         //       await LocalStorageHelper.save('lang', newValue);
//                 //         //     },
//                 //         //     items: availableLanguages
//                 //         //         .map<DropdownMenuItem<String>>((value) {
//                 //         //       return DropdownMenuItem<String>(
//                 //         //         value: value,
//                 //         //         child: LangText(
//                 //         //           value == 'en' ? 'English' : value,
//                 //         //           style: Theme.of(context).textTheme.labelSmall,
//                 //         //         ),
//                 //         //       );
//                 //         //     }).toList(),
//                 //         //   );
//                 //         // }),
//                 //       ),
//                 //       Consumer(builder: (context, ref, _) {
//                 //         AsyncValue<bool> asyncRequested =
//                 //             ref.watch(checkIfChangeRouteRequestedProvider);
//                 //         return asyncRequested.when(
//                 //             data: (requested) {
//                 //               if (!requested) {
//                 //                 return const SizedBox(
//                 //                   width: 0,
//                 //                   height: 0,
//                 //                 );
//                 //               }
//                 //               return ListTile(
//                 //                 title: LangText("Check Route change Status"),
//                 //                 contentPadding:
//                 //                     EdgeInsets.symmetric(horizontal: 10),
//                 //                 leading: Container(
//                 //                   decoration: BoxDecoration(
//                 //                     borderRadius: BorderRadius.circular(8),
//                 //                     color: Colors.grey[400],
//                 //                   ),
//                 //                   padding: EdgeInsets.all(6),
//                 //                   child: Icon(
//                 //                     Icons.manage_search_outlined,
//                 //                     color: Colors.white,
//                 //                   ),
//                 //                 ),
//                 //                 onTap: () {
//                 //                   controller.checkChangeStatusAndLogout();
//                 //                 },
//                 //               );
//                 //               return SettingsItemButton(
//                 //                 title: 'Check Route change Status',
//                 //                 icon: const Icon(
//                 //                   Icons.manage_search_outlined,
//                 //                   color: Colors.green,
//                 //                 ),
//                 //                 onTap: () {
//                 //                   controller.checkChangeStatusAndLogout();
//                 //                 },
//                 //               );
//                 //             },
//                 //             error: (error, _) => const SizedBox(
//                 //                   width: 0,
//                 //                   height: 0,
//                 //                 ),
//                 //             loading: () => const SizedBox(
//                 //                   width: 0,
//                 //                   height: 0,
//                 //                 ));
//                 //       }),
//                 //       ListTile(
//                 //         title: LangText("PDA to Support"),
//                 //         contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                 //         leading: Container(
//                 //           decoration: BoxDecoration(
//                 //             borderRadius: BorderRadius.circular(8),
//                 //             color: Colors.grey[400],
//                 //           ),
//                 //           padding: EdgeInsets.all(6),
//                 //           child: Icon(
//                 //             Icons.upload_file_outlined,
//                 //             color: Colors.white,
//                 //           ),
//                 //         ),
//                 //         onTap: () {
//                 //           controller.pdaDirectSendToSupport();
//                 //         },
//                 //       ),
//                 //       ListTile(
//                 //         onTap: () {
//                 //           Navigator.pushNamed(
//                 //               context, UpdatePasswordUI.routeName);
//                 //         },
//                 //         title: LangText("Update Password"),
//                 //         contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                 //         leading: Container(
//                 //           decoration: BoxDecoration(
//                 //             borderRadius: BorderRadius.circular(8),
//                 //             color: Colors.grey[400],
//                 //           ),
//                 //           padding: EdgeInsets.all(6),
//                 //           child: Icon(
//                 //             Icons.lock_reset_rounded,
//                 //             color: Colors.white,
//                 //           ),
//                 //         ),
//                 //         trailing: Icon(Icons.keyboard_arrow_right_rounded),
//                 //       ),
//                 //       ListTile(
//                 //         title: LangText("Dark Theme"),
//                 //         contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                 //         leading: Container(
//                 //           decoration: BoxDecoration(
//                 //             borderRadius: BorderRadius.circular(8),
//                 //             color: Colors.grey[400],
//                 //           ),
//                 //           padding: EdgeInsets.all(6),
//                 //           child: Icon(
//                 //             Icons.light_mode_outlined,
//                 //             color: Colors.white,
//                 //           ),
//                 //         ),
//                 //         trailing: Transform.scale(
//                 //           scale: 0.7,
//                 //           child: CupertinoSwitch(
//                 //             value: false,
//                 //             onChanged: (v) {},
//                 //           ),
//                 //         ),
//                 //         onTap: () {},
//                 //       ),
//                 //       ListTile(
//                 //         onTap: () {
//                 //           Alerts(context: context).customDialog(
//                 //             type: AlertType.warning,
//                 //             message: 'Are you sure?',
//                 //             twoButtons: true,
//                 //             button1: 'Cancel',
//                 //             button2: 'Logout',
//                 //             onTap2: () {
//                 //               controller.logout();
//                 //             },
//                 //           );
//                 //         },
//                 //         title: LangText("Logout"),
//                 //         contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                 //         leading: Container(
//                 //           decoration: BoxDecoration(
//                 //             borderRadius: BorderRadius.circular(8),
//                 //             color: Colors.grey[400],
//                 //           ),
//                 //           padding: EdgeInsets.all(6),
//                 //           child: Icon(
//                 //             Icons.logout_rounded,
//                 //             color: Colors.white,
//                 //           ),
//                 //         ),
//                 //         trailing: Icon(Icons.keyboard_arrow_right_rounded),
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//                 //
//                 // Padding(
//                 //   padding: const EdgeInsets.only(left: 24, top: 18, bottom: 8),
//                 //   child: LangText(
//                 //     "Permissions",
//                 //     style: Theme.of(context)
//                 //         .textTheme
//                 //         .labelMedium
//                 //         ?.copyWith(color: Colors.grey),
//                 //   ),
//                 // ),
//                 // Container(
//                 //   decoration: BoxDecoration(
//                 //     borderRadius: BorderRadius.circular(12),
//                 //     color: Colors.white,
//                 //   ),
//                 //   margin: EdgeInsets.symmetric(horizontal: 18),
//                 //   child: Column(
//                 //     children: [
//                 //       ListTile(
//                 //         title: LangText("Location Permission"),
//                 //         contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                 //         leading: Container(
//                 //           decoration: BoxDecoration(
//                 //             borderRadius: BorderRadius.circular(8),
//                 //             color: Colors.grey[400],
//                 //           ),
//                 //           padding: EdgeInsets.all(6),
//                 //           child: Icon(
//                 //             Icons.location_on_outlined,
//                 //             color: Colors.white,
//                 //           ),
//                 //         ),
//                 //         trailing: Transform.scale(
//                 //           scale: 0.7,
//                 //           child: CupertinoSwitch(
//                 //             value: true,
//                 //             onChanged: (v) {},
//                 //           ),
//                 //         ),
//                 //         onTap: () {},
//                 //       ),
//                 //       Consumer(builder: (context, ref, _) {
//                 //         AsyncValue<bool> asyncCameraPermission = ref.watch(cameraPermissionProvider);
//                 //         return asyncCameraPermission.when(
//                 //             data: (cameraPermission) {
//                 //               return ListTile(
//                 //                 title: LangText("Camera Permission"),
//                 //                 contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                 //                 leading: Container(
//                 //                   decoration: BoxDecoration(
//                 //                     borderRadius: BorderRadius.circular(8),
//                 //                     color: Colors.grey[400],
//                 //                   ),
//                 //                   padding: EdgeInsets.all(6),
//                 //                   child: Icon(
//                 //                     Icons.camera_outlined,
//                 //                     color: Colors.white,
//                 //                   ),
//                 //                 ),
//                 //                 trailing: Transform.scale(
//                 //                   scale: 0.7,
//                 //                   child: CupertinoSwitch(
//                 //                     value: cameraPermission,
//                 //                     onChanged: (v) {},
//                 //                   ),
//                 //                 ),
//                 //                 onTap: cameraPermission? null : () async {
//                 //                   await PermissionService().requestCameraPermission();
//                 //                 },
//                 //               );
//                 //             },
//                 //             error: (error, _) => SizedBox(),
//                 //             loading: () => SizedBox());
//                 //       }),
//                 //     ],
//                 //   ),
//                 // ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(vertical: 0.h),
//                   child: Wrap(
//                     // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 3.w, vertical: 2.h),
//                         child: SizedBox(
//                           width: 43.w,
//                           height: 15.h,
//                           child: ElevatedButtonTheme(
//                             data: ElevatedButtonThemeData(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.grey[100],
//                               ),
//                             ),
//                             child: ElevatedButton(
//                               style: ButtonStyle(
//                                 shape: WidgetStateProperty.all<
//                                     RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.sp),
//                                   ),
//                                 ),
//                               ),
//                               onPressed: () {},
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Image.asset('assets/settings/language.png', height: 32, width: 32,),
//                                   Consumer(builder: (context, ref, _) {
//                                     String lang = ref.watch(languageProvider);
//                                     return Center(
//                                       child: DropdownButton<String>(
//                                         value: lang,
//                                         icon: const Icon(
//                                           Icons.arrow_drop_down,
//                                           color: Colors.blue,
//                                         ),
//                                         // elevation: 16,
//                                         style: const TextStyle(
//                                             color: Colors.deepPurple),
//                                         underline: Container(
//                                           height: 0,
//                                           color: Colors.transparent,
//                                         ),
//                                         onChanged: (String? newValue) async {
//                                           ref.read(languageProvider.state).state =
//                                               newValue!;
//                                           await LocalStorageHelper.save(
//                                               'lang', newValue);
//                                         },
//                                         items: availableLanguages
//                                             .map<DropdownMenuItem<String>>((value) {
//                                           return DropdownMenuItem<String>(
//                                             value: value,
//                                             child: Row(
//                                               children: [
//                                                 const Icon(
//                                                   Icons.flag,
//                                                   color: Colors.green,
//                                                 ),
//                                                 LangText(
//                                                   value == 'en' ? 'English' : value,
//                                                   style: TextStyle(
//                                                       fontSize: 8.sp,
//                                                       fontWeight: FontWeight.bold,
//                                                       color: Colors.blueGrey),
//                                                 ), // বাংলা
//                                               ],
//                                             ),
//                                           );
//                                         }).toList(),
//                                       ),
//                                     );
//                                   }),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       /// pda to support
//                       SettingsItemButton(
//                         title: 'PDA to Support',
//                         icon: Image.asset('assets/settings/update_pass.png', height: 32, width: 32,),
//                         onTap: () {
//                           controller.pdaDirectSendToSupport();
//                         },
//                       ),
//
//                       /// check status
//                       Consumer(builder: (context, ref, _) {
//                         AsyncValue<bool> asyncRequested =
//                             ref.watch(checkIfChangeRouteRequestedProvider);
//                         return asyncRequested.when(
//                             data: (requested) {
//                               if (!requested) {
//                                 return const SizedBox(
//                                   width: 0,
//                                   height: 0,
//                                 );
//                               }
//                               return SettingsItemButton(
//                                 title: 'Check Route change Status',
//                                 icon: const Icon(
//                                   Icons.manage_search_outlined,
//                                   color: Colors.green,
//                                 ),
//                                 onTap: () {
//                                   controller.checkChangeStatusAndLogout();
//                                 },
//                               );
//                             },
//                             error: (error, _) => const SizedBox(
//                                   width: 0,
//                                   height: 0,
//                                 ),
//                             loading: () => const SizedBox(
//                                   width: 0,
//                                   height: 0,
//                                 ));
//                       }),
//
//                       /// pda to support
//                       SettingsItemButton(
//                         title: 'Update Password',
//                         icon: Image.asset('assets/settings/update_pass.png', height: 32, width: 32,),
//                         onTap: () {
//                           // controller.pdaDirectSendToSupport();
//                           Navigator.pushNamed(
//                               context, UpdatePasswordUI.routeName);
//                         },
//                       ),
//
//                       /// logout
//                       SettingsItemButton(
//                         title: 'Logout',
//                         icon: Image.asset('assets/settings/logout.png', height: 32, width: 32),
//                         onTap: () {
//                           Alerts(context: context).customDialog(
//                             type: AlertType.warning,
//                             message: 'Are you sure?',
//                             twoButtons: true,
//                             button1: 'Cancel',
//                             button2: 'Logout',
//                             onTap2: () {
//                               controller.logout();
//                             },
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//         error: (error, _) {
//           print(error);
//           return Container();
//         },
//         loading: () => const Center(
//               child: CircularProgressIndicator(),
//             ));
//   }
//
//   Widget _languageBottomSheet() {
//     return SafeArea(
//       bottom: true,
//       child: Column(
//         mainAxisSize: MainAxisSize.min, // To make the card compact
//         children: [
//           for (var value in availableLanguages)
//             ListTile(
//               onTap: () async {
//                 ref.read(languageProvider.notifier).state = value!;
//                 await LocalStorageHelper.save('lang', value);
//                 Navigator.pop(context);
//               },
//               contentPadding: EdgeInsets.symmetric(horizontal: 24),
//               title: LangText(
//                 value == 'en' ? 'English' : value,
//               ),
//               leading: Image.asset(
//                 value == "en"
//                     ? "assets/flag/english.png"
//                     : "assets/flag/bengali.png",
//                 height: 24,
//                 width: 24,
//               ),
//               trailing: const Icon(
//                 Icons.navigate_next_rounded,
//               ),
//             )
//           // availableLanguages
//           //     .map<DropdownMenuItem<String>>((value) {
//           //   return ListTile(
//           //     onTap: () {
//           //       fromCamera();
//           //       Navigator.pop(context);
//           //     },
//           //     title: LangText(
//           //       'Tap to open camera',
//           //     ),
//           //     leading: const Icon(Icons.camera_alt_rounded),
//           //     trailing: const Icon(
//           //       Icons.navigate_next_rounded,
//           //       size: 16,
//           //     ),
//           //   );
//           // }).toList()
//         ],
//       ),
//     );
//   }
// }

class SettingsUI extends ConsumerStatefulWidget {
  const SettingsUI({Key? key}) : super(key: key);
  static const routeName = "settings_ui";

  @override
  ConsumerState<SettingsUI> createState() => _SettingsUIState();
}

class _SettingsUIState extends ConsumerState<SettingsUI> {
  late SettingsController controller;
  final _outletServices = OutletServices();
  final _locationServices = LocationCategoryServices();
  final _ffServices = FFServices();

  @override
  void initState() {
    super.initState();
    controller = SettingsController(context: context, ref: ref);
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<SrInfoModel?> asyncSrInfo = ref.watch(userDataProvider);
    AsyncValue<bool> asyncResetSales = ref.watch(salesResetProvider);


    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const CustomAppBar(
        title: "Settings",
        showLeading: true,
        centerTitle: true,
      ),
      body: asyncSrInfo.when(
        data: (srInfo) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -------------------------
                // 1. Profile Section
                // -------------------------
                if (srInfo != null)
                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          child: Icon(Icons.person, size: 30, color: Colors.blue),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LangText(
                                srInfo.fullname,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              LangText(
                                srInfo.srRoute.isNotEmpty
                                    ? "${srInfo.srRoute}"
                                    : "No Route Assigned",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // -------------------------
                // 2. Settings List Section
                // -------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: LangText(
                    "General",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                        fontSize: 14),
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // Language Selector
                      _buildSettingsTile(
                        title: "Language",
                        icon: Icons.language,
                        iconColor: Colors.purple,
                        trailing: Consumer(builder: (context, ref, _) {
                          String lang = ref.watch(languageProvider);
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LangText(
                                lang == 'en' ? 'English' : 'বাংলা',
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                            ],
                          );
                        }),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            builder: (builder) => _languageBottomSheet(),
                          );
                        },
                      ),

                      _buildDivider(),

                      _buildSettingsTile(
                        title: "Change service point",
                        icon: Icons.location_on,
                        iconColor: primaryBlue,
                        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        onTap: () {
                          _showOutletSelectionPopup();
                        },
                      ),

                      _buildDivider(),

                      asyncResetSales.when(
                        data: (resetSales) {
                          if(resetSales == false) {
                            return SizedBox();
                          }
                          return _buildSettingsTile(
                            title: "Start sale again",
                            icon: Icons.shopping_cart,
                            iconColor: Colors.amber,
                            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                            onTap: () {
                              Alerts(context: context).showModalWithWidget(child: SaleResetDialogUI(salesController: controller,));
                              // controller.startSaleAgain();
                            },
                          );
                        },
                        error: (e, s) {
                          return Container();
                        },
                        loading: () {
                          return Container();
                        },
                      ),

                      _buildDivider(),

                      // Check Route Change Status (Conditional)
                      Consumer(builder: (context, ref, _) {
                        AsyncValue<bool> asyncRequested =
                        ref.watch(checkIfChangeRouteRequestedProvider);
                        return asyncRequested.when(
                          data: (requested) {
                            if (!requested) return SizedBox();
                            return Column(
                              children: [
                                _buildSettingsTile(
                                  title: "Check Route Status",
                                  icon: Icons.sync,
                                  iconColor: Colors.orange,
                                  onTap: () => controller.checkChangeStatusAndLogout(),
                                ),
                                _buildDivider(),
                              ],
                            );
                          },
                          error: (_, __) => SizedBox(),
                          loading: () => SizedBox(),
                        );
                      }),

                      // PDA to Support
                      _buildSettingsTile(
                        title: "PDA to Support",
                        icon: Icons.support_agent,
                        iconColor: Colors.green,
                        onTap: () => controller.pdaDirectSendToSupport(),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: LangText(
                    "Account",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                        fontSize: 14),
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // Update Password
                      _buildSettingsTile(
                        title: "Update Password",
                        icon: Icons.lock_outline,
                        iconColor: Colors.blueGrey,
                        onTap: () {
                          Navigator.pushNamed(context, UpdatePasswordUI.routeName);
                        },
                      ),

                      _buildDivider(),

                      // Logout
                      _buildSettingsTile(
                        title: "Logout",
                        icon: Icons.logout,
                        iconColor: Colors.redAccent,
                        textColor: Colors.redAccent,
                        hideArrow: true,
                        onTap: () {
                          Alerts(context: context).customDialog(
                            type: AlertType.warning,
                            message: 'Are you sure?',
                            twoButtons: true,
                            button1: 'Cancel',
                            button2: 'Logout',
                            onTap2: () => controller.logout(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          );
        },
        error: (error, _) => Center(child: Text("Error loading settings")),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Reusable Widgets
  // ---------------------------------------------------------------------------

  Widget _buildSettingsTile({
    required String title,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    Widget? trailing,
    Color textColor = Colors.black87,
    bool hideArrow = false,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: LangText(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: trailing ??
          (!hideArrow
              ? Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
              : null),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey[100], indent: 60);
  }

  Widget _languageBottomSheet() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 20),
          LangText(
            "Select Language",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          for (var value in availableLanguages)
            ListTile(
              onTap: () async {
                ref.read(languageProvider.notifier).state = value!;
                await LocalStorageHelper.save('lang', value);
                Navigator.pop(context);
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 24),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  value == "en"
                      ? "assets/flag/english.png" // আপনার ফ্ল্যাগ অ্যাসেট পাথ
                      : "assets/flag/bengali.png",
                  height: 24,
                  width: 32,
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => Icon(Icons.flag), // ছবি না থাকলে আইকন
                ),
              ),
              title: LangText(value == 'en' ? 'English' : 'বাংলা'),
              trailing: ref.watch(languageProvider) == value
                  ? Icon(Icons.check_circle, color: Colors.blue)
                  : null,
            ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // =====================================================================
  // Outlet Selection Popup (Zone > Region > Area > Point)
  // =====================================================================

  Future<void> _showOutletSelectionPopup() async {
    // State holders inside the popup
    ZoneModel? selectedZone;
    RegionModel? selectedRegion;
    AreaModel? selectedArea;
    PointModel? selectedPoint;

    List<ZoneModel> zones = await _locationServices.getZoneList();
    List<RegionModel> regions = [];
    List<AreaModel> areas = [];
    List<PointModel> points = [];

    bool isLoading = false;
    String? errorMsg;

    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.location_on, color: primary, size: 22),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Change Point',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                  )
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Zone dropdown
                    _buildDropdownField<ZoneModel>(
                      label: 'Zone',
                      icon: Icons.map_outlined,
                      value: selectedZone,
                      items: zones,
                      itemLabel: (z) => z.name,
                      onChanged: (z) async {
                        setDialogState(() {
                          selectedZone = z;
                          selectedRegion = null;
                          selectedArea = null;
                          selectedPoint = null;
                          regions = [];
                          areas = [];
                          points = [];
                          errorMsg = null;
                        });
                        if (z != null) {
                          final r = await _locationServices.getRegionList(zoneId: z.id);
                          setDialogState(() => regions = r);
                        }
                      },
                    ),

                    const SizedBox(height: 12),

                    // Region dropdown
                    _buildDropdownField<RegionModel>(
                      label: 'Region',
                      icon: Icons.terrain_outlined,
                      value: selectedRegion,
                      items: regions,
                      itemLabel: (r) => r.name,
                      enabled: selectedZone != null,
                      onChanged: (r) async {
                        setDialogState(() {
                          selectedRegion = r;
                          selectedArea = null;
                          selectedPoint = null;
                          areas = [];
                          points = [];
                          errorMsg = null;
                        });
                        if (r != null) {
                          final a = await _locationServices.getAreaList(regionId: r.id);
                          setDialogState(() => areas = a);
                        }
                      },
                    ),

                    const SizedBox(height: 12),

                    // Area dropdown
                    _buildDropdownField<AreaModel>(
                      label: 'Area',
                      icon: Icons.location_city_outlined,
                      value: selectedArea,
                      items: areas,
                      itemLabel: (a) => a.name,
                      enabled: selectedRegion != null,
                      onChanged: (a) async {
                        setDialogState(() {
                          selectedArea = a;
                          selectedPoint = null;
                          points = [];
                          errorMsg = null;
                        });
                        if (a != null) {
                          final p = await _locationServices.getPointListByArea(areaId: a.id);
                          setDialogState(() => points = p);
                        }
                      },
                    ),

                    const SizedBox(height: 12),

                    // Point dropdown
                    _buildDropdownField<PointModel>(
                      label: 'Point',
                      icon: Icons.place_outlined,
                      value: selectedPoint,
                      items: points,
                      itemLabel: (p) => p.name,
                      enabled: selectedArea != null,
                      onChanged: (p) {
                        setDialogState(() {
                          selectedPoint = p;
                          errorMsg = null;
                        });
                      },
                    ),

                    if (errorMsg != null) ...
                      [
                        const SizedBox(height: 10),
                        Text(
                          errorMsg!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ],

                    const SizedBox(height: 16),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (selectedPoint == null) {
                              setDialogState(
                                () => errorMsg = 'Please select a point to continue.',
                              );
                              return;
                            }
                            setDialogState(() {
                              isLoading = true;
                              errorMsg = null;
                            });
                            final saleDate = await _ffServices.getSalesDate();
                            final success =
                                await _outletServices.fetchAndUpdateRetailersFromApi(
                              pointId: selectedPoint!.id,
                              saleDate: saleDate,
                                  changeRequest: true
                            );
                            setDialogState(() => isLoading = false);
                            if (success) {
                              if (dialogContext.mounted) {
                                Navigator.of(dialogContext).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Service point updated successfully')),
                                );
                              }
                            } else {
                              setDialogState(
                                () => errorMsg = 'Failed to load outlets. Please check your connection.',
                              );
                            }
                          },
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Save Point',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<T> items,
    required String Function(T) itemLabel,
    required ValueChanged<T?> onChanged,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: enabled ? primaryBlue : Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: enabled ? primaryBlue.withOpacity(0.4) : Colors.grey.shade300,
            ),
            color: enabled ? Colors.white : Colors.grey.shade100,
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<T>(
                value: value,
                isExpanded: true,
                hint: Row(
                  children: [
                    Icon(icon, size: 16, color: enabled ? Colors.grey : Colors.grey.shade400),
                    const SizedBox(width: 6),
                    Text(
                      enabled ? 'Select $label' : 'Select ${_getPreviousLabel(label)} first',
                      style: TextStyle(
                        color: enabled ? Colors.grey : Colors.grey.shade400,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                onChanged: enabled ? onChanged : null,
                items: items
                    .map(
                      (item) => DropdownMenuItem<T>(
                        value: item,
                        child: Text(
                          itemLabel(item),
                          style: const TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getPreviousLabel(String label) {
    switch (label) {
      case 'Region':
        return 'Zone';
      case 'Area':
        return 'Region';
      case 'Point':
        return 'Area';
      default:
        return '';
    }
  }
}