import 'package:flutter/material.dart';
import 'package:wings_olympic_sr/constants/constant_variables.dart';
import 'package:wings_olympic_sr/reusable_widgets/language_textbox.dart';
import 'package:wings_olympic_sr/screens/sale/model/product_view.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';

class ThreeOptionButton extends StatelessWidget {
  final ViewComplexity value;
  final Function(ViewComplexity) onTap;

  const ThreeOptionButton({
    super.key,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ViewComplexity>(
      onSelected: (type) {
        onTap(type);
      },
      icon: _getIconByType(value),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: ViewComplexity.complex,
            child: Row(
              children: [
                _container(selected: false, rowCount: 4),
                const SizedBox(width: 4),
                LangText('Detailed view'),
                _checkIcon(visible: value == ViewComplexity.complex),
              ],
            ),
          ),
          PopupMenuItem(
            value: ViewComplexity.moderate,
            child: Row(
              children: [
                _container(selected: false, rowCount: 3),
                const SizedBox(width: 4),
                LangText('Moderate view'),
                _checkIcon(visible: value == ViewComplexity.moderate),
              ],
            ),
          ),
          PopupMenuItem(
            value: ViewComplexity.simple,
            child: Row(
              children: [
                _container(selected: false, rowCount: 2),
                const SizedBox(width: 4),
                LangText('Simple view'),
                _checkIcon(visible: value == ViewComplexity.simple),
              ],
            ),
          ),
        ];
      },
    );
    // return Container(
    //   padding: EdgeInsets.symmetric(
    //     horizontal: 8,
    //     vertical: 4,
    //   ),
    //   decoration: BoxDecoration(
    //     color: Colors.grey.shade300,
    //     borderRadius: BorderRadius.circular(4),
    //   ),
    //   child: Row(
    //     children: [
    //       InkWell(
    //         onTap: () {
    //           onTap(ProductView.maximumInfo);
    //         },
    //         child: _container(
    //           selected: value == ProductView.maximumInfo,
    //           rowCount: 4,
    //         ),
    //       ),
    //       4.horizontalSpacing,
    //       InkWell(
    //         onTap: () {
    //           onTap(ProductView.moderateInfo);
    //         },
    //         child: _container(
    //           selected: value == ProductView.moderateInfo,
    //           rowCount: 3,
    //         ),
    //       ),
    //       4.horizontalSpacing,
    //       InkWell(
    //         onTap: () {
    //           onTap(ProductView.lessInfo);
    //         },
    //         child: _container(
    //           selected: value == ProductView.lessInfo,
    //           rowCount: 2,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget _checkIcon({required bool visible}) {
    return Visibility(
      visible: visible,
      child: Row(
        children: [
          4.horizontalSpacing,
          Icon(Icons.check_circle, color: tealBlue, size: 16),
        ],
      ),
    );
  }

  Widget _container({
    required bool selected,
    required int rowCount,
    bool removePadding = false,
  }) {
    return Container(
      height: 32,
      width: 32,
      alignment: Alignment.center,
      padding: EdgeInsets.all(removePadding ? 2 : 6),
      decoration: BoxDecoration(
        // color: selected ? Colors.white : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: GridView.builder(
        itemCount: rowCount * rowCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: rowCount,
          childAspectRatio: 1,
          mainAxisSpacing: 5.00 - rowCount,
          crossAxisSpacing: 5.00 - rowCount,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: primary.withValues(alpha: .9),
              borderRadius: BorderRadius.circular(100),
            ),
          );
        },
      ),
    );
  }

  Widget _getIconByType(ViewComplexity type) {
    switch (type) {
      case ViewComplexity.complex:
        return _container(
          selected: false,
          rowCount: 4,
          removePadding: true,
        );
      case ViewComplexity.moderate:
        return _container(
          selected: false,
          rowCount: 3,
          removePadding: true,
        );
      case ViewComplexity.simple:
        return _container(
          selected: false,
          rowCount: 2,
          removePadding: true,
        );
    }
  }
}
