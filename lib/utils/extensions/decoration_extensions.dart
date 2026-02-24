import '../../models/module.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constant_variables.dart';

extension DecorationExtension on Module? {
  Decoration get titleBackgroundDecoration => this == null
      ? BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(5.sp)),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              primaryBlue,
              primaryBlue,
            ],
          ),
          color: Colors.grey[100],
        )
      : BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(5.sp)),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              // moduleColor[this!.id]![1],
              // moduleColor[this!.id]![0],
              moduleColor[1]![1],
              moduleColor[1]![0],
            ],
          ),
          color: Colors.grey[100],
        );

  Decoration get bottomBackgroundDecoration => this == null
      ? BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(5.sp),
            bottomLeft: Radius.circular(5.sp),
          ),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              primaryBlue,
              primaryBlue,
            ],
          ),
          color: Colors.grey[100],
        )
      : BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(5.sp),
            bottomLeft: Radius.circular(5.sp),
          ),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              // moduleColor[this!.id]![0],
              // moduleColor[this!.id]![1],
              moduleColor[1]![0],
              moduleColor[1]![1],
            ],
          ),
          color: Colors.grey[100],
        );

  Decoration get totalBackgroundDecoration => this == null
      ? BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(5.sp),
            bottomLeft: Radius.circular(5.sp),
            topRight: Radius.circular(5.sp),
          ),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              primaryBlue,
              primaryBlue,
            ],
          ),
          color: Colors.grey[100],
        )
      : BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(5.sp),
            bottomLeft: Radius.circular(5.sp),
            topRight: Radius.circular(5.sp),
          ),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              // moduleColor[this!.id]![1],
              // moduleColor[this!.id]![0],
              moduleColor[1]![1],
              moduleColor[1]![0],
            ],
          ),
          color: Colors.grey[100],
        );

  Decoration get titleMemoBackgroundDecoration => this == null
      ? BoxDecoration(
    // borderRadius: BorderRadius.only(topRight: Radius.circular(5.sp)),
    gradient: const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        primaryBlue,
        primaryBlue,
      ],
    ),
    color: Colors.grey[100],
  )
      : BoxDecoration(
    // borderRadius: BorderRadius.only(topRight: Radius.circular(5.sp)),
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        // moduleColor[this!.id]![1],
        // moduleColor[this!.id]![0],
        moduleColor[1]![1],
        moduleColor[1]![0],
      ],
    ),
    color: Colors.grey[100],
  );

  Decoration get bottomMemoBackgroundDecoration => this == null
      ? BoxDecoration(
    // borderRadius: BorderRadius.only(
    //   bottomRight: Radius.circular(5.sp),
    //   bottomLeft: Radius.circular(5.sp),
    // ),
    gradient: const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        primaryBlue,
        primaryBlue,
      ],
    ),
    color: Colors.grey[100],
  )
      : BoxDecoration(
    // borderRadius: BorderRadius.only(
    //   bottomRight: Radius.circular(5.sp),
    //   bottomLeft: Radius.circular(5.sp),
    // ),
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        // moduleColor[this!.id]![0],
        // moduleColor[this!.id]![1],
        moduleColor[1]![0],
        moduleColor[1]![1],
      ],
    ),
    color: Colors.grey[100],
  );

  Decoration get totalMemoBackgroundDecoration => this == null
      ? BoxDecoration(
    // borderRadius: BorderRadius.only(
    //   bottomRight: Radius.circular(5.sp),
    //   bottomLeft: Radius.circular(5.sp),
    //   topRight: Radius.circular(5.sp),
    // ),
    gradient: const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        primaryBlue,
        primaryBlue,
      ],
    ),
    color: Colors.grey[100],
  )
      : BoxDecoration(
    // borderRadius: BorderRadius.only(
    //   bottomRight: Radius.circular(5.sp),
    //   bottomLeft: Radius.circular(5.sp),
    //   topRight: Radius.circular(5.sp),
    // ),
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        // moduleColor[this!.id]![1],
        // moduleColor[this!.id]![0],
        moduleColor[1]![1],
        moduleColor[1]![0],
      ],
    ),
    color: Colors.grey[100],
  );
}
