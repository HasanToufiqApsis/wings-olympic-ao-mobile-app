import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/constant_variables.dart';

import '../../../../reusable_widgets/language_textbox.dart';
import '../../../../services/asset_download/asset_service.dart';
import '../../../../services/sync_read_service.dart';
import '../../model/sale_dashboard_category_model.dart';

class SaleDashboardItemWidget extends StatelessWidget {
  final SaleDashboardCategoryModel item;
  final Function() onTap;

  const SaleDashboardItemWidget({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      radius: 10.sp,
      borderRadius: BorderRadius.circular(10.sp),
      child: Stack(
        children: [
          Column(
            children: [
              const Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Expanded(
                flex: 8,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: item.forceDisable == true
                          ? Colors.grey[250]
                          : Colors.white,
                      // color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(10.sp),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 0.5,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: item.useLocalAsset ? Image.asset("assets/${item.image}") : AssetService(context).superImage(
                      item.image,
                      folder: 'ICONS',
                      version: SyncReadService().getAssetVersion('ICONS'),
                      fit: BoxFit.contain,
                      localAsset: "assets/media.png",
                     title: item.title??""
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: LangText(
                            item.title,
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                              color: primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (item.mandatory)
                          LangText(
                            " *",
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          // if ((item.alreadyComplete == true) && item.type != SaleDashboardType.sale)
          if ((item.alreadyComplete == true))
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: green,
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.2),
                      spreadRadius: 0.5,
                      blurRadius: 1,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                ),
              ),
            )
        ],
      ),
      // child: Stack(
      //   children: [
      //     Container(
      //       width: double.maxFinite,
      //       decoration: BoxDecoration(
      //         color:
      //             index == 0 ? Colors.grey[100] : Colors.white,
      //         border: Border.all(
      //           color: Colors.white,
      //           style: BorderStyle.solid,
      //         ),
      //         borderRadius: BorderRadius.circular(10.sp),
      //         boxShadow: [
      //           BoxShadow(
      //             color: Colors.grey.withOpacity(0.2),
      //             spreadRadius: 0.5,
      //             blurRadius: 2,
      //             offset: const Offset(0, 1),
      //           ),
      //         ],
      //       ),
      //       child: Column(
      //         children: [
      //           Expanded(
      //             child: Padding(
      //               padding: EdgeInsets.symmetric(
      //                 vertical: 2.h,
      //               ),
      //               child: AssetService(context).superImage(
      //                 item.image,
      //                 folder: 'asset',
      //                 version: SyncReadService()
      //                     .getAssetVersion('asset'),
      //                 fit: BoxFit.cover,
      //               ),
      //             ),
      //           ),
      //           Padding(
      //             padding: EdgeInsets.only(bottom: 1.h),
      //             child: LangText(
      //               item.title,
      //               style: TextStyle(
      //                 fontSize: 9.sp,
      //                 fontWeight: FontWeight.bold,
      //                 color: darkBlue,
      //               ),
      //               overflow: TextOverflow.ellipsis,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //     if (index != 0)
      //       Positioned(
      //         right: 1.w,
      //         top: 1.w,
      //         child: Icon(
      //           Icons.done_all_rounded,
      //           color: green,
      //         ),
      //       ),
      //     // if (index != 0)
      //     //   Positioned(
      //     //     right: 1.w,
      //     //     top: 1.w,
      //     //     child: Text(
      //     //       "*",
      //     //       style: TextStyle(fontSize: 36, color: green),
      //     //     ),
      //     //   ),
      //     // if (index == 0)
      //     //   Container(
      //     //     decoration: BoxDecoration(
      //     //       borderRadius: BorderRadius.circular(5.sp),
      //     //       color: Colors.black12,
      //     //     ),
      //     //   ),
      //   ],
      // ),
    );
  }
}
