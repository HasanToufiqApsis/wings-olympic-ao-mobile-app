import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/notification_model.dart';
import 'notification_notifier.dart';


final notificationProvider = StateNotifierProvider.autoDispose<NotificationNotifier, AsyncValue<List<NotificationModel>>>((ref) {
  return NotificationNotifier();
});