// lib/widgets/drag_match_dre_widget.dart
// Otimização pontual: caching de medições + ValueNotifier para drag
// Mantém design/markup originais (mesmo layout, cores, SizedBox em vez de IntrinsicHeight, Wrap/virtualização)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/course_models.dart';

typedef DRECorrectMap = Map<String, String>; // itemId -> targetId ('deb' ou 'cred')
typedef DREOnSubmitted = void Function(bool allCorrect);
typedef DRETotalsCallback = void Function(double totalDebit, double totalCredit, double result);

class DragMatchDREWidget extends StatefulWidget {
  final List<DREEntry> entries;
  final DRECorrectMap correctMap;
  final DREOnSubmitted? onSubmitted;
  final VoidCallback? onSkip;
  final DRETotalsCallback? onTotalsChanged;
  final String? explanation;

  const DragMatchDREWidget({
    super.key,
    required this.entries,
    required this.correctMap,
    this.onSubmitted,
    this.onSkip,
    this.onTotalsChanged,
    this.explanation,
  });

  factory DragMatchDREWidget.fromQuestion(
    DREQuestion question, {
    DREOnSubmitted? onSubmitted,
    VoidCallback? onSkip,
    DRETotalsCallback? onTotalsChanged,
  }) {
    return DragMatchDREWidget(
      entries: question.entries,
      correctMap: question.correctMap,
      explanation: question.explanation,
      onSubmitted: onSubmitted,
      onSkip: onSkip,
      onTotalsChanged: onTotalsChanged,
    );
  }

  @override
  State<DragMatchDREWidget> createState() => _DragMatchDREWidgetState();
}

class _DragMatchDREWidgetState extends State<DragMatchDREWidget> {
  late List<DREEntry> available;
  final Map<String, List<String>> assignments = {'deb': <String>[], 'cred': <String>[]};
  final Map<String, bool> correctness = {}; // 'deb'/'cred' -> allCorrect?
  final Map<String, bool> itemCorrect = {}; // itemId -> isCorrect
  bool submitted = false;

  // estado para destaque durante drag -> agora via ValueNotifier para evitar rebuilds globais
  final ValueNotifier<bool> _isDragging = ValueNotifier<bool>(false);
  final ValueNotifier<String?> _draggingId = ValueNotifier<String?>(null);

  // seleção por clique (id do item selecionado) — usada para atribuição por clique
  String? _selectedId;

  // largura fixa das colunas de débito/crédito (ajustável)
  static const double _colValueWidth = 96; // largura padrão desktop
  static const double _colValueWidthSmall = 72; // largura para telas pequenas
  static const double _removeColWidth = 40; // largura fixa para o botão X

  // --- caches + lookup O(1)
  final Map<String, DREEntry> _entryById = {};
  double? _cachedUniformWidth;
  double? _cachedUniformHeight;
  double? _lastMeasuredAvailableWidth;
  int? _lastEntriesHash;

  @override
  void initState() {
    super.initState();
    available = List<DREEntry>.from(widget.entries);
    for (var e in widget.entries) _entryById[e.id] = e;
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifyTotals());
  }

  @override
  void didUpdateWidget(covariant DragMatchDREWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // re-cria lookup se entries mudaram e invalida cache de medições
    final h = _entriesHash(widget.entries);
    if (h != _lastEntriesHash) {
      _entryById.clear();
      for (var e in widget.entries) _entryById[e.id] = e;
      _cachedUniformWidth = null;
      _cachedUniformHeight = null;
      _lastEntriesHash = h;
    }
  }

  @override
  void dispose() {
    _isDragging.dispose();
    _draggingId.dispose();
    super.dispose();
  }

  int _entriesHash(List<DREEntry> list) {
    int h = list.length;
    for (var e in list) {
      h = h * 31 + e.id.hashCode;
      h = h * 13 + e.label.hashCode;
      h = h * 7 + e.value.hashCode;
    }
    return h;
  }

  void _assign(String itemId, String targetId) {
    for (var t in assignments.keys) assignments[t]!.remove(itemId);
    assignments[targetId]!.add(itemId);
    available.removeWhere((e) => e.id == itemId);
    if (!submitted) setState(() {}); // necessário pois lista de disponíveis mudou
    HapticFeedback.lightImpact();
    _notifyTotals();
  }

  void _unassign(String itemId) {
    for (var t in assignments.keys) assignments[t]!.remove(itemId);
    final it = _entryById[itemId] ?? DREEntry(id: '', label: '', value: 0, isDebit: true);
    if (it.id.isNotEmpty) {
      available.add(it);
    }
    if (!submitted) setState(() {});
    _notifyTotals();
  }

  Map<String, double> _computeSums() {
    double deb = 0.0;
    double cred = 0.0;
    for (var id in assignments['deb']!) {
      final it = _entryById[id] ?? DREEntry(id: '', label: '', value: 0, isDebit: true);
      deb += it.value;
    }
    for (var id in assignments['cred']!) {
      final it = _entryById[id] ?? DREEntry(id: '', label: '', value: 0, isDebit: false);
      cred += it.value;
    }
    return {'deb': deb, 'cred': cred};
  }

  void _notifyTotals() {
    final s = _computeSums();
    final result = (s['cred'] ?? 0.0) - (s['deb'] ?? 0.0);
    widget.onTotalsChanged?.call(s['deb']!, s['cred']!, result);
  }

  void _evaluate() {
    correctness.clear();
    itemCorrect.clear();
    bool allCorrect = true;

    final expected = {'deb': <String>[], 'cred': <String>[]};
    widget.correctMap.forEach((k, v) {
      if (!expected.containsKey(v)) expected[v] = <String>[];
      expected[v]!.add(k);
    });

    for (var t in ['deb', 'cred']) {
      final assignedSet = <String>{...assignments[t]!};
      final expectedSet = <String>{...expected[t]!};
      final ok = assignedSet.length == expectedSet.length && assignedSet.difference(expectedSet).isEmpty;
      correctness[t] = ok;
      if (!ok) allCorrect = false;
    }

    for (var t in ['deb', 'cred']) {
      for (var id in assignments[t]!) {
        final expectedTarget = widget.correctMap[id];
        itemCorrect[id] = (expectedTarget == t);
      }
    }

    setState(() {
      submitted = true;
    });

    widget.onSubmitted?.call(allCorrect);
    _notifyTotals();
  }

  void _reset() {
    available = List<DREEntry>.from(widget.entries);
    assignments['deb'] = [];
    assignments['cred'] = [];
    correctness.clear();
    itemCorrect.clear();
    submitted = false;
    _selectedId = null;
    setState(() {});
    _notifyTotals();
  }

  String _format(double v) {
    if (v % 1 == 0) return v.toInt().toString();
    return v.toStringAsFixed(2);
  }

  // --- helper: calcula largura necessária do maior chip (baseado em label + value)
  // Mantive sua implementação original — mas agora com caching por availableWidth + entriesHash
  double _calcUniformChipMaxWidth(double availableWidth, bool isWide) {
    final labelStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: isWide ? 14.0 : 13.0);
    final valueStyle = TextStyle(fontWeight: FontWeight.w800, fontSize: isWide ? 14.0 : 13.0);

    double maxNeeded = 0.0;
    for (final e in widget.entries) {
      final tpLabel = TextPainter(
        text: TextSpan(text: e.label, style: labelStyle),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();

      final valueText = _format(e.value);
      final tpValue = TextPainter(
        text: TextSpan(text: valueText, style: valueStyle),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();

      const horizontalPadding = 10.0 * 2;
      const innerGap = 8.0;
      const buffer = 20.0;

      final needed = tpLabel.width + innerGap + tpValue.width + horizontalPadding + buffer;
      if (needed > maxNeeded) maxNeeded = needed;
    }

    final limit = isWide ? 260.0 : (availableWidth * 0.48);
    final result = maxNeeded.clamp(64.0, limit);
    return result;
  }

  double _calcUniformChipMaxHeight(BuildContext context, double finalWidth, bool isWide) {
    final defaultStyle = DefaultTextStyle.of(context).style;
    final textScale = MediaQuery.textScaleFactorOf(context);

    final labelStyle = defaultStyle.merge(TextStyle(fontWeight: FontWeight.w600, fontSize: isWide ? 14.0 : 13.0));
    final valueStyle = defaultStyle.merge(TextStyle(fontWeight: FontWeight.w800, fontSize: isWide ? 14.0 : 13.0));

    const horizontalPadding = 10.0 * 2;
    const verticalPadding = 6.0 * 2;
    const innerGap = 8.0;
    const verticalGap = 2.0;
    const buffer = 6.0;

    double maxHeight = 0.0;

    for (final e in widget.entries) {
      final valueText = _format(e.value);

      final tpValue = TextPainter(
        text: TextSpan(text: valueText, style: valueStyle),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        textScaleFactor: textScale,
      )..layout();

      double labelMaxWidth;
      if (isWide) {
        labelMaxWidth = finalWidth - horizontalPadding - tpValue.width - innerGap;
      } else {
        labelMaxWidth = finalWidth - horizontalPadding;
      }
      if (labelMaxWidth < 20) labelMaxWidth = 20;

      final tpLabel = TextPainter(
        text: TextSpan(text: e.label, style: labelStyle),
        textDirection: TextDirection.ltr,
        textScaleFactor: textScale,
      )..layout(maxWidth: labelMaxWidth);

      double contentHeight;
      if (isWide) {
        contentHeight = tpLabel.height > tpValue.height ? tpLabel.height : tpValue.height;
      } else {
        contentHeight = tpLabel.height + verticalGap + tpValue.height;
      }

      final totalHeight = contentHeight + verticalPadding + buffer;
      if (totalHeight > maxHeight) maxHeight = totalHeight;
    }

    final minH = isWide ? 40.0 : 44.0;
    final result = maxHeight.clamp(minH, double.infinity);
    return result.ceilToDouble();
  }

  // --- value chip: usa caching das medições caras e ValueNotifier para drag state
  // agora recebe entriesHash (calculado uma vez por build) para evitar recalcular repetidamente
  Widget _valueChip(DREEntry e, int entriesHash) {
    final valueText = _format(e.value);

    return LayoutBuilder(builder: (context, constraints) {
      final availableWidth = constraints.maxWidth == double.infinity ? MediaQuery.of(context).size.width : constraints.maxWidth;
      final isWide = availableWidth > 520;

      // --- caching: calcula apenas se necessário ---
      if (_cachedUniformWidth == null ||
          _cachedUniformHeight == null ||
          _lastMeasuredAvailableWidth == null ||
          _lastMeasuredAvailableWidth! != availableWidth ||
          _lastEntriesHash == null ||
          _lastEntriesHash! != entriesHash) {
        // medição cara apenas quando precisa (ou quando largura/entries mudam)
        _cachedUniformWidth = _calcUniformChipMaxWidth(availableWidth, isWide);
        final finalWidth = _cachedUniformWidth! > availableWidth ? availableWidth : _cachedUniformWidth!;
        _cachedUniformHeight = _calcUniformChipMaxHeight(context, finalWidth, isWide);
        _lastMeasuredAvailableWidth = availableWidth;
        _lastEntriesHash = entriesHash;
      }

      final uniformWidth = _cachedUniformWidth!;
      final finalWidth = uniformWidth > availableWidth ? availableWidth : uniformWidth;
      final uniformHeight = _cachedUniformHeight!;
      final uniformHeightCeiled = uniformHeight.ceilToDouble();
      final safeHeight = uniformHeightCeiled + 2.0;

      // --- build uma versão estática pesada do chip (será passada como `child` para ValueListenableBuilder)
      final bool isSelected = _selectedId == e.id;
      final Widget heavyChip = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // alterna seleção ao clicar
          setState(() {
            if (_selectedId == e.id) {
              _selectedId = null;
            } else {
              _selectedId = e.id;
            }
          });
        },
        child: RepaintBoundary(
          child: Draggable<String>(
            data: e.id,
            feedback: Material(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                width: finalWidth,
                height: safeHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber.shade400, width: 2),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 4))],
                ),
                child: _chipContent(e.label, valueText, isWide),
              ),
            ),
            onDragStarted: () {
              // limpa seleção ao arrastar para evitar conflito visual
              if (_selectedId != null) {
                setState(() {
                  _selectedId = null;
                });
              }
              _isDragging.value = true;
              _draggingId.value = e.id;
            },
            onDragEnd: (_) {
              _isDragging.value = false;
              _draggingId.value = null;
            },
            onDraggableCanceled: (_, __) {
              _isDragging.value = false;
              _draggingId.value = null;
            },
            onDragCompleted: () {
              _isDragging.value = false;
              _draggingId.value = null;
            },
            // childWhenDragging e child são estáticos (evitamos depender de isThisDragging aqui)
            childWhenDragging: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: finalWidth,
              height: safeHeight,
              constraints: BoxConstraints(minWidth: 64, maxWidth: finalWidth),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white.withOpacity(0.35),
              ),
              child: _chipContent(e.label, valueText, isWide),
            ),
            child: Container(
              width: finalWidth,
              height: safeHeight,
              constraints: BoxConstraints(minWidth: 64, maxWidth: finalWidth),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? Colors.amber.shade400 : Colors.grey.shade300, width: isSelected ? 2.0 : 1.0),
                color: isSelected ? Colors.amber.shade50 : Colors.white,
              ),
              child: _chipContent(e.label, valueText, isWide),
            ),
          ),
        ),
      );

      // Usamos ValueListenableBuilder **com child** para evitar reconstruir o heavyChip quando _draggingId mudar.
      return ValueListenableBuilder<String?>(
        valueListenable: _draggingId,
        child: heavyChip,
        builder: (context, draggingId, child) {
          final isThisDragging = draggingId == e.id && _isDragging.value;
          if (isThisDragging) {
            // wrapper leve que aplica destaque visual (não reconstrói o heavyChip)
            return Container(
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 4))],
                borderRadius: BorderRadius.circular(22),
              ),
              child: child,
            );
          }
          return child!;
        },
      );
    });
  }

  // mantive exatamente seu _chipContent original (sem alteração visual)
  Widget _chipContent(String label, String valueText, bool isWide) {
    final labelStyle = const TextStyle(fontWeight: FontWeight.w600);
    final valueStyle = const TextStyle(fontWeight: FontWeight.w800);

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.visible,
              softWrap: true,
              style: labelStyle,
            ),
          ),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 30),
            child: Text(
              valueText,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.right,
              style: valueStyle,
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.visible,
              softWrap: true,
              style: labelStyle,
            ),
          ),
          const SizedBox(height: 4),
          Text(valueText, style: valueStyle),
        ],
      );
    }
  }

  Widget _buildTableHeader(bool small) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: small ? 6 : 8, horizontal: 8),
      color: Colors.grey.shade50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // centraliza verticalmente
        children: [
          Expanded(child: Text('Conta', style: TextStyle(fontWeight: FontWeight.w700, fontSize: small ? 12 : 14))),
          SizedBox(width: small ? 8 : 16),
          SizedBox(
            width: small ? _colValueWidthSmall : _colValueWidth,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('Débito', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w700, fontSize: small ? 12 : 13)),
            ),
          ),
          SizedBox(width: small ? 8 : 16),
          SizedBox(
            width: small ? _colValueWidthSmall : _colValueWidth,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('Crédito', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w700, fontSize: small ? 12 : 13)),
            ),
          ),
          SizedBox(width: small ? 8 : 12),
          SizedBox(width: _removeColWidth),
        ],
      ),
    );
  }

  Widget _typeBadge(bool isDeb, bool isCred) {
    if (!isDeb && !isCred) return const SizedBox.shrink();
    final text = isDeb ? 'D' : 'C';
    final color = isDeb ? Colors.red.shade300 : Colors.blue.shade300; // cores pedidas
    return Container(
      width: 32,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  // targets continuam visuais iguais; usamos ValueListenableBuilder para highlight sem setState global
  // agora também aceitam atribuição por clique: se um item estiver selecionado (_selectedId), clicar aqui atribui.
  Widget _buildTargetBox(String id, String label, bool small) {
    final baseColor = id == 'deb' ? Colors.red.shade100 : Colors.blue.shade100;

    return Expanded(
      child: ValueListenableBuilder<bool>(
        valueListenable: _isDragging,
        builder: (context, isDragging, _) {
          // Leitura direta de _selectedId aqui; setState() é chamado quando selecionamos/desselcionamos
          final bool hasSelection = _selectedId != null && !submitted;

          return GestureDetector(
            onTap: () {
              if (hasSelection) {
                // atribui o item selecionado a este target
                final selected = _selectedId!;
                _assign(selected, id);
                // limpa seleção
                setState(() {
                  _selectedId = null;
                });
              }
            },
            child: DragTarget<String>(
              onWillAccept: (data) => !submitted,
              onAccept: (data) => _assign(data, id),
              builder: (context, candidateData, rejectedData) {
                final hovering = candidateData.isNotEmpty;
                final highlight = isDragging || hovering || hasSelection;

                final Color debitHighlight = Colors.amber.shade400;
                final Color creditHighlight = Colors.cyan.shade400;
                final Color chosenHighlight = id == 'deb' ? debitHighlight : creditHighlight;

                final sum = _computeSums()[id] ?? 0.0;
                final isCorrect = correctness[id] ?? false;

                final borderColor = submitted
                    ? (isCorrect ? Colors.green.withOpacity(0.6) : Colors.orange.shade400)
                    : (highlight ? chosenHighlight : (id == 'deb' ? Colors.red.shade200 : Colors.blue.shade200));

                final boxShadow = highlight
                    ? [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 6))]
                    : null;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
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
                          Expanded(child: Text(label, style: TextStyle(fontWeight: FontWeight.w800, color: id == 'deb' ? Colors.red.shade800 : Colors.blue.shade800))),
                          Text(_format(sum), style: TextStyle(fontWeight: FontWeight.w800, color: id == 'deb' ? Colors.red.shade800 : Colors.blue.shade800)),
                        ],
                      ),
const SizedBox(height: 8),

// torna a área inferior flexível (evita overflow quando o box tiver pouca altura)
Flexible(
  child: Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    alignment: Alignment.center,
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        assignments[id]!.isEmpty ? 'Arraste aqui (valores)' : '${assignments[id]!.length} item(s) atribuído(s)',
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
          );
        },
      ),
    );
  }

  Widget _buildAssignmentsTable(bool small) {
    final rows = widget.entries.map((e) {
      final inDeb = assignments['deb']!.contains(e.id);
      final inCred = assignments['cred']!.contains(e.id);
      final assigned = inDeb || inCred;
      final isCorrect = itemCorrect[e.id] ?? false;
      return {
        'entry': e,
        'inDeb': inDeb,
        'inCred': inCred,
        'assigned': assigned,
        'isCorrect': isCorrect,
      };
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text('Conta — Débito / Crédito (atribuições)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(6)),
          child: Column(
            children: [
              _buildTableHeader(small),
              const Divider(height: 1),
              ...rows.map((r) {
                final DREEntry e = r['entry'] as DREEntry;
                final inDeb = r['inDeb'] as bool;
                final inCred = r['inCred'] as bool;
                final assigned = r['assigned'] as bool;
                final isCorrect = r['isCorrect'] as bool;

                final bgColor = submitted
                    ? (assigned ? (isCorrect ? Colors.green.shade50 : Colors.red.shade50) : Colors.transparent)
                    : Colors.transparent;

                return Container(
                  color: bgColor,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center, // centraliza verticalmente a linha
                    children: [
                      Expanded(
                        child: Text(e.label, style: TextStyle(fontSize: small ? 12 : 13), softWrap: true),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: small ? _colValueWidthSmall : _colValueWidth,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(inDeb ? _format(e.value) : '', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: small ? _colValueWidthSmall : _colValueWidth,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(inCred ? _format(e.value) : '', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                      SizedBox(
                        width: _removeColWidth,
                        child: assigned
                            ? Center(
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50, // fundo da bolinha
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    splashRadius: 18,
                                    padding: const EdgeInsets.all(6),
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.close, size: 16, color: Colors.red),
                                    onPressed: () {
                                      _unassign(e.id);
                                      setState(() {}); // atualiza UI da tabela
                                    },
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      )
                    ],
                  ),
                );
              }).toList()
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExplanationTable(bool small) {
    if (!submitted || (widget.explanation == null || widget.explanation!.trim().isEmpty)) return const SizedBox.shrink();

    final lines = widget.explanation!.trim().split('\n').where((l) => l.trim().isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text('Explicação', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(6)),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey.shade50,
                child: Row(children: [Expanded(child: Text('Conta', style: TextStyle(fontWeight: FontWeight.w700))), SizedBox(width: 90, child: Text('Valor', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w700)))]),
              ),
              ...lines.map((l) {
                final parts = l.split(';');
                final conta = parts.isNotEmpty ? parts[0] : l;
                final valor = parts.length >= 2 ? parts[1] : '';
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
                  child: Row(children: [Expanded(child: Text(conta, style: TextStyle(fontSize: small ? 12 : 13), softWrap: true)), SizedBox(width: 90, child: Text(valor, textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w600)))]),
                );
              }).toList()
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final small = width < 520;

    // calcula entriesHash UMA vez por build (evita recálculos no _valueChip)
    final entriesHash = _entriesHash(widget.entries);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (available.isEmpty)
              Center(child: Text('Nenhum valor disponível', style: TextStyle(color: Colors.grey.shade600)))
            else
              // virtualização simples: se houver muitas entradas, usamos ListView.builder com altura fixa
              if (available.length <= 20)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: available.map((e) => _valueChip(e, entriesHash)).toList(),
                )
              else
                SizedBox(
                  height: 260,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: available.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: _valueChip(available[i], entriesHash),
                    ),
                  ),
                ),

            const SizedBox(height: 14),
            const SizedBox(height: 12),

            // substituí IntrinsicHeight por SizedBox usando cache de altura (evita multiple layout passes)
Builder(builder: (context) {
  // altura desejada baseada no cache de chips
  final double desired = (_cachedUniformHeight != null) ? (_cachedUniformHeight! + 40) : 140.0;

  // evita pedir mais espaço do que a tela (deixamos uma folga para outros elementos)
  final double screenH = MediaQuery.of(context).size.height;
  // quanto da tela você quer reservar para o restante da UI (header/buttons/etc). Ajuste se precisar.
  const double reservedForOther = 320.0;
  final double maxAllowed = (screenH - reservedForOther).clamp(80.0, double.infinity);

  // altura final: entre 80 e maxAllowed
  final double targetHeight = desired.clamp(80.0, maxAllowed);

  return SizedBox(
    height: targetHeight,
    child: Row(children: [
      _buildTargetBox('deb', 'Débito', small),
      const SizedBox(width: 12),
      _buildTargetBox('cred', 'Crédito', small),
    ]),
  );
}),

            const SizedBox(height: 12),

            _buildAssignmentsTable(small),

            const SizedBox(height: 12),

            Builder(builder: (context) {
              final s = _computeSums();
              final result = (s['cred'] ?? 0) - (s['deb'] ?? 0);
              final isProfit = result > 0;
              return Card(
                color: isProfit ? Colors.green.shade50 : Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Totais', style: TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 6), Text('Débito: ${_format(s['deb'] ?? 0)}'), Text('Crédito: ${_format(s['cred'] ?? 0)}')]),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(isProfit ? 'Lucro' : 'Prejuízo', style: TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 6), Text(_format(result), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800))]),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 12),

            Row(children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: assignments.values.any((l) => l.isNotEmpty) ? _evaluate : null,
                  child: const Text('Enviar'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: _reset,
                  child: const Text('Resetar'),
                ),
              ),
            ]),

            _buildExplanationTable(small),

            const SizedBox(height: 96),
          ],
        ),
      ),
    );
  }
}