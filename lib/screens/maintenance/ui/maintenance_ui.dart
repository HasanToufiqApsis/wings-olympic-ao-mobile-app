import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/dashboard_btn_names.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/maintanence_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../controller/maintenance_controller.dart';
import 'maintenance_details_ui.dart';

class MaintenanceUI extends ConsumerStatefulWidget {
  const MaintenanceUI({Key? key}) : super(key: key);
  static const routeName = "/maintenance_ui";

  @override
  ConsumerState<MaintenanceUI> createState() => _AssetRoUIState();
}

class _AssetRoUIState extends ConsumerState<MaintenanceUI> {
  final _appBarTitle = DashboardBtnNames.maintenance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: _appBarTitle,
          titleImage: "maintenance.png",
          onLeadingIconPressed: () {
            Navigator.pop(context);
          },
        heroTagTitle: _appBarTitle,
        heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
      ),
      body: Consumer(builder: (context, ref, _) {
        AsyncValue<List<MaintenanceModel>> asyncAssetRequisitionList = ref.watch(getAllMaintenanceList);

        return asyncAssetRequisitionList.when(
            data: (requestList) {
              return ListView.builder(
                itemCount: requestList.length,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                itemBuilder: (BuildContext context, int index) {
                  var val = requestList[index];
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, MaintenanceDetailsUI.routeName, arguments: val);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(verificationRadius),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.sp),
                        child: Column(
                          children: [
                            // ListTile(
                            //   leading: Icon(Icons.tag_rounded, color: primaryGreen,),
                            //   title: Text('${val.maintainanceId}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                            // ),
                            requestDetailsTile(
                              title: 'Code',
                              icon: Icons.tag_rounded,
                              value: val.maintainanceId ?? '',
                              boldValue: true,
                            ),
                            requestDetailsTile(
                              title: 'Retailer',
                              icon: Icons.storefront_rounded,
                              value: val.outletName ?? '',
                            ),
                            requestDetailsTile(
                              title: 'Type',
                              icon: (val.assetType ?? '').toLowerCase() == 'cooler' ? Icons.kitchen : Icons.emoji_objects_outlined,
                              value: val.assetType ?? '',
                            ),
                            requestDetailsTile(
                              title: 'Date',
                              icon: Icons.calendar_month_rounded,
                              value: val.dateTime,
                            ),
                            requestDetailsTile(
                              title: 'Phone',
                              icon: Icons.call_rounded,
                              value: val.contactNo ?? '',
                            ),
                            10.verticalSpacing,
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(verificationRadius),
                                  bottomRight: Radius.circular(verificationRadius),
                                ),
                                color: primary,
                              ),
                              width: 100.w,
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            error: (error, _) => Container(),
            loading: () => Center(
                  child: CircularProgressIndicator(),
                ));
      }),
    );
  }

  Widget heading(String label, [double? fontSize, Alignment? alignment]) {
    return Align(
      alignment: alignment ?? Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
        child: LangText(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize ?? 11.sp),
        ),
      ),
    );
  }

  Widget requestDetailsTile({
    required IconData icon,
    required String title,
    required String value,
    bool boldValue = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 8.sp,
      ),
      child: Row(
        children: [
          Icon(icon, color: primary, size: 20,),
          4.horizontalSpacing,
          Expanded(
            flex: 1,
            child: LangText(
              title,
              style: Theme.of(context).textTheme.titleSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: boldValue == true ? Theme.of(context).textTheme.headlineSmall : Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
