import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../models/asset_install_pull_out_get_model.dart';
import '../../../models/asset_requisition_model.dart';
import '../../../models/general_id_slug_model.dart';
import '../../../models/outlet_model.dart';
import '../../../models/retailers_mdoel.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/input_fields/custome_image_picker_button.dart';
import '../../../reusable_widgets/input_fields/dropdowns.dart';
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../controller/asset_controller.dart';

class AssetInstallationUI extends ConsumerStatefulWidget {
  const AssetInstallationUI({Key? key}) : super(key: key);

  @override
  ConsumerState<AssetInstallationUI> createState() => _AssetInstallationUIState();
}

class _AssetInstallationUIState extends ConsumerState<AssetInstallationUI> {
  late AssetController assetController;
  TextEditingController installAssetNumberController = TextEditingController();
  TextEditingController installAssetCoverController = TextEditingController();
  TextEditingController installAssetSizeController = TextEditingController();
  TextEditingController totalCostController = TextEditingController();
  TextEditingController totalLightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    assetController = AssetController(context: context, ref: ref);
  }

  @override
  void dispose() {
    super.dispose();
    installAssetNumberController.dispose();
    installAssetCoverController.dispose();
    installAssetSizeController.dispose();
    totalCostController.dispose();
    totalLightController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // assetController.heading("Asset Installation", 13.sp),
        // SizedBox(height: 3.h,),

        assetController.heading("Asset Type"),
        Consumer(builder: (context, ref, _) {
          AsyncValue<List<GeneralIdSlugModel>> asyncAssetType = ref.watch(getAssetTypeListProvider);
          return asyncAssetType.when(
              data: (assetType) {
                return Consumer(builder: (context, ref, _) {
                  GeneralIdSlugModel? selected = ref.watch(selectedAssetTypeProvider);
                  return CustomSingleDropdown<GeneralIdSlugModel>(
                    value: selected,
                    items: assetType.map<DropdownMenuItem<GeneralIdSlugModel>>((e) => DropdownMenuItem(value: e, child: Text(e.slug))).toList(),
                    onChanged: (value) {
                      ref.read(selectedAssetTypeProvider.notifier).state = value;

                      RetailersModel? selectedOutlet = ref.watch(selectedSoRetailerProvider);
                      if (selectedOutlet != null) {
                        ref.refresh(selectedSoRetailerProvider);
                      }
                    },
                  );
                });
              },
              error: (error, _) => Container(),
              loading: () => Container());
        }),
        assetController.heading("Outlet"),
        Consumer(builder: (context, ref, _) {
          // AsyncValue<List<OutletModel>> asyncOutletList = ref.watch(outletListProvider(true));
          // AsyncValue<List<RetailersModel>> asyncOutletList = ref.watch(getSoRetailerListProvider);
          GeneralIdSlugModel? selectedAssetType = ref.watch(selectedAssetTypeProvider);
          String? selected = ref.watch(selectedAssetActivityProvider);

          // if(selectedAssetType==null || selected==null){
          //   return const SizedBox();
          // }
          AssetInstallPullOutGetModel model=AssetInstallPullOutGetModel(assetType: selectedAssetType!, activity: selected!);


          return Consumer(builder: (context, ref, _) {
            // OutletModel? selectedOutlet = ref.watch(selectedOutletAssetProvider);
            AsyncValue<List<RetailersModel>> asyncOutletList = ref.watch(getTSMRetailerListProvider(model));
            return asyncOutletList.when(
                data: (outletList) {
                  if(outletList.isEmpty){
                    LangText('No outlet available for this Activity and Asset type');
                  }
                  return Consumer(builder: (context, ref, _) {
                    RetailersModel? selected = ref.watch(selectedSoRetailerProvider);
                    return CustomSingleDropdown<RetailersModel>(
                      value: selected,
                      items: outletList.map<DropdownMenuItem<RetailersModel>>((e) => DropdownMenuItem(value: e, child: Text(e.outletName))).toList(),
                      onChanged: (value) {
                        // ref.read(selectedOutletAssetProvider.notifier).state = value;
                        ref.read(selectedSoRetailerProvider.notifier).state = value;

                        installAssetNumberController.text = '';
                        installAssetCoverController.text = '';
                        installAssetSizeController.text = '';
                        totalCostController.text = '';
                        totalLightController.text = '';
                        ref.read(selectedAssetRequisitionProvider.notifier).state = null;
                      },
                      hintText: "Select an outlet",
                    );
                  });
                },
                error: (error, _) => Container(),
                loading: () => Center(
                  child: CircularProgressIndicator(),
                ));
          });

        }),
        Consumer(builder: (context, ref, _) {
          // OutletModel? selectedOutlet = ref.watch(selectedOutletAssetProvider);
          RetailersModel? selectedOutlet = ref.watch(selectedSoRetailerProvider);
          if (selectedOutlet == null) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Center(child: LangText("No outlet available for this Activity and Asset type", textAlign: TextAlign.center,)),
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              assetController.heading("Asset Request No"),
              Consumer(builder: (context, ref, _) {
                AsyncValue<List<AssetRequisitionModel>> asyncAssetRequisitionList = ref.watch(getAssetRequisitionListByOutletIdProvider(selectedOutlet.id!));

                GeneralIdSlugModel? slug = ref.read(selectedAssetTypeProvider);
                return asyncAssetRequisitionList.when(
                    data: (assetList) {
                      assetList = assetList.where((e) => e.type == slug?.slug).toList();
                      // assetList.map((e) => e.type== slug?.slug).toList();
                      return Consumer(builder: (context, ref, _) {
                        AssetRequisitionModel? selected = ref.watch(selectedAssetRequisitionProvider);
                        return CustomSingleDropdown<AssetRequisitionModel>(
                          value: selected,
                          items: assetList.map<DropdownMenuItem<AssetRequisitionModel>>((e) => DropdownMenuItem(value: e, child: Text(e.assetRequestNo))).toList(),
                          onChanged: (value) {
                            ref.read(selectedAssetRequisitionProvider.notifier).state = value;

                            ref.read(selectedAssetCoverProvider.notifier).state = value?.nightCover;
                          },
                          hintText: "Select an asset",
                        );
                      });
                    },
                    error: (error, _) => Container(),
                    loading: () => Container());
              }),

              // Consumer(
              //     builder: (context,ref,_){
              //       AssetRequisitionModel? selected = ref.watch(selectedAssetRequisitionProvider);
              //       if(selected == null){
              //         return Container();
              //       }
              //       return Column(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           assetController.heading("Asset Information"),
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               assetController.heading("Asset No", 9.sp),
              //               assetController.heading(selected.assetNo, 9.sp, Alignment.centerRight),
              //             ],
              //           ),
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               assetController.heading("Night Cover", 9.sp),
              //               assetController.heading(selected.nightCover, 9.sp, Alignment.centerRight),
              //             ],
              //           ),
              //
              //           assetController.heading("Night Cover"),
              //           Consumer(builder: (context, ref, _) {
              //             String lang = ref.watch(languageProvider);
              //             String hint = "Yes";
              //             if (lang != "en") {
              //               hint = "হ্যাঁ";
              //             }
              //             return NormalTextField(
              //               textEditingController: installAssetCoverController,
              //               hintText: hint,
              //               inputType: TextInputType.number,
              //               enable: false,
              //             );
              //           }),
              //         ],
              //       );
              //     }
              // ),

              Consumer(builder: (context, ref, _) {
                AssetRequisitionModel? selected = ref.watch(selectedAssetRequisitionProvider);
                if (selected == null) {
                  return Container();
                }
                installAssetNumberController.text = selected.assetNo;
                installAssetCoverController.text = selected.nightCover;


                installAssetSizeController.text = selected.requiredSize;
                totalCostController.text = selected.cost.toString();
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // assetController.heading("Asset Installation", 14.sp),
                    assetController.heading("Asset No."),
                    Consumer(builder: (context, ref, _) {
                      String lang = ref.watch(languageProvider);
                      String hint = "1234112";
                      if (lang != "en") {
                        hint = "১২৩৪১১২";
                      }
                      return NormalTextField(
                        textEditingController: installAssetNumberController,
                        hintText: hint,
                        inputType: TextInputType.number,
                        enable: false,
                      );
                    }),
                    assetController.heading("Required Size"),
                    Consumer(builder: (context, ref, _) {
                      String lang = ref.watch(languageProvider);
                      String hint = "Yes";
                      if (lang != "en") {
                        hint = "হ্যাঁ";
                      }
                      return NormalTextField(
                        textEditingController: installAssetSizeController,
                        hintText: hint,
                        inputType: TextInputType.number,
                        enable: false,
                      );
                    }),
                    assetController.heading("Night Cover"),
                    Consumer(builder: (context, ref, _) {
                      GeneralIdSlugModel? selected = ref.watch(selectedAssetTypeProvider);
                      if(selected!=null) {
                        if (selected.slug.toLowerCase() == 'cooler'){
                          return Consumer(builder: (context, ref, _) {
                            String? selected = ref.watch(selectedAssetCoverProvider);
                            return CustomSingleDropdown<String>(
                              value: selected,
                              items: ["Yes", "No"].map<DropdownMenuItem<String>>((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                              onChanged: (value) {
                                ref.read(selectedAssetCoverProvider.notifier).state = value;
                              },
                              hintText: "Select one",
                            );
                          });
                        }
                        return
                          Consumer(builder: (context, ref, _) {
                            String lang = ref.watch(languageProvider);
                            String hint = "Yes";
                            if (lang != "en") {
                              hint = "হ্যাঁ";
                            }
                            return NormalTextField(
                              textEditingController: installAssetCoverController,
                              hintText: hint,
                              inputType: TextInputType.number,
                              enable: false,
                            );
                          });
                      }
                      return const SizedBox();
                    }),

                    Consumer(
                      builder: (BuildContext context, WidgetRef ref, Widget? child) {
                        GeneralIdSlugModel? assetType = ref.read(selectedAssetTypeProvider);
                        if (assetType == null || assetType.slug.toLowerCase() == 'light box') {
                          return Column(
                            children: [
                              assetController.heading("Total cost"),
                              Consumer(builder: (context, ref, _) {
                                String lang = ref.watch(languageProvider);
                                String hint = "Input";
                                if (lang != "en") {
                                  hint = "ইনপুট";
                                }
                                return NormalTextField(
                                  textEditingController: totalCostController,
                                  hintText: hint,
                                  inputType: TextInputType.number,
                                  enable: false,
                                );
                              }),
                              assetController.heading("Total light"),
                              Consumer(builder: (context, ref, _) {
                                String lang = ref.watch(languageProvider);
                                String hint = "Input";
                                if (lang != "en") {
                                  hint = "ইনপুট";
                                }
                                return NormalTextField(
                                  textEditingController: totalLightController,
                                  hintText: hint,
                                  inputType: TextInputType.number,
                                );
                              }),
                            ],
                          );
                        }
                        return SizedBox();
                      },
                    ),
                    SizedBox(
                      width: 100.w,
                      child: CustomImagePickerButton(
                        type: CapturedImageType.assetInstallationPhoto,
                        onPressed: () {
                          assetController.getCapturePhoto(CapturedImageType.assetInstallationPhoto);
                        },
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     assetController.heading("Asset No", 9.sp),
                    //     assetController.heading(selected.assetNo, 9.sp, Alignment.centerRight),
                    //   ],
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     assetController.heading("Night Cover", 9.sp),
                    //     assetController.heading(selected.nightCover, 9.sp, Alignment.centerRight),
                    //   ],
                    // )
                  ],
                );
              }),

              SubmitButtonGroup(
                button1Label: "Install",
                button1Color: red3,
                onButton1Pressed: () {
                  AssetRequisitionModel? selectedAsset = ref.read(selectedAssetRequisitionProvider);
                  GeneralIdSlugModel? assetType = ref.read(selectedAssetTypeProvider);
                  String? nightCover;
                  if (assetType != null && assetType.slug.toLowerCase() == 'cooler'){
                    nightCover = ref.watch(selectedAssetCoverProvider);
                  }
                  assetController.submitAssetInstallation(
                    selectedOutlet,
                    selectedAsset,
                    totalLight: totalLightController.text,
                    nightCover: nightCover,
                  );
                },
              ),
              SizedBox(height: 3.h),
            ],
          );
        })
      ],
    );
  }
}
