import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wings_olympic_sr/constants/dashboard_btn_names.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/bill/bill_data_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../controller/bill_controller.dart';
import 'bill_info_ui.dart';

class BillUI extends ConsumerStatefulWidget {
  const BillUI({Key? key}) : super(key: key);
  static const routeName = "/bill_ui";

  @override
  ConsumerState<BillUI> createState() => _BillUIState();
}

class _BillUIState extends ConsumerState<BillUI> {
  final _appBarTitle = DashboardBtnNames.bill;
  late BillController assetController;

  @override
  void initState() {
    super.initState();
    assetController = BillController(context: context, ref: ref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: _appBarTitle,
          titleImage: "bill.png",
          onLeadingIconPressed: () {
            Navigator.pop(context);
          },
        heroTagTitle: _appBarTitle,
        heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
      ),
      body: Consumer(builder: (context, ref, _) {
        AsyncValue<List<BillDataModel>> asyncAssetRequisitionList = ref.watch(getAllBillList);

        return asyncAssetRequisitionList.when(
            data: (requestList) {
              if(requestList.isEmpty){
                return Center(
                  child: LangText('No bill available now'),
                );
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(borderRadius: 10.circularRadius, border: Border.all(color: primary, width: 2)),
                      child: ClipRRect(
                        borderRadius: 10.circularRadius,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: requestList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var data = requestList[index];
                            return billListTile(
                                data: data,
                                even: index % 2 == 0,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    BillInfoUI.routeName,
                                    arguments: data,
                                  );
                                });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            error: (error, _) => Container(),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                ));
      }),
    );
  }

  Widget billListTile({
    required bool even,
    required Function() onTap,
    required BillDataModel data,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: even == true ? Colors.white : primary.withOpacity(0.12),
        padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                data.outletName,
                style: const TextStyle(
                  color: Color(0xff1C3726),
                ),
              ),
            ),
            const Text(
              'View',
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            )
          ],
        ),
      ),
    );
  }
}
