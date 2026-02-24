import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/constant_variables.dart';

class DeleteSyncFileButton extends StatelessWidget {
  final Function() onTap;

  const DeleteSyncFileButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primary.withValues(alpha: .2),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          CupertinoIcons.delete_solid,
          color: yellow,
        ),
      ),
    );
  }
}
