import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import '../../../models/digital_learning/digital_learning_item.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../services/asset_download/asset_service.dart';
import 'package:widget_zoom/widget_zoom.dart';

class ImageViewDigitalLearningUI extends StatefulWidget {
  static const routeName = '/imageDigitalLearning';
  final String file;
  final DigitalLearningItem item;
  final bool? skip;

  const ImageViewDigitalLearningUI({Key? key, required this.item, required this.file, this.skip}) : super(key: key);

  @override
  _ImageViewDigitalLearningUIState createState() => _ImageViewDigitalLearningUIState();
}

class _ImageViewDigitalLearningUIState extends State<ImageViewDigitalLearningUI> {
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
    DigitalLearningItem av = widget.item;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Digital Learning",
          titleImage: "digital_learning.png",
          onLeadingIconPressed: () {
            Navigator.pop(context, true);
          },
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: Icon(
                Icons.close_rounded,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: Center(
          child: WidgetZoom(
            zoomWidget: SizedBox(
              width: 100.w,
              child: AssetService(context).superImage(
                widget.file,
                folder: "digital_learning",
              ),
            ),
            heroAnimationTag: '',
          ),
        ),
      ),
    );
  }
}
