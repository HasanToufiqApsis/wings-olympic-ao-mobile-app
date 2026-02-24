import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wings_olympic_sr/reusable_widgets/language_textbox.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

class SearchContainer extends StatelessWidget {
  final Function() onTap;

  const SearchContainer({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          )
        ),
        child: Row(
          children: [
            Icon(CupertinoIcons.search, color: Colors.grey.shade400),
            8.horizontalSpacing,
            LangText('Search...'),
          ],
        ),
      ),
    );
  }
}
