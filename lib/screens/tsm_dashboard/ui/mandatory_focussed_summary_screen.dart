import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/constant_variables.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../providers/tsm_dahboard_providers.dart';
import 'sku_summary_page.dart';

class MandatoryFocussedSummaryScreen extends ConsumerStatefulWidget {
  static const routeName = 'MandatoryFocussedSummaryScreen';

  const MandatoryFocussedSummaryScreen({super.key});

  @override
  ConsumerState createState() => _MandatoryFocussedSummaryScreenState();
}

class _MandatoryFocussedSummaryScreenState extends ConsumerState<MandatoryFocussedSummaryScreen> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin{

  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: "SKU Summary",
        // titleImage: "asset.png",
        onLeadingIconPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final asyncData = ref.watch(mandatoryFocussedDataProvider);

          return asyncData.when(
            data: (summaryList){

              final mandatoryList = summaryList.where((item) => item.filterType == 'MANDATORY').toList();
              final focussedList = summaryList.where((item) => item.filterType == 'FOCUSED').toList();
              final othersList = summaryList.where((item) => item.filterType == 'OTHERS').toList();

              return Column(
                children: [
                  const SizedBox(height: 8),
                  TabBar(
                    controller: _tabController,
                    physics: const BouncingScrollPhysics(),
                    indicatorColor: primary,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator:
                    BoxDecoration(color: primary, borderRadius: BorderRadius.circular(5)),
                    labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    indicatorPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    padding: EdgeInsets.zero,
                    unselectedLabelStyle: const TextStyle(color: Colors.blueGrey),
                    tabs: [
                      Tab(
                        child: LangText(
                          'Mandatory',
                        ),
                      ),
                      Tab(
                        child: LangText(
                          'Focussed',
                        ),
                      ),
                      Tab(
                        child: LangText(
                          'Others',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        SkuSummaryPage(summaryList: mandatoryList),
                        SkuSummaryPage(summaryList: focussedList),
                        SkuSummaryPage(summaryList: othersList),
                      ],
                    ),
                  ),
                ],
              );
            },
            error: (error, stck) => const SizedBox(),
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
