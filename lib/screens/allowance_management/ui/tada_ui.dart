import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/leave_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/input_fields/custome_image_picker_button.dart';
import '../../../reusable_widgets/input_fields/dropdowns.dart';
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../leave_management/controller/leave_controller.dart';
import '../../leave_management/model/ta_da_vehicle_model.dart';
import '../model/created_tada_model.dart';
import 'create_tada_ui.dart';

class TaDaUI extends ConsumerStatefulWidget {
  const TaDaUI({Key? key}) : super(key: key);

  @override
  ConsumerState<TaDaUI> createState() => _TaDaUIState();
}

class _TaDaUIState extends ConsumerState<TaDaUI> {
  late ScrollController _scrollController;
  late LeaveController leaveController;
  TextEditingController reasonController = TextEditingController();
  TextEditingController fromAddressController = TextEditingController();
  TextEditingController toAddressController = TextEditingController();
  TextEditingController contractPersonPhoneController = TextEditingController();
  TextEditingController contractPersonNameController = TextEditingController();

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
    // tadaController.dispose();
    _scrollController.dispose();
    fromAddressController.dispose();
    toAddressController.dispose();
    contractPersonPhoneController.dispose();
    contractPersonNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<CreatedTaDaModel>> asyncLeaveModel =
        ref.watch(taDaDataProvider);
    LeaveManagementData? updateModel = ref.watch(updatedMovementProvider);
    return asyncLeaveModel.when(
        data: (leaveData) {
          return Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, CreateTadaUI.routeName);
              },
              label: LangText(
                "Create TA/DA",
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: primary,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Column(
                children: [
                  leaveData.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.sp, vertical: 5.sp),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// sku list
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5.sp),
                                        topLeft: Radius.circular(5.sp)),
                                    gradient: const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [primary, primaryBlue],
                                    ),
                                    color: Colors.grey[100]),
                                child: DefaultTextStyle(
                                  style: TextStyle(
                                      fontSize: normalFontSize,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 1.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: LangText(
                                            'Move Type',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: normalFontSize),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: LangText(
                                              'Date',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: normalFontSize,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: LangText(
                                              'TA/DA',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: normalFontSize),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: LangText(
                                            'Date',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: normalFontSize),
                                          ),
                                        ),
                                        Expanded(
                                          child: LangText(
                                            'Status',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: normalFontSize),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              Container(
                                color: Colors.white,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: leaveData.length,
                                    itemBuilder: (context, index1) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.w, vertical: 0.5.h),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: LangText(
                                                    leaveData[index1]
                                                            .toAddress ??
                                                        "",
                                                    style: TextStyle(
                                                        fontSize: smallFontSize,
                                                        color: grey),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: LangText(
                                                      apiDateFormat.format(DateTime.parse(leaveData[index1].startDate ?? "")),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize:
                                                              smallFontSize,
                                                          color: grey),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: LangText(
                                                      leaveData[index1]
                                                          .cost
                                                          .toString(),
                                                      isNumber: true,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize:
                                                              smallFontSize,
                                                          color: grey),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: LangText(
                                                    apiDateFormat.format(DateTime.parse(leaveData[index1].createdDate ?? "")),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize:
                                                            smallerFontSize,
                                                        color: grey),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      navigatorKey.currentState
                                                          ?.pushNamed(
                                                              CreateTadaUI
                                                                  .routeName,
                                                              arguments:
                                                                  leaveData[
                                                                      index1]);
                                                      // final movement = leaveData.leaveData[index1];
                                                      // ref
                                                      //     .read(
                                                      //         updatedMovementProvider
                                                      //             .notifier)
                                                      //     .state = movement;
                                                      // reasonController.text =
                                                      //     movement.reason;
                                                      // LeaveManagementTypes?
                                                      //     selectedType =
                                                      //     ref.watch(
                                                      //         selectedMovementTypeProvider);
                                                      //
                                                      // leaveData.leaveTypes.forEach((e) {
                                                      //   if (e.type == movement.type) {
                                                      //     ref.read(selectedMovementTypeProvider.notifier).state = e;
                                                      //   }
                                                      // });
                                                      //
                                                      // ref.read(selectedMovementDateRangeProvider.notifier).state = DateTime.parse(movement.startDate);
                                                      //
                                                      // _scrollController.animateTo(
                                                      //   _scrollController.position
                                                      //       .minScrollExtent,
                                                      //   duration: const Duration(
                                                      //       milliseconds: 350),
                                                      //   curve: Curves.ease,
                                                      // );
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Visibility(
                                                          visible: (leaveData[
                                                                          index1]
                                                                      .status ??
                                                                  0) ==
                                                              0,
                                                          child: const Icon(
                                                            Icons.edit,
                                                            color:
                                                                Colors.orange,
                                                          ),
                                                        ),
                                                        // LangText(
                                                        //   leaveController.statusCheck(
                                                        //       leaveData[index1]
                                                        //               . ??
                                                        //           0),
                                                        //   textAlign:
                                                        //       TextAlign.end,
                                                        //   style: TextStyle(
                                                        //     fontSize:
                                                        //         smallFontSize,
                                                        //     color: leaveController
                                                        //         .setStatusColor(
                                                        //             leaveData[index1]
                                                        //                     .status ??
                                                        //                 0),
                                                        //   ),
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const Divider(
                                              color: Colors.blueGrey,
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                              Container(
                                  height: 2.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(5.sp),
                                          bottomLeft: Radius.circular(5.sp)),
                                      gradient: const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [primary, primaryBlue],
                                      ),
                                      color: Colors.grey[100]))
                            ],
                          ),
                        )
                      : Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 100),
                        Image.asset(
                          "assets/not_found.png",
                          height: 10.h,
                        ),
                        const SizedBox(height: 8),
                        LangText("No TA/DA request available."),
                        SizedBox(
                          height: 2.h,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
        error: (error, _) {
          return Center(
            child: LangText("Nothing to see"),
          );
        },
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ));
  }
}
