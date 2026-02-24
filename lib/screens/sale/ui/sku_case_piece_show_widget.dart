import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/products_details_model.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../utils/case_piece_type_utils.dart';

class SKUCasePieceShowWidget extends StatelessWidget {
  const SKUCasePieceShowWidget({
    Key? key,
    required this.sku,
    required this.qty,
    this.showUnitName = false,
    this.qtyTextStyle,
    this.unitTextStyle,
    this.alignment,
    this.casePieceType = CasePieceType.CASE,
    this.pieceWithQty = false,
    this.verticalView = false,
  }) : super(key: key);
  final ProductDetailsModel sku;
  final int qty;
  final bool showUnitName;
  final TextStyle? qtyTextStyle;
  final TextStyle? unitTextStyle;
  final MainAxisAlignment? alignment;
  final CasePieceType casePieceType;
  final bool pieceWithQty;
  final bool verticalView;

  @override
  Widget build(BuildContext context) {
    int caseCount = qty ~/ sku.packSize;
    int pieceCount = qty - (caseCount * sku.packSize);
    String caseLabel = sku.packSize == 1 ? CasePieceTypeUtils.toStr(CasePieceType.PIECE) : CasePieceTypeUtils.toStr(CasePieceType.CASE);

    if (pieceWithQty) {
      return Row(
        mainAxisAlignment: alignment ?? MainAxisAlignment.center,
        children: [
          LangText(
            casePieceType == CasePieceType.CASE ? caseCount.toString() : qty.toString(),
            isNumber: true,
            style: qtyTextStyle ?? TextStyle(fontSize: 15.sp, color: darkGrey, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.only(left: 3.0.sp),
            child: LangText(
              "Pcs",
              style: unitTextStyle,
            ),
          )
        ],
      );
    }

    if (showUnitName) {
      if (verticalView) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: caseCount > 0,
              child: LangText(
                caseCount.toString(),
                isNumber: true,
                style: qtyTextStyle ?? TextStyle(fontSize: 15.sp, color: darkGrey, fontWeight: FontWeight.bold),
              ),
            ),
            Visibility(
              visible: caseCount > 0,
              child: Padding(
                padding: EdgeInsets.only(left: 3.0.sp),
                child: LangText(
                  caseLabel,
                  style: unitTextStyle,
                ),
              ),
            ),
            if (pieceCount > 0)
              LangText(
                "${caseCount > 0 ? '' : ''}${pieceCount.toString()}",
                isNumber: true,
                style: qtyTextStyle ?? TextStyle(fontSize: 15.sp, color: darkGrey, fontWeight: FontWeight.bold),
              ),
            if (pieceCount > 0)
              Padding(
                padding: EdgeInsets.only(left: 3.0.sp),
                child: LangText(
                  "Pcs",
                  style: unitTextStyle,
                ),
              )
          ],
        );
      }
      return Row(
        mainAxisAlignment: alignment ?? MainAxisAlignment.center,
        children: [
          Visibility(
            visible: caseCount > 0,
            child: LangText(
              caseCount.toString(),
              isNumber: true,
              style: qtyTextStyle ?? TextStyle(fontSize: 15.sp, color: darkGrey, fontWeight: FontWeight.bold),
            ),
          ),
          Visibility(
            visible: caseCount > 0,
            child: Padding(
              padding: EdgeInsets.only(left: 3.0.sp),
              child: LangText(
                caseLabel,
                style: unitTextStyle,
              ),
            ),
          ),
          if (pieceCount > 0)
            LangText(
              "${caseCount > 0 ? ' ,' : ''}${pieceCount.toString()}",
              isNumber: true,
              style: qtyTextStyle ?? TextStyle(fontSize: 15.sp, color: darkGrey, fontWeight: FontWeight.bold),
            ),
          if (pieceCount > 0)
            Padding(
              padding: EdgeInsets.only(left: 3.0.sp),
              child: LangText(
                "Pcs",
                style: unitTextStyle,
              ),
            )
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: alignment ?? MainAxisAlignment.center,
        children: [
          LangText(
            casePieceType == CasePieceType.CASE ? caseCount.toString() : qty.toString(),
            isNumber: true,
            style: qtyTextStyle ?? TextStyle(fontSize: 15.sp, color: darkGrey, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }
  }
}

class UnitWiseCountWidget extends StatelessWidget {
  const UnitWiseCountWidget({Key? key, required this.unitName, required this.count, this.qtyTextStyle, this.unitTextStyle}) : super(key: key);
  final String unitName;
  final int count;
  final TextStyle? qtyTextStyle;
  final TextStyle? unitTextStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LangText(
          count.toString(),
          isNumber: true,
          style: qtyTextStyle ?? TextStyle(fontSize: 15.sp, color: darkGrey, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: EdgeInsets.only(left: 3.0.sp),
          child: LangText(
            unitName,
            style: unitTextStyle,
          ),
        ),
        SizedBox(
          width: 1.5.w,
        )
      ],
    );
  }
}
