import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/outlet_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';

class ExistingPreorderUI extends ConsumerWidget {
   ExistingPreorderUI({required this.outlet, Key? key}) : super(key: key);
  OutletModel outlet;
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    AsyncValue<double> asyncPrice = ref.watch(getSkuPriceProvider(outlet));
    return asyncPrice.when(
        data: (price){
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              LangText(
                price.toStringAsFixed(2),
                isNumber: true,
                style: const TextStyle(
                  color: primary
                ),
              ),
              LangText(
                " ৳",
                style: const TextStyle(
                    color: primary
                ),
              ),
            ],
          );
        },
        error: (error, _)=> Container(),
        loading: ()=> Container()
    );
  }
}
