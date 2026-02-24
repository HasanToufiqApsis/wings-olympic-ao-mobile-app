import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../main.dart';
import '../../../models/leave_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../leave_management/controller/leave_controller.dart';

class MovementEditUi extends ConsumerStatefulWidget {
  static const routeName = 'MovementEditUi';

  final LeaveManagementData movement;

  const MovementEditUi({super.key, required this.movement});

  @override
  ConsumerState<MovementEditUi> createState() => _MovementEditUiState();
}

class _MovementEditUiState extends ConsumerState<MovementEditUi> {
  late final LeaveController leaveController;

  TextEditingController tadaController = TextEditingController();

  @override
  void initState() {
    leaveController = LeaveController(context: context, ref: ref);
    // tadaController = TextEditingController(text: widget.movement.tada.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: CustomAppBar(
    //     title: "Leave Calendar",
    //     onLeadingIconPressed: () {
    //       Navigator.pop(context);
    //     },
    //   ),
    //   body: SingleChildScrollView(
    //     physics: const BouncingScrollPhysics(),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         leaveController.heading("Movement Type"),
    //         Padding(
    //           padding: EdgeInsets.symmetric(horizontal: 11.sp),
    //           child: LangText(widget.movement.type),
    //         ),
    //         const SizedBox(height: 12),
    //         leaveController.heading("Date"),
    //         Padding(
    //           padding: EdgeInsets.symmetric(horizontal: 11.sp),
    //           child: LangText(widget.movement.startDate),
    //         ),
    //         const SizedBox(height: 12),
    //         leaveController.heading("Day"),
    //         Padding(
    //           padding: EdgeInsets.symmetric(horizontal: 11.sp),
    //           child: LangText(widget.movement.totalDays.toString()),
    //         ),
    //         const SizedBox(height: 12),
    //         leaveController.heading("Reason"),
    //         Padding(
    //           padding: EdgeInsets.symmetric(horizontal: 11.sp),
    //           child: LangText(widget.movement.reason),
    //         ),
    //         const SizedBox(height: 12),
    //         leaveController.heading("TA/DA"),
    //         Consumer(builder: (context, ref, _) {
    //           String lang = ref.watch(languageProvider);
    //           String hint = "টিএ/ডিএ";
    //           if (lang == "en") {
    //             hint = "TA/DA";
    //           }
    //           return NormalTextField(
    //             textEditingController: tadaController,
    //             hintText: hint,
    //             inputType: TextInputType.number,
    //           );
    //         }),
    //         SizedBox(
    //           height: 3.h,
    //         ),
    //         SubmitButtonGroup(
    //           twoButtons: true,
    //           onButton1Pressed: () {
    //             leaveController.submitMovementEditRequestToServer(
    //               taDaAmount: tadaController.text.trim(),
    //               movement: widget.movement,
    //             );
    //           },
    //           onButton2Pressed: () {
    //             navigatorKey.currentState?.pop();
    //           },
    //         ),
    //         SizedBox(
    //           height: 2.h,
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return Placeholder();
  }
}
