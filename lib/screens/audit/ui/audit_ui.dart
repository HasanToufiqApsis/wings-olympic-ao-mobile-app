import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/dashboard_btn_names.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/asset_requisition_model.dart';
import '../../../models/digital_learning/digital_learning_item.dart';
import '../../../models/point_model.dart';
import '../../../models/previous_requisition.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../utils/digital_learning_utils.dart';
import '../controller/digital_learning_controller.dart';

class AuditUI extends ConsumerStatefulWidget {
  const AuditUI({Key? key}) : super(key: key);
  static const routeName = "/audit_ui";

  @override
  ConsumerState<AuditUI> createState() => _AuditUIState();
}

class _AuditUIState extends ConsumerState<AuditUI> {
  final _appBarTitle = DashboardBtnNames.digitalLearning;
  late DigitalLearningController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DigitalLearningController(context: context, ref: ref);
    _controller.onControllerInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: _appBarTitle,
          heroTagTitle: _appBarTitle,
          heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
          titleImage: "digital_learning.png",
          onLeadingIconPressed: () {
            Navigator.pop(context);
          }),
      body: Consumer(builder: (context, ref, _) {
        AsyncValue<List<PointDetailsModel>> asyncAssetRequisitionList = ref.watch(getAllPointsProvider);

        return asyncAssetRequisitionList.when(
            data: (requestList) {
              if (requestList.isEmpty) {
                return Center(
                  child: LangText('No content available at this moment'),
                );
              }
              return ListView.separated(
                itemCount: requestList.length,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                itemBuilder: (BuildContext context, int index) {
                  var digitalLearningItem = requestList[index];
                  // final bool enable = data[index.toString()] ?? false;
                  return ListTile(
                    title: LangText(digitalLearningItem.name??""),
                    onTap: () async {
                      await _controller.onPointLocationItemTap(digitalLearningItem);
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              );
            },
            error: (error, _) => Container(),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                ));
      }),
    );
  }
}
