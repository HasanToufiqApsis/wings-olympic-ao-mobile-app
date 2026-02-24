import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/models/cluster_model.dart';

import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/general_id_slug_model.dart';
import '../../../models/outlet_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/input_fields/custome_image_picker_button.dart';
import '../../../reusable_widgets/input_fields/dropdowns.dart';
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../reusable_widgets/scaffold_widgets/body.dart';
import '../controller/outlet_controller.dart';

class NewOutletRegistrationUI extends ConsumerStatefulWidget {
  const NewOutletRegistrationUI({required this.outletModel, Key? key})
    : super(key: key);
  final OutletModel? outletModel;
  static const routeName = "/new_outlet_registration_ui";

  @override
  ConsumerState<NewOutletRegistrationUI> createState() =>
      _NewOutletRegistrationUIState();
}

class _NewOutletRegistrationUIState
    extends ConsumerState<NewOutletRegistrationUI> {
  final TextEditingController _outletNameController = TextEditingController();
  final TextEditingController _outletNameBnController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _nidNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  late OutletController outletController;
  late OutletModel? outletModel;
  List<GeneralIdSlugModel> businessType = [];
  List<GeneralIdSlugModel> channelCats = [];
  List<GeneralIdSlugModel> coolers = [];
  List<ClusterModel> clusters = [];
  @override
  void dispose() {
    super.dispose();
    _outletNameController.dispose();
    _outletNameBnController.dispose();
    _ownerNameController.dispose();
    _contactNameController.dispose();
    _nidNumberController.dispose();
    _addressController.dispose();
  }

  @override
  void initState() {
    outletController = OutletController(context: context, ref: ref);
    outletModel = widget.outletModel;
    if (outletModel != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setValue();
      });
    }
    super.initState();
  }

  setValue() {
    _outletNameController.text = outletModel?.name ?? "";
    _outletNameBnController.text = outletModel?.nameBn ?? "";
    _ownerNameController.text = outletModel?.owner ?? "";
    _contactNameController.text = outletModel?.contact ?? "";
    _nidNumberController.text = outletModel?.nid ?? "";
    _addressController.text = outletModel?.address ?? "";
    if (outletModel != null) {
      if (outletModel!.availableOnboardingInfo != null) {
        if (outletModel!.availableOnboardingInfo!.coolerStatus != null) {
          ref.read(selectedCoolerStatusProvider.state).state =
              outletModel!.availableOnboardingInfo!.coolerStatus;
        }
      }
    }

    if (outletModel != null) {
      if (outletModel?.outletCoverImage != null) {
        ref.read(outletImageProvider(CapturedImageType.newOutlet).state).state =
            outletModel?.outletCoverImage?.image;
      }
    }
  }

  changeChannelCategory() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (outletModel != null) {
        if (outletModel!.availableOnboardingInfo != null) {
          if (outletModel!.availableOnboardingInfo!.channelCategory != null) {
            if (channelCats.isNotEmpty) {
              for (GeneralIdSlugModel val in channelCats) {
                if (val.slug ==
                    outletModel
                        ?.availableOnboardingInfo
                        ?.channelCategory
                        ?.slug) {
                  ref.read(selectedChannelCatsProvider.state).state = val;
                  break;
                }
              }
            }
          }
        }
      }
    });
  }

  changeSelectedCooler() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (outletModel != null) {
        if (outletModel!.availableOnboardingInfo != null) {
          if (outletModel!.availableOnboardingInfo!.cooler != null) {
            if (coolers.isNotEmpty) {
              for (GeneralIdSlugModel val in coolers) {
                if (val.slug ==
                    outletModel?.availableOnboardingInfo?.cooler?.slug) {
                  ref.read(selectedCoolerListProvider.state).state = val;

                  break;
                }
              }
            }
          }
          if (outletModel?.availableOnboardingInfo?.coolerPhotoImage != null) {
            ref
                .read(outletImageProvider(CapturedImageType.coolerImage).state)
                .state = outletModel
                ?.availableOnboardingInfo
                ?.coolerPhotoImage
                ?.image;
          }
        }
      }
    });
  }

  changeBusinessType() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (outletModel != null) {
        if (outletModel!.availableOnboardingInfo != null) {
          if (outletModel!.availableOnboardingInfo!.businessType != null) {
            if (businessType.isNotEmpty) {
              for (GeneralIdSlugModel val in businessType) {
                if (val.slug ==
                    outletModel?.availableOnboardingInfo?.businessType?.slug) {
                  ref.read(selectedBusinessTypeProvider.state).state = val;
                  break;
                }
              }
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.outletModel == null
            ? "New Outlet Registration"
            : "Edit Outlet",
        titleImage: "outlet.png",
        showLeading: true,
        onLeadingIconPressed: () {
          onGoBack();
        },
      ),
      body: CustomBody(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Consumer(
                builder: (context, ref, _) {
                  final asyncClusterList = ref.watch(clusterListProvider);
                  final selectedCluster = ref.watch(selectedClusterProvider);

                  // 👇 Initialize provider if it's null and widget has a cluster
                  if (selectedCluster == null &&
                      widget.outletModel?.cluster != null) {
                    ref.read(selectedClusterProvider.notifier).state =
                        widget.outletModel!.cluster;
                  }

                  return asyncClusterList.when(
                    data: (clusterList) {
                      return CustomSingleDropdown<ClusterModel>(
                        items: clusterList
                            .map(
                              (e) => DropdownMenuItem<ClusterModel>(
                                value: e,
                                child: Text(e.slug ?? ""),
                              ),
                            )
                            .toList(),
                        onChanged: (ClusterModel? val) {
                          ref.read(selectedClusterProvider.notifier).state =
                              val;
                        },
                        value: ref.watch(selectedClusterProvider),
                        hintText: "Select Cluster",
                        labelText: "Market Name*",
                      );
                    },
                    loading: () => const LinearProgressIndicator(),
                    error: (error, _) => const SizedBox(),
                  );
                },
              ),

              CustomImagePickerButton(
                label: "Outlet Photo*",
                type: CapturedImageType.newOutlet,
                onPressed: () {
                  outletController.getImageCapture(
                    type: CapturedImageType.newOutlet,
                  );
                },
              ),
              NormalTextField(
                textEditingController: _outletNameController,
                hintText: "Outlet name",
                label: "Outlet Name*",
              ),
              NormalTextField(
                textEditingController: _outletNameBnController,
                hintText: "আউটলেট এর নাম (বাংলায়)",
                label: "Outlet Name (In Bangla)*",
              ),
              NormalTextField(
                textEditingController: _ownerNameController,
                hintText: "Owner Name",
                label: "Owner Name*",
              ),
              NormalTextField(
                textEditingController: _contactNameController,
                hintText: "Contact Number",
                inputType: TextInputType.number,
                label: "Contact Number*",
              ),
              NormalTextField(
                textEditingController: _nidNumberController,
                hintText: "NID Number",
                inputType: TextInputType.number,
                label: "NID Number",
              ),
              NormalTextField(
                textEditingController: _addressController,
                hintText: "Address",
                label: "Address*",
              ),
              Consumer(
                builder: (context, ref, _) {
                  AsyncValue<List<GeneralIdSlugModel>> asyncBusinessTypeList =
                      ref.watch(businessTypeProvider);
                  return asyncBusinessTypeList.when(
                    data: (businessTypeList) {
                      businessType = businessTypeList;
                      changeBusinessType();
                      return Consumer(
                        builder: (context, ref, _) {
                          GeneralIdSlugModel? businessType = ref.watch(
                            selectedBusinessTypeProvider,
                          );
                          return CustomSingleDropdown<GeneralIdSlugModel>(
                            items: businessTypeList
                                .map<DropdownMenuItem<GeneralIdSlugModel>>(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.slug),
                                  ),
                                )
                                .toList(),
                            onChanged: (GeneralIdSlugModel? val) {
                              ref
                                      .read(selectedBusinessTypeProvider.state)
                                      .state =
                                  val;
                            },
                            hintText: "Select Business Type",
                            value: businessType,
                            labelText: "Business Type*",
                          );
                        },
                      );
                    },
                    error: (error, _) => Container(),
                    loading: () => LinearProgressIndicator(),
                  );
                },
              ),
              Consumer(
                builder: (context, ref, _) {
                  AsyncValue<List<GeneralIdSlugModel>> asyncChannelCatsList =
                      ref.watch(channelCatsProvider);
                  return asyncChannelCatsList.when(
                    data: (channelCatsList) {
                      channelCats = channelCatsList;
                      changeChannelCategory();
                      return Consumer(
                        builder: (context, ref, _) {
                          GeneralIdSlugModel? channelCats = ref.watch(
                            selectedChannelCatsProvider,
                          );
                          return CustomSingleDropdown<GeneralIdSlugModel>(
                            items: channelCatsList
                                .map<DropdownMenuItem<GeneralIdSlugModel>>(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.slug),
                                  ),
                                )
                                .toList(),
                            onChanged: (GeneralIdSlugModel? val) {
                              ref
                                      .read(selectedChannelCatsProvider.state)
                                      .state =
                                  val;
                            },
                            hintText: "Select Channel Category",
                            value: channelCats,
                            labelText: "Channel Category*",
                          );
                        },
                      );
                    },
                    error: (error, _) => Container(),
                    loading: () => LinearProgressIndicator(),
                  );
                },
              ),
              Visibility(
                visible: true,
                child: Consumer(
                  builder: (context, ref, _) {
                    String? status = ref.watch(selectedCoolerStatusProvider);
                    return CustomSingleDropdown<String>(
                      items: ["Yes", "No"]
                          .map<DropdownMenuItem<String>>(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (String? val) {
                        ref.read(selectedCoolerStatusProvider.state).state =
                            val;
                      },
                      labelText: "Cooler Status*",
                      hintText: "Select one",
                      value: status,
                    );
                  },
                ),
              ),
              Visibility(
                visible: true,
                child: Consumer(
                  builder: (context, ref, _) {
                    String? status = ref.watch(selectedCoolerStatusProvider);
                    if (status == "Yes") {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Consumer(
                            builder: (context, ref, _) {
                              AsyncValue<List<GeneralIdSlugModel>>
                              asyncCoolerList = ref.watch(coolersProvider);
                              return asyncCoolerList.when(
                                data: (coolerList) {
                                  coolers = coolerList;
                                  changeSelectedCooler();
                                  return Consumer(
                                    builder: (context, ref, _) {
                                      GeneralIdSlugModel? cooler = ref.watch(
                                        selectedCoolerListProvider,
                                      );
                                      return CustomSingleDropdown<
                                        GeneralIdSlugModel
                                      >(
                                        items: coolerList
                                            .map<
                                              DropdownMenuItem<
                                                GeneralIdSlugModel
                                              >
                                            >(
                                              (e) => DropdownMenuItem(
                                                value: e,
                                                child: Text(e.slug),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (GeneralIdSlugModel? val) {
                                          ref
                                                  .read(
                                                    selectedCoolerListProvider
                                                        .state,
                                                  )
                                                  .state =
                                              val;
                                        },
                                        labelText: "Cooler",
                                        hintText: "Select one",
                                        value: cooler,
                                      );
                                    },
                                  );
                                },
                                error: (error, _) => Container(),
                                loading: () => LinearProgressIndicator(),
                              );
                            },
                          ),
                          Consumer(
                            builder: (context, ref, _) {
                              GeneralIdSlugModel? cooler = ref.watch(
                                selectedCoolerListProvider,
                              );
                              if (cooler != null) {
                                /*if (cooler.slug != "AFBL") {
                                return Container();
                              }*/
                              } else {
                                return Container();
                              }
                              return SizedBox(
                                width: 100.w,
                                child: CustomImagePickerButton(
                                  label: "Cooler Photo*",
                                  type: CapturedImageType.coolerImage,
                                  onPressed: () {
                                    outletController.getImageCapture(
                                      type: CapturedImageType.coolerImage,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              ),

              SubmitButtonGroup(
                twoButtons: true,
                layout: ButtonLayout.vertical,
                onButton1Pressed: () {
                  if (outletModel == null) {
                    outletController.saveNewOutlet(
                      outletName: _outletNameController.text.trim(),
                      outletNameBN: _outletNameBnController.text.trim(),
                      outletOwnerName: _ownerNameController.text.trim(),
                      contactNumber: _contactNameController.text.trim(),
                      nidNumber: _nidNumberController.text.trim(),
                      address: _addressController.text.trim(),
                    );
                  } else {
                    outletController.saveUpdatedOutlet(
                      outletModel: outletModel!,
                      outletName: _outletNameController.text.trim(),
                      outletNameBN: _outletNameBnController.text.trim(),
                      outletOwnerName: _ownerNameController.text.trim(),
                      contactNumber: _contactNameController.text.trim(),
                      nidNumber: _nidNumberController.text.trim(),
                      address: _addressController.text.trim(),
                    );
                  }
                },
                onButton2Pressed: () {
                  onGoBack();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  onGoBack() {
    OutletController(context: context, ref: ref).refreshCameraProviders();
    navigatorKey.currentState?.pop();
  }
}
