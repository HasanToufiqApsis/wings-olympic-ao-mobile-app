import 'package:flutter/material.dart';
import 'package:wings_olympic_sr/constants/constant_variables.dart';

import '../../../services/asset_download/asset_service.dart';
import '../../../services/sync_read_service.dart';
import '../../../utils/extensions/widget_extensions.dart';
import '../model/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final bool read;
  final NotificationModel notificationModel;

  const NotificationTile({super.key, required this.read, required this.notificationModel});

  @override
  Widget build(BuildContext context) {
    final image = AssetService(context).superImage(
      '${notificationModel.productDetailsModel!.id}.png',
      folder: 'SKU',
      version: SyncReadService().getAssetVersion('SKU'),
      height: 48,
      width: 48,
      circular: true,
      // fit: BoxFit.fitHeight,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: read == false ? Colors.grey.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!read)
                Container(
                  height: 48,
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 10,
                    width: 10,
                    child: Container(
                      height: 9,
                      width: 9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: read ? Colors.transparent : red3,
                      ),
                    ),
                  ),
                ),
              if (read) 10.horizontalSpacing,
              4.horizontalSpacing,
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(48),
                      child: Container(
                        height: 48,
                        width: 48,
                        alignment: Alignment.center,
                        child: image,
                      ),
                    ),
                    12.horizontalSpacing,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          4.verticalSpacing,
                          Text(
                            notificationModel.title ??
                                notificationModel.productDetailsModel?.name ??
                                '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          8.verticalSpacing,
                          Text(
                            notificationModel.description??"",
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    12.horizontalSpacing,
                  ],
                ),
              ),
              14.horizontalSpacing,
            ],
          ),
        ),
      ),
    );
  }
}
