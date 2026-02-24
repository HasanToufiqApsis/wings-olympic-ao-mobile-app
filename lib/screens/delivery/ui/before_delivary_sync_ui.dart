import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../reusable_widgets/scaffold_widgets/body.dart';
import '../../outlet_informations/controller/outlet_controller.dart';

class CheckDeliverySyncUI extends ConsumerStatefulWidget {
  const CheckDeliverySyncUI({Key? key}) : super(key: key);
  static const routeName = "/check_if_delivery_synced";
  @override
  ConsumerState<CheckDeliverySyncUI> createState() => _CheckDeliverySyncUIState();
}

class _CheckDeliverySyncUIState extends ConsumerState<CheckDeliverySyncUI> {
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
        title: "Delivery",
        titleImage: "delivery.png",
        showLeading: true,
      ),
      body: CustomBody(
        child: Padding(
          padding: EdgeInsets.only(top: 3.h, left: 7.5.w, right: 7.5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: EdgeInsets.only(left: 40.w, bottom: 1.h),
                child: SizedBox(
                  height: 30.sp,
                  width: 30.sp,
                  child: Icon(Icons.info, color: Colors.red,),
                ),
              ),
              Center(
                child: LangText(
                  'You have unsynced outlets. Please sync the outlet list if you want to make delivery at those outlets!', //
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
                button1Label: "Refresh",
                button2Label: "Proceed",
                button2Color: red3,
                onButton1Pressed:(){
                  _outletController.handleOutletSyncAndRedirectToDelivery(true);
                },
                onButton2Pressed: (){
                  _outletController.handleOutletSyncAndRedirectToDelivery(false);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
