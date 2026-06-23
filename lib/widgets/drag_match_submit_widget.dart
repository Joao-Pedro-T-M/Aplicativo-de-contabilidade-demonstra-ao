// lib/widgets/drag_match_submit_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/course_models.dart';

/// Fallbacks locais para as constantes de tema usadas no app.
const Color kPrimaryColor = Color(0xFF4CB2B2);
const Color kSecondaryTextColor = Color(0xFF2D6B6B);
const Color kCardColor = Colors.white;
const Color kTextColor = Colors.black87;

// --- ACTION BUTTON STANDARDS (padronizados para combinar com LessonPage) ---
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

// --- TOP STRIPE (faixa superior do card) ---
const double kTopStripeCollapsedHeight = 4.0;
const double kTopStripeExpandedHeight = 8.0;
const double kTopStripeCollapsedWidthFactor = 0.36; // 36% quando inativa
const double kTopStripeExpandedWidthFactor = 1.0;   // 100% quando ativa
const Duration kTopStripeAnimDuration = Duration(milliseconds: 160);

// --------------------------------------------------------------------------------

/// Notification usada como fallback para indicar "pular -> próxima questão".
/// Pais podem capturar essa notification via NotificationListener<SkipNextNotification>.
class SkipNextNotification extends Notification {}

class DragMatchSubmitWidget extends StatefulWidget {
  final List<String> items;
  final List<MatchTarget> targets;
  final Map<String, String> correctMap;
  final void Function(bool allCorrect)? onSubmitted;
  final VoidCallback? onSkip; // pai pode passar comportamento de pular
  final String? explanation;
  final bool preserveCorrectAfterReset;

  const DragMatchSubmitWidget({
    super.key,
    required this.items,
    required this.targets,
    required this.correctMap,
    this.onSubmitted,
    this.onSkip,
    this.explanation,
    this.preserveCorrectAfterReset = true,
  });

  @override
  State<DragMatchSubmitWidget> createState() => _DragMatchSubmitWidgetState();
}

class _DragMatchSubmitWidgetState extends State<DragMatchSubmitWidget>
    with AutomaticKeepAliveClientMixin {
  late List<String> availableItems;
  late Map<String, String?> assignments;
  late Map<String, bool> correctness;

  bool submitted = false;
  bool _lockedCorrect = false;
  bool showExplanationAfterSubmit = true;
  String? _selectedItem;

  final GlobalKey _explanationKey = GlobalKey(); // para ensureVisible

  // Overlay
  OverlayEntry? _overlayEntry;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    availableItems = List<String>.from(widget.items);
    assignments = {for (var t in widget.targets) t.id: null};
    correctness = {};

    // Inserir o overlay após o primeiro frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _insertOverlay());
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(builder: (overlayContext) {
      final bool hasAnyAssignment = assignments.values.any((v) => v != null);
      final bool allCorrectAfterSubmit =
          submitted && correctness.isNotEmpty && correctness.values.every((v) => v);

      // SE ACERTOU TUDO → não mostrar nada
      // O LessonPage já vai mostrar o botão "Próxima"
      if (allCorrectAfterSubmit) {
        return const SizedBox.shrink();
      }

      // Barra só aparece quando:
      // - existe pelo menos um item colocado
      // - ou já foi enviado e ainda não acertou tudo
      final bool showBar = hasAnyAssignment || submitted;

      if (!showBar) {
        return const SizedBox.shrink();
      }

      Widget left;
      Widget right;

      if (!submitted) {
        left = _elevatedAction(
          'Enviar',
          hasAnyAssignment ? _evaluateAndShow : null,
        );
        right = _outlinedAction('Tentar de novo', _reset);
      } else {
        left = _outlinedAction('Tentar de novo', _reset);
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

  // --- Updated: Handler para "Pular" com fallback robusto ---
  void _handleSkip() {
    // marca a questão como "respondida" mas não correta
    widget.onSubmitted?.call(false);

    // reseta estado interno
    _reset();

    // usa o comportamento do LessonPage
    if (widget.onSkip != null) {
      widget.onSkip!();
    } else {
      SkipNextNotification().dispatch(context);
    }
  }

  // --- Interaction methods (com chamadas para atualizar overlay) ---
  void _selectItem(String item) {
    if (submitted) return;
    setState(() {
      _selectedItem = item;
    });
    _refreshOverlay();
  }

  void _assign(String item, String targetId) {
    // Faz as mutações dentro de setState para garantir rebuild consistente
    setState(() {
      final prevEntry = assignments.entries.firstWhere(
        (e) => e.value == item,
        orElse: () => const MapEntry('', null),
      );

      if (prevEntry.key.isNotEmpty) {
        assignments[prevEntry.key] = null;
      }

      final prev = assignments[targetId];
      if (prev != null) {
        availableItems.add(prev);
      }

      assignments[targetId] = item;
      availableItems.remove(item);

      if (_selectedItem == item) {
        _selectedItem = null;
      }
    });

    _refreshOverlay();
  }

  void _unassignFromTarget(String targetId) {
    setState(() {
      final prev = assignments[targetId];
      if (prev != null) {
        availableItems.add(prev);
        assignments[targetId] = null;

        if (_selectedItem == prev) {
          _selectedItem = null;
        }
      }
    });

    _refreshOverlay();
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

  void _evaluateAndShow() {
    correctness.clear();
    bool allCorrect = true;

    for (final t in widget.targets) {
      final assigned = assignments[t.id];
      final expectedTargetId = widget.correctMap[assigned ?? ''];
      final ok = assigned != null && expectedTargetId == t.id;
      correctness[t.id] = ok;
      if (!ok) allCorrect = false;
    }

    setState(() {
      submitted = true;
      showExplanationAfterSubmit = !allCorrect;
      if (allCorrect && widget.preserveCorrectAfterReset) {
        _lockedCorrect = true;
      }
    });
    widget.onSubmitted?.call(allCorrect);

    _refreshOverlay();

    if (!allCorrect && showExplanationAfterSubmit) {
      _scrollToExplanation();
    }
  }

  void _reset() {
    final wasLocked = _lockedCorrect;

    setState(() {
      availableItems = List<String>.from(widget.items);
      assignments = {for (var t in widget.targets) t.id: null};
      correctness.clear();
      _selectedItem = null;
      submitted = false;
      _lockedCorrect = false;
      showExplanationAfterSubmit = true;
    });
    _refreshOverlay();

    if (wasLocked && widget.preserveCorrectAfterReset) {
      widget.onSubmitted?.call(true);
    }
  }

  // --- UI helper methods (mantidos) ---
  Color _targetBorderColor(String targetId, String? assigned) {
    if (!submitted) {
      if (_selectedItem != null) return kPrimaryColor.withOpacity(0.35);
      return Colors.grey.shade300;
    }

    if (assigned == null) return Colors.red.shade300;
    final isCorrect = correctness[targetId] ?? false;
    return isCorrect ? Colors.green.withOpacity(0.75) : Colors.red.withOpacity(0.75);
  }

  Color _targetFillColor(String targetId, String? assigned) {
    if (!submitted) {
      if (_selectedItem != null) return kPrimaryColor.withOpacity(0.06);
      return assigned != null ? kPrimaryColor.withOpacity(0.45) : kPrimaryColor.withOpacity(0.15);
    }

    final isCorrect = correctness[targetId] ?? false;
    if (assigned == null) return Colors.red.withOpacity(0.06);
    return isCorrect ? Colors.green.withOpacity(0.10) : Colors.red.withOpacity(0.10);
  }

  Color _topStripeColor(String targetId, String? assigned) {
    if (!submitted || assigned == null) return Colors.transparent;
    final isCorrect = correctness[targetId] ?? false;
    return isCorrect ? Colors.green : Colors.red;
  }

  Widget _buildChip(String text) {
    final bool selected = _selectedItem == text;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? kPrimaryColor : kPrimaryColor.withOpacity(0.05),
          width: selected ? 1.6 : 1.0,
        ),
        color: selected ? kPrimaryColor.withOpacity(0.10) : kPrimaryColor.withOpacity(0.35),
        boxShadow: [
          BoxShadow(
            color: selected ? kPrimaryColor.withOpacity(0.12) : Colors.black.withOpacity(0.02),
            blurRadius: selected ? 8 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          color: selected ? kPrimaryColor : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDraggableChip(String item) {
    return GestureDetector(
      onTap: () => _selectItem(item),
      child: Draggable<String>(
        data: item,
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
            child: Text(
              item,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.35,
          child: _buildChip(item),
        ),
        child: _buildChip(item),
      ),
    );
  }

  Widget _buildTargetCard(MatchTarget t) {
    final assigned = assignments[t.id];
    final isCorrect = correctness[t.id] ?? false;

    final borderColor = _targetBorderColor(t.id, assigned);
    final fillColor = _targetFillColor(t.id, assigned);
    final stripeColor = _topStripeColor(t.id, assigned);

    return DragTarget<String>(
      onWillAccept: (data) => !submitted,
      onAccept: (data) {
        HapticFeedback.lightImpact();
        _assign(data, t.id);
      },
      builder: (context, candidateData, rejectedData) {
        final bool isHovering = candidateData.isNotEmpty;
        final bool hasSelectedItem = _selectedItem != null && !submitted;
        final bool highlight = isHovering || hasSelectedItem;

        return GestureDetector(
          onTap: () {
            if (!submitted && _selectedItem != null) {
              HapticFeedback.lightImpact();
              _assign(_selectedItem!, t.id);
            }
          },
          onLongPress: () {
            if (!submitted) _unassignFromTarget(t.id);
          },
          child: AnimatedScale(
            duration: const Duration(milliseconds: 140),
            scale: isHovering ? 1.02 : 1.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: double.infinity,
              // OBS: removemos o padding horizontal daqui para permitir que a stripe ocupe 100% do card
              decoration: BoxDecoration(
                color: submitted ? fillColor : (highlight ? kPrimaryColor.withOpacity(0.10) : fillColor),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: submitted ? borderColor : (isHovering ? kPrimaryColor.withOpacity(0.95) : borderColor),
                  width: submitted ? 2.0 : (isHovering ? 2.4 : (hasSelectedItem ? 1.8 : 1.4)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: submitted && assigned != null
                        ? (isCorrect ? Colors.green.withOpacity(0.12) : Colors.red.withOpacity(0.12))
                        : isHovering
                            ? kPrimaryColor.withOpacity(0.22)
                            : hasSelectedItem
                                ? kPrimaryColor.withOpacity(0.10)
                                : Colors.black.withOpacity(0.02),
                    blurRadius: isHovering ? 14 : (hasSelectedItem ? 10 : 6),
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // stripe agora fora do padding — ocupa toda a largura do card naturalmente
                  if (submitted && assigned != null)
                    Container(
                      height: 4,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: stripeColor,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                    )
                  else
                    AnimatedContainer(
                      duration: kTopStripeAnimDuration,
                      height: isHovering ? kTopStripeExpandedHeight : kTopStripeCollapsedHeight,
                      width: double.infinity,
                      curve: Curves.easeInOut,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: (isHovering
                              ? kTopStripeExpandedWidthFactor
                              : (hasSelectedItem ? 0.6 : kTopStripeCollapsedWidthFactor)),
                          child: AnimatedContainer(
                            duration: kTopStripeAnimDuration,
                            height: isHovering ? kTopStripeExpandedHeight : kTopStripeCollapsedHeight,
                            decoration: BoxDecoration(
                              color: isHovering
                                  ? kPrimaryColor.withOpacity(0.95)
                                  : (hasSelectedItem ? kPrimaryColor.withOpacity(0.55) : Colors.transparent),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // conteúdo do card — agora com padding horizontal aplicado aqui
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                t.label,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: submitted && assigned != null
                                      ? (isCorrect ? Colors.green : Colors.red)
                                      : (isHovering ? kPrimaryColor : Colors.black87),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (submitted && assigned != null)
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 160),
                                child: isCorrect
                                    ? const Icon(Icons.check_circle, key: ValueKey('ok'), color: Colors.green, size: 16)
                                    : const Icon(Icons.highlight_off, key: ValueKey('no'), color: Colors.red, size: 16),
                              )
                            else
                              Icon(Icons.drag_indicator, size: 16, color: isHovering ? kPrimaryColor : Colors.grey),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // resto do conteúdo (assigned block / hint block) — mantenha como estava
                        if (assigned != null)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: submitted
                                  ? (isCorrect ? Colors.green.withOpacity(0.08) : Colors.red.withOpacity(0.08))
                                  : kPrimaryColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: submitted
                                    ? (isCorrect ? Colors.green.withOpacity(0.20) : Colors.red.withOpacity(0.20))
                                    : kPrimaryColor.withOpacity(0.30),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    assigned,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      height: 1.15,
                                      color: submitted ? (isCorrect ? Colors.green : Colors.red) : kPrimaryColor,
                                    ),
                                  ),
                                ),
                                if (!submitted) ...[
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () {
                                      _unassignFromTarget(t.id);
                                      setState(() {});
                                      _refreshOverlay();
                                    },
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
                              ],
                            ),
                          )
                        else
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: hasSelectedItem ? kPrimaryColor.withOpacity(0.05) : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: hasSelectedItem ? kPrimaryColor.withOpacity(0.20) : Colors.grey.shade200,
                              ),
                            ),
                            child: Text(
                              hasSelectedItem ? 'Toque no alvo para posicionar o item selecionado' : 'Toque ou arraste um item para cá',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: hasSelectedItem ? kPrimaryColor.withOpacity(0.95) : Colors.black54,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- Mantive o construtor opcional de bottom nav (se quiser reutilizar) ---
  Widget _buildBottomNav({required Widget left, required Widget right}) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, -4)),
        ],
        border: Border(top: BorderSide(color: kPrimaryColor.withOpacity(0.03))),
      ),
      child: Row(
        children: [
          Expanded(child: left),
          const SizedBox(width: 12),
          Expanded(child: right),
        ],
      ),
    );
  }

  // Updated: use the standardized styles instead of fixed SizedBox wrappers
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
    if (!submitted || text == null || text.isEmpty || !showExplanationAfterSubmit) {
      return const SizedBox.shrink();
    }

    // Painel de explicação com mesmo estilo do LessonPage (flat panel)
    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const Text(
            'Explicação',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: kTextColor,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            color: kCardColor,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 1,
                  color: kPrimaryColor.withOpacity(0.28),
                ),
                Padding(
                  key: _explanationKey,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 15,
                      color: kTextColor,
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Build: agora sem navbar na árvore; overlay cuida da barra ---
  @override
  Widget build(BuildContext context) {
    super.build(context); // necessário para AutomaticKeepAliveClientMixin
    final double width = MediaQuery.of(context).size.width;

    // ajustar conforme o padding horizontal do pai (Padding horizontal: 16 + 16)
    const double horizontalPadding = 16.0 * 2;

    // espaço entre colunas (Wrap) — já usado abaixo
    const double spacing = 12.0;

    // breakpoint para alternar 1 coluna / 2 colunas (ajuste conforme desejar)
    final bool oneColumn = width - horizontalPadding < 380;

    // largura disponível real para conteúdo
    final double availableWidth = (width - horizontalPadding) - (oneColumn ? 0.0 : spacing);

    // largura do item — em 2 colunas dividimos por 2
    final double itemWidth = oneColumn ? availableWidth : (availableWidth / 2);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AbsorbPointer(
              absorbing: submitted,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableItems.map(_buildDraggableChip).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: widget.targets
                  .map(
                    (t) => SizedBox(
                      width: itemWidth,
                      child: _buildTargetCard(t),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            _buildExplanation(),
            SizedBox(height: 120 + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}