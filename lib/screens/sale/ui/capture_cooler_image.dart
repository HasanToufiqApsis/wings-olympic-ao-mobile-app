import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_keys.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../models/outlet_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/cameraScreen.dart';
import '../../../services/Image_service.dart';

class CaptureCoolerImage extends StatelessWidget {
const CaptureCoolerImage({Key? key, required this.onCaptureCoolerImage}) : super(key: key);
final VoidCallback onCaptureCoolerImage;
@override
Widget build(BuildContext context) {
  return Padding(
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
            'Need to capture cooler image!',
            style:const TextStyle(
              color: primaryRed,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              fontFamily: 'NotoSansBengali',
            ),
          ),
        ),
        SizedBox(height: 5.h),
        // Consumer(
        //     builder: (context, ref,_){
        //       String imagePath = ref.watch(coolerImagePathProvider);
        //       if(imagePath.isEmpty){
        //         return Container();
        //       }
        //       return Image.file(File(imagePath), height: 10.h,);
        //     }
        // ),
        SubmitButtonGroup(
          button1Icon: Icon(Icons.camera_alt,color: Colors.white,),
          button1Label: "Cooler Image",
          onButton1Pressed:onCaptureCoolerImage
        )
      ],
    ),
  );
}
}
