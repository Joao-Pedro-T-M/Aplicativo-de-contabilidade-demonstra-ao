// lib/screens/course_home_page.dart
import 'dart:math' as math;
import 'package:equition/models/user_model.dart';
import 'package:flutter/material.dart';
import '../data/sample_course.dart';
import 'course_page.dart';
import 'package:equition/Utils/progress_storage.dart';
import '../models/course_models.dart';

// Paleta local
const Color kPrimaryColor = Color(0xFF4CB2B2);
const Color kSecondaryTextColor = Color(0xFF2D6B6B);
const Color kTextColor = Color(0xFF0C1C1C);
const Color kBackgroundColor = Color(0xFFFFFFFF); // cor de fundo
const Color kCardColor = Color(0xFFFFFFFF);

class CourseHomePage extends StatefulWidget {
  const CourseHomePage({super.key, required this.user});
  final UserModel user;

  @override
  State<CourseHomePage> createState() => _CourseHomePageState();
}

class _CourseHomePageState extends State<CourseHomePage> {
  bool _loading = true;

  /// cache: courseId -> número de trilhas concluídas nesse course
  final Map<String, int> _completedPerCourse = {};

  @override
  void initState() {
    super.initState();
    for (final c in courses) {
      _completedPerCourse[c.id] = 0;
    }
    _loadHomeProgress();
  }

  /// Carrega progresso para todos os cursos (concurrentemente)
  Future<void> _loadHomeProgress() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final futures = courses.map((course) async {
        try {
          final set = await ProgressStorage.getCompletedTrailIds(
            course.id,
            userId: widget.user.id,
          );
          return MapEntry(course.id, set.length);
        } catch (_) {
          return MapEntry(course.id, _completedPerCourse[course.id] ?? 0);
        }
      }).toList();

      final results = await Future.wait(futures);
      for (final e in results) {
        _completedPerCourse[e.key] = e.value;
      }
    } catch (_) {
      // fallback silencioso
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

/// Abre a página do curso e, quando voltar, recarrega progresso apenas se houver mudança.
Future<void> _openCoursePage(BuildContext context, Course course) async {
  final changed = await Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder: (_) => CoursePage(course: course, userId: widget.user.id),
    ),
  );

  // Só recarrega se CoursePage retornou true (houve mudança no progresso)
  if (changed == true) {
    await _loadHomeProgress();
  }
}
  /// Usa o mesmo padrão de cor (kPrimaryColor) para todos os cursos.
  Color _baseColorForCourse(int index) {
    return kPrimaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text(
          'Meus Cursos',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  ...courses.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final course = entry.value;
                    final completedCount = _completedPerCourse[course.id] ?? 0;
                    final total = course.trails.length;
                    final bool filledAll = completedCount >= total;

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final baseColor = _baseColorForCourse(idx);
                        final bool hasClassificationColor =
                            baseColor != kCardColor;
                        final Color effectiveColor = hasClassificationColor
                            ? baseColor
                            : kPrimaryColor;

                        final bool filled = filledAll;
                        final Color background = const Color(0xFFE0F7FA);
                        
                        // Observação: este borderColor pode vir com opacidade aqui,
                        // mas dentro do PressableCourseCard transformamos para sólido.
                        final Color borderColor = filled
                            ? effectiveColor
                            : kPrimaryColor;

                        final double w = constraints.maxWidth.isFinite
                            ? constraints.maxWidth
                            : MediaQuery.of(context).size.width;
                        final double h = constraints.maxHeight.isFinite &&
                                constraints.maxHeight > 0
                            ? constraints.maxHeight
                            : 100.0;
                        final double fontBase = math.min(w, h) * 0.12;
                        final double fontSize = fontBase.clamp(18.0, 28.0);

                        final double iconSize =
                            (fontSize * 2.8).clamp(20.0, 56.0);

                        final List<BoxShadow> threeDShadows = [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            offset: const Offset(0, 8),
                            blurRadius: 14,
                            spreadRadius: -3,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            offset: const Offset(0, 14),
                            blurRadius: 28,
                            spreadRadius: -10,
                          ),
                        ];

                        return PressableCourseCard(
                          course: course,
                          completedCount: completedCount,
                          total: total,
                          filled: filled,
                          background: background,
                          borderColor: borderColor,
                          effectiveColor: effectiveColor,
                          fontSize: fontSize,
                          iconSize: iconSize,
                          threeDShadows: threeDShadows,
                          onTap: () => _openCoursePage(context, course),
                        );
                      },
                    );
                  }).toList(),
                ],
              ),
      ),
    );
  }
}

class PressableCourseCard extends StatefulWidget {
  const PressableCourseCard({
    super.key,
    required this.course,
    required this.completedCount,
    required this.total,
    required this.filled,
    required this.background,
    required this.borderColor,
    required this.effectiveColor,
    required this.fontSize,
    required this.iconSize,
    required this.threeDShadows,
    required this.onTap,
  });

  final Course course;
  final int completedCount;
  final int total;
  final bool filled;
  final Color background;
  final Color borderColor;
  final Color effectiveColor;
  final double fontSize;
  final double iconSize;
  final List<BoxShadow> threeDShadows;
  final VoidCallback onTap;

  @override
  State<PressableCourseCard> createState() => _PressableCourseCardState();
}

class _PressableCourseCardState extends State<PressableCourseCard> with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late final AnimationController _pressController;

  @override
  void initState() {
    super.initState();
    // Controller de pressão: 0.0 = solto, 1.0 = pressionado
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
      reverseDuration: const Duration(milliseconds: 160),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handlePressIn() {
    setState(() => _pressed = true);
    _pressController.forward();
  }

  void _handlePressOut() {
    setState(() => _pressed = false);
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // parâmetros visuais ajustáveis
    const double maxPressOffset = 6.0; // quanto desce no press
    const double maxScaleReduction = 0.015; // quanto reduz no press (ex: 1 - 0.015 = 0.985)

    // inset entre a base (maior) e o card principal (menor)
    final double outerInset = 6.0;
    final double baseTopOverlap = 6.0;
    final EdgeInsets baseMargin = EdgeInsets.only(top: outerInset - baseTopOverlap);
    final Color solidBorder = widget.borderColor.withOpacity(1.0);
    final Color frontColor = _pressed ? solidBorder : widget.background;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 108,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Fundo maior (base)
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                curve: Curves.easeOut,
                margin: baseMargin,
                decoration: BoxDecoration(
                  color: solidBorder,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: solidBorder, width: 1.0),
                ),
              ),
            ),

            // Card principal (front)
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
                  onTapDown: (_) => _handlePressIn(),
                  onTapCancel: () => _handlePressOut(),
                  onTapUp: (_) {
                    // mantemos visual de press por um instante e então "liberamos"
                    Future.delayed(const Duration(milliseconds: 90), () {
                      if (mounted) _handlePressOut();
                    });
                  },
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: AnimatedBuilder(
                    animation: _pressController,
                    builder: (context, child) {
                      final t = _pressController.value;
                      final double pressOffset = maxPressOffset * t; // 0..maxPressOffset
                      final double scale = 1.0 - (maxScaleReduction * t); // 1..~0.985
                      final bool showShadow = t < 0.08; // esconde sombra quando está bem pressionado

                      return Transform.translate(
                        offset: Offset(0, pressOffset),
                        child: Transform.scale(
                          scale: scale,
                          child: Container(
                            decoration: BoxDecoration(
                              color: frontColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: solidBorder,
                                width: widget.filled ? 1.6 : 1.0,
                              ),
                              boxShadow: showShadow ? widget.threeDShadows : null,
                            ),
                            child: child,
                          ),
                        ),
                      );
                    },
                    // conteúdo (child) — mantido fora do builder para performance
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
                                  Icons.school,
                                  size: widget.iconSize,
                                  color: _pressed ? Colors.white : widget.effectiveColor,
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
                                    widget.course.title,
                                    style: TextStyle(
                                      fontSize: widget.fontSize,
                                      fontWeight: FontWeight.w800,
                                      color: _pressed ? Colors.white : kTextColor,
                                      height: 1.02,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            DonutChart(
                              completed: widget.completedCount,
                              total: widget.total,
                              size: 64,
                              strokeWidth: 10,
                              foregroundColor: _pressed ? Colors.white : widget.effectiveColor,
                              backgroundColor: _pressed
                                  ? Colors.white.withOpacity(0.18)
                                  : widget.effectiveColor.withOpacity(0.15),
                            ),

                            const SizedBox(width: 8),

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
/// DonutChart (painter) — mantive idêntico ao seu original
class DonutChart extends StatelessWidget {
  const DonutChart({
    super.key,
    required this.completed,
    required this.total,
    this.size = 64.0,
    this.strokeWidth = 10.0,
    this.backgroundColor = const Color(0xFFE6F3F3),
    this.foregroundColor = kPrimaryColor,
  });

  final int completed;
  final int total;
  final double size;
  final double strokeWidth;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final double percent =
        (total > 0) ? (completed / total).clamp(0.0, 1.0) : 0.0;
    final display = '$completed/$total';

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _DonutPainter(
              progress: percent,
              bgColor: backgroundColor,
              fgColor: foregroundColor,
              strokeWidth: strokeWidth,
            ),
          ),
          Text(
            display,
            style: TextStyle(
              fontSize: size * 0.22,
              fontWeight: FontWeight.bold,
              color: kTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({
    required this.progress,
    required this.bgColor,
    required this.fgColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color bgColor;
  final Color fgColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width / 2) - strokeWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = bgColor;

    final fgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = fgColor;

    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi, false, bgPaint);
    final sweep = 2 * math.pi * progress;
    canvas.drawArc(rect, -math.pi / 2, sweep, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.bgColor != bgColor ||
        oldDelegate.fgColor != fgColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}