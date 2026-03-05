import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/outlet_model.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../services/outlet_services.dart';
import '../controller/stock_validation_controller.dart';
import '../models/stock_validation_model.dart';
import '../providers/stock_validation_providers.dart';
import 'stock_validation_detail_ui.dart';

class StockValidationUI extends ConsumerStatefulWidget {
  const StockValidationUI({Key? key}) : super(key: key);
  static const String routeName = '/stock_validation';

  @override
  _StockValidationUIState createState() => _StockValidationUIState();
}

class _StockValidationUIState extends ConsumerState<StockValidationUI> {
  // Tracks which outlet cards are expanded
  final Set<String> _expandedOutlets = {};
  final Map<int, TextEditingController> _pointVolumeControllers = {};
  final Map<int, TextEditingController> _pointRemarkControllers = {};
  String _pointDataSignature = '';
  late StockValidationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = StockValidationController(context: context, ref: ref);
  }

  @override
  void dispose() {
    _pointVolumeControllers.values.forEach((c) => c.dispose());
    _pointRemarkControllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  void _ensurePointControllers(List<PointQcEntryModel> entries) {
    final signature = entries.map((e) => '${e.skuId}-${e.faultId}').join('|');
    if (_pointDataSignature == signature && _pointVolumeControllers.length == entries.length) {
      return;
    }

    _pointVolumeControllers.values.forEach((c) => c.dispose());
    _pointRemarkControllers.values.forEach((c) => c.dispose());
    _pointVolumeControllers.clear();
    _pointRemarkControllers.clear();

    for (int i = 0; i < entries.length; i++) {
      _pointVolumeControllers[i] =
          TextEditingController(text: entries[i].volume.toString());
      _pointRemarkControllers[i] = TextEditingController();
    }
    _pointDataSignature = signature;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stockValidationProvider);
    final pointState = ref.watch(pointValidationProvider);

    return Scaffold(
      appBar: CustomAppBar(
          titleImage: 'stock_verification.png',
          title: 'Stock Validation'
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(3.w, 1.5.h, 3.w, 0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black87,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(text: 'Outlet'),
                  Tab(text: 'Point'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  state.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error_outline, size: 48, color: primary),
                            const SizedBox(height: 12),
                            Text(
                              'Failed to load data',
                              style: TextStyle(
                                fontSize: mediumFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              err.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => ref
                                  .read(stockValidationProvider.notifier)
                                  .refresh(),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primary),
                              child: const Text(
                                'Retry',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    data: (data) => _buildBody(data),
                  ),
                  pointState.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error_outline, size: 48, color: primary),
                            const SizedBox(height: 12),
                            Text(
                              'Failed to load point data',
                              style: TextStyle(
                                fontSize: mediumFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              err.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () =>
                                  ref.read(pointValidationProvider.notifier).refresh(),
                              style: ElevatedButton.styleFrom(backgroundColor: primary),
                              child: const Text(
                                'Retry',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    data: (data) => _buildPointBody(data),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onPointSubmit(List<PointQcEntryModel> entries) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await _controller.onPointSubmit(
      entries: entries,
      volumeControllers: _pointVolumeControllers,
      remarkControllers: _pointRemarkControllers,
      date: today,
    );
  }

  String _formatDisplayDate(String raw) {
    if (raw.isEmpty) return '-';
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(raw));
    } catch (_) {
      return raw;
    }
  }

  Map<String, List<int>> _groupPointEntriesByFault(List<PointQcEntryModel> entries) {
    final Map<String, List<int>> groups = {};
    for (int i = 0; i < entries.length; i++) {
      final faultType = entries[i].faultType;
      groups.putIfAbsent(faultType, () => []).add(i);
    }
    return groups;
  }

  Widget _buildPointBody(PointValidationResponseModel data) {
    if (data.entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 56, color: Colors.grey[400]),
            const SizedBox(height: 12),
            LangText(
              'No point QC data available',
              style: TextStyle(color: Colors.grey[600], fontSize: mediumFontSize),
            ),
          ],
        ),
      );
    }

    _ensurePointControllers(data.entries);
    final groups = _groupPointEntriesByFault(data.entries);

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Last Submit',
                  value: _formatDisplayDate(data.lastSubmissionDate),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _InfoTile(
                  label: 'Last Verify',
                  value: _formatDisplayDate(data.lastVerificationDate),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _onPointSubmit(data.entries),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 16),
                label: LangText(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primary, Color(0xFF7A0000)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: const Row(
            children: [
              Expanded(flex: 3, child: _PointTableHeaderText('SKU')),
              Expanded(flex: 2, child: _PointTableHeaderText('Code', align: TextAlign.center)),
              Expanded(flex: 2, child: _PointTableHeaderText('Volume', align: TextAlign.center)),
              Expanded(flex: 3, child: _PointTableHeaderText('Edit Volume', align: TextAlign.center)),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => ref.read(pointValidationProvider.notifier).refresh(),
            child: ListView(
              children: groups.entries.map((groupEntry) {
                final faultType = groupEntry.key;
                final indices = groupEntry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      color: const Color(0xFF1A73E8).withOpacity(0.12),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      child: Row(
                        children: [
                          LangText(
                            "Fault",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A73E8),
                            ),
                          ),
                          LangText(
                            ": ",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A73E8),
                            ),
                          ),
                          Expanded(
                            child: LangText(
                              faultType,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A73E8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...indices.map(
                      (i) => _PointEntryRow(
                        entry: data.entries[i],
                        rowIndex: i,
                        volumeController: _pointVolumeControllers[i]!,
                        remarkController: _pointRemarkControllers[i]!,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(StockValidationResponseModel data) {
    final outletIds = data.qcData.keys.toList();

    if (outletIds.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 56, color: Colors.grey[400]),
            const SizedBox(height: 12),
            LangText('No QC data available',
                style: TextStyle(color: Colors.grey[600], fontSize: mediumFontSize)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async =>
          ref.read(stockValidationProvider.notifier).refresh(),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        itemCount: outletIds.length,
        itemBuilder: (context, index) {
          final outletIdStr = outletIds[index];
          final int outletId = int.tryParse(outletIdStr) ?? 0;
          final dateMap = data.qcData[outletIdStr]!;
          return _OutletCard(
            outletId: outletId,
            dateMap: dateMap,
            isExpanded: _expandedOutlets.contains(outletIdStr),
            onToggle: () {
              setState(() {
                if (_expandedOutlets.contains(outletIdStr)) {
                  _expandedOutlets.remove(outletIdStr);
                } else {
                  _expandedOutlets.add(outletIdStr);
                }
              });
            },
          );
        },
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        LangText(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
        ),
        LangText(
          value,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C2C2C),
          ),
        ),
      ],
    );
  }
}

class _PointTableHeaderText extends StatelessWidget {
  final String text;
  final TextAlign align;

  const _PointTableHeaderText(this.text, {this.align = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return LangText(
      text,
      textAlign: align,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _PointEntryRow extends StatefulWidget {
  final PointQcEntryModel entry;
  final int rowIndex;
  final TextEditingController volumeController;
  final TextEditingController remarkController;

  const _PointEntryRow({
    required this.entry,
    required this.rowIndex,
    required this.volumeController,
    required this.remarkController,
  });

  @override
  State<_PointEntryRow> createState() => _PointEntryRowState();
}

class _PointEntryRowState extends State<_PointEntryRow> {
  num get _computedValue {
    final vol = num.tryParse(widget.volumeController.text) ?? 0;
    return widget.entry.unitPrice * vol;
  }

  @override
  void initState() {
    super.initState();
    widget.volumeController.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.volumeController.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: LangText(
                  widget.entry.skuName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: LangText(
                    widget.entry.skuCode,
                    style: const TextStyle(fontSize: 11, color: primary),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: LangText(
                      widget.entry.volume.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: TextFormField(
                    controller: widget.volumeController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
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
          LangText(
            'Value: ${_computedValue.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

/// A card that resolves the outlet by ID, then shows header + expandable date list.
class _OutletCard extends StatefulWidget {
  final int outletId;
  final Map<String, List<QcEntryModel>> dateMap;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _OutletCard({
    Key? key,
    required this.outletId,
    required this.dateMap,
    required this.isExpanded,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<_OutletCard> createState() => _OutletCardState();
}

class _OutletCardState extends State<_OutletCard> {
  OutletModel? _outlet;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadOutlet();
  }

  Future<void> _loadOutlet() async {
    final outlet = await OutletServices().getOutletBuId(widget.outletId);
    if (mounted) {
      setState(() {
        _outlet = outlet;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dates = widget.dateMap.keys.toList()..sort();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            onTap: widget.onToggle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primary, Color(0xFF7A0000)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: widget.isExpanded
                    ? const BorderRadius.vertical(top: Radius.circular(12))
                    : BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.store_mall_directory_rounded,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _loading
                        ? const SizedBox(
                            height: 18,
                            width: 80,
                            child: LinearProgressIndicator(
                                backgroundColor: Colors.white24,
                                color: Colors.white),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _outlet?.name ?? 'Outlet #${widget.outletId}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_outlet?.owner ?? ''}  •  ${_outlet?.outletCode ?? ''}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${dates.length} date${dates.length > 1 ? 's' : ''}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 11),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        turns: widget.isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded date list ──────────────────────────────────────
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Column(
              children: dates.asMap().entries.map((entry) {
                final idx = entry.key;
                final date = entry.value;
                final entries = widget.dateMap[date]!;
                final isLast = idx == dates.length - 1;
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      StockValidationDetailUI.routeName,
                      arguments: {
                        'outlet': _outlet,
                        'outlet_id': widget.outletId,
                        'date': date,
                        'entries': entries,
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: !isLast
                          ? Border(
                              bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.12)))
                          : null,
                      borderRadius: isLast
                          ? const BorderRadius.vertical(
                              bottom: Radius.circular(12))
                          : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.calendar_today_rounded,
                              size: 16, color: primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                date,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2C2C2C)),
                              ),
                              Text(
                                '${entries.length} item${entries.length > 1 ? 's' : ''}',
                                style: TextStyle(
                                    fontSize: 11, color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right,
                            color: Colors.grey[400], size: 20),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            crossFadeState: widget.isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 220),
          ),
        ],
      ),
    );
  }
}
