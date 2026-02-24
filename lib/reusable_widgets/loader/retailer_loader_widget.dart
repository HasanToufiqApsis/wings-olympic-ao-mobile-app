import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constant_variables.dart';
import '../language_textbox.dart';

class RetailerLoaderWidget extends StatelessWidget {
  const RetailerLoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownMenuItem<String>(
      value: '',
      child: Row(
        children: [
          SizedBox(width: 2.w,),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey[300],
            ),
            child: Text(
              "item.retailerName",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.transparent, fontSize: normalFontSize),
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey[300],
            ),
            child: Icon(Icons.ac_unit, size: 15.sp, color: Colors.transparent,),
          ),
          SizedBox(width: 2.5.w,)
        ],
      ),
    );
  }
}
