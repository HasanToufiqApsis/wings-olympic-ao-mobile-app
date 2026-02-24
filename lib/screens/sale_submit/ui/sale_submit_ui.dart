import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/dashboard_btn_names.dart';
import 'package:wings_olympic_sr/utils/extensions/widget_extensions.dart';
import 'dart:ui' as ui;
import '../../../constants/constant_variables.dart';
import '../../../models/sale_submit_table_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../controller/sale_submit_controller.dart';

class SaleSubmitUI extends ConsumerStatefulWidget {
  static const routeName ="sale_submit";
  SaleSubmitUI({Key? key}) : super(key: key);

  @override
  ConsumerState<SaleSubmitUI> createState() => _SaleSubmitUIState();
}

class _SaleSubmitUIState extends ConsumerState<SaleSubmitUI> {
  final _appBarTitle = DashboardBtnNames.salesSubmit;
  bool allSynced = false;
  late SaleSubmitController submitSalesController;

  List<SaleSubmitTableModel> deviceData = [];
  @override
  void initState() {
    submitSalesController = SaleSubmitController(context: context, ref: ref);
    super.initState();
  }

  final demoList = ["Preorder outlet count",
    "Sale outlet count",
    "Preorder",
    "Sale",
    "Stock",
    "Damage",
    "Preorder promotion",
    "Sale promotion"];

  @override
  Widget build(BuildContext context) {
    AsyncValue<bool> asyncAlreadySalesSubmit = ref.watch(salesSubmittedProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: _appBarTitle,
        titleImage: "sync.png",
        showLeading: true,
        heroTagTitle: _appBarTitle,
        heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: SizedBox(
          height: 100.h,
          child: ListView(
            children: [
              /// online status
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LangText('Device Online Status'),
                  SizedBox(width: 1.w),
                  Consumer(builder: (context, ref, _) {
                    bool isConnected = ref.watch(internetConnectivityProvider);

                    if (isConnected == true) {
                      ///get server data when internet is on
                      submitSalesController.getSaleSubmitServerData();
                      return RichText(
                        text: TextSpan(children: [
                          WidgetSpan(
                              child: Icon(
                                Icons.circle,
                                color: Colors.green,
                                size: 12.sp,
                              )),
                          WidgetSpan(child: SizedBox(width: 0.5.w)),
                          WidgetSpan(
                              alignment: ui.PlaceholderAlignment.middle,
                              child: LangText(
                                'Online',
                                style: const TextStyle(color: Colors.green),
                              )),
                        ]),
                      );
                    } else {
                      return RichText(
                        text: TextSpan(children: [
                          WidgetSpan(
                              child: Icon(
                                Icons.circle,
                                color: Colors.red,
                                size: 12.sp,
                              )),
                          WidgetSpan(child: SizedBox(width: 0.5.w)),
                          WidgetSpan(
                              alignment: ui.PlaceholderAlignment.middle,
                              child: LangText(
                                'Offline',
                                style: const TextStyle(color: Colors.red),
                              )),
                        ]),
                      );
                    }
                  }),
                ],
              ),
              SizedBox(height: 2.h),

              ///=============== Sale Data List ===============================

              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// table title
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(5.sp)),
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
                              Expanded(
                                flex: 3,
                                child: LangText(
                                  'Topic',
                                  style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: LangText(
                                  'Device',
                                  style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                                ),
                              ),
                              LangText(
                                'Server',
                                style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// table data
                    Consumer(builder: (context, ref, _) {
                      Map serverData = ref.watch(saleSummaryServerDataProvider);

                      return Container(
                        color: Colors.white,
                        child: FutureBuilder(
                            future: submitSalesController.getSubmittedSaleData(),
                            builder: (context, AsyncSnapshot<List<SaleSubmitTableModel>> snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                deviceData = snapshot.data??[];
                                return ListView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        color: index%2==0?Colors.white:Colors.grey.shade50,
                                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: LangText(
                                                '${snapshot.data?[index].title}',
                                                style: TextStyle(fontSize: smallFontSize, color: grey),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: LangText(
                                                '${snapshot.data?[index].value.toString().nonZeroText}',
                                                isNumber: true,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: smallFontSize, color: grey),
                                              ),
                                            ),
                                            Expanded(
                                              child: LangText(
                                                '${serverData[snapshot.data?[index].key] ?? '-'}',
                                                isNumber: true,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: smallFontSize, color: grey),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              } else {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: demoList.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        color: index%2==0?Colors.white:Colors.grey.shade50,
                                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: LangText(
                                                demoList[index],
                                                style: TextStyle(fontSize: smallFontSize, color: grey),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: LangText(
                                                '',
                                                isNumber: true,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: smallFontSize, color: grey),
                                              ),
                                            ),
                                            Expanded(
                                              child: LangText(
                                                '',
                                                isNumber: true,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: smallFontSize, color: grey),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              }
                            }),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              /// ================ sync ==========================
              Consumer(builder: (context, ref, _) {
                bool isConnected = ref.watch(internetConnectivityProvider);
                return asyncAlreadySalesSubmit.when(
                    data: (alreadySalesSubmitted){
                      return Column(
                        children: [
                          SubmitButtonGroup(
                            button1Label: "Day Close",
                            button1Color: (isConnected == true && !alreadySalesSubmitted)? darkGreen : lightMediumGrey,
                            onButton1Pressed:  () {
                              if(isConnected == true && !alreadySalesSubmitted) {
                                submitSalesController.syncAllDataForASectionToServer(deviceData);
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          Visibility(
                            visible: alreadySalesSubmitted,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.orange.withOpacity(0.2)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      color: Colors.orange[800], size: 20,),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: LangText(
                                      "You already close your day. To do service again please reset first",
                                      style: TextStyle(
                                          color: Colors.orange[900],
                                          fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    error: (error, _) {
                      debugPrint(error.toString());
                      return Container();
                    },
                    loading: ()=>Center(child: CircularProgressIndicator(),)
                );
              }),
              SizedBox(height: 2.h),

              ///=============== submit sale ====================
              // Consumer(builder: (context, ref, _) {
              //   bool isConnected = ref.watch(internetConnectivityProvider);
              //   bool buttonOn = ref.watch(saleSubmitButtonProvider);
              //   if (isConnected) {
              //     return SubmitButtonGroup(
              //       button1Label: "Sale Submit",
              //       button1Color: isConnected == true ?blue3 : lightMediumGrey,
              //       onButton1Pressed:isConnected == true
              //           ?  (){
              //         submitSalesController.saleSubmit();
              //       }
              //           :
              //           (){},
              //     );
              //
              //   } else {
              //     ///=================== export pda ==============================
              //     return SubmitButtonGroup(
              //       button1Label: "Export Pda",
              //       button1Color: blue3 ,
              //       onButton1Pressed:isConnected == true
              //           ?  (){
              //         // submitSalesController.exportPda();
              //       }
              //           :
              //           (){},
              //     );
              //
              //   }
              // }),
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
