import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/main.dart';
import 'package:wings_olympic_sr/provider/global_provider.dart';
import 'package:wings_olympic_sr/screens/retailer_selection/models/selection_nav.dart';
import 'package:wings_olympic_sr/screens/sale/controller/sale_controller.dart';
import 'package:wings_olympic_sr/screens/sale/ui/sales_ui_v2.dart';

import '../../../models/outlet_model.dart';
import '../providers/retailer_selection_providers.dart';
import '../widgets/dropdown_mode_retailer_selection.dart';
import '../widgets/received_retailer_selection.dart';
import '../widgets/tab_mode_retailer_selection.dart';

class RetailerSelectionUi extends ConsumerStatefulWidget {
  static const routeName = 'RetailerSelectionUi';
  final List<OutletModel>? retailerList;
  final bool forMemo;
  final SelectionNav selectionType;

  const RetailerSelectionUi({
    super.key,
    this.retailerList,
    this.forMemo = false,
    this.selectionType = SelectionNav.backWord,
  });

  @override
  ConsumerState createState() => _RetailerSelectionUiState();
}

class _RetailerSelectionUiState extends ConsumerState<RetailerSelectionUi> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Consumer(
        builder: (context, ref, _) {
          final asyncConfig = ref.watch(retailerSelectionConfigProvider);

          return asyncConfig.when(
            data: (config) {
              if (widget.retailerList != null) {
                return ReceivedRetailerSelection(
                  config: config,
                  retailerList: widget.retailerList!,
                  onRetailerSelect: _onRetailerSelect,
                );
              }
              if (config.tabMode == true) {
                return TabModeRetailerSelection(
                  config: config,
                  forMemo: widget.forMemo,
                  selectionNav: widget.selectionType,
                  onRetailerSelect: _onRetailerSelect,
                );
              }

              return DropDownModeRetailerSelection(
                config: config,
                selectionNav: widget.selectionType,
                onRetailerSelect: _onRetailerSelect,
              );
            },
            error: (error, stck) => const SizedBox(),
            loading: () => const SizedBox(),
          );
        },
      ),
    );
  }

  void _onRetailerSelect(OutletModel retailer) {
    switch (widget.selectionType) {
      case SelectionNav.forward:
        // SaleController(context: context, ref: ref).handleRetailerChange(retailer);
        // ref.read(selectedRetailerProvider.notifier).state = retailer;
        navigatorKey.currentState?.pushNamed(SalesUIv2.routeName, arguments: retailer);
      case SelectionNav.backWord:
        navigatorKey.currentState?.pop(retailer);
    }
  }
}
