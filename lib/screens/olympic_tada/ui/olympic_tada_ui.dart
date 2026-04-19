import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/dashboard_btn_names.dart';
import '../../../constants/constant_variables.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../leave_management/model/ta_da_vehicle_model.dart';
import '../controller/olympic_tada_controller.dart';
import '../model/drafted_ta_da.dart';
import '../model/olympic_da_info.dart';
import '../model/olympic_tada_entry.dart';
import '../service/olympic_tada_service.dart';

class OlympicTaDaUi extends ConsumerStatefulWidget {
  static const routeName = 'OlympicTaDaUi';

  const OlympicTaDaUi({super.key, required this.visibleSubmitTaDa});

  final bool visibleSubmitTaDa;

  @override
  ConsumerState<OlympicTaDaUi> createState() => _OlympicTaDaUiState();
}

class _OlympicTaDaUiState extends ConsumerState<OlympicTaDaUi> {
  final _appBarTitle = DashboardBtnNames.taDa;
  final OlympicTaDaService _service = OlympicTaDaService();
  final TextEditingController _remarksController = TextEditingController();

  late final OlympicTaDaController _controller;

  bool _loading = true;
  String? _daMessage;
  OlympicDaInfo? _daInfo;
  List<TaDaVehicleModel> _vehicleTypes = <TaDaVehicleModel>[];
  List<OlympicTaDaEntry> _entries = <OlympicTaDaEntry>[];

  @override
  void initState() {
    super.initState();
    _controller = OlympicTaDaController(context: context, ref: ref);
    _loadData();
  }

  @override
  void dispose() {
    _remarksController.dispose();
    for (final entry in _entries) {
      entry.dispose();
    }
    super.dispose();
  }

  Future<void> _loadData() async {
    final oldEntries = _entries;
    final vehicleTypes = await _service.vehicleTypeList();
    final draft = await _service.getDraftTaDa();
    final daResolution = await _service.resolveDaForCurrentSalesDate();

    if (!mounted) return;

    final loadedEntries = _buildEntriesFromDraft(
      draft: draft,
      vehicles: vehicleTypes,
    );

    setState(() {
      for (final entry in oldEntries) {
        entry.dispose();
      }
      _vehicleTypes = vehicleTypes;
      _entries = loadedEntries.isEmpty ? <OlympicTaDaEntry>[OlympicTaDaEntry()] : loadedEntries;
      _remarksController.text = draft?.remarks ?? '';
      _daInfo = daResolution.daInfo ?? draft?.daInfo;
      _daMessage = daResolution.daInfo != null
          ? null
          : (_daInfo != null ? 'Showing DA from saved draft.' : daResolution.message);
      _loading = false;
    });
  }

  List<OlympicTaDaEntry> _buildEntriesFromDraft({
    required DraftedTaDaData? draft,
    required List<TaDaVehicleModel> vehicles,
  }) {
    final List<OlympicTaDaEntry> rows = <OlympicTaDaEntry>[];
    for (final row in draft?.draftedTaDa ?? <DraftedTaDa>[]) {
      final vehicle = _findVehicle(
        vehicles: vehicles,
        vehicleId: row.vehicleId ?? row.costType,
      );

      rows.add(
        OlympicTaDaEntry(
          identity: row.identity,
          selectedVehicle: vehicle,
          fromController:
              TextEditingController(text: row.fromLocation ?? ''),
          toController: TextEditingController(text: row.toLocation ?? ''),
          kmController: TextEditingController(text: row.km ?? ''),
          amountController: TextEditingController(
            text: row.cost?.toString() ?? '',
          ),
          remarksController:
              TextEditingController(text: row.remarks ?? ''),
        ),
      );
    }

    return rows;
  }

  TaDaVehicleModel? _findVehicle({
    required List<TaDaVehicleModel> vehicles,
    required int? vehicleId,
  }) {
    if (vehicleId == null) return null;
    for (final vehicle in vehicles) {
      if (vehicle.id == vehicleId) {
        return vehicle;
      }
    }
    return null;
  }

  void _addRow() {
    final lastEntry = _entries.isEmpty ? null : _entries.last;
    if (lastEntry != null && !lastEntry.isComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: LangText('Complete the current TA row before adding another one.'),
        ),
      );
      return;
    }

    setState(() {
      _entries = <OlympicTaDaEntry>[
        ..._entries,
        OlympicTaDaEntry(),
      ];
    });
  }

  void _removeRow(int index) {
    if (_entries.length == 1) {
      setState(() {
        _entries[index].dispose();
        _entries = <OlympicTaDaEntry>[OlympicTaDaEntry()];
      });
      return;
    }

    final entry = _entries[index];
    setState(() {
      entry.dispose();
      _entries = List<OlympicTaDaEntry>.from(_entries)..removeAt(index);
    });
  }

  double get _taTotal {
    return _entries.fold<double>(0, (sum, entry) => sum + entry.amount);
  }

  double get _daTotal => _daInfo?.amount ?? 0;

  double get _grandTotal => _taTotal + _daTotal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      appBar: CustomAppBar(
        title: _appBarTitle,
        titleImage: 'taDa.png',
        onLeadingIconPressed: () => Navigator.pop(context),
        heroTagTitle: _appBarTitle,
        heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                children: [
                  _buildDaCard(),
                  const SizedBox(height: 16),
                  _buildTaSection(),
                  const SizedBox(height: 16),
                  _buildSummaryCard(),
                  const SizedBox(height: 16),
                  _buildGeneralRemarks(),
                  const SizedBox(height: 16),
                  SubmitButtonGroup(
                    button1Label: 'Save Draft',
                    button2Label: 'Submit Ta/Da',
                    twoButtons: widget.visibleSubmitTaDa,
                    onButton1Pressed: () => _controller.draftTaDa(
                      entries: _entries,
                      daInfo: _daInfo,
                      remarks: _remarksController.text.trim(),
                    ),
                    onButton2Pressed: () => _controller.submitTaDaToServer(
                      entries: _entries,
                      daInfo: _daInfo,
                      remarks: _remarksController.text.trim(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDaCard() {
    final amountText = _daInfo == null
        ? '--'
        : _formatAmount(_daInfo!.amount);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4D7CB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4CF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: LangText(
                  'DA',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8A4D1A),
                  ),
                ),
              ),
              const Spacer(),
              LangText(
                '৳ $amountText',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1B5E20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LangText(
            _daInfo == null
                ? 'DA will be calculated automatically from the first completed survey.'
                : 'Type: ${_daInfo!.allowanceType} | Source: ${_daInfo!.surveyType == 'audit' ? 'Audit Survey' : 'Outlet Survey'}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4E4A45),
            ),
          ),
          if (_daMessage != null) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7E7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF0D49D)),
              ),
              child: LangText(
                _daMessage!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7A5A1B),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTaSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD0B8A2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: const BoxDecoration(
              color: Color(0xFFF6D4BC),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: LangText(
              'TA',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D241D),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                for (int index = 0; index < _entries.length; index++) ...[
                  _buildEntryCard(index),
                  if (index != _entries.length - 1) const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryCard(int index) {
    final entry = _entries[index];
    final isLast = index == _entries.length - 1;
    final showRemove = !isLast || _entries.length > 1;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCAB3A0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6D4BC),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: LangText(
                  'Row ${index + 1}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6B3E1E),
                  ),
                ),
              ),
              const Spacer(),
              if (showRemove)
                TextButton(
                  onPressed: () => _removeRow(index),
                  child: LangText(
                    'Remove',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTwoColumnFields(
            left: _buildLabeledField(
              label: 'FROM',
              child: _buildTextField(
                controller: entry.fromController,
                hintText: 'From',
              ),
            ),
            right: _buildLabeledField(
              label: 'TO',
              child: _buildTextField(
                controller: entry.toController,
                hintText: 'To',
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildLabeledField(
            label: 'Vehicle Type',
            child: DropdownButtonFormField<TaDaVehicleModel>(
              initialValue: entry.selectedVehicle,
              decoration: _inputDecoration('Select vehicle'),
              isExpanded: true,
              items: _vehicleTypes
                  .map(
                    (vehicle) => DropdownMenuItem<TaDaVehicleModel>(
                      value: vehicle,
                      child: LangText(
                        vehicle.slug ?? '',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  entry.selectedVehicle = value;
                });
              },
            ),
          ),
          const SizedBox(height: 12),
          _buildTwoColumnFields(
            left: _buildLabeledField(
              label: 'KM (Optional)',
              child: _buildTextField(
                controller: entry.kmController,
                hintText: '0',
                isNumber: true,
              ),
            ),
            right: _buildLabeledField(
              label: 'Amount',
              child: _buildTextField(
                controller: entry.amountController,
                hintText: '0',
                isNumber: true,
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildLabeledField(
            label: 'Remarks',
            child: _buildTextField(
              controller: entry.remarksController,
              hintText: 'Remarks',
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: isLast ? _addRow : () => _removeRow(index),
              child: LangText(
                isLast ? 'add more' : 'remove',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTwoColumnFields({
    required Widget left,
    required Widget right,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 10),
        Expanded(child: right),
      ],
    );
  }

  Widget _buildLabeledField({
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LangText(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6A5B4E),
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFBF9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6DDD5)),
      ),
      child: Column(
        children: [
          _buildSummaryRow('TA Total', _taTotal),
          const SizedBox(height: 10),
          _buildSummaryRow('DA Total', _daTotal),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          _buildSummaryRow('Grand Total', _grandTotal, isBold: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isBold = false}) {
    return Row(
      children: [
        Expanded(
          child: LangText(
            label,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: const Color(0xFF3E3A35),
            ),
          ),
        ),
        LangText(
          '৳ ${_formatAmount(amount)}',
          style: TextStyle(
            fontSize: isBold ? 18 : 15,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
            color: isBold ? primary : const Color(0xFF1B5E20),
          ),
        ),
      ],
    );
  }

  Widget _buildGeneralRemarks() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6DDD5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LangText(
            'General Remarks',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3E3A35),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _remarksController,
            maxLines: 3,
            decoration: _inputDecoration('Write any overall note'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isNumber = false,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      inputFormatters: isNumber
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ]
          : null,
      decoration: _inputDecoration(hintText),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD8C7B7)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD8C7B7)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primary, width: 1.2),
      ),
    );
  }

  String _formatAmount(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }
}
