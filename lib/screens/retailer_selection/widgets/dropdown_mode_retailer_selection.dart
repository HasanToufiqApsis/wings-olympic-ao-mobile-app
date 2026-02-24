import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/constant_variables.dart';
import 'package:wings_olympic_sr/services/helper.dart';

import '../../../main.dart';
import '../../../models/location_category_models.dart';
import '../../../models/outlet_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../models/retailer_selection_config.dart';
import '../models/selection_nav.dart';
import '../providers/retailer_selection_providers.dart';
import 'retailer_list_widget.dart';
import 'retailer_search_delegate.dart';

class DropDownModeRetailerSelection extends StatefulWidget {
  final RetailerSelectionConfig? config;
  final bool forMemo;
  final SelectionNav selectionNav;
  final Function(OutletModel) onRetailerSelect;

  const DropDownModeRetailerSelection({
    super.key,
    required this.config,
    this.forMemo = false,
    required this.selectionNav,
    required this.onRetailerSelect,
  });

  @override
  State<DropDownModeRetailerSelection> createState() => _DropDownModeRetailerSelectionState();
}

class _DropDownModeRetailerSelectionState extends State<DropDownModeRetailerSelection> {
  List<OutletModel> searchRetailerList = [];

  List<SectionModel?> tabRouteList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: Center(
          child: AppBar(
            title: LangText(
              'Select Retailer',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: primary,
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
                    navigatorKey.currentState?.pop(retailer);
                  }
                },
                icon: const Icon(
                  color: Colors.white,
                  CupertinoIcons.search,
                ),
              ),
              const SizedBox(width: 4),
            ],
            leading: Padding(
              padding: EdgeInsets.only(left: 3.w),
              child: Container(
                height: 7.h,
                decoration: BoxDecoration(
                  color: greenOlive.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      navigatorKey.currentState?.pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          return Consumer(
            builder: (context, ref, _) {
              final asyncRoutes = ref.watch(sectionListProvider);

              return asyncRoutes.when(
                data: (routeList) {
                  return Consumer(builder: (context, ref, _) {
                    final asyncRetailers = ref.watch(plainRetailerListProvider(widget.forMemo));

                    return asyncRetailers.when(
                      data: (retailerList) {
                        searchRetailerList = retailerList;

                        Helper.dPrint('retailer list length -> ${retailerList.length}');

                        if (tabRouteList.isEmpty) {
                          if (widget.config?.showAllRoutes == true) {
                            tabRouteList = routeList;
                          } else {
                            /// Find the active route
                            SectionModel? activeRoute = routeList.isEmpty ? null : routeList.first;
                            for (var route in routeList) {
                              if (route.isActive ?? false) {
                                activeRoute = route;
                              }
                            }

                            tabRouteList = [
                              activeRoute,
                              SectionModel(id: 0, name: 'Ad-Hoc', parentId: 0, isActive: false),
                            ];
                          }
                        }

                        return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.sp),
                                color: Colors.white,
                                // border: Border.all(color: grey, width: 1.sp)
                              ),
                              child: Consumer(
                                builder: (context, ref, _) {
                                  SectionModel? selectedSection = ref.watch(selectedRoutesProvider);

                                  /// Here auto select the active route
                                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                                    await Future.delayed(const Duration(microseconds: 500));
                                    for (var sec in tabRouteList) {
                                      if (sec?.isActive == true) {
                                        final alreadySec = ref.read(selectedRouteProvider.notifier).state;
                                        if (alreadySec == null) {
                                          // ref.read(selectedRouteProvider.notifier).state = sec;
                                          break;
                                        }
                                      }
                                    }
                                  });

                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                                    child: Center(
                                      child: DropdownButton<SectionModel>(
                                        hint: LangText(
                                          'Select Route',
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                        iconDisabledColor: Colors.transparent,
                                        focusColor: Theme.of(context).primaryColor,
                                        isExpanded: true,
                                        value: selectedSection,
                                        iconSize: 15.sp,
                                        items: tabRouteList.map(
                                          (item) {
                                            return DropdownMenuItem<SectionModel>(
                                              value: item,
                                              child: FittedBox(
                                                child: Row(
                                                  children: [
                                                    LangText(
                                                      item?.name ?? '-',
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(color: Colors.black, fontSize: normalFontSize),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ).toList(),
                                        style: const TextStyle(color: Colors.black),
                                        underline: Container(
                                          height: 0,
                                          color: Colors.transparent,
                                        ),
                                        onChanged: (val) {
                                          // ref.read(selectedRouteProvider.notifier).state = val;
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: Consumer(
                                builder: (context, ref, _) {
                                  final selectedRoute = ref.watch(selectedRouteProvider);

                                  final filteredList = retailerList.where((ret) {
                                    if (selectedRoute?.id == 0) {
                                      return true;
                                    }
                                    // return ret.sectionId.contains(selectedRoute?.id);
                                    return ret.sectionId == (selectedRoute?.id);
                                  }).toList();

                                  return RetailerListWidget(
                                    retailerList: filteredList,
                                    navigationTileEnabled: widget.config?.showNavButtons,
                                    onRetailerSelect: widget.onRetailerSelect,
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                      error: (error, stck) {
                        return Center(
                          child: Text(error.toString()),
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
                    child: Text(error.toString()),
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
        },
      ),
    );
  }
}
