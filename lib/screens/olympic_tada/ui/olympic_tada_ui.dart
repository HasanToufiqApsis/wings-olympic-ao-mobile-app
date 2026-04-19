import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/dashboard_btn_names.dart';
import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/input_fields/dropdowns.dart';
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../leave_management/model/selected_vehicle_with_tada.dart';
import '../../leave_management/model/ta_da_vehicle_model.dart';
import '../../retailer_selection/providers/retailer_selection_providers.dart';
import '../controller/olympic_tada_controller.dart';
import '../model/drafted_ta_da.dart';
import '../model/extra_ta_da_model.dart';
import '../model/selected_vehicle_with_tada_olympic.dart';
import '../providers/olympic_tada.dart';

class OlympicTaDaUi extends ConsumerStatefulWidget {
  static const routeName = 'OlympicTaDaUi';
  final bool visibleSubmitTaDa;

  const OlympicTaDaUi({super.key, required this.visibleSubmitTaDa});

  @override
  ConsumerState createState() => _OlympicTaDaUiState();
}

class _OlympicTaDaUiState extends ConsumerState<OlympicTaDaUi> {
  final _appBarTitle = DashboardBtnNames.taDa;
  late final OlympicTaDaController _controller;
  final TextEditingController _remarksController = TextEditingController();
  bool _dataLoaded = false;

  @override
  void initState() {
    _controller = OlympicTaDaController(context: context, ref: ref);
    super.initState();
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fareChartsProviderAsync = ref.watch(getServicesClustersProvider);
    final fixedTaDaModel = ref.watch(fixedTaDaForOlympicTaDaProvider);

    final commonShadow = [
      BoxShadow(
        color: Colors.grey.withOpacity(0.15),
        blurRadius: 20,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(
        title: _appBarTitle,
        titleImage: "taDa.png",
        onLeadingIconPressed: () => Navigator.pop(context),
        heroTagTitle: _appBarTitle,
        heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            fareChartsProviderAsync.when(
              loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  )),
              error: (e, st) => Center(
                child: LangText('Error: $e',
                    style: const TextStyle(color: Colors.red)),
              ),
              data: (fareCharts) {
                Map<String, Map<String, dynamic>> groupedData = {};

                for (var item in fareCharts) {
                  double amount =
                      double.tryParse(item.fareInAmount.toString()) ?? 0.0;
                  double distance =
                      double.tryParse(item.distanceInKm.toString()) ?? 0.0;

                  if (groupedData.containsKey(item.categorySlug)) {
                    groupedData[item.categorySlug]!['amount'] += amount;
                    groupedData[item.categorySlug]!['distance'] += distance;
                  } else {
                    groupedData[item.categorySlug] = {
                      'amount': amount,
                      'distance': distance,
                      'originalItem': item,
                    };
                  }
                }

                List<dynamic> mergedList = groupedData.entries.map((entry) {
                  var data = entry.value;
                  return {
                    'categorySlug': entry.key,
                    'fareInAmount': data['amount'],
                    'distanceInKm': data['distance'],
                  };
                }).toList();

                return fixedTaDaModel.when(
                  data: (fixedTaDa) {
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: primary.withOpacity(0.1),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'Transport',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: primary,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Fare Amount',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: primary,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Distance',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: primary,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.separated(
                                shrinkWrap: true,
                                itemCount: mergedList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) => Divider(
                                  height: 1,
                                  color: Colors.grey[200],
                                ),
                                itemBuilder: (context, index) {
                                  final item = mergedList[index];
                                  final isLast = index == mergedList.length - 1;

                                  String totalFare = double.parse(
                                      item['fareInAmount'].toString())
                                      .toStringAsFixed(2);
                                  String totalDistance = double.parse(
                                      item['distanceInKm'].toString())
                                      .toStringAsFixed(1);

                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: index % 2 == 0
                                          ? Colors.grey[50]
                                          : Colors.white,
                                      borderRadius: isLast
                                          ? const BorderRadius.only(
                                        bottomLeft: Radius.circular(16),
                                        bottomRight: Radius.circular(16),
                                      )
                                          : null,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            children: [
                                              Container(
                                                padding:
                                                const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color:
                                                  primary.withOpacity(0.1),
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                  Icons.directions_bus,
                                                  size: 16,
                                                  color: primary,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  item['categorySlug'],
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Center(
                                            child: Text(
                                              '৳ $totalFare',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            '$totalDistance km',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blueGrey[700],
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: primary.withOpacity(0.1),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: LangText(
                                        'Fixed Allowance',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: primary,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: LangText(
                                        'Amount',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: primary,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: fixedTaDa.length,
                                separatorBuilder: (ctx, i) => Divider(
                                  height: 1,
                                  color: Colors.grey[200],
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  final isLast = index == fixedTaDa.length - 1;
                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: index % 2 == 0
                                          ? Colors.grey[50]
                                          : Colors.white,
                                      borderRadius: isLast
                                          ? const BorderRadius.only(
                                        bottomLeft: Radius.circular(16),
                                        bottomRight: Radius.circular(16),
                                      )
                                          : null,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            children: [
                                              Container(
                                                padding:
                                                const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.orange
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                  Icons.local_offer_rounded,
                                                  size: 16,
                                                  color: Colors.orange[800],
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: LangText(
                                                  fixedTaDa[index].slug ?? "",
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: LangText(
                                            "৳ ${fixedTaDa[index].amount}",
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Consumer(
                          builder: (BuildContext context, WidgetRef ref,
                              Widget? child) {
                            final asyncLeaveModel =
                            ref.watch(extraTaDaForOlympicTaDaProvider);
                            final draftedTaDaAsync =
                            ref.watch(draftedTaDaProvider);
                            final vehicleTaDas =
                            ref.watch(selectedOlympicTaDaTypeProvider);

                            return asyncLeaveModel.when(
                              data: (availableTaDaCat) {
                                return draftedTaDaAsync.when(
                                  data: (draftedTaDa) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((timeStamp) {
                                      if (!_dataLoaded) {
                                        _dataLoaded = true;
                                        if (draftedTaDa != null &&
                                            draftedTaDa.draftedTaDa != null &&
                                            draftedTaDa
                                                .draftedTaDa!.isNotEmpty) {
                                          ref
                                              .read(
                                              selectedOlympicTaDaTypeProvider
                                                  .notifier)
                                              .removeTaDa(index: 0);
                                        }
                                        _remarksController.text =
                                            draftedTaDa?.remarks ?? "";
                                        for (var val in draftedTaDa
                                            ?.draftedTaDa ??
                                            <DraftedTaDa>[]) {
                                          var index =
                                          availableTaDaCat.indexWhere(
                                                  (e) => e.id == val.costType);
                                          if (index != -1) {
                                            final taDa =
                                            availableTaDaCat[index];
                                            ref
                                                .read(
                                                selectedOlympicTaDaTypeProvider
                                                    .notifier)
                                                .addAnother(
                                                taDa:
                                                SelectedVehicleWithTaDaOlympic(
                                                  textEditingController:
                                                  TextEditingController(
                                                      text: "${val.cost}"),
                                                  selectedTaDa: taDa,
                                                ));
                                          }
                                        }
                                      }
                                    });

                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                            Colors.black.withOpacity(0.08),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: primary.withOpacity(0.1),
                                              borderRadius:
                                              const BorderRadius.only(
                                                topLeft: Radius.circular(16),
                                                topRight: Radius.circular(16),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: LangText(
                                                    'Extra Expenses',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                      color: primary,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  flex: 2,
                                                  child: LangText(
                                                    'Amount',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                      color: primary,
                                                    ),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                            const NeverScrollableScrollPhysics(),
                                            itemCount: vehicleTaDas.length,
                                            separatorBuilder: (ctx, i) =>
                                                Divider(
                                                    height: 1,
                                                    color: Colors.grey[200]),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Padding(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 12),
                                                child: Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child:
                                                      CustomSingleDropdown<
                                                          ExtraTaDaType>(
                                                        items: availableTaDaCat
                                                            .map<
                                                            DropdownMenuItem<
                                                                ExtraTaDaType>>(
                                                              (e) =>
                                                              DropdownMenuItem(
                                                                value: e,
                                                                child: Text(
                                                                  e.slug ?? "",
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                                  style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                      14),
                                                                ),
                                                              ),
                                                        )
                                                            .toList(),
                                                        onChanged:
                                                            (ExtraTaDaType?
                                                        val) {
                                                          ref
                                                              .read(
                                                              selectedOlympicTaDaTypeProvider
                                                                  .notifier)
                                                              .updateTaDaType(
                                                            taDa:
                                                            vehicleTaDas[
                                                            index],
                                                            index: index,
                                                            taDaItem: val!,
                                                          );
                                                        },
                                                        hintText: "Select Type",
                                                        value:
                                                        vehicleTaDas[index]
                                                            .selectedTaDa,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      flex: 2,
                                                      child: IgnorePointer(
                                                        ignoring: !(vehicleTaDas[
                                                        index]
                                                            .selectedTaDa
                                                            ?.isTextInput ??
                                                            false),
                                                        child: Consumer(
                                                          builder: (context,
                                                              ref, _) {
                                                            return InputTextFields(
                                                              textEditingController: vehicleTaDas[index].textEditingController,
                                                              hintText: "0.00",
                                                              inputType:
                                                              TextInputType
                                                                  .number,
                                                              // textAlign: TextAlign.right,
                                                              onChanged: (v) =>
                                                                  setState(
                                                                          () {}),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    // const SizedBox(width: 12),
                                                    // InkWell(
                                                    //   onTap: () {
                                                    //     if (index + 1 ==
                                                    //         vehicleTaDas
                                                    //             .length) {
                                                    //       ref
                                                    //           .read(
                                                    //           selectedOlympicTaDaTypeProvider
                                                    //               .notifier)
                                                    //           .addNew();
                                                    //     } else {
                                                    //       ref
                                                    //           .read(
                                                    //           selectedOlympicTaDaTypeProvider
                                                    //               .notifier)
                                                    //           .removeTaDa(
                                                    //           index: index);
                                                    //     }
                                                    //   },
                                                    //   child: Container(
                                                    //     width: 40,
                                                    //     height: 40,
                                                    //     decoration:
                                                    //     BoxDecoration(
                                                    //       color: index + 1 ==
                                                    //           vehicleTaDas
                                                    //               .length
                                                    //           ? primary
                                                    //           : Colors
                                                    //           .grey[200],
                                                    //       borderRadius:
                                                    //       BorderRadius
                                                    //           .circular(8),
                                                    //     ),
                                                    //     child: Icon(
                                                    //       index + 1 ==
                                                    //           vehicleTaDas
                                                    //               .length
                                                    //           ? Icons.add
                                                    //           : Icons.close,
                                                    //       color: index + 1 ==
                                                    //           vehicleTaDas
                                                    //               .length
                                                    //           ? Colors.white
                                                    //           : Colors.black54,
                                                    //       size: 20,
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  error: (_, __) => const SizedBox(),
                                  loading: () => const SizedBox(),
                                );
                              },
                              error: (_, __) => const SizedBox(),
                              loading: () => const SizedBox(),
                            );
                          },
                        ),
                        Consumer(
                          builder: (context, ref, _) {
                            final vehicleTaDas =
                            ref.watch(selectedOlympicTaDaTypeProvider);
                            final transportCategorySum = fareCharts.fold<num>(
                                0, (sum, fare) => sum + fare.fareInAmount);
                            final extraTaDaSum =
                            vehicleTaDas.fold<num>(0, (sum, item) {
                              final cost = double.tryParse(
                                  item.textEditingController?.text ?? '0') ??
                                  0;
                              return sum + cost;
                            });
                            final fixedTaDaSum = fixedTaDa
                                .map((e) => e.amount ?? 0.0)
                                .fold<double>(0.0, (sum, item) => sum + item);

                            final overallSum = transportCategorySum +
                                extraTaDaSum +
                                fixedTaDaSum;

                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: commonShadow,
                                border: Border.all(color: Colors.grey.shade100),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      LangText(
                                        'Payment Breakdown',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[800]),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  _buildSimpleRow("Transport Cost",
                                      transportCategorySum, Colors.blueGrey),
                                  const SizedBox(height: 12),
                                  _buildSimpleRow("Fixed TA/DA", fixedTaDaSum,
                                      Colors.orange[700]!),
                                  const SizedBox(height: 12),
                                  _buildSimpleRow("Extra TA/DA", extraTaDaSum,
                                      Colors.orange[700]!),
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                    child: Divider(
                                        color: Colors.grey[200], thickness: 1),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      LangText(
                                        'Overall Total',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                      LangText(
                                        '৳ ${(overallSum).toStringAsFixed(0)}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: commonShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LangText("Remarks",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700])),
                              const SizedBox(height: 12),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InputTextFields(
                                  textEditingController: _remarksController,
                                  hintText: "Add any additional notes here...",
                                  maxLine: 3,
                                  inputType: TextInputType.multiline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                          child: SubmitButtonGroup(
                            button1Label: "Draft Ta/Da",
                            button2Label: "Submit Ta/Da",
                            twoButtons: widget.visibleSubmitTaDa,
                            onButton1Pressed: () => _controller.draftTaDa(
                                remarks: _remarksController.text),
                            onButton2Pressed: () =>
                                _controller.submitTaDaToServer(
                                    fareCharts: fareCharts,
                                    remarks: _remarksController.text),
                          ),
                        ),
                      ],
                    );
                  },
                  error: (_, __) => const SizedBox(),
                  loading: () => const SizedBox(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleRow(String title, num amount, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
                width: 8,
                height: 8,
                decoration:
                BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 10),
            LangText(title,
                style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500)),
          ],
        ),
        LangText(
          '৳ ${amount.toStringAsFixed(0)}',
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
      ],
    );
  }
}
