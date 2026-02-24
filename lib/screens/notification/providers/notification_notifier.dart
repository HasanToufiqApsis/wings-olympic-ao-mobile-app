import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wings_olympic_sr/screens/notification/service/notification_service.dart';

import '../model/notification_model.dart';

class NotificationNotifier extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  List<NotificationModel> notifications = [];
  int count = 0;
  NotificationNotifier() : super(const AsyncLoading()) {
    init();
  }

  Future init() async {
    NotificationService notificationService = NotificationService();
    notifications = await notificationService.getAllNotifications();
    state = AsyncData(notifications);
  }

  void readNotification(int id) async {
    await NotificationService().seanNotification(id);
    await init();
  }
}
