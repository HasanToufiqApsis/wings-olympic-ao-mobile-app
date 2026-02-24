import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/main.dart';
import 'package:wings_olympic_sr/screens/verificartions/widgets/delete_sync_file_button.dart';
import 'package:wings_olympic_sr/screens/verificartions/widgets/language_change_button.dart';
import 'package:wings_olympic_sr/screens/verificartions/widgets/title_text.dart';
import 'package:wings_olympic_sr/services/sync_service.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';
import '../../../api/links.dart';
import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../constants/language_global.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../services/shared_storage_services.dart';
import '../../splash_screen/ui/splash_screen_ui.dart';
import '../controller/verification_controller.dart';

class LoginUI extends ConsumerStatefulWidget {
  const LoginUI({Key? key, this.loginStatus = LoginStatus.login_with_api}) : super(key: key);
  static const routeName = "/login_ui";
  final LoginStatus loginStatus;

  @override
  ConsumerState<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends ConsumerState<LoginUI> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final VerificationController _verificationController;
  late final Alerts _alerts;
  final SyncService _syncService = SyncService();

  late MediaQueryData _mediaQuery;

  @override
  void initState() {
    _verificationController = VerificationController(context: context, ref: ref);
    _verificationController.setPreviouslySavedUsername(_usernameController);
    _alerts = Alerts(context: context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mediaQuery = MediaQuery.of(context);
    final smallScreen = _mediaQuery.size.height < 600;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: _mediaQuery.size.height - (_mediaQuery.padding.top * 2),
          width: _mediaQuery.size.width,
          child: Stack(
            children: [
              /// Light blue card
              Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE1EFFE),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  32.verticalSpacing,
                  FooterText(),
                ],
              ),

              /// Image background
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  height: _mediaQuery.size.height / 2.2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/abc.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    height: _mediaQuery.size.height / 2.2,
                    decoration: BoxDecoration(
                        color: primary.withValues(alpha: .35),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        )),
                    child: Image(
                      image: const AssetImage("assets/wings_logo_white.png"),
                      width: _mediaQuery.size.width / 2,
                    ),
                  ),
                ),
              ),

              /// Input form
              Container(
                margin: EdgeInsets.only(
                  left: 28,
                  right: 28,
                  bottom: 100,
                  top: _mediaQuery.size.height / 3,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, _) {
                          final s = ref.watch(languageProvider);

                          Map banglaMap = {
                            "Write Username": "আপনার ইউজারনেমটি লিখুন",
                            "Write Password": "আপনার পাসওয়ার্ডটি লিখুন",
                          };
                          Map enMap = {
                            "Write Username": "Write Username",
                            "Write Password": "Write Password",
                          };
                          Map lang = {};
                          if (s == "en") {
                            lang = enMap;
                          } else {
                            lang = banglaMap;
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: smallScreen ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TitleText(text: lang['Write Username']),
                                  8.verticalSpacing,
                                  InputTextFields(
                                    textEditingController: _usernameController,
                                    hintText: lang['Write Username'] ?? '',
                                    maxLine: 1,
                                  ),
                                ],
                              ),
                              if (!smallScreen) 32.verticalSpacing,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TitleText(text: lang['Write Password']),
                                  8.verticalSpacing,
                                  Consumer(
                                    builder: (context, ref, _) {
                                      bool hidden = ref.watch(hideTextProvider);
                                      IconData suffix = !hidden ? Icons.visibility_off : Icons.visibility;
                                      return InputTextFields(
                                        textEditingController: _passwordController,
                                        hintText: lang['Write Password'] ?? '',
                                        obscureText: hidden,
                                        onTap: () {
                                          ref.read(hideTextProvider.notifier).state = !hidden;
                                        },
                                        suffixIcon: suffix,
                                        maxLine: 1,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    // login button
                    TextButtons(
                      label: "Login",
                      onPressed: () async {
                        // print("login status ${widget.loginStatus}");
                        await _verificationController.doLogin(
                            _usernameController.text, _passwordController.text, widget.loginStatus);
                        // Navigator.pushNamed(context, OutletDashboard.routeName);
                        // Navigator.pushNamed(context, routeName)
                      },
                    ),
                    if (!smallScreen) 16.verticalSpacing,
                  ],
                ),
              ),


              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    8.horizontalSpacing,
                    DeleteSyncFileButton(
                      onTap: _deleteSyncFile,
                    ),
                    Expanded(child: const SizedBox()),
                    LanguageChangeButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteSyncFile() async {
    _alerts.customDialog(
      type: AlertType.warning,
      description: "Are you sure you want to delete your data?",
      // message: "Danger",
      button1: "Yes",
      button2: "Cancel",
      twoButtons: true,
      onTap1: () async {
        await _syncService.deleteSync();
        navigatorKey.currentState
            ?.pushNamedAndRemoveUntil(SplashScreenUI.routeName, (route) => false);
      },
      onTap2: () async {
        Navigator.pop(context);
      },
    );
  }
}

class TextButtons extends StatelessWidget {
  const TextButtons({super.key, required this.label, required this.onPressed});

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(primary),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(verificationRadius),
          ),
        ),
      ),
      child: Center(
        child: LangText(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10.sp),
        ),
      ),
    );
  }
}

class FooterText extends StatelessWidget {
  const FooterText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LangText(
          "Wings SFA (v.$appVersionDeviceLog)",
          style: TextStyle(color: Colors.grey, fontSize: 8.sp),
        ),
        RichText(
          text: TextSpan(
            text: "App Developed by ",
            style: TextStyle(color: Colors.grey, fontSize: 8.sp),
            children: [
              TextSpan(
                text: "Apsis Solutions Limited",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 9.sp,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
