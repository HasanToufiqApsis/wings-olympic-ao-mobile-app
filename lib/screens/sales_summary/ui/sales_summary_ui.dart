import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/dashboard_btn_names.dart';
import 'package:wings_olympic_sr/utils/sales_type_utils.dart';

import '../../../constants/constant_variables.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import 'delivery_summary.dart';
import 'sales_summary.dart';

class SalesSummaryUI extends ConsumerStatefulWidget {
  const SalesSummaryUI({Key? key}) : super(key: key);
  static const routeName = "/sale_summary";

  @override
  _SalesSummaryUIState createState() => _SalesSummaryUIState();
}

class _SalesSummaryUIState extends ConsumerState<SalesSummaryUI> with TickerProviderStateMixin {
  final _appBarTitle = DashboardBtnNames.summary;
  late TabController _tabController;
  late PageController _pageController;

  // double creditGiven = 0.0;
  // double carryAmount = 0.0;
  // double due = 0.0;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController(initialPage: 0);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: _appBarTitle,
          titleImage: "summary.png",
          onLeadingIconPressed: () {
            ref.read(selectedQCInfoListProvider.notifier).state = [];
            Navigator.pop(context);
          },
        heroTagTitle: _appBarTitle,
        heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
      ),
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              unselectedLabelColor: primaryBlack.withOpacity(0.6),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              dividerColor: Colors.transparent,
              indicatorColor: primaryBlue,
              tabs: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: LangText(
                    'Preorder',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: LangText(
                    'Sale',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: LangText('Delivery'),
                )
              ],
              onTap: (v){
                _pageController.animateToPage(
                  v,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                // physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (v) {
                  // _tabController.index = v;
                  _tabController.animateTo(v);
                },
                children: const [
                  SalesSummary(saleType: SaleType.preorder),
                  SalesSummary(saleType: SaleType.spotSale),
                  DeliverySummary(),
                ],
              ),
            ),
            // Expanded(
            //   child: ,
            // ),
          ],
        ),
      ),
    );
  }
}