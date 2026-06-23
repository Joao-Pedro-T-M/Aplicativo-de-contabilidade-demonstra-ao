// lib/screens/app_shell.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/sample_course.dart';
import 'course_page.dart';
import '../models/user_model.dart';
import 'package:equition/Utils/progress_storage.dart';
import '../models/course_models.dart';
import '../state/app_state.dart';
import 'simulado_tab.dart';
import 'perfil_tab.dart'; // novo arquivo

const Color kPrimaryColor = Color(0xFF4CB2B2);
const Color kSecondaryTextColor = Color(0xFF2D6B6B);
const Color kTextColor = Color(0xFF0C1C1C);
const Color kBackgroundColor = Color(0xFFFFFFFF);
const Color kCardColor = Color(0xFFFFFFFF);

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.user});
  final UserModel user;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;
  final Map<String, int> _completedPerCourse = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    // inicializa contador zero para cada curso disponível (evita null checks)
    for (final c in courses) {
      _completedPerCourse[c.id] = 0;
    }
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    setState(() => _loading = true);
    try {
      // para cada course na lista, busca os trailIds concluídos (ProgressStorage retorna Set<String>)
      for (final course in courses) {
        try {
          final set = await ProgressStorage.getCompletedTrailIds(course.id, userId: widget.user.id);
          // número de trilhas concluídas = tamanho do set (ids de trilha concluídos)
          _completedPerCourse[course.id] = set.length;
        } catch (e) {
          // em caso de erro só mantém zero (não quebra tudo)
          _completedPerCourse[course.id] = _completedPerCourse[course.id] ?? 0;
        }
      }
    } catch (e) {
      // fallback simples — não impede a UI
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _openCoursePage(BuildContext ctx, Course course) async {
    // removei o named parameter 'allowInternalTabs' (não existe mais)
    await Navigator.of(ctx).push(MaterialPageRoute(builder: (context) => CoursePage(course: course, userId: widget.user.id)));
    await _loadProgress();
  }

  Future<void> _openLessonAsSimulado(BuildContext ctx, int trailIndex, Course course) async {
    final trail = course.trails[trailIndex];
    if (trail.lessons.isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Nenhuma prova disponível nesta trilha.')));
      return;
    }
    await Navigator.of(ctx).push(MaterialPageRoute(builder: (context) => LessonPage(lesson: trail.lessons.first, trailTitle: '${course.title} • ${trail.title}', reviewMode: false)));
    await _loadProgress();
  }

  Widget _coursesTab() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // Lista de cards para cada curso
                ...courses.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final course = entry.value;
                  final completedCount = _completedPerCourse[course.id] ?? 0;
                  return Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    child: InkWell(
                      onTap: () {
                        // seleciona o curso globalmente e muda para a aba "Aprender"
                        context.read<AppState>().selectCourse(course);
                        setState(() => _selectedIndex = 0);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Curso selecionado. Abrindo Aprender...')));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: kPrimaryColor,
                              child: Text('C${idx + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(course.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kTextColor)),
                                const SizedBox(height: 6),
                                Text(course.description.isEmpty ? 'Curso rápido de contabilidade' : course.description, style: const TextStyle(color: kSecondaryTextColor)),
                              ]),
                            ),
                            const SizedBox(width: 12),
                            DonutChart(completed: completedCount, total: course.trails.length, size: 64, strokeWidth: 10),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),

                const SizedBox(height: 12),

                // Se você ainda quer manter a listagem de trilhas do sampleCourse abaixo,
                // mantenha este bloco (ou remova se não for mais necessário):
                ...List.generate(sampleCourse.trails.length, (i) {
                  final t = sampleCourse.trails[i];
                  return ListTile(
                    title: Text(t.title),
                    subtitle: Text(t.description ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_arrow, color: kPrimaryColor),
                      onPressed: () => _openCoursePage(context, sampleCourse),
                    ),
                    onTap: () {
                      context.read<AppState>().selectCourse(sampleCourse);
                      setState(() => _selectedIndex = 0);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Curso selecionado. Abrindo Aprender...')));
                    },
                  );
                }),
              ],
            ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final courseActive = context.watch<AppState>().activeCourse;

    final tabs = <Widget>[
      // Aprender — se houver curso ativo mostra CoursePage (overview embutido),
      // caso contrário mostra a lista de cursos.
      courseActive != null ? CoursePage(course: courseActive, userId: widget.user.id) : _coursesTab(),

      // Simulado — componente individual (aceita courseActive para conteúdo por-curso)
      SimuladoTab(course: courseActive, userId: widget.user.id),

      // Perfil — novo componente separado. Se não houver curso ativo, passamos o sampleCourse para manter contagem.
      PerfilTab(course: courseActive ?? sampleCourse, user: widget.user, userId: widget.user.id),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Equition'), centerTitle: true, backgroundColor: kPrimaryColor),
      body: IndexedStack(index: _selectedIndex, children: tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey[600],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Aprender'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Simulado'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
      backgroundColor: kBackgroundColor,
    );
  }
}

/// DonutChart (mantive igual)
class DonutChart extends StatelessWidget {
  const DonutChart({super.key, required this.completed, required this.total, this.size = 64.0, this.strokeWidth = 10.0});
  final int completed;
  final int total;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final double percent = (total > 0) ? (completed / total).clamp(0.0, 1.0) : 0.0;
    final display = '$completed/$total';
    return SizedBox(
      width: size,
      height: size,
      child: Stack(alignment: Alignment.center, children: [
        CustomPaint(size: Size(size, size), painter: _DonutPainter(progress: percent, bgColor: const Color(0xFFE6F3F3), fgColor: kPrimaryColor, strokeWidth: strokeWidth)),
        Text(display, style: TextStyle(fontSize: size * 0.22, fontWeight: FontWeight.bold, color: kTextColor)),
      ]),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({required this.progress, required this.bgColor, required this.fgColor, required this.strokeWidth});
  final double progress;
  final Color bgColor;
  final Color fgColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width / 2) - strokeWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final bgPaint = Paint()..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round..color = bgColor;
    final fgPaint = Paint()..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round..color = fgColor;
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi, false, bgPaint);
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) => oldDelegate.progress != progress || oldDelegate.bgColor != bgColor || oldDelegate.fgColor != fgColor || oldDelegate.strokeWidth != strokeWidth;
}