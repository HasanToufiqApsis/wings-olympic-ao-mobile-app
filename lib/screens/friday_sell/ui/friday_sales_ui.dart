import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/dashboard_btn_names.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../main.dart';
import '../../../models/journey_change_route_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../controller/friday_sales_controller.dart';

class FridaySalesUI extends ConsumerStatefulWidget {
  const FridaySalesUI({super.key});

  static const routeName = "friday_sales_ui";

  @override
  ConsumerState<FridaySalesUI> createState() => _FridaySellUIState();
}

class _FridaySellUIState extends ConsumerState<FridaySalesUI> {
  final _appBarTitle = DashboardBtnNames.fridaySales;
  late FridaySalesController fridaySalesController;

  @override
  void initState() {
    super.initState();
    fridaySalesController = FridaySalesController(context: context, ref: ref);

    ///take decision about my current route fom [FridaySalesController]
    fridaySalesController.controllerInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _appBarTitle,
        titleImage: "friday.png",
        showLeading: true,
        centerTitle: true,
        onLeadingIconPressed: () {
          fridaySalesController.refreshState();
          navigatorKey.currentState?.pop();
        },
        heroTagTitle: _appBarTitle,
        heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
      ),
      body: ListView(
        children: [
          2.h.verticalSpacing,
          heading("Select Route"),
          Consumer(
            builder: (context, ref, _) {
              AsyncValue<List<JourneyChangeRouteModel>> asyncRouteList = ref.watch(getALlRouteListProvider);
              JourneyChangeRouteModel? selected = ref.watch(selectedRouteProvider);

              return asyncRouteList.when(
                  data: (routeList) {
                    String lang = ref.watch(languageProvider);
                    String hint = "Select a route";
                    if (lang != "en") {
                      hint = "রুট নির্বাচন করুন";
                    }
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.sp),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                      margin: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Center(
                          child: DropdownButton<JourneyChangeRouteModel>(
                            hint: LangText(
                              hint,
                              style: TextStyle(color: Colors.grey, fontSize: 8.sp),
                            ),
                            iconDisabledColor: Colors.transparent,
                            focusColor: Theme.of(context).primaryColor,
                            isExpanded: true,
                            value: selected,
                            iconSize: 15.sp,
                            items: routeList.map((item) {
                              return DropdownMenuItem<JourneyChangeRouteModel>(
                                value: item,
                                child: FittedBox(
                                  child: Row(
                                    children: [
                                      // iconList(item.iconData),

                                      1.w.horizontalSpacing,

                                      LangText(
                                        item.slug,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: Colors.black),
                                      ),
                                      SizedBox(width: 1.w),
                                      item == selected
                                          ? const Icon(
                                              Icons.done_all,
                                              color: Colors.green,
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                            style: const TextStyle(color: Colors.black),
                            underline: Container(
                              height: 0,
                              color: Colors.transparent,
                            ),
                            onChanged: (val) {
                              ref.read(selectedRouteProvider.notifier).state = val;
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  error: (e, s) => Container(),
                  loading: () => Container());
            },
          ),
          5.h.verticalSpacing,
          SubmitButtonGroup(
            twoButtons: true,
            onButton1Pressed: () {
              fridaySalesController.changeRoute();
            },
            onButton2Pressed: () {
              navigatorKey.currentState?.pop();
            },
          )
        ],
      ),
    );
  }

  Widget heading(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
      child: LangText(
        label,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
      ),
    );
  }
}
