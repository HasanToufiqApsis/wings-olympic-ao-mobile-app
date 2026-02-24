import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/bill/bill_data_model.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../controller/bill_controller.dart';

class BillInfoUI extends ConsumerStatefulWidget {
  const BillInfoUI({
    Key? key,
    required this.billDetails,
  }) : super(key: key);
  static const routeName = "/bill_info_ui";

  final BillDataModel billDetails;

  @override
  ConsumerState<BillInfoUI> createState() => _BillInfoUIState();
}

class _BillInfoUIState extends ConsumerState<BillInfoUI> {
  late BillController _billController;
  TextEditingController outletNameController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController assetTypeController = TextEditingController();
  TextEditingController assetNoController = TextEditingController();
  TextEditingController totalLightController = TextEditingController();
  TextEditingController totalBillController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _billController = BillController(context: context, ref: ref);

    outletNameController.text=widget.billDetails.outletName;
    ownerNameController.text=widget.billDetails.ownerName;
    assetTypeController.text=widget.billDetails.assetType;
    assetNoController.text=widget.billDetails.assetNo;
    totalLightController.text=widget.billDetails.totalLight.toString();
    totalBillController.text=widget.billDetails.total.toString();
  }

  @override
  void dispose() {
    outletNameController.dispose();
    ownerNameController.dispose();
    assetTypeController.dispose();
    assetNoController.dispose();
    totalLightController.dispose();
    totalBillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: "Bill Info",
          titleImage: "bill.png",
          onLeadingIconPressed: () {
            Navigator.pop(context);
          }),
      body: ListView(
        // padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
        children: [
          16.sp.verticalSpacing,
          heading("Outlet"),
          NormalTextField(
            textEditingController: outletNameController,
            inputType: TextInputType.text,
            enable: false,
          ),
          heading("Owner Name"),
          NormalTextField(
            textEditingController: ownerNameController,
            inputType: TextInputType.text,
            enable: false,
          ),
          heading("Asset Type"),
          NormalTextField(
            textEditingController: assetTypeController,
            inputType: TextInputType.text,
            enable: false,
          ),
          heading("Asset No"),
          NormalTextField(
            textEditingController: assetNoController,
            inputType: TextInputType.text,
            enable: false,
          ),
          heading("Total Light"),
          NormalTextField(
            textEditingController: totalLightController,
            inputType: TextInputType.text,
            enable: false,
          ),
          heading("Total Bill"),
          NormalTextField(
            textEditingController: totalBillController,
            inputType: TextInputType.text,
            enable: false,
          ),
          SizedBox(height: 1.5.h),
          SubmitButtonGroup(
            button1Label: "Disburse",
            button1Color: primary,
            onButton1Pressed: () {
              // AssetPullOutModel? selectedAsset = ref.watch(selectedAssetPullInProvider);
              // assetController.submitAssetPullOut(selectedOutlet, commentController.text, selectedAsset);
              _billController.disburseBill(bill: widget.billDetails);
            },
          ),
          SizedBox(height: 3.h),
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

  Widget billListTile({required bool even}) {
    return Container(
      color: even == true ? Colors.white : primary.withOpacity(0.12),
      padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Mayer Doa',
              style: TextStyle(
                color: Color(0xff1C3726),
              ),
            ),
          ),
          Text(
            'View',
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          )
        ],
      ),
    );
  }
}
