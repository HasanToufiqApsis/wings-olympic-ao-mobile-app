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

class AssetPullOutROUI extends ConsumerStatefulWidget {
  const AssetPullOutROUI({Key? key}) : super(key: key);

  @override
  ConsumerState<AssetPullOutROUI> createState() => _AssetPullInROUIState();
}

class _AssetPullInROUIState extends ConsumerState<AssetPullOutROUI> {
  late AssetController assetController;
  TextEditingController commentController = TextEditingController();
  TextEditingController pullOutAssetNumberController = TextEditingController();
  TextEditingController pullOutAssetCoverController = TextEditingController();
  TextEditingController pullOutAssetSizeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    assetController = AssetController(context: context, ref: ref);
  }

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
    pullOutAssetNumberController.dispose();
    pullOutAssetCoverController.dispose();
    pullOutAssetSizeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // assetController.heading("Pull Out", 13.sp),
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
                      if(selectedOutlet!=null) {
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
          AsyncValue<List<RetailersModel>> asyncOutletList = ref.watch(getSoRetailerListProvider);
          return asyncOutletList.when(
              data: (outletList) {
                return Consumer(builder: (context, ref, _) {
                  // OutletModel? selected = ref.watch(selectedOutletAssetProvider);
                  RetailersModel? selected = ref.watch(selectedSoRetailerProvider);
                  return CustomSingleDropdown<RetailersModel>(
                    value: selected,
                    items: outletList.map<DropdownMenuItem<RetailersModel>>((e) => DropdownMenuItem(value: e, child: Text(e.outletName))).toList(),
                    onChanged: (value) {
                      // ref.read(selectedOutletAssetProvider.notifier).state = value;
                      ref.read(selectedSoRetailerProvider.notifier).state = value;

                      pullOutAssetNumberController.text = '';
                      pullOutAssetCoverController.text = '';
                      pullOutAssetSizeController.text = '';
                      ref.read(selectedAssetPullInProvider.notifier).state = null;
                    },
                    hintText: "Select an outlet",
                  );
                });
              },
              error: (error, _) => Container(),
              loading: () => Container());
        }),
        Consumer(builder: (context, ref, _) {
          // OutletModel? selectedOutlet = ref.watch(selectedOutletAssetProvider);
          RetailersModel? selectedOutlet = ref.watch(selectedSoRetailerProvider);
          if (selectedOutlet == null) {
            return Center(child: LangText("Please select a retailer"));
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              assetController.heading("Installed Asset"),
              Consumer(builder: (context, ref, _) {
                AsyncValue<List<AssetPullOutModel>> asyncAssetRequisitionList = ref.watch(getAssetPullInListByOutletIdProvider(selectedOutlet.outletCode!));

                GeneralIdSlugModel? slug=ref.read(selectedAssetTypeProvider);
                return asyncAssetRequisitionList.when(
                    data: (assetList) {
                      assetList = assetList.where((e) => e.type== slug?.slug).toList();

                      return Consumer(builder: (context, ref, _) {
                        AssetPullOutModel? selected = ref.watch(selectedAssetPullInProvider);
                        return CustomSingleDropdown<AssetPullOutModel>(
                          value: selected,
                          items: assetList.map<DropdownMenuItem<AssetPullOutModel>>((e) => DropdownMenuItem(value: e, child: Text(e.assetNo))).toList(),
                          onChanged: (value) {
                            ref.read(selectedAssetPullInProvider.notifier).state = value;
                          },
                          hintText: "Select an asset",
                        );
                      });
                    },
                    error: (error, _) => Container(),
                    loading: () => Container());
              }),
              Consumer(builder: (context, ref, _) {
                AssetPullOutModel? selected = ref.watch(selectedAssetPullInProvider);
                if (selected == null) {
                  return Container();
                }
                pullOutAssetNumberController.text = selected.assetNo;
                pullOutAssetCoverController.text = selected.nightCover;
                pullOutAssetSizeController.text = selected.requiredSize;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    assetController.heading("Asset Installation", 14.sp),
                    assetController.heading("Asset No."),
                    Consumer(builder: (context, ref, _) {
                      String lang = ref.watch(languageProvider);
                      String hint = "1234112";
                      if (lang != "en") {
                        hint = "১২৩৪১১২";
                      }
                      return NormalTextField(
                        textEditingController: pullOutAssetNumberController,
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
                        textEditingController: pullOutAssetSizeController,
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
                        textEditingController: pullOutAssetCoverController,
                        hintText: hint,
                        inputType: TextInputType.number,
                        enable: false,
                      );
                    }),
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
              Consumer(builder: (context, ref, _) {
                AssetPullOutModel? selected = ref.watch(selectedAssetPullInProvider);
                if (selected == null) {
                  return Container();
                }
                String lang = ref.watch(languageProvider);
                String hint = "Reason";
                if (lang != "en") {
                  hint = "কারণ লিখুন";
                }
                return Column(
                  children: [
                    assetController.heading("Reason"),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InputTextFields(
                            textEditingController: commentController,
                            hintText: hint,
                            inputType: TextInputType.text,
                            maxLine: 5,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
              SizedBox(
                width: 100.w,
                child: CustomImagePickerButton(
                  type: CapturedImageType.assetPullOutPhoto,
                  onPressed: () {
                    assetController.getCapturePhoto(CapturedImageType.assetPullOutPhoto);
                  },
                ),
              ),
              SizedBox(height: 1.5.h),
              SubmitButtonGroup(
                button1Label: "Pull Out",
                button1Color: pullOutButton,
                onButton1Pressed: () {
                  AssetPullOutModel? selectedAsset = ref.watch(selectedAssetPullInProvider);
                  assetController.submitAssetPullOut(selectedOutlet, commentController.text, selectedAsset);
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
