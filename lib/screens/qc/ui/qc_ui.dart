import 'package:flutter/material.dart';
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
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../services/asset_download/asset_service.dart';
import '../../../services/sync_read_service.dart';
import '../controller/qc_entry_controller.dart';
import 'qc_entry_ui.dart';


class QCUI extends ConsumerStatefulWidget {
  const QCUI({Key? key}) : super(key: key);
  static const routeName = "/qc";
  @override
  _QCUIState createState() => _QCUIState();
}

class _QCUIState extends ConsumerState<QCUI> {
  GlobalWidgets globalWidgets = GlobalWidgets();
  final TextEditingController _searchTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchTextController.dispose();
    _searchTextController.removeListener(() {});
  }

  searchSKUListListener() {
    String key = _searchTextController.text.trim();
    ref.read(qcSKUListProvider.notifier).searchQC(key);
  }
  int totalQC = 0;
  List<SelectedQCInfoModel> qcList = [];

  @override
  void initState() {
    super.initState();
    _searchTextController.addListener(searchSKUListListener);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(
        title: "Damage/Product Return",
        // titleImage: "pre_order_button.png",
        onLeadingIconPressed: () {
          ref.read(selectedQCInfoListProvider.state).state = [];
          Navigator.pop(context);
        }
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    globalWidgets.showInfo(message: 'Select product for Damage to continue'),
                    SizedBox(
                      height: 2.h,
                    ),
                    Consumer(
                        builder: (context,ref,_) {
                          String lang = ref.watch(languageProvider);
                          String hint = "Search products";
                          if(lang != "en"){
                            hint = "প্রডাক্ট অনুসন্ধান করুন";
                          }
                          return InputTextFields(
                            textEditingController: _searchTextController,
                            hintText: hint,
                            suffixIcon: Icons.search,
                          );
                        }
                    ),
                    SizedBox(height: 2.h,),
                    Consumer(builder: (context, ref, _) {
                      AsyncValue<List<ProductDetailsModel>> asyncSkuList = ref.watch(qcSKUListProvider);
                      return asyncSkuList.when(
                          data: (skuList) {
                            return Card(
                              child: SizedBox(
                                width: 100.w,
                                height: 18.h,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: skuList.length,
                                    itemBuilder: (context, index) {
                                      return getItem(skuList[index]);
                                    }),
                              ),
                            );
                          },
                          error: (error, _) {
                            return Container(
                              color: Colors.red,
                            );
                          },
                          loading: () => const Center(child: CircularProgressIndicator()));
                    }),
                    SizedBox(
                      height: 2.h,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: LangText(
                        'Damage Summary',
                        style: TextStyle(color: darkGrey, fontSize: mediumFontSize, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Consumer(builder: (context, ref, _) {
                      List<SelectedQCInfoModel> selectedQCList = ref.watch(selectedQCInfoListProvider);

                      if (selectedQCList.isNotEmpty) {
                        qcList = selectedQCList;
                        return getTable(selectedQCList);
                      } else {
                        qcList = [];
                        return Center(
                          child: LangText(
                            'No product for Damage',
                            // style: TextStyle(color: textFieldGrey),
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),
          SubmitButtonGroup(
            twoButtons: false,
            button2Label: "Submit Damage",
            onButton1Pressed: (){
              Alerts(context: context).customDialog(
                  type: AlertType.info,
                  twoButtons: true,
                  description: "Are you sure to save Damage?", // আপনি কি QC জমা দিতে চান?
                  onTap1: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(qcList);
                  });
            },
          )
        ],
      ),
    );
  }

  Widget getTable(List<SelectedQCInfoModel> qcList) {
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
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [grey, darkGrey],
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
                      'SKU',
                      style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                    ),
                    LangText(
                      'Damage Type',
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: qcList.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return getTableItem(qcList[index]);
                }),
          ),
          Container(
            width: 100.w,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomRight: Radius.circular(5.sp), bottomLeft: Radius.circular(5.sp)), color: Colors.grey[200]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: LangText('Total Damage settlement', style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(child: Container()),
                    Expanded(
                      child: Consumer(builder: (context, ref, _) {
                        // List<SelectedQCInfoModel> list = ref.watch(selectedQCInfoListProvider);
                        int totalQCSum = ref.watch(totalQCQuantityProvider);
                        return LangText(
                          totalQCSum.toString(),
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold),
                        );
                      }),
                    )
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: LangText('Settlement Value', style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(child: Container()),
                    Expanded(
                      child: Consumer(builder: (context, ref, _) {
                        // List<SelectedQCInfoModel> list = ref.watch(selectedQCInfoListProvider);
                        AsyncValue<double> totalQCValueAsync = ref.watch(qcValueProvider);
                        return totalQCValueAsync.when(
                            data: (qcTotalValue) {
                              return Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    LangText(
                                      qcTotalValue.toStringAsFixed(2),
                                      textAlign: TextAlign.end,
                                      style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold),
                                    ),
                                    LangText(
                                      'BDT',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(fontSize: normalFontSize, fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              );
                            },
                            error: (error, _) => Container(),
                            loading: () => Container());
                      }),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getItem(ProductDetailsModel sku) {
    return InkWell(
      onTap: () {
        QCController(context: context, ref: ref).navigateSKUForQC(sku);
        Navigator.pushNamed(context, QCEntryUI.routeName);
        // ref.read(selectedProductForQCProvider.state).state = sku;
        // Map<int, int> qcPrevData = QCController(context: context, ref: ref).getQcQuantityData(sku);
        //
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
        child: Container(
          width: 25.w,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: Colors.white, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(5.sp),
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
              Center(child: AssetService(context).superImage('${sku.id}.png', folder: 'SKU', version: SyncReadService().getAssetVersion('SKU'), height: 12.h)),
              Expanded(
                child: Center(
                  child: LangText(
                    sku.shortName,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: red3, fontSize: smallFontSize),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getTableItem(SelectedQCInfoModel qcItem) {
    String qcType = '';
    int totalAmount = 0;
    for (QCInfoModel val in qcItem.qcInfoList) {
      qcType += val.name;
      qcType += ',';
      if (val.totalQuantity() == 0) {
        return Container();
      }
      totalAmount += val.totalQCQuantity;
    }
    qcType = qcType.substring(0, qcType.length - 1);
    totalQC += totalAmount;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: LangText(
            qcItem.sku.shortName,
            style: TextStyle(color: red3, fontSize: normalFontSize),
          ),
        ),
        Expanded(
          child: LangText(
            qcType,
            textAlign: TextAlign.left,
            style: TextStyle(color: red3, fontSize: normalFontSize),
          ),
        ),
        Expanded(
          child: LangText(
            totalAmount.toString(),
            textAlign: TextAlign.right,
            style: TextStyle(color: red3, fontSize: normalFontSize),
          ),
        ),
      ],
    );
  }
}
