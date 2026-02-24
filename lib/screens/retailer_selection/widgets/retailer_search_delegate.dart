import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wings_olympic_sr/constants/constant_variables.dart';
import 'package:wings_olympic_sr/screens/retailer_selection/widgets/retailer_list_widget.dart';

import '../../../main.dart';
import '../../../models/outlet_model.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../models/retailer_selection_config.dart';
import '../models/suggestion_model.dart';

class RetailerSearchDelegate extends SearchDelegate<OutletModel> {
  final List<OutletModel> retailerList;
  final RetailerSelectionConfig? retailerSelectionConfig;

  RetailerSearchDelegate({
    required this.retailerList,
    required this.retailerSelectionConfig,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      TextButton(
        onPressed: () {
          query = '';
        },
        child: LangText('Clear'),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        navigatorKey.currentState?.pop();
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final resultList = query.isEmpty
        ? retailerList
        : retailerList.where((retailer) {
            final nameMatched = retailer.name.toLowerCase().contains(query.toLowerCase());
            final owner = retailer.owner.toLowerCase().contains(query.toLowerCase());
            final phoneMatched = retailer.contact?.toLowerCase().contains(query.toLowerCase()) ?? false;
            final codeMatched = retailer.outletCode?.toLowerCase().contains(query.toLowerCase()) ?? false;
            final addressMatched = retailer.address?.toLowerCase().contains(query.toLowerCase()) ?? false;
            return nameMatched || owner || phoneMatched || codeMatched || addressMatched;
          }).toList();

    return RetailerListWidget(
      retailerList: resultList,
      navigationTileEnabled: retailerSelectionConfig?.showNavButtons,
      onRetailerSelect: (retailer) {
        navigatorKey.currentState?.pop(retailer);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    buildResults(context);

    List<SuggestionModel> suggestionsList = [];

    if (query.isEmpty) {
      suggestionsList = [];
    } else {
      final retailerKeyList = <SuggestionModel>[];
      for (var ret in retailerList) {
        retailerKeyList.add(SuggestionModel(type: 'Owner', value: ret.owner));
        retailerKeyList.add(SuggestionModel(type: 'Store', value: ret.name));
        if (ret.contact != null) {
          retailerKeyList.add(SuggestionModel(type: 'Contact', value: ret.contact!));
        }
        if (ret.outletCode != null) {
          retailerKeyList.add(SuggestionModel(type: 'Code', value: ret.outletCode!));
        }
        if (ret.address != null) {
          retailerKeyList.add(SuggestionModel(type: 'Address', value: ret.address ?? ''));
        }
      }

      suggestionsList = retailerKeyList.where((suggestion) {
        return suggestion.value.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    return ListView.builder(
      itemCount: suggestionsList.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {

        IconData iconData = Icons.search;

        switch (suggestionsList[index].type) {
          case 'Owner':
            iconData = Icons.person;
          case 'Store':
            iconData = Icons.store;
          case 'Contact':
            iconData = Icons.call;
          case 'Code':
            iconData = Icons.numbers;
          case 'Address':
            iconData = Icons.location_on_rounded;
        }

        return Column(
          children: [
            ListTile(
              onTap: () {
                query = suggestionsList[index].value;
                showResults(context);
              },
              title: Row(
                children: [
                  Icon(iconData, size: 16, color: primary,),
                  const SizedBox(width: 8),
                  Expanded(child: LangText(suggestionsList[index].value)),
                ],
              ),
              // subtitle: Row(
              //   children: [
              //     Icon(iconData),
              //     const SizedBox(width: 8),
              //     LangText(
              //       suggestionsList[index].type,
              //       style: const TextStyle(
              //         color: Colors.black38,
              //       ),
              //     ),
              //   ],
              // ),
            ),
            const Divider(),
          ],
        );
      },
    );
  }
}
