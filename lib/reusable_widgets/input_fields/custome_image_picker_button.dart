import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constant_variables.dart';
import '../../constants/enum.dart';
import '../../provider/global_provider.dart';
import '../../services/helper.dart';
import '../language_textbox.dart';

class CustomImagePickerButton extends StatelessWidget {
  const CustomImagePickerButton({
    Key? key,
    this.label,
    required this.onPressed,
    required this.type,
    this.error = false,
  }) : super(key: key);
  final String? label;
  final VoidCallback onPressed;
  final CapturedImageType type;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: LangText(
                label!,
                style: TextStyle(
                    color: primaryBlack,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(verificationRadius),
              border: Border.all(width: 1, color: error ? primaryRed : Colors.transparent)
            ),
            height: 10.h,
            width: 100.w,
            child: RawMaterialButton(
              onPressed: onPressed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(verificationRadius)),
              child: Consumer(builder: (context, ref, _) {
                String? image = ref.watch(outletImageProvider(type));
                print(type);
                print(image);
                bool ifUrl = Helper.checkIfUrl(image);
                return image == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_camera_outlined,
                            color: pureGrey,
                            size: normalFontSize,
                          ),
                          LangText(
                            "Tap to open camera",
                            style: TextStyle(
                                color: pureGrey,
                                fontSize: smallerFontSize,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    : !ifUrl
                        ? Image.file(File(image))
                        : Image(
                            image: NetworkImage(image),
                            errorBuilder: (context, exception, stackTrace) {
                              return Image.asset("assets/placeholder.png");
                            },
                            // loadingBuilder: (context, o, s)=> const CircularProgressIndicator()//Image.asset("assets/placeholder.png"),
                          );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomMultipleImagePickerButton extends StatelessWidget {
  const CustomMultipleImagePickerButton({
    Key? key,
    this.label,
    required this.onPressed,
    required this.type,
    required this.index,
  }) : super(key: key);
  final String? label;
  final VoidCallback onPressed;
  final CapturedMultipleImageType type;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: LangText(
                label!,
                style: TextStyle(
                    color: primaryBlack,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(verificationRadius)),
            height: 10.h,
            width: 100.w,
            child: RawMaterialButton(
              onPressed: onPressed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(verificationRadius)),
              child: Consumer(builder: (context, ref, _) {
                String? image =
                    ref.watch(multipleImageProvider("$type-$index"));
                print(type);
                print(image);
                String extension = image?.split('.').last ?? "";
                bool isAFile = false;
                if (extension == "pdf" ||
                    extension == "doc" ||
                    extension == "xlsx" ||
                    extension == "xlsm") {
                  isAFile = true;
                }
                bool ifUrl = Helper.checkIfUrl(image);
                return image == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_camera_outlined,
                            color: pureGrey,
                            size: normalFontSize,
                          ),
                          LangText(
                            "Tap to select attachment",
                            style: TextStyle(
                                color: pureGrey,
                                fontSize: smallerFontSize,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    : !ifUrl
                        ? isAFile
                            ? Icon(
                                extension == "pdf"
                                    ? Icons.picture_as_pdf
                                    : Icons.file_copy_rounded,
                                color: primary,
                              )
                            : Image.file(File(image))
                        : Image(
                            image: NetworkImage(image),
                            errorBuilder: (context, exception, stackTrace) {
                              return Image.asset("assets/placeholder.png");
                            },
                            // loadingBuilder: (context, o, s)=> const CircularProgressIndicator()//Image.asset("assets/placeholder.png"),
                          );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
