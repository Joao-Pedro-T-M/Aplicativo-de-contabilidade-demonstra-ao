import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/course_models.dart';

const Color kPrimaryColor = Color(0xFF4CB2B2);
const Color kSecondaryTextColor = Color(0xFF2D6B6B);
const Color kCardColor = Color(0xFFFFFFFF);
const Color kTextColor = Colors.black87;

const double kActionButtonHeight = 56.0;
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
  elevation: 1,
);

final ButtonStyle kSecondaryActionStyle = OutlinedButton.styleFrom(
  foregroundColor: kPrimaryColor,
  side: BorderSide(color: kPrimaryColor.withOpacity(0.28)),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  minimumSize: const Size.fromHeight(kActionButtonHeight),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  textStyle: const TextStyle(
    fontSize: kActionButtonFontSize,
    fontWeight: FontWeight.w700,
  ),
);

typedef MethodCountsCallback = void Function(Map<String, int> counts);

class InventoryMethodItem {
  final String id;
  final String label;
  final String correctMethod;
  final String? detail;
  final String? mnemonic;

  const InventoryMethodItem({
    required this.id,
    required this.label,
    required this.correctMethod,
    this.detail,
    this.mnemonic,
  });
}

class InventoryMethodQuestion {
  final String id;
  final String text;
  final List<InventoryMethodItem> items;
  final List<MatchTarget> targets;
  final Map<String, String> correctMap;
  final String? explanation;
  final Map<String, String>? methodNotes;
  final Map<String, List<String>>? groups;

  const InventoryMethodQuestion({
    required this.id,
    required this.text,
    required this.items,
    required this.targets,
    required this.correctMap,
    this.explanation,
    this.methodNotes,
    this.groups,
  });
}

class DragMatchInventoryMethodWidget extends StatefulWidget {
  final List<InventoryMethodItem> items;
  final List<MatchTarget> targets;
  final Map<String, String> correctMap;
  final String? questionText;
  final void Function(bool allCorrect)? onSubmitted;
  final VoidCallback? onSkip;
  final MethodCountsCallback? onCountsChanged;
  final String? explanation;
  final Map<String, String>? methodNotes;
  final Map<String, List<String>>? groups;
  final ValueChanged<bool>? onInteractionChanged;

  const DragMatchInventoryMethodWidget({
    super.key,
    required this.items,
    required this.targets,
    required this.correctMap,
    this.questionText,
    this.onSubmitted,
    this.onSkip,
    this.onCountsChanged,
    this.explanation,
    this.methodNotes,
    this.groups,
    this.onInteractionChanged,
  });

  factory DragMatchInventoryMethodWidget.fromQuestion(
    InventoryMethodQuestion question, {
    void Function(bool allCorrect)? onSubmitted,
    VoidCallback? onSkip,
    MethodCountsCallback? onCountsChanged,
    ValueChanged<bool>? onInteractionChanged,
  }) {
    return DragMatchInventoryMethodWidget(
      key: ValueKey(question.id),
      items: question.items,
      targets: question.targets,
      correctMap: question.correctMap,
      questionText: question.text,
      explanation: question.explanation,
      methodNotes: question.methodNotes,
      groups: question.groups,
      onSubmitted: onSubmitted,
      onSkip: onSkip,
      onCountsChanged: onCountsChanged,
      onInteractionChanged: onInteractionChanged,
    );
  }

  @override
  State<DragMatchInventoryMethodWidget> createState() =>
      _DragMatchInventoryMethodWidgetState();
}

class _TargetLabelParts {
  final String prefix;
  final String title;

  const _TargetLabelParts({required this.prefix, required this.title});
}

class _MovementNumbers {
  final String quant;
  final String unit;
  final String total;

  const _MovementNumbers({
    required this.quant,
    required this.unit,
    required this.total,
  });
}

class _LedgerRowModel {
  final InventoryMethodItem item;
  final String? targetId;
  final MatchTarget? target;
  final String targetLabel;
  final String kind;

  final String entradaQuant;
  final String entradaUnit;
  final String entradaTotal;

  final String saidaQuant;
  final String saidaUnit;
  final String saidaTotal;

  final String saldoQuant;
  final String saldoUnit;
  final String saldoTotal;

  final bool assigned;
  final bool correct;

  const _LedgerRowModel({
    required this.item,
    required this.targetId,
    required this.target,
    required this.targetLabel,
    required this.kind,
    required this.entradaQuant,
    required this.entradaUnit,
    required this.entradaTotal,
    required this.saidaQuant,
    required this.saidaUnit,
    required this.saidaTotal,
    required this.saldoQuant,
    required this.saldoUnit,
    required this.saldoTotal,
    required this.assigned,
    required this.correct,
  });
}

class _StockLayer {
  double qty;
  double unitCost;

  _StockLayer(this.qty, this.unitCost);
}

class _InventoryState {
  final String method;
  final List<_StockLayer> _layers = [];
  final List<_StockLayer> _lastSaleLayers = [];

  double _qty = 0;
  double _total = 0;

  _InventoryState({required this.method});

  double get qty => _qty;
  double get total => _total;
  double get avgCost => _qty == 0 ? 0 : _total / _qty;

  void add(double qty, double unitCost) {
    if (qty <= 0) return;

    _qty += qty;
    _total += qty * unitCost;

    if (method != 'mpm') {
      _layers.add(_StockLayer(qty, unitCost));
    }
  }

  double consumeForSale(double qty) {
    if (qty <= 0) return 0;

    if (method == 'mpm') {
      final cost = qty * avgCost;
      _qty -= qty;
      _total -= cost;
      return cost;
    }

    return _consumeLayers(
      qty,
      fromEnd: method == 'ueps',
      recordAsLastSale: true,
    );
  }

  double removeLatestPurchase(double qty) {
    if (qty <= 0) return 0;

    if (method == 'mpm') {
      final cost = qty * avgCost;
      _qty -= qty;
      _total -= cost;
      return cost;
    }

    return _consumeLayers(
      qty,
      fromEnd: true,
      recordAsLastSale: false,
    );
  }

  double addSaleReturn(double qty) {
    if (qty <= 0) return 0;

    if (method == 'mpm') {
      final cost = qty * avgCost;
      add(qty, avgCost);
      return cost;
    }

    if (_lastSaleLayers.isEmpty) {
      final cost = qty * avgCost;
      add(qty, avgCost);
      return cost;
    }

    double remaining = qty;
    double cost = 0;

    for (var i = _lastSaleLayers.length - 1; i >= 0 && remaining > 0; i--) {
      final layer = _lastSaleLayers[i];
      final take = remaining < layer.qty ? remaining : layer.qty;

      cost += take * layer.unitCost;
      add(take, layer.unitCost);
      remaining -= take;
    }

    if (remaining > 0) {
      final unit = avgCost;
      cost += remaining * unit;
      add(remaining, unit);
    }

    return cost;
  }

  double _consumeLayers(
    double qty, {
    required bool fromEnd,
    required bool recordAsLastSale,
  }) {
    double remaining = qty;
    double cost = 0;
    final consumed = <_StockLayer>[];

    while (remaining > 0 && _layers.isNotEmpty) {
      final index = fromEnd ? _layers.length - 1 : 0;
      final layer = _layers[index];
      final take = remaining < layer.qty ? remaining : layer.qty;

      cost += take * layer.unitCost;
      consumed.add(_StockLayer(take, layer.unitCost));

      layer.qty -= take;
      remaining -= take;

      if (layer.qty <= 0.000001) {
        _layers.removeAt(index);
      }
    }

    _qty -= (qty - remaining);
    _total -= cost;

    if (recordAsLastSale) {
      _lastSaleLayers
        ..clear()
        ..addAll(consumed);
    }

    return cost;
  }
}

class _DragMatchInventoryMethodWidgetState extends State<DragMatchInventoryMethodWidget>
    with AutomaticKeepAliveClientMixin {
  late List<InventoryMethodItem> availableItems;
  late Map<String, List<String>> assignments;
  late Map<String, bool> correctness;

  bool submitted = false;
  bool _overallCorrect = false;
  String? _selectedItemId;
  bool _sheetExpanded = false;

  final GlobalKey _explanationKey = GlobalKey();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _resetState();
  }

  bool _sameItemLists(
    List<InventoryMethodItem> a,
    List<InventoryMethodItem> b,
  ) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }

  bool _sameTargetLists(List<MatchTarget> a, List<MatchTarget> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id || a[i].label != b[i].label) return false;
    }
    return true;
  }

  bool _sameStringMap(Map<String, String>? a, Map<String, String>? b) {
    final aa = a ?? const <String, String>{};
    final bb = b ?? const <String, String>{};
    if (aa.length != bb.length) return false;
    for (final entry in aa.entries) {
      if (bb[entry.key] != entry.value) return false;
    }
    return true;
  }

  bool _sameGroups(
    Map<String, List<String>>? a,
    Map<String, List<String>>? b,
  ) {
    final aa = a ?? const <String, List<String>>{};
    final bb = b ?? const <String, List<String>>{};
    if (aa.length != bb.length) return false;

    for (final entry in aa.entries) {
      final other = bb[entry.key];
      if (other == null) return false;
      if (entry.value.length != other.length) return false;
      for (int i = 0; i < entry.value.length; i++) {
        if (entry.value[i] != other[i]) return false;
      }
    }
    return true;
  }

  @override
  void didUpdateWidget(covariant DragMatchInventoryMethodWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final changed = !_sameItemLists(oldWidget.items, widget.items) ||
        !_sameTargetLists(oldWidget.targets, widget.targets) ||
        !_sameStringMap(oldWidget.correctMap, widget.correctMap) ||
        oldWidget.questionText != widget.questionText ||
        oldWidget.explanation != widget.explanation ||
        !_sameStringMap(oldWidget.methodNotes, widget.methodNotes) ||
        !_sameGroups(oldWidget.groups, widget.groups);

    if (changed) {
      _resetState();
      setState(() {});
    }
  }

  void _resetState() {
    availableItems = List<InventoryMethodItem>.from(widget.items);
    assignments = {for (final t in widget.targets) t.id: <String>[]};
    correctness = {};
    submitted = false;
    _overallCorrect = false;
    _selectedItemId = null;
    _sheetExpanded = false;
  }

  bool get _hasAnyAssignment => assignments.values.any((v) => v.isNotEmpty);

  String _methodTitle() {
    final methods = widget.items
        .map((e) => e.correctMethod.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toSet();

    if (methods.contains('peps')) return 'PEPS';
    if (methods.contains('ueps')) return 'UEPS';
    if (methods.contains('mpm')) return 'MPM';
    return 'MÉTODO';
  }

  Map<String, String> get _methodLabels => const {
        'peps': 'PEPS',
        'ueps': 'UEPS',
        'mpm': 'MPM',
      };

  Map<String, String> get _methodSummaries => {
        'peps': widget.methodNotes?['peps'] ?? 'Primeiro que entra, primeiro que sai.',
        'ueps': widget.methodNotes?['ueps'] ?? 'Último que entra, primeiro que sai.',
        'mpm': widget.methodNotes?['mpm'] ?? 'Custo médio ponderado móvel.',
      };

  Map<String, String> get _methodEffects => const {
        'peps': 'Em alta de preços, o estoque final tende a ficar mais próximo dos custos recentes.',
        'ueps': 'Em alta de preços, tende a elevar o CMV e reduzir o lucro tributável.',
        'mpm': 'Suaviza oscilações de preço e produz um resultado intermediário.',
      };

  Map<String, String> get _methodOrderHints => const {
        'peps': 'Saída pelos lotes mais antigos.',
        'ueps': 'Saída pelos lotes mais novos.',
        'mpm': 'Não depende da ordem; usa média ponderada.',
      };

  void _toggleSheetExpanded() {
    if (!mounted) return;
    setState(() {
      _sheetExpanded = !_sheetExpanded;
    });
  }

  void _notifyCounts() {
    final counts = <String, int>{};
    for (final e in assignments.entries) {
      counts[e.key] = e.value.length;
    }
    widget.onCountsChanged?.call(counts);
  }

  void _assign(String itemId, String targetId) {
    final exists = widget.items.any((i) => i.id == itemId);
    if (!exists) return;

    for (final entry in assignments.entries) {
      if (entry.value.contains(itemId)) {
        entry.value.remove(itemId);
        break;
      }
    }

    assignments[targetId]!.add(itemId);
    availableItems.removeWhere((i) => i.id == itemId);

    if (_selectedItemId == itemId) {
      _selectedItemId = null;
    }

    if (!submitted) {
      setState(() {});
    }

    HapticFeedback.lightImpact();
    _notifyCounts();
  }

  void _unassignFromTarget(String targetId, [String? itemId]) {
    if (itemId != null) {
      assignments[targetId]!.remove(itemId);
      final item = widget.items.firstWhere(
        (it) => it.id == itemId,
        orElse: () => const InventoryMethodItem(id: '', label: '', correctMethod: ''),
      );
      if (item.id.isNotEmpty && !availableItems.any((e) => e.id == item.id)) {
        availableItems.add(item);
      }
    } else {
      final removed = assignments[targetId]!.toList();
      for (final rid in removed) {
        final item = widget.items.firstWhere(
          (it) => it.id == rid,
          orElse: () => const InventoryMethodItem(id: '', label: '', correctMethod: ''),
        );
        if (item.id.isNotEmpty && !availableItems.any((e) => e.id == item.id)) {
          availableItems.add(item);
        }
      }
      assignments[targetId] = [];
    }

    if (!submitted) {
      setState(() {});
    }

    _notifyCounts();
  }

  void _toggleSelectItem(String id) {
    if (submitted) return;
    if (!availableItems.any((ai) => ai.id == id)) return;

    setState(() {
      _selectedItemId = _selectedItemId == id ? null : id;
    });
  }

  void _evaluateAndShow() {
    correctness.clear();
    bool allCorrect = true;

    for (final entry in assignments.entries) {
      final targetId = entry.key;
      final assignedList = entry.value;

      final expectedList = widget.correctMap.entries
          .where((e) => e.value == targetId)
          .map((e) => e.key)
          .toList();

      final assignedSet = <String>{...assignedList};
      final expectedSet = <String>{...expectedList};

      final ok = assignedSet.length == expectedSet.length &&
          assignedSet.difference(expectedSet).isEmpty;

      correctness[targetId] = ok;
      if (!ok) allCorrect = false;
    }

    setState(() {
      submitted = true;
      _overallCorrect = allCorrect;
    });

    widget.onSubmitted?.call(allCorrect);
    _notifyCounts();

    if (!allCorrect) {
      _scrollToExplanation();
    }
  }

  void _reset() {
    _resetState();
    setState(() {});
    _notifyCounts();
  }

  void _handleSkip() {
    widget.onSubmitted?.call(false);
    _reset();
    widget.onSkip?.call();
  }

  Future<void> _scrollToExplanation() async {
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
  }

  String _fmtCount(int n) => n.toString();

  int _columnsForWidth(double width) {
    if (width < 540) return 1;
    if (width < 900) return 2;
    return 3;
  }

  _TargetLabelParts _splitTargetLabel(String label) {
    final parts = label.split('—');
    if (parts.length >= 2) {
      return _TargetLabelParts(
        prefix: parts.first.trim(),
        title: parts.sublist(1).join('—').trim(),
      );
    }

    final fallback = label.split('-');
    if (fallback.length >= 2) {
      return _TargetLabelParts(
        prefix: fallback.first.trim(),
        title: fallback.sublist(1).join('-').trim(),
      );
    }

    return const _TargetLabelParts(prefix: 'Etapa', title: '');
  }

  String _fmtMoney(double value) {
    final negative = value < 0;
    final absValue = value.abs();
    final parts = absValue.toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    return '${negative ? '-' : ''}$intPart,${parts[1]}';
  }

  String _fmtQty(double value) {
    if (value.isNaN || value.isInfinite) return '';
    final rounded = value.roundToDouble();
    if ((value - rounded).abs() < 0.000001) {
      return rounded.toInt().toString();
    }
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  String _normalizeText(String text) {
    return text
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('â', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('ä', 'a')
        .replaceAll('é', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ç', 'c');
  }

  double? _parseMoneyFromText(String text) {
    final match = RegExp(r'R\$\s*([\d\.,]+)').firstMatch(text);
    if (match == null) return null;
    return double.tryParse(match.group(1)!.replaceAll('.', '').replaceAll(',', '.'));
  }

  double? _parseQuantityFromText(String text) {
    final candidates = [
      RegExp(
        r'(\d+(?:[\.,]\d+)?)\s*(?:unidades|unidade|unds|und|u\b)',
        caseSensitive: false,
      ),
      RegExp(r'(?<!R\$\s*)(\d+(?:[\.,]\d+)?)\s*(?:x|×)', caseSensitive: false),
      RegExp(r'\b(\d+(?:[\.,]\d+)?)\b'),
    ];

    for (final reg in candidates) {
      final match = reg.firstMatch(text);
      if (match != null) {
        final value = double.tryParse(match.group(1)!.replaceAll(',', '.'));
        if (value != null) return value;
      }
    }
    return null;
  }

  _MovementNumbers _parseMovementNumbers(InventoryMethodItem item) {
    final source = [
      item.label,
      if ((item.detail ?? '').trim().isNotEmpty) item.detail!,
      if ((item.mnemonic ?? '').trim().isNotEmpty) item.mnemonic!,
    ].join(' ');

    final qty = _parseQuantityFromText(source);
    final unit = _parseMoneyFromText(source);

    final totalFromText = RegExp(
      r'valor\s+total\s+de\s+R\$\s*([\d\.,]+)',
      caseSensitive: false,
    ).firstMatch(source)?.group(1);

    final totalExplicit = totalFromText == null
        ? null
        : double.tryParse(totalFromText.replaceAll('.', '').replaceAll(',', '.'));

    final quantText = qty == null
        ? ''
        : (qty % 1 == 0
            ? qty.toInt().toString()
            : qty.toStringAsFixed(2).replaceAll('.', ','));

    final unitText = unit == null ? '' : 'R\$ ${_fmtMoney(unit)}';

    double? totalValue;
    if (totalExplicit != null) {
      totalValue = totalExplicit;
    } else if (qty != null && unit != null) {
      totalValue = qty * unit;
    }

    final totalText = totalValue == null ? '' : 'R\$ ${_fmtMoney(totalValue)}';

    return _MovementNumbers(
      quant: quantText,
      unit: unitText,
      total: totalText,
    );
  }

  String? _assignedTargetIdForItem(String itemId) {
    for (final entry in assignments.entries) {
      if (entry.value.contains(itemId)) return entry.key;
    }
    return null;
  }

  MatchTarget? _findTargetById(String id) {
    for (final t in widget.targets) {
      if (t.id == id) return t;
    }
    return null;
  }

  String _kindForTarget(String targetId, String targetLabel) {
    final text = _normalizeText('$targetId $targetLabel');

    if (text.contains('devolucao_compra') ||
        text.contains('devolucao de compra')) {
      return 'saida';
    }

    if (text.contains('devolucao_venda') ||
        text.contains('devolucao de venda')) {
      return 'entrada';
    }

    if (text.contains('cmv') ||
        text.contains('saida') ||
        text.contains('venda') ||
        text.contains('receita')) {
      return 'saida';
    }

    if (text.contains('saldo') || text.contains('estoque final')) {
      return 'saldo';
    }

    if (text.contains('compr') || text.contains('entrada') || text.contains('compra')) {
      return 'entrada';
    }

    return 'saldo';
  }

  List<_LedgerRowModel> _buildLedgerRows() {
    final rows = <_LedgerRowModel>[];

    final method = widget.items.isNotEmpty
        ? widget.items.first.correctMethod.trim().toLowerCase()
        : 'ueps';

    final stock = _InventoryState(method: method);

    for (final item in widget.items) {
      final targetId = _assignedTargetIdForItem(item.id);
      final target = targetId == null ? null : _findTargetById(targetId);
      final targetLabel = target?.label ?? '';
      final kind = targetId == null ? 'livre' : _kindForTarget(targetId, targetLabel);

      final source = [
        item.label,
        if ((item.detail ?? '').trim().isNotEmpty) item.detail!,
        if ((item.mnemonic ?? '').trim().isNotEmpty) item.mnemonic!,
      ].join(' ');

      final qty = _parseQuantityFromText(source) ?? 0;
      final parsedUnit = _parseMoneyFromText(source);
      final parsedTotal = RegExp(
        r'valor\s+total\s+de\s+R\$\s*([\d\.,]+)',
        caseSensitive: false,
      ).firstMatch(source)?.group(1);

      final totalFromText = parsedTotal == null
          ? null
          : double.tryParse(parsedTotal.replaceAll('.', '').replaceAll(',', '.'));

      String entradaQuant = '';
      String entradaUnit = '';
      String entradaTotal = '';
      String saidaQuant = '';
      String saidaUnit = '';
      String saidaTotal = '';
      String saldoQuant = '';
      String saldoUnit = '';
      String saldoTotal = '';

      if (kind == 'saldo') {
        saldoQuant = _fmtQty(stock.qty);
        saldoUnit = _fmtMoney(stock.avgCost);
        saldoTotal = _fmtMoney(stock.total);
      } else if (kind == 'entrada') {
        double unitCost = parsedUnit ?? 0;
        double totalCost = totalFromText ?? 0;

        if (_normalizeText(source).contains('estoque inicial')) {
          if (qty > 0 && totalCost > 0) {
            unitCost = totalCost / qty;
          }
          stock.add(qty, unitCost);
          totalCost = qty * unitCost;
        } else if (_normalizeText(source).contains('devolucao de venda')) {
          totalCost = stock.addSaleReturn(qty);
          unitCost = qty > 0 ? totalCost / qty : 0;
        } else {
          if (qty > 0 && unitCost == 0 && totalCost > 0) {
            unitCost = totalCost / qty;
          }
          if (qty > 0) {
            stock.add(qty, unitCost);
            totalCost = qty * unitCost;
          }
        }

        entradaQuant = _fmtQty(qty);
        entradaUnit = _fmtMoney(unitCost);
        entradaTotal = _fmtMoney(totalCost);
      } else if (kind == 'saida') {
        double totalCost = 0;

        if (_normalizeText(source).contains('devolucao de compra')) {
          totalCost = stock.removeLatestPurchase(qty);
        } else {
          totalCost = stock.consumeForSale(qty);
        }

        final double unitCost = qty > 0 ? totalCost / qty : 0.0;

        saidaQuant = _fmtQty(qty);
        saidaUnit = _fmtMoney(unitCost);
        saidaTotal = _fmtMoney(totalCost);
      }

      saldoQuant = _fmtQty(stock.qty);
      saldoUnit = _fmtMoney(stock.avgCost);
      saldoTotal = _fmtMoney(stock.total);

      final assigned = targetId != null;
      final correct = assigned && widget.correctMap[item.id] == targetId;

      rows.add(
        _LedgerRowModel(
          item: item,
          targetId: targetId,
          target: target,
          targetLabel: targetLabel,
          kind: kind,
          entradaQuant: entradaQuant,
          entradaUnit: entradaUnit,
          entradaTotal: entradaTotal,
          saidaQuant: saidaQuant,
          saidaUnit: saidaUnit,
          saidaTotal: saidaTotal,
          saldoQuant: saldoQuant,
          saldoUnit: saldoUnit,
          saldoTotal: saldoTotal,
          assigned: assigned,
          correct: correct,
        ),
      );
    }

    return rows;
  }

  Widget _buildPrimaryAction(String label, VoidCallback? onPressed) {
    return SizedBox(
      height: kActionButtonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: kPrimaryActionStyle,
        child: Text(label),
      ),
    );
  }

  Widget _buildSecondaryAction(String label, VoidCallback? onPressed) {
    return SizedBox(
      height: kActionButtonHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        style: kSecondaryActionStyle,
        child: Text(label),
      ),
    );
  }

  Widget _methodChipContainer(
    InventoryMethodItem item, {
    required bool selected,
    required bool available,
  }) {
    final Color borderColor = selected
        ? kPrimaryColor
        : (available ? kPrimaryColor.withOpacity(0.08) : Colors.grey.shade300);

    final Color fillColor = selected
        ? kPrimaryColor.withOpacity(0.10)
        : (available ? Colors.white : Colors.grey.shade50);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: selected ? 1.5 : 1.0,
        ),
        color: fillColor,
        boxShadow: [
          BoxShadow(
            color: selected
                ? kPrimaryColor.withOpacity(0.10)
                : Colors.black.withOpacity(0.03),
            blurRadius: selected ? 10 : 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.drag_indicator,
            size: 16,
            color: selected ? kPrimaryColor : Colors.grey.shade500,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              item.label,
              maxLines: 3,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? kPrimaryColor : Colors.black87,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodChip(InventoryMethodItem item) {
    final selected = _selectedItemId == item.id;
    final available = availableItems.any((ai) => ai.id == item.id);

    return GestureDetector(
      onTap: () {
        if (available) _toggleSelectItem(item.id);
      },
      child: Draggable<String>(
        data: item.id,
        feedback: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: _methodChipContainer(item, selected: false, available: true),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.35,
          child: _methodChipContainer(item, selected: false, available: available),
        ),
        child: _methodChipContainer(item, selected: selected, available: available),
        onDragStarted: () {
          if (_selectedItemId != null) {
            setState(() => _selectedItemId = null);
          }
        },
      ),
    );
  }

  Widget _methodMetaCard(String id, {required bool small}) {
    final title = _methodLabels[id] ?? id.toUpperCase();
    final note = _methodSummaries[id] ?? '';
    final effect = _methodEffects[id] ?? '';
    final order = _methodOrderHints[id] ?? '';
    final target = _findTargetById(id);
    final label = target?.label ?? id;

    final assignedIds = assignments[id] ?? <String>[];
    final isCorrect = correctness[id] ?? false;

    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          if (_selectedItemId != null && !submitted) {
            _assign(_selectedItemId!, id);
          }
        },
        child: DragTarget<String>(
          onWillAccept: (data) {
            if (submitted || data == null) return false;
            return widget.items.any((i) => i.id == data);
          },
          onAccept: (data) {
            if (!mounted) return;
            if (!widget.items.any((i) => i.id == data)) return;
            _assign(data, id);
          },
          builder: (context, candidateData, rejectedData) {
            final hovering = candidateData.isNotEmpty;

            final Color borderColor = submitted
                ? (isCorrect
                    ? Colors.green.withOpacity(0.55)
                    : Colors.orange.shade400)
                : (hovering ? kPrimaryColor : Colors.grey.shade300);

            final Color fillColor = submitted
                ? (isCorrect
                    ? Colors.green.withOpacity(0.05)
                    : Colors.orange.withOpacity(0.05))
                : (hovering ? kPrimaryColor.withOpacity(0.08) : Colors.white);

            return AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: hovering ? 2.0 : 1.1),
                color: fillColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: small ? 10.5 : 11,
                            fontWeight: FontWeight.w700,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (submitted)
                        Icon(
                          isCorrect ? Icons.check_circle : Icons.highlight_off,
                          size: 16,
                          color: isCorrect ? Colors.green : Colors.orange,
                        )
                      else
                        Icon(
                          Icons.drag_indicator,
                          size: 16,
                          color: hovering ? kPrimaryColor : Colors.grey,
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    note,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black.withOpacity(0.58),
                      height: 1.2,
                    ),
                  ),
                  if (order.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      order,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: Colors.black.withOpacity(0.50),
                        height: 1.2,
                      ),
                    ),
                  ],
                  if (effect.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      effect,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: Colors.black.withOpacity(0.50),
                        height: 1.2,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    assignedIds.isEmpty
                        ? 'Arraste as afirmações corretas aqui.'
                        : '${_fmtCount(assignedIds.length)} item(s) atribuído(s)',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black.withOpacity(0.58),
                    ),
                  ),
                  if (assignedIds.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: assignedIds.map((itemId) {
                        final it = widget.items.firstWhere(
                          (x) => x.id == itemId,
                          orElse: () => const InventoryMethodItem(
                            id: '',
                            label: '',
                            correctMethod: '',
                          ),
                        );
                        if (it.id.isEmpty) return const SizedBox.shrink();

                        final bool thisCorrect = widget.correctMap[it.id] == id;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: submitted
                                  ? (thisCorrect
                                      ? Colors.green.withOpacity(0.05)
                                      : Colors.red.withOpacity(0.05))
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.14),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      it.label,
                                      style: const TextStyle(fontSize: 12, height: 1.2),
                                    ),
                                  ),
                                  if (!submitted)
                                    InkWell(
                                      onTap: () => _unassignFromTarget(id, itemId),
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.10),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 14,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _tableHeader(String text) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          height: 1.1,
        ),
      ),
    );
  }

  Widget _tableCell(
    String text, {
    TextAlign align = TextAlign.center,
    bool bold = false,
    Color? color,
    bool compact = false,
  }) {
    return Container(
      alignment: align == TextAlign.right ? Alignment.centerRight : Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: compact ? 7 : 10),
      child: Text(
        text,
        textAlign: align,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 11.5,
          height: 1.12,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          color: color ?? Colors.black87,
        ),
      ),
    );
  }

  Widget _buildExplanation() {
    final text = widget.explanation?.trim() ?? '';
    if (!submitted || text.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      key: _explanationKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(
          'Explicação',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          color: kCardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: kTextColor, height: 1.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionPanel() {
    final canSubmit = _hasAnyAssignment && !submitted;
    final bool showReset = submitted || _hasAnyAssignment;

    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 520;
        final buttons = <Widget>[];

        if (!submitted) {
          buttons.add(
            _buildPrimaryAction(
              'Enviar',
              canSubmit ? _evaluateAndShow : null,
            ),
          );
          if (showReset) {
            buttons.add(_buildSecondaryAction('Tentar novamente', _reset));
          }
        } else {
          buttons.add(_buildPrimaryAction('Pular', _handleSkip));
          buttons.add(_buildSecondaryAction('Tentar novamente', _reset));
        }

        if (narrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int i = 0; i < buttons.length; i++) ...[
                buttons[i],
                if (i != buttons.length - 1) const SizedBox(height: 10),
              ],
            ],
          );
        }

        return Row(
          children: [
            for (int i = 0; i < buttons.length; i++) ...[
              Expanded(child: buttons[i]),
              if (i != buttons.length - 1) const SizedBox(width: 12),
            ],
          ],
        );
      },
    );
  }

  Widget _buildLedgerTable(List<_LedgerRowModel> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Table(
          border: TableBorder.all(color: Colors.black, width: 1),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(1.55),
            1: FlexColumnWidth(0.95),
            2: FlexColumnWidth(1.0),
            3: FlexColumnWidth(1.0),
            4: FlexColumnWidth(0.95),
            5: FlexColumnWidth(1.0),
            6: FlexColumnWidth(1.0),
            7: FlexColumnWidth(0.95),
            8: FlexColumnWidth(1.0),
            9: FlexColumnWidth(1.0),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey.shade300),
              children: [
                _tableHeader('Data'),
                _tableHeader(''),
                _tableHeader('Entradas/Compras'),
                _tableHeader(''),
                _tableHeader(''),
                _tableHeader('Saídas/CMV'),
                _tableHeader(''),
                _tableHeader(''),
                _tableHeader('Saldo'),
                _tableHeader(''),
              ],
            ),
            TableRow(
              decoration: BoxDecoration(color: Colors.grey.shade100),
              children: [
                _tableHeader(''),
                _tableHeader('Quant'),
                _tableHeader('Vl. Unit'),
                _tableHeader('Vl. Total'),
                _tableHeader('Quant'),
                _tableHeader('Vl. Unit'),
                _tableHeader('Vl. Total'),
                _tableHeader('Quant'),
                _tableHeader('Vl. Unit'),
                _tableHeader('Vl. Total'),
              ],
            ),
            ...rows.map((row) {
              final title = row.targetLabel.isNotEmpty ? row.targetLabel : row.item.label;
              final dataText = row.item.label + (row.targetLabel.isNotEmpty ? '\n$title' : '');
              final rowColor = submitted
                  ? (row.correct
                      ? Colors.green.withOpacity(0.06)
                      : (row.assigned ? Colors.red.withOpacity(0.06) : Colors.transparent))
                  : Colors.transparent;

              return TableRow(
                decoration: BoxDecoration(color: rowColor),
                children: [
                  _tableCell(dataText, align: TextAlign.left, bold: true, compact: true),
                  _tableCell(row.entradaQuant, compact: true),
                  _tableCell(row.entradaUnit, compact: true),
                  _tableCell(row.entradaTotal, compact: true),
                  _tableCell(row.saidaQuant, compact: true),
                  _tableCell(row.saidaUnit, compact: true),
                  _tableCell(row.saidaTotal, compact: true),
                  _tableCell(row.saldoQuant, compact: true),
                  _tableCell(row.saldoUnit, compact: true),
                  _tableCell(row.saldoTotal, compact: true),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildControlSheetDock() {
    final rows = _buildLedgerRows();
    final method = _methodTitle();

    return InventoryControlSheetCard(
      method: method,
      rows: rows,
      submitted: submitted,
      compact: MediaQuery.of(context).size.width < 700,
      expanded: _sheetExpanded,
      tableBuilder: _buildLedgerTable,
      onToggleExpanded: _toggleSheetExpanded,
      onInteractionChanged: widget.onInteractionChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final questionText = widget.questionText?.trim() ?? '';

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            if (questionText.isNotEmpty) ...[
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    questionText,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            AbsorbPointer(
              absorbing: submitted,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableItems.map(_buildMethodChip).toList(),
              ),
            ),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final columns = _columnsForWidth(width);
                final spacing = 12.0;
                final cardWidth = columns == 1
                    ? width
                    : (width - ((columns - 1) * spacing)) / columns;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: widget.targets.map((t) {
                    return SizedBox(
                      width: cardWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _methodMetaCard(t.id, small: columns == 1),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildActionPanel(),
            _buildExplanation(),
            const SizedBox(height: 16),
            _buildControlSheetDock(),
          ],
        ),
      ),
    );
  }
}

class InventoryControlSheetCard extends StatefulWidget {
  final String method;
  final List<_LedgerRowModel> rows;
  final bool submitted;
  final bool compact;
  final bool expanded;
  final Widget Function(List<_LedgerRowModel> rows) tableBuilder;
  final VoidCallback? onToggleExpanded;
  final VoidCallback? onResetZoomHint;
  final ValueChanged<bool>? onInteractionChanged;

  const InventoryControlSheetCard({
    super.key,
    required this.method,
    required this.rows,
    required this.submitted,
    required this.compact,
    required this.expanded,
    required this.tableBuilder,
    this.onToggleExpanded,
    this.onResetZoomHint,
    this.onInteractionChanged,
  });

  @override
  State<InventoryControlSheetCard> createState() =>
      _InventoryControlSheetCardState();
}

class _InventoryControlSheetCardState extends State<InventoryControlSheetCard>
    with SingleTickerProviderStateMixin {
  static const double _sheetMinScale = 0.20;
  static const double _sheetMaxScale = 2.5;
  static const double _sheetDefaultScale = 1.0;

  late final TransformationController _sheetController;
  double _sheetScale = _sheetDefaultScale;

  @override
  void initState() {
    super.initState();
    _sheetController = TransformationController();
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  void _setSheetZoom(double value) {
    final next = value.clamp(_sheetMinScale, _sheetMaxScale).toDouble();
    setState(() {
      _sheetScale = next;
      _sheetController.value = Matrix4.identity()..scale(_sheetScale);
    });
  }

  void _zoomSheet(double factor) {
    _setSheetZoom(_sheetScale * factor);
  }

  void _resetSheetZoom() {
    _setSheetZoom(_sheetDefaultScale);
  }

  Widget _buildZoomBar() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Diminuir',
          onPressed: () => _zoomSheet(0.9),
          icon: const Icon(Icons.remove),
        ),
        Text(
          '${(_sheetScale * 100).round()}%',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        IconButton(
          tooltip: 'Aumentar',
          onPressed: () => _zoomSheet(1.1),
          icon: const Icon(Icons.add),
        ),
        IconButton(
          tooltip: 'Resetar zoom',
          onPressed: _resetSheetZoom,
          icon: const Icon(Icons.center_focus_strong),
        ),
      ],
    );
  }

  Widget _buildCollapsedBar() {
    return Card(
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.black.withOpacity(0.45), width: 1.1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onToggleExpanded,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Ficha de Controle de Estoque',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Expandir',
                onPressed: widget.onToggleExpanded,
                icon: const Icon(Icons.expand_less),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedSheet(BuildContext context) {
    final minWidth = widget.compact ? 920.0 : 1060.0;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final availableHeight = screenHeight - topInset - bottomInset - 24;

    return Card(
      elevation: 14,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.black.withOpacity(0.55), width: 1.2),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: double.infinity,
        height: availableHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black.withOpacity(0.75),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Ficha de Controle de Estoque',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: widget.onToggleExpanded,
                    icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                    label: const Text('Recolher'),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black.withOpacity(0.12),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Método (${widget.method})',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _buildZoomBar(),
                ],
              ),
            ),
            Expanded(
              child: ClipRect(
                child: InteractiveViewer(
                  transformationController: _sheetController,
                  constrained: false,
                  panEnabled: widget.expanded,
                  scaleEnabled: true,
                  minScale: _sheetMinScale,
                  maxScale: _sheetMaxScale,
                  boundaryMargin: const EdgeInsets.all(120),
                  onInteractionStart: (_) {
                    widget.onInteractionChanged?.call(true);
                  },
                  onInteractionEnd: (_) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        widget.onInteractionChanged?.call(false);
                      }
                    });
                  },
                  child: RepaintBoundary(
                    child: SizedBox(
                      width: minWidth,
                      child: widget.tableBuilder(widget.rows),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border(
                    top: BorderSide(
                      color: Colors.black.withOpacity(0.10),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Use os botões de zoom ou arraste com dois dedos.',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.65),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: widget.onToggleExpanded,
                      icon: const Icon(Icons.expand_more, size: 18),
                      label: const Text('Recolher'),
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

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: widget.expanded
          ? _buildExpandedSheet(context)
          : SizedBox(
              height: 78,
              child: _buildCollapsedBar(),
            ),
    );
  }
}

class ExamQuestionWidget extends StatelessWidget {
  final ExamQuestion question;
  final int? selectedIndex;
  final void Function(int index)? onSelected;

  const ExamQuestionWidget({
    super.key,
    required this.question,
    this.selectedIndex,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final headers = question.tableHeaders ?? const <String>[];
    final rows = question.tableRows ?? const <List<String>>[];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool small = constraints.maxWidth < 600;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.subject,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      question.statement,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (headers.isNotEmpty && rows.isNotEmpty)
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  height: small ? 280 : 320,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: small ? 520 : constraints.maxWidth,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Table(
                          border: TableBorder.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          columnWidths: {
                            for (int i = 0; i < headers.length; i++)
                              i: const IntrinsicColumnWidth(),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                              ),
                              children: headers
                                  .map(
                                    (h) => Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        h,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            ...rows.map(
                              (row) => TableRow(
                                children: row
                                    .map(
                                      (cell) => Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          cell,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            ...question.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final letter = String.fromCharCode(65 + index);
              final bool isSelected = selectedIndex == index;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: onSelected == null ? null : () => onSelected!(index),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected ? Colors.teal : Colors.grey.shade300,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 14,
                        backgroundColor: isSelected ? Colors.teal : Colors.grey,
                        child: Text(
                          letter,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      title: Text(
                        option,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            if (question.explanation.trim().isNotEmpty)
              Card(
                color: const Color(0xFFF1F8E9),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    question.explanation,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}