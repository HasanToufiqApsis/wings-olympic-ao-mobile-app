
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constant_variables.dart';
import '../../provider/global_provider.dart';
import '../language_textbox.dart';

class AssetRetailerAlphaBox extends ConsumerStatefulWidget {
  const AssetRetailerAlphaBox({super.key});

  @override
  ConsumerState<AssetRetailerAlphaBox> createState() => _AssetRetailerAlphaBoxState();
}

class _AssetRetailerAlphaBoxState extends ConsumerState<AssetRetailerAlphaBox> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      List<String> alphabetList = ref.watch(alphabetListProvider);
      String? selected = ref.watch(selectedAlphabetProvider);

      return Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(vertical: 0.0.h),

        margin: EdgeInsets.symmetric(horizontal: 10.sp),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.sp),
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.5, 1],
                colors: [primary, red3])),
        child: DefaultTextStyle(
          style: TextStyle(color: Colors.white, fontSize: normalFontSize),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(
                alphabetList.length,
                    (index) => FittedBox(
                  child: InkWell(
                    onTap: () {
                      ref.read(assetOutletListProvider.notifier).searchByFirstLetter(alphabetList[index]);
                      ref.refresh(selectedSoRetailerProvider);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(2.sp),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 1.h, vertical: 1.h),
                        decoration: (selected == alphabetList[index])
                            ? BoxDecoration(
                          borderRadius: BorderRadius.circular(5.sp),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [green, darkGreen],
                          ),
                        )
                            : null,
                        child: Center(
                          child: LangText(
                            alphabetList[index].toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
