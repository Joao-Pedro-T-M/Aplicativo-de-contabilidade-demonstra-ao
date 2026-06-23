// lib/Utils/progress_storage.dart
import 'package:shared_preferences/shared_preferences.dart';

class ProgressStorage {
  // key por curso: completed_trails_<userId>_<courseId>
  static String _key(String courseId, {String? userId}) {
    if (userId != null && userId.isNotEmpty) {
      return 'completed_trails_${userId}_$courseId';
    } else {
      // antigo (compatibilidade)
      return 'completed_trails_$courseId';
    }
  }

  /// retorna conjunto de trailIds completadas (verifica chave com userId e sem userId)
  static Future<Set<String>> getCompletedTrailIds(String courseId, {String? userId}) async {
    final prefs = await SharedPreferences.getInstance();

    // 1) tenta chave com userId (se fornecido)
    if (userId != null && userId.isNotEmpty) {
      final list = prefs.getStringList(_key(courseId, userId: userId));
      if (list != null) return list.toSet();
    }

    // 2) fallback: chave antiga sem userId (compatibilidade)
    final listOld = prefs.getStringList(_key(courseId));
    return (listOld ?? <String>[]).toSet();
  }

  static Future<void> markTrailCompleted(String courseId, String trailId, {String? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _key(courseId, userId: userId);
    final existing = prefs.getStringList(key) ?? <String>[];
    final set = existing.toSet();
    set.add(trailId);
    await prefs.setStringList(key, set.toList());
  }

  static Future<void> unmarkTrailCompleted(String courseId, String trailId, {String? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _key(courseId, userId: userId);
    final existing = prefs.getStringList(key) ?? <String>[];
    final set = existing.toSet();
    set.remove(trailId);
    await prefs.setStringList(key, set.toList());
  }

  static Future<void> clearCourseProgress(String courseId, {String? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(courseId, userId: userId));
  }
}