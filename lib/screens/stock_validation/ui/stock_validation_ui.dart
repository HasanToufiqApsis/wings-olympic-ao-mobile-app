import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constant_variables.dart';
import '../../../models/outlet_model.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../../../services/outlet_services.dart';
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stockValidationProvider);

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
                  _buildPointComingSoon(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointComingSoon() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.construction_rounded, size: 54, color: Colors.grey[500]),
            const SizedBox(height: 12),
            Text(
              'Point',
              style: TextStyle(
                fontSize: mediumFontSize,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Demo / Coming soon',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: smallFontSize,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
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
