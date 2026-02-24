import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/screens/verificartions/ui/login_ui.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/assetModel.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../controller/update_controller.dart';


class UpdateFoundUI extends ConsumerStatefulWidget {
  final List<AssetModel> assetList;
  const UpdateFoundUI({Key? key, required this.assetList}) : super(key: key);
  static const routeName = "/update_found";

  @override
  _UpdateFoundUIState createState() => _UpdateFoundUIState();
}

class _UpdateFoundUIState extends ConsumerState<UpdateFoundUI> {
  late UpdateController _updateController;

  @override
  void initState() {
    super.initState();
    _updateController = UpdateController(context: context, ref: ref);
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
                    height: 3.h,
                  ),
                  Image.asset(
                    'assets/update_fount.png',
                    height: 40.h,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  LangText(
                    'Good News!',
                    style: TextStyle(color: primary, fontSize: 25.sp),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  SizedBox(
                    width: 50.w,
                    child: Center(
                      child: LangText(
                        'New update found. To use this app further more you have to update.',
                        textAlign: TextAlign.center,
                        style: TextStyle(overflow: TextOverflow.clip, fontSize: normalFontSize),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    height: 5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.sp),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [primary, primary],
                      ),
                    ),
                    child: ElevatedButton(
                        onPressed: () async {
                          _updateController.updateProcessSelection(widget.assetList);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ),
                        child: SizedBox(
                          height: 5.h,
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.system_update,
                                  color: Colors.white,
                                  size: 10.sp,
                                ),
                                SizedBox(
                                  width: 1.w,
                                ),
                                Center(
                                  child: LangText(
                                    'Update',
                                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                  ),
                  Consumer(
                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      String lang = ref.watch(languageProvider);
                      if(lang == "en"){
                        return Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: LangText(
                              'Current version SO App $appVersionDeviceLog',
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 9.sp),
                            ),
                          ),
                        );
                      }
                      else{
                        return Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: FooterText(),
                          ),
                        );
                      }
                    },
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
