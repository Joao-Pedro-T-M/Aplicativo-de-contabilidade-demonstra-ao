// lib/widgets/drag_match_sum_widget.dart
import 'package:equition/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/course_models.dart';

/// Repaginada do widget de soma/arrastar (versão visual e comportamental alinhada
/// com `drag_match_submit_widget.dart`). Usa overlay para barra de ação, estilos
/// padronizados, top-stripe e comportamento por toque/drag.
/// Mantém compatibilidade das props originais e adiciona `onTotalsChanged`.
/// ---------------------------------------------------------------

// --- Tema / estilos (copiados/compatíveis com o widget anterior) ---
const Color kPrimaryColor = Color(0xFF4CB2B2);
const Color kSecondaryTextColor = Color(0xFF2D6B6B);
const Color kCardColor = Color(0xFFFFFFFF);
const Color kTextColor = Colors.black87;

// Action button standards (compatíveis com LessonPage)
const double kActionButtonHeight = 84.0;
const double kActionButtonFontSize = 16.0;

final ButtonStyle kPrimaryActionStyle = ElevatedButton.styleFrom(
  backgroundColor: kPrimaryColor,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  minimumSize: const Size.fromHeight(kActionButtonHeight),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  textStyle: const TextStyle(fontSize: kActionButtonFontSize, fontWeight: FontWeight.w700),
  elevation: 2,
);

final ButtonStyle kSecondaryActionStyle = OutlinedButton.styleFrom(
  foregroundColor: kPrimaryColor,
  side: BorderSide(color: kPrimaryColor.withOpacity(0.35)),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  minimumSize: const Size.fromHeight(kActionButtonHeight),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  textStyle: const TextStyle(fontSize: kActionButtonFontSize, fontWeight: FontWeight.w700),
);

// Top stripe constants (visual)
const double kTopStripeCollapsedHeight = 4.0;
const double kTopStripeExpandedHeight = 8.0;
const double kTopStripeCollapsedWidthFactor = 0.36;
const double kTopStripeExpandedWidthFactor = 1.0;
const Duration kTopStripeAnimDuration = Duration(milliseconds: 160);

// -----------------------------------------------------------------

typedef TotalsCallback = void Function(Map<String, double> totals);

class DragMatchSumWidget extends StatefulWidget {
  final List<MatchSumItem> items;
  final List<MatchTarget> targets;
  final Map<String, String> correctMap; // itemId -> targetId
  final void Function(bool allCorrect)? onSubmitted;
  final VoidCallback? onSkip; // <-- Adicionado
  final TotalsCallback? onTotalsChanged;
  final Map<String, double>? expectedTargetTotals; // optional validation of sums
  final String? explanation;
  final Map<String, List<String>>? groups;

  const DragMatchSumWidget({
    super.key,
    required this.items,
    required this.targets,
    required this.correctMap,
    this.onSubmitted,
    this.onSkip, // <-- repassar no construtor
    this.onTotalsChanged,
    this.expectedTargetTotals,
    this.explanation,
    this.groups,
  });

  @override
  State<DragMatchSumWidget> createState() => _DragMatchSumWidgetState();
}

class _DragMatchSumWidgetState extends State<DragMatchSumWidget>
    with AutomaticKeepAliveClientMixin {
  late List<MatchSumItem> availableItems;
  late Map<String, List<String>> assignments; // targetId -> [itemIds]
  late Map<String, bool> correctness; // targetId -> all items correct?
  bool submitted = false;
  bool _lockedCorrect = false;
  String? _selectedItemId;
  final GlobalKey _explanationKey = GlobalKey();

  // Overlay
  OverlayEntry? _overlayEntry;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    availableItems = List<MatchSumItem>.from(widget.items);

    // inicializa assignments recursivamente (todos os targets e subs)
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

    // notifica totais iniciais
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

  // -------- Overlay bar (Enviar / Tentar / Pular) similar ao widget anterior --------
  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(builder: (overlayContext) {
      final bool hasAnyAssignment = assignments.values.any((v) => v.isNotEmpty);
      final bool allCorrectAfterSubmit =
          submitted && correctness.isNotEmpty && correctness.values.every((v) => v);

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
      final double bottomInset = media.viewInsets.bottom > 0
          ? media.viewInsets.bottom
          : media.padding.bottom;
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

  // -------- Core interactions: assign / unassign / select --------
  void _assign(String itemId, String targetId) {
    // remove de qualquer target anterior
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
      final item = widget.items.firstWhere((it) => it.id == itemId, orElse: () => MatchSumItem(id: '', label: '', value: 0));
      if (item.id.isNotEmpty) availableItems.add(item);
    } else {
      final removed = assignments[targetId]!.toList();
      for (var rid in removed) {
        final item = widget.items.firstWhere((it) => it.id == rid, orElse: () => MatchSumItem(id: '', label: '', value: 0));
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
      if (_selectedItemId == id) {
        _selectedItemId = null;
      } else {
        _selectedItemId = id;
      }
    });
    _refreshOverlay();
  }

// -------- Totals / groups computation --------
  Map<String, double> _computeTargetSums() {
    final Map<String, double> sums = {};

    for (var entry in assignments.entries) {
      double s = 0.0;
      for (var id in entry.value) {
        final it = widget.items.firstWhere((it) => it.id == id, orElse: () => MatchSumItem(id: '', label: '', value: 0));
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

  // Retorna Map<grupo, List<targetId>> — CORREÇÃO: tipo de valor é List<String>
  Map<String, List<String>> get _defaultGroupsConf {
    return {
      'Ativos': widget.targets
          .where((t) =>
              t.id == 'ac' ||
              t.id == 'anc' ||
              t.id.startsWith('ac') ||
              t.id.startsWith('anc'))
          .map((e) => e.id)
          .toList(),
      'Passivos': widget.targets
          .where((t) =>
              t.id == 'pc' ||
              t.id == 'pnc' ||
              t.id.startsWith('pc') ||
              t.id.startsWith('pnc'))
          .map((e) => e.id)
          .toList(),
      'PL': widget.targets
          .where((t) => t.id == 'pl' || t.id.startsWith('pl'))
          .map((e) => e.id)
          .toList(),
    };
  }

  Map<String, double> _computeGroupSums() {
    final targetSums = _computeTargetSums();
    final Map<String, double> groups = {};
    // força o tipo aqui para evitar inferência errada
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
  final Map<String, List<String>> expected = { for (var id in assignments.keys) id: <String>[] };
  widget.correctMap.forEach((itemId, targetId) {
    // some correctMap entries might point to targets não listados (defensivo)
    if (!expected.containsKey(targetId)) expected[targetId] = <String>[];
    expected[targetId]!.add(itemId);
  });
  return expected;
}
  void _notifyTotals() {
    final totals = _computeTargetSums();
    if (widget.onTotalsChanged != null) widget.onTotalsChanged!(totals);
  }

  // -------- Evaluation / reset / skip (comportamento compatível) --------
void _evaluateAndShow() {
  correctness.clear();
  bool allCorrect = true;

  // expected items per target (conjuntos esperados)
  final expectedPerTarget = _computeExpectedItemsPerTarget();

  // Para cada target que temos em assignments, comparamos o conjunto atribuído
  // com o conjunto esperado. Só é correto se forem conjuntos idênticos.
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

  // Se o usuário passou expectedTargetTotals, também valida as somas (mantém comportamento)
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

  setState(() {
    submitted = true;
    if (allCorrect && !_lockedCorrect) _lockedCorrect = true;
  });

  widget.onSubmitted?.call(allCorrect);
  _notifyTotals();

  // garante overlay esteja presente e o atualiza
  _insertOverlay();
  _refreshOverlay();

  if (!allCorrect) _scrollToExplanation();
}
  void _reset() {
    final wasLocked = _lockedCorrect;

    availableItems = List<MatchSumItem>.from(widget.items);

    final allIds = <String>{};
    void collectIds(List<MatchTarget> ts) {
      for (var t in ts) {
        allIds.add(t.id);
        if (t.subs != null && t.subs!.isNotEmpty) collectIds(t.subs!);
      }
    }

    collectIds(widget.targets);
    assignments = {for (var id in allIds) id: <String>[]};
    correctness.clear();
    _selectedItemId = null;
    submitted = false;
    _lockedCorrect = false;

    setState(() {});
    if (wasLocked && widget.onSubmitted != null) widget.onSubmitted!(true);
    _notifyTotals();
    _refreshOverlay();
  }

void _handleSkip() {
  // sinaliza ao pai que a questão foi 'respondida' mas não correta
  widget.onSubmitted?.call(false);

  // reseta estado interno (mantendo compatibilidade com o reset atual)
  _reset();

  // chama callback do pai se houver; senão usa fallback por Notification (compatível com LessonPage)
  if (widget.onSkip != null) {
    widget.onSkip!();
  } else {
    SkipNextNotification().dispatch(context);
  }
}

  // -------- Scroll to explanation helper --------
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

  // -------- UI helpers: chip, sub-target, etc. (estilizados como no widget anterior) --------
  String _formatValue(double v) {
    if (v % 1 == 0) return v.toInt().toString();
    return v.toStringAsFixed(2);
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
        childWhenDragging: Opacity(opacity: 0.35, child: _chipContainer(item, selected: false, available: available)),
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
          color: selected ? kPrimaryColor : (available ? kPrimaryColor.withOpacity(0.05) : Colors.grey.shade300),
          width: selected ? 1.6 : 1.0,
        ),
        color: selected ? kPrimaryColor.withOpacity(0.10) : (available ? kPrimaryColor.withOpacity(0.35) : Colors.grey.shade50),
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
          onWillAccept: (data) => !submitted,
          onAccept: (data) {
            HapticFeedback.lightImpact();
            _assign(data!, sub.id);
          },
          builder: (context, candidate, rejected) {
final bool isHovering = candidate.isNotEmpty;

// Quando submetido, cor depende somente de isCorrect (verde se correto, laranja se incorreto).
// Quando não submetido, mantém comportamento de hover/normal.
final borderColor = submitted
    ? (isCorrect ? Colors.green.withOpacity(0.6) : Colors.orange.shade400)
    : (isHovering ? kPrimaryColor.withOpacity(0.95) : Colors.grey.shade300);

final fillColor = submitted
    ? (isCorrect ? Colors.green.withOpacity(0.06) : Colors.orange.withOpacity(0.06))
    : (isHovering ? kPrimaryColor.withOpacity(0.10) : Colors.white);

// stripe: mostre sempre quando submitted (agora cobre também o caso de target vazio correto)
final Widget stripe = submitted
    ? Container(height: 4, width: double.infinity, color: isCorrect ? Colors.green : Colors.orange)
    : AnimatedContainer(
        duration: kTopStripeAnimDuration,
        height: isHovering ? kTopStripeExpandedHeight : kTopStripeCollapsedHeight,
        width: double.infinity,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: (isHovering ? kTopStripeExpandedWidthFactor : (_selectedItemId != null ? 0.6 : kTopStripeCollapsedWidthFactor)),
            child: AnimatedContainer(
              duration: kTopStripeAnimDuration,
              height: isHovering ? kTopStripeExpandedHeight : kTopStripeCollapsedHeight,
              decoration: BoxDecoration(
                color: isHovering ? kPrimaryColor.withOpacity(0.95) : (_selectedItemId != null ? kPrimaryColor.withOpacity(0.55) : Colors.transparent),
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
      // substitua a linha do Row/stripe pelo widget stripe acima
      stripe,
                  Row(
                    children: [
                      Expanded(child: Text(sub.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
                      if (submitted)
                        Icon(isCorrect ? Icons.check_circle : Icons.highlight_off,
                            size: 16, color: isCorrect ? Colors.green : Colors.orange),
                      if (!submitted) Icon(Icons.drag_indicator, size: 16, color: isHovering ? kPrimaryColor : Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('Subtotal: ${_formatValue(subtotal)}', style: TextStyle(fontSize: 11, color: Colors.black.withOpacity(0.6))),
                  if (assignedIds.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: assignedIds.map((id) {
                        final it = widget.items.firstWhere((it) => it.id == id);
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
        ),
      ),
    );
  }

Widget _targetCard(MatchTarget t, double width) {
  final assignedIds = assignments[t.id] ?? [];
  final subtotal = _computeTargetSums()[t.id] ?? 0.0;
  final isCorrect = correctness[t.id] ?? false;

  // If has subs, render a parent card with sub boxes inside (handled in build)
  return SizedBox(
    width: width,
    child: GestureDetector(
      onTap: () {
        if (_selectedItemId != null && !submitted) _assign(_selectedItemId!, t.id);
      },
      child: DragTarget<String>(
        onWillAccept: (data) => !submitted,
        onAccept: (data) {
          HapticFeedback.lightImpact();
          _assign(data, t.id);
        },
        builder: (context, candidateData, rejectedData) {
          final isHovering = candidateData.isNotEmpty;

          // Quando submetido, cor depende somente de isCorrect.
          // Quando não submetido, mantém comportamento de hover/normal.
          final borderColor = submitted
              ? (isCorrect ? Colors.green.withOpacity(0.6) : Colors.orange.shade400)
              : (isHovering ? kPrimaryColor.withOpacity(0.95) : Colors.grey.shade300);

          final fillColor = submitted
              ? (isCorrect ? Colors.green.withOpacity(0.06) : Colors.orange.withOpacity(0.06))
              : (isHovering ? kPrimaryColor.withOpacity(0.08) : Colors.white);

          // stripe: mostrado sempre quando submitted; cor depende apenas de isCorrect.
          // caso não submetido, exibe animação de hover como antes.
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
                              : (_selectedItemId != null ? kPrimaryColor.withOpacity(0.55) : Colors.transparent),
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
                // stripe (agora sempre exibida quando submitted; caso contrário mantém animação de hover)
                stripe,
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Text(t.label, style: const TextStyle(fontWeight: FontWeight.w800))),
                    const SizedBox(width: 8),
                    Icon(
                      submitted ? (isCorrect ? Icons.check_circle : Icons.error) : Icons.account_balance,
                      color: submitted ? (isCorrect ? Colors.green : Colors.orange) : Colors.grey.shade600,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Total: ${_formatValue(subtotal)}', style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.7))),
                if (assignedIds.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: assignedIds.map((id) {
                      final it = widget.items.firstWhere((it) => it.id == id);
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
                                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.10), shape: BoxShape.circle),
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
      ),
    ),
  );
}
  // ---------- action button builders (use standardized styles) ----------
  Widget _elevatedAction(String label, VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: kPrimaryActionStyle,
      child: Text(label, style: const TextStyle(fontSize: kActionButtonFontSize, fontWeight: FontWeight.w700)),
    );
  }

  Widget _outlinedAction(String label, VoidCallback? onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: kSecondaryActionStyle,
      child: Text(label, style: const TextStyle(fontSize: kActionButtonFontSize, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildExplanation() {
    final text = widget.explanation?.trim();
    if (!submitted || text == null || text.isEmpty) return const SizedBox.shrink();

    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const Text('Explicação', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: kTextColor)),
          const SizedBox(height: 10),
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            color: kCardColor,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(height: 1, color: kPrimaryColor.withOpacity(0.28)),
                Padding(
                  key: _explanationKey,
                  padding: const EdgeInsets.all(16),
                  child: Text(text, style: const TextStyle(fontSize: 15, color: kTextColor, height: 1.25)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------ Build ------------------
  @override
  Widget build(BuildContext context) {
    super.build(context); // for AutomaticKeepAliveClientMixin
    final double width = MediaQuery.of(context).size.width;
    const double horizontalPadding = 16.0 * 2;
    const double spacing = 12.0;
    final bool oneColumn = width - horizontalPadding < 520;
    final double availableWidth = (width - horizontalPadding) - (oneColumn ? 0.0 : spacing);
    final double itemWidth = oneColumn ? availableWidth : (availableWidth / 2);

    final targetSums = _computeTargetSums();
    final groupSums = _computeGroupSums();
    final double ativos = groupSums['Ativos'] ?? 0.0;
    final double passivos = groupSums['Passivos'] ?? 0.0;
    final double pl = groupSums['PL'] ?? 0.0;
    final double rhs = passivos + pl;
    const double eps = 0.001;
    final bool balanced = (ativos - rhs).abs() <= eps;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Pool de itens
            AbsorbPointer(
              absorbing: submitted,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableItems.map(_buildChip).toList(),
              ),
            ),
            const SizedBox(height: 18),

            // Targets (pai/subs)
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: widget.targets.map((t) {
                if (t.subs != null && t.subs!.isNotEmpty) {
                  final parentSubtotal = targetSums[t.id] ?? 0.0;
                  return SizedBox(
                    width: itemWidth,
                    child: GestureDetector(
                      onTap: () {
                        if (_selectedItemId != null && !submitted) _assign(_selectedItemId!, t.id);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: kCardColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300, width: 1.6),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text(t.label, style: const TextStyle(fontWeight: FontWeight.w800))),
                                const SizedBox(width: 8),
                                Icon(Icons.folder_open, color: Colors.grey.shade600),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Total: ${_formatValue(parentSubtotal)}', style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.7))),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: t.subs!
                                  .map((sub) {
                                    final subWidth = (itemWidth - 24) / (t.subs!.length <= 2 ? 2 : 1.0);
                                    return _buildSubTargetBox(sub, subWidth.clamp(100.0, itemWidth - 20));
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
// Totais (Balanço) — estilo usando AppTheme
Card(
  color: Color(0xFFE0F7FA),
  elevation: 1,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  child: Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // título com destaque na cor primária
        Text(
          'Totais (Balanço)',
          style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primaryColor),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ativos (A)', style: TextStyle(color: AppTheme.secondaryTextColor)),
              Text(
                _formatValue(ativos),
                style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primaryColor),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Passivos (P)', style: TextStyle(color: AppTheme.secondaryTextColor)),
              Text(
                _formatValue(passivos),
                style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primaryColor),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Patrimônio Líquido (PL)', style: TextStyle(color: AppTheme.secondaryTextColor)),
              Text(
                _formatValue(pl),
                style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primaryColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Divider(color: AppTheme.dividerColor.withOpacity(0.25), height: 1),
        const SizedBox(height: 8),
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
                      style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textColor),
                    ),
                    const TextSpan(text: '  '),
                    WidgetSpan(child: SizedBox(width: 6)),
                    TextSpan(
                      text: '(verificação)',
                      style: TextStyle(color: AppTheme.secondaryTextColor, fontSize: 12),
                    ),
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
                      '${_formatValue(ativos)}  =  ${_formatValue(passivos)}  +  ${_formatValue(pl)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: balanced ? AppTheme.successColor : AppTheme.errorColor,
                      ),
                    ),
                  ),
                  if (!balanced) const SizedBox(height: 4),
                  if (!balanced)
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Diferença: ${_formatValue((ativos - rhs).abs())}',
                        style: TextStyle(color: AppTheme.errorColor, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          ],
        )
      ],
    ),
  ),
),

            const SizedBox(height: 12),

            const SizedBox(height: 8),
            // explanation (if any)
            _buildExplanation(),
            SizedBox(height: 120 + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}

// Fallback notification para pular -> próxima questão (compatível com o outro widget)
class SkipNextNotification extends Notification {}