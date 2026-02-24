import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/models/resignation_status.dart';
import 'package:wings_olympic_sr/provider/global_provider.dart';
import 'package:wings_olympic_sr/reusable_widgets/custom_dialog.dart';
import 'package:wings_olympic_sr/screens/olympic_tada/service/olympic_tada_service.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/dashboard_btn_names.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/returned_data_model.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../controller/resignation_controller.dart';
import '../provider/resignation_provider.dart';

class ResignationUI extends ConsumerStatefulWidget {
  const ResignationUI({Key? key}) : super(key: key);
  static const routeName = "/resignation_ui";

  @override
  ConsumerState<ResignationUI> createState() => _ResignationUIState();
}

class _ResignationUIState extends ConsumerState<ResignationUI> {
  final _appBarTitle = DashboardBtnNames.resignation;
  late TextEditingController reasonController;
  late ResignationController resignationController;

  @override
  void initState() {
    super.initState();
    resignationController = ResignationController(context: context);
    reasonController = TextEditingController();
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusAsync = ref.watch(resignationStatusProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: _appBarTitle,
        titleImage: "resignation.png",
        onLeadingIconPressed: () => Navigator.pop(context),
        heroTagTitle: _appBarTitle,
        heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
      ),
      body: statusAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: LangText(
            'Error: $e',
            style: const TextStyle(color: Colors.red),
          ),
        ),
        data: (data) {
          if (data.status == ReturnedStatus.success &&
              data.data != null &&
              data.data["success"] == true &&
              data.data["data"].isNotEmpty) {
            final lastResignation = ResignationModel.fromJson(
              data.data,
            ).data.first;
            final status = lastResignation.status?.toLowerCase() ?? "pending";

            if (status == "rejected") {
              //  Rejected → Show old + form
              return SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red.shade400,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: LangText(
                              "Your previous resignation was rejected. You may reapply below.",
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildExistingStatusCard(
                      ref,
                      lastResignation,
                      showRefresh: false,
                    ),
                    const Divider(height: 30),
                    _buildResignationForm(ref, nested: true),
                  ],
                ),
              );
            } else {
              //  Pending /  Approved → Show existing info only
              return _buildExistingStatusCard(ref, lastResignation);
            }
          } else {
            //  No previous resignation → show form
            return _buildResignationForm(ref);
          }
        },
      ),
    );
  }

  // Existing Status Card
  Widget _buildExistingStatusCard(
    WidgetRef ref,
    ResignationData data, {
    bool showRefresh = true,
  }) {
    final status = data.status ?? "N/A";
    final remarks = data.remarks ?? "N/A";
    final supervisorRemarks = data.supervisorRemarks ?? "";
    final lastWorkingDate = data.lastWorkingDate ?? "N/A";
    final submissionDate = data.submissionDate ?? "N/A";

    Color statusColor;
    switch (status.toLowerCase()) {
      case 'approved':
        statusColor = green;
        break;
      case 'pending':
        statusColor = orange;
        break;
      case 'rejected':
        statusColor = primaryRed;
        break;
      default:
        statusColor = grey;
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (status.toLowerCase() == 'rejected')
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: LangText(
                "Previous Resignation (Rejected)",
                style: TextStyle(
                  color: Colors.red.shade400,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LangText(
                "Resignation Status",
                style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
              ),
              Chip(
                label: LangText(
                  status.toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: statusColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _infoRow("Submission Date", submissionDate),
          if (status.toLowerCase() != 'rejected')
            _infoRow("Last Working Date", lastWorkingDate),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: LangText(
              "Remarks:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: LangText(
              remarks,
              style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade800),
            ),
          ),
          Visibility(
            visible: supervisorRemarks.isNotEmpty,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: LangText(
                    "Supervisor Remarks:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: LangText(
                    supervisorRemarks,
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade800),
                  ),
                ),
              ],
            ),
          ),
          if (showRefresh)
            Padding(
              padding: EdgeInsets.only(top: 20.sp),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () => ref.invalidate(resignationStatusProvider),
                  icon: const Icon(Icons.refresh),
                  label: LangText("Refresh"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.sp,
                      vertical: 12.sp,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        LangText(
          "$label:",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        LangText(value, style: const TextStyle(color: Colors.black87)),
      ],
    ),
  );

  //  Resignation Form (works nested or full-screen)
  Widget _buildResignationForm(WidgetRef ref, {bool nested = false}) {
    final formContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.h),
        heading("Pick a Date"),
        InkWell(
          onTap: () async {
            final prevPickedDate = ref.read(selectedResignationDateProvider);
            final picked = await showDatePicker(
              context: context,
              initialDate: prevPickedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(3000),
            );
            if (picked != null) {
              ref.read(selectedResignationDateProvider.notifier).state = picked;
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(appBarRadius),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer(
                    builder: (context, ref, _) {
                      final date = ref.watch(selectedResignationDateProvider);
                      return LangText(
                        uiDateFormat.format(date),
                        style: TextStyle(color: Colors.grey, fontSize: 9.sp),
                      );
                    },
                  ),
                  Icon(Icons.calendar_month_outlined, color: lightMediumGrey),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        heading("Reason"),
        Consumer(
          builder: (context, ref, _) {
            final lang = ref.watch(languageProvider);
            final hint = lang == "en" ? "Reason" : "কারণ লিখুন";
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
              child: InputTextFields(
                textEditingController: reasonController,
                hintText: hint,
                inputType: TextInputType.text,
                maxLine: 5,
              ),
            );
          },
        ),
        SizedBox(height: 5.h),
        SubmitButtonGroup(
          twoButtons: true,
          onButton1Pressed: () async {
            final result = await resignationController.submitResignation(
              reasonController.text.trim(),
              ref.read(selectedResignationDateProvider),
            );
            if (result.status == ReturnedStatus.success) {
              Alerts(context: context).customDialog(
                type: AlertType.success,
                description: "Resignation Submitted!",
                onTap1: () {
                  ref.invalidate(resignationStatusProvider);
                  navigatorKey.currentState?.pop();
                },
              );
            } else {
              Alerts(context: context).customDialog(
                type: AlertType.warning,
                description: result.errorMessage,
              );
            }
          },
          onButton2Pressed: () => navigatorKey.currentState?.pop(),
        ),
      ],
    );

    // If nested inside another scrollable
    if (nested) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.sp),
        child: formContent,
      );
    }

    // Default standalone form
    return ListView(children: [formContent]);
  }

  Widget heading(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
      child: LangText(
        label,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
      ),
    );
  }
}
