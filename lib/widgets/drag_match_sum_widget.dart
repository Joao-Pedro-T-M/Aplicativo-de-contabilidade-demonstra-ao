// lib/widgets/drag_match_sum_widget.dart
import 'package:equition/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/course_models.dart';

/// Widget de soma/arrastar para Balanço Patrimonial.
/// Agora, quando houver dreEntries, a DRE também é interativa no mesmo fluxo,
/// com chips arrastáveis, Débito/Crédito, validação e incorporação do resultado
/// líquido ao Patrimônio Líquido final.

const Color kPrimaryColor = Color(0xFF4CB2B2);
const Color kSecondaryTextColor = Color(0xFF2D6B6B);
const Color kCardColor = Color(0xFFFFFFFF);
const Color kTextColor = Colors.black87;

const double kActionButtonHeight = 84.0;
const double kActionButtonFontSize = 16.0;

final ButtonStyle kPrimaryActionStyle = ElevatedButton.styleFrom(
  backgroundColor: kPrimaryColor,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  minimumSize: const Size.fromHeight(kActionButtonHeight),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  textStyle: const TextStyle(
    fontSize: kActionButtonFontSize,
    fontWeight: FontWeight.w700,
  ),
  elevation: 2,
);

final ButtonStyle kSecondaryActionStyle = OutlinedButton.styleFrom(
  foregroundColor: kPrimaryColor,
  side: BorderSide(color: kPrimaryColor.withOpacity(0.35)),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  minimumSize: const Size.fromHeight(kActionButtonHeight),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  textStyle: const TextStyle(
    fontSize: kActionButtonFontSize,
    fontWeight: FontWeight.w700,
  ),
);

const double kTopStripeCollapsedHeight = 4.0;
const double kTopStripeExpandedHeight = 8.0;
const double kTopStripeCollapsedWidthFactor = 0.36;
const double kTopStripeExpandedWidthFactor = 1.0;
const Duration kTopStripeAnimDuration = Duration(milliseconds: 160);

typedef TotalsCallback = void Function(Map<String, double> totals);

typedef DreTotalsCallback = void Function(double totalDebit, double totalCredit, double result);

class DragMatchSumWidget extends StatefulWidget {
  final List<MatchSumItem> items;
  final List<MatchTarget> targets;
  final Map<String, String> correctMap;
  final void Function(bool allCorrect)? onSubmitted;
  final VoidCallback? onSkip;
  final TotalsCallback? onTotalsChanged;
  final Map<String, double>? expectedTargetTotals;
  final String? explanation;
  final Map<String, List<String>>? groups;
  final List<DREEntry>? dreEntries;
final bool isDfcMode;
final double? initialCash;
final List<DfcFlowItem>? dfcFlows;
const DragMatchSumWidget({
  super.key,
  required this.items,
  required this.targets,
  required this.correctMap,
  this.onSubmitted,
  this.onSkip,
  this.onTotalsChanged,
  this.expectedTargetTotals,
  this.explanation,
  this.groups,
  this.dreEntries,
  this.isDfcMode = false,
  this.initialCash,
  this.dfcFlows,
});

  @override
  State<DragMatchSumWidget> createState() => _DragMatchSumWidgetState();
}

class _DragMatchSumWidgetState extends State<DragMatchSumWidget>

    with AutomaticKeepAliveClientMixin {
  late List<MatchSumItem> availableItems;
  late Map<String, List<String>> assignments;
  late Map<String, bool> correctness;

  // DRE state (interativa)
  late List<DREEntry> availableDreItems;
  late Map<String, List<String>> dreAssignments;
  final Map<String, bool> dreCorrectness = {};
  final Map<String, bool> dreItemCorrect = {};
  final Map<String, DREEntry> _dreById = {};

  bool submitted = false;
  bool _lockedCorrect = false;
  bool _overallCorrect = false;
  String? _selectedItemId;
  String? _selectedDreItemId;
  final GlobalKey _explanationKey = GlobalKey();

  OverlayEntry? _overlayEntry;
  static const double _dreColValueWidth = 96.0;
  static const double _dreColValueWidthSmall = 72.0;
  static const double _dreRemoveColWidth = 40.0;

  double? _dreCachedUniformWidth;
  double? _dreCachedUniformHeight;
  double? _dreLastMeasuredAvailableWidth;
  int? _dreLastEntriesHash;
    int _dreEntriesHash(List<DREEntry> list) {
    int h = list.length;
    for (final e in list) {
      h = h * 31 + e.id.hashCode;
      h = h * 13 + e.label.hashCode;
      h = h * 7 + e.value.hashCode;
      h = h * 5 + e.isDebit.hashCode;
    }
    return h;
  }

  double _calcDreUniformChipMaxWidth(double availableWidth, bool isWide) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: isWide ? 14.0 : 13.0,
    );

    double maxNeeded = 0.0;

    for (final e in widget.dreEntries ?? const <DREEntry>[]) {
      final chipText = '${e.label} — ${_formatValue(e.value)}';

      final tp = TextPainter(
        text: TextSpan(text: chipText, style: textStyle),
        textDirection: TextDirection.ltr,
        maxLines: isWide ? 1 : 2,
      )..layout(maxWidth: isWide ? double.infinity : availableWidth * 0.92);

      final needed = tp.width + 24.0;
      if (needed > maxNeeded) maxNeeded = needed;
    }

    final limit = isWide ? 320.0 : (availableWidth * 0.92);
    return maxNeeded.clamp(72.0, limit);
  }

  double _calcDreUniformChipMaxHeight(BuildContext context, double finalWidth, bool isWide) {
    final defaultStyle = DefaultTextStyle.of(context).style;
    final textScale = MediaQuery.textScaleFactorOf(context);

    final chipStyle = defaultStyle.merge(
      TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: isWide ? 14.0 : 13.0,
      ),
    );

    const horizontalPadding = 12.0 * 2;
    const verticalPadding = 8.0 * 2;
    const buffer = 6.0;

    double maxHeight = 0.0;

    for (final e in widget.dreEntries ?? const <DREEntry>[]) {
      final chipText = '${e.label} — ${_formatValue(e.value)}';

      final tp = TextPainter(
        text: TextSpan(text: chipText, style: chipStyle),
        textDirection: TextDirection.ltr,
        maxLines: isWide ? 1 : 2,
        textScaleFactor: textScale,
      )..layout(maxWidth: (finalWidth - horizontalPadding).clamp(20.0, double.infinity));

      final totalHeight = tp.height + verticalPadding + buffer;
      if (totalHeight > maxHeight) maxHeight = totalHeight;
    }

    return maxHeight.clamp(isWide ? 40.0 : 44.0, double.infinity).ceilToDouble();
  }
    @override
  void didUpdateWidget(covariant DragMatchSumWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final hash = _dreEntriesHash(widget.dreEntries ?? const <DREEntry>[]);
    if (hash != _dreLastEntriesHash) {
      _dreCachedUniformWidth = null;
      _dreCachedUniformHeight = null;
      _dreLastMeasuredAvailableWidth = null;
      _dreLastEntriesHash = hash;

      _dreById
        ..clear();

      for (final e in widget.dreEntries ?? const <DREEntry>[]) {
        _dreById[e.id] = e;
      }

      availableDreItems = List<DREEntry>.from(widget.dreEntries ?? const <DREEntry>[]);
    }
  }
  @override
  bool get wantKeepAlive => true;

  bool get _hasDre => widget.dreEntries != null && widget.dreEntries!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    availableItems = List<MatchSumItem>.from(widget.items);
    availableDreItems = List<DREEntry>.from(widget.dreEntries ?? const <DREEntry>[]);

    for (final e in availableDreItems) {
      _dreById[e.id] = e;
    }

    final allIds = <String>{};
    void collectIds(List<MatchTarget> ts) {
      for (var t in ts) {
        allIds.add(t.id);
        if (t.subs != null && t.subs!.isNotEmpty) collectIds(t.subs!);
      }
    }

    collectIds(widget.targets);
    assignments = {for (var id in allIds) id: <String>[]};
    correctness = {};

    dreAssignments = {
      'deb': <String>[],
      'cred': <String>[],
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyTotals();
      _insertOverlay();
    });
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  Map<String, String> get _dreCorrectMap {
    final map = <String, String>{};
    for (final e in widget.dreEntries ?? const <DREEntry>[]) {
      map[e.id] = e.isDebit ? 'deb' : 'cred';
    }
    return map;
  }

  bool _hasAnyAssignment() {
    final bpAssigned = assignments.values.any((v) => v.isNotEmpty);
    final dreAssigned = _hasDre && dreAssignments.values.any((v) => v.isNotEmpty);
    return bpAssigned || dreAssigned;
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(builder: (overlayContext) {
      final bool hasAnyAssignment = _hasAnyAssignment();
      final bool allCorrectAfterSubmit = submitted && _overallCorrect;

      if (allCorrectAfterSubmit) return const SizedBox.shrink();

      final bool showBar = hasAnyAssignment || submitted;
      if (!showBar) return const SizedBox.shrink();

      Widget left;
      Widget right;

      if (!submitted) {
        left = _elevatedAction('Enviar', hasAnyAssignment ? _evaluateAndShow : null);
        right = _outlinedAction('Tentar novamente', _reset);
      } else {
        left = _outlinedAction('Tentar novamente', _reset);
        right = _elevatedAction('Pular', _handleSkip);
      }

      final media = MediaQuery.of(overlayContext);
      final double bottomInset = media.viewInsets.bottom > 0 ? media.viewInsets.bottom : media.padding.bottom;
      const double barHeight = kActionButtonHeight;

      return Positioned(
        left: 0,
        right: 0,
        bottom: bottomInset,
        child: SafeArea(
          top: false,
          child: Material(
            elevation: 8,
            color: kCardColor,
            child: Container(
              height: barHeight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(child: left),
                  const SizedBox(width: 12),
                  Expanded(child: right),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _insertOverlay() {
    if (_overlayEntry != null) return;
    final overlay = Overlay.of(context, rootOverlay: true);
    if (overlay == null) return;
    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _refreshOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _insertOverlay());
    }
  }

void _assign(String itemId, String targetId) {
  final bpItemExists = widget.items.any((i) => i.id == itemId);
  if (!bpItemExists) return;

  for (var e in assignments.entries) {
    if (e.value.contains(itemId)) {
      e.value.remove(itemId);
      break;
    }
  }
  assignments[targetId]!.add(itemId);
  availableItems.removeWhere((i) => i.id == itemId);
  if (_selectedItemId == itemId) _selectedItemId = null;
  if (!submitted) setState(() {});
  HapticFeedback.lightImpact();
  _notifyTotals();
  _refreshOverlay();
}

  void _unassignFromTarget(String targetId, [String? itemId]) {
    if (itemId != null) {
      assignments[targetId]!.remove(itemId);
      final item = widget.items.firstWhere(
        (it) => it.id == itemId,
        orElse: () => MatchSumItem(id: '', label: '', value: 0),
      );
      if (item.id.isNotEmpty) availableItems.add(item);
    } else {
      final removed = assignments[targetId]!.toList();
      for (var rid in removed) {
        final item = widget.items.firstWhere(
          (it) => it.id == rid,
          orElse: () => MatchSumItem(id: '', label: '', value: 0),
        );
        if (item.id.isNotEmpty) availableItems.add(item);
      }
      assignments[targetId] = [];
    }
    if (!submitted) setState(() {});
    _notifyTotals();
    _refreshOverlay();
  }

  void _toggleSelectItem(String id) {
    if (submitted) return;
    if (!availableItems.any((ai) => ai.id == id)) return;
    setState(() {
      _selectedItemId = _selectedItemId == id ? null : id;
    });
    _refreshOverlay();
  }

void _assignDre(String itemId, String targetId) {
  final dreItemExists = _dreById.containsKey(itemId);
  if (!dreItemExists) return;

  for (var e in dreAssignments.entries) {
    if (e.value.contains(itemId)) {
      e.value.remove(itemId);
      break;
    }
  }
  dreAssignments[targetId]!.add(itemId);
  availableDreItems.removeWhere((e) => e.id == itemId);
  if (_selectedDreItemId == itemId) _selectedDreItemId = null;
  if (!submitted) setState(() {});
  HapticFeedback.lightImpact();
  _refreshOverlay();
}
  void _unassignDreFromTarget(String targetId, [String? itemId]) {
    if (itemId != null) {
      dreAssignments[targetId]!.remove(itemId);
      final item = _dreById[itemId];
      if (item != null) availableDreItems.add(item);
    } else {
      final removed = dreAssignments[targetId]!.toList();
      for (final rid in removed) {
        final item = _dreById[rid];
        if (item != null) availableDreItems.add(item);
      }
      dreAssignments[targetId] = [];
    }
    if (!submitted) setState(() {});
    _refreshOverlay();
  }

  void _toggleSelectDreItem(String id) {
    if (submitted) return;
    if (!availableDreItems.any((ai) => ai.id == id)) return;
    setState(() {
      _selectedDreItemId = _selectedDreItemId == id ? null : id;
    });
    _refreshOverlay();
  }

  Map<String, double> _computeTargetSums() {
    final Map<String, double> sums = {};

    for (var entry in assignments.entries) {
      double s = 0.0;
      for (var id in entry.value) {
        final it = widget.items.firstWhere(
          (it) => it.id == id,
          orElse: () => MatchSumItem(id: '', label: '', value: 0),
        );
        s += it.value;
      }
      sums[entry.key] = s;
    }

    void sumParent(List<MatchTarget> ts) {
      for (var t in ts) {
        if (t.subs != null && t.subs!.isNotEmpty) {
          double ps = 0.0;
          for (var st in t.subs!) {
            ps += (sums[st.id] ?? 0.0);
          }
          sums[t.id] = ps;
          sumParent(t.subs!);
        }
      }
    }

    sumParent(widget.targets);
    return sums;
  }

Map<String, double> _computeDreSums() {
  double deb = 0.0;
  double cred = 0.0;

  for (final id in dreAssignments['deb'] ?? const <String>[]) {
    final it = _dreById[id];
    if (it != null) deb += it.value;
  }

  for (final id in dreAssignments['cred'] ?? const <String>[]) {
    final it = _dreById[id];
    if (it != null) cred += it.value;
  }

  return {'deb': deb, 'cred': cred};
}

double _computeDfcFinalCash() {
  final initial = widget.initialCash ?? 0.0;
  double total = initial;

  for (final flow in widget.dfcFlows ?? const <DfcFlowItem>[]) {
    total += flow.isInflow ? flow.value : -flow.value;
  }

  return total;
}

Map<String, double> _computeDfcByCategory() {
  final totals = {
    'operacional': 0.0,
    'investimento': 0.0,
    'financiamento': 0.0,
  };

  for (final flow in widget.dfcFlows ?? const <DfcFlowItem>[]) {
    totals[flow.category] =
        (totals[flow.category] ?? 0.0) + (flow.isInflow ? flow.value : -flow.value);
  }

  return totals;
}
  double _dreRevenueTotal() => _computeDreSums()['cred'] ?? 0.0;
  double _dreExpenseTotal() => _computeDreSums()['deb'] ?? 0.0;
  double _dreNetResult() => _dreRevenueTotal() - _dreExpenseTotal();

  String _dreResultLabel(double net) {
    return net >= 0 ? 'Lucro líquido' : 'Prejuízo líquido';
  }

  Map<String, List<String>> get _defaultGroupsConf {
    return {
      'Ativos': widget.targets
          .where((t) => t.id == 'ac' || t.id == 'anc' || t.id.startsWith('ac') || t.id.startsWith('anc'))
          .map((e) => e.id)
          .toList(),
      'Passivos': widget.targets
          .where((t) => t.id == 'pc' || t.id == 'pnc' || t.id.startsWith('pc') || t.id.startsWith('pnc'))
          .map((e) => e.id)
          .toList(),
      'PL': widget.targets.where((t) => t.id == 'pl' || t.id.startsWith('pl')).map((e) => e.id).toList(),
    };
  }

  Map<String, double> _computeGroupSums() {
    final targetSums = _computeTargetSums();
    final Map<String, double> groups = {};
    final Map<String, List<String>> groupsConf = widget.groups ?? _defaultGroupsConf;

    groupsConf.forEach((g, listTargetIds) {
      double gsum = 0.0;
      for (var tid in listTargetIds) {
        gsum += (targetSums[tid] ?? 0.0);
      }
      groups[g] = gsum;
    });
    return groups;
  }

  Map<String, List<String>> _computeExpectedItemsPerTarget() {
    final Map<String, List<String>> expected = {
      for (var id in assignments.keys) id: <String>[],
    };

    widget.correctMap.forEach((itemId, targetId) {
      if (!expected.containsKey(targetId)) expected[targetId] = <String>[];
      expected[targetId]!.add(itemId);
    });

    return expected;
  }

  Map<String, List<String>> _computeExpectedDrePerTarget() {
    return {
      'deb': [
        for (final e in widget.dreEntries ?? const <DREEntry>[])
          if (e.isDebit) e.id,
      ],
      'cred': [
        for (final e in widget.dreEntries ?? const <DREEntry>[])
          if (!e.isDebit) e.id,
      ],
    };
  }

  void _notifyTotals() {
    final totals = _computeTargetSums();
    widget.onTotalsChanged?.call(totals);
  }

  void _evaluateAndShow() {
    correctness.clear();
    dreCorrectness.clear();
    dreItemCorrect.clear();
    bool allCorrect = true;

    // BP
    final expectedPerTarget = _computeExpectedItemsPerTarget();
    for (var entry in assignments.entries) {
      final tId = entry.key;
      final assignedList = entry.value;
      final expectedList = expectedPerTarget[tId] ?? <String>[];

      final assignedSet = <String>{...assignedList};
      final expectedSet = <String>{...expectedList};

      final bool allOk = assignedSet.length == expectedSet.length && assignedSet.difference(expectedSet).isEmpty;
      correctness[tId] = allOk;
      if (!allOk) allCorrect = false;
    }

    if (widget.expectedTargetTotals != null) {
      const eps = 0.001;
      final targetSums = _computeTargetSums();
      for (var entry in widget.expectedTargetTotals!.entries) {
        final got = targetSums[entry.key] ?? 0.0;
        if ((got - entry.value).abs() > eps) {
          allCorrect = false;
        }
      }
    }

    // DRE
    if (_hasDre) {
      final expectedDre = _computeExpectedDrePerTarget();
      for (final targetId in ['deb', 'cred']) {
        final assignedList = dreAssignments[targetId] ?? <String>[];
        final expectedList = expectedDre[targetId] ?? <String>[];
        final assignedSet = <String>{...assignedList};
        final expectedSet = <String>{...expectedList};

        final bool ok = assignedSet.length == expectedSet.length && assignedSet.difference(expectedSet).isEmpty;
        dreCorrectness[targetId] = ok;
        if (!ok) allCorrect = false;
      }

      for (final targetId in ['deb', 'cred']) {
        for (final id in dreAssignments[targetId] ?? const <String>[]) {
          final expectedTarget = _dreCorrectMap[id];
          dreItemCorrect[id] = (expectedTarget == targetId);
        }
      }
    }

    setState(() {
      submitted = true;
      _overallCorrect = allCorrect;
      if (allCorrect && !_lockedCorrect) _lockedCorrect = true;
    });

    widget.onSubmitted?.call(allCorrect);
    _notifyTotals();

    _insertOverlay();
    _refreshOverlay();

    if (!allCorrect) _scrollToExplanation();
  }

  void _reset() {
    final wasLocked = _lockedCorrect;

    availableItems = List<MatchSumItem>.from(widget.items);
    availableDreItems = List<DREEntry>.from(widget.dreEntries ?? const <DREEntry>[]);

    final allIds = <String>{};
    void collectIds(List<MatchTarget> ts) {
      for (var t in ts) {
        allIds.add(t.id);
        if (t.subs != null && t.subs!.isNotEmpty) collectIds(t.subs!);
      }
    }

    collectIds(widget.targets);
    assignments = {for (var id in allIds) id: <String>[]};
    dreAssignments = {
      'deb': <String>[],
      'cred': <String>[],
    };

    correctness.clear();
    dreCorrectness.clear();
    dreItemCorrect.clear();
    _selectedItemId = null;
    _selectedDreItemId = null;
    submitted = false;
    _overallCorrect = false;
    _lockedCorrect = false;

    setState(() {});
    if (wasLocked && widget.onSubmitted != null) widget.onSubmitted!(true);
    _notifyTotals();
    _refreshOverlay();
  }

  void _handleSkip() {
    widget.onSubmitted?.call(false);
    _reset();

    if (widget.onSkip != null) {
      widget.onSkip!();
    } else {
      SkipNextNotification().dispatch(context);
    }
  }

  Future<void> _scrollToExplanation() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 120));
      if (!mounted) return;
      final ctx = _explanationKey.currentContext;
      if (ctx == null) return;
      try {
        await Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeInOut,
          alignment: 0.85,
        );
      } catch (_) {}
    });
  }

  String _formatValue(double v) {
    if (v % 1 == 0) return v.toInt().toString();
    return v.toStringAsFixed(2);
  }

  Widget _summaryLine(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppTheme.secondaryTextColor,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
              fontSize: 12,
            ),
          ),
          Text(
            _formatValue(value),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
Widget _buildDfcCard() {
  final initialCash = widget.initialCash ?? 0.0;
  final totals = _computeDfcByCategory();

  final operacional = totals['operacional'] ?? 0.0;
  final investimento = totals['investimento'] ?? 0.0;
  final financiamento = totals['financiamento'] ?? 0.0;

  final finalCash = _computeDfcFinalCash();

  return Card(
    color: const Color(0xFFE8F5E9),
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DFC (Demonstrativo dos Fluxos de Caixa)',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          _summaryLine('Saldo inicial de caixa', initialCash),
          _summaryLine('Fluxo operacional', operacional, bold: true),
          _summaryLine('Fluxo de investimento', investimento, bold: true),
          _summaryLine('Fluxo de financiamento', financiamento, bold: true),
          const Divider(),
          _summaryLine('Saldo final de caixa', finalCash, bold: true),
        ],
      ),
    ),
  );
}  Widget _buildDreChip(DREEntry item) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        final isWide = availableWidth > 520;
        final entriesHash = _dreEntriesHash(widget.dreEntries ?? const <DREEntry>[]);

        if (_dreCachedUniformWidth == null ||
            _dreCachedUniformHeight == null ||
            _dreLastMeasuredAvailableWidth == null ||
            _dreLastMeasuredAvailableWidth != availableWidth ||
            _dreLastEntriesHash != entriesHash) {
          _dreCachedUniformWidth = _calcDreUniformChipMaxWidth(availableWidth, isWide);
          final finalWidth = _dreCachedUniformWidth! > availableWidth
              ? availableWidth
              : _dreCachedUniformWidth!;
          _dreCachedUniformHeight = _calcDreUniformChipMaxHeight(context, finalWidth, isWide);
          _dreLastMeasuredAvailableWidth = availableWidth;
          _dreLastEntriesHash = entriesHash;
        }

        final finalWidth = _dreCachedUniformWidth! > availableWidth
            ? availableWidth
            : _dreCachedUniformWidth!;
        final safeHeight = _dreCachedUniformHeight!.ceilToDouble() + 2.0;

        final bool selected = _selectedDreItemId == item.id;
        final bool available = availableDreItems.any((ai) => ai.id == item.id);

        return GestureDetector(
          onTap: () {
            if (available) _toggleSelectDreItem(item.id);
          },
          child: Draggable<String>(
            data: item.id,
            feedback: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: finalWidth,
                height: safeHeight,
                child: _dreChipContainer(item, selected: false, available: available),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.35,
              child: SizedBox(
                width: finalWidth,
                height: safeHeight,
                child: _dreChipContainer(item, selected: false, available: available),
              ),
            ),
            child: SizedBox(
              width: finalWidth,
              height: safeHeight,
              child: _dreChipContainer(item, selected: selected, available: available),
            ),
            onDragStarted: () {
              if (_selectedDreItemId != null) {
                setState(() {
                  _selectedDreItemId = null;
                });
              }
            },
          ),
        );
      },
    );
  }
  Widget _dreChipContainer(
    DREEntry item, {
    required bool selected,
    required bool available,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected
              ? kPrimaryColor
              : (available ? kPrimaryColor.withOpacity(0.05) : Colors.grey.shade300),
          width: selected ? 1.6 : 1.0,
        ),
        color: selected
            ? kPrimaryColor.withOpacity(0.10)
            : (available ? kPrimaryColor.withOpacity(0.35) : Colors.grey.shade50),
        boxShadow: [
          BoxShadow(
            color: selected ? kPrimaryColor.withOpacity(0.12) : Colors.black.withOpacity(0.02),
            blurRadius: selected ? 8 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '${item.label} — ${_formatValue(item.value)}',
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            color: selected ? kPrimaryColor : Colors.black87,
          ),
        ),
      ),
    );
  }
  Widget _buildDreTargetBox(String id, String label, bool small, double boxHeight) {
    final baseColor = id == 'deb' ? Colors.red.shade100 : Colors.blue.shade100;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_selectedDreItemId != null && !submitted) {
            final selected = _selectedDreItemId!;
            _assignDre(selected, id);
            setState(() {
              _selectedDreItemId = null;
            });
          }
        },
        child: DragTarget<String>(
          onWillAccept: (data) {
            if (submitted || data == null) return false;
            return _dreById.containsKey(data);
          },
          onAccept: (data) {
            if (data == null) return;
            if (!_dreById.containsKey(data)) return;
            _assignDre(data, id);
          },
          builder: (context, candidateData, rejectedData) {
            final hovering = candidateData.isNotEmpty;
            final highlight = hovering || (_selectedDreItemId != null && !submitted);

            final Color debitHighlight = Colors.amber.shade400;
            final Color creditHighlight = Colors.cyan.shade400;
            final Color chosenHighlight = id == 'deb' ? debitHighlight : creditHighlight;

            final sum = _computeDreSums()[id] ?? 0.0;
            final isCorrect = dreCorrectness[id] ?? false;

            final borderColor = submitted
                ? (isCorrect ? Colors.green.withOpacity(0.6) : Colors.orange.shade400)
                : (highlight
                    ? chosenHighlight
                    : (id == 'deb' ? Colors.red.shade200 : Colors.blue.shade200));

            final boxShadow = highlight
                ? [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 6))]
                : null;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: boxHeight,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: highlight ? 2.0 : 1.4),
                borderRadius: BorderRadius.circular(8),
                color: baseColor,
                boxShadow: boxShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: id == 'deb' ? Colors.red.shade800 : Colors.blue.shade800,
                          ),
                        ),
                      ),
                      Text(
                        _formatValue(sum),
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: id == 'deb' ? Colors.red.shade800 : Colors.blue.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          dreAssignments[id]!.isEmpty
                              ? 'Arraste aqui (valores)'
                              : '${dreAssignments[id]!.length} item(s) atribuído(s)',
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  Widget _buildDreAssignmentsTable(bool small) {
    final rows = widget.dreEntries ?? const <DREEntry>[];
    final valueWidth = small ? _dreColValueWidthSmall : _dreColValueWidth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text('Conta — Débito / Crédito (DRE)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(6)),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                color: Colors.grey.shade50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Conta',
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: small ? 12 : 13),
                      ),
                    ),
                    SizedBox(width: small ? 8 : 16),
                    SizedBox(
                      width: valueWidth,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Débito',
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: small ? 12 : 13),
                        ),
                      ),
                    ),
                    SizedBox(width: small ? 8 : 16),
                    SizedBox(
                      width: valueWidth,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Crédito',
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: small ? 12 : 13),
                        ),
                      ),
                    ),
                    const SizedBox(width: _dreRemoveColWidth),
                  ],
                ),
              ),
              const Divider(height: 1),
              ...rows.map((e) {
                final inDeb = dreAssignments['deb']!.contains(e.id);
                final inCred = dreAssignments['cred']!.contains(e.id);
                final assigned = inDeb || inCred;
                final isCorrect = dreItemCorrect[e.id] ?? false;
                final bgColor = submitted
                    ? (assigned ? (isCorrect ? Colors.green.shade50 : Colors.red.shade50) : Colors.transparent)
                    : Colors.transparent;

                return Container(
                  color: bgColor,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          e.label,
                          maxLines: small ? 2 : 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: small ? 12 : 13),
                        ),
                      ),
                      SizedBox(width: small ? 8 : 16),
                      SizedBox(
                        width: valueWidth,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            inDeb ? _formatValue(e.value) : '',
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(width: small ? 8 : 16),
                      SizedBox(
                        width: valueWidth,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            inCred ? _formatValue(e.value) : '',
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: _dreRemoveColWidth,
                        child: assigned
                            ? Center(
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    splashRadius: 18,
                                    padding: const EdgeInsets.all(6),
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.close, size: 16, color: Colors.red),
                                    onPressed: submitted
                                        ? null
                                        : () {
                                            _unassignDreFromTarget(inDeb ? 'deb' : 'cred', e.id);
                                            setState(() {});
                                          },
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildDreInteractiveCard() {
    if (!_hasDre) return const SizedBox.shrink();

    final media = MediaQuery.of(context);
    final small = media.size.width < 520;

    final dreSums = _computeDreSums();
    final deb = dreSums['deb'] ?? 0.0;
    final cred = dreSums['cred'] ?? 0.0;
    final net = _dreNetResult();
    final label = _dreResultLabel(net);

    final double fallbackHeight = small ? 152.0 : 132.0;
    final double targetHeight = (_dreCachedUniformHeight != null)
        ? (_dreCachedUniformHeight! + (small ? 78.0 : 64.0))
        : fallbackHeight;

    return Card(
      color: const Color(0xFFF1F8E9),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DRE',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            AbsorbPointer(
              absorbing: submitted,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableDreItems.map(_buildDreChip).toList(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: targetHeight.clamp(110.0, 220.0),
              child: Row(
                children: [
                  _buildDreTargetBox('deb', 'Débito', small, targetHeight.clamp(110.0, 220.0)),
                  const SizedBox(width: 12),
                  _buildDreTargetBox('cred', 'Crédito', small, targetHeight.clamp(110.0, 220.0)),
                ],
              ),
            ),
            _buildDreAssignmentsTable(small),
            const SizedBox(height: 12),
            Card(
              color: const Color(0xFFF8FCF0),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _summaryLine('Total Débito', deb),
                    _summaryLine('Total Crédito', cred),
                    Divider(color: AppTheme.dividerColor.withOpacity(0.25)),
                    _summaryLine(label, net.abs(), bold: true),
                    const SizedBox(height: 4),
                    Text(
                      'O resultado líquido é incorporado ao Patrimônio Líquido final.',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.secondaryTextColor.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildTotalsCard() {
    final totals = _computeTargetSums();
    final groupSums = _computeGroupSums();

    final double ativos = groupSums['Ativos'] ?? ((totals['ac'] ?? 0.0) + (totals['anc'] ?? 0.0));
    final double passivos = groupSums['Passivos'] ?? ((totals['pc'] ?? 0.0) + (totals['pnc'] ?? 0.0));
    final double plBase = groupSums['PL'] ?? (totals['pl'] ?? 0.0);
    final double dreNet = _hasDre ? _dreNetResult() : 0.0;
    final double plFinal = _hasDre ? (plBase + dreNet) : plBase;
    final double rhs = passivos + plFinal;
    final bool balanced = (ativos - rhs).abs() <= 0.001;

    return Card(
      color: const Color(0xFFE0F7FA),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Totais (Balanço)',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            _summaryLine('Ativo Circulante', totals['ac'] ?? 0.0),
            _summaryLine('Ativo não Circulante', totals['anc'] ?? 0.0),
            _summaryLine('Total do Ativo', ativos, bold: true),
            const SizedBox(height: 6),
            _summaryLine('Passivo Circulante', totals['pc'] ?? 0.0),
            _summaryLine('Passivo não Circulante', totals['pnc'] ?? 0.0),
            if (_hasDre) ...[
              _summaryLine('Patrimônio Líquido inicial', plBase),
              _summaryLine(
                dreNet >= 0 ? 'Lucro líquido' : 'Prejuízo líquido',
                dreNet.abs(),
                bold: true,
              ),
              _summaryLine('Patrimônio Líquido final', plFinal, bold: true),
            ] else ...[
              _summaryLine('Patrimônio Líquido', plBase),
            ],
            _summaryLine('Passivo + PL', rhs, bold: true),
            const SizedBox(height: 8),
            Divider(color: AppTheme.dividerColor.withOpacity(0.25), height: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'A = P + PL',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textColor,
                            fontSize: 12,
                          ),
                        ),
                        const TextSpan(text: '  '),
                        const WidgetSpan(child: SizedBox(width: 6)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${_formatValue(ativos)}  =  ${_formatValue(passivos)}  +  ${_formatValue(plFinal)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: balanced ? AppTheme.successColor : AppTheme.errorColor,
                          ),
                        ),
                      ),
                      if (!balanced) ...[
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Diferença: ${_formatValue((ativos - rhs).abs())}',
                            style: TextStyle(
                              color: AppTheme.errorColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<String> _itemIdsForTarget(String targetId) {
    return widget.correctMap.entries.where((e) => e.value == targetId).map((e) => e.key).toList();
  }

  List<MatchSumItem> _itemsForTarget(String targetId) {
    final ids = _itemIdsForTarget(targetId);
    return ids
        .map((id) => widget.items.firstWhere(
              (it) => it.id == id,
              orElse: () => MatchSumItem(id: '', label: '', value: 0),
            ))
        .where((item) => item.id.isNotEmpty)
        .toList();
  }

  double _sumForTarget(String targetId) {
    double total = 0.0;
    for (final itemId in _itemIdsForTarget(targetId)) {
      final item = widget.items.firstWhere(
        (it) => it.id == itemId,
        orElse: () => MatchSumItem(id: '', label: '', value: 0),
      );
      total += item.value;
    }
    return total;
  }

  MatchTarget? _findTargetById(String id, List<MatchTarget> targets) {
    for (final t in targets) {
      if (t.id == id) return t;
      if (t.subs != null && t.subs!.isNotEmpty) {
        final found = _findTargetById(id, t.subs!);
        if (found != null) return found;
      }
    }
    return null;
  }

  String _fmtMoney(double value) {
    if (value.abs() < 0.001) return '-';
    final negative = value < 0;
    final raw = value.abs().toStringAsFixed(2);
    final parts = raw.split('.');
    final intPart = parts[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.');
    return '${negative ? '-' : ''}$intPart,${parts[1]}';
  }

  List<MatchTarget> _leftRoots() {
    return widget.targets.where((t) {
      final id = t.id;
      return id == 'ac' || id == 'anc' || id.startsWith('ac') || id.startsWith('anc');
    }).toList();
  }

  List<MatchTarget> _rightRoots() {
    return widget.targets.where((t) {
      final id = t.id;
      return id == 'pc' || id == 'pnc' || id == 'pl' || id.startsWith('pc') || id.startsWith('pnc') || id.startsWith('pl');
    }).toList();
  }

  bool _hasNodeContent(MatchTarget node) {
    if (_itemsForTarget(node.id).isNotEmpty) return true;
    for (final sub in node.subs ?? const <MatchTarget>[]) {
      if (_hasNodeContent(sub)) return true;
    }
    return false;
  }

  double _sumNodeRecursive(MatchTarget node) {
    double total = 0.0;
    for (final item in _itemsForTarget(node.id)) {
      total += item.value;
    }
    for (final sub in node.subs ?? const <MatchTarget>[]) {
      total += _sumNodeRecursive(sub);
    }
    return total;
  }

  double _sumTargetTree(String targetId) {
    final target = _findTargetById(targetId, widget.targets);
    if (target == null) return _sumForTarget(targetId);

    double total = _sumForTarget(targetId);
    for (final sub in target.subs ?? const <MatchTarget>[]) {
      total += _sumTargetTree(sub.id);
    }
    return total;
  }

  List<_BpLine> _buildNodeLines(MatchTarget node, {int level = 0}) {
    if (!_hasNodeContent(node)) return const <_BpLine>[];

    final lines = <_BpLine>[];
    final total = _sumNodeRecursive(node);
    final directItems = _itemsForTarget(node.id);
    final hasChildren = node.subs != null && node.subs!.isNotEmpty;
    final isLeafSingleItem =
        !hasChildren &&
        directItems.length == 1 &&
        directItems.first.label.trim().toLowerCase() == node.label.trim().toLowerCase();

    if (isLeafSingleItem) {
      final item = directItems.first;
      lines.add(_BpLine(label: item.label, value: item.value, level: level, header: false));
      return lines;
    }

    lines.add(_BpLine(label: node.label, value: total, level: level, header: true));

    for (final item in directItems) {
      lines.add(_BpLine(label: item.label, value: item.value, level: level + 1, header: false));
    }

    for (final sub in node.subs ?? const <MatchTarget>[]) {
      lines.addAll(_buildNodeLines(sub, level: level + 1));
    }

    return lines;
  }

  List<_BpLine> _buildSideLines(List<MatchTarget> roots) {
    final lines = <_BpLine>[];
    for (final root in roots) {
      lines.addAll(_buildNodeLines(root, level: 0));
    }
    return lines;
  }

  Widget _lineCell(
    String text, {
    bool bold = false,
    bool header = false,
    bool value = false,
    bool negative = false,
    TextAlign align = TextAlign.left,
    int level = 0,
    double? fontSize,
  }) {
    final bool isLeafDetail = !header && level > 0;
    final Color bg = header ? Colors.grey.shade200 : (isLeafDetail ? Colors.white : Colors.white);
    final Color fg = negative ? Colors.red : Colors.black;

    return Container(
      padding: EdgeInsets.only(left: 8.0 + (level * 10.0), right: 8, top: 6, bottom: 6),
      constraints: const BoxConstraints(minHeight: 30),
      color: bg,
      child: Text(
        text,
        textAlign: align,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontSize ?? 11,
          fontWeight: bold || header ? FontWeight.w700 : FontWeight.w400,
          color: value ? AppTheme.primaryColor : fg,
          height: 1.0,
        ),
      ),
    );
  }

  Widget _valueCell(double value, {double? fontSize, bool header = false}) {
    return _lineCell(
      _fmtMoney(value),
      align: TextAlign.right,
      value: true,
      header: header,
      fontSize: fontSize ?? 11,
    );
  }

  TableRow _row(List<Widget> children) => TableRow(children: children);

  Widget _buildDynamicExplanationTable({required bool expanded}) {
    final leftRoots = _leftRoots();
    final rightRoots = _rightRoots();

    final leftLines = _buildSideLines(leftRoots);
    final rightLines = _buildSideLines(rightRoots);

    final double totalAtivo = _sumTargetTree('ac') + _sumTargetTree('anc');
    final double totalPassivo = _sumTargetTree('pc') + _sumTargetTree('pnc');
    final double totalPLBase = _sumTargetTree('pl');
    final double totalPL = _hasDre ? (totalPLBase + _dreNetResult()) : totalPLBase;
    final double rhs = totalPassivo + totalPL;

    final int bodyCount = leftLines.length > rightLines.length ? leftLines.length : rightLines.length;

    while (leftLines.length < bodyCount) {
      leftLines.add(const _BpLine.empty());
    }
    while (rightLines.length < bodyCount) {
      rightLines.add(const _BpLine.empty());
    }

    final rows = <TableRow>[];

    for (int i = 0; i < bodyCount; i++) {
      final left = leftLines[i];
      final right = rightLines[i];

      rows.add(
        _row([
          _lineCell(left.label, header: left.header, bold: left.header, level: left.level, fontSize: expanded ? 12 : 11),
          _valueCell(left.value, header: left.header, fontSize: expanded ? 12 : 11),
          _lineCell(right.label, header: right.header, bold: right.header, level: right.level, fontSize: expanded ? 12 : 11),
          _valueCell(right.value, header: right.header, fontSize: expanded ? 12 : 11),
        ]),
      );
    }

    rows.add(
      _row([
        _lineCell('TOTAL DO ATIVO', header: true, bold: true, fontSize: expanded ? 12 : 11),
        _valueCell(totalAtivo, header: true, fontSize: expanded ? 12 : 11),
        _lineCell('TOTAL PASSIVO + PL', header: true, bold: true, fontSize: expanded ? 12 : 11),
        _valueCell(rhs, header: true, fontSize: expanded ? 12 : 11),
      ]),
    );

    return Table(
      border: TableBorder.all(color: Colors.black, width: 1),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: FlexColumnWidth(2.4),
        1: FlexColumnWidth(1.1),
        2: FlexColumnWidth(2.4),
        3: FlexColumnWidth(1.1),
      },
      children: rows,
    );
  }

  Widget _buildBalanceSheetExplanation(bool small) {
if (!submitted || widget.explanation == null || widget.explanation!.trim().isEmpty) {
  return const SizedBox.shrink();
}

    return Column(
      key: _explanationKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text('Explicação', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async {
            if (!mounted) return;

            await showGeneralDialog(
              context: context,
              barrierDismissible: true,
              barrierLabel: 'Fechar',
              barrierColor: Colors.black54,
              transitionDuration: const Duration(milliseconds: 180),
              pageBuilder: (dialogContext, animation, secondaryAnimation) {
                final screenWidth = MediaQuery.of(dialogContext).size.width;
                final contentWidth = screenWidth - 24;
                final tableWidth = contentWidth < 760 ? 760.0 : contentWidth;

                return Material(
                  color: const Color(0xFFE0F7FA),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Explicação',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textColor,
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () => Navigator.of(dialogContext).pop(),
                                icon: const Icon(Icons.close),
                                label: const Text('Voltar'),
                              ),
                            ],
                          ),
                        ),
                        Divider(color: AppTheme.dividerColor.withOpacity(0.25), height: 1),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: InteractiveViewer(
                              constrained: false,
                              panEnabled: true,
                              scaleEnabled: true,
                              minScale: 1.0,
                              maxScale: 3.0,
                              boundaryMargin: const EdgeInsets.all(80),
                              child: SizedBox(
                                width: tableWidth,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDynamicExplanationTable(expanded: true),
                                    const SizedBox(height: 12),
                                    Divider(color: AppTheme.dividerColor.withOpacity(0.25), height: 1),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Card(
            elevation: 1,
            color: const Color(0xFFE0F7FA),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const double baseWidth = 760;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: constraints.maxWidth,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: baseWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDynamicExplanationTable(expanded: false),
                              const SizedBox(height: 12),
                              Divider(color: AppTheme.dividerColor.withOpacity(0.25), height: 1),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(MatchSumItem item) {
    final bool selected = _selectedItemId == item.id;
    final bool available = availableItems.any((ai) => ai.id == item.id);

    return GestureDetector(
      onTap: () {
        if (available) _toggleSelectItem(item.id);
      },
      child: Draggable<String>(
        data: item.id,
        feedback: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(color: kPrimaryColor.withOpacity(0.28)),
            ),
            child: Text('${item.label} — ${_formatValue(item.value)}', style: const TextStyle(fontSize: 14)),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.35,
          child: _chipContainer(item, selected: false, available: available),
        ),
        child: _chipContainer(item, selected: selected, available: available),
        onDragStarted: () {
          if (_selectedItemId != null) {
            setState(() {
              _selectedItemId = null;
            });
          }
        },
      ),
    );
  }

  Widget _chipContainer(MatchSumItem item, {required bool selected, required bool available}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected
              ? kPrimaryColor
              : (available ? kPrimaryColor.withOpacity(0.05) : Colors.grey.shade300),
          width: selected ? 1.6 : 1.0,
        ),
        color: selected
            ? kPrimaryColor.withOpacity(0.10)
            : (available ? kPrimaryColor.withOpacity(0.35) : Colors.grey.shade50),
        boxShadow: [
          BoxShadow(
            color: selected ? kPrimaryColor.withOpacity(0.12) : Colors.black.withOpacity(0.02),
            blurRadius: selected ? 8 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '${item.label} — ${_formatValue(item.value)}',
        style: TextStyle(
          fontSize: 14,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          color: selected ? kPrimaryColor : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSubTargetBox(MatchTarget sub, double width) {
    final assignedIds = assignments[sub.id] ?? [];
    final subtotal = _computeTargetSums()[sub.id] ?? 0.0;
    final isCorrect = correctness[sub.id] ?? false;

    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: () {
          if (_selectedItemId != null && !submitted) {
            _assign(_selectedItemId!, sub.id);
          }
        },
child: DragTarget<String>(
  onWillAccept: (data) {
    if (submitted || data == null) return false;
    return widget.items.any((i) => i.id == data);
  },
  onAccept: (data) {
    if (data == null) return;
    if (!widget.items.any((i) => i.id == data)) return;
    HapticFeedback.lightImpact();
    _assign(data, sub.id);
  },
  builder: (context, candidate, rejected) {
    final bool isHovering = candidate.isNotEmpty;

    final borderColor = submitted
        ? (isCorrect ? Colors.green.withOpacity(0.6) : Colors.orange.shade400)
        : (isHovering ? kPrimaryColor.withOpacity(0.95) : Colors.grey.shade300);

    final fillColor = submitted
        ? (isCorrect ? Colors.green.withOpacity(0.06) : Colors.orange.withOpacity(0.06))
        : (isHovering ? kPrimaryColor.withOpacity(0.10) : Colors.white);

    final Widget stripe = submitted
        ? Container(height: 4, width: double.infinity, color: isCorrect ? Colors.green : Colors.orange)
        : AnimatedContainer(
            duration: kTopStripeAnimDuration,
            height: isHovering ? kTopStripeExpandedHeight : kTopStripeCollapsedHeight,
            width: double.infinity,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: (isHovering
                    ? kTopStripeExpandedWidthFactor
                    : (_selectedItemId != null ? 0.6 : kTopStripeCollapsedWidthFactor)),
                child: AnimatedContainer(
                  duration: kTopStripeAnimDuration,
                  height: isHovering ? kTopStripeExpandedHeight : kTopStripeCollapsedHeight,
                  decoration: BoxDecoration(
                    color: isHovering
                        ? kPrimaryColor.withOpacity(0.95)
                        : (_selectedItemId != null
                            ? kPrimaryColor.withOpacity(0.55)
                            : Colors.transparent),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                ),
              ),
            ),
          );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: isHovering ? 2.4 : 1.2),
        color: fillColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          stripe,
          Row(
            children: [
              Expanded(
                child: Text(sub.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
              if (submitted)
                Icon(
                  isCorrect ? Icons.check_circle : Icons.highlight_off,
                  size: 16,
                  color: isCorrect ? Colors.green : Colors.orange,
                ),
              if (!submitted)
                Icon(
                  Icons.drag_indicator,
                  size: 16,
                  color: isHovering ? kPrimaryColor : Colors.grey,
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Subtotal: ${_formatValue(subtotal)}',
            style: TextStyle(fontSize: 11, color: Colors.black.withOpacity(0.6)),
          ),
          if (assignedIds.isNotEmpty) ...[
            const SizedBox(height: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: assignedIds.map((id) {
                final it = widget.items.firstWhere(
                  (it) => it.id == id,
                  orElse: () => MatchSumItem(id: '', label: '', value: 0),
                );
                if (it.id.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    children: [
                      Expanded(child: Text(it.label, style: const TextStyle(fontSize: 12))),
                      Text(_formatValue(it.value), style: const TextStyle(fontSize: 12)),
                      if (!submitted)
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: InkWell(
                            onTap: () => _unassignFromTarget(sub.id, id),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.10),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, size: 14, color: Colors.red),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  },
),      ),
    );
  }

  Widget _targetCard(MatchTarget t, double width) {
    final assignedIds = assignments[t.id] ?? [];
    final subtotal = _computeTargetSums()[t.id] ?? 0.0;
    final isCorrect = correctness[t.id] ?? false;

    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: () {
          if (_selectedItemId != null && !submitted) _assign(_selectedItemId!, t.id);
        },
   child: DragTarget<String>(
  onWillAccept: (data) {
    if (submitted || data == null) return false;
    return widget.items.any((i) => i.id == data);
  },
  onAccept: (data) {
    if (data == null) return;
    if (!widget.items.any((i) => i.id == data)) return;
    HapticFeedback.lightImpact();
    _assign(data, t.id);
  },
  builder: (context, candidateData, rejectedData) {
    final isHovering = candidateData.isNotEmpty;

    final borderColor = submitted
        ? (isCorrect ? Colors.green.withOpacity(0.6) : Colors.orange.shade400)
        : (isHovering ? kPrimaryColor.withOpacity(0.95) : Colors.grey.shade300);

    final fillColor = submitted
        ? (isCorrect ? Colors.green.withOpacity(0.06) : Colors.orange.withOpacity(0.06))
        : (isHovering ? kPrimaryColor.withOpacity(0.08) : Colors.white);

    final Widget stripe = submitted
        ? Container(height: 4, width: double.infinity, color: isCorrect ? Colors.green : Colors.orange)
        : AnimatedContainer(
            duration: kTopStripeAnimDuration,
            height: isHovering ? kTopStripeExpandedHeight : kTopStripeCollapsedHeight,
            width: double.infinity,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: (isHovering
                    ? kTopStripeExpandedWidthFactor
                    : (_selectedItemId != null ? 0.6 : kTopStripeCollapsedWidthFactor)),
                child: AnimatedContainer(
                  duration: kTopStripeAnimDuration,
                  height: isHovering ? kTopStripeExpandedHeight : kTopStripeCollapsedHeight,
                  decoration: BoxDecoration(
                    color: isHovering
                        ? kPrimaryColor.withOpacity(0.95)
                        : (_selectedItemId != null
                            ? kPrimaryColor.withOpacity(0.55)
                            : Colors.transparent),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                ),
              ),
            ),
          );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: isHovering ? 2.4 : 2.0),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          stripe,
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(t.label, style: const TextStyle(fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 8),
              Icon(
                submitted ? (isCorrect ? Icons.check_circle : Icons.error) : Icons.account_balance,
                color: submitted ? (isCorrect ? Colors.green : Colors.orange) : Colors.grey.shade600,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Total: ${_formatValue(subtotal)}',
            style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.7)),
          ),
          if (assignedIds.isNotEmpty) ...[
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: assignedIds.map((id) {
                final it = widget.items.firstWhere(
                  (it) => it.id == id,
                  orElse: () => MatchSumItem(id: '', label: '', value: 0),
                );
                if (it.id.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    children: [
                      Expanded(child: Text(it.label, style: const TextStyle(fontSize: 13))),
                      Text(_formatValue(it.value), style: const TextStyle(fontSize: 13)),
                      const SizedBox(width: 6),
                      if (!submitted)
                        InkWell(
                          onTap: () => _unassignFromTarget(t.id, id),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.10),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, size: 14, color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  },
),      ),
    );
  }

  Widget _elevatedAction(String label, VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: kPrimaryActionStyle,
      child: Text(
        label,
        style: const TextStyle(fontSize: kActionButtonFontSize, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _outlinedAction(String label, VoidCallback? onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: kSecondaryActionStyle,
      child: Text(
        label,
        style: const TextStyle(fontSize: kActionButtonFontSize, fontWeight: FontWeight.w700),
      ),
    );
  }

 @override
Widget build(BuildContext context) {
  super.build(context);

  final double width = MediaQuery.of(context).size.width;
  const double horizontalPadding = 16.0 * 2;
  const double spacing = 12.0;
  final bool oneColumn = width - horizontalPadding < 520;
  final double availableWidth =
      (width - horizontalPadding) - (oneColumn ? 0.0 : spacing);
  final double itemWidth = oneColumn ? availableWidth : (availableWidth / 2);

  return SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AbsorbPointer(
            absorbing: submitted,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableItems.map(_buildChip).toList(),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: widget.targets.map((t) {
              if (t.subs != null && t.subs!.isNotEmpty) {
                final targetSums = _computeTargetSums();
                final parentSubtotal = targetSums[t.id] ?? 0.0;

                return SizedBox(
                  width: itemWidth,
                  child: GestureDetector(
                    onTap: () {
                      if (_selectedItemId != null && !submitted) {
                        _assign(_selectedItemId!, t.id);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: kCardColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300, width: 1.6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  t.label,
                                  style: const TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.folder_open, color: Colors.grey.shade600),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Total: ${_formatValue(parentSubtotal)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: t.subs!
                                .map((sub) {
                                  final subWidth =
                                      (itemWidth - 24) / (t.subs!.length <= 2 ? 2 : 1.0);
                                  return _buildSubTargetBox(
                                    sub,
                                    subWidth.clamp(100.0, itemWidth - 20),
                                  );
                                })
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return _targetCard(t, itemWidth);
              }
            }).toList(),
          ),
          const SizedBox(height: 12),

          if (_hasDre) ...[
            _buildDreInteractiveCard(),
            const SizedBox(height: 12),
          ],

          widget.isDfcMode ? _buildDfcCard() : _buildTotalsCard(),
          const SizedBox(height: 12),

          if (!widget.isDfcMode) _buildBalanceSheetExplanation(oneColumn),

          const SizedBox(height: 120),
        ],
      ),
    ),
  );
}}

class SkipNextNotification extends Notification {}

class _BpLine {
  final String label;
  final double value;
  final int level;
  final bool header;

  const _BpLine({
    required this.label,
    required this.value,
    required this.level,
    required this.header,
  });

  const _BpLine.empty()
      : label = '',
        value = 0.0,
        level = 0,
        header = false;
}
