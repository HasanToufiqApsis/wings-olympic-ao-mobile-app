import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wings_olympic_sr/models/point_model.dart';
import 'package:wings_olympic_sr/screens/survey/survey_point_location_ui.dart';

import '../../../constants/enum.dart';
import '../../../models/digital_learning/digital_learning_item.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../services/before_sale_services/survey_service.dart';
import '../../../services/digital_learning_searvice.dart';
import '../../survey_digital_learning/ui/survey_digital_learning_ui.dart';
import '../ui/image_view_digital_learning.dart';
import '../ui/pdf_reader_digital_learning.dart';
import '../ui/video_player_digital_learning.dart';

class DigitalLearningController {
  BuildContext context;
  WidgetRef ref;
  late Alerts _alerts;

  DigitalLearningController({
    required this.context,
    required this.ref,
  })  : _alerts = Alerts(context: context),
        lang = ref.read(languageProvider);
  String lang = "বাংলা";

  final _digitalLearningService = DigitalLearningService();

  onControllerInit() {}

  void goToSurvey({required DigitalLearningItem data}) async {
    // _digitalLearningService.viewSingleDigitalLearningData(digitalLearningId: data.id);

    try {
      String fileExtantion = data.videoUrl.split('.').last.toLowerCase();

      if (fileExtantion == 'png' || fileExtantion == 'jpg' || fileExtantion == 'jpeg') {
        String fileUrl = data.videoUrl.split('/').last;

        await Navigator.pushNamed(context, ImageViewDigitalLearningUI.routeName, arguments: {
          "data": data,
          "file": fileUrl,
        }).then((value) {
          if (value == true) {
            Navigator.pushNamed(context, SurveyDigitalLearningUI.routeName, arguments: {'surveyModel': data});
          } else {
            _alerts.customDialog(type: AlertType.error, message: 'Please complete the video for next procedure');
          }
        });
      } else if (fileExtantion.toLowerCase() == 'mp4') {
        File? file = await _digitalLearningService.grtDigitalLearning(data.videoUrl.split('/').last, context);
        await Navigator.pushNamed(context, VideoPlayerDigitalLearningUI.routeName, arguments: {
          "data": data,
          "file": file,
        }).then((value) {
          if (value == true) {
            Navigator.pushNamed(context, SurveyDigitalLearningUI.routeName, arguments: {'surveyModel': data});
          } else {
            _alerts.customDialog(type: AlertType.error, message: 'Please complete the video for next procedure');
          }
        });
      } else if (fileExtantion.toLowerCase() == 'pdf') {
        String fileUrl = data.videoUrl.split('/').last;
        await Navigator.pushNamed(context, PdfReaderDigitalLearningUI.routeName, arguments: {
          "data": data,
          "file": fileUrl,
        }).then((value) {
          if (value == true) {
            Navigator.pushNamed(context, SurveyDigitalLearningUI.routeName, arguments: {'surveyModel': data});
          } else {
            _alerts.customDialog(type: AlertType.error, message: 'Please complete the video for next procedure');
          }
        });
      }
    } catch (e, t) {
      log(e.toString());
      log(t.toString());
    }
  }

  Future<void> onPointLocationItemTap(PointDetailsModel point) async {
    try {
      final list = await SurveyService().getPointWiseSurveyList(
        surveyIdList: point.availableSurveys ?? [],
      );

      for (var survey in list) {
        Navigator.of(context).pushNamed(
          SurveyPointLocationUI.routeName,
          arguments: {
            'pointId': point.id,
            'surveyModel': survey,
            'point': point,
          },
        );
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
  }
}
