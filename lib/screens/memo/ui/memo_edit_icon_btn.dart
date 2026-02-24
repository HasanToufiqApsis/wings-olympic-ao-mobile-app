import 'package:flutter/material.dart';

class MemoEditIconBtn extends StatelessWidget {
  final Function()? onTap;
  final Color? bgc;
  final Color? iconColor;

  const MemoEditIconBtn({
    super.key,
    this.onTap,
    this.bgc,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: bgc,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        alignment: Alignment.center,
        child: Icon(Icons.edit, color: iconColor, size: 20,),
      ),
    );
  }
}
