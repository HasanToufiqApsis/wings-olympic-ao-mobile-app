import 'package:flutter/material.dart';

import '../../../constants/constant_variables.dart';
import '../../../utils/extensions/widget_extensions.dart';

class SubmitTaDaNotificationTile extends StatelessWidget {
  const SubmitTaDaNotificationTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(48),
          child: Container(
            height: 48,
            width: 48,
            color: notificationAvatarBackgroundColor,
            alignment: Alignment.center,
            child: Text(
              "AB",
              style: TextStyle(
                color: notificationAvatarTextColor,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
        ),
        12.horizontalSpacing,
        Expanded(
          child: Column(
            children: [
              4.verticalSpacing,
              Row(
                children: [
                  Flexible(
                    child: RichText(
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'Ashwin Bose',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          TextSpan(text: ' has submitted'),
                          TextSpan(text: ' has submitted'),
                          TextSpan(text: ' has submitted'),
                          TextSpan(text: ' has submitted'),
                          TextSpan(text: ' has submitted'),
                          TextSpan(
                            text: ' TA/DA',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              8.verticalSpacing,
              Row(
                children: [
                  // PrimaryButton(
                  //   title: 'View',
                  //   smallSize: true,
                  // ),
                ],
              ),
            ],
          ),
        ),
        12.horizontalSpacing,
        Column(
          children: [
            Text(
              "15h",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: notificationAvatarTextColor,
                  ),
            ),
            Icon(Icons.more_horiz)
          ],
        )
      ],
    );
  }
}
