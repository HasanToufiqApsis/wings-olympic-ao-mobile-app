import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/reusable_widgets/circular_progress_painter.dart';

import '../../../constants/constant_variables.dart';
import '../../../main.dart';
import '../../../models/assetModel.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/shapes/circular_progress_painter.dart';
import '../../../services/asset_download/asset_download_service.dart';
import '../../outlet_informations/ui/home_dashboard.dart';
import 'spinning_wheel.dart';

class UpdatingUI extends ConsumerStatefulWidget {
  final List<AssetModel> bulkList;
  final num count;

  const UpdatingUI({Key? key, required this.bulkList, required this.count})
      : super(key: key);
  static const routeName = "/updating";

  @override
  _UpdatingUIState createState() => _UpdatingUIState();
}

class _UpdatingUIState extends ConsumerState<UpdatingUI> {
  late final AssetDownloadService assetDownloadService;
  late List<AssetModel> bulkList;
  late num count;

  @override
  void initState() {
    super.initState();
    bulkList = widget.bulkList;
    count = widget.count;
    assetDownloadService = AssetDownloadService(context, ref: ref);
    downloadProcess();
  }

  @override
  Widget build(BuildContext context) {
    int x = ref.watch(progressProvider.state).state;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  // SizedBox(height: 40.h, width: 40.h, child: SpinningWheel()),
                  SizedBox(
                    height: 5.h,
                  ),
                  LangText(
                    'The app is updating',
                    style: TextStyle(color: primary.withOpacity(0.4), fontSize: 25.sp),
                  ),
                  SizedBox(
                    height: 48,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 1.5,
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: CustomPaint(
                      // painter: CircularProgressPainter(
                      //   lineColor: Colors.redAccent.withOpacity(.2),
                      //   completeColor: const Color(0xFF59F39B),
                      //   completedGradientColor: const [
                      //     primary,
                      //     primary,
                      //   ],
                      //   completePercent: (x*100)/count,
                      //   width: 6,
                      // ),
                      painter: CustomCircularProgressPainter(
                        progress: ((x * 100) / count)/100,
                        color: primary,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Lottie.asset('assets/lottie/download.json'),
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   height: 2.h,
                  //   width: 100.w,
                  //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.sp), color: Colors.grey[200]),
                  //   child: Stack(
                  //     children: [
                  //       Container(
                  //         height: 2.h,
                  //         width: (x * 90.w / count),
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(5.sp),
                  //           gradient: LinearGradient(
                  //             begin: Alignment.centerLeft,
                  //             end: Alignment.centerRight,
                  //             colors: [darkGreen, green],
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LangText(
                          'Processing',
                          style: TextStyle(
                              color: primary, fontSize: normalFontSize),
                        ),
                        LangText(
                          '($x/$count)',
                          isNumber: true,
                          isNum: false,
                          style: TextStyle(
                              color: primary, fontSize: normalFontSize),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: LangText(
                        'Warning: Do not turn off the app',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  downloadProcess() async {
    for (var i in bulkList) {
      await assetDownloadService
          .bulkDownload(folder: i.slug, version: i.version, files: i.assets)
          .then((value) {});
    }
    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(HomeDashboard.routeName, (route) => false);
  }
}
