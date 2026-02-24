import 'package:flutter/material.dart';

import '../../models/products_details_model.dart';
import '../../screens/sale/ui/sku_case_piece_show_widget.dart';
import '../../utils/case_piece_type_utils.dart';
import '../language_textbox.dart';

class ExaminePurchaseSkuRow extends StatelessWidget {
  final ProductDetailsModel product;

  const ExaminePurchaseSkuRow({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: LangText(
              product.shortName,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: SKUCasePieceShowWidget(
                sku: product,
                qty: product.preorderData!.qty,
                showUnitName: true,
                unitTextStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                qtyTextStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: LangText(
                product.preorderData!.price.toStringAsFixed(2),
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
