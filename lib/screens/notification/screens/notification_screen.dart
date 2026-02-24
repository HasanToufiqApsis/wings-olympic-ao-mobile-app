import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wings_olympic_sr/reusable_widgets/language_textbox.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

import '../../../reusable_widgets/custom_dialog.dart';
import '../controller/notification_controller.dart';
import '../model/notification_model.dart';
import '../providers/notification_provider.dart';
import '../widget/notification_tile.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  static const routeName = "notification_ui";
  const NotificationScreen({
    super.key,
  });

  @override
  ConsumerState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  late NotificationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = NotificationController(
      ref: ref,
    );
  }

  List<NotificationModel> cashNotification = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LangText("Notification"),
      ),
      body: Consumer(builder: (context, ref, child) {
        AsyncValue<List<NotificationModel>> asyncnotificationData =
            ref.watch(notificationProvider);
        return asyncnotificationData.when(
          // skipLoadingOnRefresh: false,
          data: (notifications) {
            cashNotification = notifications;
            return ListView(
              shrinkWrap: true,
              children: List.generate(notifications.length, (index) {
                return GestureDetector(
                  onTap: () {
                    // Ui.commonUi.showAwesomeDialog(
                    //   notifications[index].title ?? '',
                    //   notifications[index].description ?? '',
                    //   AppColor.primary700,
                    //   () {
                    //     Navigator.pop(context);
                    //   },
                    //   context,
                    //   videoPlay: notifications[index].notificationType == 'tutorial'? true : false,
                    //   onVideoTap: () {
                    //     _launchUrl(notifications[index].path?? "");
                    //   }
                    // );
                    // if ((notifications[index].read ?? true) == false) {
                    //   _controller.updateNotification(
                    //       notifications[index].id.toString());
                    // }
                    // readNotification
                    ref.read(notificationProvider.notifier).readNotification(notifications[index].id??0);
                  },
                  child: NotificationTile(
                    read: notifications[index].read ?? false,
                    notificationModel: notifications[index],
                  ),
                );
              }),
            );
          },
          error: (error, t) {
            log(error.toString());
            log(t.toString());
            return 0.horizontalSpacing;
          },
          loading: () {
            if (cashNotification.isNotEmpty) {
              return ListView(
                shrinkWrap: true,
                children: List.generate(cashNotification.length, (index) {
                  return NotificationTile(
                    read: cashNotification[index].read ?? false,
                    notificationModel: cashNotification[index],
                  );
                }),
              );
            }
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          },
        );
      }),
    );
  }



  Future<void> _launchUrl(String url) async {

    log("url is :: $url");
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
}
