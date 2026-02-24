import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/constant_variables.dart';

import '../services/asset_download/asset_service.dart';
import '../services/sync_read_service.dart';
import 'language_textbox.dart';

class NullRetailerWidget extends StatelessWidget {
  final Function()? onTap;

  const NullRetailerWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: primary,
              style: BorderStyle.solid,
              width: 1),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            // BoxShadow(
            //   color: primaryGreen.withValues(alpha: 0.2),
            //   spreadRadius: 0.1,
            //   blurRadius: .1,
            //   offset: const Offset(0, 1), // changes position of shadow
            // ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.sp),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(100),
                    ),
                    // child: Icon(
                    //   Icons.storefront,
                    //   color: grey500,
                    // ),
                    child: AssetService(context).superImage(
                      "new_outlet.png",
                      folder: 'asset',
                      version: SyncReadService().getAssetVersion('asset'),
                      fit: BoxFit.cover,
                      height: 26,
                      width: 26,
                    ),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  LangText(
                    "Select a retailer",
                    // style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_drop_down_outlined,
                // color: Colors.grey[400],
              )
            ],
          ),
        ),
      ),
    );
  }
}
