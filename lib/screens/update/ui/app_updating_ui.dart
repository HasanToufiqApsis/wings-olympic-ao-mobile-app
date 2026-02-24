import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/shapes/circular_progress_painter.dart';
import 'spinning_wheel.dart';


class AppUpdatingUI extends ConsumerStatefulWidget {
  // final List<AssetModel> bulkList;
  // final num count;
  const AppUpdatingUI({Key? key, required this.url}) : super(key: key);
  static const routeName = "/app_updating";
  final String url;
  @override
  _UpdatingUIState createState() => _UpdatingUIState();
}

class _UpdatingUIState extends ConsumerState<AppUpdatingUI> {

  bool? success ;

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
    //   success = await UpdateController(context: context,ref: ref).updateApp(widget.url);
    //   if(success==false){
    //     setState((){});
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
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
                  SizedBox(height: 40.h, width: 40.h, child: SpinningWheel()),
                  SizedBox(
                    height: 5.h,
                  ),
                  LangText(
                    'The app is updating',
                    style: TextStyle(color: red3, fontSize: 25.sp),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),

                Consumer(
                  builder: (context,ref,_) {
                    int updateStatus = ref.watch(apkUpdateProgressProvider);
                    print("update status 1 $updateStatus");

                    return SizedBox(
                      height: MediaQuery.of(context).size.width / 1.5,
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: CustomPaint(
                        painter: CircularProgressPainter(
                          lineColor: Colors.redAccent.withOpacity(.2),
                          completeColor: const Color(0xFF59F39B),
                          completedGradientColor: const [
                            primary,
                            primary,
                          ],
                          completePercent: updateStatus.toDouble(),
                          width: 6,
                          showProgressShadow: true,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Lottie.asset('assets/lottie/download.lottie'),
                          ),
                        ),
                      ),
                    );

                    return Container(
                        height: 2.h,
                        width: 100.w,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.sp), color: Colors.grey[200]),
                        child:     Stack(
                          children: [
                            Container(
                              height: 2.h,
                              width: (updateStatus * 90.w / 100),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.sp),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [darkGreen, green],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                  }
                ),

                  SizedBox(
                    height: 3.h,
                  ),
                  Consumer(
                    builder: (context, ref,_) {
                      int updateStatus = ref.watch(apkUpdateProgressProvider);
                      print("update status 2 $updateStatus");
                      return Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LangText(
                              'Processing',
                              style: TextStyle(color: red3, fontSize: normalFontSize),
                            ),
                            LangText(
                              ' $updateStatus%/100%',
                              isNumber: true,
                              isNum: false,
                              style: TextStyle(color: red3, fontSize: normalFontSize),
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: LangText(
                        'Warning: Do not turn off the app',
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, color: Colors.red),
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

}
