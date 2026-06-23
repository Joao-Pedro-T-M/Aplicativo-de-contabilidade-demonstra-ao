// lib/state/app_state.dart
import 'package:flutter/foundation.dart';
import '../models/course_models.dart';
import 'package:equition/services/sync_manager.dart';

class AppState extends ChangeNotifier {
  Course? _activeCourse;

  /// Flag que controla se a sincronização com a nuvem está habilitada.
  /// Por padrão deve ser `false` em contas Spark / gratuitas.
  bool cloudSyncEnabled = false;

  /// Gerenciador responsável por agrupar e enviar updates para a nuvem.
  SyncManager? syncManager;

  Course? get activeCourse => _activeCourse;

  /// seleciona um curso (tornando-o "ativo")
  void selectCourse(Course? course) {
    _activeCourse = course;
    notifyListeners();
  }

  /// limpa a seleção
  void clearCourse() {
    _activeCourse = null;
    notifyListeners();
  }

  /// Habilita sincronização com a nuvem para o usuário `userId`.
  /// Cria (ou reinicia) o SyncManager associado.
  void enableCloudSync(String userId) {
    cloudSyncEnabled = true;

    // descarta manager existente (se houver) e cria novo para o userId atual
    try {
      syncManager?.dispose();
    } catch (_) {}
    syncManager = SyncManager(userId: userId);

    notifyListeners();
  }

  /// Desabilita a sincronização e descarta o SyncManager.
  void disableCloudSync() {
    cloudSyncEnabled = false;
    try {
      syncManager?.dispose();
    } catch (_) {}
    syncManager = null;
    notifyListeners();
  }

  /// Dispose: garante que possamos liberar o SyncManager corretamente.
  /// Note: SyncManager.dispose() é assíncrono, mas aqui chamamos sem await
  /// pois dispose() do ChangeNotifier não pode ser async.
  @override
  void dispose() {
    try {
      syncManager?.dispose();
    } catch (_) {}
    super.dispose();
  }
}