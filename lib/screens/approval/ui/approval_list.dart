import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/products_details_model.dart';
import '../../../models/route_change_model_tsm.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../sale/ui/sku_case_piece_show_widget.dart';
import 'single_approval.dart';

class ApprovalList extends StatefulWidget {
  static const routeName = "/approval_list";
  const ApprovalList({Key? key}) : super(key: key);

  @override
  State<ApprovalList> createState() => _ApprovalListState();
}

class _ApprovalListState extends State<ApprovalList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Approval",
        showLeading: true,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 2.h, left: 5.w, right: 5.w, top: 5.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// sku list
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(5.sp), topLeft: Radius.circular(5.sp)),
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
                      Expanded(
                        child: LangText(
                          'Date',
                          style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: LangText(
                            'Present Route',
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                          ),
                        ),
                      ),
                      Expanded(
                        child: LangText(
                          'Requested Route',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                        ),
                      ),
                      Expanded(
                        child: LangText(
                          'Action',
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.white, fontSize: normalFontSize),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              color: Colors.white,
              child: Consumer(
                  builder: (context,ref,_) {
                    AsyncValue<List<ChangeRouteTSMModel>> asyncChangeRouteList = ref.watch(getSrChangeRouteListForTSMProvider);
                    return asyncChangeRouteList.when(
                        data: (changeRouteList){
                          if(changeRouteList.isEmpty){
                            return Center(
                              child: LangText(
                                  "Nothing to show"
                              ),
                            );
                          }
                          return ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: changeRouteList.length,
                              itemBuilder: (context, index1) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: LangText(
                                          uiDateFormat.format(changeRouteList[index1].effectiveStartDate),
                                          style: TextStyle(fontSize: smallFontSize, color: grey),
                                          // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
                                        ),
                                      ),
                                      Expanded(
                                        child: LangText(
                                          changeRouteList[index1].presentRoute,
                                          style: TextStyle(fontSize: smallFontSize, color: grey),
                                          // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
                                        ),
                                      ),
                                      Expanded(
                                        child: LangText(
                                          changeRouteList[index1].requestRoute,
                                          style: TextStyle(fontSize: smallFontSize, color: grey),
                                          // style: TextStyle(fontSize: smallFontSize, color: item['amount'] == null ? purple : grey),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context, SingleApproval.routeName, arguments: changeRouteList[index1]);
                                        },
                                        child: Expanded(
                                          child: LangText(
                                            'view',
                                            isNumber: true,
                                            textAlign: TextAlign.end,
                                            style: TextStyle(fontSize: smallFontSize, color: grey),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                        error: (error, _)=>Container(),
                        loading: ()=> const Center(child: CircularProgressIndicator(),)
                    );

                  }
              ),
            ),
            Column(
              children: [
                Container(
                  width: 100.w,
                  height: 4.h,
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(5.sp), bottomLeft: Radius.circular(5.sp)),
                    gradient: const LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [primary, primaryBlue],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
