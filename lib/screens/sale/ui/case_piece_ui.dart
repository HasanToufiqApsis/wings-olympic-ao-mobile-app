import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/products_details_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../utils/case_piece_type_utils.dart';

class CasePieceUI extends ConsumerWidget {
  final ProductDetailsModel sku;
  const CasePieceUI({required this.sku, Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If no unit config available, show nothing
    if (sku.unitConfig.isEmpty) {
      return SizedBox.shrink();
    }
    
    return Container(
      height: 4.h,
      padding: EdgeInsets.only(left: 3.w),
      child: Row(
        children: sku.unitConfig.map((unitConfig) => getSelectUnitButton(unitConfig, ref)).toList(),
      ),
    );
  }
  
  Widget getSelectUnitButton(SkuUnitItem unitConfig, WidgetRef ref){
    return Padding(
      padding: EdgeInsets.only(right: 3.w),
      child: Consumer(
          builder: (context,ref,_) {
            SkuUnitItem? selected = ref.watch(selectedSkuUnitConfigProvider(sku));
          return InkWell(
            onTap: (){
              ref.read(selectedSkuUnitConfigProvider(sku).notifier).state = unitConfig;
            },
            child: Container(
              height: 3.h,
              // width: 18.w,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft, 
                    end: Alignment.bottomRight,  
                    colors: unitConfig != selected ? [primaryGrey, primaryGrey] : [primary, red3]
                  ),
                  borderRadius: BorderRadius.circular(5.sp),
                  border: Border.all(color: primary)
              ),
              padding: EdgeInsets.symmetric(horizontal: 1.5.w,vertical: 1.w),
              child: Center(
                child: Text(
                  unitConfig.packType ?? 'Unit',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: unitConfig != selected ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 9.sp
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
