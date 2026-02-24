import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wings_olympic_sr/models/retailers_mdoel.dart';

import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/outlet_model.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../services/geo_location_service.dart';
import '../../map/ui/map_navigation_screen.dart';
import '../../outlet_informations/controller/outlet_controller.dart';
import '../../outlet_informations/ui/outlet_details_ui.dart';
import '../controller/retailer_selection_controller.dart';
import '../ui/retailer_details_ui.dart';
import 'retailer_list_tile.dart';

class RetailerListWidget extends ConsumerStatefulWidget {
  final List<OutletModel> retailerList;
  final bool? navigationTileEnabled;
  final Function(OutletModel) onRetailerSelect;

  const RetailerListWidget({
    super.key,
    required this.retailerList,
    this.navigationTileEnabled,
    required this.onRetailerSelect,
  });

  @override
  ConsumerState<RetailerListWidget> createState() => _RetailerListWidgetState();
}

class _RetailerListWidgetState extends ConsumerState<RetailerListWidget>
    with AutomaticKeepAliveClientMixin {
  late final Alerts _alerts;
  late final RetailerSelectionController _retailerSelectionController;

  @override
  void initState() {
    _alerts = Alerts(context: context);

    _retailerSelectionController = RetailerSelectionController(
      alerts: _alerts,
      locationService: LocationService(context),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemCount: widget.retailerList.length,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) {
        return RetailerListTile(
          retailer: widget.retailerList[index],
          navigationTileEnabled: widget.navigationTileEnabled,
          onItemTap: () {
            widget.onRetailerSelect(widget.retailerList[index]);
          },
          onInfoTap: () async {
            // navigatorKey.currentState?.pushNamed(
            //   RetailerDetailsScreen.routeName,
            //   arguments: widget.retailerList[index],
            // );


            await OutletController(ref: ref, context: context)
                .setDifferentImageURL(widget.retailerList[index]);
            navigatorKey.currentState?.pushNamed(
                OutletDetailsUI.routeName,
                arguments: widget.retailerList[index]);
          },
          onMapTap: () async {
            _retailerSelectionController.retailerLocationNavigator(
              retailer: widget.retailerList[index],
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
