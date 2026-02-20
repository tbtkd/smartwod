import '../../core/timer_ui_state.dart';

abstract class WorkoutRunner {
  /// Stream de estado del temporizador
  Stream<TimerUiState> get stream;

  /// Duración total del entrenamiento en segundos
  int get totalWorkoutSeconds;

  /// Progreso global 0.0 → 1.0
  double get globalProgress;

  /// Inicia el entrenamiento
  Future<void> start();

  /// Alterna pausa (si el modo lo permite)
  void togglePause();

  /// Libera recursos
  void dispose();
}
