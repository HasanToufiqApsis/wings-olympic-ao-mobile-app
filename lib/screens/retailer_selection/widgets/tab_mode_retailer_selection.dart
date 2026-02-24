import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/screens/retailer_selection/models/selection_nav.dart';
import 'package:wings_olympic_sr/services/helper.dart';

import '../../../constants/constant_variables.dart';
import '../../../main.dart';
import '../../../models/location_category_models.dart';
import '../../../models/outlet_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../models/retailer_selection_config.dart';
import 'retailer_list_widget.dart';
import 'retailer_search_delegate.dart';

class TabModeRetailerSelection extends StatefulWidget {
  final RetailerSelectionConfig? config;
  final bool forMemo;
  final SelectionNav selectionNav;
  final Function(OutletModel) onRetailerSelect;

  const TabModeRetailerSelection({
    super.key,
    required this.config,
    this.forMemo = false,
    required this.selectionNav,
    required this.onRetailerSelect,
  });

  @override
  State<TabModeRetailerSelection> createState() =>
      _TabModeRetailerSelectionState();
}

class _TabModeRetailerSelectionState extends State<TabModeRetailerSelection>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController? tabController;

  List<OutletModel> searchRetailerList = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: "Select Retailer",
        showLeading: true,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              final retailer = await showSearch(
                context: context,
                delegate: RetailerSearchDelegate(
                  retailerList: searchRetailerList,
                  retailerSelectionConfig: widget.config,
                ),
              );

              if (retailer != null) {
                // navigatorKey.currentState?.pop(retailer);
                widget.onRetailerSelect(retailer);
              }
            },
            icon: const Icon(
              color: Colors.white,
              CupertinoIcons.search,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Builder(builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final asyncRoutes = ref.watch(sectionListProvider);

            return asyncRoutes.when(
              data: (routeList) {
                return Consumer(builder: (context, ref, _) {
                  // final asyncRetailers = ref.watch(plainRetailerListProvider(widget.forMemo));
                  final asyncRetailers = ref.watch(outletListProvider(true));

                  return asyncRetailers.when(
                    data: (retailerList) {
                      searchRetailerList = retailerList;

                      Helper.dPrint('retailer list length -> ${retailerList.length}');

                      /// Find the active route
                      SectionModel? activeRoute =
                          routeList.isEmpty ? null : routeList.first;
                      for (var route in routeList.reversed) {
                        if (route.isActive ?? false) {
                          activeRoute = route;
                        }
                      }

                      final tabRouteList = <SectionModel>[];
                      if (activeRoute != null) {
                        tabRouteList.add(activeRoute);
                      }
                      tabRouteList.add(
                        SectionModel(id: 0, name: activeRoute == null ? 'All Retailers' : 'Ad-Hoc', parentId: 0, isActive: false),
                      );

                      /// filter active route retailers and adhoc call retailers
                      final activeRouteRetailers = <OutletModel>[];
                      final adhocRouteRetailers = <OutletModel>[];
                      for (var retailer in retailerList) {
                        // if (retailer.sectionId.contains(activeRoute?.id)) {
                        if (retailer.sectionId == (activeRoute?.id)) {
                          activeRouteRetailers.add(retailer);
                        } else {
                          adhocRouteRetailers.add(retailer);
                        }
                      }

                      tabController = TabController(
                          length: tabRouteList.length, vsync: this);

                      return Column(
                        children: [
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TabBar(
                              controller: tabController,
                              isScrollable: true,
                              tabAlignment: TabAlignment.start,
                              // labelStyle: TextStyle(color: blue),
                              labelColor: Colors.white,
                              unselectedLabelColor: grey,
                              // padding: EdgeInsets.symmetric(horizontal: 10),
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              indicatorSize: TabBarIndicatorSize.tab,
                              // indicatorPadding: const EdgeInsets.symmetric(horizontal: 6),
                              indicator: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    primary,
                                    red3,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.sp),
                                    topRight: Radius.circular(5.sp)),
                              ),
                              tabs: tabRouteList.map((route) {
                                return Tab(
                                  child: LangText(
                                    route.name ?? '-',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Expanded(
                            child: Builder(builder: (context) {
                              return TabBarView(
                                controller: tabController,
                                children: tabRouteList.map((element) {
                                  return RetailerListWidget(
                                    navigationTileEnabled: widget.config?.showNavButtons,
                                    retailerList: element.id == 0
                                        ? adhocRouteRetailers
                                        : activeRouteRetailers,
                                    onRetailerSelect: widget.onRetailerSelect,
                                  );
                                }).toList(),
                              );
                            }),
                          ),
                        ],
                      );
                    },
                    error: (error, stck) {
                      return Center(
                        child: LangText(error.toString()),
                      );
                    },
                    loading: () {
                      return Center(
                        child: CircularProgressIndicator(
                          color: primary,
                        ),
                      );
                    },
                  );
                });
              },
              error: (error, stck) {
                return Center(
                  child: LangText(error.toString()),
                );
              },
              loading: () {
                return Center(
                  child: CircularProgressIndicator(
                    color: primary,
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
