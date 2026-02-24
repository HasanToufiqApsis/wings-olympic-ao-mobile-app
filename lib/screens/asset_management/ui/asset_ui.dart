import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/dashboard_btn_names.dart';

import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/input_fields/dropdowns.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../controller/asset_controller.dart';
import 'asset_installation.dart';
import 'asset_pull_out_ui.dart';
import 'asset_requisition_ui.dart';

class AssetUI extends ConsumerStatefulWidget {
  const AssetUI({Key? key}) : super(key: key);
  static const routeName = "/asset_ui";
  @override
  ConsumerState<AssetUI> createState() => _AssetUIState();
}

class _AssetUIState extends ConsumerState<AssetUI> {
  final _appBarTitle = DashboardBtnNames.asset;
  late AssetController assetController;

  @override
  void initState() {
    super.initState();
    assetController = AssetController(context: context, ref: ref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: _appBarTitle,
          titleImage: "asset.png",
          onLeadingIconPressed: () {
            Navigator.pop(context);
          },
        heroTagTitle: _appBarTitle,
        heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
      ),
      body: ListView(
        children: [
          SizedBox(height: 16.sp,),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 10.sp),
          //   child: GlobalWidgets().showInfoCenter(
          //     message: 'You must fill (*) marked questions',
          //   ),
          // ),
          // SizedBox(height: 10.sp,),
          assetController.heading("Activity Type"),
          Consumer(
            builder: (context,ref,_) {
              String? selected = ref.watch(selectedAssetActivityProvider);

              return CustomSingleDropdown<String>(
                value: selected,
                items: ["Requisition", "Installation", "Pull Out"].map<DropdownMenuItem<String>>((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (value){
                  ref.read(selectedAssetActivityProvider.notifier).state = value;
                  ref.refresh(selectedSoRetailerProvider);
                },

              );
            }
          ),
          // SizedBox(height: 3.h,),
          Consumer(
              builder: (context,ref,_){
                String? type = ref.watch(selectedAssetActivityProvider);
                switch(type){
                  case "Installation":
                    return const AssetInstallationUI();
                  case "Requisition":
                    return const AssetRequisitionUI();
                  default:
                    return const AssetPullOutUI();
                }
              }
          )
        ],
      ),
    );
  }
}
