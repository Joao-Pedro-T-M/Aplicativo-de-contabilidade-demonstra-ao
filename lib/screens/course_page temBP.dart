// lib/screens/course_pages.dart

import 'package:flutter/foundation.dart';
import 'package:equition/state/app_state.dart';
import 'package:equition/widgets/drag_match_submit_widget.dart';
import 'package:equition/widgets/drag_match_sum_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../models/course_models.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;
import 'package:equition/Utils/progress_storage.dart';
import 'simulado_tab.dart';
import 'perfil_tab.dart';
import 'package:provider/provider.dart';
import '../widgets/drag_match_dre_widget.dart';
// Paleta local aplicada somente neste arquivo
const Color kPrimaryColor = Color(0xFF4CB2B2); // #4cb2b2 (verde principal)
const Color kAccentColor = Color(0xFFA2D7D7); // #a2d7d7 (verde claro)
const Color kTextColor = Color(0xFF0C1C1C);
const Color kSecondaryTextColor = Color(0xFF2D6B6B);
const Color kBackgroundColor = Color(0xFFFFFFFF);
const Color kCardColor = Color(0xFFE0F7FA);  // cor base dos cards
const Color kFilledLightBg = Color(0xFFF2FAFD); // #f2fafd - fundo leve quando "filled"
// debug toggle (false em produção)
const bool _kDebugWave = false;

/// ---------------------- Painel de Balanço (overview) ----------------------
/// Exibe 3 blocos: Ativo (esquerda grande), Passivo (direita cima), PL (direita baixo).
/// Ao tocar em cada bloco, chamamos a função onTap específica (recebe o índice da trilha).
class BalanceOverview extends StatelessWidget {
  final int? ativoIndex;
  final int? passivoIndex;
  final int? patrimonioIndex;
  final bool ativoDone;
  final bool passivoDone;
  final bool patrimonioDone;
  final void Function(int index)? onTapIndex;
  final double height;

  const BalanceOverview({
    Key? key,
    required this.ativoIndex,
    required this.passivoIndex,
    required this.patrimonioIndex,
    required this.ativoDone,
    required this.passivoDone,
    required this.patrimonioDone,
    this.onTapIndex,
    this.height = 150,
  }) : super(key: key);

  Widget _box({
    required BuildContext ctx,
    required String title,
    required IconData icon,
    required bool filled,
    required VoidCallback? onTap,
    // agora este parâmetro representa a cor de classificação (ex: kPrimaryColor)
    required Color baseColor,
    required Color borderColor,
    double? height,
    TextAlign align = TextAlign.center,
  }) {
    // fallback de altura para cálculos
    final h = (height ?? 150).clamp(48.0, 400.0);

    // tamanhos proporcionais (com limites)
    final double horizontalPadding = math.max(8.0, h * 0.06);
    final double verticalPadding = math.max(8.0, h * 0.06);
    final double iconSize = math.min(40.0, math.max(18.0, h * 0.22));
    final double gap = math.max(4.0, h * 0.05);
    final double titleFont = math.min(16.0, math.max(10.0, h * 0.11));

    // --- comportamento de cor seguindo o padrão solicitado ---
    final Color background = filled ? kFilledLightBg : kCardColor;
    final Color effectiveBorder = filled ? baseColor : borderColor;
    final Color iconAndTitleColor = filled ? baseColor : kTextColor;
    // ---------------------------------------------------------------

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: h,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: effectiveBorder, width: filled ? 1.6 : 1.0),
          boxShadow: filled ? [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: Offset(0,4))] : null,
        ),
        child: Stack(
          children: [
            if (filled)
              Positioned(
                right: 8,
                top: 8,
                // pequeno indicador quando preenchido (ajustável)
                child: Icon(Icons.check_circle, color: baseColor.withOpacity(0.95), size: 0),
              ),
            // centralizamos e permitimos que o conteúdo se ajuste sem overflow
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // evita Column expandir além do necessário
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: iconSize, color: iconAndTitleColor),
                  SizedBox(height: gap),
                  // limita linhas e evita overflow vertical
                  SizedBox(
                    // restringe a largura do texto para o espaço disponível no container
                    width: double.infinity,
                    child: Text(
                      title,
                      textAlign: align,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: iconAndTitleColor,
                        fontSize: titleFont,
                        height: 1.05,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // alturas internas
    final leftHeight = height;
    final rightHalf = (height - 8) / 2;

    // estado de conclusão
    final allDone = ativoDone && passivoDone && patrimonioDone;

    // cores e estilos
    final completionBg = kPrimaryColor.withOpacity(0.12);
    final completionBorder = kPrimaryColor.withOpacity(0.28);
    final headerTextColor = kPrimaryColor; // mantive cor primária
    final dividerColor = allDone ? completionBorder : kTextColor.withOpacity(0.12);

    // função helper para os blocos (mesma estrutura em ambos os estados)
    Widget blocksRow() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Expanded(
          flex: 3,
          child: PressableOverviewBox(
            title: 'Ativo',
            icon: Icons.account_balance_wallet_outlined,
            filled: ativoDone,
            onTap: ativoIndex != null ? () => onTapIndex?.call(ativoIndex!) : null,
            baseColor: const Color.fromARGB(255, 68, 156, 156),
            borderColor: ativoDone ? const Color.fromARGB(255, 68, 156, 156) : kPrimaryColor.withOpacity(0.18),
            height: leftHeight,
          ),
        ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Column(
              children: [
              PressableOverviewBox(
                title: 'Passivo',
                icon: Icons.request_quote_outlined,
                filled: passivoDone,
                onTap: passivoIndex != null ? () => onTapIndex?.call(passivoIndex!) : null,
                baseColor: const Color.fromARGB(255, 68, 156, 156),
                borderColor: passivoDone ? Color.fromARGB(255, 68, 156, 156) : kPrimaryColor.withOpacity(0.18),
                height: rightHalf,
              ),
                const SizedBox(height: 8),
                PressableOverviewBox(
                  title: 'Patrimônio\nLíquido',
                  icon: Icons.pie_chart_outline,
                  filled: patrimonioDone,
                  onTap: patrimonioIndex != null ? () => onTapIndex?.call(patrimonioIndex!) : null,
                  baseColor: const Color.fromARGB(255, 68, 156, 156),
                  borderColor: patrimonioDone ? Color.fromARGB(255, 68, 156, 156) : kPrimaryColor.withOpacity(0.18),
                  height: rightHalf,
                  align: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      );
    }

    // --- estado ALL DONE: retângulo envoltório + header + DIV colado + blocos
    if (allDone) {
      return Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 68, 156, 156),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: completionBorder, width: 1.2),
        ),
        // padding geral (mantém header menor para ficar "colado")
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // header (com padding reduzido)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Center(
                child: Text(
                  'BALANÇO PATRIMONIAL',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                ),
              ),
            ),

            // DIVIDER imediatamente abaixo do texto (sem gap)
            Divider(height: 1, thickness: 1, color: dividerColor),

            // pequena folga entre divider e blocos para respiração visual
            const SizedBox(height: 8),

            // blocos
            blocksRow(),
          ],
        ),
      );
    }

    // --- estado NÃO COMPLETO: header + DIV colado + blocos (sem retângulo envoltório)         esse é o card que envolve Ativo, Passivo, PL
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: completionBorder, width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Center(
              child: Text(
                'BALANÇO PATRIMONIAL',
                style: TextStyle(color: kTextColor, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          Divider(height: 1, thickness: 1, color: dividerColor),
          const SizedBox(height: 8),
          blocksRow(),
        ],
      ),
    );
  }
}

class PressableOverviewBox extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool filled;
  final VoidCallback? onTap;
  final Color baseColor;
  final Color borderColor;
  final double? height;
  final TextAlign align;

  const PressableOverviewBox({
    Key? key,
    required this.title,
    required this.icon,
    required this.filled,
    required this.onTap,
    required this.baseColor,
    required this.borderColor,
    this.height,
    this.align = TextAlign.center,
  }) : super(key: key);

  @override
  State<PressableOverviewBox> createState() => _PressableOverviewBoxState();
}

class _PressableOverviewBoxState extends State<PressableOverviewBox> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final double h = (widget.height ?? 150).clamp(48.0, 400.0);

    // tamanhos proporcionais (mesma lógica que antes)
    final double horizontalPadding = math.max(8.0, h * 0.06);
    final double verticalPadding = math.max(8.0, h * 0.06);
    final double iconSize = math.min(40.0, math.max(18.0, h * 0.22));
    final double gap = math.max(4.0, h * 0.05);
    final double titleFont = math.min(16.0, math.max(10.0, h * 0.11));

    // cores / estado
    final Color background = widget.filled ? kPrimaryColor : kCardColor;  // cor do card dentro do BP = Ativo, Passivo, PL
    final Color solidBorder = widget.borderColor.withOpacity(1.0);
    final Color effectiveBorder = widget.filled ? widget.baseColor : widget.borderColor;
    final Color iconAndTitleColor = widget.filled ? widget.baseColor : kTextColor;

    final double pressOffset = _pressed ? 4.0 : 0.0;

    // frontColor: quando pressionado, front vira a cor sólida da borda (efeito "pressed")
    final Color frontColor = _pressed ? solidBorder : background;

    final displayedIcon = widget.filled ? Icons.check_circle : widget.icon;
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(12),
      onHighlightChanged: (value) => setState(() => _pressed = value),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        height: h,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        transform: Matrix4.translationValues(0, pressOffset, 0),
        decoration: BoxDecoration(
          color: frontColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: solidBorder, width: widget.filled ? 1.6 : 1.0),
          boxShadow: widget.filled ? [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: Offset(0,4))] : null,
        ),
        child: Stack(
          children: [
if (widget.filled)
  Positioned(
    right: 8,
    top: 8,
    child: Icon(
      Icons.check_circle,
      color: Colors.white, // branco quando completo
      size: 0,
    ),
  ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
Icon(
  displayedIcon,
  size: iconSize,
  color: _pressed ? Colors.white : (widget.filled ? widget.baseColor : kTextColor),
),
                  SizedBox(height: gap),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      widget.title,
                      textAlign: widget.align,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: _pressed ? Colors.white : (widget.filled ? iconAndTitleColor : kTextColor),
                        fontSize: titleFont,
                        height: 1.05,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/// ---------------------- CoursePage / Abas principais ----------------------
class CoursePage extends StatefulWidget {
  final Course course;
  final String? userId;

  const CoursePage({
    Key? key,
    required this.course,
    this.userId,
  }) : super(key: key);

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  int _selectedIndex = 0;
  bool _progressChanged = false;
  bool _hideAppBarForSimulado = false;

  void _notifyProgressChanged() {
    if (!_progressChanged) setState(() => _progressChanged = true);
  }

  void _setSimuladoHeaderHidden(bool hidden) {
    if (!mounted) return;
    setState(() {
      _hideAppBarForSimulado = hidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = <Widget>[
      _AprenderTab(
        course: widget.course,
        userId: widget.userId,
        onProgressChanged: _notifyProgressChanged,
      ),
      SimuladoTab(
        course: widget.course,
        userId: widget.userId,
        onUiStateChanged: _setSimuladoHeaderHidden,
      ),
      PerfilTab(
        course: widget.course,
        userId: widget.userId,
      ),
    ];

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_progressChanged);
        return false;
      },
      child: Scaffold(
appBar: _selectedIndex == 1
    ? null
    : AppBar(
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        elevation: 2,
        title: Text(
          widget.course.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
        body: IndexedStack(
          index: _selectedIndex,
          children: tabs,
        ),
bottomNavigationBar: (_selectedIndex == 1 && _hideAppBarForSimulado)
    ? null
    : BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey[600],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Aprender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Simulado',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
        backgroundColor: kBackgroundColor,
      ),
    );
  }
}
/// ---------------------- Aba Aprender (tela atual de trilhas) ----------------------
class _AprenderTab extends StatefulWidget {
  final Course course;
  final String? userId;
  final VoidCallback? onProgressChanged;
  const _AprenderTab({
    required this.course,
    this.userId,
    this.onProgressChanged,
  }) : super();

  @override
  State<_AprenderTab> createState() => _AprenderTabState();
}

class _AprenderTabState extends State<_AprenderTab> {
  late List<bool> _completed;
  late List<String?> _trailCharacteristic;

  @override
  void initState() {
    super.initState();
    final n = widget.course.trails.length;
    _completed = List<bool>.filled(n, false);
    _trailCharacteristic = List<String?>.filled(n, null);

    for (var i = 0; i < n; i++) {
      final t = widget.course.trails[i];
      final id = t.id.toLowerCase();
      final title = t.title.toLowerCase();

      if (id.contains('nivel1') || title.contains('nível 1') || title.contains('nivel 1')) {
        _trailCharacteristic[i] = 'ativo';
      } else if (id.contains('nivel2') || title.contains('nível 2') || title.contains('nivel 2')) {
        _trailCharacteristic[i] = 'passivo';
      } else if (id.contains('nivel3') || title.contains('nível 3') || title.contains('nivel 3')) {
        _trailCharacteristic[i] = 'patrimonio';
      } else {
        _trailCharacteristic[i] = null;
      }
    }

    _loadProgressFromStorage();
  }

  Future<void> _loadProgressFromStorage() async {
    try {
      // futura proteção: evita chamadas ao Cloud quando o AppState não habilitou o sync.
      bool cloudSyncEnabled = false;
      try {
        // exige `import 'package:provider/provider.dart';` no topo do arquivo
        final appState = Provider.of<dynamic>(context, listen: false);
        if (appState != null && appState.cloudSyncEnabled == true) cloudSyncEnabled = true;
      } catch (_) {
        // Provider/AppState não disponível ou não configurado — permanecemos com cloudSyncEnabled = false
      }

      // carrega progresso local sempre
      final localFuture = ProgressStorage.getCompletedTrailIds(widget.course.id, userId: widget.userId);

      // apenas prepara leitura cloud se habilitado
      

   
      if (!mounted) return;
      setState(() {
        for (var i = 0; i < widget.course.trails.length; i++) {
          final id = widget.course.trails[i].id;
        }
      });

  
    } catch (e) {
      debugPrint('Erro ao carregar progresso: $e');
    }
  }

  int? _findIndexForKey(String key) {
    for (var i = 0; i < _trailCharacteristic.length; i++) {
      if (_trailCharacteristic[i] == key) return i;
    }

    for (var i = 0; i < widget.course.trails.length; i++) {
      final t = widget.course.trails[i];
      final id = t.id.toLowerCase();
      final title = t.title.toLowerCase();

      if (key == 'ativo' && (id.contains('nivel1') || title.contains('nível 1') || title.contains('nivel 1'))) {
        return i;
      }
      if (key == 'passivo' && (id.contains('nivel2') || title.contains('nível 2') || title.contains('nivel 2'))) {
        return i;
      }
      if (key == 'patrimonio' && (id.contains('nivel3') || title.contains('nível 3') || title.contains('nivel 3'))) {
        return i;
      }
    }
    return null;
  }

  String? _inferredClassification(int index) {
    final t = widget.course.trails[index];
    final id = t.id.toLowerCase();
    final title = t.title.toLowerCase();

    if (id.contains('nivel1') || title.contains('nível 1') || title.contains('nivel 1')) return 'ativo';
    if (id.contains('nivel2') || title.contains('nível 2') || title.contains('nivel 2')) return 'passivo';
    if (id.contains('nivel3') || title.contains('nível 3') || title.contains('nivel 3')) return 'patrimonio';
    return null;
  }

  // -> adicionar em _AprenderTabState
  Color _baseColorForTrail(int index) {
    final char = _trailCharacteristic[index] ?? _inferredClassification(index);
    if (char == 'ativo') return kPrimaryColor;
    if (char == 'passivo') return kAccentColor;
    if (char == 'patrimonio') return kPrimaryColor;
    return kCardColor; // sem classificação -> mantém branco
  }

  Future<void> _onTapLevel(int index) async {
    final trail = widget.course.trails[index];
    final bool isAlreadyCompleted = _completed[index];

    final start = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Começar',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = Curves.easeOut.transform(animation.value);
        return Opacity(
          opacity: animation.value,
          child: Transform.scale(
            scale: 0.95 + 0.05 * curved,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 520),
                    decoration: BoxDecoration(
                      color: kCardColor,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                          decoration: const BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.14),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: kPrimaryColor.withOpacity(0.24)),
                                ),
                                child: Icon(
                                  isAlreadyCompleted ? Icons.check_circle : Icons.school,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Começar a aprender',
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trail.title,
                                style: const TextStyle(color: kTextColor, fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                trail.description,
                                style: const TextStyle(color: kSecondaryTextColor, fontSize: 14, height: 1.35),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          child: Row(
                            children: [
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    elevation: 4,
                                  ),
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text(
                                    'Começar',
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (start == true && trail.lessons.isNotEmpty) {
      final finished = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => LessonPage(
            lesson: trail.lessons.first,
            trailTitle: trail.title,
            reviewMode: _completed[index],
          ),
        ),
      );

      if (finished == true) {
        // Salva local (sempre)
        try {
          await ProgressStorage.markTrailCompleted(
            widget.course.id,
            trail.id,
            userId: widget.userId,
          );
        } catch (e) {
          debugPrint('Erro salvando progresso local: $e');
        }

        // atualiza UI antes de aguardar a nuvem (melhora percepção de responsividade)
        if (!mounted) return;
        setState(() => _completed[index] = true);

        // === invés de gravar direto, use o SyncManager (buffered) se o cloudSync estiver habilitado ===
        try {
          final appState = Provider.of<AppState>(context, listen: false);
          if (widget.userId != null && widget.userId!.isNotEmpty && appState.cloudSyncEnabled && appState.syncManager != null) {
            appState.syncManager!.markCompletedLocally(widget.course.id, trail.id);
          } else {
            if (kDebugMode) debugPrint('Cloud sync disabled or not configured - progresso mantido localmente');
          }
        } catch (e) {
          if (kDebugMode) debugPrint('SyncManager not available: $e');
        }

        widget.onProgressChanged?.call();
      }
    } else if (start == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhuma prova disponível neste nível.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;

    final ativoIdx = _findIndexForKey('ativo');
    final passivoIdx = _findIndexForKey('passivo');
    final patrimonioIdx = _findIndexForKey('patrimonio');

    final ativoDone = (ativoIdx != null) ? _completed[ativoIdx] : false;
    final passivoDone = (passivoIdx != null) ? _completed[passivoIdx] : false;
    final patrimonioDone = (patrimonioIdx != null) ? _completed[patrimonioIdx] : false;

    final visibleIndices = <int>[
      for (var i = 0; i < course.trails.length; i++)
        if (_inferredClassification(i) == null) i,
    ];

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: visibleIndices.length + 1,
        itemBuilder: (_, idx) {
          if (idx == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: BalanceOverview(
                ativoIndex: ativoIdx,
                passivoIndex: passivoIdx,
                patrimonioIndex: patrimonioIdx,
                ativoDone: ativoDone,
                passivoDone: passivoDone,
                patrimonioDone: patrimonioDone,
                height: 150,
                onTapIndex: (index) => _onTapLevel(index),
              ),
            );
          }

          final trailIndex = visibleIndices[idx - 1];
          final trail = course.trails[trailIndex];
          final completed = _completed[trailIndex];

          // parâmetros responsivos (reaproveitei sua lógica original)
return LayoutBuilder(
  builder: (context, constraints) {
    final baseColor = _baseColorForTrail(trailIndex);
    final bool hasClassificationColor = baseColor != kCardColor;
    final bool filled = completed;

    final Color effectiveColor = hasClassificationColor
        ? baseColor
        : (filled ? kPrimaryColor : kPrimaryColor);

    // inverter o fundo do card quando preenchido (usa effectiveColor quando filled)
    final Color background = filled ? effectiveColor : kCardColor;
    // borda: quando preenchido deixamos um contorno claro (kCardColor), caso contrário uma borda sutil
    final Color borderColor = filled ? const Color.fromARGB(255, 68, 156, 156) : kPrimaryColor.withOpacity(0.18);            // cor do card de fundo do principal

              // cálculo responsivo do tamanho da fonte:
              final double w = constraints.maxWidth.isFinite ? constraints.maxWidth : MediaQuery.of(context).size.width;
              final double h = constraints.maxHeight.isFinite && constraints.maxHeight > 0 ? constraints.maxHeight : 80.0;
              double fontBase = math.min(w, h) * 0.12;
              final double fontSize = fontBase.clamp(18.0, 32.0);

              final double iconSize = (fontSize * 1.6).clamp(28.0, 80.0);

              final List<BoxShadow> threeDShadows = [
                BoxShadow(color: Colors.black.withOpacity(0.06), offset: const Offset(0, 6), blurRadius: 10, spreadRadius: -2),
                BoxShadow(color: Colors.black.withOpacity(0.04), offset: const Offset(0, 10), blurRadius: 24, spreadRadius: -8),
              ];

              return PressableTrailCard(
                title: trail.title,
                description: trail.description,
                filled: filled,
                background: background,
                borderColor: borderColor,
                effectiveColor: effectiveColor,
                fontSize: fontSize,
                iconSize: iconSize,
                threeDShadows: threeDShadows,
                onTap: () => _onTapLevel(trailIndex),
              );
            },
          );
        },
      ),
      backgroundColor: kBackgroundColor, // isso aqui define o fundo de tudo
    );
  }
}

/// Pressable card para trilhas (adaptado do PressableCourseCard do outro arquivo)
class PressableTrailCard extends StatefulWidget {
  final String title;
  final String description;
  final bool filled;
  final Color background;
  final Color borderColor;
  final Color effectiveColor;
  final double fontSize;
  final double iconSize;
  final List<BoxShadow> threeDShadows;
  final VoidCallback onTap;

  const PressableTrailCard({
    Key? key,
    required this.title,
    required this.description,
    required this.filled,
    required this.background,
    required this.borderColor,
    required this.effectiveColor,
    required this.fontSize,
    required this.iconSize,
    required this.threeDShadows,
    required this.onTap,
  }) : super(key: key);

  @override
  State<PressableTrailCard> createState() => _PressableTrailCardState();
}

class _PressableTrailCardState extends State<PressableTrailCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    // Quando solto: o card principal fica "por cima" da base.
    // Quando pressionado: ele desce e cobre a base, como uma tecla.
    final double pressOffset = _pressed ? 4.0 : 0.0;

    // inset entre a base (maior) e o card principal (menor)
    final double outerInset = 6.0;

    // quanto reduzir da margem top do fundo para que ele "suba" só um pouco
    final double baseTopOverlap = 6.0; // ajuste pequeno — aumente/reduza se quiser
    final EdgeInsets baseMargin = EdgeInsets.only(top: outerInset - baseTopOverlap);

    // Remove transparências: força cor sólida para borda/fundo do card
    final Color solidBorder = widget.borderColor.withOpacity(1.0);

    // Quando pressionado, o frontColor usa a mesma cor sólida do fundo.
    final Color frontColor = _pressed ? solidBorder : widget.background;

    final displayedIcon = widget.filled ? Icons.check_circle : Icons.school;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 108,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // === MAIOR card de fundo (cor sólida) ===
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 90),
                curve: Curves.easeOut,
                margin: baseMargin,
                decoration: BoxDecoration(
                  color: solidBorder,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: solidBorder,
                    width: 1.0,
                  ),
                ),
              ),
            ),

            // === Card principal, menor, que fica por cima ===
            Positioned.fill(
              left: outerInset,
              top: 1,
              right: outerInset,
              bottom: outerInset,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: widget.onTap,
                  onHighlightChanged: (value) {
                    setState(() => _pressed = value);
                  },
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 90),
                    curve: Curves.easeOut,
                    transform: Matrix4.translationValues(0, pressOffset, 0),
                    decoration: BoxDecoration(
                      color: frontColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: solidBorder,
                        width: widget.filled ? 1.6 : 1.0,
                      ),
                      boxShadow: widget.filled ? widget.threeDShadows : null,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 96),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // círculo do ícone: acompanha o estado pressed
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: _pressed ? solidBorder : widget.background,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: solidBorder,
                                  width: 1.2,
                                ),
                              ),
child: Center(
  child: Icon(
    displayedIcon,
    size: widget.iconSize,
    color: _pressed
        ? Colors.white
        : (widget.filled ? kSecondaryTextColor : widget.effectiveColor),
  ),
),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.title,
                                    style: TextStyle(
                                      fontSize: widget.fontSize,
                                      fontWeight: FontWeight.w800,
                                      color: _pressed
    ? Colors.white
    : (widget.filled ? Colors.white : kTextColor),       // cor texto card principal
                                      height: 1.02,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            Icon(Icons.chevron_right, color: _pressed ? Colors.white : kPrimaryColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------- Restante do arquivo (LessonPage e painter) ----------------------
/// (mantive sua implementação original do LessonPage, apenas preservei tal como estava,
/// porém formatei e corrigi o método build para evitar erros de parênteses)
class _ConditionalPageScrollPhysics extends ClampingScrollPhysics {
  final PageController controller;
  final bool Function(int from, int to) canNavigate;
  _ConditionalPageScrollPhysics({ScrollPhysics? parent, required this.controller, required this.canNavigate}) : super(parent: parent);

  @override
  _ConditionalPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _ConditionalPageScrollPhysics(parent: buildParent(ancestor), controller: controller, canNavigate: canNavigate);
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    final fraction = controller.hasClients ? controller.viewportFraction : 1.0;
    final double pageWidth = position.viewportDimension * fraction;
    if (pageWidth <= 0) return super.applyBoundaryConditions(position, value);

    final double delta = value - position.pixels;
    final int from = (position.pixels / pageWidth).floor();

    if (delta > 0) {
      final int to = from + 1;
      final int maxPage = (position.maxScrollExtent / pageWidth).round();
      if (to <= maxPage && !canNavigate(from, to)) return delta;
    } else if (delta < 0) {
      final int to = from - 1;
      if (to >= 0 && !canNavigate(from, to)) return delta;
    }

    return super.applyBoundaryConditions(position, value);
  }
}

class LessonPage extends StatefulWidget {
  final Lesson lesson;
  final String trailTitle;
  final bool reviewMode;
  const LessonPage({Key? key, required this.lesson, required this.trailTitle, this.reviewMode = false}) : super(key: key);

  @override
  State<LessonPage> createState() => _LessonPageState();
}













// parte da aba das questoes
class _LessonPageState extends State<LessonPage> with TickerProviderStateMixin {
  late final PageController _pageController;
  late final int total;
  int current = 0;

  late List<int?> selectedIndices;
  late List<Set<int>> incorrectAttemptsPerQuestion;
  late List<bool> answeredCorrectList;
  late List<GlobalKey> _questionKeys;
  late List<GlobalKey> _explanationKeys;
  late List<bool> allowedToAdvance;
  int totalCorrect = 0;

  double _waveWidth = 0.0;
  bool _waveOnRight = false;
  late final AnimationController _waveController;
  late Animation<double> _waveAnim;

  static const double _maxWave = 16.0;
  static const double _sensitivity = 0.35;
  static const double _overscrollTrigger = 0.02;
  static const double _collisionThreshold = 0.12;

  double _waveFocal = 0.5;
  double _waveHeightFactor = 0.8;

  bool _programmaticScroll = false;

  dynamic getQuestion(int idx) => widget.lesson.questions[idx];

  @override
  void initState() {
    super.initState();
    total = widget.lesson.questions.length;
    _pageController = PageController(initialPage: 0, viewportFraction: 1);

    selectedIndices = List<int?>.filled(total, null);
    incorrectAttemptsPerQuestion = List.generate(total, (_) => <int>{});
    answeredCorrectList = List<bool>.filled(total, false);
    allowedToAdvance = List<bool>.filled(total, false);
    _questionKeys = List.generate(total, (_) => GlobalKey());
    _explanationKeys = List.generate(total, (_) => GlobalKey());

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _waveAnim = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeOut),
    );

    _waveController.addListener(() {
      setState(() {
        _waveWidth = _waveAnim.value;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _animateWaveTo(double target, {int ms = 60}) {
    if ((target - _waveWidth).abs() < 0.5) return;
    _waveController.stop();
    _waveController.duration = Duration(milliseconds: ms.clamp(20, 600));
    _waveAnim = Tween<double>(begin: _waveWidth, end: target).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeOut),
    );
    _waveController
      ..value = 0.0
      ..forward();
  }

  Future<void> _scrollToKey(GlobalKey key, {double alignment = 0.85}) async {
    await Future.delayed(const Duration(milliseconds: 20));
    if (!mounted) return;
    final ctx = key.currentContext;
    if (ctx == null) return;

    try {
      await Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOut,
        alignment: alignment,
      );
    } catch (_) {}
  }

  void _focusExplanation(int questionIndex) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 120));
      if (!mounted) return;
      await _scrollToKey(_explanationKeys[questionIndex], alignment: 0.85);
    });
  }

  void _focusQuestionTop(int questionIndex) {
  // Executa após o frame para que o layout esteja estável
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (!mounted) return;
    // pequena espera para deixar animações do botão/ícone terminarem
    await Future.delayed(const Duration(milliseconds: 140));
    if (!mounted) return;

    final ctx = _questionKeys[questionIndex].currentContext;
    if (ctx == null) return;

    try {
      // posição global do topo do card
      final renderBox = ctx.findRenderObject() as RenderBox;
      final topGlobal = renderBox.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;

      // Se o topo já estiver visível perto da parte superior, evita fazer scroll abrupto
      // Ajuste os thresholds se quiser comportamento diferente
      if (topGlobal.dy <= screenHeight * 0.12) {
        // já está suficientemente no topo — nada a fazer
        return;
      }

      // Define um alignment adaptativo:
      // - se o card estiver bem lá embaixo, traz mais pro topo (alignment menor)
      // - se estiver apenas um pouco deslocado, usa um alignment mais brando
      final double alignment =
          topGlobal.dy > screenHeight * 0.66 ? 0.08 : (topGlobal.dy > screenHeight * 0.40 ? 0.16 : 0.30);

      await Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 420), // mais suave
        curve: Curves.easeOutCubic,
        alignment: alignment,
      );
    } catch (_) {
      // se der erro, não quer quebrar a UI — swallow
    }
  });
}

  Widget _animatedReveal({
    required bool show,
    required String id,
    required Widget child,
  }) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: ClipRect(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (widget, animation) {
            final slide = Tween<Offset>(
              begin: const Offset(0, 0.08),
              end: Offset.zero,
            ).animate(animation);

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: slide,
                child: widget,
              ),
            );
          },
          child: show
              ? KeyedSubtree(
                  key: ValueKey('show-$id'),
                  child: child,
                )
              : const SizedBox.shrink(
                  key: ValueKey('hide'),
                ),
        ),
      ),
    );
  }

  void select(int questionIndex, int optionIndex) {
    if (answeredCorrectList[questionIndex]) return;

    final q = getQuestion(questionIndex);
    final bool isCorrect = optionIndex == q.correctIndex;

    setState(() {
      selectedIndices[questionIndex] = optionIndex;

      if (isCorrect) {
        answeredCorrectList[questionIndex] = true;
        totalCorrect++;
      } else {
        incorrectAttemptsPerQuestion[questionIndex].add(optionIndex);
      }
    });

    if (!isCorrect) {
      _focusExplanation(questionIndex);
    } else {
      _focusQuestionTop(questionIndex);
    }
  }

  Future<void> _animateToPage(
    int newPage, {
    int ms = 200,
    bool force = false,
  }) async {
    if (newPage < 0 || newPage >= total) return;

    if (!force && !_isNavigationAllowed(current, newPage)) {
      HapticFeedback.mediumImpact();
      if (_waveWidth > 0) _startWaveReturnAnimation();
      return;
    }

    _programmaticScroll = true;
    try {
      await _pageController.animateToPage(
        newPage,
        duration: Duration(milliseconds: ms),
        curve: Curves.easeInOut,
      );
    } finally {
      _programmaticScroll = false;
    }
  }

  void next() {
    if (current < total - 1) {
      _animateToPage(current + 1, ms: 220, force: true);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Concluído'),
          content: Text('Você terminou a trilha! Acertos: $totalCorrect/$total'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(true);
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    }
  }

  void skipQuestion() {
    // permite avanço futuro a partir desta questão (mesmo sem estar correta)
    allowedToAdvance[current] = true;

    if (current < total - 1) {
      _animateToPage(current + 1, ms: 220, force: true);
    } else {
      next();
    }
  }

  void tryAgain() {
    setState(() {
      selectedIndices[current] = null;
      allowedToAdvance[current] = false; // opcional: revoga o skip anterior
    });
    _focusQuestionTop(current);
  }

bool _isNavigationAllowed(int from, int to) {
  if (widget.reviewMode) return true;
  if (to == from) return true;

  // AVANÇAR (to > from): permite se:
  // - a questão atual (from) está correta; ou
  // - a questão de destino (to) já está correta (retro-visitada); ou
  // - a questão atual foi previamente "pulada" / desbloqueada (allowedToAdvance[from])
  if (to > from) {
    return answeredCorrectList[from] ||
           answeredCorrectList[to] ||
           allowedToAdvance[from];
  }

  // VOLTAR (to < from): permite se:
  // - a questão de destino (to) está correta; ou
  // - a questão de destino foi previamente "pulada" / desbloqueada (allowedToAdvance[to])
  // Isso garante que se o usuário pulou a questão antes, ele conseguirá voltar para ela.
  return answeredCorrectList[to] || allowedToAdvance[to];
}

  void _handlePageChangeAttempted(int attemptedPage) {
    if (_programmaticScroll) {
      setState(() {
        current = attemptedPage;
      });
      return;
    }

    final allowed = _isNavigationAllowed(current, attemptedPage);
    if (allowed) {
      setState(() {
        current = attemptedPage;
      });
    } else {
      _animateToPage(current, ms: 160);
      if (_waveWidth > 0) _startWaveReturnAnimation();
      HapticFeedback.mediumImpact();
    }
  }

  void _startWaveReturnAnimation() {
    _waveController.stop();
    final ratio = (_waveWidth / (_maxWave == 0 ? 1.0 : _maxWave)).clamp(0.0, 1.0);
    final int dur = (120 + (260 * ratio)).round().clamp(100, 500);
    _waveController.duration = Duration(milliseconds: dur);
    _waveAnim = Tween<double>(begin: _waveWidth, end: 0.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeOut),
    );
    _waveController
      ..value = 0.0
      ..forward();
  }

  bool _isAtPageLockPosition() {
    if (!_pageController.hasClients) return false;
    final double page = _pageController.page ?? _pageController.initialPage.toDouble();
    return (page - current).abs() < 0.03;
  }

  bool _onScrollNotification(ScrollNotification notif) {
    if (notif.metrics.axis == Axis.vertical) {
      if (_waveWidth > 0) _startWaveReturnAnimation();
      return false;
    }
    if (_programmaticScroll) return false;

    final viewport = notif.metrics.viewportDimension;
    if (viewport <= 0) return false;

    final double fraction = _pageController.hasClients ? _pageController.viewportFraction : 1.0;
    final double pageWidth = viewport * fraction;
    if (pageWidth <= 0) return false;

    final double pageOffset = notif.metrics.pixels / pageWidth;
    if (_kDebugWave) {
      debugPrint('scroll notif: current=$current pageOffset=$pageOffset pixels=${notif.metrics.pixels}');
    }

    const double eps = 0.01;

    if (_isAtPageLockPosition() && notif is ScrollUpdateNotification) {
      final double localOffset = notif.metrics.pixels - (current * pageWidth);
      const double localThreshold = 4.0;

      if (localOffset > localThreshold) {
        final int to = current + 1;
        final bool blocked = to >= total || !_isNavigationAllowed(current, to);
        if (blocked) {
          _waveOnRight = true;
          final double target = (localOffset * _sensitivity * (0.7 + 0.3 * _waveHeightFactor)).clamp(0.0, _maxWave);
          setState(() {
            _waveWidth = target;
          });
          return false;
        }
      } else if (localOffset < -localThreshold) {
        final int to = current - 1;
        final bool blocked = to < 0 || !_isNavigationAllowed(current, to);
        if (blocked) {
          _waveOnRight = false;
          final double target = ((-localOffset) * _sensitivity * (0.7 + 0.3 * _waveHeightFactor)).clamp(0.0, _maxWave);
          setState(() {
            _waveWidth = target;
          });
          return false;
        }
      }
    }

    double overscrollPixels = 0.0;
    bool overscrollRight = false;

    if (pageOffset < -eps) {
      overscrollPixels = (-pageOffset) * pageWidth;
      overscrollRight = false;
    } else if (pageOffset > (total - 1) + eps) {
      overscrollPixels = (pageOffset - (total - 1)) * pageWidth;
      overscrollRight = true;
    } else {
      overscrollPixels = 0.0;
    }

    if (notif is ScrollUpdateNotification) {
      if (overscrollPixels > 0) {
        if (_isAtPageLockPosition()) {
          _waveOnRight = overscrollRight;
          final double target = (overscrollPixels * _sensitivity * (0.7 + 0.3 * _waveHeightFactor)).clamp(0.0, _maxWave);
          setState(() {
            _waveWidth = target;
          });
        } else {
          if (_waveWidth > 0.5) _startWaveReturnAnimation();
        }
      } else {
        if (_waveWidth > 0.5) {
          _animateWaveTo((_waveWidth * 0.82).clamp(0.0, _maxWave), ms: 80);
        }
      }
    } else if (notif is ScrollEndNotification ||
        (notif is UserScrollNotification && notif.direction == ScrollDirection.idle)) {
      if (_waveWidth > 0) _startWaveReturnAnimation();
    }

    return false;
  }

  void _onPointerMove(PointerMoveEvent e) {
    if (_programmaticScroll) return;

    const double threshold = 2.0;
    if (!_isAtPageLockPosition()) return;

    final dx = e.delta.dx;
    final dy = e.delta.dy;

    if (dy.abs() > 6 && dy.abs() > dx.abs()) {
      if (_waveWidth > 0) _startWaveReturnAnimation();
      return;
    }

    try {
      final box = context.findRenderObject() as RenderBox;
      final local = box.globalToLocal(e.position);
      final h = box.size.height;
      if (h > 0) {
        _waveFocal = (local.dy / h).clamp(0.05, 0.95);
        final distFromCenter = (_waveFocal - 0.5).abs();
        _waveHeightFactor = (1.0 - (distFromCenter * 1.6)).clamp(0.35, 1.0);
      }
    } catch (_) {
      _waveFocal = 0.5;
      _waveHeightFactor = 0.8;
    }

    if (dx < -threshold) {
      final int to = current + 1;
      final bool blocked = to >= total || !_isNavigationAllowed(current, to);
      if (blocked) {
        _waveOnRight = true;
        final double inc = (-dx) * 1.8;
        setState(() {
          _waveWidth = (_waveWidth + inc).clamp(0.0, _maxWave);
        });
        HapticFeedback.lightImpact();
        if (_kDebugWave) {
          debugPrint('pointer move (blocked advance): dx=$dx waveWidth=$_waveWidth');
        }
      }
    } else if (dx > threshold) {
      final int to = current - 1;
      final bool blocked = to < 0 || !_isNavigationAllowed(current, to);
      if (blocked) {
        _waveOnRight = false;
        final double inc = dx * 1.8;
        setState(() {
          _waveWidth = (_waveWidth + inc).clamp(0.0, _maxWave);
        });
        HapticFeedback.lightImpact();
        if (_kDebugWave) {
          debugPrint('pointer move (blocked back): dx=$dx waveWidth=$_waveWidth');
        }
      }
    }
  }

  void _onDragUpdateImmediate(DragUpdateDetails details) {
    final dx = details.delta.dx;
    const double threshold = 2.0;
    if (!_isAtPageLockPosition()) return;

    if (dx < -threshold) {
      final int to = current + 1;
      final bool blocked = to >= total || !_isNavigationAllowed(current, to);
      if (blocked) {
        _waveOnRight = true;
        setState(() {
          _waveWidth = (_waveWidth + (-dx * 1.6)).clamp(0.0, _maxWave);
        });
        HapticFeedback.lightImpact();
      }
    } else if (dx > threshold) {
      final int to = current - 1;
      final bool blocked = to < 0 || !_isNavigationAllowed(current, to);
      if (blocked) {
        _waveOnRight = false;
        setState(() {
          _waveWidth = (_waveWidth + (dx * 1.6)).clamp(0.0, _maxWave);
        });
        HapticFeedback.lightImpact();
      }
    }
  }

  Widget _flatPanel({
    required Widget child,
    required Color backgroundColor,
    Color? topLineColor,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: backgroundColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (topLineColor != null)
            Container(
              height: 1,
              color: topLineColor,
            ),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = (current + 1) / (total == 0 ? 1 : total);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        title: Text(widget.trailTitle, style: const TextStyle(color: Colors.white)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: progress,
            valueColor: const AlwaysStoppedAnimation<Color>(kSecondaryTextColor),
            backgroundColor: kSecondaryTextColor.withOpacity(0.15),
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: _onScrollNotification,
                    child: Listener(
                      onPointerMove: _onPointerMove,
                      child: PageView.builder(
                        controller: _pageController,
                        physics: _ConditionalPageScrollPhysics(
                          parent: const ClampingScrollPhysics(),
                          controller: _pageController,
                          canNavigate: (from, to) =>
                              _programmaticScroll ? true : _isNavigationAllowed(from, to),
                        ),
                        itemCount: total,
                        onPageChanged: (idx) {
                          _handlePageChangeAttempted(idx);
                        },
 itemBuilder: (context, pageIndex) {
  final dynamic q = widget.lesson.questions[pageIndex];
  final selected = selectedIndices[pageIndex];
  final incorrectAttempts = incorrectAttemptsPerQuestion[pageIndex];
  final answeredCorrect = answeredCorrectList[pageIndex];

  // escala responsiva para tipografia (evita usar clamp() que retorna num diretamente)
  final double width = MediaQuery.of(context).size.width;
  double scale = width / 420.0;
  if (scale < 0.66) scale = 0.66;
  if (scale > 1.0) scale = 1.0;

  final bool hasExplanation = q.explanation != null && (q.explanation as String).trim().isNotEmpty;
  final bool showExplanation =
      hasExplanation && !answeredCorrect && (selected != null || incorrectAttempts.isNotEmpty);

  // cartão de enunciado com tipografia responsiva
  Widget questionCard = Padding(
    padding: EdgeInsets.zero,
    child: SizedBox(
      key: _questionKeys[pageIndex],
      width: double.infinity,
      child: _flatPanel(
        backgroundColor: const Color.fromARGB(255, 153, 190, 190),
        topLineColor: const Color.fromARGB(255, 153, 190, 190).withOpacity(0.28),
        child: Padding(
          padding: EdgeInsets.all(18 * scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10 * scale),
              // Text responsivo: usa scale
              Text(
                q.text,
                style: TextStyle(fontSize: 18 * scale, color: kTextColor),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  // --- MatchQuestion branch (unchanged, apenas adaptado para scale) ---
  if (q is MatchQuestion) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          questionCard,
          SizedBox(height: 20 * scale),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0 * scale),
            child: DragMatchSubmitWidget(
              items: q.items,
              targets: q.targets,
              correctMap: q.correctMap,
              explanation: q.explanation,
              onSkip: skipQuestion,
              onSubmitted: (allCorrect) {
                setState(() {
                  answeredCorrectList[pageIndex] = allCorrect;
                  totalCorrect = answeredCorrectList.where((e) => e).length;
                });

                if (!allCorrect) {
                  _focusExplanation(pageIndex);
                }
              },
            ),
          ),
          _animatedReveal(
            show: showExplanation,
            id: 'match-explanation-$pageIndex',
            child: Padding(
              padding: EdgeInsets.only(top: 22 * scale),
              child: _flatPanel(
                backgroundColor: kCardColor,
                topLineColor: kPrimaryColor.withOpacity(0.28),
                child: Padding(
                  key: _explanationKeys[pageIndex],
                  padding: EdgeInsets.all(16 * scale),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Explicação', style: TextStyle(fontSize: 15 * scale, fontWeight: FontWeight.w700, color: kTextColor)),
                      SizedBox(height: 10 * scale),
                      Text(q.explanation!, style: TextStyle(fontSize: 15 * scale, color: kTextColor)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 180 * scale + MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  // --- MatchSumQuestion branch ---
  if (q is MatchSumQuestion) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          questionCard,
          SizedBox(height: 20 * scale),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0 * scale),
            child: DragMatchSumWidget(
              items: q.items,
              targets: q.targets,
              correctMap: q.correctMap,
              expectedTargetTotals: q.expectedTargetTotals,
              explanation: q.explanation,
              onSubmitted: (allCorrect) {
                setState(() {
                  answeredCorrectList[pageIndex] = allCorrect;
                  totalCorrect = answeredCorrectList.where((e) => e).length;
                });

                if (!allCorrect) {
                  _focusQuestionTop(pageIndex);
                }
              },
              onSkip: skipQuestion,
              onTotalsChanged: (totals) {
                // opcional: usar totais para UI
              },
            ),
          ),
          _animatedReveal(
            show: showExplanation,
            id: 'matchsum-explanation-$pageIndex',
            child: Padding(
              padding: EdgeInsets.only(top: 22 * scale),
              child: _flatPanel(
                backgroundColor: kCardColor,
                topLineColor: kPrimaryColor.withOpacity(0.28),
                child: Padding(
                  key: _explanationKeys[pageIndex],
                  padding: EdgeInsets.all(16 * scale),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Explicação', style: TextStyle(fontSize: 15 * scale, fontWeight: FontWeight.w700, color: kTextColor)),
                      SizedBox(height: 10 * scale),
                      Text(q.explanation!, style: TextStyle(fontSize: 15 * scale, color: kTextColor)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 180 * scale + MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  // --- DREQuestion branch (fixes the cast crash) ---
  if (q is DREQuestion) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          questionCard,
          SizedBox(height: 20 * scale),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0 * scale),
            child: DragMatchDREWidget.fromQuestion(
              q,
              onSubmitted: (allCorrect) {
                setState(() {
                  answeredCorrectList[pageIndex] = allCorrect;
                  totalCorrect = answeredCorrectList.where((e) => e).length;
                });

                if (!allCorrect) {
                  _focusExplanation(pageIndex);
                } else {
                  _focusQuestionTop(pageIndex);
                }
              },
              onSkip: skipQuestion,
              onTotalsChanged: (debit, credit, result) {
                // opcional: você pode atualizar algum estado se precisar mostrar os totais
              },
            ),
          ),
          // DRE widget já mostra explicação quando submetido, mas mantemos uma área explicativa
          _animatedReveal(
            show: showExplanation,
            id: 'dre-explanation-$pageIndex',
            child: Padding(
              padding: EdgeInsets.only(top: 22 * scale),
              child: _flatPanel(
                backgroundColor: kCardColor,
                topLineColor: kPrimaryColor.withOpacity(0.28),
                child: Padding(
                  key: _explanationKeys[pageIndex],
                  padding: EdgeInsets.all(16 * scale),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Explicação', style: TextStyle(fontSize: 15 * scale, fontWeight: FontWeight.w700, color: kTextColor)),
                      SizedBox(height: 10 * scale),
                      Text(q.explanation ?? '', style: TextStyle(fontSize: 15 * scale, color: kTextColor)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 180 * scale + MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  // --- Default: Multiple choice Question (safe check with is) ---
  if (q is Question) {
    final Question mq = q;
    final bool questionLocked = selected != null && !answeredCorrect;

    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          questionCard,
          SizedBox(height: 28 * scale),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0 * scale),
            child: Column(
              children: [
                ...List.generate(mq.options.length, (i) {
                  final isSelected = selected == i;
                  final isCorrect = i == mq.correctIndex;
                  final alreadyTried = incorrectAttempts.contains(i);

                  Color? optionBackground;
                  Color? optionBorderColor;
                  Color? topStripeColor;

                  if (isSelected && isCorrect) {
                    optionBackground = Colors.green.withOpacity(0.14);
                    optionBorderColor = Colors.green.withOpacity(0.65);
                    topStripeColor = Colors.green;
                  } else if (isSelected && !isCorrect) {
                    optionBackground = Colors.red.withOpacity(0.14);
                    optionBorderColor = Colors.red.withOpacity(0.65);
                    topStripeColor = Colors.red;
                  } else if (!isSelected && alreadyTried) {
                    optionBackground = Colors.red.withOpacity(0.08);
                    optionBorderColor = Colors.red.withOpacity(0.28);
                    topStripeColor = Colors.red.withOpacity(0.55);
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10 * scale),
                    child: Card(
                      color: optionBackground ?? kCardColor,
                      elevation: isSelected ? 6 : 3,
                      shadowColor: (isSelected && isCorrect)
                          ? Colors.green.withOpacity(0.35)
                          : (isSelected && !isCorrect)
                              ? Colors.red.withOpacity(0.35)
                              : Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: optionBorderColor ?? Colors.transparent,
                          width: isSelected ? 1.8 : 0.0,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: questionLocked ? null : () => select(pageIndex, i),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (topStripeColor != null)
                              Container(height: 4, width: double.infinity, color: topStripeColor),
                            Padding(
                              padding: EdgeInsets.all(16 * scale),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      mq.options[i],
                                      style: TextStyle(fontSize: 16 * scale, color: kTextColor),
                                    ),
                                  ),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 180),
                                    transitionBuilder: (child, animation) {
                                      final scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(animation);
                                      return ScaleTransition(scale: scaleAnim, child: FadeTransition(opacity: animation, child: child));
                                    },
                                    child: isSelected && isCorrect
                                        ? Container(
                                            key: const ValueKey('correct'),
                                            width: 36 * scale,
                                            height: 36 * scale,
                                            decoration: BoxDecoration(color: Colors.green.withOpacity(0.14), shape: BoxShape.circle),
                                            child: Icon(Icons.check, color: Colors.green, size: 20 * scale),
                                          )
                                        : isSelected && !isCorrect
                                            ? Container(
                                                key: const ValueKey('wrong'),
                                                width: 36 * scale,
                                                height: 36 * scale,
                                                decoration: BoxDecoration(color: Colors.red.withOpacity(0.14), shape: BoxShape.circle),
                                                child: Icon(Icons.close, color: Colors.red, size: 20 * scale),
                                              )
                                            : SizedBox(key: const ValueKey('none'), width: 36 * scale, height: 36 * scale),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                SizedBox(height: 18 * scale),
                _animatedReveal(
                  show: showExplanation,
                  id: 'explanation-$pageIndex',
                  child: Padding(
                    padding: EdgeInsets.only(top: 6 * scale),
                    child: _flatPanel(
                      backgroundColor: kCardColor,
                      topLineColor: kPrimaryColor.withOpacity(0.28),
                      child: Padding(
                        key: _explanationKeys[pageIndex],
                        padding: EdgeInsets.all(16 * scale),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Explicação', style: TextStyle(fontSize: 15 * scale, fontWeight: FontWeight.w700, color: kTextColor)),
                            SizedBox(height: 10 * scale),
                            Text(mq.explanation!, style: TextStyle(fontSize: 15 * scale, color: kTextColor)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 120 * scale + MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // fallback: se for um tipo desconhecido
  return const SizedBox.shrink();
},                     ),
                    ),
                  ),
                ),
const SizedBox(height: 12),
SafeArea(
  top: false,
  child: AnimatedSwitcher(
    duration: const Duration(milliseconds: 250),
    switchInCurve: Curves.easeOutCubic,
    switchOutCurve: Curves.easeInCubic,
    transitionBuilder: (child, animation) {
      final slide = Tween<Offset>(
        begin: const Offset(0, 0.12),
        end: Offset.zero,
      ).animate(animation);

      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: slide,
          child: child,
        ),
      );
    },
    child: (widget.reviewMode || answeredCorrectList[current])
        ? SizedBox(
            key: const ValueKey('next-button'),
            width: double.infinity,
            height: 64,
            child: ElevatedButton.icon(
              onPressed: next,
              icon: const Icon(Icons.arrow_forward, size: 28),
              label: Text(
                current == total - 1 ? 'Concluir nível' : 'Próxima',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          )
        : (selectedIndices[current] != null &&
                !answeredCorrectList[current] &&
                !widget.reviewMode)
            ? Padding(
                key: const ValueKey('retry-skip-buttons'),
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 64,
                        child: OutlinedButton(
                          onPressed: tryAgain,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: kPrimaryColor,
                            side: BorderSide(color: kPrimaryColor.withOpacity(0.35)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Tentar de novo',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 64,
                        child: ElevatedButton(
                          onPressed: skipQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Pular',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(key: ValueKey('no-actions')),
  ),
),
              ],
            ),
          ),
          IgnorePointer(
            ignoring: true,
            child: CustomPaint(
              painter: _SideWavePainter(
                width: _waveWidth,
                onRight: _waveOnRight,
                color: kPrimaryColor.withOpacity(0.18),
                focal: _waveFocal,
                heightFactor: _waveHeightFactor,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
      backgroundColor: kBackgroundColor,
    );
  }
}

class _SideWavePainter extends CustomPainter {
  final double width;
  final bool onRight;
  final Color color;
  final double focal;
  final double heightFactor;

  _SideWavePainter({
    required this.width,
    required this.onRight,
    required this.color,
    required this.focal,
    required this.heightFactor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (width <= 0.5) return;

    final paint = Paint()..color = color;
    final path = Path();
    final w = width.clamp(0.0, size.width * 0.5);
    final midY = (focal.clamp(0.0, 1.0)) * size.height;
    final waveDepth = w;
    final controlDist = waveDepth * (0.6 + 0.6 * heightFactor);
    final verticalOffset = size.height * 0.18 * heightFactor;

    if (onRight) {
      path.moveTo(size.width, 0.0);
      path.lineTo(size.width - waveDepth, 0.0);
      path.quadraticBezierTo(
        size.width - waveDepth - controlDist,
        (midY - verticalOffset).clamp(0.0, size.height),
        size.width - waveDepth,
        midY,
      );
      path.quadraticBezierTo(
        size.width - waveDepth + controlDist,
        (midY + verticalOffset).clamp(0.0, size.height),
        size.width - waveDepth,
        size.height,
      );
      path.lineTo(size.width, size.height);
      path.close();
    } else {
      path.moveTo(0, 0.0);
      path.lineTo(waveDepth, 0.0);
      path.quadraticBezierTo(
        waveDepth + controlDist,
        (midY - verticalOffset).clamp(0.0, size.height),
        waveDepth,
        midY,
      );
      path.quadraticBezierTo(
        waveDepth - controlDist,
        (midY + verticalOffset).clamp(0.0, size.height),
        waveDepth,
        size.height,
      );
      path.lineTo(0, size.height);
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SideWavePainter old) =>
      old.width != width ||
      old.onRight != onRight ||
      old.color != color ||
      old.focal != focal ||
      old.heightFactor != heightFactor;
}