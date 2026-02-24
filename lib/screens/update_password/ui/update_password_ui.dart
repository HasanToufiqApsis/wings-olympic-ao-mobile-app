import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import '../../../constants/enum.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../verificartions/ui/login_ui.dart';
import '../controller/update_password_controller.dart';

class UpdatePasswordUI extends ConsumerStatefulWidget {
  const UpdatePasswordUI({
    Key? key,
  }) : super(key: key);
  static const routeName = "/update_password_ui";

  @override
  ConsumerState<UpdatePasswordUI> createState() => _UpdatePasswordUIState();
}

class _UpdatePasswordUIState extends ConsumerState<UpdatePasswordUI> {
  GlobalWidgets globalWidgets = GlobalWidgets();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _reEnterNewPasswordController = TextEditingController();
  late UpdatePasswordController _controller;

  bool hiddenP = true;
  bool hiddenNP = true;
  bool hiddenCNP = true;

  @override
  void initState() {
    _controller = UpdatePasswordController(context: context, ref: ref);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _newPasswordController.dispose();
    _reEnterNewPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Update Password",
        // titleImage: "pre_order_button.png",
        showLeading: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.h),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: SizedBox(
                  width: 100.w,
                  child: globalWidgets.showInfo(
                      message:
                          'Password must be at-least 3 digits long'),
              ), //You can see a memo by selecting outlet.
            ),
          ),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              String lang = ref.watch(languageProvider);
              String hint = "Current Password";
              if (lang != "en") {
                hint = "বর্তমান পাসওয়ার্ড";
              }
              return VerificationTextField(
                textEditingController: _passwordController,
                hintText: hint,
                obscureText: hiddenP,
                onTap: () {
                  setState(() {
                    hiddenP = !hiddenP;
                  });
                },
                suffix: hiddenP ? Icons.visibility_off : Icons.visibility,
              );
            },
          ),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              String lang = ref.watch(languageProvider);
              String hint = "New password";
              if (lang != "en") {
                hint = "নতুন পাসওয়ার্ড";
              }
              return VerificationTextField(
                textEditingController: _newPasswordController,
                hintText: hint,
                obscureText: hiddenNP,
                onTap: () {
                  setState(() {
                    hiddenNP = !hiddenNP;
                  });
                },
                suffix: hiddenNP ? Icons.visibility_off : Icons.visibility,
              );
            },
          ),
          Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
            String lang = ref.watch(languageProvider);
            String hint = "Confirm New password";
            if (lang != "en") {
              hint = "নতুন পাসওয়ার্ড নিশ্চিত করুন";
            }
            return VerificationTextField(
              textEditingController: _reEnterNewPasswordController,
              hintText: hint,
              obscureText: hiddenCNP,
              onTap: () {
                setState(() {
                  hiddenCNP = !hiddenCNP;
                });
              },
              suffix: hiddenCNP ? Icons.visibility_off : Icons.visibility,
            );
          }),


          // login button
          TextButtons(
            label: "Update Password",
            onPressed: () async {
              _controller.updatePassword(
                oldPassword: _passwordController.text.trim(),
                newPassword: _newPasswordController.text.trim(),
                reNewPassword: _reEnterNewPasswordController.text.trim(),
              );
            },
          )
        ],
      ),
    );
  }
}
