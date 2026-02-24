import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/provider/global_provider.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../constants/dashboard_btn_names.dart';
import '../../../main.dart';
import '../../../models/returned_data_model.dart';
import '../../../models/sr_info_model.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../reusable_widgets/scaffold_widgets/cameraScreen.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../controller/transfer_bill_controller.dart';
import '../provider/transfer_bill_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../../services/image_service.dart';
import '../../../api/global_http.dart';
import '../../../api/links.dart';
import '../../../services/ff_services.dart';
import 'package:path/path.dart' as path;

class TransferBillFormUI extends ConsumerStatefulWidget {
  const TransferBillFormUI({Key? key}) : super(key: key);
  static const routeName = "/transfer_bill_form_ui";

  @override
  ConsumerState<TransferBillFormUI> createState() => _TransferBillFormUIState();
}

class _TransferBillFormUIState extends ConsumerState<TransferBillFormUI> {
  late TextEditingController reasonController;
  late TextEditingController fromController;
  late TextEditingController toController;
  late TextEditingController amountController;
  late TransferBillController transferBillController;

  @override
  void initState() {
    super.initState();
    transferBillController = TransferBillController(context: context);
    reasonController = TextEditingController();
    fromController = TextEditingController();
    toController = TextEditingController();
    amountController = TextEditingController();
  }

  @override
  void dispose() {
    reasonController.dispose();
    fromController.dispose();
    toController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = ref.watch(selectedTransferBillImagePathProvider);
    final imageCashPath = ref.watch(selectedTransferBillCashImagePathProvider);
    final imageServerPath = ref.watch(selectedTransferBillImageServerPathProvider);
    final billCopyPath = ref.watch(selectedTransferBillCopyPathProvider);
    final billCopyServerPath = ref.watch(selectedTransferBillCopyServerPathProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Transfer Bill',
        titleImage: "bill.png",
        onLeadingIconPressed: () => Navigator.pop(context),
        heroTagTitle: 'Transfer Bill',
        heroTagImg: DashboardBtnNames.getImageHeroTag('Transfer Bill'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 12.sp),
        children: [
          SizedBox(height: 2.h),

          heading('From Location'),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
            child: InputTextFields(
              textEditingController: fromController,
              hintText: 'From Location',
              inputType: TextInputType.text,
            ),
          ),

          heading('To Location'),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
            child: InputTextFields(
              textEditingController: toController,
              hintText: 'To Location',
              inputType: TextInputType.text,
            ),
          ),

          heading('Transfer Date'),
          InkWell(
            onTap: () async {
              final prevPickedDate = ref.read(selectedTransferBillDateProvider);
              final now = DateTime.now();
              final firstDate = DateTime(now.year, now.month - 3, now.day);
              final picked = await showDatePicker(
                context: context,
                initialDate: prevPickedDate,
                firstDate: firstDate,
                lastDate: now,
              );
              if (picked != null) {
                ref.read(selectedTransferBillDateProvider.notifier).state = picked;
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
                        final date = ref.watch(selectedTransferBillDateProvider);
                        return LangText(uiDateFormat.format(date), style: TextStyle(color: Colors.grey, fontSize: 9.sp));
                      },
                    ),
                    Icon(Icons.calendar_month_outlined, color: lightMediumGrey),
                  ],
                ),
              ),
            ),
          ),

          heading('Amount'),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
            child: InputTextFields(
              textEditingController: amountController,
              hintText: 'Amount',
              inputType: TextInputType.numberWithOptions(decimal: true),
            ),
          ),

          heading('Description'),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
            child: InputTextFields(
              textEditingController: reasonController,
              hintText: 'Description',
              inputType: TextInputType.text,
              maxLine: 5,
            ),
          ),

          SizedBox(height: 2.h),

          heading('Image (camera / gallery)'),
          // show preview when image is picked or uploaded
          if (imagePath.isNotEmpty || imageServerPath.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 6.sp),
              child: GestureDetector(
                onTap: () {
                  // Optionally implement full screen preview later
                },
                child: Container(
                  height: 18.h,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(imageCashPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      // show bottom sheet with camera/gallery/file
                      ImageService().showImageBottomSheet(
                        context: context,
                        filePicker: false,
                        fromGallery: () async {
                          ImagePicker picker = ImagePicker();
                          XFile? file = await picker.pickImage(source: ImageSource.gallery);
                          if (file != null) {
                            File? compressed = await ImageService().compressFile(context: context, file: File(file.path), name: 'transfer_image_${DateTime.now().millisecondsSinceEpoch}');

                            if (compressed != null) {
                              final cacheDir = await getApplicationCacheDirectory();

                              final fileName = path.basename(compressed.path);
                              final cachedFilePath = path.join(cacheDir.path, fileName);

                              final cachedFile = await compressed.copy(cachedFilePath);

                              // cachedFile is now inside application cache directory
                              print('Cached file path: ${cachedFile.path}');
                              ref.read(selectedTransferBillCashImagePathProvider.notifier).state = cachedFile.path;
                            }

                            if (compressed != null) {
                              // store local compressed path for preview
                              ref.read(selectedTransferBillImagePathProvider.notifier).state = compressed.path;
                              // upload instantly via controller
                              final serverName = await transferBillController.sendTransferImageToServer(compressed);
                              if (serverName != null) {
                                ref.read(selectedTransferBillImageServerPathProvider.notifier).state = serverName;
                                // clear local compressed preview path after successful upload
                                ref.read(selectedTransferBillImagePathProvider.notifier).state = '';
                                compressed.delete();
                              }
                            }
                          }
                        },
                        fromCamera: () async {
                          await Future.delayed(const Duration(microseconds: 100));
                          Navigator.of(context).pushNamed(CameraScreen.routeName).then((value) async {
                            if (value != null) {
                              File? compressed = await ImageService().compressFile(context: context, file: File(value.toString()), name: 'transfer_image_${DateTime.now().millisecondsSinceEpoch}');
                              if (compressed != null) {
                                ref.read(selectedTransferBillImagePathProvider.notifier).state = compressed.path;
                                final serverName = await transferBillController.sendTransferImageToServer(compressed);
                                if (serverName != null) {
                                  ref.read(selectedTransferBillImageServerPathProvider.notifier).state = serverName;
                                  ref.read(selectedTransferBillImagePathProvider.notifier).state = '';
                                  compressed.delete();
                                }
                              }
                            }
                          });
                        },
                      );
                    },
                    child: LangText(imagePath.isEmpty ? 'Attach Image' : 'Replace Image'),
                  ),
                ),
                if (imagePath.isNotEmpty)
                  IconButton(
                    onPressed: () => ref.read(selectedTransferBillImagePathProvider.notifier).state = '',
                    icon: const Icon(Icons.clear),
                  )
              ],
            ),
          ),

          heading('Bill Copy (file only)'),
          // show filename if bill copy selected
          if (billCopyPath.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 6.sp),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    const Icon(Icons.insert_drive_file_outlined),
                    SizedBox(width: 10),
                    Expanded(child: LangText(billCopyPath.split('/').last)),
                    IconButton(onPressed: () => ref.read(selectedTransferBillCopyPathProvider.notifier).state = '', icon: const Icon(Icons.clear))
                  ],
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        type: FileType.custom,
                        allowedExtensions: ['pdf', 'doc', 'docx', 'xlsx'],
                      );
                      if (result != null && result.files.single.path != null) {
                        String path = result.files.single.path!;
                        // store local path for preview
                        ref.read(selectedTransferBillCopyPathProvider.notifier).state = path;
                        // upload instantly via controller
                        final File file = File(path);
                        final serverName = await transferBillController.sendTransferBillFileToServer(file);
                        if (serverName != null) {
                          ref.read(selectedTransferBillCopyServerPathProvider.notifier).state = serverName;
                          // clear local file path after successful upload
                          ref.read(selectedTransferBillCopyPathProvider.notifier).state = '';
                        }
                      }
                    },
                    child: LangText(billCopyPath.isEmpty ? 'Attach Bill Copy' : 'Replace Bill Copy'),
                  ),
                ),
                if (billCopyPath.isNotEmpty)
                  IconButton(
                    onPressed: () => ref.read(selectedTransferBillCopyPathProvider.notifier).state = '',
                    icon: const Icon(Icons.clear),
                  )
              ],
            ),
          ),

          // show server filename if uploaded
          if (billCopyServerPath.isNotEmpty && billCopyPath.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 6.sp),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    const Icon(Icons.insert_drive_file_outlined),
                    SizedBox(width: 10),
                    Expanded(child: LangText(billCopyServerPath.split('/').last)),
                    IconButton(onPressed: () => ref.read(selectedTransferBillCopyServerPathProvider.notifier).state = '', icon: const Icon(Icons.clear))
                  ],
                ),
              ),
            ),

          SizedBox(height: 3.h),

          SubmitButtonGroup(
            twoButtons: true,
            button1Label: "Submit",
            onButton1Pressed: () async {
              // Basic validation
              if (fromController.text.trim().isEmpty || toController.text.trim().isEmpty) {
                Alerts(context: context).customDialog(type: AlertType.warning, description: 'Please enter from and to locations');
                return;
              }
              if (amountController.text.trim().isEmpty) {
                Alerts(context: context).customDialog(type: AlertType.warning, description: 'Please enter amount');
                return;
              }

              final imageLocal = ref.read(selectedTransferBillImagePathProvider);
              final imageServer = ref.read(selectedTransferBillImageServerPathProvider);
              final billLocal = ref.read(selectedTransferBillCopyPathProvider);
              final billServer = ref.read(selectedTransferBillCopyServerPathProvider);
              print('TransferBill submit -> imageLocal: $imageLocal, imageServer: $imageServer, billLocal: $billLocal, billServer: $billServer');

              if (imageLocal.isNotEmpty && imageServer.isEmpty) {
                Alerts(context: context).customDialog(
                  type: AlertType.warning,
                  description: 'Image upload is not completed yet or failed',
                );
                return;
              }

              if (billLocal.isNotEmpty && billServer.isEmpty) {
                Alerts(context: context).customDialog(
                  type: AlertType.warning,
                  description: 'Bill copy upload is not completed yet or failed',
                );
                return;
              }

              num parsedAmount = num.tryParse(amountController.text.trim()) ?? 0;

              final result = await transferBillController.submitTransferBill(
                fromLocation: fromController.text.trim(),
                toLocation: toController.text.trim(),
                amount: parsedAmount,
                description: reasonController.text.trim(),
                imagePath: imageServer.isNotEmpty ? imageServer : '',
                billCopyPath: billServer.isNotEmpty ? billServer : '',
                selectedDate: ref.read(selectedTransferBillDateProvider),
              );

              if (result.status == ReturnedStatus.success) {
                Alerts(context: context).customDialog(
                  type: AlertType.success,
                  description: "Transfer Bill Submitted!",
                  onTap1: () {
                    ref.invalidate(transferBillStatusProvider);
                    navigatorKey.currentState?.pop();
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
      ),
    );
  }

  Widget heading(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
      child: LangText(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
    );
  }
}
