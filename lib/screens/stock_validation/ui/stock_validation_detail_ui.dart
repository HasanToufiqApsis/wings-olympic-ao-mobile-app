import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/outlet_model.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../services/sync_read_service.dart';
import '../controller/stock_validation_controller.dart';
import '../models/stock_validation_model.dart';

class StockValidationDetailUI extends ConsumerStatefulWidget {
  const StockValidationDetailUI({
    Key? key,
    required this.outlet,
    required this.outletId,
    required this.date,
    required this.entries,
  }) : super(key: key);

  final OutletModel? outlet;
  final int? outletId;
  final String date;
  final List<QcEntryModel> entries;

  static const String routeName = '/stock_validation_detail';

  @override
  ConsumerState<StockValidationDetailUI> createState() => _StockValidationDetailUIState();
}

class _StockValidationDetailUIState extends ConsumerState<StockValidationDetailUI> {
  OutletModel? _outlet;
  int? _outletId;
  String _date = '';
  List<QcEntryModel> _entries = [];

  // Per-entry controllers: index → {volume, remark}
  final Map<int, TextEditingController> _volumeControllers = {};
  final Map<int, TextEditingController> _remarkControllers = {};

  late StockValidationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = StockValidationController(context: context, ref: ref);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _outlet = widget.outlet;
    _outletId = widget.outletId;
    _date = widget.date;
    _entries = widget.entries;

    // Initialise controllers once
    if (_volumeControllers.isEmpty) {
      for (int i = 0; i < _entries.length; i++) {
        _volumeControllers[i] = TextEditingController(text: _entries[i].volume.toString());
        _remarkControllers[i] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    _volumeControllers.values.forEach((c) => c.dispose());
    _remarkControllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  // Group entries by faultType
  Map<String, List<int>> get _groupedByFaultType {
    final Map<String, List<int>> groups = {};
    for (int i = 0; i < _entries.length; i++) {
      final ft = _entries[i].faultType;
      groups.putIfAbsent(ft, () => []).add(i);
    }
    return groups;
  }

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (_) {
      return raw;
    }
  }

  String _formatLastSubmitted(String raw) {
    try {
      final dt = DateTime.parse(raw).toLocal();
      return DateFormat('yyyy-MM-dd').format(dt);
    } catch (_) {
      return raw;
    }
  }

  Future<void> _onSubmit() async {
    _controller.onSubmit(
      entries: _entries,
      volumeControllers: _volumeControllers,
      remarkControllers: _remarkControllers,
      date: _date,
    );
  }

  // Future<void> _onSubmit() async {
  //   final srInfo = await SyncReadService().getSrInfo();
  //   final sbuIdStr = srInfo.sbuId.replaceAll('[', '').replaceAll(']', '');
  //   final sbuId = int.tryParse(sbuIdStr) ?? 1;
  //
  //   final List<Map<String, dynamic>> verificationData = [];
  //   for (int i = 0; i < _entries.length; i++) {
  //     final entry = _entries[i];
  //     final editedVolumeStr = _volumeControllers[i]?.text;
  //     if (editedVolumeStr == null || editedVolumeStr.isEmpty) {
  //       return;
  //     }
  //     final editedVolume = num.tryParse(editedVolumeStr) ?? 0;
  //     final remark = _remarkControllers[i]?.text ?? '';
  //     verificationData.add({
  //       'sbu_id': sbuId,
  //       'dep_id': entry.depId,
  //       'section_id': entry.sectionId,
  //       'outlet_id': entry.outletId,
  //       'qc_entry_date': entry.qcEntryDate,
  //       'sku_id': entry.skuId,
  //       'fault_id': entry.faultId,
  //       'unit_price': entry.unitPrice,
  //       'volume': editedVolume,
  //       'total_value': entry.unitPrice * editedVolume,
  //       'date': _date,
  //       'remark': remark,
  //     });
  //   }
  //   await _controller.submit(verificationData);
  // }

  @override
  Widget build(BuildContext context) {
    final outletCode = _outlet?.outletCode ?? '#$_outletId';
    final outletName = _outlet?.name ?? 'Outlet';
    final groups = _groupedByFaultType;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: CustomAppBar(title: '$outletCode — ${_formatDate(_date)}'),
      body: Column(
        children: [
          // ── Top info bar ────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: _InfoChip(label: 'Outlet', value: outletName),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _InfoChip(label: 'Date', value: _formatDate(_date)),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 16),
                  label: LangText('Submit', style: TextStyle(color: Colors.white, fontSize: 13)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // ── Table header ─────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [primary, Color(0xFF7A0000)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(flex: 3, child: _TableHeaderText('SKU')),
                Expanded(flex: 2, child: _TableHeaderText('Code', align: TextAlign.center)),
                Expanded(flex: 2, child: _TableHeaderText('Volume', align: TextAlign.center)),
                Expanded(flex: 3, child: _TableHeaderText('Edit Volume', align: TextAlign.center)),
              ],
            ),
          ),

          // ── Entries by fault group ───────────────────────────────────
          Expanded(
            child: ListView(
              children: groups.entries.map((groupEntry) {
                final faultType = groupEntry.key;
                final indices = groupEntry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fault type subheader
                    Container(
                      width: double.infinity,
                      color: const Color(0xFF1A73E8).withOpacity(0.12),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      child: Row(
                        children: [
                          LangText(
                            "Fault",
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A73E8)),
                          ),
                          LangText(
                            ": ",
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A73E8)),
                          ),
                          LangText(
                            faultType,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A73E8)),
                          ),
                        ],
                      ),
                    ),
                    // Entry rows
                    ...indices.map(
                      (i) => _EntryRow(
                        entry: _entries[i],
                        rowIndex: i,
                        volumeController: _volumeControllers[i]!,
                        remarkController: _remarkControllers[i]!,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
class _InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        LangText(label, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
        LangText(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2C2C2C)),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _TableHeaderText extends StatelessWidget {
  final String text;
  final TextAlign align;

  const _TableHeaderText(this.text, {this.align = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return LangText(
      text,
      textAlign: align,
      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
    );
  }
}

// ─────────────────────────────────────────────────────────────
class _EntryRow extends StatefulWidget {
  final QcEntryModel entry;
  final int rowIndex;
  final TextEditingController volumeController;
  final TextEditingController remarkController;

  const _EntryRow({
    Key? key,
    required this.entry,
    required this.rowIndex,
    required this.volumeController,
    required this.remarkController,
  }) : super(key: key);

  @override
  State<_EntryRow> createState() => _EntryRowState();
}

class _EntryRowState extends State<_EntryRow> {
  num get _computedValue {
    final vol = num.tryParse(widget.volumeController.text) ?? 0;
    return widget.entry.unitPrice * vol;
  }

  @override
  void initState() {
    super.initState();
    widget.volumeController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final isEven = widget.rowIndex % 2 == 0;

    return Container(
      color: isEven ? Colors.white : const Color(0xFFF9F9F9),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main row: SKU | Code | Vol (read-only) | Edit Vol
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SKU Name
              Expanded(
                flex: 3,
                child: LangText(
                  widget.entry.skuInfo.shortName,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2C2C2C)),
                ),
              ),
              // SKU Code
              Expanded(
                flex: 2,
                child: Center(
                  child: LangText(
                    widget.entry.skuInfo.materialCode,
                    style: TextStyle(fontSize: 11, color: primary),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Original volume (read-only highlighted)
              Expanded(
                flex: 2,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4)),
                    child: LangText(
                      widget.entry.volume.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ),
                ),
              ),
              // Editable volume
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: TextFormField(
                    controller: widget.volumeController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: primary),
                      ),
                    ),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Remark field
          TextFormField(
            controller: widget.remarkController,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              hintText: 'Enter remark',
              hintStyle: TextStyle(fontSize: 11, color: Colors.grey[400]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: primary),
              ),
            ),
            style: const TextStyle(fontSize: 11),
          ),

          const SizedBox(height: 4),

          // Value
          LangText(
            'Value: ${_computedValue.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 11, color: Colors.grey[600], fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
