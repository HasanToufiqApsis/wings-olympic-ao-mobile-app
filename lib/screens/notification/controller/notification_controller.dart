import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationController {
  final WidgetRef _ref;

  NotificationController({required WidgetRef ref}) : _ref = ref;

  updateNotification(String id) async {
    // ResponseModel responseModel = await _notificationRepository.readNotifications(id);
    //
    // _ref.refresh(notificationProvider);
  }
}
