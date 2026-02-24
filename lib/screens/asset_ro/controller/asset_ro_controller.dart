import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/asset_management_api.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/general_id_slug_model.dart';
import '../../../models/previous_requisition.dart';
import '../../../models/retailers_mdoel.dart';
import '../../../models/returned_data_model.dart';
import '../../../models/sr_info_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/scaffold_widgets/cameraScreen.dart';
import '../../../services/Image_service.dart';
import '../../../services/sync_read_service.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/asset_type_utils.dart';

class AssetRoController {
  BuildContext context;
  WidgetRef ref;
  late Alerts _alerts;

  AssetRoController({
    required this.context,
    required this.ref,
  })  : _alerts = Alerts(context: context),
        lang = ref.read(languageProvider);

  String lang = "বাংলা";

  void assetTypeInit() async {
    await Future.delayed(const Duration(milliseconds: 100));
    List<GeneralIdSlugModel>? asyncAssetType = ref.read(getAssetTypeListProvider).value;
    if (asyncAssetType != null && asyncAssetType.isNotEmpty) {
      int index = asyncAssetType.indexWhere((element) => element.slug.toLowerCase() == 'light box');
      if (index != -1) {
        GeneralIdSlugModel selected = asyncAssetType[index];
        ref.read(selectedAssetTypeProvider.notifier).state = selected;
      }
    }
  }

  submitAssetRequisition({
    required RetailersModel? outlet,
    required GeneralIdSlugModel? assetType,
    required GeneralIdSlugModel? coolerOrLightBoxType,
    required String coolerSize,
    required String? placement,
    required String? assetCover,
    required List<GeneralIdSlugModel> competitorBrand,
    required String afblSale,
    required String approxSale,
    required String? brandingInsideOutside,
    required String nameOfBrand,
    required String beverageSale,
    String? lightBoxBillType,
    required String cost,
    required bool newRequisition,
    PreviousRequisition? previousData,
    int? requisitionId,
  }) async {
    bool haveAnDataError = false;
    if (outlet == null) {
      // _alerts.customDialog(type: AlertType.warning, description: "Please select a outlet");
      ref.read(assetFieldErrorProvider(RequisitionField.outlet).notifier).state = true;
      haveAnDataError = true;
      // return;
    } else {
      ref.read(assetFieldErrorProvider(RequisitionField.outlet).notifier).state = false;
    }
    if (assetType == null) {
      _alerts.customDialog(type: AlertType.warning, description: "Please select a asset type");
      return;
    }
    if (coolerOrLightBoxType == null) {
      // _alerts.customDialog(type: AlertType.warning, description: "Please select a cooler type");
      ref.read(assetFieldErrorProvider(RequisitionField.assetType).notifier).state = true;
      haveAnDataError = true;
      // return;
    } else {
      ref.read(assetFieldErrorProvider(RequisitionField.assetType).notifier).state = false;
    }
    if (coolerSize.isEmpty) {
      // _alerts.customDialog(type: AlertType.warning, description: "Please add a asset size");
      ref.read(assetFieldErrorProvider(RequisitionField.size).notifier).state = true;
      haveAnDataError = true;
      // return;
    } else {
      ref.read(assetFieldErrorProvider(RequisitionField.size).notifier).state = false;
    }
    if (AssetTypeUtils.toType(assetType.slug) == AssetType.lightBox) {
      if (lightBoxBillType == null || lightBoxBillType.isEmpty) {
        // _alerts.customDialog(type: AlertType.warning, description: "Please a lightbox bill category");
        ref.read(assetFieldErrorProvider(RequisitionField.lightBoxBillType).notifier).state = true;
        haveAnDataError = true;
        // return;
      }
    } else {
      ref.read(assetFieldErrorProvider(RequisitionField.lightBoxBillType).notifier).state = false;
    }
    if (cost.isEmpty) {
      // _alerts.customDialog(type: AlertType.warning, description: "Please add cost");
      ref.read(assetFieldErrorProvider(RequisitionField.cost).notifier).state = true;
      haveAnDataError = true;
      // return;
    } else {
      ref.read(assetFieldErrorProvider(RequisitionField.cost).notifier).state = true;
    }
    // if (placement == null) {
    //   _alerts.customDialog(type: AlertType.warning, description: "Please select a placement");
    //   return;
    // }
    // if (assetCover == null) {
    //   _alerts.customDialog(type: AlertType.warning, description: "Please select if asset cover needed");
    //   return;
    // }
    if (beverageSale.isEmpty) {
      // _alerts.customDialog(type: AlertType.warning, description: "Please add total beverage sale of the retailer");
      ref.read(assetFieldErrorProvider(RequisitionField.totalBeverageSale).notifier).state = true;
      haveAnDataError = true;
      // return;
    } else {
      ref.read(assetFieldErrorProvider(RequisitionField.totalBeverageSale).notifier).state = false;
    }
    if (afblSale.isEmpty) {
      // _alerts.customDialog(type: AlertType.warning, description: "Please add present sale before the asset");
      ref.read(assetFieldErrorProvider(RequisitionField.presentSales).notifier).state = true;
      haveAnDataError = true;
      // return;
    } else {
      ref.read(assetFieldErrorProvider(RequisitionField.presentSales).notifier).state = false;
    }
    if (approxSale.isEmpty) {
      // _alerts.customDialog(type: AlertType.warning, description: "Please approximate sale after installing the cooler");
      ref.read(assetFieldErrorProvider(RequisitionField.afterSales).notifier).state = true;
      haveAnDataError = true;
      // return;
    } else {
      ref.read(assetFieldErrorProvider(RequisitionField.afterSales).notifier).state = false;
    }
    if (brandingInsideOutside == null) {
      // _alerts.customDialog(type: AlertType.warning, description: "Please select where do you want to install the cooler");
      ref.read(assetFieldErrorProvider(RequisitionField.currentBranding).notifier).state = true;
      haveAnDataError = true;
      // return;
    } else {
      ref.read(assetFieldErrorProvider(RequisitionField.currentBranding).notifier).state = false;
      if (brandingInsideOutside == "Yes") {
        if (nameOfBrand.isEmpty) {
          // _alerts.customDialog(type: AlertType.warning, description: "Please add name of the brand");
          ref.read(assetFieldErrorProvider(RequisitionField.nameOfBrand).notifier).state = true;
          haveAnDataError = true;
          // return;
        }  else {
          ref.read(assetFieldErrorProvider(RequisitionField.nameOfBrand).notifier).state = false;
        }
      }
    }
    String? ownerPhotoPath = ref.read(outletImageProvider(CapturedImageType.assetOwnerPassportSizePhoto).notifier).state;
    String? ownerNIDPhotoPath = ref.read(outletImageProvider(CapturedImageType.assetOwnerNIDPhoto).notifier).state;
    String? ownerLicensePhotoPath = ref.read(outletImageProvider(CapturedImageType.assetLicensePhoto).notifier).state;
    if ((ownerPassportPhotoName.isEmpty || ownerPhotoPath == null) && newRequisition) {
      // _alerts.customDialog(type: AlertType.warning, description: "Please capture owner's photo");
      ref.read(assetFieldErrorProvider(RequisitionField.passportImage).notifier).state = true;
      haveAnDataError = true;
      // return;
    } else {
      ref.read(assetFieldErrorProvider(RequisitionField.passportImage).notifier).state = false;
    }
    if ((ownerNIDPhotoName.isEmpty || ownerNIDPhotoPath == null) && newRequisition) {
      // _alerts.customDialog(type: AlertType.warning, description: "Please capture owner's NID photo");
      ref.read(assetFieldErrorProvider(RequisitionField.nidImage).notifier).state = true;
      haveAnDataError = true;
      // return;
    } else {
      ref.read(assetFieldErrorProvider(RequisitionField.nidImage).notifier).state = false;
    }

    if ((ownerLicensePhotoName.isEmpty || ownerLicensePhotoPath == null) && newRequisition) {
      // _alerts.customDialog(type: AlertType.warning, description: "Please capture owner's Valid Trade License/Outlet Deed/Recent Electricity/gas/wasa bill photo");
      ref.read(assetFieldErrorProvider(RequisitionField.utilityImage).notifier).state = true;
      haveAnDataError = true;
      // return;
    } else {
      ref.read(assetFieldErrorProvider(RequisitionField.utilityImage).notifier).state = false;
    }
    SrInfoModel sr = await SyncReadService().getSrInfo();
    List competitorList = [];
    for (GeneralIdSlugModel competitor in competitorBrand) {
      competitorList.add(competitor.id);
    }
    if(haveAnDataError == true) {
      if (coolerSize.isEmpty) {
        // _alerts.customDialog(type: AlertType.warning, description: "Please add a cooler size");
        ref.read(assetFieldErrorProvider(RequisitionField.size).notifier).state = true;
        haveAnDataError = true;
        // return;
      } else {
        ref.read(assetFieldErrorProvider(RequisitionField.size).notifier).state = false;
      }
      _alerts.customDialog(type: AlertType.warning, description: "You need to insert all data marked by red mark for asset request");
      return;
    }
    Map payload = {
      if (newRequisition == false) "requisition_id": requisitionId,
      "ff_id": sr.ffId,
      "sbu_id": 1,
      "dep_id": sr.depIds,
      "section_id": outlet!.sectionId,
      "outlet_id": outlet.id,
      "outlet_code": outlet.outletCode,
      "activity_type": "Asset Requisition",
      "asset_cat_type": assetType.id,
      "cooler_cat_type": coolerOrLightBoxType!.id,
      "required_size": coolerSize,
      "required_qty": 1,
      "competitor_asset": competitorList, //[1,3],
      "placement": "Outside", //'Inside','Outside'
      "asset_cover": "No", //'Yes','No'
      "total_beverage_sales": int.parse(beverageSale),
      "monthly_present_afbl_sales": int.parse(afblSale),
      "sales_after_cooler_placement": int.parse(approxSale),
      "current_branding": brandingInsideOutside, //'Yes','No'
      "owner_image": newRequisition ? ownerPassportPhotoName : previousData?.assetOwnerImage,
      "nid_image": newRequisition ? ownerNIDPhotoName : previousData?.assetNidImage,
      "business_identity_image": newRequisition ? ownerLicensePhotoName : previousData?.assetBusinessIdentityImage,
      "name_of_brand": nameOfBrand,
      "date": apiDateFormat.format(DateTime.now()),
      if (AssetTypeUtils.toType(assetType.slug) == AssetType.lightBox) "bill_category": lightBoxBillType,
      "cost": cost
    };
    _alerts.floatingLoading();
    if (newRequisition) {
      await ImageService().sendImage(ownerPhotoPath!, "asset/owner_image/${outlet.outletCode}");
      await ImageService().sendImage(ownerNIDPhotoPath!, "asset/nid_image/${outlet.outletCode}");
      await ImageService().sendImage(ownerLicensePhotoPath!, "asset/business_identity_image/${outlet.outletCode}");
    }
    ReturnedDataModel returnedDataModel = newRequisition ? await AssetManagementAPI().acceptCreatedRequisitionAPI(payload, sr) : await AssetManagementAPI().acceptRequisitionAPI(payload, sr);
    navigatorKey.currentState?.pop();
    if (returnedDataModel.status == ReturnedStatus.success) {
      SrInfoModel sr = await SyncReadService().getSrInfo();
      ref.refresh(getRoRequisitionProvider(sr.depIds ?? ''));
      refreshProviderAndData();
      navigatorKey.currentState?.pop();
      String desc = "Asset Requisition for ${outlet.outletName} is successfully done.";
      if (lang != "en") {
        desc = "${outlet.outletName} এর জন্য অ্যাসেট নির্ধারন সফল হয়েছে।";
      }
      _alerts.customDialog(type: AlertType.success, description: desc);
    } else {
      _alerts.customDialog(type: AlertType.error, description: returnedDataModel.errorMessage);
    }
  }

  rejectAssetRequisition({
    required int requisitionId,
  }) async {

    SrInfoModel sr = await SyncReadService().getSrInfo();

    _alerts.floatingLoading();
    ReturnedDataModel returnedDataModel = await AssetManagementAPI().rejectRequisitionRequisitionAPI(sr, requisitionId: requisitionId);
    navigatorKey.currentState?.pop();
    if (returnedDataModel.status == ReturnedStatus.success) {
      SrInfoModel sr = await SyncReadService().getSrInfo();
      ref.refresh(getRoRequisitionProvider(sr.depIds ?? ''));
      refreshProviderAndData();
      navigatorKey.currentState?.pop();
      String desc = "Asset Requisition rejected successfully done.";
      if (lang != "en") {
        desc = "অ্যাসেট নির্ধারন সফল ভাবে বাতিল হয়েছে।";
      }
      _alerts.customDialog(type: AlertType.success, description: desc);
    } else {
      _alerts.customDialog(type: AlertType.error, description: returnedDataModel.errorMessage);
    }
  }

  refreshProviderAndData() {
    ref.refresh(outletImageProvider(CapturedImageType.assetLicensePhoto));
    ref.refresh(outletImageProvider(CapturedImageType.assetOwnerNIDPhoto));
    ref.refresh(outletImageProvider(CapturedImageType.assetOwnerPassportSizePhoto));
    ref.refresh(outletImageProvider(CapturedImageType.assetInstallationPhoto));
  }

  void updateInitialData({required PreviousRequisition outlet}) async {
    await Future.delayed(const Duration(seconds: 1));
    List<RetailersModel>? asyncOutletList = ref.read(getSoRetailerListProvider).value;
    if (asyncOutletList != null && asyncOutletList.isNotEmpty) {
      int index = asyncOutletList.indexWhere((element) => element.id == outlet.assetOutletId);
      if (index != -1) {
        RetailersModel selected = asyncOutletList[index];
        ref.read(selectedSoRetailerProvider.notifier).state = selected;
      }
    }

    List<GeneralIdSlugModel>? asyncAssetCoolerType = ref.read(getLightBoxTypeListProvider).value;
    if (asyncAssetCoolerType != null && asyncAssetCoolerType.isNotEmpty) {
      int index = asyncAssetCoolerType.indexWhere((element) => element.slug.toLowerCase() == outlet.coolerCatType?.toLowerCase());
      if (index != -1) {
        GeneralIdSlugModel selected = asyncAssetCoolerType[index];
        ref.read(selectedCoolerLightBoxTypeProvider.notifier).state = selected;
      }
    }

    List<String>? asyncBillType = ref.watch(getLightBoxBillTypeProvider).value;
    if (asyncBillType != null && asyncBillType.isNotEmpty) {
      for (var val in asyncBillType) {
        print('my index is:: $val ${outlet.billCategory}');
      }
      int index = asyncBillType.indexWhere((element) => element.toLowerCase() == outlet.billCategory?.toLowerCase());

      if (index != -1) {
        String selected = asyncBillType[index];
        ref.read(selectedLightBoxBillTypeProvider.notifier).state = selected;
      }
    }

    List<GeneralIdSlugModel>? competitorAssetList = ref.read(competitorAssetProvider).value;

    for (var val in outlet.competitorAsset ?? []) {
      if (competitorAssetList != null && competitorAssetList.isNotEmpty) {
        int index = competitorAssetList.indexWhere((element) => element.id == val);
        if (index != -1) {
          GeneralIdSlugModel selected = competitorAssetList[index];
          List<GeneralIdSlugModel> selectedCooler = ref.watch(selectedCompetitorAssetProvider);
          addCompetitor(selectedCooler, selected);
        }
      }
    }

    ref.read(selectedAssetPlacementProvider.notifier).state = outlet.assetPlacement;
    ref.read(selectedAssetCoverProvider.notifier).state = outlet.assetAssetCover;
    ref.read(selectedCurrentBrandingProvider.notifier).state = "${outlet.assetCurrentBranding}";
  }

  bool competitorExists(List<GeneralIdSlugModel> coolerList, GeneralIdSlugModel selected) {
    for (GeneralIdSlugModel selectedItem in coolerList) {
      if (selectedItem.id == selected.id) {
        return true;
      }
    }
    return false;
  }

  removeCompetitor(List<GeneralIdSlugModel> coolerList, GeneralIdSlugModel selected) {
    coolerList.remove(selected);
    ref.read(selectedCompetitorAssetProvider.notifier).state = [...coolerList];
  }

  addCompetitor(List<GeneralIdSlugModel> coolerList, GeneralIdSlugModel selected) {
    coolerList.add(selected);
    ref.read(selectedCompetitorAssetProvider.notifier).state = [...coolerList];
  }

  void getCapturePhoto(CapturedImageType type) async {
    SrInfoModel? sr = await SyncReadService().getSrInfo();
    String name = type == CapturedImageType.assetInstallationPhoto
        ? "installation_image_${sr.ffId}_${DateTime.now().millisecondsSinceEpoch}"
        : "assetManagement_${sr.ffId}_${DateTime.now().millisecondsSinceEpoch}";
    if (type == CapturedImageType.assetInstallationPhoto) {
      Navigator.of(context).pushNamed(CameraScreen.routeName).then((value) async {
        imageProcessing(value: value.toString(), name: name, type: type);
      });
    } else {
      ImageService().showImageBottomSheet(
        context: context,
        fromGallery: () async {
          XFile? file = await getImageGallery(context);
          imageProcessing(value: file?.path.toString() ?? '', name: name, type: type);
        },
        fromCamera: () async {
          await Future.delayed(const Duration(microseconds: 100));
          Navigator.of(context).pushNamed(CameraScreen.routeName).then((value) async {
            imageProcessing(value: value.toString(), name: name, type: type);
          });
        },
      );
    }
  }

  String ownerPassportPhotoName = "";
  String ownerLicensePhotoName = "";
  String ownerNIDPhotoName = "";

  void imageProcessing({
    required String value,
    required String name,
    required CapturedImageType type,
  }) {
    ImageService().compressFile(context: context, file: File(value.toString()), name: name).then((File? compressedImage) async {
      if (compressedImage != null) {
        ref.read(outletImageProvider(type).notifier).state = compressedImage.path;
        // print(compressedImage.path);
        if (type == CapturedImageType.assetOwnerPassportSizePhoto) {
          ownerPassportPhotoName = "$name.jpg";
        } else if (type == CapturedImageType.assetLicensePhoto) {
          ownerLicensePhotoName = "$name.jpg";
        } else if (type == CapturedImageType.assetOwnerNIDPhoto) {
          ownerNIDPhotoName = "$name.jpg";
        }
      } else {
        // Navigator.pop(context);
        _alerts.customDialog(
          type: AlertType.error,
          message: 'Skipped capturing image',
          // description: 'You have to capture retailers image',
        );
      }
    });
  }

  Future<XFile?> getImageGallery(context) async {
    ImagePicker picker = ImagePicker();

    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    return pickedImage;
  }
}
