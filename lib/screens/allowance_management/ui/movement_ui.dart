import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/leave_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../leave_management/controller/leave_controller.dart';
import 'create_movement_ui.dart';

class MovementUI extends ConsumerStatefulWidget {
  const MovementUI({Key? key}) : super(key: key);

  @override
  ConsumerState<MovementUI> createState() => _MovementUIState();
}

class _MovementUIState extends ConsumerState<MovementUI> {
  late ScrollController _scrollController;
  late LeaveController leaveController;
  TextEditingController reasonController = TextEditingController();
  TextEditingController tadaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    leaveController = LeaveController(context: context, ref: ref);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    reasonController.dispose();
    tadaController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<LeaveManagementModel> asyncLeaveModel = ref.watch(movementDataProvider);
    LeaveManagementData? updateModel = ref.watch(updatedMovementProvider);
    // return asyncLeaveModel.when(
    //     data: (leaveData) {
    //       return Scaffold(
    //         floatingActionButton: FloatingActionButton.extended(
    //           onPressed: () {
    //             Navigator.pushNamed(context, CreateMovementUI.routeName);
    //           },
    //           label: LangText(
    //             "Create Movement",
    //             style: const TextStyle(color: Colors.white),
    //           ),
    //           backgroundColor: primary,
    //         ),
    //         // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    //         body: SingleChildScrollView(
    //           padding: EdgeInsets.only(bottom: 10.h),
    //           child: Column(
    //             children: [
    //               leaveData.leaveData.isNotEmpty
    //                   ? Padding(
    //                       padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
    //                       child: Column(
    //                         mainAxisSize: MainAxisSize.min,
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           /// sku list
    //                           Container(
    //                             decoration: BoxDecoration(
    //                                 borderRadius: BorderRadius.only(
    //                                     topRight: Radius.circular(5.sp),
    //                                     topLeft: Radius.circular(5.sp)),
    //                                 gradient: const LinearGradient(
    //                                   begin: Alignment.centerLeft,
    //                                   end: Alignment.centerRight,
    //                                   colors: [primary, primaryBlue],
    //                                 ),
    //                                 color: Colors.grey[100]),
    //                             child: DefaultTextStyle(
    //                               style: TextStyle(
    //                                   fontSize: normalFontSize,
    //                                   color: Colors.white,
    //                                   fontWeight: FontWeight.bold),
    //                               child: Padding(
    //                                 padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
    //                                 child: Row(
    //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                   crossAxisAlignment: CrossAxisAlignment.center,
    //                                   children: [
    //                                     Expanded(
    //                                       child: LangText(
    //                                         'Move Type',
    //                                         style: TextStyle(
    //                                             color: Colors.white, fontSize: normalFontSize),
    //                                       ),
    //                                     ),
    //                                     Expanded(
    //                                       child: Center(
    //                                         child: LangText(
    //                                           'Days',
    //                                           style: TextStyle(
    //                                               color: Colors.white, fontSize: normalFontSize),
    //                                         ),
    //                                       ),
    //                                     ),
    //                                     Expanded(
    //                                       child: Center(
    //                                         child: LangText(
    //                                           'TA/DA',
    //                                           style: TextStyle(
    //                                               color: Colors.white, fontSize: normalFontSize),
    //                                         ),
    //                                       ),
    //                                     ),
    //                                     Expanded(
    //                                       child: LangText(
    //                                         'Date',
    //                                         textAlign: TextAlign.end,
    //                                         style: TextStyle(
    //                                             color: Colors.white, fontSize: normalFontSize),
    //                                       ),
    //                                     ),
    //                                     Expanded(
    //                                       child: LangText(
    //                                         'Status',
    //                                         textAlign: TextAlign.end,
    //                                         style: TextStyle(
    //                                             color: Colors.white, fontSize: normalFontSize),
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //
    //                           Container(
    //                             color: Colors.white,
    //                             child: ListView.builder(
    //                                 shrinkWrap: true,
    //                                 primary: false,
    //                                 itemCount: leaveData.leaveData.length,
    //                                 itemBuilder: (context, index1) {
    //                                   return Padding(
    //                                     padding:
    //                                         EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
    //                                     child: Column(
    //                                       children: [
    //                                         Row(
    //                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                           children: [
    //                                             Expanded(
    //                                               child: LangText(
    //                                                 leaveData.leaveData[index1].type,
    //                                                 style: TextStyle(
    //                                                     fontSize: smallFontSize, color: grey),
    //                                                 // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
    //                                               ),
    //                                             ),
    //                                             Expanded(
    //                                               child: Center(
    //                                                 child: LangText(
    //                                                   leaveData.leaveData[index1].totalDays
    //                                                       .toString(),
    //                                                   isNumber: true,
    //                                                   textAlign: TextAlign.end,
    //                                                   style: TextStyle(
    //                                                       fontSize: smallFontSize, color: grey),
    //                                                 ),
    //                                               ),
    //                                             ),
    //                                             Expanded(
    //                                               child: Center(
    //                                                 child: LangText(
    //                                                   leaveData.leaveData[index1].tada == null
    //                                                       ? "N/A"
    //                                                       : leaveData.leaveData[index1].tada
    //                                                           .toString(),
    //                                                   isNumber: true,
    //                                                   textAlign: TextAlign.end,
    //                                                   style: TextStyle(
    //                                                       fontSize: smallFontSize, color: grey),
    //                                                 ),
    //                                               ),
    //                                             ),
    //                                             Expanded(
    //                                               child: LangText(
    //                                                 leaveData.leaveData[index1].startDate,
    //                                                 textAlign: TextAlign.end,
    //                                                 style: TextStyle(
    //                                                     fontSize: smallerFontSize, color: grey),
    //                                               ),
    //                                             ),
    //                                             Expanded(
    //                                               child: InkWell(
    //                                                 onTap: () {
    //                                                   // navigatorKey.currentState?.pushNamed(MovementEditUi.routeName, arguments: leaveData.leaveData[index1]);
    //                                                   final movement = leaveData.leaveData[index1];
    //                                                   // ref.read(updatedMovementProvider.notifier).state = movement;
    //                                                   // reasonController.text = movement.reason;
    //                                                   // LeaveManagementTypes? selectedType = ref.watch(selectedMovementTypeProvider);
    //                                                   //
    //                                                   // leaveData.leaveTypes.forEach((e) {
    //                                                   //   if(e.type == movement.type) {
    //                                                   //     ref.read(selectedMovementTypeProvider.notifier).state = e;
    //                                                   //   }
    //                                                   // });
    //                                                   //
    //                                                   // ref.read(selectedMovementDateRangeProvider.notifier).state = DateTime.parse(movement.startDate);
    //                                                   //
    //                                                   // _scrollController.animateTo(_scrollController.position.minScrollExtent, duration: const Duration(milliseconds: 350),
    //                                                   //     curve: Curves.ease,);
    //                                                   Navigator.pushNamed(
    //                                                       context, CreateMovementUI.routeName,
    //                                                       arguments: movement);
    //                                                 },
    //                                                 child: Column(
    //                                                   crossAxisAlignment: CrossAxisAlignment.center,
    //                                                   mainAxisAlignment: MainAxisAlignment.end,
    //                                                   children: [
    //                                                     Visibility(
    //                                                       visible:
    //                                                           (leaveData.leaveData[index1].status ??
    //                                                                   0) ==
    //                                                               0,
    //                                                       child: const Icon(
    //                                                         Icons.edit,
    //                                                         color: Colors.orange,
    //                                                       ),
    //                                                     ),
    //                                                     LangText(
    //                                                       leaveController.statusCheck(
    //                                                           leaveData.leaveData[index1].status ??
    //                                                               0),
    //                                                       textAlign: TextAlign.end,
    //                                                       style: TextStyle(
    //                                                         fontSize: smallFontSize,
    //                                                         color: leaveController.setStatusColor(
    //                                                             leaveData
    //                                                                     .leaveData[index1].status ??
    //                                                                 0),
    //                                                       ),
    //                                                     ),
    //                                                   ],
    //                                                 ),
    //                                               ),
    //                                             )
    //                                           ],
    //                                         ),
    //                                         const Divider(
    //                                           color: Colors.blueGrey,
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   );
    //                                 }),
    //                           ),
    //                           Container(
    //                               height: 2.h,
    //                               decoration: BoxDecoration(
    //                                   borderRadius: BorderRadius.only(
    //                                       bottomRight: Radius.circular(5.sp),
    //                                       bottomLeft: Radius.circular(5.sp)),
    //                                   gradient: const LinearGradient(
    //                                     begin: Alignment.centerLeft,
    //                                     end: Alignment.centerRight,
    //                                     colors: [primary, primaryBlue],
    //                                   ),
    //                                   color: Colors.grey[100]))
    //                         ],
    //                       ),
    //                     )
    //                   : Center(
    //                       child: Column(
    //                         children: [
    //                           const SizedBox(height: 100),
    //                           Image.asset(
    //                             "assets/not_found.png",
    //                             height: 10.h,
    //                           ),
    //                           const SizedBox(height: 8),
    //                           LangText("No movement created."),
    //                           SizedBox(
    //                             height: 2.h,
    //                           )
    //                         ],
    //                       ),
    //                     )
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //     error: (error, _) {
    //       return Center(
    //         child: LangText("Nothing to see"),
    //       );
    //     },
    //     loading: () => const Center(
    //           child: CircularProgressIndicator(),
    //         ));
    return Placeholder();
  }
}
