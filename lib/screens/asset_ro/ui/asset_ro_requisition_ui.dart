import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../api/links.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../models/general_id_slug_model.dart';
import '../../../models/outlet_model.dart';
import '../../../models/previous_requisition.dart';
import '../../../models/retailers_mdoel.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/asset/asset_retailer_alphabet_box.dart';
import '../../../reusable_widgets/asset/asset_retailer_dropdown.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/input_fields/custome_image_picker_button.dart';
import '../../../reusable_widgets/input_fields/dropdowns.dart';
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../asset_management/ui/asset_installation.dart';
import '../../asset_management/ui/asset_requisition_ui.dart';
import '../controller/asset_ro_controller.dart';
import 'asset_installation_ro.dart';
import 'asset_pull_out_ro_ui.dart';

class AssetRoRequisitionUI extends ConsumerStatefulWidget {
  const AssetRoRequisitionUI({required this.requisition, Key? key}) : super(key: key);

  final PreviousRequisition? requisition;

  static const routeName = "/asset_ro_requisition_ui";

  @override
  ConsumerState<AssetRoRequisitionUI> createState() => _AssetRoRequisitionState();
}

class _AssetRoRequisitionState extends ConsumerState<AssetRoRequisitionUI> {
  late AssetRoController assetRoController;
  TextEditingController coolerSizeController = TextEditingController();
  TextEditingController costTextController = TextEditingController();
  TextEditingController nameBrandController = TextEditingController();
  TextEditingController totalBeverageSaleController = TextEditingController();
  TextEditingController presentSaleController = TextEditingController();
  TextEditingController approxSaleController = TextEditingController();

  @override
  void initState() {
    assetRoController = AssetRoController(context: context, ref: ref);
    super.initState();

    updateInitialData();
  }

  @override
  void dispose() {
    coolerSizeController.dispose();
    costTextController.dispose();
    nameBrandController.dispose();
    totalBeverageSaleController.dispose();
    presentSaleController.dispose();
    approxSaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: "Asset",
          titleImage: "asset.png",
          onLeadingIconPressed: () {
            Navigator.pop(context);
          }),
      body: ListView(
        children: [
          16.sp.verticalSpacing,
          10.sp.verticalSpacing,
          heading("Activity Type"),
          Consumer(builder: (context, ref, _) {
            String? selected = ref.watch(selectedAssetActivityProvider);

            return CustomSingleDropdown<String>(
              value: selected,
              items: ["Requisition", "Installation", "Pull Out"].map<DropdownMenuItem<String>>((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) {
                ref.read(selectedAssetActivityProvider.notifier).state = value;
              },
            );
          }),
          Consumer(builder: (context, ref, _) {
            String? type = ref.watch(selectedAssetActivityProvider);
            switch (type) {
              case "Requisition":
                return Column(
                  children: [
                    heading("Outlet"),

                    if(widget.requisition!=null)
                     IgnorePointer(
                      ignoring: widget.requisition == null ? false : true,
                      child: Consumer(builder: (context, ref, _) {
                        AsyncValue<List<RetailersModel>> asyncOutletList = ref.watch(getSoRetailerListProvider);
                        return asyncOutletList.when(
                            data: (outletList) {
                              return Consumer(builder: (context, ref, _) {
                                bool error = ref.watch(assetFieldErrorProvider(RequisitionField.outlet));
                                RetailersModel? selected = ref.watch(selectedSoRetailerProvider);
                                return CustomSingleDropdown<RetailersModel>(
                                  value: selected,
                                  items: outletList.map<DropdownMenuItem<RetailersModel>>((e) => DropdownMenuItem(value: e, child: Text(e.outletName))).toList(),
                                  onChanged: (value) {
                                    ref.read(selectedSoRetailerProvider.notifier).state = value;
                                  },
                                  hintText: "Select an outlet",
                                  error: error,
                                );
                              });
                            },
                            error: (error, _) => Container(),
                            loading: () => Container());
                      }),
                    ),
                    if(widget.requisition==null)
                      Column(
                        children: [

                          // AssetRetailerAlphaBox(),

                          SizedBox(
                            height: 10.sp,
                          ),
                          AssetRetailerDropdown(),
                        ],
                      ),
                    heading("Asset Type"),
                    IgnorePointer(
                      ignoring: false,
                      child: Consumer(builder: (context, ref, _) {
                        AsyncValue<List<GeneralIdSlugModel>> asyncAssetType = ref.watch(getAssetTypeListProvider);
                        return asyncAssetType.when(
                            data: (assetType) {
                              assetType.removeWhere((element) => element.slug.toLowerCase() != 'light box');
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
                    ),
                    heading("Type"),
                    Consumer(builder: (context, ref, _) {
                      bool error = ref.watch(assetFieldErrorProvider(RequisitionField.assetType));
                      AsyncValue<List<GeneralIdSlugModel>> asyncAssetCoolerType = ref.watch(getLightBoxTypeListProvider);
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
                                hintText: "Select a lightbox type",
                                error: error,
                              );
                            });
                          },
                          error: (error, _) => Container(),
                          loading: () => Container());
                    }),
                    Consumer(builder: (context, ref, _) {
                      bool error = ref.watch(assetFieldErrorProvider(RequisitionField.size));
                      String lang = ref.watch(languageProvider);
                      String hint = "Required Size";
                      if (lang != "en") {
                        hint = "নির্ধারিত সাইজ";
                      }
                      return NormalTextField(
                        textEditingController: coolerSizeController,
                        hintText: hint,
                        error: error,
                      );
                    }),
                    heading("Bill Category"),
                    Consumer(builder: (context, ref, _) {
                      bool error = ref.watch(assetFieldErrorProvider(RequisitionField.lightBoxBillType));
                      AsyncValue<List<String>> asyncAssetCoolerType = ref.watch(getLightBoxBillTypeProvider);
                      return asyncAssetCoolerType.when(
                          data: (coolerType) {
                            return Consumer(builder: (context, ref, _) {
                              String? selected = ref.watch(selectedLightBoxBillTypeProvider);
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
                    heading("Approximate cost*"),
                    Consumer(builder: (context, ref, _) {
                      bool error = ref.watch(assetFieldErrorProvider(RequisitionField.cost));
                      String lang = ref.watch(languageProvider);
                      String hint = "Approximate cost";
                      if (lang != "en") {
                        hint = "আনুমানিক খরচ";
                      }
                      return NormalTextField(
                        textEditingController: costTextController,
                        hintText: hint,
                        inputType: TextInputType.number,
                        error: error,
                      );
                    }),
                    Consumer(builder: (context, ref, _) {
                      bool error = ref.watch(assetFieldErrorProvider(RequisitionField.totalBeverageSale));
                      String lang = ref.watch(languageProvider);
                      String hint = "Total Beverage Sales (Per Month)";
                      if (lang != "en") {
                        hint = "মোট পানীয় বিক্রয় (প্রতি মাসে)";
                      }
                      return NormalTextField(
                        textEditingController: totalBeverageSaleController,
                        hintText: hint,
                        inputType: TextInputType.number,
                        error: error,
                      );
                    }),
                    Consumer(builder: (context, ref, _) {
                      bool error = ref.watch(assetFieldErrorProvider(RequisitionField.presentSales));
                      String lang = ref.watch(languageProvider);
                      String hint = "Actual Present Sales of AFBL (Per Month)";
                      if (lang != "en") {
                        hint = "AFBL এর প্রকৃত বর্তমান বিক্রয় (প্রতি মাসে)";
                      }
                      return NormalTextField(
                        textEditingController: presentSaleController,
                        hintText: hint,
                        inputType: TextInputType.number,
                        error: error,
                      );
                    }),
                    Consumer(builder: (context, ref, _) {
                      bool error = ref.watch(assetFieldErrorProvider(RequisitionField.afterSales));
                      String lang = ref.watch(languageProvider);
                      String hint = "After Asset Placement Approx. Sales of AFBL (Per Month))";
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
                    heading("Current Branding Inside or Outside"),
                    Consumer(builder: (context, ref, _) {
                      bool error = ref.watch(assetFieldErrorProvider(RequisitionField.currentBranding));
                      String? selected = ref.watch(selectedCurrentBrandingProvider);
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
                      bool error = ref.watch(assetFieldErrorProvider(RequisitionField.nameOfBrand));
                      String? selected = ref.watch(selectedCurrentBrandingProvider);
                      if (selected == null || selected == "No") {
                        nameBrandController.clear();
                        return Container();
                      }
                      return NormalTextField(
                        textEditingController: nameBrandController,
                        hintText: "Name of Brand",
                        error: error,
                      );
                    }),

                    heading("Owners Passport Size Picture"),
                    if (widget.requisition == null)
                      Consumer(
                        builder: (context, ref, _) {
                          bool error = ref.watch(assetFieldErrorProvider(RequisitionField.passportImage));
                          return SizedBox(
                            width: 100.w,
                            child: CustomImagePickerButton(
                              type: CapturedImageType.assetOwnerPassportSizePhoto,
                              onPressed: () {
                                assetRoController.getCapturePhoto(CapturedImageType.assetOwnerPassportSizePhoto);
                              },
                              error: error,
                            ),
                          );
                        }
                      ),
                    if (widget.requisition != null)
                      SizedBox(
                        height: 15.h,
                        child: ClipRRect(
                          borderRadius: 10.circularRadius,
                          child: Image.network(
                            '${Links.baseUrl}/app-api/static-file?path=asset/owner_image/${widget.requisition?.assetOutletCode}&filename=${widget.requisition?.assetOwnerImage}',
                            width: 100.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    heading("Valid Trade License/Outlet Deed/Recent Electricity/gas/wasa bill"),
                    if (widget.requisition == null)
                      Consumer(
                          builder: (context, ref, _) {
                          bool error = ref.watch(assetFieldErrorProvider(RequisitionField.utilityImage));
                          return SizedBox(
                            width: 100.w,
                            child: CustomImagePickerButton(
                              type: CapturedImageType.assetLicensePhoto,
                              onPressed: () {
                                assetRoController.getCapturePhoto(CapturedImageType.assetLicensePhoto);
                              },
                              error: error,
                            ),
                          );
                        }
                      ),
                    if (widget.requisition != null)
                      SizedBox(
                        height: 18.h,
                        child: ClipRRect(
                          borderRadius: 10.circularRadius,
                          child: Image.network(
                            '${Links.baseUrl}/app-api/static-file?path=asset/business_identity_image/${widget.requisition?.assetOutletCode}&filename=${widget.requisition?.assetBusinessIdentityImage}',
                            width: 100.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    heading("NID Photocopy"),
                    if (widget.requisition == null)
                      Consumer(
                          builder: (context, ref, _) {
                            bool error = ref.watch(assetFieldErrorProvider(RequisitionField.passportImage));
                          return SizedBox(
                            width: 100.w,
                            child: CustomImagePickerButton(
                              type: CapturedImageType.assetOwnerNIDPhoto,
                              onPressed: () {
                                assetRoController.getCapturePhoto(CapturedImageType.assetOwnerNIDPhoto);
                              },
                              error: error,
                            ),
                          );
                        }
                      ),
                    if (widget.requisition != null)
                      SizedBox(
                        height: 18.h,
                        child: ClipRRect(
                          borderRadius: 10.circularRadius,
                          child: Image.network(
                            '${Links.baseUrl}/app-api/static-file?path=asset/nid_image/${widget.requisition?.assetOutletCode}&filename=${widget.requisition?.assetNidImage}',
                            width: 100.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    2.h.verticalSpacing,
                    SubmitButtonGroup(
                      button1Label: "Accept",
                      button2Label: "Reject",
                      button1Color: red3,
                      button2Color: yellow,
                      twoButtons: widget.requisition == null ? false : true,
                      onButton1Pressed: () async {
                        RetailersModel? outlet = ref.read(selectedSoRetailerProvider);
                        // GeneralIdSlugModel? assetType = assetTypeList.first; //
                        GeneralIdSlugModel? assetType = ref.watch(selectedAssetTypeProvider);
                        ref.read(selectedAssetTypeProvider);
                        GeneralIdSlugModel? coolerOrLightBoxType = ref.read(selectedCoolerLightBoxTypeProvider);
                        String? lightBoxBillType = ref.read(selectedLightBoxBillTypeProvider);
                        String? placement = ref.read(selectedAssetPlacementProvider);
                        String? assetCover = ref.read(selectedAssetCoverProvider);
                        List<GeneralIdSlugModel> competitorBrand = ref.read(selectedCompetitorAssetProvider);
                        String? brandingInsideOutside = ref.read(selectedCurrentBrandingProvider);

                        await assetRoController.submitAssetRequisition(
                          requisitionId: widget.requisition?.assetId,
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
                          cost: costTextController.text,
                          newRequisition: widget.requisition == null ? true : false,
                          previousData: widget.requisition,
                        );
                      },
                      onButton2Pressed: () {
                        assetRoController.rejectAssetRequisition(requisitionId: widget.requisition?.assetId ?? 0);
                      },
                    ),
                    2.h.verticalSpacing,
                  ],
                );
              case "Installation":
                return const AssetInstallationUIRO();
              default:
                return const AssetPullOutROUI();
            }
          }),
        ],
      ),
    );
  }

  Widget heading(String label, [double? fontSize, Alignment? alignment]) {
    return Align(
      alignment: alignment ?? Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
        child: LangText(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize ?? 11.sp),
        ),
      ),
    );
  }

  void updateInitialData() {
    ///for framework building issue addPostFrameCallback call from here->
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      assetRoController.assetTypeInit();
      if (widget.requisition != null) {
        assetRoController.updateInitialData(outlet: widget.requisition!);

        coolerSizeController.text = '${widget.requisition?.assetRequiredSize}';
        nameBrandController.text = '${widget.requisition?.assetNameOfBrand}';
        presentSaleController.text = '${widget.requisition?.assetMonthlyPresentAfblSales}';
        totalBeverageSaleController.text = '${widget.requisition?.assetTotalBeverageSales}';
        approxSaleController.text = '${widget.requisition?.assetSalesAfterCoolerPlacement}';
        // costTextController.text = '${widget.requisition?.assetCost}';
      }
    });
  }
}
