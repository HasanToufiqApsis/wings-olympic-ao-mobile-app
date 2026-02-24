import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/outlet_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../controller/outlet_controller.dart';
import 'new_outlet_registration_ui.dart';

class OutletDetailsUI extends ConsumerStatefulWidget {
  const OutletDetailsUI({Key? key, required this.outlet}) : super(key: key);
  final OutletModel outlet;
  static const routeName = "/outlet_details";
  @override
  ConsumerState<OutletDetailsUI> createState() => _OutletDetailsUIState();
}

class _OutletDetailsUIState extends ConsumerState<OutletDetailsUI> {

  late OutletController outletController;

  @override
  void initState() {
    super.initState();
    outletController = OutletController(context: context, ref: ref);
  }


  @override
  Widget build(BuildContext context) {
    final coverImageUrl = ref.watch(retailerImageProvider(widget.outlet.outlet_cover_image??""));
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Outlet Details",
        titleImage: "outlet.png",
        showLeading: true,
      ),
      body: coverImageUrl.when(
          data: (imageUrl) {
            print("----------????> ${widget.outlet.outletCoverImage?.imageType} :: $imageUrl");
            return ListView(
              children: [
                InkWell(
                  onTap: (){
                    print(widget.outlet.outletCoverImage?.image);
                    outletController.showImage(widget.outlet.outletCoverImage, networkImage: imageUrl);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [

                      // Container(
                      //   height: 20.h,
                      //   width: double.infinity,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(
                      //         verificationRadius), bottomRight: Radius.circular(
                      //         verificationRadius),),
                      //     image: DecorationImage(
                      //       image: widget.outlet.outletCoverImage == null ?
                      //       const AssetImage("assets/placeholder.png")
                      //           :
                      //       widget.outlet.outletCoverImage?.imageType == ImageType.file ?
                      //       FileImage(File(widget.outlet.outletCoverImage?.image ?? "")) :
                      //       NetworkImage(imageUrl ?? "") as ImageProvider,
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 20.h,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(verificationRadius),
                            bottomRight: Radius.circular(verificationRadius),
                          ),
                          child: Image(
                            image: widget.outlet.outletCoverImage == null
                                ? const AssetImage("assets/placeholder.png")
                                : widget.outlet.outletCoverImage?.imageType == ImageType.file
                                ? FileImage(
                              File(widget.outlet.outletCoverImage?.image ?? ""),
                            )
                                : NetworkImage(imageUrl ?? ""),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                      Container(
                        height: 20.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(verificationRadius), bottomRight: Radius.circular(verificationRadius)),
                            gradient: const LinearGradient(colors: [Colors.transparent, Colors.black], begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [.6, 1])),
                      ),
                      Positioned(
                        bottom: 10,
                        child: Column(
                          children: [
                            LangText(
                              widget.outlet.name,
                              style: TextStyle(color: Colors.white, fontSize: mediumFontSize, fontWeight: FontWeight.bold),
                            ),
                            LangText("(${widget.outlet.nameBn})", style: TextStyle(color: Colors.white, fontSize: normalFontSize))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.all(verificationRadius),child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(verificationRadius)
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15.sp),
                    child: Column(
                      children: [
                        // OutletDetailsItemUI(label: "Outlet ID", value: widget.outlet.id.toString(),),
                        OutletDetailsItemUI(label: "Owner Name", value: widget.outlet.owner,),
                        //OutletDetailsItemUI(label: "Cluster", value: widget.outlet.cluster?.slug??"N/A",),
                        OutletDetailsItemUI(label: "Contact No.", value: widget.outlet.contact,),
                       if(widget.outlet.nid!=null && widget.outlet.nid!.isNotEmpty) OutletDetailsItemUI(label: "NID", value: widget.outlet.nid,),
                        OutletDetailsItemUI(label: "Address", value: widget.outlet.address,),
                        OutletDetailsItemUI(label: "Business Type", value: widget.outlet.availableOnboardingInfo?.businessType?.slug??"N/A",),
                        OutletDetailsItemUI(label: "Channel Category", value: widget.outlet.availableOnboardingInfo?.channelCategory?.slug??"N/A",),
                        OutletDetailsItemUI(label: "Status", value: widget.outlet.outletStatus??"N/A",),
                        widget.outlet.availableOnboardingInfo?.coolerStatus == "Yes"?
                        OutletDetailsItemUI(label: "Cooler", value: widget.outlet.availableOnboardingInfo?.cooler?.slug??"N/A",):Container(),
                        widget.outlet.availableOnboardingInfo?.cooler?.slug == "AFBL"?
                        OutletDetailsItemUI(
                          label: "Cooler Photo",
                          onTap: (){
                            outletController.showImage(widget.outlet.availableOnboardingInfo?.coolerPhotoImage);
                          },
                          image: widget.outlet.availableOnboardingInfo?.coolerPhotoImage == null?
                          const AssetImage("assets/placeholder.png")
                              :
                          widget.outlet.availableOnboardingInfo?.coolerPhotoImage?.imageType == ImageType.file?
                          FileImage(File(widget.outlet.availableOnboardingInfo?.coolerPhotoImage?.image??"")):
                          NetworkImage(widget.outlet.availableOnboardingInfo?.coolerPhotoImage?.image??"") as ImageProvider,):Container()

                      ],
                    ),
                  ),
                ),),

                Consumer(
                    builder: (context,ref, _) {
                      AsyncValue<Map> asyncAvailableOnboardingFeature = ref.watch(availableOnboardingFeaturesProvider);

                      return asyncAvailableOnboardingFeature.when(data: (availableOnboardingFeature){
                        bool allButtonAvailable  = false;
                        bool editButtonAvailable = false;
                        bool inactiveButtonAvailable = false;
                        if(availableOnboardingFeature.containsKey("modify_outlet")){
                          if(availableOnboardingFeature["modify_outlet"]==1){
                            if(widget.outlet.outletStatus?.toLowerCase()!='pending'){
                              editButtonAvailable = true;
                            }
                          }
                        }
                        if(availableOnboardingFeature.containsKey("inactive_outlet")){
                          if(availableOnboardingFeature["inactive_outlet"]==1){
                            inactiveButtonAvailable = true;
                          }
                        }

                        allButtonAvailable = editButtonAvailable && inactiveButtonAvailable;

                        if(allButtonAvailable){
                          return SubmitButtonGroup(
                            twoButtons: true,
                            button1Label: "Edit",
                            button1Icon:const Icon(Icons.edit_location_outlined, color: Colors.white,),
                            button2Label: "Inactive",
                            button2Icon:const Icon(Icons.block, color: Colors.white,),
                            layout: ButtonLayout.vertical,
                            onButton1Pressed: (){
                              navigatorKey.currentState?.pushNamed(NewOutletRegistrationUI.routeName, arguments: widget.outlet);
                            },
                            onButton2Pressed: (){
                              outletRemoveButton();
                            },
                          );
                        }else if(editButtonAvailable){
                          return SubmitButtonGroup(
                            button1Label: "Edit",
                            button1Icon: const Icon(Icons.edit_location_outlined, color: Colors.white),
                            onButton1Pressed: (){
                              navigatorKey.currentState?.pushNamed(NewOutletRegistrationUI.routeName, arguments: widget.outlet);
                            },
                          );
                        }else if(inactiveButtonAvailable){
                          return SubmitButtonGroup(
                            button1Label: "Inactive",
                            button1Color: primaryRed,
                            button1Icon:const Icon(Icons.block, color: Colors.white),
                            onButton1Pressed: (){
                              outletRemoveButton();
                            },
                          );
                        }else{
                          return Container();
                        }

                      },  error: (error, _)=>Container(),
                          loading: ()=> const Center(child: CircularProgressIndicator(),));

                    }
                ),

                SizedBox(height: 100.sp,)
              ],
            );
          },
          error: (error, _) {
            return Center(
              child: LangText("Nothing to see"),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          )),
    );
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Outlet Details",
        titleImage: "outlet.png",
        showLeading: true,
      ),
      body: ListView(
        children: [
          InkWell(
            onTap: (){
              print(widget.outlet.outletCoverImage?.image);
              outletController.showImage(widget.outlet.outletCoverImage);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [

                Container(
                  height: 20.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(verificationRadius), bottomRight: Radius.circular(verificationRadius)),
                    image: DecorationImage(
                      image:  widget.outlet.outletCoverImage == null?
                       const AssetImage("assets/placeholder.png")
                      :
                      widget.outlet.outletCoverImage?.imageType == ImageType.file?
                        FileImage(File(widget.outlet.outletCoverImage?.image??"")):
                        NetworkImage(widget.outlet.outletCoverImage?.image??"") as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 20.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(verificationRadius), bottomRight: Radius.circular(verificationRadius)),
                      gradient: const LinearGradient(colors: [Colors.transparent, Colors.black], begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [.6, 1])),
                ),
                Positioned(
                  bottom: 10,
                  child: Column(
                    children: [
                      LangText(
                       widget.outlet.name,
                        style: TextStyle(color: Colors.white, fontSize: mediumFontSize, fontWeight: FontWeight.bold),
                      ),
                      LangText("(${widget.outlet.nameBn})", style: TextStyle(color: Colors.white, fontSize: normalFontSize))
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(verificationRadius),child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(verificationRadius)
            ),
            child: Padding(
              padding: EdgeInsets.all(15.sp),
              child: Column(
                children: [
                  // OutletDetailsItemUI(label: "Outlet ID", value: widget.outlet.id.toString(),),
                  OutletDetailsItemUI(label: "Owner Name", value: widget.outlet.owner,),
                  OutletDetailsItemUI(label: "Contact No.", value: widget.outlet.contact,),
                  OutletDetailsItemUI(label: "NID", value: widget.outlet.nid,),
                  OutletDetailsItemUI(label: "Address", value: widget.outlet.address,),
                  OutletDetailsItemUI(label: "Business Type", value: widget.outlet.availableOnboardingInfo?.businessType?.slug??"N/A",),
                  OutletDetailsItemUI(label: "Channel Category", value: widget.outlet.availableOnboardingInfo?.channelCategory?.slug??"N/A",),
                  OutletDetailsItemUI(label: "Status", value: widget.outlet.outletStatus??"N/A",),
                  widget.outlet.availableOnboardingInfo?.coolerStatus == "Yes"?
                  OutletDetailsItemUI(label: "Cooler", value: widget.outlet.availableOnboardingInfo?.cooler?.slug??"N/A",):Container(),
                  widget.outlet.availableOnboardingInfo?.cooler?.slug == "AFBL"?
                  OutletDetailsItemUI(
                      label: "Cooler Photo",
                      onTap: (){
                        outletController.showImage(widget.outlet.availableOnboardingInfo?.coolerPhotoImage);
                      },
                      image: widget.outlet.availableOnboardingInfo?.coolerPhotoImage == null?
                  const AssetImage("assets/placeholder.png")
                      :
                  widget.outlet.availableOnboardingInfo?.coolerPhotoImage?.imageType == ImageType.file?
                  FileImage(File(widget.outlet.availableOnboardingInfo?.coolerPhotoImage?.image??"")):
                  NetworkImage(widget.outlet.availableOnboardingInfo?.coolerPhotoImage?.image??"") as ImageProvider,):Container()

                ],
              ),
            ),
          ),),

          Consumer(
            builder: (context,ref, _) {
              AsyncValue<Map> asyncAvailableOnboardingFeature = ref.watch(availableOnboardingFeaturesProvider);

              return asyncAvailableOnboardingFeature.when(data: (availableOnboardingFeature){
                bool allButtonAvailable  = false;
                bool editButtonAvailable = false;
                bool inactiveButtonAvailable = false;
                if(availableOnboardingFeature.containsKey("modify_outlet")){
                  if(availableOnboardingFeature["modify_outlet"]==1){
                      if(widget.outlet.outletStatus?.toLowerCase()!='pending'){
                        editButtonAvailable = true;
                      }
                  }
                }
                if(availableOnboardingFeature.containsKey("inactive_outlet")){
                  if(availableOnboardingFeature["inactive_outlet"]==1){
                    inactiveButtonAvailable = true;
                  }
                }

                allButtonAvailable = editButtonAvailable && inactiveButtonAvailable;

                if(allButtonAvailable){
                  return SubmitButtonGroup(
                    twoButtons: true,
                    button1Label: "Edit",
                    button1Icon:const Icon(Icons.edit_location_outlined, color: Colors.white,),
                    button2Label: "Inactive",
                    button2Icon:const Icon(Icons.block, color: Colors.white,),
                    layout: ButtonLayout.vertical,
                    onButton1Pressed: (){
                      navigatorKey.currentState?.pushNamed(NewOutletRegistrationUI.routeName, arguments: widget.outlet);
                    },
                    onButton2Pressed: (){
                      outletRemoveButton();
                    },
                  );
                }else if(editButtonAvailable){
                  return SubmitButtonGroup(
                    button1Label: "Edit",
                    button1Icon: const Icon(Icons.edit_location_outlined, color: Colors.white),
                    onButton1Pressed: (){
                      navigatorKey.currentState?.pushNamed(NewOutletRegistrationUI.routeName, arguments: widget.outlet);
                    },
                  );
                }else if(inactiveButtonAvailable){
                  return SubmitButtonGroup(
                    button1Label: "Inactive",
                    button1Color: primaryRed,
                    button1Icon:const Icon(Icons.block, color: Colors.white),
                    onButton1Pressed: (){
                      outletRemoveButton();
                    },
                  );
                }else{
                  return Container();
                }

              },  error: (error, _)=>Container(),
                  loading: ()=> const Center(child: CircularProgressIndicator(),));

            }
          ),

           SizedBox(height: 100.sp,)
        ],
      ),
    );
  }
  outletRemoveButton(){
    String reason = "";
    Alerts(context: context).customDialog(
        message: "Are you sure that you want to inactive this outlet?",
        twoButtons: true,
        button1: "Save",
        button2: "Cancel",
        onTap1: (){
          navigatorKey.currentState?.pop();
          Alerts(context: context).showModalWithWidget(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20.h,
                      child: TextFormField(
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintText: "Enter the reason",
                          fillColor: primaryGrey,
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.sp),
                              borderSide: const BorderSide(color: Colors.transparent)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.sp),
                              borderSide: const BorderSide(color: Colors.transparent)
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.sp),
                              borderSide: const BorderSide(color: Colors.transparent)
                          ),
                        ),
                        onChanged: (val){
                          reason = val;
                        },
                      ),
                    ),
                    SubmitButtonGroup(
                      twoButtons: true,
                      button1Label: "Submit",
                      button2Label: "Cancel",
                      onButton1Pressed: (){
                        OutletController(context: context, ref:ref).removeOutlet(reason, widget.outlet);

                      },
                      onButton2Pressed: () {
                        navigatorKey.currentState?.pop();
                      },
                    )
                  ],
                ),
              )
          );
        }
    );
  }
}

class OutletDetailsItemUI<T> extends StatelessWidget {
  const OutletDetailsItemUI({Key? key, required this.label, this.value, this.image, this.onTap}) : super(key: key);
  final String label;
  final String? value;
  final ImageProvider? image;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.sp),
      child: Row(
        children: [
          Expanded(child: LangText(label,style: TextStyle(color: primaryBlack, fontSize: smallFontSize, fontWeight: FontWeight.bold),)),
          Expanded(child:image!=null?
                InkWell(
                    onTap: onTap,
                    child: Image(image: image!, height: 100.sp,)
                )
              :
                LangText(value!,style: TextStyle(color: secondaryGrey, fontSize: smallFontSize),))
        ],
      ),
    );
  }
}



