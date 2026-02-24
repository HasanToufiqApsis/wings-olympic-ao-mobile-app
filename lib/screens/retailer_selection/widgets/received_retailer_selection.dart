import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/constant_variables.dart';

import '../../../main.dart';
import '../../../models/outlet_model.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../models/retailer_selection_config.dart';
import 'retailer_list_widget.dart';
import 'retailer_search_delegate.dart';

class ReceivedRetailerSelection extends StatefulWidget {
  final RetailerSelectionConfig? config;
  final List<OutletModel> retailerList;
  final Function(OutletModel) onRetailerSelect;

  const ReceivedRetailerSelection({
    super.key,
    required this.config,
    required this.retailerList,
    required this.onRetailerSelect,
  });

  @override
  State<ReceivedRetailerSelection> createState() => _ReceivedRetailerSelectionState();
}

class _ReceivedRetailerSelectionState extends State<ReceivedRetailerSelection> {

  List<OutletModel> retailerList = [];

  @override
  void initState() {
    retailerList = widget.retailerList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: Center(
          child: AppBar(
            title: LangText(
              'Select Retailer',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: primary,
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () async {
                  final retailer = await showSearch(
                    context: context,
                    delegate: RetailerSearchDelegate(
                      retailerList: retailerList,
                      retailerSelectionConfig: widget.config,
                    ),
                  );

                  if (retailer != null) {
                    navigatorKey.currentState?.pop(retailer);
                  }
                },
                icon: const Icon(
                  color: Colors.white,
                  CupertinoIcons.search,
                ),
              ),
            ],
            leading: Padding(
              padding: EdgeInsets.only(left: 3.w),
              child: Container(
                height: 7.h,
                decoration: BoxDecoration(
                  color: greenOlive.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      navigatorKey.currentState?.pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Builder(builder: (context) {
        return Column(
          children: [
            Expanded(
              child: RetailerListWidget(
                navigationTileEnabled: widget.config?.showNavButtons,
                retailerList: retailerList,
                onRetailerSelect: widget.onRetailerSelect,
              ),
            ),
          ],
        );
      }),
    );
  }
}
