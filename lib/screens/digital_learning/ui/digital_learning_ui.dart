import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/dashboard_btn_names.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/asset_requisition_model.dart';
import '../../../models/digital_learning/digital_learning_item.dart';
import '../../../models/previous_requisition.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../utils/digital_learning_utils.dart';
import '../controller/digital_learning_controller.dart';

class DigitalLearningUI extends ConsumerStatefulWidget {
  const DigitalLearningUI({Key? key}) : super(key: key);
  static const routeName = "/digital_learning_ui";

  @override
  ConsumerState<DigitalLearningUI> createState() => _AssetRoUIState();
}

class _AssetRoUIState extends ConsumerState<DigitalLearningUI> {
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
        AsyncValue<List<DigitalLearningItem>> asyncAssetRequisitionList = ref.watch(getAllDigitalLearnings);

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
                  return InkWell(
                    onTap: () async {
                      _controller.goToSurvey(data: digitalLearningItem);
                    },
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: 5.circularRadius,
                            color: Colors.black12,
                          ),
                          height: 100,
                          width: 140,
                          child: Icon(
                            digitalLearningItem.type == DigitalLearningType.video
                                ? Icons.play_circle_fill_rounded
                                : digitalLearningItem.type == DigitalLearningType.image
                                    ? Icons.image
                                    : Icons.picture_as_pdf_rounded,
                            size: 46,
                            color: primary,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  digitalLearningItem.name ?? 'AFBL Promotion',
                                  style: TextStyle(
                                    fontSize: mediumFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                7.verticalSpacing,
                                Text(
                                  digitalLearningItem.type == DigitalLearningType.video
                                      ? 'Video'
                                      : digitalLearningItem.type == DigitalLearningType.image
                                          ? 'Image'
                                          : 'PDF',
                                  style: TextStyle(fontSize: smallFontSize, color: grey),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
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
