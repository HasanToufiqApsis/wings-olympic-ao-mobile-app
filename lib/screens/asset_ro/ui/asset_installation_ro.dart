import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
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
import '../../asset_management/controller/asset_controller.dart';

class AssetInstallationUIRO extends ConsumerStatefulWidget {
  const AssetInstallationUIRO({Key? key}) : super(key: key);

  @override
  ConsumerState<AssetInstallationUIRO> createState() => _AssetInstallationUIROState();
}

class _AssetInstallationUIROState extends ConsumerState<AssetInstallationUIRO> {
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
                    },
                  );
                });
              },
              error: (error, _) => Container(),
              loading: () => Container());
        }),
        assetController.heading("Outlet"),
        Consumer(builder: (context, ref, _) {
          AsyncValue<List<RetailersModel>> asyncOutletList = ref.watch(getSoRetailerListProvider);
          return asyncOutletList.when(
              data: (outletList) {
                return Consumer(builder: (context, ref, _) {
                  RetailersModel? selected = ref.watch(selectedSoRetailerProvider);
                  return CustomSingleDropdown<RetailersModel>(
                    value: selected,
                    items: outletList.map<DropdownMenuItem<RetailersModel>>((e) => DropdownMenuItem(value: e, child: Text(e.outletName))).toList(),
                    onChanged: (value) {
                      ref.read(selectedSoRetailerProvider.notifier).state = value;
                    },
                    hintText: "Select an outlet",
                  );
                });
              },
              error: (error, _) => Container(),
              loading: () => Container());
        }),
        Consumer(builder: (context, ref, _) {
          RetailersModel? selectedOutlet = ref.watch(selectedSoRetailerProvider);
          if (selectedOutlet == null) {
            return Center(child: LangText("Please select a retailer"));
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              assetController.heading("Asset Request No"),
              Consumer(builder: (context, ref, _) {
                AsyncValue<List<AssetRequisitionModel>> asyncAssetRequisitionList = ref.watch(getAssetRequisitionListByOutletIdProvider(selectedOutlet.id));

                GeneralIdSlugModel? slug = ref.read(selectedAssetTypeProvider);
                return asyncAssetRequisitionList.when(
                    data: (assetList) {
                      List<AssetRequisitionModel> finalAssetList = [];
                      if (slug != null) {
                        finalAssetList = assetList.where((element) => element.type.toLowerCase() == slug.slug.toLowerCase()).toList();
                        print('asset list::: ${assetList.length} : final list ${finalAssetList.length}');
                      }
                      return Consumer(builder: (context, ref, _) {
                        AssetRequisitionModel? selected = ref.watch(selectedAssetRequisitionProvider);
                        return CustomSingleDropdown<AssetRequisitionModel>(
                          value: selected,
                          items: finalAssetList.map<DropdownMenuItem<AssetRequisitionModel>>((e) => DropdownMenuItem(value: e, child: Text(e.assetRequestNo))).toList(),
                          onChanged: (value) {
                            ref.read(selectedAssetRequisitionProvider.notifier).state = value;
                          },
                          hintText: "Select an asset",
                        );
                      });
                    },
                    error: (error, _) => Container(),
                    loading: () => Container());
              }),
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
                    }),

                    Consumer(
                      builder: (BuildContext context, WidgetRef ref, Widget? child) {
                        GeneralIdSlugModel? assetType = ref.read(selectedAssetTypeProvider);
                        if (assetType == null || assetType.slug.toLowerCase() == 'light box') {
                          return Column(
                            children: [
                              assetController.heading("Approximate cost"),
                              Consumer(builder: (context, ref, _) {
                                String lang = ref.watch(languageProvider);
                                String hint = "Approximate cost";
                                if (lang != "en") {
                                  hint = "আনুমানিক খরচ";
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
                  ],
                );
              }),
              SubmitButtonGroup(
                button1Label: "Install",
                button1Color: red3,
                onButton1Pressed: () {
                  AssetRequisitionModel? selectedAsset = ref.read(selectedAssetRequisitionProvider);
                  assetController.submitAssetInstallation(
                    selectedOutlet,
                    selectedAsset,
                    forRo: true,
                    sectionId: selectedOutlet.sectionId,
                    totalLight: totalLightController.text,
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
