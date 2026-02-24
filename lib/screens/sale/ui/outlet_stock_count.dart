import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../services/asset_download/asset_service.dart';
import '../../../services/sync_read_service.dart';
import '../../aws_stock/controller/aws_stock_controller.dart';
import '../../aws_stock/model/aws_product_model.dart';
import '../controller/sale_controller.dart';

class OutletStockCountUI extends ConsumerStatefulWidget {
  static const routeName = "outlet_stock_count_ui";
  final List<AwsProductModel> productList;

  const OutletStockCountUI({super.key, required this.productList});

  @override
  ConsumerState<OutletStockCountUI> createState() => _AwsStockScreenState();
}

class _AwsStockScreenState extends ConsumerState<OutletStockCountUI> {
  Alerts? _alerts;
  final _formKey = GlobalKey<FormState>();
  final GlobalWidgets globalWidgets = GlobalWidgets();
  late AwsStockController awsStockController;
  late SaleController salesController;

  void initState() {
    super.initState();
    _alerts = Alerts(context: context);
    awsStockController = AwsStockController(context: context, ref: ref);
    salesController = SaleController(context: context, ref: ref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Outlet Stock Count",
        titleImage: "stock.png",
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 2.h,
            ),
            if (widget.productList.isNotEmpty) tableHeader(),
            if (widget.productList.isEmpty)
              Center(
                child: LangText("No Sku Found"),
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: 3.h,
                ),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.productList.length,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Visibility(
                          visible: widget.productList[index].saleEnabled == 1,
                          child: Padding(
                            padding: EdgeInsets.only(left: 3.w, right: 3.w),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          // width: 17.w,
                                          width: 40,
                                          child: AssetService(context).superImage(
                                            '${widget.productList[index].id}.png',
                                            folder: 'SKU',
                                            version: SyncReadService().getAssetVersion('SKU'),
                                            height: 85,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Expanded(child: LangText(widget.productList[index].name)),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5.sp),
                                              color: Colors.grey.shade300.withValues(alpha: 0.3),
                                            ),
                                            child: TextFormField(
                                              initialValue: '0',
                                              decoration: const InputDecoration(
                                                border: UnderlineInputBorder(
                                                    borderSide: BorderSide.none),
                                                isDense: true,
                                                enabledBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide.none),
                                              ),
                                              textAlign: TextAlign.center,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(
                                                    RegExp(r'[0-9]*')),
                                                TextInputFormatter.withFunction(
                                                  (oldValue, newValue) => newValue.copyWith(
                                                    text: newValue.text.replaceAll('.', '.'),
                                                  ),
                                                ),
                                              ],
                                              style: TextStyle(
                                                  fontSize: 11.sp,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                              onSaved: (damaged) {
                                                widget.productList[index].setDamagedCount(
                                                    int.tryParse(damaged ?? '0') ?? 0);
                                              },
                                              // onChanged: (damaged) {
                                              //   widget.productList[index].setDamagedCount(int.tryParse(damaged)??0);
                                              // },
                                            ),
                                          ),
                                        ),
                                        Expanded(child: Container()),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5.sp),
                                              color: Colors.grey.shade300.withOpacity(0.3),
                                            ),
                                            child: TextFormField(
                                              initialValue: '0',
                                              decoration: const InputDecoration(
                                                border: UnderlineInputBorder(
                                                    borderSide: BorderSide.none),
                                                isDense: true,
                                                enabledBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide.none),
                                              ),
                                              textAlign: TextAlign.center,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(
                                                    RegExp(r'[0-9]*')),
                                                TextInputFormatter.withFunction(
                                                  (oldValue, newValue) => newValue.copyWith(
                                                    text: newValue.text.replaceAll('.', '.'),
                                                  ),
                                                ),
                                              ],
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                color: greenOlive,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              onSaved: (stock) {
                                                widget.productList[index]
                                                    .setStockCount(int.tryParse(stock ?? '0') ?? 0);
                                              },
                                              // onChanged: (stock) {
                                              //   widget.productList[index].setStockCount(int.tryParse(stock)??0);
                                              // },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Consumer(builder: (context, ref, _) {
                      final retailer = ref.watch(selectedRetailerProvider);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.w),
                              child: SubmitButtonGroup(
                                twoButtons: false,
                                button1Label: "Save",
                                // button2Label: "Edit",
                                button1Color: primary,
                                button2Color: darkGreen,
                                button1Icon: Icon(Icons.save, color: Colors.white),
                                layout: ButtonLayout.horizontal,
                                onButton1Pressed: () {
                                  _alerts?.customDialog(
                                    type: AlertType.warning,
                                    twoButtons: true,
                                    message: 'Are you sure?',
                                    onTap1: () async {
                                      _formKey.currentState?.save();
                                      salesController
                                          .saveOutletStockCount(productList: widget.productList)
                                          .then((value) {
                                        _formKey.currentState?.reset();
                                        // ref.read(saleMenuStatusProvider.notifier).completeTask("stock count");
                                        // ref.read(outletStockCountSubmitStatusProvider.notifier).state = SaleDashboardCompleteStatus.done;
                                        ref.refresh(saleDashboardMenuProvider(retailer!));
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      });
                                      // _formKey.currentState?.save();
                                      // _formKey.currentState?.reset();
                                      // // ref.read(saleMenuStatusProvider.notifier).completeTask("stock count");
                                      // // ref.read(outletStockCountSubmitStatusProvider.notifier).state = SaleDashboardCompleteStatus.done;
                                      // Navigator.pop(context);
                                      // Navigator.pop(context);
                                    },
                                  );
                                },
                              ),
                              // child: globalWidgets.button(
                              //     isIconLeft: true,
                              //     colors: [green, darkGreen],
                              //     text: "Save",
                              //     textColor: Colors.white,
                              //     callback: () {
                              //       _alerts?.customDialog(
                              //         type: AlertType.warning,
                              //         twoButtons: true,
                              //         message: 'Are you sure?',
                              //         onTap1: () async {
                              //           _formKey.currentState?.save();
                              //           // salesController.saveOutletStockCount(productList: widget.productList).then((value) {
                              //           //   _formKey.currentState?.reset();
                              //           //   // ref.read(saleMenuStatusProvider.notifier).completeTask("stock count");
                              //           //   // ref.read(outletStockCountSubmitStatusProvider.notifier).state = SaleDashboardCompleteStatus.done;
                              //           //   ref.refresh(saleDashboardMenuProvider(retailer!));
                              //           //   Navigator.pop(context);
                              //           //   Navigator.pop(context);
                              //           // });
                              //           // _formKey.currentState?.save();
                              //           // _formKey.currentState?.reset();
                              //           // // ref.read(saleMenuStatusProvider.notifier).completeTask("stock count");
                              //           // // ref.read(outletStockCountSubmitStatusProvider.notifier).state = SaleDashboardCompleteStatus.done;
                              //           // Navigator.pop(context);
                              //           // Navigator.pop(context);
                              //         },
                              //       );
                              //     },
                              //   icon: const Icon(
                              //     Icons.save,
                              //     color: Colors.white,
                              //   ),
                              // ),
                            ),
                          ),
                        ],
                      );
                    })
                  ],
                ),
              ),
            ),
            // SizedBox(
            //   height: 2.h,
            // ),
          ],
        ),
      ),
    );
  }

  Widget tableHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFEBF5FF),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5.sp),
            topRight: Radius.circular(5.sp),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: LangText(
                  "SKU",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LangText(
                          "DAMAGED",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        LangText(
                          "(Pack)",
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LangText(
                          "STOCK",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        LangText(
                          "(Pack)",
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
