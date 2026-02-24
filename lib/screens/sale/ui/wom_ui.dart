import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../models/WomModel.dart';
import '../../../models/outlet_model.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../services/before_sale_services/wom_service.dart';
import 'package:flutter_html/flutter_html.dart';

class WOMUI extends StatelessWidget {
  WOMUI({Key? key, required this.womModel, required this.retailer}) : super(key: key);
  final WomModel womModel;
  final OutletModel retailer;
  final GlobalWidgets globalWidgets = GlobalWidgets();
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Html(
                    data: womModel.content,
                  ),
                ),
              ),
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
