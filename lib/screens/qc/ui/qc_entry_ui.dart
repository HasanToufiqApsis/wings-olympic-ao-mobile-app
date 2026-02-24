import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/enum.dart';
import '../../../models/products_details_model.dart';
import '../../../models/qc_info_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/global_widgets.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../services/asset_download/asset_service.dart';
import '../../../services/sync_read_service.dart';
import '../controller/qc_entry_controller.dart';

class QCEntryUI extends ConsumerStatefulWidget {
  const QCEntryUI({Key? key}) : super(key: key);
  static const routeName = "/qc_entry";
  @override
  _QCEntryUIState createState() => _QCEntryUIState();
}

class _QCEntryUIState extends ConsumerState<QCEntryUI> {
  List<QCInfoModel> qcList = [];
  // List<QCInfoModel> qcMainList = [];
  late QCController controller;
  GlobalWidgets globalWidgets = GlobalWidgets();
  int totalQC = 0;
  // Map<int, int> qcPrevData = {};
  @override
  void initState() {
    controller = QCController(context: context, ref: ref);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            title: "Damage Entry",
            // titleImage: "pre_order_button.png",
            onLeadingIconPressed: () {
              Navigator.pop(context);
            }
        ),
        body: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
              child: Consumer(builder: (context, ref, _) {
                ProductDetailsModel? sku = ref.watch(selectedProductForQCProvider);
                // qcPrevData = controller.getQcQuantityData(sku!);

                return Column(
                  children: [
                    SizedBox(
                      height: 20.h,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                          child: Row(
                            children: [
                              Expanded(child: AssetService(context).superImage('${sku!.id}.png', folder: 'SKU', version: SyncReadService().getAssetVersion('SKU'))),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LangText(
                                      sku.shortName,
                                      style: TextStyle(
                                        fontSize: mediumFontSize,
                                        color: red3,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // Consumer(builder: (context, ref, _) {
                                    //   double maxQCDouble = ref.watch(maxQCProvider);
                                    //
                                    //   String maxQCSrt = maxQCDouble.toStringAsFixed(2);
                                    //   return RichText(
                                    //       text: TextSpan(children: [
                                    //     WidgetSpan(child: LangText('Maximum Damage:', style: TextStyle(fontWeight: FontWeight.bold, color: darkGrey))),
                                    //     WidgetSpan(
                                    //         child: SizedBox(
                                    //       width: 1.w,
                                    //     )),
                                    //     WidgetSpan(
                                    //       child: LangText(maxQCSrt,  style: TextStyle(color: darkGrey)),
                                    //     ),
                                    //     WidgetSpan(
                                    //       child: LangText('BDT', style: TextStyle(color: darkGrey)),
                                    //     ),
                                    //   ]));
                                    // }),
                                    Consumer(builder: (context, ref, _) {
                                      double qcDoneValue = ref.watch(qcDoneProvider);
                                      double prevQCValue = ref.watch(prevQCAmountProvider);
                                      double qcDone = qcDoneValue - prevQCValue;
                                      return RichText(
                                          text: TextSpan(children: [
                                        WidgetSpan(child: LangText('Damage Done', style: TextStyle(fontWeight: FontWeight.bold, color: darkGrey))),
                                        const WidgetSpan(child: Text(': ')),
                                        WidgetSpan(child: LangText(prevQCValue.toStringAsFixed(2), style: TextStyle(color: darkGrey))),
                                        WidgetSpan(child: LangText('BDT', style: TextStyle(color: darkGrey))),
                                      ]));
                                    }),
                                    // Consumer(builder: (context, ref, _) {
                                    //   double maxQCValue = ref.watch(maxQCProvider);
                                    //   double prevQCValue = ref.watch(prevQCAmountProvider);
                                    //   double qcDoneValue = ref.watch(qcDoneProvider);
                                    //   double remaining = (maxQCValue + prevQCValue) - qcDoneValue;
                                    //   return RichText(
                                    //       text: TextSpan(children: [
                                    //     WidgetSpan(child: LangText('Damage left:', style: TextStyle(fontWeight: FontWeight.bold, color: darkGrey))),
                                    //     WidgetSpan(
                                    //         child: SizedBox(
                                    //       width: 1.w,
                                    //     )),
                                    //     WidgetSpan(child: LangText(remaining.toStringAsFixed(2), style: TextStyle(color: darkGrey))),
                                    //     WidgetSpan(child: LangText('BDT', style: TextStyle(color: darkGrey))),
                                    //   ]));
                                    // })
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    // getTable(sku),
                    SizedBox(height: 50.h, child: getTable(sku)),
                    SizedBox(
                      height: 3.h,
                    ),
                    SubmitButtonGroup(
                      button1Label: 'Save',
                      button1Color: red3,
                      onButton1Pressed: () async {
                        if (qcList.isNotEmpty) {
                          // double remaining
                          await QCController(context: context, ref: ref).saveQC(qcList);
                        } else {
                          Alerts(context: context).customDialog(type: AlertType.info, message: 'Please add Damage amount');
                        }
                      },
                    ),

                    SizedBox(
                      height: 2.h,
                    ),
                    SubmitButtonGroup(
                      button1Label: 'Cancel',
                      button1Color: pureGrey,
                      onButton1Pressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    SubmitButtonGroup(
                      button1Label: 'Delete',
                      button1Color: Colors.red,
                      onButton1Pressed: () async{
                        await QCController(context: context, ref: ref).removeQC();
                      },
                    ),
                  ],
                );
              }),
            ),
          ),
        ));
  }

  Widget getTable(ProductDetailsModel sku) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.sp), bottomRight: Radius.circular(5.sp)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),

            spreadRadius: 0.5,
            blurRadius: 5,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5.sp), topRight: Radius.circular(5.sp)),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [primary, primaryBlue],
                ),
                color: Colors.grey[100]),
            child: DefaultTextStyle(
              style: TextStyle(fontSize: normalFontSize, color: Colors.white, fontWeight: FontWeight.bold),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LangText(
                      'Fault',
                      style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                    ),
                    LangText(
                      'Type',
                      style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                    ),
                    LangText(
                      'Quantity',
                      style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer(builder: (context, ref, _) {
              AsyncValue<List<QCInfoModel>> asyncQCInfoList = ref.watch(qcInfoProvider(sku.module.id.toString()));
              return asyncQCInfoList.when(
                  data: (qcInfoList) {
                    // qcMainList = qcInfoList;
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: qcInfoList.length,
                        itemBuilder: (context, index) {
                          return getTableItem(qcInfoList[index], index, sku);
                        });
                  },
                  error: (error, _) {
                    print('async qc error: $error');
                    return Container();
                  },
                  loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ));
            }),
          ),
          Container(
            width: 100.w,
            height: 3.h,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.sp), bottomRight: Radius.circular(5.sp)),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [grey, darkGrey],
                ),
                color: Colors.grey[100]),
          ),
        ],
      ),
    );
  }

  Widget getTableItem(QCInfoModel qc, int index, ProductDetailsModel sku) {
    return Container(
      // height: 30.h,
      color: index % 2 == 0 ? Colors.white : Colors.grey[50],
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 20.w,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Center(
                  child: LangText(
                    qc.name,
                    style: TextStyle(color: red3, fontSize: mediumFontSize, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(width: 70.w, child: getQCType(qc, sku))
          ],
        ),
      ),
    );
  }

  Widget getQCType(QCInfoModel qc, ProductDetailsModel sku) {
    return ListView.builder(
        itemCount: qc.types.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return qcFaultItem(qc.types[index], qc, sku);
        });
  }

  Widget qcFaultItem(QCTypesModel qcFault, QCInfoModel qc, ProductDetailsModel sku) {
    String quantity = '';
    // int prevQuantity = qcPrevData[qcFault.id]??0;//controller.getQuantityByQCType(sku, qc, qcFault);
    //
    // if(prevQuantity != 0){
    //   if(!qcList.contains(qc)){
    //     qcList.add(qc);
    //   }
    //   qcFault.quantity = prevQuantity;
    // }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: LangText(
              qcFault.name,
              style: TextStyle(color: red3, fontSize: normalFontSize),
            ),
          ),
          Expanded(
              child: Container(
            height: 5.h,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Center(
              child: TextFormField(
                keyboardType: TextInputType.number,
                initialValue: qcFault.quantity == 0? null: qcFault.quantity.toString(),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.sp), borderSide: BorderSide(color: red3)),
                  isDense: true,
                  isCollapsed: true,

                  // hintText: prevQuantity == 0? '' : prevQuantity.toString(),
                  // hintStyle: TextStyle(color: lightGrey)
                ),
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                onChanged: (value) {
                  quantity = value;
                  controller.onChangeQCEntry(quantity, qcList, qc, qcFault);
                },
              ),
            ),
          ))
        ],
      ),
    );
  }
}
