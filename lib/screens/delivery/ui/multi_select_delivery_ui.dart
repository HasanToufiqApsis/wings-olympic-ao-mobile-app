import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../models/outlet_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/body.dart';
import '../controller/delivery_controller.dart';
import 'existing_preorder_ui.dart';

class MultiSelectDeliveryUI extends ConsumerStatefulWidget {
  const MultiSelectDeliveryUI({Key? key}) : super(key: key);
  static const routeName = "/multi_select_ui";

  @override
  ConsumerState<MultiSelectDeliveryUI> createState() => _MultiSelectDeliveryUIState();
}

class _MultiSelectDeliveryUIState extends ConsumerState<MultiSelectDeliveryUI> {
  late final Alerts _alerts;

  @override
  void initState() {
    super.initState();
    _alerts = Alerts(context: context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<OutletModel>> asyncOutletList = ref.watch(deliveryOutletListProvider);
    return asyncOutletList.when(
        data: (outletList) {
          return CustomBody(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: Column(
                // clipBehavior: Clip.antiAlias,
                children: [
                  Expanded(
                    child: outletList.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.only(bottom: 40),
                            itemCount: outletList.length,
                            itemBuilder: (context, index) {
                              return Consumer(builder: (context, ref, _) {
                                List<OutletModel> list = ref.watch(selectedMultiOutletProvider);
                                return ListTile(
                                  onTap: () {
                                    if (list.isNotEmpty) {
                                      if (!list.contains(outletList[index])) {
                                        list.add(outletList[index]);
                                        ref.read(selectedMultiOutletProvider.notifier).state = [
                                          ...list
                                        ];
                                      } else {
                                        list.remove(outletList[index]);
                                        ref.read(selectedMultiOutletProvider.notifier).state = [
                                          ...list
                                        ];
                                      }
                                    }
                                  },
                                  onLongPress: () {
                                    if (!list.contains(outletList[index])) {
                                      list.add(outletList[index]);
                                      ref.read(selectedMultiOutletProvider.notifier).state = [
                                        ...list
                                      ];
                                    } else {
                                      list.remove(outletList[index]);
                                      ref.read(selectedMultiOutletProvider.notifier).state = [
                                        ...list
                                      ];
                                    }
                                  },
                                  tileColor: index % 2 == 0 ? Colors.white : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: list.contains(outletList[index])
                                            ? primary
                                            : Colors.transparent),
                                    borderRadius: BorderRadius.circular(5.sp),
                                  ),
                                  leading: const CircleAvatar(
                                    backgroundColor: primary,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      LangText(outletList[index].name),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      ExistingPreorderUI(outlet: outletList[index])
                                    ],
                                  ),
                                  subtitle: LangText(outletList[index].owner),
                                );
                              });
                            },
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Center(
                              //   child: SizedBox(
                              //     height: 30.sp,
                              //     width: 30.sp,
                              //     child: Image.asset(
                              //       'assets/sell_out_of_selected_outlet_icon.png',
                              //     ),
                              //   ),
                              // ),

                              Icon(
                                Icons.warning_amber_rounded,
                                size: 56,
                                color: yellow,
                              ),
                              8.verticalSpacing,
                              Padding(
                                padding: EdgeInsets.only(left: 16, top: 10),
                                child: LangText(
                                  'You have no more outlets to deliver...', //
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 5.h),
                            ],
                          ),
                  ),
                  Consumer(builder: (context, ref, _) {
                    List<OutletModel> list = ref.watch(selectedMultiOutletProvider);
                    List<OutletModel> selectedList = ref.watch(selectedMultiOutletProvider);
                    if (list.isEmpty) {
                      return Container();
                    }
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade300,
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 10.sp),
                          child: CheckboxListTile(
                            onChanged: (v) {
                              if (selectedList.length == outletList.length) {
                                ref.read(selectedMultiOutletProvider.notifier).state = [];
                              } else {
                                ref.read(selectedMultiOutletProvider.notifier).state = [...outletList];
                              }
                            },
                            value: selectedList.length == outletList.length,
                            title: LangText("Select All"),
                          ),
                        ),
                        SubmitButtonGroup(
                          twoButtons: true,
                          layout: ButtonLayout.horizontal,
                          onButton2Pressed: () {
                            ref.refresh(selectedMultiOutletProvider);
                          },
                          onButton1Pressed: () {
                            _alerts.customDialog(
                                type: AlertType.warning,
                                message: 'Are you sure, you want to save data?',
                                button1: 'Yes',
                                button2: 'No',
                                twoButtons: true,
                                onTap1: () {
                                  Navigator.pop(context);
                                  DeliveryController(context: context, ref: ref)
                                      .saveMultiDelivery(list);
                                },
                                onTap2: () {
                                  Navigator.pop(context);
                                });

                            ///print
                          },
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        },
        error: (error, _) => Container(),
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ));
  }
}
