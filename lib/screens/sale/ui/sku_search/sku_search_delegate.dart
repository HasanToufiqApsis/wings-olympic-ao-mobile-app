import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wings_olympic_sr/models/products_details_model.dart';
import 'package:wings_olympic_sr/screens/sale/controller/sale_controller.dart';
import 'package:wings_olympic_sr/screens/sale/model/product_view.dart';
import 'package:wings_olympic_sr/services/search_history_db_service.dart';
import 'package:wings_olympic_sr/utils/sales_type_utils.dart';

import '../../../../constants/constant_variables.dart';
import '../../../../main.dart';
import '../../../../models/sale_summary_model.dart';
import '../../../../provider/global_provider.dart';
import '../../../../reusable_widgets/language_textbox.dart';
import '../../../retailer_selection/models/suggestion_model.dart';
import '../sale_v2_widget/sku_list_tile.dart';

class SkuSearchDelegate extends SearchDelegate {
  final SaleController saleController;
  final Map<String, List<ProductDetailsModel>> data;
  final Map<int, SalesSummaryModel> skuIdWiseSalesSummary;
  final Map<String, dynamic> preOrderData;
  final int totalRetailerCount;
  final ViewComplexity viewType;

  SkuSearchDelegate({
    required this.saleController,
    required this.data,
    required this.skuIdWiseSalesSummary,
    required this.totalRetailerCount,
    required this.preOrderData,
    required this.viewType,
  });

  final searchHistoryDbService = SearchHistoryDbService();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(
          Icons.cancel_outlined,
          color: Colors.grey,
        ),
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
    final allProducts = data['All'] ?? [];

    if(query.isNotEmpty){
      bool isProduct = false;
      for (var product in allProducts) {
        if(product.name == query || product.shortName == query || product.filterType == query){
          isProduct = true;
          break;
        }
      }
      if(!isProduct){
        searchHistoryDbService.addItem(searchKey: query);
      }
    }

    final resultList = query.isEmpty
        ? allProducts
        : allProducts.where((product) {
            final nameMatched = _matchString(baseString: product.name);
            final shortNameMatched = _matchString(baseString: product.shortName);
            final classMatched = _matchString(baseString: product.filterType);

            return nameMatched || shortNameMatched || classMatched;
          }).toList();

    return ListView.builder(
      itemCount: resultList.length,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: 56,
      ),
      itemBuilder: (context, index) {
        final memoCount = skuIdWiseSalesSummary[resultList[index].id]?.memo ?? 0;
        final bcp = memoCount == 0 ? 0.0 : (memoCount / totalRetailerCount) * 100;
        final preOrderVolume = preOrderData[resultList[index].id.toString()] ?? 0;
        return SkuListTile(
          saleType: SaleType.preorder,
          sku: resultList[index],
          saleController: saleController,
          showPreorderInfo: false,
          viewType: viewType,
          bcpValue: bcp,
          preOrderVolume: preOrderVolume,
          soqVolume: 0,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Consumer(builder: (context, ref, _) {
        final asyncSearchHistoryList = ref.watch(recentSearchListProvider);
        return asyncSearchHistoryList.when(
          data: (searchHistoryList) {
            return ListView.builder(
              itemCount: searchHistoryList.length,
              itemBuilder: (context, index) {
                final history = searchHistoryList[index];
                return ListTile(
                  title: Text(history),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Icon(Icons.history, color: Colors.grey,),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.close, color: Colors.grey,),
                    onPressed: () async {
                      await searchHistoryDbService.deleteItem(searchKey: history);
                      ref.refresh(recentSearchListProvider);
                    },
                  ),
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    query = history;
                    showResults(context);
                  },
                );
              },
            );
          },
          error: (error, _) => const SizedBox(),
          loading: () => const SizedBox(),
        );
      });
    }

    final allProducts = data['All'] ?? [];
    List<SuggestionModel> suggestionsList = [];
    final keySet = <String>{};

    if (query.isEmpty) {
      suggestionsList = [];
    } else {
      final retailerKeyList = <SuggestionModel>[];
      for (var ret in allProducts) {
        if (!keySet.contains(ret.shortName)) {
          retailerKeyList.add(SuggestionModel(type: 'Product', value: ret.shortName));
          keySet.add(ret.shortName);
        }
        if (!keySet.contains(ret.name)) {
          retailerKeyList.add(SuggestionModel(type: 'Product', value: ret.name));
          keySet.add(ret.name);
        }
        if (!keySet.contains(ret.filterType)) {
          retailerKeyList.add(SuggestionModel(type: 'Classification', value: ret.filterType));
          keySet.add(ret.filterType);
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
          case 'Product':
            iconData = CupertinoIcons.cube_box;
          case 'Classification':
            iconData = Icons.category;
        }

        return Column(
          children: [
            ListTile(
              onTap: () {
                searchHistoryDbService.addItem(searchKey: suggestionsList[index].value);
                query = suggestionsList[index].value;
                showResults(context);
              },
              title: Row(
                children: [
                  Icon(
                    iconData,
                    size: 16,
                    color: primary,
                  ),
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

  bool _matchString({required String baseString}) {
    return baseString.toLowerCase().contains(query.toLowerCase());
  }
}
