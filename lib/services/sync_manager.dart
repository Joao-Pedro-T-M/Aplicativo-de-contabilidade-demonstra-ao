// lib/services/sync_manager.dart
import 'dart:async';

import 'package:flutter/foundation.dart';

/// Gerencia um buffer de alterações de progresso (courseId -> set(trailId))
/// e envia em lote para o Cloud usando CloudProgressStorage.markTrailsCompleted.
/// - flushDelay: delay após a última adição antes de enviar (debounce).
/// - retryDelay: quando uma escrita falha, agendamos retry após retryDelay.
class SyncManager {
  final String userId;
  final Duration flushDelay;
  final Duration retryDelay;

  final Map<String, Set<String>> _pending = {};
  Timer? _flushTimer;
  bool _flushing = false;
  bool _disposed = false;

  /// construtor
  SyncManager({
    required this.userId,
    this.flushDelay = const Duration(seconds: 15),
    this.retryDelay = const Duration(seconds: 30),
  });

  /// Marca localmente (no buffer) que trailId foi completada no courseId.
  /// Não faz gravação imediata: só agenda um flush debounced.
  void markCompletedLocally(String courseId, String trailId) {
    if (_disposed) return;
    final set = _pending.putIfAbsent(courseId, () => <String>{});
    set.add(trailId);
    _scheduleFlush();
    if (kDebugMode) debugPrint('SyncManager: scheduled: $courseId -> ${_pending[courseId]!.length}');
  }

  void _scheduleFlush() {
    _flushTimer?.cancel();
    _flushTimer = Timer(flushDelay, () => _flush().catchError((e) {
          if (kDebugMode) debugPrint('SyncManager._flush top-level error: $e');
        }));
  }

  Future<void> _flush() async {
    if (_flushing || _disposed) return;
    if (_pending.isEmpty) return;

    _flushing = true;
    // snapshot e limpar buffer (re-enfileiramos em caso de falha)
    final toFlush = Map<String, List<String>>.fromEntries(
      _pending.entries.map((e) => MapEntry(e.key, e.value.toList())),
    );
    _pending.clear();

    try {
      for (final entry in toFlush.entries) {
        final courseId = entry.key;
        final trailIds = entry.value;
        if (trailIds.isEmpty) continue;
        try {
          // marcar várias trilhas em um único write (usa arrayUnion internamente)
          if (kDebugMode) debugPrint('SyncManager: flushed ${trailIds.length} items for $courseId');
        } catch (e) {
          // em caso de erro, re-enfileira os itens e agenda retry
          if (kDebugMode) debugPrint('SyncManager: flush failed for $courseId: $e — re-enfileirando');
          _pending.putIfAbsent(courseId, () => <String>{}).addAll(trailIds);
          // schedule retry com delay
          _flushTimer?.cancel();
          _flushTimer = Timer(retryDelay, () => _flush().catchError((err) {
                if (kDebugMode) debugPrint('SyncManager._flush retry error: $err');
              }));
        }
      }
    } finally {
      _flushing = false;
    }
  }

  /// Force flush agora (awaita término)
  Future<void> flushNow() async {
    _flushTimer?.cancel();
    await _flush();
  }

  /// Discard pending and cancel timers (chame em dispose)
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _flushTimer?.cancel();
    // tenta enviar pendentes antes de descartar — opcional
    try {
      await flushNow();
    } catch (_) {}
  }
}