import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../api/asset_management_api.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/asset_requisition_model.dart';
import '../../../models/general_id_slug_model.dart';
import '../../../models/retailers_mdoel.dart';
import '../../../models/returned_data_model.dart';
import '../../../models/sr_info_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/cameraScreen.dart';
import '../../../services/Image_service.dart';
import '../../../services/sync_read_service.dart';
import '../../../utils/asset_type_utils.dart';

class AssetController {
  BuildContext context;
  WidgetRef ref;
  late Alerts _alerts;

  AssetController({required this.context, required this.ref})
      : _alerts = Alerts(context: context),
        lang = ref.read(languageProvider);
  String lang = "বাংলা";
  String ownerPassportPhotoName = "";
  String ownerLicensePhotoName = "";
  String ownerNIDPhotoName = "";
  String assetInstalletionPhotoName = "";
  String assetPullOutPhotoName = "";

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

  Future<XFile?> getImageGallery(context) async {
    ImagePicker picker = ImagePicker();

    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    return pickedImage;
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
        } else if (type == CapturedImageType.assetInstallationPhoto) {
          assetInstalletionPhotoName = "$name.jpg";
        } else if (type == CapturedImageType.assetPullOutPhoto) {
          assetPullOutPhotoName = "$name.jpg";
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

  // getCapturePhoto(CapturedImageType type)async{
  //   SrInfoModel? sr = await SyncReadService().getSrInfo();
  //   String name = "assetManagement_${sr.ffId}_${DateTime.now().millisecondsSinceEpoch}";
  //   Navigator.of(context).pushNamed(CameraScreen.routeName).then((value) async {
  //     ImageService().compressFile(context: context, file: File(value.toString()), name: name).then((File? compressedImage) async {
  //       if (compressedImage != null) {
  //         ref.read(outletImageProvider(type).notifier).state = compressedImage.path;
  //         print(compressedImage.path);
  //         if(type == CapturedImageType.assetOwnerPassportSizePhoto){
  //           ownerPassportPhotoName = "$name.jpg";
  //         }
  //         else if(type == CapturedImageType.assetLicensePhoto){
  //           ownerLicensePhotoName = "$name.jpg";
  //         }
  //         else if(type == CapturedImageType.assetOwnerNIDPhoto){
  //           ownerNIDPhotoName = "$name.jpg";
  //         }
  //       } else {
  //         // Navigator.pop(context);
  //         _alerts.customDialog(
  //           type: AlertType.error,
  //           message: 'Skipped capturing image',
  //           // description: 'You have to capture retailers image',
  //         );
  //       }
  //     });
  //   });
  // }

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
      // ref.read(assetFieldErrorProvider(RequisitionField.assetType).notifier).state = true;
      // haveAnDataError = true;
      return;
    }
    if (coolerOrLightBoxType == null) {
      // _alerts.customDialog(type: AlertType.warning, description: assetType.slug == "Cooler"? "Please select a cooler type" : "Please select a lightbox type");
      ref.read(assetFieldErrorProvider(RequisitionField.assetType).notifier).state = true;
      haveAnDataError = true;
      // return;
    } else {
      ref.read(assetFieldErrorProvider(RequisitionField.assetType).notifier).state = false;
    }
    if (coolerSize.isEmpty) {
      // _alerts.customDialog(type: AlertType.warning, description: "Please add a cooler size");
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
    if (AssetTypeUtils.toType(assetType.slug) == AssetType.cooler && placement == null) {
      // _alerts.customDialog(type: AlertType.warning, description: "Please select a placement");
      ref.read(assetFieldErrorProvider(RequisitionField.assetPlacement).notifier).state = true;
      haveAnDataError = true;
      // return;
    }else {
      ref.read(assetFieldErrorProvider(RequisitionField.size).notifier).state = false;
    }
    if (AssetTypeUtils.toType(assetType.slug) == AssetType.cooler && assetCover == null) {
      // _alerts.customDialog(type: AlertType.warning, description: "Please select if asset cover needed");
      ref.read(assetFieldErrorProvider(RequisitionField.assetCover).notifier).state = true;
      haveAnDataError = true;
      // return;
    } else {
      ref.read(assetFieldErrorProvider(RequisitionField.assetCover).notifier).state = false;
    }
    // if (assetCover == null) {
    //   _alerts.customDialog(type: AlertType.warning, description: "Please select competitor asset");
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
    if (ownerPassportPhotoName.isEmpty || ownerPhotoPath == null) {
      // _alerts.customDialog(type: AlertType.warning, description: "Please capture owner's photo");
      ref.read(assetFieldErrorProvider(RequisitionField.passportImage).notifier).state = true;
      haveAnDataError = true;
      // return;
    } else {
      ref.read(assetFieldErrorProvider(RequisitionField.passportImage).notifier).state = false;
    }
    if (ownerNIDPhotoName.isEmpty || ownerNIDPhotoPath == null) {
      // _alerts.customDialog(type: AlertType.warning, description: "Please capture owner's NID photo");
      ref.read(assetFieldErrorProvider(RequisitionField.nidImage).notifier).state = true;
      haveAnDataError = true;
      // return;
    } else {
      ref.read(assetFieldErrorProvider(RequisitionField.nidImage).notifier).state = false;
    }

    if (ownerLicensePhotoName.isEmpty || ownerLicensePhotoPath == null) {
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
      "ff_id": sr.ffId,
      "sbu_id": 1,
      // "dep_id": sr.depIds,
      "dep_id": outlet!.depId,
      // "section_id": sr.sectionId,
      "section_id": outlet.sectionId,
      "outlet_id": outlet.id,
      "outlet_code": outlet.outletCode,
      "activity_type": "Asset Requisition",
      "asset_cat_type": assetType.id,
      "cooler_cat_type": coolerOrLightBoxType!.id,
      "required_size": coolerSize,
      "required_qty": 1,
      "competitor_asset": competitorList, //[1,3],
      "placement": AssetTypeUtils.toType(assetType.slug) == AssetType.lightBox?'Outside': placement, //'Inside','Outside'
      "asset_cover": AssetTypeUtils.toType(assetType.slug) == AssetType.lightBox?'No': assetCover, //'Yes','No'
      "total_beverage_sales": int.parse(beverageSale),
      "monthly_present_afbl_sales": int.parse(afblSale),
      "sales_after_cooler_placement": int.parse(approxSale),
      "current_branding": brandingInsideOutside, //'Yes','No'
      "owner_image": ownerPassportPhotoName,
      "nid_image": ownerNIDPhotoName,
      "business_identity_image": ownerLicensePhotoName,
      "name_of_brand": nameOfBrand,
      "date": apiDateFormat.format(DateTime.now()),
      if (AssetTypeUtils.toType(assetType.slug) == AssetType.lightBox) "bill_category": lightBoxBillType
    };
    log(jsonEncode(payload));
    _alerts.floatingLoading();
    await ImageService().sendImage(ownerPhotoPath!, "asset/owner_image/${outlet.outletCode}");
    await ImageService().sendImage(ownerNIDPhotoPath!, "asset/nid_image/${outlet.outletCode}");
    await ImageService().sendImage(ownerLicensePhotoPath!, "asset/business_identity_image/${outlet.outletCode}");
    ReturnedDataModel returnedDataModel = await AssetManagementAPI().submitAssetRequisitionAPI(payload, sr);
    navigatorKey.currentState?.pop();
    if (returnedDataModel.status == ReturnedStatus.success) {
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

  refreshProviderAndData() {
    ref.refresh(outletImageProvider(CapturedImageType.assetLicensePhoto));
    ref.refresh(outletImageProvider(CapturedImageType.assetOwnerNIDPhoto));
    ref.refresh(outletImageProvider(CapturedImageType.assetOwnerPassportSizePhoto));
    ref.refresh(outletImageProvider(CapturedImageType.assetInstallationPhoto));
    ref.refresh(outletImageProvider(CapturedImageType.assetPullOutPhoto));
    ref.refresh(selectedSoRetailerProvider);
    ref.refresh(selectedAssetCoverProvider);
  }

  submitAssetInstallation(
    RetailersModel outlet,
    AssetRequisitionModel? assetRequisitionModel, {
    bool forRo = false,
    int? sectionId,
    String? totalLight, String? nightCover,
  }) async {
    String? assetInstallationPhotoPath = ref.read(outletImageProvider(CapturedImageType.assetInstallationPhoto).notifier).state;

    if (assetRequisitionModel == null) {
      _alerts.customDialog(type: AlertType.warning, description: "Please select an Asset Type");
      return;
    }

    if (assetInstalletionPhotoName.isEmpty || assetInstallationPhotoPath == null) {
      _alerts.customDialog(type: AlertType.warning, description: "Please capture asset photo");
      return;
    }

    if (assetRequisitionModel.type.toUpperCase()=='light box' && totalLight == null) {
      _alerts.customDialog(type: AlertType.warning, description: "Please enter total light");
      return;
    }

    SrInfoModel sr = await SyncReadService().getSrInfo();
    Map payload = {
      "requisition_id": assetRequisitionModel.id,
      "ff_id": sr.ffId,
      "sbu_id": 1,
      // "dep_id": forRo?sr.depIds : sr.depId,
      "dep_id": outlet.depId,
      // "section_id": forRo? sectionId : sr.sectionId,
      "section_id": outlet.sectionId,
      "outlet_id": outlet.id,
      "outlet_code": outlet.outletCode,
      "activity_type": "Asset Installation", //'Asset Requisition','Asset Installation','Asset Pull-out'",
      "asset_no": assetRequisitionModel.assetNo,
      "night_cover": nightCover ?? assetRequisitionModel.nightCover, //'Yes','No'
      "date": apiDateFormat.format(DateTime.now()),
      "installation_image": assetInstalletionPhotoName,
      if(assetRequisitionModel.type.toUpperCase()=='light box') "total_light": int.tryParse(totalLight!),
    };
    _alerts.floatingLoading();

    await ImageService().sendImage(assetInstallationPhotoPath, "asset/asset_install_image/${outlet.outletCode}");

    ReturnedDataModel returnedDataModel = await AssetManagementAPI().submitAssetInstallationAPI(payload, sr);
    navigatorKey.currentState?.pop();
    if (returnedDataModel.status == ReturnedStatus.success) {
      refreshProviderAndData();
      navigatorKey.currentState?.pop();
      String desc = "Asset Installation for ${outlet.outletName} is successfully done.";
      if (lang != "en") {
        desc = "${outlet.outletName} এর জন্য অ্যাসেট ইন্সটলেশন সফল হয়েছে।";
      }
      _alerts.customDialog(type: AlertType.success, description: desc);
    } else {
      _alerts.customDialog(type: AlertType.error, description: returnedDataModel.errorMessage);
    }
  }

  submitAssetPullOut(RetailersModel outlet, String comment, AssetPullOutModel? assetPullOut, {String? pullOutReason}) async {
    String? assetPullOutPhotoPath = ref.read(outletImageProvider(CapturedImageType.assetPullOutPhoto).notifier).state;

    print('-----> $assetPullOutPhotoPath');

    if (assetPullOut == null) {
      _alerts.customDialog(type: AlertType.warning, description: "Please select an Asset Type");
      return;
    }
    if(pullOutReason==null) {
      if (comment.isEmpty) {
        _alerts.customDialog(type: AlertType.warning, description: "Please add a comment");
        return;
      }
    } else {
      comment = pullOutReason;
    }

    if (assetPullOutPhotoName.isEmpty || assetPullOutPhotoPath == null) {
      _alerts.customDialog(type: AlertType.warning, description: "Please capture asset photo");
      return;
    }

    SrInfoModel sr = await SyncReadService().getSrInfo();
    Map payload = {
      "ff_id": sr.ffId,
      "sbu_id": 1,
      // "dep_id": sr.depId,
      "dep_id": outlet.depId,
      // "section_id": sr.depId,
      "section_id": outlet.sectionId,
      "outlet_id": outlet.id,
      "outlet_code": outlet.outletCode,
      "activity_type": "Asset Pull-out", //'Asset Requisition','Asset Installation','Asset Pull-out'",
      "asset_no": assetPullOut.assetNo,
      "remark": comment, //'Yes','No'
      "date": apiDateFormat.format(DateTime.now()),
      "pull_out_image": assetPullOutPhotoName,
      "asset_cat_type": assetPullOut.assetCatType,
      "cooler_cat_type": assetPullOut.coolerCatType,
    };
    _alerts.floatingLoading();

    await ImageService().sendImage(assetPullOutPhotoPath, "asset/asset_pull_out_image/${outlet.outletCode}");

    ReturnedDataModel returnedDataModel = await AssetManagementAPI().submitAssetPullOutAPI(payload, sr);
    navigatorKey.currentState?.pop();
    if (returnedDataModel.status == ReturnedStatus.success) {
      refreshProviderAndData();
      navigatorKey.currentState?.pop();
      String desc = "Asset Pull Out for ${outlet.outletName} is successfully done.";
      if (lang != "en") {
        desc = "${outlet.outletName} এর জন্য অ্যাসেট পুল আউট সফল হয়েছে।";
      }
      _alerts.customDialog(type: AlertType.success, description: desc);
    } else {
      _alerts.customDialog(type: AlertType.error, description: returnedDataModel.errorMessage);
    }
  }

  void reasonError() {
      _alerts.customDialog(type: AlertType.warning, description: "Please select pull out reason");
  }
}
