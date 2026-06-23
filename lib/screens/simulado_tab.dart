import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:equition/simulado/cfc_2025_01/cfc_exam_history.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../models/course_models.dart';
import '../simulado/cfc_2025_01/cfc_exam_bank.dart';

const Color kPrimaryColor = Color(0xFF4CB2B2);
const Color kAccentColor = Color(0xFFA2D7D7);
const Color kTextColor = Color(0xFF0C1C1C);
const Color kSecondaryTextColor = Color(0xFF2D6B6B);
const Color kBackgroundColor = Color(0xFFFFFFFF);
const Color kCardColor = Color(0xFFE0F7FA);
const Color kQuestionBgColor = Color.fromARGB(255, 153, 190, 190);
const Color kQuestionBorderColor = Color.fromARGB(255, 133, 176, 176);
const Color kOptionBgColor = Color(0xFFF7FCFC);
const Color kOptionBorderColor = Color(0xFFCAE7E7);

class SimuladoTab extends StatefulWidget {
  final Course? course;
  final String? userId;
  final ValueChanged<bool>? onUiStateChanged;
  final VoidCallback? onLoaded;

  const SimuladoTab({
    super.key,
    required this.course,
    required this.userId,
    this.onUiStateChanged,
    this.onLoaded,
  });

  @override
  State<SimuladoTab> createState() => _SimuladoTabState();
}

enum TrendChartMode { total, bySubject }

class _SimuladoTabState extends State<SimuladoTab> with WidgetsBindingObserver {
  double _tableScale = 1.0;
  int? _selectedReviewIndex;
  final Set<String> _selectedSubjects = {};
  final Set<int> _selectedYears = {};
  final Map<String, String> _answers = {};
  final Map<String, CfcQuestionHistory> _stats = {};
  final Map<String, Map<String, int>> _dailySubjectCount = {};

  TrendChartMode _trendChartMode = TrendChartMode.total;
  final Map<String, Color> _subjectColors = {};

  static const List<Color> _colorChoices = [
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.indigo,
    Colors.brown,
    Colors.pink,
    Colors.amber,
    Colors.cyan,
    Colors.deepOrange,
    Colors.lime,
    Colors.lightBlue,
    Colors.deepPurple,
    Colors.black,
  ];

  int _questionCount = 10;
  bool _useTimer = false;
  int _secondsPerQuestion = 60;
  int _remainingSeconds = 0;
  Timer? _timer;

  List<ExamQuestion> _bank = [];
  List<ExamQuestion> _session = [];
  int _currentIndex = 0;
  bool _started = false;
  bool _finished = false;
  bool _loading = true;
  bool _showGabarito = false;

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addObserver(this);
  _loadQuestionBank();
}

@override
void didUpdateWidget(covariant SimuladoTab oldWidget) {
  super.didUpdateWidget(oldWidget);

  if (oldWidget.userId != widget.userId) {
    _timer?.cancel();
    setState(() {
      _loading = true;
      _tableScale = 1.0;
      _selectedReviewIndex = null;
      _selectedSubjects.clear();
      _selectedYears.clear();
      _answers.clear();
      _stats.clear();
      _dailySubjectCount.clear();
      _session = [];
      _currentIndex = 0;
      _started = false;
      _finished = false;
      _showGabarito = false;
      _remainingSeconds = 0;
    });

    _loadQuestionBank();
  }
}

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _saveProgress();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _saveProgress();
    }
  }

  Future<File> _progressFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'simulado_progress_${widget.userId ?? 'guest'}.json';
    return File('${dir.path}/$fileName');
  }

Map<String, dynamic> _progressToJson() {
  return {
    'tableScale': _tableScale,
    'selectedSubjects': _selectedSubjects.toList(),
    'selectedYears': _selectedYears.toList(),
    'questionCount': _questionCount,
    'useTimer': _useTimer,
    'secondsPerQuestion': _secondsPerQuestion,
    'remainingSeconds': _remainingSeconds,
    'currentIndex': _currentIndex,
    'started': _started,
    'finished': _finished,
    'showGabarito': _showGabarito,
    'sessionIds': _session.map((q) => q.id).toList(),
    'answers': _answers,
    'stats': _stats.map((k, v) => MapEntry(k, v.toJson())),
    'dailySubjectCount': _dailySubjectCount,
    'trendChartMode': _trendChartMode.name,
    'subjectColors': _subjectColors.map((k, v) => MapEntry(k, v.value)),
    'savedAt': DateTime.now().toIso8601String(),
  };
}

  Future<void> _saveProgress() async {
    try {
      final file = await _progressFile();
      await file.writeAsString(jsonEncode(_progressToJson()));
    } catch (e) {
      debugPrint('Erro ao salvar progresso: $e');
    }
  }

Future<void> _loadQuestionBank() async {
  final data = await CfcExamBank.load();
  if (!mounted) return;

  _bank = data;
  await _loadProgress();

  if (!mounted) return;
  setState(() {
    _loading = false;
  });

  widget.onLoaded?.call();
}

  Future<void> _loadProgress() async {
    try {
      final file = await _progressFile();
      if (!await file.exists()) return;

      final raw = await file.readAsString();
      if (raw.trim().isEmpty) return;

      final data = jsonDecode(raw) as Map<String, dynamic>;

      _tableScale = (data['tableScale'] as num?)?.toDouble() ?? _tableScale;

      _selectedSubjects
        ..clear()
        ..addAll((data['selectedSubjects'] as List? ?? []).map((e) => e.toString()));

      _selectedYears
        ..clear()
        ..addAll(
          (data['selectedYears'] as List? ?? [])
              .map((e) => int.tryParse(e.toString()))
              .whereType<int>(),
        );

      _questionCount = (data['questionCount'] as num?)?.toInt() ?? _questionCount;
      _useTimer = data['useTimer'] as bool? ?? _useTimer;
      _secondsPerQuestion =
          (data['secondsPerQuestion'] as num?)?.toInt() ?? _secondsPerQuestion;
      _remainingSeconds =
          (data['remainingSeconds'] as num?)?.toInt() ?? _remainingSeconds;
      _currentIndex = (data['currentIndex'] as num?)?.toInt() ?? 0;
      _started = data['started'] as bool? ?? false;
      _finished = data['finished'] as bool? ?? false;
      _showGabarito = data['showGabarito'] as bool? ?? false;

      _answers
        ..clear()
        ..addAll(
          (data['answers'] as Map? ?? {}).map(
            (key, value) => MapEntry(key.toString(), value.toString()),
          ),
        );

      _stats
        ..clear()
        ..addEntries(
          (data['stats'] as Map? ?? {}).entries.map((e) {
            final value = e.value;
            if (value is Map) {
              return MapEntry(
                e.key.toString(),
                CfcQuestionHistory.fromJson(
                  Map<String, dynamic>.from(value),
                ),
              );
            }
            return MapEntry(
              e.key.toString(),
              CfcQuestionHistory(questionId: e.key.toString()),
            );
          }),
        );

      _dailySubjectCount
        ..clear()
        ..addEntries(
          (data['dailySubjectCount'] as Map? ?? {}).entries.map((e) {
            final rawInner = e.value as Map? ?? {};
            final inner = <String, int>{};
            for (final entry in rawInner.entries) {
              final parsed = int.tryParse(entry.value.toString()) ?? 0;
              inner[entry.key.toString()] = parsed;
            }
            return MapEntry(e.key.toString(), inner);
          }),
        );

      final savedSessionIds = (data['sessionIds'] as List? ?? [])
          .map((e) => e.toString())
          .toList();

      final bankById = {for (final q in _bank) q.id: q};
      final restoredSession = <ExamQuestion>[
        for (final id in savedSessionIds)
          if (bankById[id] != null) bankById[id]!,
      ];

      if (savedSessionIds.isNotEmpty && restoredSession.isNotEmpty) {
        _session = restoredSession;
      } else {
        _session = [];
        _started = false;
        _finished = false;
        _showGabarito = false;
        _currentIndex = 0;
        _remainingSeconds = 0;
        _answers.clear();
      }

final savedAtRaw = data['savedAt']?.toString();
final savedAt = savedAtRaw == null ? null : DateTime.tryParse(savedAtRaw);

_trendChartMode = TrendChartMode.values.firstWhere(
  (e) => e.name == (data['trendChartMode'] as String? ?? 'total'),
  orElse: () => TrendChartMode.total,
);

_subjectColors
  ..clear()
  ..addEntries(
    (data['subjectColors'] as Map? ?? {}).entries.map((e) {
      return MapEntry(
        e.key.toString(),
        Color((e.value as num?)?.toInt() ?? kPrimaryColor.value),
      );
    }),
  );

if (_started && !_finished && _useTimer && savedAt != null) {
  final elapsed = DateTime.now().difference(savedAt).inSeconds;
  _remainingSeconds = math.max(0, _remainingSeconds - elapsed);
}

if (_started && !_finished && _useTimer && _session.isNotEmpty) {
  widget.onUiStateChanged?.call(true);

  if (_remainingSeconds <= 0) {
    _finishExam();
  } else {
    _resumeTimer();
  }
}
    } catch (e) {
      debugPrint('Erro ao carregar progresso: $e');
    }
  }

  List<String> get _allSubjects {
    final subjects = <String>{};
    for (final q in _bank) {
      subjects.add(q.subject);
    }
    return subjects.toList()..sort();
  }

  List<int> get _allYears {
    final years = <int>{};
    for (final q in _bank) {
      years.add(q.examYear);
    }
    return years.toList()..sort();
  }

  List<ExamQuestion> _filteredQuestions() {
    return _bank.where((q) {
      final subjectOk =
          _selectedSubjects.isEmpty || _selectedSubjects.contains(q.subject);
      final yearOk = _selectedYears.isEmpty || _selectedYears.contains(q.examYear);
      return subjectOk && yearOk;
    }).toList();
  }

  String _selectionPreview<T>(Set<T> selected, List<T> all) {
    if (selected.isEmpty) return 'Todas';
    final items = selected.take(2).map((e) => e.toString()).toList();
    final remaining = selected.length - items.length;
    if (remaining > 0) {
      return '${items.join(', ')} +$remaining';
    }
    return items.join(', ');
  }

  String _formatTime(int seconds) {
    if (seconds < 60) {
      return '00:${seconds.toString().padLeft(2, '0')}';
    }

    if (seconds < 3600) {
      final minutes = seconds ~/ 60;
      final secs = seconds % 60;

      if (secs == 0) return '${minutes}min';
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }

    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (secs == 0) {
      if (minutes == 0) return '${hours}h';
      return '${hours}h${minutes.toString().padLeft(2, '0')}';
    }

    if (minutes == 0) return '${hours}h';
    return '${hours}h${minutes.toString().padLeft(2, '0')}';
  }

  String _dayKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  DateTime _parseDayKey(String key) {
    return DateTime.parse('${key}T00:00:00');
  }

Color _seriesColor(int index) {
  final hue = (index * 137.508) % 360;
  return HSLColor.fromAHSL(1, hue, 0.65, 0.52).toColor();
}

Color _colorForSubject(String subject, int index) {
  return _subjectColors[subject] ?? _seriesColor(index);
}

void _registerSessionStudy() {
  if (_session.isEmpty) return;

  final dayKey = _dayKey(DateTime.now());
  final bucket = _dailySubjectCount.putIfAbsent(dayKey, () => {});

  for (final q in _session) {
    bucket[q.subject] = (bucket[q.subject] ?? 0) + 1;
  }
}

List<DateTime> _historyDays({int maxDays = 30}) {
  final days = _dailySubjectCount.keys.map(_parseDayKey).toList()..sort();
  if (days.length <= maxDays) return days;
  return days.sublist(days.length - maxDays);
}

List<String> _subjectsForDays(List<DateTime> days) {
  final totals = <String, int>{};

  for (final day in days) {
    final bucket = _dailySubjectCount[_dayKey(day)] ?? {};
    for (final entry in bucket.entries) {
      totals[entry.key] = (totals[entry.key] ?? 0) + entry.value;
    }
  }

  final sorted = totals.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  return sorted.map((e) => e.key).toList();
}

List<int> _buildTotalSeries(List<DateTime> days) {
  return List<int>.generate(days.length, (i) {
    final bucket = _dailySubjectCount[_dayKey(days[i])] ?? {};
    return bucket.values.fold<int>(0, (sum, value) => sum + value);
  });
}

Map<String, List<int>> _buildSeriesBySubject(
  List<DateTime> days,
  List<String> subjects,
) {
  final result = <String, List<int>>{
    for (final subject in subjects) subject: List<int>.filled(days.length, 0),
  };

  for (int i = 0; i < days.length; i++) {
    final bucket = _dailySubjectCount[_dayKey(days[i])] ?? {};
    for (final entry in bucket.entries) {
      final line = result[entry.key];
      if (line != null) {
        line[i] += entry.value;
      }
    }
  }

  return result;
}

Future<void> _chooseSubjectColor(String subject) async {
  final picked = await showDialog<Color>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Cor para $subject'),
      content: SizedBox(
        width: 320,
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final color in _colorChoices)
              InkWell(
                onTap: () => Navigator.of(context).pop(color),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12),
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
      ],
    ),
  );

  if (picked != null) {
    setState(() => _subjectColors[subject] = picked);
    _saveProgress();
  }
}

  List<ExamQuestion> _buildSession() {
    final filtered = _filteredQuestions();
    if (filtered.isEmpty) return [];
    filtered.shuffle();
    final count = _questionCount.clamp(1, filtered.length);
    return filtered.take(count).toList();
  }

  void _resumeTimer() {
    _timer?.cancel();

    if (!_useTimer || !_started || _finished || _remainingSeconds <= 0) {
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (_remainingSeconds <= 1) {
        timer.cancel();
        _finishExam();
        return;
      }

      setState(() {
        _remainingSeconds--;
      });

      _saveProgress();
    });
  }

  void _startExam() {
    widget.onUiStateChanged?.call(true);

    final session = _buildSession();

    setState(() {
      _session = session;
      _answers.clear();
      _currentIndex = 0;
      _started = true;
      _finished = false;
      _showGabarito = false;
      _remainingSeconds = _useTimer ? session.length * _secondsPerQuestion : 0;
    });

    _saveProgress();
    _resumeTimer();
  }

  void _chooseAnswer(String option) {
    if (_showGabarito) return;

    final question = _session[_currentIndex];
    setState(() {
      _answers[question.id] = option;
    });

    _saveProgress();
  }

  void _showAnswer() {
    setState(() {
      _showGabarito = true;
    });

    _saveProgress();
  }

  void _next() {
    if (_currentIndex < _session.length - 1) {
      setState(() {
        _currentIndex++;
        _showGabarito = false;
      });
      _saveProgress();
    } else {
      _finishExam();
    }
  }

  void _previous() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showGabarito = false;
      });
      _saveProgress();
    }
  }

  void _finishExam() {
    _timer?.cancel();

    setState(() {
      for (final q in _session) {
        final chosen = _answers[q.id];
        final old = _stats[q.id] ?? CfcQuestionHistory(questionId: q.id);

        if (chosen == null) {
          _stats[q.id] = old.copyWith(
            lastSeenAt: DateTime.now(),
          );
        } else {
          final isCorrect = chosen == q.correctOption;

          _stats[q.id] = old.copyWith(
            rightCount: isCorrect ? old.rightCount + 1 : old.rightCount,
            wrongCount: isCorrect ? old.wrongCount : old.wrongCount + 1,
            lastWrongAt: isCorrect ? old.lastWrongAt : DateTime.now(),
            lastSeenAt: DateTime.now(),
          );
        }
      }

      _registerSessionStudy();
      _finished = true;
    });

    _saveProgress();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_started) return _buildStartScreen();
    if (_finished) return _buildReviewScreen();
    return _buildQuizScreen();
  }

Widget _buildStartScreen() {
  final availableQuestions = _filteredQuestions().length;
  final maxQuestions = availableQuestions > 0 ? availableQuestions : 1;
  final currentQuestionCount = _questionCount.clamp(1, maxQuestions).toInt();
  final currentSecondsPerQuestion = _secondsPerQuestion.clamp(30, 400).toInt();

  return Scaffold(
    appBar: AppBar(
      backgroundColor: kPrimaryColor,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: const Text(
        'Simulado CFC',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          const Text(
            'Simulado CFC',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),

          Card(
            elevation: 0,
            color: kCardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: kQuestionBorderColor.withOpacity(0.35)),
            ),
            child: ExpansionTile(
              initiallyExpanded: false,
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              title: Text(
                'Filtrar matérias (${_selectedSubjects.length}/${_allSubjects.length})',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                _selectionPreview(_selectedSubjects, _allSubjects),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 180),
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _allSubjects.map((subject) {
                          final selected = _selectedSubjects.contains(subject);
                          return FilterChip(
                            label: Text(
                              subject,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: selected ? Colors.white : kTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            selected: selected,
                            showCheckmark: false,
                            selectedColor: kPrimaryColor,
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: selected
                                  ? kPrimaryColor
                                  : kQuestionBorderColor.withOpacity(0.45),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            onSelected: (_) {
                              setState(() {
                                if (selected) {
                                  _selectedSubjects.remove(subject);
                                } else {
                                  _selectedSubjects.add(subject);
                                }
                              });
                              _saveProgress();
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Card(
            elevation: 0,
            color: kCardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: kQuestionBorderColor.withOpacity(0.35)),
            ),
            child: ExpansionTile(
              initiallyExpanded: false,
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              title: Text(
                'Filtrar anos (${_selectedYears.length}/${_allYears.length})',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                _selectedYears.isEmpty
                    ? 'Todos'
                    : _selectedYears.take(3).map((e) => e.toString()).join(', ') +
                        (_selectedYears.length > 3 ? ' +${_selectedYears.length - 3}' : ''),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 140),
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _allYears.map((year) {
                          final selected = _selectedYears.contains(year);
                          return FilterChip(
                            label: Text(
                              year.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: selected ? Colors.white : kTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            selected: selected,
                            showCheckmark: false,
                            selectedColor: kPrimaryColor,
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: selected
                                  ? kPrimaryColor
                                  : kQuestionBorderColor.withOpacity(0.45),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            onSelected: (_) {
                              setState(() {
                                if (selected) {
                                  _selectedYears.remove(year);
                                } else {
                                  _selectedYears.add(year);
                                }
                              });
                              _saveProgress();
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Card(
            elevation: 0,
            color: kCardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: kQuestionBorderColor.withOpacity(0.35)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Quantidade de questões',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selecionadas: $currentQuestionCount questões',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: 54,
                        height: 44,
                        child: OutlinedButton(
                          onPressed: currentQuestionCount <= 1
                              ? null
                              : () {
                                  setState(() {
                                    _questionCount =
                                        (currentQuestionCount - 1).clamp(1, maxQuestions).toInt();
                                  });
                                  _saveProgress();
                                },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            '<',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: kQuestionBorderColor.withOpacity(0.35)),
                          ),
                          child: Text(
                            '$currentQuestionCount',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 54,
                        height: 44,
                        child: OutlinedButton(
                          onPressed: currentQuestionCount >= maxQuestions
                              ? null
                              : () {
                                  setState(() {
                                    _questionCount =
                                        (currentQuestionCount + 1).clamp(1, maxQuestions).toInt();
                                  });
                                  _saveProgress();
                                },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            '>',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: currentQuestionCount.toDouble(),
                    min: 1,
                    max: maxQuestions.toDouble(),
                    divisions: maxQuestions > 1 ? maxQuestions - 1 : 1,
                    label: '$currentQuestionCount',
                    activeColor: kPrimaryColor,
                    inactiveColor: kPrimaryColor.withOpacity(0.2),
                    onChanged: availableQuestions == 0
                        ? null
                        : (value) {
                            setState(() {
                              _questionCount = value.round();
                            });
                            _saveProgress();
                          },
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Ativar tempo',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      _useTimer
                          ? 'Tempo total: ${_formatTime(currentQuestionCount * currentSecondsPerQuestion)}'
                          : 'Simulado sem contagem regressiva',
                    ),
                    value: _useTimer,
                    onChanged: (value) {
                      setState(() {
                        _useTimer = value;
                      });
                      _saveProgress();
                    },
                  ),
                  if (_useTimer) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Tempo por questão',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selecionado: ${currentSecondsPerQuestion}s',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: 54,
                          height: 44,
                          child: OutlinedButton(
                            onPressed: currentSecondsPerQuestion <= 30
                                ? null
                                : () {
                                    setState(() {
                                      _secondsPerQuestion =
                                          (currentSecondsPerQuestion - 30).clamp(30, 400).toInt();
                                    });
                                    _saveProgress();
                                  },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              '<',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: kQuestionBorderColor.withOpacity(0.35)),
                            ),
                            child: Text(
                              '${currentSecondsPerQuestion}s',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 54,
                          height: 44,
                          child: OutlinedButton(
                            onPressed: currentSecondsPerQuestion >= 400
                                ? null
                                : () {
                                    setState(() {
                                      _secondsPerQuestion =
                                          (currentSecondsPerQuestion + 30).clamp(30, 400).toInt();
                                    });
                                    _saveProgress();
                                  },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              '>',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: currentSecondsPerQuestion.toDouble(),
                      min: 30,
                      max: 400,
                      divisions: 4,
                      label: '$currentSecondsPerQuestion s',
                      activeColor: kPrimaryColor,
                      inactiveColor: kPrimaryColor.withOpacity(0.2),
                      onChanged: (value) {
                        setState(() {
                          _secondsPerQuestion = value.round();
                        });
                        _saveProgress();
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            elevation: 0,
            color: kCardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: kQuestionBorderColor.withOpacity(0.35)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Evolução por matéria',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                 Text(
  _historyDays(maxDays: 30).isEmpty
      ? 'Ainda não há histórico suficiente para gerar o gráfico.'
      : _trendChartMode == TrendChartMode.total
          ? 'Últimos 30 dias em linha única.'
          : 'Últimos 30 dias por matéria. Toque na legenda para escolher a cor.',
  style: TextStyle(
    color: Colors.grey.shade700,
    fontWeight: FontWeight.w600,
    fontSize: 12,
  ),
),
                  const SizedBox(height: 14),
                  if (_historyDays(maxDays: 30).isEmpty)
                    Container(
                      height: 180,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kQuestionBorderColor.withOpacity(0.35)),
                      ),
                      child: const Text(
                        'Faça alguns simulados para ver a evolução aqui.',
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    _buildTrendChart(_historyDays(maxDays: 30)),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SizedBox(
        height: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: availableQuestions == 0 ? null : _startExam,
          child: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Iniciar simulado',
              maxLines: 1,
              softWrap: false,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    ),
  );
}
Widget _buildTrendChart(List<DateTime> days) {
  final showBySubject = _trendChartMode == TrendChartMode.bySubject;
  final subjects = showBySubject ? _subjectsForDays(days) : <String>[];

  final series = showBySubject
      ? _buildSeriesBySubject(days, subjects)
      : {'Total': _buildTotalSeries(days)};

  final colors = showBySubject
      ? {
          for (int i = 0; i < subjects.length; i++)
            subjects[i]: _colorForSubject(subjects[i], i),
        }
      : {'Total': kPrimaryColor};

  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Modo do gráfico'),
        subtitle: Text(
          showBySubject
              ? 'Cada matéria aparece com a sua cor.'
              : 'Modo padrão: uma única linha total.',
        ),
        value: showBySubject,
        onChanged: (value) {
          setState(() {
            _trendChartMode =
                value ? TrendChartMode.bySubject : TrendChartMode.total;
          });
          _saveProgress();
        },
      ),
      SizedBox(
        height: 240,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: math.max(320.0, days.length * 26.0),
            child: CustomPaint(
              painter: _TrendChartPainter(
                days: days,
                series: series,
                colors: colors,
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 12),
      if (showBySubject)
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            for (int i = 0; i < subjects.length; i++)
              InkWell(
                onTap: () => _chooseSubjectColor(subjects[i]),
                borderRadius: BorderRadius.circular(999),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: colors[subjects[i]]!,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        subjects[i],
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.palette_outlined,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        )
      else
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'Total',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
    ],
  );
}

  Widget _buildQuizScreen() {
    final question = _session[_currentIndex];
    final selected = _answers[question.id];
    final hasAnswer = selected != null;
    final correct = hasAnswer && selected == question.correctOption;
    final showNeutralGabarito = _showGabarito && !hasAnswer;
    final isLastQuestion = _currentIndex == _session.length - 1;

    return Scaffold(
appBar: AppBar(
  backgroundColor: kPrimaryColor,
  centerTitle: true,
  elevation: 2,
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () async {
      final sair = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sair do simulado?'),
          content: const Text(
            'Tem certeza que deseja sair da tela das questões e voltar para a tela inicial?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sair'),
            ),
          ],
        ),
      );

      if (sair == true) {
        _timer?.cancel();
        widget.onUiStateChanged?.call(false);

        setState(() {
          _started = false;
          _finished = false;
          _showGabarito = false;
          _currentIndex = 0;
          _selectedReviewIndex = null;
          _session = [];
          _answers.clear();
          _remainingSeconds = 0;
        });

        _saveProgress();
      }
    },
  ),
  title: Text(
    'Questão ${_currentIndex + 1} de ${_session.length}',
    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
  ),
  bottom: PreferredSize(
    preferredSize: const Size.fromHeight(6),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: LinearProgressIndicator(
        value: (_currentIndex + 1) / _session.length,
        backgroundColor: Colors.white.withOpacity(0.22),
        valueColor: const AlwaysStoppedAnimation<Color>(kSecondaryTextColor),
        minHeight: 6,
      ),
    ),
  ),
),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_useTimer)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Card(
                      elevation: 0,
                      color: _remainingSeconds <= 30 ? Colors.red.shade50 : kCardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: _remainingSeconds <= 30
                              ? Colors.red.shade200
                              : kQuestionBorderColor.withOpacity(0.35),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              color: _remainingSeconds <= 30 ? Colors.red : kPrimaryColor,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Tempo restante',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const Spacer(),
                            Text(
                              _formatTime(_remainingSeconds),
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: _remainingSeconds <= 30 ? Colors.red : kTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildStatementPanel(question),
                      const SizedBox(height: 12),
                      ...List.generate(question.options.length, (i) {
                        final optionLetter = String.fromCharCode(65 + i);
                        final optionText = question.options[i];
                        final isSelected = selected == optionLetter;
                        final isCorrectOption =
                            _showGabarito && optionLetter == question.correctOption;
                        final isWrongSelected =
                            _showGabarito && isSelected && optionLetter != question.correctOption;

                        Color optionColor = kOptionBgColor;
                        Color borderColor = kOptionBorderColor;
                        Color accentColor = kPrimaryColor;

                        if (_showGabarito) {
                          if (isCorrectOption) {
                            optionColor = Colors.green.shade50;
                            borderColor = Colors.green.shade300;
                            accentColor = Colors.green;
                          } else if (isWrongSelected) {
                            optionColor = Colors.red.shade50;
                            borderColor = Colors.red.shade300;
                            accentColor = Colors.red;
                          } else if (isSelected) {
                            optionColor = Colors.blue.shade50;
                            borderColor = Colors.blue.shade300;
                            accentColor = Colors.blue;
                          }
                        } else if (isSelected) {
                          optionColor = kAccentColor.withOpacity(0.30);
                          borderColor = kPrimaryColor.withOpacity(0.85);
                          accentColor = kPrimaryColor;
                        }

                        return Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOutCubic,
                            decoration: BoxDecoration(
                              color: optionColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: borderColor,
                                width: isSelected ? 1.8 : 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(isSelected ? 0.08 : 0.04),
                                  blurRadius: isSelected ? 12 : 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              clipBehavior: Clip.antiAlias,
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                onTap: _showGabarito ? null : () => _chooseAnswer(optionLetter),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(14),
                                      ),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 180),
                                        curve: Curves.easeOutCubic,
                                        height: 4,
                                        width: double.infinity,
                                        color: isSelected ? accentColor : Colors.transparent,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 14,
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 34,
                                            child: const SizedBox.shrink(),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              optionText,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                height: 1.35,
                                                color: kTextColor,
                                                fontWeight: FontWeight.w500,
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
                          ),
                        );
                      }),
                      const SizedBox(height: 12),
                      if (_showGabarito) ...[
                        _buildGabaritoPanel(
                          question: question,
                          selected: selected,
                          correct: correct,
                          showNeutralGabarito: showNeutralGabarito,
                        ),
                      ],
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: _currentIndex == 0 ? null : _previous,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: kPrimaryColor,
                              side: BorderSide(color: kPrimaryColor.withOpacity(0.35)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Voltar',
                                maxLines: 1,
                                softWrap: false,
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: _showGabarito ? null : _showAnswer,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: kPrimaryColor,
                              side: BorderSide(color: kPrimaryColor.withOpacity(0.35)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Ver Gabarito',
                                maxLines: 1,
                                softWrap: false,
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _next,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                isLastQuestion ? 'Finalizar Simulado' : 'Próxima',
                                maxLines: 1,
                                softWrap: false,
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildStatementPanel(ExamQuestion question) {
    final blocks = _parseStatementBlocks(question.statement);
    final tableScale = _tableScale.clamp(0.50, 1.0);

    final hasDreTable = question.dreTableHeaders != null &&
        question.dreTableRows != null &&
        question.dreTableHeaders!.isNotEmpty &&
        question.dreTableRows!.isNotEmpty;

    final hasTable = question.tableHeaders != null &&
        question.tableRows != null &&
        question.tableHeaders!.isNotEmpty &&
        question.tableRows!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          decoration: BoxDecoration(
            color: kQuestionBgColor,
            borderRadius: BorderRadius.zero,
            border: Border.all(color: kQuestionBorderColor.withOpacity(0.95), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...blocks.map((block) {
                if (block.isTitle) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.35)),
                    ),
                    child: Text(
                      block.text ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: kTextColor,
                        height: 1.35,
                      ),
                    ),
                  );
                }

                final text = (block.text ?? '').trim();
                if (text.isEmpty) return const SizedBox.shrink();

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.55)),
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.45,
                      color: kTextColor,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        if (hasDreTable || hasTable) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Tamanho da tabela',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                '${(tableScale * 100).round()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: kSecondaryTextColor,
                ),
              ),
            ],
          ),
          Slider(
            value: tableScale,
            min: 0.50,
            max: 1.0,
            divisions: 10,
            label: '${(tableScale * 100).round()}%',
            activeColor: kPrimaryColor,
            inactiveColor: kPrimaryColor.withOpacity(0.2),
            onChanged: (value) {
              setState(() {
                _tableScale = value;
              });
              _saveProgress();
            },
          ),
        ],
        if (hasDreTable)
          _buildDataTable(
            question.dreTableHeaders!,
            question.dreTableRows!,
            tableScale: tableScale,
          ),
        if (hasTable)
          _buildDataTable(
            question.tableHeaders!,
            question.tableRows!,
            tableScale: tableScale,
          ),
      ],
    );
  }

  Widget _buildGabaritoPanel({
    required ExamQuestion question,
    required String? selected,
    required bool correct,
    required bool showNeutralGabarito,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: showNeutralGabarito
            ? Colors.grey.shade50
            : (correct ? Colors.green.shade50 : Colors.red.shade50),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: showNeutralGabarito
              ? Colors.grey.shade300
              : (correct ? Colors.green.shade200 : Colors.red.shade200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Gabarito: ${question.correctOption}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: showNeutralGabarito
                  ? Colors.grey.shade800
                  : (correct ? Colors.green.shade900 : Colors.red.shade900),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sua resposta: ${selected ?? "-"}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (selected == null)
            const Text(
              'Você pode avançar sem responder. Essa questão não será contada como erro.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          const SizedBox(height: 8),
          const Text(
            'Explicação:',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(question.explanation),
        ],
      ),
    );
  }

  Widget _buildDataTable(
    List<String> headers,
    List<List<String>> rows, {
    required double tableScale,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12 * tableScale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kQuestionBorderColor.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStatePropertyAll(kPrimaryColor.withOpacity(0.12)),
          columnSpacing: 16 * tableScale,
          horizontalMargin: 12 * tableScale,
          dataRowMinHeight: 34 * tableScale,
          dataRowMaxHeight: 70 * tableScale,
          headingRowHeight: 42 * tableScale,
          columns: headers
              .map(
                (h) => DataColumn(
                  label: Text(
                    h,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14 * tableScale,
                      color: kTextColor,
                    ),
                  ),
                ),
              )
              .toList(),
          rows: rows
              .map(
                (row) => DataRow(
                  cells: List.generate(
                    headers.length,
                    (index) => DataCell(
                      Text(
                        index < row.length ? row[index] : '',
                        style: TextStyle(
                          fontSize: 13 * tableScale,
                          height: 1.2,
                          color: kTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  List<_StatementBlock> _parseStatementBlocks(String statement) {
    final lines = statement.replaceAll('\r\n', '\n').split('\n');
    final blocks = <_StatementBlock>[];

    if (lines.isEmpty) return blocks;

    int index = 0;
    final firstLine = lines.first.trim();

    final hasTitle = firstLine.isNotEmpty &&
        (firstLine.contains('FGV') ||
            firstLine.contains('CFC') ||
            firstLine.contains('EXAME') ||
            firstLine.contains('|'));

    if (hasTitle) {
      blocks.add(_StatementBlock.text(firstLine, isTitle: true));
      index = 1;
    }

    final textBuffer = <String>[];
    final tableRows = <List<String>>[];

    void flushText() {
      if (textBuffer.isNotEmpty) {
        blocks.add(_StatementBlock.text(textBuffer.join('\n').trim()));
        textBuffer.clear();
      }
    }

    void flushTable() {
      if (tableRows.isNotEmpty) {
        blocks.add(_StatementBlock.table(List<List<String>>.from(tableRows)));
        tableRows.clear();
      }
    }

    for (; index < lines.length; index++) {
      final line = lines[index].trim();

      if (line.isEmpty) {
        flushText();
        flushTable();
        continue;
      }

      final yearRow = RegExp(r'^(\d{4})\s*:\s*(.+?)\s*/\s*(.+)$').firstMatch(line);
      if (yearRow != null) {
        flushText();
        tableRows.add([
          yearRow.group(1)!.trim(),
          yearRow.group(2)!.trim(),
          yearRow.group(3)!.trim(),
        ]);
        continue;
      }

      final pipeRow = RegExp(r'^(.+?)\s*\|\s*(.+?)\s*\|\s*(.+)$').firstMatch(line);
      if (pipeRow != null) {
        flushText();
        tableRows.add([
          pipeRow.group(1)!.trim(),
          pipeRow.group(2)!.trim(),
          pipeRow.group(3)!.trim(),
        ]);
        continue;
      }

      flushTable();
      textBuffer.add(line);
    }

    flushText();
    flushTable();

    if (blocks.isEmpty) {
      blocks.add(_StatementBlock.text(statement.trim()));
    }

    return blocks;
  }
  Widget _buildReviewScreen() {
    final items = _session.asMap().entries.toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Simulado CFC',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Revisão do simulado',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final entry in items)
                  _buildReviewCard(
                    entry.value,
                    entry.key + 1,
                    index: entry.key,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (_selectedReviewIndex != null &&
                _selectedReviewIndex! >= 0 &&
                _selectedReviewIndex! < _session.length)
              _buildReviewDetails(
                _session[_selectedReviewIndex!],
                _selectedReviewIndex! + 1,
              ),
            const SizedBox(height: 90),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                _timer?.cancel();
                widget.onUiStateChanged?.call(false);
                setState(() {
                  _started = false;
                  _finished = false;
                  _showGabarito = false;
                  _currentIndex = 0;
                  _selectedReviewIndex = null;
                  _session = [];
                  _answers.clear();
                  _remainingSeconds = 0;
                });
                _saveProgress();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Novo simulado'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(
    ExamQuestion q,
    int questionNumber, {
    required int index,
  }) {
    final chosen = _answers[q.id];
    final answered = chosen != null;
    final correct = answered && chosen == q.correctOption;
    final stat = _stats[q.id] ?? CfcQuestionHistory(questionId: q.id);

    final Color cardColor = !answered
        ? Colors.grey.shade50
        : (correct ? Colors.green.shade50 : Colors.red.shade50);

    final Color borderColor = !answered
        ? Colors.grey.shade300
        : (correct ? Colors.green.shade200 : Colors.red.shade200);

    final bool isSelected = _selectedReviewIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedReviewIndex = _selectedReviewIndex == index ? null : index;
        });
      },
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? kPrimaryColor : borderColor,
            width: isSelected ? 2.2 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.08 : 0.04),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                '$questionNumber',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: !answered
                      ? Colors.grey.shade700
                      : (correct ? Colors.green.shade900 : Colors.red.shade900),
                ),
              ),
            ),
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: !answered
                      ? Colors.grey.shade400
                      : (correct ? Colors.green : Colors.red),
                ),
              ),
            ),
            Positioned(
              left: 6,
              bottom: 6,
              child: Text(
                '${stat.rightCount}/${stat.wrongCount}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewDetails(ExamQuestion q, int questionNumber) {
    final chosen = _answers[q.id];
    final answered = chosen != null;
    final correct = answered && chosen == q.correctOption;
    final stat = _stats[q.id] ?? CfcQuestionHistory(questionId: q.id);

    final Color cardColor = !answered
        ? Colors.grey.shade50
        : (correct ? Colors.green.shade50 : Colors.red.shade50);

    final Color borderColor = !answered
        ? Colors.grey.shade300
        : (correct ? Colors.green.shade200 : Colors.red.shade200);

    final Color titleColor = !answered
        ? Colors.grey.shade800
        : (correct ? Colors.green.shade900 : Colors.red.shade900);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor),
                  ),
                  child: Text(
                    '$questionNumber',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    q.subject,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: titleColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Text(
                    'Acertos: ${stat.rightCount}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    'Erros: ${stat.wrongCount}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              'Pergunta:',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              q.statement,
              style: const TextStyle(height: 1.45),
            ),
            const Divider(height: 24),
            Text(
              'Sua resposta: ${chosen ?? "-"}',
              style: TextStyle(
                color: !answered ? Colors.grey : (correct ? Colors.green : Colors.red),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              answered
                  ? (correct ? 'Você acertou esta questão.' : 'Você errou esta questão.')
                  : 'Você não respondeu esta questão.',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Tipo: ${q.subject}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              'Histórico desta questão: ${stat.rightCount} acertos e ${stat.wrongCount} erros.',
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  final List<DateTime> days;
  final Map<String, List<int>> series;
  final Map<String, Color> colors;

  _TrendChartPainter({
    required this.days,
    required this.series,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (days.isEmpty) return;

    const leftMargin = 44.0;
    const topMargin = 12.0;
    const rightMargin = 12.0;
    const bottomMargin = 34.0;

    final chartRect = Rect.fromLTWH(
      leftMargin,
      topMargin,
      size.width - leftMargin - rightMargin,
      size.height - topMargin - bottomMargin,
    );

    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    final axisPaint = Paint()
      ..color = Colors.grey.shade500
      ..strokeWidth = 1.2;

    final maxY = math.max(
      1,
      series.values.expand((v) => v).fold<int>(0, math.max),
    );

    const ySteps = 4;
    final yStepValue = maxY / ySteps;

    for (int i = 0; i <= ySteps; i++) {
      final y = chartRect.bottom - (chartRect.height / ySteps) * i;
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );

      final value = (yStepValue * i).round();
      _drawText(
        canvas,
        value.toString(),
        Offset(6, y - 8),
        fontSize: 10,
        color: Colors.grey.shade700,
        align: TextAlign.right,
        maxWidth: 30,
      );
    }

    canvas.drawLine(
      Offset(chartRect.left, chartRect.top),
      Offset(chartRect.left, chartRect.bottom),
      axisPaint,
    );
    canvas.drawLine(
      Offset(chartRect.left, chartRect.bottom),
      Offset(chartRect.right, chartRect.bottom),
      axisPaint,
    );

    final labelStep = days.length <= 6 ? 1 : (days.length / 5).ceil();

    for (int i = 0; i < days.length; i++) {
      if (i % labelStep != 0 && i != days.length - 1) continue;

      final x = days.length == 1
          ? chartRect.left + chartRect.width / 2
          : chartRect.left + (i / (days.length - 1)) * chartRect.width;

      _drawText(
        canvas,
        '${days[i].day.toString().padLeft(2, '0')}/${days[i].month.toString().padLeft(2, '0')}',
        Offset(x - 16, chartRect.bottom + 6),
        fontSize: 10,
        color: Colors.grey.shade700,
        maxWidth: 32,
        align: TextAlign.center,
      );
    }

    for (final entry in series.entries) {
      final subject = entry.key;
      final values = entry.value;
      final color = colors[subject] ?? Colors.blue;

      final points = <Offset>[];
      for (int i = 0; i < values.length; i++) {
        final x = days.length == 1
            ? chartRect.left + chartRect.width / 2
            : chartRect.left + (i / (days.length - 1)) * chartRect.width;

        final y = chartRect.bottom - (values[i] / maxY) * chartRect.height;
        points.add(Offset(x, y));
      }

      final linePaint = Paint()
        ..color = color
        ..strokeWidth = 2.4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final path = Path();
      for (int i = 0; i < points.length; i++) {
        if (i == 0) {
          path.moveTo(points[i].dx, points[i].dy);
        } else {
          path.lineTo(points[i].dx, points[i].dy);
        }
      }
      canvas.drawPath(path, linePaint);

      final dotPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      for (final point in points) {
        canvas.drawCircle(point, 2.8, dotPaint);
      }
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset, {
    required double fontSize,
    required Color color,
    TextAlign align = TextAlign.left,
    double maxWidth = double.infinity,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: align,
      maxLines: 1,
      ellipsis: '…',
    )..layout(maxWidth: maxWidth);

    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _TrendChartPainter oldDelegate) {
    return oldDelegate.days != days ||
        oldDelegate.series != series ||
        oldDelegate.colors != colors;
  }
}

class _StatementBlock {
  final String? text;
  final List<List<String>>? tableRows;
  final bool isTitle;

  const _StatementBlock.text(this.text, {this.isTitle = false})
      : tableRows = null;

  const _StatementBlock.table(this.tableRows)
      : text = null,
        isTitle = false;
}