import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/input_fields/custome_image_picker_button.dart';
import '../../../reusable_widgets/input_fields/dropdowns.dart';
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../leave_management/controller/leave_controller.dart';
import '../../leave_management/model/selected_vehicle_with_tada.dart';
import '../../leave_management/model/ta_da_vehicle_model.dart';
import '../model/created_tada_model.dart';

class CreateTadaUI extends ConsumerStatefulWidget {
  final CreatedTaDaModel? data;
  const CreateTadaUI({Key? key, this.data}) : super(key: key);
  static const routeName = "create_tada_ui";
  @override
  ConsumerState<CreateTadaUI> createState() => _CreateTadaUIState();
}

class _CreateTadaUIState extends ConsumerState<CreateTadaUI> {
  CreatedTaDaModel? updateModel;
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
    if(widget.data!=null) {
      updateModel = widget.data;

      fromAddressController.text = updateModel?.fromAddress??"";
      toAddressController.text = updateModel?.toAddress??"";
      contractPersonNameController.text = updateModel?.contactName??"";
      contractPersonPhoneController.text = updateModel?.contactNo??"";
      reasonController.text = updateModel?.remark??"";
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        // await Future.delayed(Duration(seconds: 2));
        ref.read(selectedMovementDateRangeProvider.notifier).state = DateTime.parse(updateModel!.startDate??"");
        // ref.read(selectedLeaveDateRangeProvider.notifier).state = DateTimeRange(
        //     start: DateTime.parse(updateModel!.startDate??""),
        //     end: DateTime.parse(updateModel!.endDate??"")
        // );
      });

    }
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

  bool _updated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: updateModel==null? "Create TA/DA" : "Update TA/DA",
        showLeading: true,
        centerTitle: true,
        onLeadingIconPressed: (){
          leaveController.refreshState();
          navigatorKey.currentState?.pop();
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            leaveController.heading("Date"),
            InkWell(
              onTap: ()async{
                if(widget.data!=null) {
                  Alerts(context: context).customDialog(
                    type: AlertType.error,
                    message: 'You cannot change date while updating TADA',
                    // description: 'You have to capture retailers image',
                  );
                } else {
                  await leaveController.taDaDateRange();
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 9.sp),
                  width: double.infinity,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(verificationRadius), color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer(
                          builder: (context,ref,_) {
                            DateTime? pickedRange = ref.watch(selectedMovementDateRangeProvider);
                            String dateRange = "Date";
                            Color color = lightMediumGrey;
                            double size = 9.sp;
                            if(pickedRange != null){
                              dateRange = uiDateFormat.format(pickedRange);
                              color = Colors.black;
                              size = 11.sp;
                              return Text(
                                dateRange,
                                style: TextStyle(color: color, fontSize: size),
                              );
                            }
                            return LangText(
                              dateRange,
                              style: TextStyle(color: color, fontSize: size),
                            );
                          }
                      ),
                      Icon(
                        Icons.calendar_month_outlined,
                        color: lightMediumGrey,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Consumer(builder: (context, ref, _) {
              DateTime? pickedRange = ref.watch(selectedMovementDateRangeProvider);

              if (pickedRange == null) {
                return LangText("Select date first");
              }
              return Column(
                children: [
                  leaveController.heading("Number of days"),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                    child: Container(
                        padding:
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 9.sp),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(verificationRadius),
                            color: Colors.grey),
                        child: Consumer(builder: (context, ref, _) {
                          DateTime? pickedRange = ref.watch(selectedMovementDateRangeProvider);
                          String rangeStr = "0";
                          if(pickedRange != null){
                            rangeStr = "1";
                          }
                          return LangText(
                            rangeStr,
                            isNumber: true,
                          );
                        })),
                  ),
                  leaveController.heading("From address"),
                  Consumer(builder: (context, ref, _) {
                    String lang = ref.watch(languageProvider);
                    String hint = "";
                    if (lang == "en") {
                      hint = "TA/DA";
                    }
                    return NormalTextField(
                      textEditingController: fromAddressController,
                      hintText: hint,
                    );
                  }),
                  leaveController.heading("To address"),
                  Consumer(builder: (context, ref, _) {
                    String lang = ref.watch(languageProvider);
                    String hint = "";
                    if (lang == "en") {
                      hint = "TA/DA";
                    }
                    return NormalTextField(
                      textEditingController: toAddressController,
                      hintText: hint,
                    );
                  }),
                  leaveController.heading("TA/DA type with Cost"),
                  Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      final asyncLeaveModel = ref.watch(vehicleCostListProvider);
                      final vehicleTaDas =
                      ref.watch(selectedVehicleListTypeProvider);
                      return asyncLeaveModel.when(
                          data: (leaveData) {
                            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                              if(updateModel!=null && _updated == false) {
                                if((updateModel?.taDaCost??<TaDaCost>[]).isNotEmpty) {
                                  ref.read(selectedVehicleListTypeProvider.notifier).removeTaDa(index: 0);
                                }
                                for(var val in updateModel?.taDaCost ??<TaDaCost>[]) {
                                  var index = leaveData.indexWhere((e)=>e.id==val.costTypeId);
                                  if(index!=-1) {
                                    final taDa = leaveData[index];
                                    // ref.read(selectedVehicleListTypeProvider.notifier).addAnother(taDa: SelectedVehicleWithTaDa(textEditingController: TextEditingController(text: "${val.cost}"), selectedTaDa: taDa));
                                  }
                                }
                                _updated = true;
                              }
                            });
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: vehicleTaDas.length,
                              itemBuilder: (BuildContext context, int index) {
                                return IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: CustomSingleDropdown<TaDaVehicleModel>(
                                          items: leaveData.map<DropdownMenuItem<TaDaVehicleModel>>(
                                                (e) => DropdownMenuItem(value: e, child: Text(e.slug ?? ""),
                                            ),
                                          ).toList(),
                                          onChanged: (TaDaVehicleModel? val) {
                                            // ref.read(selectedVehicleListTypeProvider.notifier).updateTaDaType(
                                            //   taDa: vehicleTaDas[index],
                                            //   index: index,
                                            //   taDaItem: val!,
                                            // );
                                          },
                                          hintText: "Ta/Da Type",
                                          // value: vehicleTaDas[index].selectedTaDa,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                verificationRadius + 1),
                                            color:
                                            index + 1 == vehicleTaDas.length
                                                ? primary
                                                : primaryRed,
                                          ),
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                            top: 5.sp,
                                            bottom: 5.sp,
                                            right: 9.sp,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Consumer(
                                                    builder: (context, ref, _) {
                                                      String lang =
                                                      ref.watch(languageProvider);
                                                      String hint = "খরচ";
                                                      if (lang == "en") {
                                                        hint = "Cost";
                                                      }
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              verificationRadius),
                                                          color: Colors.white,
                                                        ),

                                                        // margin: EdgeInsets.only(top: 5.sp, bottom: 5.sp, right: 9.sp,),
                                                        alignment: Alignment.center,
                                                        child: InputTextFields(
                                                          textEditingController:
                                                          vehicleTaDas[index]
                                                              .textEditingController,
                                                          // initialValue: vehicleTaDas[index].taDa,
                                                          hintText: hint,
                                                          inputType:
                                                          TextInputType.number,
                                                          onChanged: (v) {
                                                            // ref.read(selectedVehicleListTypeProvider.notifier).updateTaDaValue(taDa: vehicleTaDas[index], index: index, taDaValue: v,);
                                                          },
                                                        ),
                                                      );
                                                    }),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  if (index + 1 == vehicleTaDas.length) {
                                                    var lastItem = vehicleTaDas.last;
                                                    if(lastItem.selectedTaDa==null || lastItem.textEditingController==null || (lastItem.textEditingController?.text.isEmpty ?? false)) {
                                                      Alerts(context: context).customDialog(type: AlertType.warning, description: "Enter all TA/DA type and Cost first");
                                                    } else {
                                                      ref.read(selectedVehicleListTypeProvider.notifier).addNew();
                                                    }
                                                  } else {
                                                    ref.read(selectedVehicleListTypeProvider.notifier).removeTaDa(index: index);
                                                  }
                                                },
                                                icon: Icon(
                                                  index + 1 == vehicleTaDas.length
                                                      ? Icons.add_rounded
                                                      : Icons.close_rounded,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
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
                    },
                  ),
                  leaveController.heading("Contact person name"),
                  Consumer(builder: (context, ref, _) {
                    String lang = ref.watch(languageProvider);
                    String hint = "";
                    if (lang == "en") {
                      hint = "";
                    }
                    return NormalTextField(
                      textEditingController: contractPersonNameController,
                      hintText: hint,
                      inputType: TextInputType.name,
                    );
                  }),
                  leaveController.heading("Contact person"),
                  Consumer(builder: (context, ref, _) {
                    String lang = ref.watch(languageProvider);
                    String hint = "";
                    if (lang == "en") {
                      hint = "";
                    }
                    return NormalTextField(
                      textEditingController: contractPersonPhoneController,
                      hintText: hint,
                      inputType: TextInputType.number,
                    );
                  }),
                  leaveController.heading("Reason"),
                  Consumer(builder: (context, ref, _) {
                    String lang = ref.watch(languageProvider);
                    String hint = "Reason";
                    if (lang != "en") {
                      hint = "কারন লিখুন";
                    }
                    return Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                      child: InputTextFields(
                        textEditingController: reasonController,
                        hintText: hint,
                        inputType: TextInputType.text,
                        maxLine: 5,
                      ),
                    );
                  }),
                  leaveController.heading("Attachment"),
                  Consumer(
                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      final list = ref.watch(multipleImageListProvider);
                      return ListView.builder(
                        itemCount: list.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: 100.w,
                            child: CustomMultipleImagePickerButton(
                              type: CapturedMultipleImageType.taDa,
                              index: index,
                              onPressed: () {
                                leaveController.captureTaDaImage(index: index, type: CapturedMultipleImageType.taDa);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),

                  Consumer(
                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      final list = ref.watch(multipleImageListProvider);
                      return SingleCustomButton(
                        color: lightMediumGrey2,
                        label: "Add another attachment",
                        onPressed: (){
                          ref.read(multipleImageListProvider.notifier).state = [...list]..add(DateTime.now().toString());
                        },
                        icon: const Icon(Icons.add_rounded, color: primary,),
                        textColor: primary,
                      );
                    },
                  ),

                  SizedBox(
                    height: 3.h,
                  ),
                  SubmitButtonGroup(
                    button1Label: updateModel != null ? "Update" : null,
                    twoButtons: true,
                    onButton1Pressed: () {
                      if (updateModel == null) {
                        leaveController.submitTaDaToServer(
                          fromAddress: fromAddressController.text,
                          toAddress: toAddressController.text,
                          contactPerson: contractPersonNameController.text,
                          contactNumber: contractPersonPhoneController.text,
                          reason: reasonController.text,
                        );
                      } else {
                        leaveController.updateTaDaToServer(
                          updated: updateModel,
                          fromAddress: fromAddressController.text,
                          toAddress: toAddressController.text,
                          contactPerson: contractPersonNameController.text,
                          contactNumber: contractPersonPhoneController.text,
                          reason: reasonController.text,
                        );
                      }
                    },
                    onButton2Pressed: () {
                      navigatorKey.currentState?.pop();
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              );
            }),

          ],
        ),
      ),
    );
  }

}
