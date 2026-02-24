import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../verificartions/controller/verification_controller.dart';

class SplashScreenUI extends ConsumerStatefulWidget {
  const SplashScreenUI({Key? key}) : super(key: key);

  static const routeName = "/splash_screen";

  @override
  ConsumerState<SplashScreenUI> createState() => _SplashScreenUIState();
}

class _SplashScreenUIState extends ConsumerState<SplashScreenUI> {

  late final VerificationController _verificationController;

  @override
  void initState(){
    _verificationController = VerificationController(context: context, ref: ref);
    goto();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [primary, primaryBlue], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        height: 100.h,
        width: 100.w,
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            LangText(
              "Please wait for a moment",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: bigMediumFontSize),
            ),
            SizedBox(
              height: 2.h,
            ),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ]),
        ),
      ),
    );
  }

  goto() async {
    _verificationController.checkLogin();
  }
}
