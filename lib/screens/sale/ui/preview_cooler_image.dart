import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wings_olympic_sr/constants/enum.dart';

import '../../../constants/constant_variables.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';

class PreviewCoolerImage extends StatelessWidget {
  const PreviewCoolerImage({
    super.key,
    required this.coolerImage,
    required this.onTryAgainPressed,
    required this.onSubmitPressed,
  });

  static const routeName = "/preview_cooler_image";
  final File coolerImage;
  final VoidCallback onTryAgainPressed;
  final VoidCallback onSubmitPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image(
                  image: FileImage(coolerImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: SubmitButtonGroup(
              layout: ButtonLayout.horizontal,
              twoButtons: true,
              button1Icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              button1Color: primaryRed,
              button1Label: "Try Again",
              button2Icon: Icon(
                Icons.done,
                color: Colors.white,
              ),
              button2Color: primary,
              button2Label: "Done",
              onButton1Pressed: onTryAgainPressed,
              onButton2Pressed: onSubmitPressed,
            ),
          )
        ],
      ),
    );
  }
}
