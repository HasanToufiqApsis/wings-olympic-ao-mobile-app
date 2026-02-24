import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/models/cluster_model.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../constants/sync_global.dart';
import '../../../main.dart';
import '../../../models/general_id_slug_model.dart';
import '../../../models/image_model.dart';
import '../../../models/outlet_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/cameraScreen.dart';
import '../../../services/Image_service.dart';
import '../../../services/connectivity_service.dart';
import '../../../services/delivery_services.dart';
import '../../../services/geo_location_service.dart';
import '../../../services/helper.dart';
import '../../../services/outlet_services.dart';
import '../../../services/shared_storage_services.dart';
import '../../../services/sync_read_service.dart';
import '../../../services/sync_service.dart';
import '../../delivery/ui/delivery_selection_ui.dart';
import '../../retailer_selection/models/selection_nav.dart';
import '../../retailer_selection/ui/retailer_selection_ui.dart';
import '../../sale/ui/sale_ui.dart';
import '../../sale/ui/sales_ui_v2.dart';
import '../ui/check_outlet_sync_ui.dart';

class OutletController {
  late BuildContext context;
  late WidgetRef ref;
  late Alerts _alerts;
  LocationData? position;

  OutletController({required this.context, required this.ref}) {
    _alerts = Alerts(context: context);
  }

  final OutletServices _outletServices = OutletServices();
  final SyncReadService _syncReadService = SyncReadService();

  String setImageNameByType(CapturedImageType type) {
    String name = "firefly_";
    if (type == CapturedImageType.newOutlet) {
      String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      name += "newOutlet_";
      name += timeStamp;
      name += "_";
    } else if (type == CapturedImageType.coolerImage) {
      String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      name += "cooler_";
      name += timeStamp;
      name += "_";
    }
    return name;
  }

  getImageCapture({required CapturedImageType type, String? phone}) async {
    Navigator.of(context).pushNamed(CameraScreen.routeName).then((value) async {
      ImageService()
          .compressFile(
            context: context,
            file: File(value.toString()),
            name: setImageNameByType(type),
          )
          .then((File? compressedImage) async {
            if (compressedImage != null) {
              ref.read(previewImageProvider.notifier).state = compressedImage;
              _alerts.showModalWithWidget(
                margin: EdgeInsets.symmetric(vertical: 100, horizontal: 16),
                child: Column(
                  children: [
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, _) {
                          File? prevImg = ref.watch(previewImageProvider);
                          if (prevImg == null) {
                            return Center(
                              child: LangText("Please take an image"),
                            );
                          }
                          return Padding(
                            padding: EdgeInsets.all(4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image(
                                image: FileImage(prevImg),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    SubmitButtonGroup(
                      button1Label: "Try Again",
                      button2Label: "Submit",
                      layout: ButtonLayout.horizontal,
                      twoButtons: true,
                      button1Color: primaryRed,
                      button2Color: primary,
                      button1Icon: Icon(Icons.refresh, color: Colors.white),
                      button2Icon: Icon(Icons.check, color: Colors.white),
                      onButton1Pressed: () {
                        navigatorKey.currentState?.pop();
                        getImageCapture(type: type, phone: phone);
                      },
                      onButton2Pressed: () {
                        File? lastImg = ref.read(previewImageProvider);
                        ref.read(outletImageProvider(type).notifier).state =
                            lastImg?.path;
                        navigatorKey.currentState?.pop();
                      },
                    ),
                  ],
                ),
              );
            } else {
              // Navigator.pop(context);
              _alerts.customDialog(
                type: AlertType.error,
                message: 'Skipped capturing image',
                // description: 'You have to capture retailers image',
              );
            }
          });
    });
  }

  showError(String errorText) {
    _alerts.customDialog(type: AlertType.error, message: errorText);
  }

  removeOutlet(String reason, OutletModel outletModel) async {
    _alerts.floatingLoading();
    await OutletServices().inactiveOutlet(
      outletModel: outletModel,
      reason: reason,
    );
    ref.refresh(outletListProvider(false));
    navigatorKey.currentState?.pop();
    navigatorKey.currentState?.pop();
    navigatorKey.currentState?.pop();
  }

  saveNewOutlet({
    required String outletName,
    required String outletNameBN,
    required String outletOwnerName,
    required String contactNumber,
    required String nidNumber,
    required String address,
  }) async {
    String? ownerImage = ref.read(
      outletImageProvider(CapturedImageType.newOutlet),
    );
    ClusterModel? cluster = ref.watch(selectedClusterProvider);

    if (cluster == null) {
      showError("Please select a cluster");
      return;
    }

    if (ownerImage == null) {
      showError("Please capture Outlet image");
      return;
    }
    if (outletName.isEmpty) {
      showError("Please provide outlet name");
      return;
    }
    if (outletNameBN.isEmpty) {
      showError("Please provide outlet name in Bangla");
      return;
    }
    if (outletOwnerName.isEmpty) {
      showError("Please provide owner name");
      return;
    }
    if (contactNumber.isEmpty ||
        contactNumber.length != 11 ||
        contactNumber.substring(0, 2) != "01") {
      showError("Please provide valid contact number");
      return;
    }

    //NID is Optional
    /*if (nidNumber.isEmpty) {
      showError("Please provide a valid NID number");
      return;
    }*/
    if(nidNumber.isNotEmpty){
      if (nidNumber.length != 10 && nidNumber.length != 17) {
        showError("Please provide a valid NID number");
        return;
      }
      if (await OutletServices().checkExistingNID(nidNumber)) {
        showError("NID already exists");
        return;
      }
    }


    if (address.isEmpty) {
      showError("Please provide an address");
      return;
    }
    GeneralIdSlugModel? businessType = ref.watch(selectedBusinessTypeProvider);
    if (businessType == null) {
      showError("Please select an business type");
      return;
    }
    GeneralIdSlugModel? channelCats = ref.watch(selectedChannelCatsProvider);
    if (channelCats == null) {
      showError("Please select an channel category");
      return;
    }
    String? coolerStatus = ref.watch(selectedCoolerStatusProvider);
    if (coolerStatus == null) {
      showError("Please select an cooler status");
      return;
    }
    GeneralIdSlugModel? cooler = ref.watch(selectedCoolerListProvider);
    if (coolerStatus == "Yes" && cooler == null) {
      showError("Please select an cooler");
      return;
    }
    String? coolerImage;
    if (cooler != null) {
      coolerImage = ref.read(
        outletImageProvider(CapturedImageType.coolerImage),
      );
      if (coolerStatus == "Yes" && coolerImage == null) {
        showError("Please capture cooler image");
        return;
      }
    }
    if (!await LocationService(context).isLocationEnabled()) {
      showError("Please enable device location service");
      return;
    }

    _alerts.floatingLoading();

    LocationData? position = await LocationService(context).determinePosition();
    await OutletServices().addNewOutlet(
      clusterModel: cluster,
      outletName: outletName,
      outletNameBn: outletNameBN,
      ownerName: outletOwnerName,
      contactNumber: contactNumber,
      nidNumber: nidNumber,
      address: address,
      coolerStatus: coolerStatus,
      businessType: businessType,
      channelCategory: channelCats,
      cooler: cooler,
      position: position,
      coolerPhotoPath: coolerImage,
      outletCoverPhotoPath: ownerImage,
    );
    ref.refresh(outletListProvider(false));
    // refresh providers
    refreshCameraProviders();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  refreshCameraProviders() {
    ref.refresh(outletImageProvider(CapturedImageType.newOutlet));
    ref.refresh(outletImageProvider(CapturedImageType.coolerImage));
    // ref.refresh(outletImageTypeChangeProvider(outletImageType));
    // ref.refresh(outletImageTypeChangeProvider(coolerImageType));
  }

  void saveUpdatedOutlet({
    required OutletModel outletModel,
    required String outletName,
    required String outletNameBN,
    required String outletOwnerName,
    required String contactNumber,
    required String nidNumber,
    required String address,
  }) async {
    String? ownerImage = ref.read(
      outletImageProvider(CapturedImageType.newOutlet),
    );
    ClusterModel ? cluster = ref.watch(selectedClusterProvider);
    if (cluster == null) {
      showError("Please select a cluster");
      return;
    }
    if (ownerImage == null) {
      showError("Please capture Outlet image';");
      return;
    }

    print("inside update page");
    if (outletName.isEmpty) {
      showError("Please provide outlet name");
      return;
    }
    if (outletNameBN.isEmpty) {
      showError("Please provide outlet name in Bangla");
      return;
    }
    if (outletOwnerName.isEmpty) {
      showError("Please provide outlet name");
      return;
    }

    ///NID is optional
    /*if (nidNumber.isEmpty) {
      showError("Please provide a valid NID number");
      return;
    }*/
    if(nidNumber.isNotEmpty){
      if (nidNumber.length != 10 && nidNumber.length != 17) {
        showError("Please provide a valid NID number");
        return;
      }
      if (await OutletServices().checkExistingNID(
        nidNumber,
        outletModel.outletCode,
      )) {
        showError("NID already exists");
        return;
      }
    }


    if (address.isEmpty) {
      showError("Please provide an address");
      return;
    }
    GeneralIdSlugModel? businessType = ref.watch(selectedBusinessTypeProvider);
    if (businessType == null) {
      showError("Please select an business type");
      return;
    }
    GeneralIdSlugModel? channelCats = ref.watch(selectedChannelCatsProvider);
    if (channelCats == null) {
      showError("Please select an channel category");
      return;
    }

    String? coolerStatus = ref.watch(selectedCoolerStatusProvider);
    if (coolerStatus == null) {
      showError("Please select an cooler status");
      return;
    }
    GeneralIdSlugModel? cooler = ref.watch(selectedCoolerListProvider);
    if (coolerStatus == "Yes" && cooler == null) {
      showError("Please select an cooler");
      return;
    }
    String? coolerImage;
    if (cooler != null) {
      coolerImage = ref.read(
        outletImageProvider(CapturedImageType.coolerImage),
      );
      if (coolerStatus == "Yes" && coolerImage == null) {
        showError("Please capture cooler image");
        return;
      }
    }

    if (!await LocationService(context).isLocationEnabled()) {
      showError("Please enable device location service");
      return;
    }

    // todo save outlets or send through api code here
    OutletModel updatedOutlet = OutletModel.fromJson(outletModel.toJson());
    LocationData? position = await LocationService(context).determinePosition();
    updatedOutlet.availableOnboardingInfo = AvailableOnboardingInfoModel(
      coolerStatus: coolerStatus,
      businessType: businessType,
      channelCategory: channelCats,
      cooler: cooler,
      coolerPhotoImage: coolerImage != null
          ? Helper.checkIfUrl(coolerImage)
                ? ImageModel(image: coolerImage, imageType: ImageType.network)
                : ImageModel(image: coolerImage, imageType: ImageType.file)
          : null,
    );
    updatedOutlet.nameBn = outletNameBN;
    updatedOutlet.name = outletName;
    updatedOutlet.owner = outletOwnerName;
    updatedOutlet.address = address;
    updatedOutlet.nid = nidNumber;
    updatedOutlet.contact = contactNumber;
    updatedOutlet.outletCoverImage = Helper.checkIfUrl(ownerImage)
        ? ImageModel(image: ownerImage, imageType: ImageType.network)
        : ImageModel(image: ownerImage, imageType: ImageType.file);
    updatedOutlet.synced = false;
    updatedOutlet.outletLocation.latitude = position?.latitude ?? 0.0;
    updatedOutlet.outletLocation.longitude = position?.longitude ?? 0.0;
    updatedOutlet.cluster= cluster;
    updatedOutlet.clusterId=cluster.id;

    _alerts.floatingLoading();
    if (outletModel.id == null) {
      await OutletServices().updateNewOutlet(
        outletModel.outletCode!,
        updatedOutlet,
      );
    } else {
      await OutletServices().updateExistingOutlet(updatedOutlet);
    }
    // refresh providers
    ref.refresh(outletListProvider(false));
    refreshCameraProviders();
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  handlePreorderRedirection() async {
    try {
      _alerts.floatingLoading(message: "Checking Outlet Sync Status");
      bool synced = await _outletServices.checkIfAllOutletSynced();
      navigatorKey.currentState?.pop();
      if (synced) {
        // navigatorKey.currentState?.pushNamed(SaleUI.routeName);
        // navigatorKey.currentState?.pushNamed(SalesUIv2.routeName);
        navigatorKey.currentState?.pushNamed(
          RetailerSelectionUi.routeName,
          arguments: {"nav_type": SelectionNav.forward},
        );
      } else {
        navigatorKey.currentState?.pushNamed(CheckOutletSyncUI.routeName);
      }
    } catch (e) {
      Helper.dPrint(
        "inside handlePreorderRedirection OutletController catch block $e",
      );
    }
  }

  handleOutletSyncAndRedirectToPreorder(bool sync) async {
    if (sync) {
      _alerts.floatingLoading(message: "Checking internet...");
      bool hasInternet = await ConnectivityService().checkInternet();
      navigatorKey.currentState?.pop();
      if (hasInternet) {
        _alerts.floatingLoading(message: "Syncing outlet list!");
        await _outletServices.syncOutletInfo(true);
        await _outletServices.updateRetailerListFromApi();
        ref.refresh(outletListProviderWithoutDropdown);
        ref.refresh(dashBoardSaleTypeProvider);
        navigatorKey.currentState?.pop();
      } else {
        _alerts.customDialog(
          message: "আপনার কোন ইন্টারনেট সংযোগ নেই। আউটলেট তালিকা সিঙ্ক করার জন্য আপনার ইন্টারনেট সংযোগ প্রয়োজন",
        );
      }
    }
    navigatorKey.currentState?.pushReplacementNamed(
      RetailerSelectionUi.routeName,
      arguments: {"nav_type": SelectionNav.forward},
    );
  }

  handleOutletSyncAndRedirectToDelivery(
    bool sync, {
    bool navigateDeliveryScreen = true,
  }) async {
    if (sync) {
      _alerts.floatingLoading(message: "Syncing outlet list!");
      bool hasInternet = await ConnectivityService().checkInternet();
      navigatorKey.currentState?.pop();
      if (hasInternet) {
        _alerts.floatingLoading(message: "Syncing outlet list!");
        // _alerts.floatingLoading(message: "আউটলেট তালিকা সিঙ্ক করা হচ্ছে!");
        await DeliveryServices().updateRetailerListFromApi();
        final retailer = ref.watch(selectedRetailerProvider);
        if (retailer != null) {
          ref.refresh(saleDashboardMenuProvider(retailer));
        }

        navigatorKey.currentState?.pop();
      } else {
        _alerts.customDialog(
          message:
              "আপনার কোন ইন্টারনেট সংযোগ নেই। আউটলেট তালিকা সিঙ্ক করার জন্য আপনার ইন্টারনেট সংযোগ প্রয়োজন",
        );
      }
    }
    ref.refresh(deliveryOutletListProvider);
    if (navigateDeliveryScreen) {
      navigatorKey.currentState?.popAndPushNamed(DeliverySelectionUI.routeName);
    }
  }

  void showImage(ImageModel? outletCoverImage, {String networkImage = ""}) {
    if (outletCoverImage != null) {
      if (outletCoverImage.image.isNotEmpty) {
        _alerts.showModalWithWidget(
          dismissible: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // outletCoverImage.imageType == ImageType.file
              //     ? Image.file(File(outletCoverImage.image ?? ""))
              //     : Image.network(networkImage),
              // Container(
              //   height: 50.h,
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.only(
              //       topLeft: Radius.circular(verificationRadius),
              //       topRight: Radius.circular(verificationRadius),
              //     ),
              //     image: DecorationImage(
              //       image: outletCoverImage.imageType == ImageType.file ?
              //       FileImage(File(outletCoverImage.image ?? "")) :
              //       NetworkImage(networkImage ?? "") as ImageProvider,
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 50.h,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(verificationRadius),
                    topRight: Radius.circular(verificationRadius),
                  ),
                  child: Image(
                    image: outletCoverImage.imageType == ImageType.file
                        ? FileImage(File(outletCoverImage.image ?? ""))
                        : NetworkImage(networkImage ?? ""),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              SubmitButtonGroup(
                button1Color: primaryRed,
                button1Label: "Cancel",
                onButton1Pressed: () {
                  navigatorKey.currentState?.pop();
                },
              ),
            ],
          ),
        );
      }
    }
  }

  setDifferentImageURL(OutletModel outletModel) async {
    try {
      /// outlet cover image fix
      int? outlet = await LocalStorageHelper.readInt(
        "${outletModel.outletCode}_cover",
      );
      ImageModel? outletCover = outletModel.outletCoverImage;

      if (outletCover != null) {
        if (outletCover.imageType == ImageType.network) {
          if (outlet == null) {
            await LocalStorageHelper.saveInt(
              "${outletModel.outletCode}_cover",
              1,
            );
            outletModel.outletCoverImage?.image += "1";
          } else {
            await LocalStorageHelper.saveInt(
              "${outletModel.outletCode}_cover",
              outlet + 1,
            );
            outletModel.outletCoverImage?.image += "${outlet + 1}";
          }
        }
      }

      /// cooler image url fix
      int? cooler = await LocalStorageHelper.readInt(
        "${outletModel.outletCode}_cooler",
      );
      ImageModel? outletCooler =
          outletModel.availableOnboardingInfo?.coolerPhotoImage;
      if (outletCooler != null) {
        if (outletCooler.imageType == ImageType.network) {
          if (cooler == null) {
            await LocalStorageHelper.saveInt(
              "${outletModel.outletCode}_cooler",
              1,
            );
            outletModel.availableOnboardingInfo?.coolerPhotoImage?.image += "1";
          } else {
            await LocalStorageHelper.saveInt(
              "${outletModel.outletCode}_cooler",
              cooler + 1,
            );
            outletModel.availableOnboardingInfo?.coolerPhotoImage?.image +=
                "${cooler + 1}";
          }
        }
      }
      print(outletModel.outletCoverImage?.image);
      print(outletModel.availableOnboardingInfo?.coolerPhotoImage?.image);
    } catch (e, s) {
      print(s);
    }
  }

  void pushData() {
    try {
      SyncService().readSync();
      syncObj['promotions']['200'] = onePromotion;
      syncObj['promotions']['201'] = twoPromotion;
      syncObj['promotions']['202'] = threePromotion;
      syncObj['retailers'][0]['available_promotions'].add({
        "id": 200,
        "discount_val": 30,
        "cap_val": null,
      });
      syncObj['retailers'][0]['available_promotions'].add({
        "id": 201,
        "discount_val": 30,
        "cap_val": null,
      });
      syncObj['retailers'][0]['available_promotions'].add({
        "id": 202,
        "discount_val": 70,
        "cap_val": null,
      });

      log('sync is ------> ${jsonEncode(syncObj)}');

      String txt = jsonEncode(syncObj);
      SyncService().writeSync(txt);
    } catch (e, t) {
      print('error is:: ${e.toString()}\n${t.toString()}');
    }
  }

  Map<String, dynamic> onePromotion = {
    "slab_group_id": 500,
    "id": 1,
    "label":
        "Buy minimum 3 case with Mojo \u0026 Clemon, get 30 TK discount on entire memo",
    "payable_type": "Cash Discount",
    "discount_type": "Multi Buy",
    "cap_value": 0,
    "discount_amount": 30,
    "is_dependency": 1,
    "entire_memo": 0,
    "restriction": 1,
    "total_applicable_quantity": 3,
    "discount_product_type": "case",
    "rules": [
      {"sku_id": "5", "applied_unit": 48},
      {"sku_id": "%", "applied_unit": 24},
    ],
    "skus": [
      {"sku_id": 5, "applied_unit": 24},
      {"sku_id": 6, "applied_unit": 24},
    ],
    "discount_on": [
      {"sku_id": 5, "discount_val": 8, "applied_unit": 0},
    ],
  };
  Map<String, dynamic> twoPromotion = {
    "slab_group_id": 501,
    "id": 1,
    "label":
        "Buy minimum 3 case from minimum 2 SKU, get 30 TK discount on entire memo",
    "payable_type": "Cash Discount",
    "discount_type": "Multi Buy",
    "cap_value": 0,
    "discount_amount": 30,
    "is_dependency": 1,
    "entire_memo": 0,
    "restriction": 1,
    "total_applicable_quantity": 3,
    "discount_product_type": "case",
    "rules": [
      {"sku_id": "%", "applied_unit": 24, "case": 1},
      {"sku_id": "%", "applied_unit": 24, "case": 1},
    ],
    "skus": [
      {"sku_id": 5, "applied_unit": 24},
      {"sku_id": 23, "applied_unit": 24},
      {"sku_id": 1, "applied_unit": 24},
      {"sku_id": 4, "applied_unit": 24},
    ],
    "discount_on": [
      {"sku_id": 5, "discount_val": 30, "applied_unit": 0},
    ],
  };
  Map<String, dynamic> threePromotion = {
    "slab_group_id": 501,
    "id": 1,
    "label":
        "Buy minimum 5 case from minimum 3 SKU, get 70 TK discount on entire memo",
    "payable_type": "Cash Discount",
    "discount_type": "Multi Buy",
    "cap_value": 0,
    "discount_amount": 70,
    "is_dependency": 1,
    "entire_memo": 0,
    "restriction": 1,
    "total_applicable_quantity": 5,
    "discount_product_type": "case",
    "rules": [
      {"sku_id": "%", "applied_unit": 24, "case": 1},
      {"sku_id": "%", "applied_unit": 24, "case": 1},
    ],
    "skus": [
      {"sku_id": 5, "applied_unit": 24},
      {"sku_id": 23, "applied_unit": 24},
      {"sku_id": 1, "applied_unit": 24},
      {"sku_id": 4, "applied_unit": 24},
    ],
    "discount_on": [
      {"sku_id": 5, "discount_val": 30, "applied_unit": 0},
    ],
  };

  void showWelcomeMessage() async {
    bool alreadyWelcomed = await _syncReadService.checkAlreadyWelcomed();
    if (!alreadyWelcomed) {
      await _syncReadService.updateWelcomeStatus();
      _alerts.goodMorningDialogue();
    }
  }

  Future<void> handleForceOutletSyncAndRedirectToDelivery() async {
    _alerts.floatingLoading(message: "আউটলেট তালিকা সিঙ্ক করা হচ্ছে !");
    bool hasInternet = await ConnectivityService().checkInternet();
    if (hasInternet) {
      await DeliveryServices().updateRetailerListFromApi();
      ref.refresh(selectedRetailerProvider);
      ref.refresh(outletSaleStatusProvider);
      ref.refresh(deliveryOutletListProvider);
      navigatorKey.currentState?.pop();
    } else {
      navigatorKey.currentState?.pop();
      _alerts.customDialog(
        message:
            "আপনার কোন ইন্টারনেট সংযোগ নেই। আউটলেট তালিকা সিঙ্ক করার জন্য আপনার ইন্টারনেট সংযোগ প্রয়োজন",
        onTap1: () {
          navigatorKey.currentState?.pop();
          navigatorKey.currentState?.pop();
        },
      );
    }
  }
}
