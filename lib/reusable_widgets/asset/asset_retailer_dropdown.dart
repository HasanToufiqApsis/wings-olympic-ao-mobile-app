import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constant_variables.dart';
import '../../models/retailers_mdoel.dart';
import '../../provider/global_provider.dart';
import '../language_textbox.dart';

class AssetRetailerDropdown extends ConsumerStatefulWidget {
  final bool error;

  const AssetRetailerDropdown({
    super.key,
    this.error =false,
  });

  @override
  ConsumerState<AssetRetailerDropdown> createState() =>
      _AssetRetailerAlphaBoxState();
}

class _AssetRetailerAlphaBoxState extends ConsumerState<AssetRetailerDropdown> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.sp),
              color: Colors.white,
              border: Border.all(color: widget.error? primaryRed : Colors.transparent, width: 1)
            ),
            child: Consumer(builder: (context, ref, _) {
              // OutletModel? dropdownSelected = ref.watch(selectedRetailerProvider);
              AsyncValue<List<RetailersModel>> retailerList =
                  ref.watch(assetOutletListProvider);
              return retailerList.when(
                  data: (data) {
                    return Consumer(
                      builder: (BuildContext context, WidgetRef ref,
                          Widget? child) {
                        RetailersModel? dropdownSelected =
                            ref.watch(selectedSoRetailerProvider);
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 2),
                          child: Center(
                            child: DropdownButton<RetailersModel>(
                              hint: LangText(
                                'Select an outlet',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 8.sp),
                              ),
                              iconDisabledColor: Colors.transparent,
                              focusColor: Theme.of(context).primaryColor,
                              isExpanded: true,
                              value: dropdownSelected,
                              iconSize: 15.sp,
                              items: data.map((item) {
                                return DropdownMenuItem<RetailersModel>(
                                  value: item,
                                  child: FittedBox(
                                    child: Row(
                                      children: [
                                        // iconList(item.iconData),
                                        SizedBox(
                                          width: 1.w,
                                        ),
                                        LangText(
                                          '${item.outletName} (${item.oWNER})',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: normalFontSize),
                                        ),
                                        SizedBox(
                                          width: 1
                                              .w, // item.totalSale.toStringAsFixed(2)
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                              style: const TextStyle(color: Colors.black),
                              underline: Container(
                                height: 0,
                                color: Colors.transparent,
                              ),
                              onChanged: (val) {
                                ref
                                    .read(selectedSoRetailerProvider.notifier)
                                    .state = val;
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  error: (e, s) => LangText('$e'),
                  loading: () => const CircularProgressIndicator());
            }),
          ),
        ),
        // IconButton(
        //     onPressed: () {},
        //     icon: const Icon(
        //       Icons.info,
        //       color: Colors.grey,
        //     ))
      ],
    );
  }
}
