import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/dashboard_btn_names.dart';
import 'package:wings_olympic_sr/services/cluster_service.dart';

import '../../../constants/constant_variables.dart';
import '../../../main.dart';
import '../../../models/outlet_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/cooler_available_image.dart';
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../reusable_widgets/scaffold_widgets/body.dart';
import '../controller/outlet_controller.dart';
import 'new_outlet_registration_ui.dart';
import 'outlet_details_ui.dart';

class OutletListUI extends ConsumerStatefulWidget {
  const OutletListUI({Key? key}) : super(key: key);
  static const routeName = "/outlet_list";

  @override
  ConsumerState<OutletListUI> createState() => _OutletListUIState();
}

// class _OutletListUIState extends ConsumerState<OutletListUI> {
//   final TextEditingController _searchTextController = TextEditingController();
//   final _appBarTitle = DashboardBtnNames.outlets;
//   Timer? timer;
//
//   @override
//   void dispose() {
//     super.dispose();
//     _searchTextController.dispose();
//     _searchTextController.removeListener(() {});
//   }
//
//   searchOutletListListener() {
//     String key = _searchTextController.text.trim();
//     if (timer?.isActive ?? false) {
//       timer?.cancel();
//     }
//     timer = Timer(Duration(seconds: 1), () {
//       ref.read(outletListProvider(false).notifier).searchByKey(key);
//     });
//   }
//
//   @override
//   void initState() {
//     _searchTextController.addListener(searchOutletListListener);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     AsyncValue<List<OutletModel>> asyncOutletList =
//         ref.watch(outletListProvider(false));
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: _appBarTitle,
//         titleImage: "outlet.png",
//         showLeading: true,
//         heroTagTitle: _appBarTitle,
//         heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
//       ),
//       body: CustomBody(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10.sp),
//           child: CustomScrollView(
//             clipBehavior: Clip.antiAlias,
//             slivers: [
//               // SliverAppBar(
//               //   expandedHeight:  17.h,
//               //   backgroundColor: primaryGrey,
//               //   automaticallyImplyLeading: false,
//               //   floating: true,
//               //   pinned: true,
//               //   snap: true,
//               //   ///==================== buttons and filter ===================================
//               //   // title: sliverAppBarTitle(),
//               //   flexibleSpace: FlexibleSpaceBar(
//               //     centerTitle: true,
//               //     expandedTitleScale: 1,
//               //     titlePadding: EdgeInsets.symmetric(horizontal:0.w, vertical: 0.h
//               //     ),
//               //
//               //     title: sliverAppBarTitle(),
//               //     background: InputTextFields(
//               //       textEditingController: _searchTextController,
//               //       hintText: "Search Outlets",
//               //       suffixIcon: Icons.search,
//               //     ),
//               //   ),
//               // ),
//
//               // SliverAppBar(
//               //
//               //   title: sliverAppBarTitle(),
//               // ),
//               SliverToBoxAdapter(
//                 child: Consumer(
//                   builder: (context,ref,_) {
//                     String lang = ref.watch(languageProvider);
//                     String hint = "Search Outlets";
//                     if(lang != "en"){
//                       hint = "খুচরা বিক্রেতা অনুসন্ধান করুন";
//                     }
//                     return InputTextFields(
//                       textEditingController: _searchTextController,
//                       hintText: hint,
//                       suffixIcon: Icons.search,
//                     );
//                   }
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // RichText(
//                     //     text: TextSpan(
//                     //         text: "Show: ",
//                     //         style: TextStyle(
//                     //             color: primaryBlack, fontSize: normalFontSize),
//                     //         children: [
//                     //       TextSpan(
//                     //           text: "All",
//                     //           style: TextStyle(
//                     //               color: primaryBlack,
//                     //               fontWeight: FontWeight.bold,
//                     //               fontSize: normalFontSize))
//                     //     ])),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         LangText(
//                           "Show: ",
//                           style: TextStyle(
//                               color: primaryBlack, fontSize: normalFontSize),
//                         ),
//                         LangText(
//                           "All",
//                           style: TextStyle(
//                               color: primaryBlack,
//                               fontWeight: FontWeight.bold,
//                               fontSize: normalFontSize),
//                         )
//                       ],
//                     ),
//                     SizedBox(
//                       width: 50.w,
//                       child: Consumer(builder: (context, ref, _) {
//                         AsyncValue<Map> asyncAvailableOnboardingFeature =
//                             ref.watch(availableOnboardingFeaturesProvider);
//                         return asyncAvailableOnboardingFeature.when(
//                             data: (availableOnboardingFeature) {
//                               if (availableOnboardingFeature
//                                   .containsKey("new_outlet")) {
//                                 if (availableOnboardingFeature["new_outlet"] ==
//                                     1) {
//                                   return SubmitButtonGroup(
//                                     button1Icon: const Icon(Icons.add, color: Colors.white,),
//                                     button1Label: "Register New",
//                                     onButton1Pressed: () {
//                                       Navigator.pushNamed(context,
//                                           NewOutletRegistrationUI.routeName);
//                                     },
//                                   );
//                                 }
//                               }
//                               return const SizedBox(
//                                 width: 1,
//                               );
//                             },
//                             error: (error, _) => Container(),
//                             loading: () => const Center(
//                                   child: CircularProgressIndicator(),
//                                 ));
//                       }),
//                     )
//                   ],
//                 ),
//               ),
//               asyncOutletList.when(
//                   data: (outletList) {
//                     return SliverList(
//                       delegate: SliverChildBuilderDelegate((context, index) {
//                         return ListTile(
//                           onTap: ()async {
//                             await OutletController(ref:ref, context: context).setDifferentImageURL(outletList[index]);
//                             navigatorKey.currentState?.pushNamed(
//                                 OutletDetailsUI.routeName,
//                                 arguments: outletList[index]);
//                           },
//                           tileColor: index % 2 == 0
//                               ? Colors.white
//                               : Colors.transparent,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5.sp)),
//                           leading: const CircleAvatar(
//                             backgroundColor: primary,
//                             child: Icon(
//                               Icons.person,
//                               color: Colors.white,
//                             ),
//                           ),
//                           title: Row(
//                             children: [
//                               LangText(outletList[index].name),
//                               CoolerAvailableImageWidget(outlet: outletList[index])
//                             ],
//                           ),
//                           subtitle: LangText(outletList[index].owner),
//                           trailing: outletList[index].outletStatus=="PENDING" ? Text(outletList[index].outletStatus??"") : null,
//                         );
//                       }, childCount: outletList.length),
//                     );
//                   },
//                   error: (error, _) => SliverToBoxAdapter(),
//                   loading: () => SliverToBoxAdapter(
//                           child: const Center(
//                         child: CircularProgressIndicator(),
//                       ))),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget sliverAppBarTitle() {
//     return SizedBox(
//       height: 10.h,
//       child: Column(
//         children: [
//           // InputTextFields(
//           //   textEditingController: _searchTextController,
//           //   hintText: "Search Outlets",
//           //   suffixIcon: Icons.search,
//           // ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               InkWell(
//                 onTap: () {},
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     LangText(
//                       "Show: ",
//                       style: TextStyle(
//                           color: primaryBlack, fontSize: normalFontSize),
//                     ),
//                     LangText(
//                       "All",
//                       style: TextStyle(
//                           color: primaryBlack,
//                           fontWeight: FontWeight.bold,
//                           fontSize: normalFontSize),
//                     )
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 width: 50.w,
//                 child: SubmitButtonGroup(
//                   button1Icon: const Icon(Icons.add, color: Colors.white,),
//                   button1Label: "Register New",
//                   onButton1Pressed: () {
//                     OutletController(context: context, ref: ref)
//                         .refreshCameraProviders();
//                     Navigator.pushNamed(
//                         context, NewOutletRegistrationUI.routeName);
//                   },
//                 ),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }



// class _OutletListUIState extends ConsumerState<OutletListUI> {
//   final TextEditingController _searchTextController = TextEditingController();
//   final _appBarTitle = DashboardBtnNames.outlets;
//   Timer? timer;
//
//   @override
//   void dispose() {
//     super.dispose();
//     _searchTextController.dispose();
//     _searchTextController.removeListener(() {});
//   }
//
//   searchOutletListListener() {
//     String key = _searchTextController.text.trim();
//     if (timer?.isActive ?? false) {
//       timer?.cancel();
//     }
//     timer = Timer(Duration(seconds: 1), () {
//       ref.read(outletListProvider(false).notifier).searchByKey(key);
//     });
//   }
//
//   @override
//   void initState() {
//     _searchTextController.addListener(searchOutletListListener);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     AsyncValue<List<OutletModel>> asyncOutletList = ref.watch(outletListProvider(false));
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: _appBarTitle,
//         titleImage: "outlet.png",
//         showLeading: true,
//         heroTagTitle: _appBarTitle,
//         heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.only(left: 10.sp, right: 10.sp, bottom: 10.h, top: 16),
//           child: Column(
//             children: [
//               Consumer(
//                 builder: (context, ref, _) {
//                   String lang = ref.watch(languageProvider);
//                   String hint = "Search Outlets";
//                   if (lang != "en") {
//                     hint = "খুচরা বিক্রেতা অনুসন্ধান করুন";
//                   }
//                   return InputTextFields(
//                     textEditingController: _searchTextController,
//                     hintText: hint,
//                     suffixIcon: Icons.search,
//                   );
//                 },
//               ),
//               SizedBox(height: 16),
//               asyncOutletList.when(
//                 data: (outletList) {
//                   return ListView.builder(
//                       physics: const NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: outletList.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           onTap: ()async {
//                             await OutletController(ref:ref, context: context).setDifferentImageURL(outletList[index]);
//                             navigatorKey.currentState?.pushNamed(
//                                 OutletDetailsUI.routeName,
//                                 arguments: outletList[index]);
//                           },
//                           tileColor: index % 2 == 0
//                               ? Colors.white
//                               : Colors.transparent,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5.sp)),
//                           leading: const CircleAvatar(
//                             backgroundColor: primary,
//                             child: Icon(
//                               Icons.person,
//                               color: Colors.white,
//                             ),
//                           ),
//                           title: Row(
//                             children: [
//                               LangText(outletList[index].name),
//                               CoolerAvailableImageWidget(outlet: outletList[index])
//                             ],
//                           ),
//                           subtitle: LangText(outletList[index].owner),
//                           trailing: outletList[index].outletStatus=="PENDING" ? Text(outletList[index].outletStatus??"") : null,
//                         );
//                       });
//                   return SliverList(
//                     delegate: SliverChildBuilderDelegate((context, index) {
//                       return ListTile(
//                         onTap: () async {
//                           await OutletController(
//                             ref: ref,
//                             context: context,
//                           ).setDifferentImageURL(outletList[index]);
//                           navigatorKey.currentState?.pushNamed(
//                             OutletDetailsUI.routeName,
//                             arguments: outletList[index],
//                           );
//                         },
//                         tileColor: index % 2 == 0 ? Colors.white : Colors.transparent,
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.sp)),
//                         leading: const CircleAvatar(
//                           backgroundColor: primary,
//                           child: Icon(Icons.person, color: Colors.white),
//                         ),
//                         title: Row(
//                           children: [
//                             LangText(outletList[index].name),
//                             CoolerAvailableImageWidget(outlet: outletList[index]),
//                           ],
//                         ),
//                         subtitle: LangText(outletList[index].owner),
//                         trailing: outletList[index].outletStatus == "PENDING"
//                             ? Text(outletList[index].outletStatus ?? "")
//                             : null,
//                       );
//                     }, childCount: outletList.length),
//                   );
//                 },
//                 error: (error, _) => SizedBox(),
//                 loading: () =>
//                     SizedBox(),
//               ),],
//           ),
//         ),
//       ),
//       floatingActionButton: Consumer(
//         builder: (context, ref, _) {
//           AsyncValue<Map> asyncAvailableOnboardingFeature = ref.watch(
//             availableOnboardingFeaturesProvider,
//           );
//           return asyncAvailableOnboardingFeature.when(
//             data: (availableOnboardingFeature) {
//               if (availableOnboardingFeature.containsKey("new_outlet")) {
//                 if (availableOnboardingFeature["new_outlet"] == 1) {
//                   return FloatingActionButton.extended(
//                     onPressed: () {
//                       Navigator.pushNamed(context, NewOutletRegistrationUI.routeName);
//                     },
//                     label: LangText("Register New", style: const TextStyle(color: Colors.white)),
//                     backgroundColor: primary,
//                   );
//                   return SubmitButtonGroup(
//                     button1Icon: const Icon(Icons.add, color: Colors.white),
//                     button1Label: "Register New",
//                     onButton1Pressed: () {},
//                   );
//                 }
//               }
//               return const SizedBox();
//             },
//             error: (error, _) => SizedBox(),
//             loading: () => const SizedBox(),
//           );
//         },
//       ),
//       // floatingActionButton: FloatingActionButton.extended(
//       //   onPressed: () {
//       //     Navigator.pushNamed(context, CreateLeaveUI.routeName, arguments: leaveData);
//       //   },
//       //   label: LangText("Apply For Leave", style: const TextStyle(color: Colors.white),),
//       //   backgroundColor: primary,
//       // ),
//     );
//   }
//
//   Widget sliverAppBarTitle() {
//     return SizedBox(
//       height: 10.h,
//       child: Column(
//         children: [
//           // InputTextFields(
//           //   textEditingController: _searchTextController,
//           //   hintText: "Search Outlets",
//           //   suffixIcon: Icons.search,
//           // ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               InkWell(
//                 onTap: () {},
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     LangText(
//                       "Show: ",
//                       style: TextStyle(color: primaryBlack, fontSize: normalFontSize),
//                     ),
//                     LangText(
//                       "All",
//                       style: TextStyle(
//                         color: primaryBlack,
//                         fontWeight: FontWeight.bold,
//                         fontSize: normalFontSize,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 width: 50.w,
//                 child: SubmitButtonGroup(
//                   button1Icon: const Icon(Icons.add, color: Colors.white),
//                   button1Label: "Register New",
//                   onButton1Pressed: () {
//                     OutletController(context: context, ref: ref).refreshCameraProviders();
//                     Navigator.pushNamed(context, NewOutletRegistrationUI.routeName);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }


class _OutletListUIState extends ConsumerState<OutletListUI> {
  final TextEditingController _searchTextController = TextEditingController();
  final _appBarTitle = DashboardBtnNames.outlets;
  Timer? timer;

  @override
  void dispose() {
    super.dispose();
    _searchTextController.dispose();
    _focusNode.dispose();
    _searchTextController.removeListener(() {});
  }

  searchOutletListListener() {
    String key = _searchTextController.text.trim();
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
    timer = Timer(Duration(seconds: 1), () {
      ref.read(outletListProvider(false).notifier).searchByKey(key);
    });
  }

  @override
  void initState() {
    _searchTextController.addListener(searchOutletListListener);
    super.initState();
  }

  bool searching = false;
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<OutletModel>> asyncOutletList =
    ref.watch(outletListProvider(false));
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // appBar: CustomAppBar(
      //   title: _appBarTitle,
      //   titleImage: "outlet.png",
      //   showLeading: true,
      //   heroTagTitle: _appBarTitle,
      //   heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
      // ),
      appBar: CustomAppBar(
        title: "Outlets",
        showSearch: searching,
        searchController: _searchTextController,
        focusNode: _focusNode,
        onSearchChanged: (value) {
          print(value);
        },
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                searching = !searching;
                if(searching) {
                  _focusNode.requestFocus();
                }
              });
            },
            icon: Icon(searching ? Icons.close : Icons.search, color: Colors.white,),
          ),
          SizedBox(width: 8)
        ],
      ),
      body: Column(
        children: [
          // Container(
          //   color: Colors.white,
          //   padding: EdgeInsets.only(
          //       left: 4.w, right: 4.w, top: 2.h, bottom: 2.h),
          //   child: Consumer(
          //     builder: (context, ref, _) {
          //       String lang = ref.watch(languageProvider);
          //       String hint = "Search Outlets";
          //       if (lang != "en") {
          //         hint = "খুচরা বিক্রেতা অনুসন্ধান করুন";
          //       }
          //       return InputTextFields(
          //         textEditingController: _searchTextController,
          //         hintText: hint,
          //         suffixIcon: Icons.search,
          //       );
          //     },
          //   ),
          // ),
          Expanded(
            child: asyncOutletList.when(
              data: (outletList) {
                return ListView.separated(
                  padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 2.h, bottom: 10.h,),
                  itemCount: outletList.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: 1.5.h),
                  itemBuilder: (context, index) {
                    final outlet = outletList[index];
                    return _buildOutletCard(outlet);
                  },
                );
              },
              error: (error, _) => SizedBox(),
              loading: () => Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, _) {
          AsyncValue<Map> asyncAvailableOnboardingFeature = ref.watch(
            availableOnboardingFeaturesProvider,
          );
          return asyncAvailableOnboardingFeature.when(
            data: (availableOnboardingFeature) {
              if (availableOnboardingFeature.containsKey("new_outlet")) {
                if (availableOnboardingFeature["new_outlet"] == 1) {
                  return FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, NewOutletRegistrationUI.routeName);
                    },
                    label: LangText("Register New",
                        style: const TextStyle(color: Colors.white)),
                    backgroundColor: primary,
                    icon: const Icon(Icons.add, color: Colors.white),
                  );
                }
              }
              return const SizedBox();
            },
            error: (error, _) => SizedBox(),
            loading: () => const SizedBox(),
          );
        },
      ),
    );
  }

  Widget _buildOutletCard(OutletModel outlet) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await OutletController(ref: ref, context: context)
                .setDifferentImageURL(outlet);
            navigatorKey.currentState?.pushNamed(
                OutletDetailsUI.routeName,
                arguments: outlet);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.storefront_rounded,
                    color: primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: LangText(
                              outlet.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLine: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8),
                          CoolerAvailableImageWidget(outlet: outlet),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.person_outline_rounded,
                              size: 14, color: Colors.grey),
                          SizedBox(width: 4),
                          Expanded(
                            child: LangText(
                              outlet.owner,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                              maxLine: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (outlet.outletStatus == "PENDING")
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: Colors.orange.withOpacity(0.2)),
                    ),
                    child: Text(
                      _getStatus(outlet.outletStatus ?? ""),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.grey[300],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getStatus(String status) {
    if(status == "PENDING") {
      return "UNVERIFIED";
    }
    return status;
  }
}