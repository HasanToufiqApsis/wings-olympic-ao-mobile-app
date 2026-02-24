import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/dashboard_btn_names.dart';
import 'package:wings_olympic_sr/utils/extensions/date_extension.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../models/pjp_plan_details.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../widget/pjp_plan_item_widget.dart';
import 'pjp_plan_explanation_ui.dart';

class PjpPlanUI extends ConsumerStatefulWidget {
  const PjpPlanUI({
    Key? key,
  }) : super(key: key);
  static const routeName = "/pjp_plan_ui";

  @override
  ConsumerState<PjpPlanUI> createState() => _PjpPlanUIState();
}

class _PjpPlanUIState extends ConsumerState<PjpPlanUI> {
  final _appBarTitle = DashboardBtnNames.pJPPlan;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _appBarTitle,
        heroTagTitle: _appBarTitle,
        heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
        titleImage: "pjp_plan.png",
        showLeading: true,
      ),
      body: Column(
        children: [
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final selectedPickedDateRange =
                  ref.watch(selectedDateRangeProvider);
              return InkWell(
                onTap: () async {
                  final pickedRange = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(DateTime.now().year - 1, 1, 1),
                    lastDate: DateTime(DateTime.now().year + 1, 12, 31),
                  );
                  if (pickedRange != null) {
                    ref.read(selectedDateRangeProvider.notifier).state =
                        pickedRange;
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 9.sp),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(verificationRadius),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: LangText(
                          "${selectedPickedDateRange.start.toString().dayMonthYear} - ${selectedPickedDateRange.end.toString().dayMonthYear}",
                        ),
                      ),
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: Consumer(builder: (context, ref, _) {
              AsyncValue<List<PJPPlanDetails>> asyncDeliverySummaryFeature =
                  ref.watch(fullMonthPjpPlanProvider);

              return asyncDeliverySummaryFeature.when(
                  data: (deliverySummery) {
                    if (deliverySummery.isEmpty) {
                      return Center(
                        child: LangText('No PJP plan available at this moment'),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      itemCount: deliverySummery.length,
                      itemBuilder: (BuildContext context, int index) {
                        var data = deliverySummery[index];
                        return PjpPlanItemWidget(
                          index: index,
                          data: data,
                          onTap: () {
                            Navigator.pushNamed(context, PjpPlanExplanationUI.routeName, arguments: data);
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 16,
                        );
                      },
                    );
                  },
                  error: (error, _) => Container(),
                  loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ));
            }),
          ),
        ],
      ),
    );
  }
}
