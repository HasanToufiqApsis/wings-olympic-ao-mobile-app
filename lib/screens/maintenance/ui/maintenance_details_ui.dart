import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../models/maintanence_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/input_fields/custome_image_picker_button.dart';
import '../../../reusable_widgets/input_fields/dropdowns.dart';
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../controller/maintenance_controller.dart';

class MaintenanceDetailsUI extends ConsumerStatefulWidget {
  const MaintenanceDetailsUI({
    Key? key,
    required this.maintenanceModel,
  }) : super(key: key);
  static const routeName = "/maintenance_details_ui";

  final MaintenanceModel maintenanceModel;

  @override
  ConsumerState<MaintenanceDetailsUI> createState() => _MaintenanceDetailsUIState();
}

class _MaintenanceDetailsUIState extends ConsumerState<MaintenanceDetailsUI> {
  late MaintenanceController maintenanceController;
  TextEditingController maintenanceIdController = TextEditingController();
  TextEditingController assetNumberController = TextEditingController();
  TextEditingController requestDateController = TextEditingController();

  TextEditingController sparePartsDetailsController = TextEditingController();
  TextEditingController totalCostController = TextEditingController();

  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    maintenanceController = MaintenanceController(context: context, ref: ref);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      maintenanceIdController.text = widget.maintenanceModel.maintainanceId.toString();
      assetNumberController.text = widget.maintenanceModel.assetNo.toString();
      requestDateController.text = widget.maintenanceModel.dateTime.toString();
    });
  }

  @override
  void dispose() {
    super.dispose();
    maintenanceIdController.dispose();
    assetNumberController.dispose();
    requestDateController.dispose();
    sparePartsDetailsController.dispose();
    totalCostController.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: "Asset Maintenance",
          titleImage: "maintenance.png",
          onLeadingIconPressed: () {
            Navigator.pop(context);
          }),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 2.h, top: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading("Asset Type"),
            CustomSingleDropdown<String>(
              value: widget.maintenanceModel.assetType,
              items: [widget.maintenanceModel.assetType].map<DropdownMenuItem<String>>((e) => DropdownMenuItem(value: e, child: Text(e ?? ''))).toList(),
              onChanged: (value) {
                // ref.read(selectedSoRetailerProvider.notifier).state = value;
              },
              hintText: "Select an outlet",
            ),
            heading("Outlet"),
            CustomSingleDropdown<String>(
              value: widget.maintenanceModel.outletName,
              items: [widget.maintenanceModel.outletName].map<DropdownMenuItem<String>>((e) => DropdownMenuItem(value: e, child: Text(e ?? ''))).toList(),
              onChanged: (value) {
                // ref.read(selectedSoRetailerProvider.notifier).state = value;
              },
              hintText: "Select an outlet",
            ),

            // heading("Asset Request No"),
            // CustomSingleDropdown<String>(
            //   value: widget.maintenanceModel.id.toString(),
            //   items: [widget.maintenanceModel.id.toString()].map<DropdownMenuItem<String>>((e) => DropdownMenuItem(value: e, child: Text(e??''))).toList(),
            //   onChanged: (value) {
            //   },
            //   hintText: "Select an asset",
            // ),

            heading("Maintenance Id"),
            Consumer(builder: (context, ref, _) {
              String lang = ref.watch(languageProvider);
              String hint = "1234112";
              if (lang != "en") {
                hint = "১২৩৪১১২";
              }
              return NormalTextField(
                textEditingController: maintenanceIdController,
                inputType: TextInputType.number,
                enable: false,
              );
            }),
            heading("Asset No."),
            Consumer(builder: (context, ref, _) {
              String lang = ref.watch(languageProvider);
              String hint = "Yes";
              if (lang != "en") {
                hint = "হ্যাঁ";
              }
              return NormalTextField(
                textEditingController: assetNumberController,
                inputType: TextInputType.number,
                enable: false,
              );
            }),
            heading("Date of Request"),
            Consumer(builder: (context, ref, _) {
              String lang = ref.watch(languageProvider);
              String hint = "Yes";
              if (lang != "en") {
                hint = "হ্যাঁ";
              }
              return NormalTextField(
                textEditingController: requestDateController,
                hintText: hint,
                inputType: TextInputType.number,
                enable: false,
              );
            }),
            heading("Spare Parts Details"),
            Consumer(builder: (context, ref, _) {
              String lang = ref.watch(languageProvider);
              String hint = "Input";
              if (lang != "en") {
                hint = "ইনপুট";
              }
              return NormalTextField(
                textEditingController: sparePartsDetailsController,
                hintText: hint,
                inputType: TextInputType.text,
              );
            }),
            heading("Total Cost"),
            Consumer(builder: (context, ref, _) {
              String lang = ref.watch(languageProvider);
              String hint = "1000";
              if (lang != "en") {
                hint = "১০০০";
              }
              return NormalTextField(
                textEditingController: totalCostController,
                hintText: hint,
                inputType: TextInputType.number,
              );
            }),

            Consumer(builder: (context, ref, _) {

              String lang = ref.watch(languageProvider);
              String hint = "Reason";
              if (lang != "en") {
                hint = "কারণ লিখুন";
              }
              return Column(
                children: [
                  heading("Reason"),
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
                type: CapturedImageType.maintenance,
                onPressed: () {
                  maintenanceController.getCapturePhoto(CapturedImageType.maintenance);
                },
              ),
            ),
            SizedBox(height: 1.5.h),

            SubmitButtonGroup(
              button1Label: "Done",
              button1Color: red3,
              onButton1Pressed: () {
                maintenanceController.installData(
                  maintenance: widget.maintenanceModel,
                  partsDetails: sparePartsDetailsController.text,
                  totalCost: totalCostController.text,
                  reason: commentController.text,
                );
              },
            ),
            SizedBox(height: 3.h),
          ],
        ),
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
}
