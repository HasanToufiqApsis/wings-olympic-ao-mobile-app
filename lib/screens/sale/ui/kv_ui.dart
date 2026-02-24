import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../models/WomModel.dart';
import '../../../models/outlet_model.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../services/asset_download/asset_service.dart';
import '../../../services/before_sale_services/wom_service.dart';

class KVUI extends StatelessWidget {
  KVUI({Key? key, required this.womModel, required this.retailer}) : super(key: key);
  final WomModel womModel;
  final OutletModel retailer;

  popWOM(BuildContext context) {
    WomService(context).submitWomData(womModel, retailer.id!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title:"Pre-order",
        titleImage: "pre_order_button.png",
        showLeading: true,
      ),
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: SizedBox(
          height: 100.h,
          width: 100.w,
          child: Column(
            children: [
              Expanded(child: Container(child: AssetService(context).superImage(womModel.content, folder: 'kv'))),
              Padding(
                  padding: EdgeInsets.only(bottom: 3.h),
                  child: SubmitButtonGroup(
                    button1Label: "Close",
                    onButton1Pressed: (){
                      popWOM(context);
                    },
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
