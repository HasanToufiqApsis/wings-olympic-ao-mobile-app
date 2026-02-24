import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:wings_olympic_sr/screens/notification/model/notification_model.dart';
import 'package:wings_olympic_sr/services/product_category_services.dart';

import '../../../constants/sync_global.dart';
import '../../../services/sync_service.dart';


class NotificationService {
  final _productCategoryService = ProductCategoryServices();
  final _syncService = SyncService();

  Future<List<NotificationModel>> getAllNotifications() async {
    List<NotificationModel> notificationList = [];
    await _syncService.checkSyncVariable();
    
    try {
      if (syncObj.containsKey('notifications')) {
        List<dynamic> notifications = syncObj['notifications'] ?? [];
        
        for (var notificationData in notifications) {
          NotificationModel notification = NotificationModel.fromJson(notificationData);
          notification.description = notificationData['description'];
          
          // Check if message_type is new_product and get product details
          if (notification.messageType == 'new_product' && 
              notificationData.containsKey('other_data') && 
              notificationData['other_data'] != null) {
            
            int? productId = notificationData['other_data']['id'];
            if (productId != null) {
              final productDetails =
                  await _productCategoryService.getSkuDetailsFromSkuId(productId);
              notification.productDetailsModel = productDetails;
              notification.sku = productId;
            }
          }
          
          notificationList.add(notification);
        }
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    
    return notificationList;
  }

  Future seanNotification(int id) async {
    if (syncObj.containsKey('notifications')) {
      List notifications = syncObj['notifications'] ?? [];
      int index = notifications.indexWhere((element) => element['id'] == id);
      if (index != -1) {
        syncObj['notifications'][index]['is_viewed'] = 1;
        await _syncService.writeSync(jsonEncode(syncObj));
      }
    }
  }
}