import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../reusable_widgets/scaffold_widgets/body.dart';
import '../controller/outlet_controller.dart';

class CheckOutletSyncUI extends ConsumerStatefulWidget {
  const CheckOutletSyncUI({Key? key}) : super(key: key);
  static const routeName = "/check_if_outlet_synced";
  @override
  ConsumerState<CheckOutletSyncUI> createState() => _CheckOutletSyncUIState();
}

class _CheckOutletSyncUIState extends ConsumerState<CheckOutletSyncUI> {
  late final OutletController _outletController;

  @override
  void initState(){
    super.initState();
    _outletController = OutletController(context: context, ref: ref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Outlets",
        titleImage: "outlet.png",
        showLeading: true,
      ),
      body: CustomBody(
        child: Padding(
          padding: EdgeInsets.only(top: 3.h, left: 7.5.w, right: 7.5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // Padding(
              //   padding: EdgeInsets.only(left: 40.w, bottom: 1.h),
              //   child: SizedBox(
              //     height: 30.sp,
              //     width: 30.sp,
              //     child: Image.asset(
              //       'assets/sell_out_of_selected_outlet_icon.png',
              //     ),
              //   ),
              // ),

              Icon(Icons.warning_amber_rounded, size: 56, color: yellow,),
              8.verticalSpacing,
              Center(
                child: LangText(
                  'You have unsynced outlets. Please sync the outlet list if you want to take pre-orders at those outlets!',
                  style: TextStyle(
                    color: primaryRed,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    fontFamily: 'NotoSansBengali',
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              SubmitButtonGroup(
                twoButtons: true,
                layout: ButtonLayout.vertical,
                button1Label: "Sync",
                button2Label: "Proceed",
                button2Color: red3,
                onButton1Pressed:(){
                  _outletController.handleOutletSyncAndRedirectToPreorder(true);
                },
                onButton2Pressed: (){
                  _outletController.handleOutletSyncAndRedirectToPreorder(false);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
