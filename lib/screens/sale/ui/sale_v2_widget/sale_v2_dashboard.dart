import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../../provider/global_provider.dart';
import '../../../../reusable_widgets/custom_dialog.dart';
import '../../../../reusable_widgets/global_widgets.dart';
import '../../../../services/sales_service.dart';
import '../../../../services/storage_prmission_service.dart';
import '../../controller/sale_controller.dart';
import 'sale_dashboard_item_widget.dart';


class SalesUIv2Dashboard extends ConsumerStatefulWidget {
  const SalesUIv2Dashboard({
    Key? key,
  }) : super(key: key);

  @override
  _SalesUIv2DashboardState createState() => _SalesUIv2DashboardState();
}

class _SalesUIv2DashboardState extends ConsumerState<SalesUIv2Dashboard> {
  late GlobalWidgets globalWidgets;
  late SaleController salesController;
  late SalesService _salesService;
  late Alerts alerts;
  late StoragePermissionService _storagePermissionService;

  @override
  void initState() {
    super.initState();

    alerts = Alerts(context: context);
    globalWidgets = GlobalWidgets();
    salesController = SaleController(context: context, ref: ref);
    _salesService = SalesService();

    _storagePermissionService = StoragePermissionService(context: context);
    _storagePermissionService.requestStoragePermission();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final retailer = ref.watch(selectedRetailerProvider);
      if (retailer == null) {
        return const SizedBox();
      }
      final asyncSaleDashboardMenu = ref.watch(saleDashboardMenuProvider(retailer));
      return asyncSaleDashboardMenu.when(
        data: (saleDashboardMenu) {
          return GridView.builder(
            itemCount: saleDashboardMenu.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
              horizontal: 3.w,
              // vertical: 3.h,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 2.w,
              crossAxisSpacing: 2.w,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (BuildContext context, int index) {
              var item = saleDashboardMenu[index];

              return SaleDashboardItemWidget(
                item: item,
                // itemCompleteStatus: completed,
                onTap: () {
                  salesController.navigateToPage(
                    item: item,
                    retailer: retailer,
                    allItems: saleDashboardMenu,
                  );
                },
              );
            },
          );
        },
        error: (e, s) => Text('$e'),
        loading: () => const CircularProgressIndicator(),
      );
    });
  }
}
