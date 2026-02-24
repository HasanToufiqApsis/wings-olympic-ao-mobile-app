import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../models/general_id_slug_model.dart';
import '../../../models/retailers_mdoel.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/asset/asset_retailer_alphabet_box.dart';
import '../../../reusable_widgets/asset/asset_retailer_dropdown.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/input_fields/custome_image_picker_button.dart';
import '../../../reusable_widgets/input_fields/dropdowns.dart';
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../services/asset_management_service.dart';
import '../../../utils/asset_type_utils.dart';
import '../controller/asset_controller.dart';

class AssetRequisitionUI extends ConsumerStatefulWidget {
  const AssetRequisitionUI({Key? key}) : super(key: key);

  @override
  ConsumerState<AssetRequisitionUI> createState() => _AssetRequisitionUIState();
}

class _AssetRequisitionUIState extends ConsumerState<AssetRequisitionUI> {
  late AssetController assetController;
  TextEditingController coolerSizeController = TextEditingController();
  TextEditingController presentSaleController = TextEditingController();
  TextEditingController totalBeverageSaleController = TextEditingController();
  TextEditingController approxSaleController = TextEditingController();
  TextEditingController nameBrandController = TextEditingController();
  TextEditingController coolerQtyController = TextEditingController(text: "1");
  TextEditingController competitorsNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    assetController = AssetController(context: context, ref: ref);
  }

  @override
  void dispose() {
    super.dispose();
    coolerSizeController.dispose();
    coolerQtyController.dispose();
    presentSaleController.dispose();
    approxSaleController.dispose();
    totalBeverageSaleController.dispose();
    nameBrandController.dispose();
    competitorsNameController.dispose();
  }

  // Widget alphabetBox() {
  //   return Consumer(builder: (context, ref, _) {
  //     List<String> alphabetList = ref.watch(alphabetListProvider);
  //     String? selected = ref.watch(selectedAlphabetProvider);
  //
  //     return Container(
  //       width: 100.w,
  //       padding: EdgeInsets.symmetric(vertical: 0.0.h),
  //
  //       margin: EdgeInsets.symmetric(horizontal: 10.sp),
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(5.sp),
  //           gradient: const LinearGradient(
  //               begin: Alignment.topLeft,
  //               end: Alignment.bottomRight,
  //               stops: [0.5, 1],
  //               colors: [primaryGreen, blue3])),
  //       child: DefaultTextStyle(
  //         style: TextStyle(color: Colors.white, fontSize: normalFontSize),
  //         child: Padding(
  //           padding: EdgeInsets.symmetric(horizontal: 2.w),
  //           child: Wrap(
  //             alignment: WrapAlignment.center,
  //             children: List.generate(
  //               alphabetList.length,
  //                   (index) => FittedBox(
  //                 child: InkWell(
  //                   onTap: () {
  //                     ref.read(assetOutletListProvider.notifier).searchByFirstLetter(alphabetList[index]);
  //                     ref.refresh(selectedSoRetailerProvider);
  //                     },
  //                   child: Padding(
  //                     padding: EdgeInsets.all(2.sp),
  //                     child: Container(
  //                       padding: EdgeInsets.symmetric(
  //                           horizontal: 1.h, vertical: 1.h),
  //                       decoration: (selected == alphabetList[index])
  //                           ? BoxDecoration(
  //                         borderRadius: BorderRadius.circular(5.sp),
  //                         gradient: LinearGradient(
  //                           begin: Alignment.topCenter,
  //                           end: Alignment.bottomCenter,
  //                           colors: [green, darkGreen],
  //                         ),
  //                       )
  //                           : null,
  //                       child: Center(
  //                         child: LangText(
  //                           alphabetList[index].toString(),
  //                           style: const TextStyle(color: Colors.white),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   });
  // }
  //
  // Widget retailerDropdown() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: Container(
  //           margin: EdgeInsets.symmetric(horizontal: 10.sp),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(10.sp),
  //             color: Colors.white,
  //             // border: Border.all(color: grey, width: 1.sp)
  //           ),
  //           child: Consumer(builder: (context, ref, _) {
  //             // OutletModel? dropdownSelected = ref.watch(selectedRetailerProvider);
  //             AsyncValue<List<RetailersModel>> retailerList = ref.watch(assetOutletListProvider);
  //             return retailerList.when(
  //                 data: (data) {
  //                   return Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
  //                     RetailersModel? dropdownSelected = ref.watch(selectedSoRetailerProvider);
  //                     return Padding(
  //                       padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2),
  //                       child: Center(
  //                         child: DropdownButton<RetailersModel>(
  //                           hint: LangText(
  //                             'Select an outlet',
  //                             style: TextStyle(color: Colors.grey, fontSize: 8.sp),
  //                           ),
  //                           iconDisabledColor: Colors.transparent,
  //                           focusColor: Theme.of(context).primaryColor,
  //                           isExpanded: true,
  //                           value: dropdownSelected,
  //                           iconSize: 15.sp,
  //                           items: data.map((item) {
  //                             return DropdownMenuItem<RetailersModel>(
  //                               value: item,
  //                               child: FittedBox(
  //                                 child: Row(
  //                                   children: [
  //                                     // iconList(item.iconData),
  //                                     SizedBox(
  //                                       width: 1.w,
  //                                     ),
  //                                     LangText(
  //                                       item.outletName,
  //                                       overflow: TextOverflow.ellipsis,
  //                                       style: TextStyle(color: Colors.black, fontSize: normalFontSize),
  //                                     ),
  //                                     SizedBox(
  //                                       width: 1.w, // item.totalSale.toStringAsFixed(2)
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             );
  //                           }).toList(),
  //                           style: const TextStyle(color: Colors.black),
  //                           underline: Container(
  //                             height: 0,
  //                             color: Colors.transparent,
  //                           ),
  //                           onChanged: (val) {
  //                             ref.read(selectedSoRetailerProvider.notifier).state = val;
  //                           },
  //                         ),
  //                       ),
  //                     );
  //                   },);
  //                 },
  //                 error: (e, s) => LangText('$e'),
  //                 loading: () => const CircularProgressIndicator());
  //           }),
  //         ),
  //       ),
  //       // IconButton(
  //       //     onPressed: () {},
  //       //     icon: const Icon(
  //       //       Icons.info,
  //       //       color: Colors.grey,
  //       //     ))
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // assetController.heading("Asset Requisition", 13.sp),
        // SizedBox(
        //   height: 3.h,
        // ),
        assetController.heading("Outlet"),
        AssetRetailerAlphaBox(),

        SizedBox(
          height: 10.sp,
        ),
        Consumer(
          builder: (context, ref, _) {
            bool error = ref.watch(assetFieldErrorProvider(RequisitionField.outlet));
            return AssetRetailerDropdown(
              error: error,
            );
          }
        ),
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
                    hintText: "Select a asset type",
                  );
                });
              },
              error: (error, _) => Container(),
              loading: () => Container());
        }),

        Consumer(builder: (context, ref, _) {
          GeneralIdSlugModel? selected = ref.watch(selectedAssetTypeProvider);
          if (selected == null) {
            return Center(
              child: LangText('Please select asset type'),
            );
          }
          return Column(
            children: [
              Consumer(builder: (context, ref, _) {
                GeneralIdSlugModel? selected = ref.watch(selectedAssetTypeProvider);
                bool error = ref.watch(assetFieldErrorProvider(RequisitionField.assetType));
                AssetType assetType = AssetType.cooler;
                if (selected != null) {
                  assetType = AssetTypeUtils.toType(selected.slug);
                }
                return Column(
                  children: [
                    assetController.heading(assetType == AssetType.cooler ? "Cooler Type" : "Lightbox asset type"),
                    Consumer(builder: (context, ref, _) {
                      AsyncValue<List<GeneralIdSlugModel>> asyncAssetCoolerType = assetType == AssetType.cooler ? ref.watch(getCoolerTypeListProvider) : ref.watch(getLightBoxTypeListProvider);
                      return asyncAssetCoolerType.when(
                          data: (coolerType) {
                            return Consumer(builder: (context, ref, _) {
                              GeneralIdSlugModel? selected = ref.watch(selectedCoolerLightBoxTypeProvider);
                              return CustomSingleDropdown<GeneralIdSlugModel>(
                                value: selected,
                                items: coolerType.map<DropdownMenuItem<GeneralIdSlugModel>>((e) => DropdownMenuItem(value: e, child: Text(e.slug))).toList(),
                                onChanged: (value) {
                                  ref.read(selectedCoolerLightBoxTypeProvider.notifier).state = value;
                                },
                                hintText: assetType == AssetType.cooler ? "Select a cooler type" : "Select a lightbox type",
                                error: error,
                              );
                            });
                          },
                          error: (error, _) => Container(),
                          loading: () => Container());
                    }),
                  ],
                );
              }),
              Consumer(builder: (context, ref, _) {
                bool error = ref.watch(assetFieldErrorProvider(RequisitionField.size));
                String lang = ref.watch(languageProvider);
                String hint = "Required Size $error";
                if (lang != "en") {
                  hint = "নির্ধারিত সাইজ";
                }
                return NormalTextField(
                  textEditingController: coolerSizeController,
                  hintText: hint,
                  error: error,
                );
              }),
              // NormalTextField(
              //   textEditingController: coolerSizeController,
              //   hintText: "Required Size",
              //   inputType: TextInputType.number,
              // ),

              Consumer(builder: (context, ref, _) {
                GeneralIdSlugModel? selected = ref.watch(selectedAssetTypeProvider);
                AssetType assetType = AssetType.cooler;
                if (selected != null) {
                  assetType = AssetTypeUtils.toType(selected.slug);
                }
                if (assetType == AssetType.lightBox) {
                  return Column(
                    children: [
                      assetController.heading("Bill Category"),
                      Consumer(builder: (context, ref, _) {
                        AsyncValue<List<String>> asyncAssetCoolerType = ref.watch(getLightBoxBillTypeProvider);
                        return asyncAssetCoolerType.when(
                            data: (coolerType) {
                              return Consumer(builder: (context, ref, _) {
                                String? selected = ref.watch(selectedLightBoxBillTypeProvider);
                                bool error = ref.watch(assetFieldErrorProvider(RequisitionField.lightBoxBillType));
                                return CustomSingleDropdown<String>(
                                  value: selected,
                                  items: coolerType.map<DropdownMenuItem<String>>((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                                  onChanged: (value) {
                                    ref.read(selectedLightBoxBillTypeProvider.notifier).state = value;
                                  },
                                  hintText: "Select lightbox bill category",
                                  error: error,
                                );
                              });
                            },
                            error: (error, _) => Container(),
                            loading: () => Container());
                      }),
                    ],
                  );
                }
                return const SizedBox();
              }),

              Consumer(builder: (context, ref, _) {
                GeneralIdSlugModel? selected = ref.watch(selectedAssetTypeProvider);
                if (selected == null) {
                  return Center(
                    child: LangText('Please select asset type'),
                  );
                }
                if (AssetTypeUtils.toType(selected.slug) != AssetType.lightBox) {
                  return Column(
                    children: [
                      assetController.heading("Placement for Requirement Asset"),
                      Consumer(builder: (context, ref, _) {
                        String? selected = ref.watch(selectedAssetPlacementProvider);
                        bool error = ref.watch(assetFieldErrorProvider(RequisitionField.assetPlacement));
                        return CustomSingleDropdown<String>(
                          value: selected,
                          items: ["Inside", "Outside"].map<DropdownMenuItem<String>>((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (value) {
                            ref.read(selectedAssetPlacementProvider.notifier).state = value;
                          },
                          hintText: "Select place for requirement asset",
                          error: error,
                        );
                      }),
                      assetController.heading("Asset Cover"),
                      Consumer(builder: (context, ref, _) {
                        String? selected = ref.watch(selectedAssetCoverProvider);
                        bool error = ref.watch(assetFieldErrorProvider(RequisitionField.assetCover));
                        return CustomSingleDropdown<String>(
                          value: selected,
                          items: ["Yes", "No"].map<DropdownMenuItem<String>>((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (value) {
                            ref.read(selectedAssetCoverProvider.notifier).state = value;
                          },
                          hintText: "Select one",
                          error: error,
                        );
                      }),
                      assetController.heading("Competitor Asset"),
                      Consumer(builder: (context, ref, _) {
                        AsyncValue<List<GeneralIdSlugModel>> asyncCoolerList = ref.watch(competitorAssetProvider);
                        bool error = ref.watch(assetFieldErrorProvider(RequisitionField.competitor));
                        return asyncCoolerList.when(
                            data: (coolerList) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 2.h, left: 3.w, right: 3.w),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: error? primaryRed : Colors.white),
                                    borderRadius: BorderRadius.circular(verificationRadius),
                                  ),
                                  child: Consumer(builder: (context, ref, _) {
                                    List<GeneralIdSlugModel> selectedCooler = ref.watch(selectedCompetitorAssetProvider);
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Wrap(
                                            spacing: 14,
                                            runSpacing: 12,
                                            children: coolerList.map((e) {
                                              return InkWell(
                                                onTap: () {
                                                  if (assetController.competitorExists(selectedCooler, e)) {
                                                    assetController.removeCompetitor(selectedCooler, e);
                                                  } else {
                                                    assetController.addCompetitor(selectedCooler, e);
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    color: Colors.white
                                                  ),
                                                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        height: 24.0,
                                                        width: 24.0,
                                                        child: IgnorePointer(
                                                          ignoring: true,
                                                          child: Checkbox(
                                                              value: assetController.competitorExists(selectedCooler, e),
                                                              onChanged: (v){

                                                              }
                                                          ),
                                                        ),
                                                      ),
                                                      Text(e.slug, style: TextStyle(fontSize: normalFontSize))
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                  // child: Center(
                                  //   child: Consumer(builder: (context, ref, _) {
                                  //     List<GeneralIdSlugModel> selectedCooler = ref.watch(selectedCompetitorAssetProvider);
                                  //     return ExpansionTile(
                                  //       iconColor: primaryGrey,
                                  //       tilePadding: const EdgeInsets.all(0),
                                  //       title: LangText(
                                  //         "Competitor Asset",
                                  //         style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                                  //       ),
                                  //       children: <Widget>[
                                  //         SizedBox(
                                  //           height: 20.h,
                                  //           child: ListView.builder(
                                  //             shrinkWrap: true,
                                  //             itemCount: coolerList.length,
                                  //             itemBuilder: (BuildContext context, int index) {
                                  //               return CheckboxListTile(
                                  //                 controlAffinity: ListTileControlAffinity.trailing,
                                  //                 title: Text(coolerList[index].slug, style: TextStyle(fontSize: normalFontSize)),
                                  //                 value: assetController.competitorExists(selectedCooler, coolerList[index]),
                                  //                 onChanged: (val) {
                                  //                   if (assetController.competitorExists(selectedCooler, coolerList[index])) {
                                  //                     assetController.removeCompetitor(selectedCooler, coolerList[index]);
                                  //                   } else {
                                  //                     assetController.addCompetitor(selectedCooler, coolerList[index]);
                                  //                   }
                                  //                 },
                                  //               );
                                  //             },
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     );
                                  //   }),
                                  // ),
                                ),
                              );
                            },
                            error: (error, _) => Container(),
                            loading: () => LinearProgressIndicator());
                      }),
                    ],
                  );
                }
                return const SizedBox();
              }),

              // Consumer(builder: (context, ref, _) {
              //   String lang = ref.watch(languageProvider);
              //   String hint = "Pran, Nestle";
              //   if (lang != "en") {
              //     hint = "প্রাণ, নেসলে";
              //   }
              //   return NormalTextField(
              //     textEditingController: competitorsNameController,
              //     hintText: hint,
              //     inputType: TextInputType.text,
              //   );
              // }),
              Consumer(builder: (context, ref, _) {
                String lang = ref.watch(languageProvider);
                bool error = ref.watch(assetFieldErrorProvider(RequisitionField.totalBeverageSale));
                String hint = "Total Beverage Sales (Case/Per Month)";
                if (lang != "en") {
                  hint = "মোট পানীয় বিক্রয় (কেস পার মান্থ)";
                }
                return NormalTextField(
                  textEditingController: totalBeverageSaleController,
                  hintText: hint,
                  inputType: TextInputType.number,
                  error: error,
                );
              }),
              Consumer(builder: (context, ref, _) {
                String lang = ref.watch(languageProvider);
                bool error = ref.watch(assetFieldErrorProvider(RequisitionField.presentSales));
                String hint = "Actual Present Sales of AFBL (Per Month)";
                if (lang != "en") {
                  hint = "AFBL এর প্রকৃত বর্তমান বিক্রয় (কেস পার মান্থ)";
                }
                return NormalTextField(
                  textEditingController: presentSaleController,
                  hintText: hint,
                  inputType: TextInputType.number,
                  error: error,
                );
              }),
              Consumer(builder: (context, ref, _) {
                String lang = ref.watch(languageProvider);
                bool error = ref.watch(assetFieldErrorProvider(RequisitionField.afterSales));
                String hint = "After Asset Placement Approx. Sales of AFBL (Per Month)";
                if (lang != "en") {
                  hint = "অ্যাসেট বসানোর পরে AFBL এর আনুমানিক বিক্রয় (কেস পার মান্থ)";
                }
                return NormalTextField(
                  textEditingController: approxSaleController,
                  hintText: hint,
                  inputType: TextInputType.number,
                  error: error,
                );
              }),

              assetController.heading("Current Branding Inside or Outside"),
              Consumer(builder: (context, ref, _) {
                String? selected = ref.watch(selectedCurrentBrandingProvider);
                bool error = ref.watch(assetFieldErrorProvider(RequisitionField.currentBranding));
                return CustomSingleDropdown<String>(
                  value: selected,
                  items: ["Yes", "No"].map<DropdownMenuItem<String>>((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (value) {
                    ref.read(selectedCurrentBrandingProvider.notifier).state = value;
                  },
                  hintText: "Select one",
                  error: error,
                );
              }),
              Consumer(builder: (context, ref, _) {
                String? selected = ref.watch(selectedCurrentBrandingProvider);
                bool error = ref.watch(assetFieldErrorProvider(RequisitionField.nameOfBrand));
                if (selected == null || selected == "No") {
                  nameBrandController.clear();
                  return Container();
                }
                return NormalTextField(textEditingController: nameBrandController, hintText: "Name of Brand", error: error,);
              }),
              assetController.heading("Owners Passport Size Picture"),
              Consumer(
                builder: (context, ref, _) {
                  bool error = ref.watch(assetFieldErrorProvider(RequisitionField.passportImage));
                  return SizedBox(
                    width: 100.w,
                    child: CustomImagePickerButton(
                      type: CapturedImageType.assetOwnerPassportSizePhoto,
                      onPressed: () {
                        assetController.getCapturePhoto(CapturedImageType.assetOwnerPassportSizePhoto);
                      },
                      error: error,
                    ),
                  );
                }
              ),

              assetController.heading("Valid Trade License/Outlet Deed/Recent Electricity/gas/wasa bill"),
              Consumer(
                builder: (context, ref, _) {
                  bool error = ref.watch(assetFieldErrorProvider(RequisitionField.utilityImage));
                  return SizedBox(
                    width: 100.w,
                    child: CustomImagePickerButton(
                      type: CapturedImageType.assetLicensePhoto,
                      onPressed: () {
                        assetController.getCapturePhoto(CapturedImageType.assetLicensePhoto);
                      },
                      error: error,
                    ),
                  );
                }
              ),
              assetController.heading("NID Photocopy"),
              Consumer(
                builder: (context, ref, _) {
                  bool error = ref.watch(assetFieldErrorProvider(RequisitionField.nidImage));
                  return SizedBox(
                    width: 100.w,
                    child: CustomImagePickerButton(
                      type: CapturedImageType.assetOwnerNIDPhoto,
                      onPressed: () {
                        assetController.getCapturePhoto(CapturedImageType.assetOwnerNIDPhoto);
                      },
                      error: error,
                    ),
                  );
                }
              ),
              SubmitButtonGroup(
                onButton1Pressed: () async {
                  RetailersModel? outlet = ref.read(selectedSoRetailerProvider);
                  List<GeneralIdSlugModel> assetTypeList = await AssetManagementService().getAssetTypeList();
                  // GeneralIdSlugModel? assetType = assetTypeList.first; //
                  GeneralIdSlugModel? assetType = ref.watch(selectedAssetTypeProvider);
                  ref.read(selectedAssetTypeProvider);
                  GeneralIdSlugModel? coolerOrLightBoxType = ref.read(selectedCoolerLightBoxTypeProvider);
                  String? lightBoxBillType = ref.read(selectedLightBoxBillTypeProvider);
                  String? placement = ref.read(selectedAssetPlacementProvider);
                  String? assetCover = ref.read(selectedAssetCoverProvider);
                  List<GeneralIdSlugModel> competitorBrand = ref.read(selectedCompetitorAssetProvider);
                  String? brandingInsideOutside = ref.read(selectedCurrentBrandingProvider);
                  await assetController.submitAssetRequisition(
                    outlet: outlet,
                    assetType: assetType,
                    coolerOrLightBoxType: coolerOrLightBoxType,
                    coolerSize: coolerSizeController.text,
                    placement: placement,
                    assetCover: assetCover,
                    competitorBrand: competitorBrand,
                    beverageSale: totalBeverageSaleController.text,
                    afblSale: presentSaleController.text,
                    approxSale: approxSaleController.text,
                    brandingInsideOutside: brandingInsideOutside,
                    nameOfBrand: nameBrandController.text,
                    lightBoxBillType: lightBoxBillType,
                  );
                },
              ),
            ],
          );
        }),

        SizedBox(height: 3.h),
      ],
    );
  }
}
