import '../../../models/products_details_model.dart';

class NotificationModel {
  int? id;
  String? notificationType;
  String? messageType;
  String? title;
  bool? read;
  String? description;
  int? sku;
  ProductDetailsModel? productDetailsModel;

  NotificationModel({
    this.id,
    this.notificationType,
    this.messageType,
    this.title,
    this.read,
    this.description,
    this.sku,
    this.productDetailsModel,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    bool isView = (json['is_viewed'] ?? 0) == 1 ? true : false;
    id = json['id'];
    notificationType = json['notification_type'];
    messageType = json['message_type'];
    title = json['title'];
    read = isView;
    sku = json['sku'];
  }
}
