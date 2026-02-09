/// Estados posibles de la interfaz del temporizador.
///
/// Este enum NO controla el tiempo.
/// Solo indica cómo debe comportarse la UI.
///
/// Se usa en:
/// - TimerScreen
/// - Widgets de temporizador
/// - Futuros modos (EMOM, TABATA)
enum TimerUiState {
  /// Estado inicial, antes de comenzar
  /// Muestra botón ▶️
  idle,

  /// Countdown previo (por ejemplo 10 → 1)
  /// Prepara al usuario antes del inicio real
  countdown,

  /// Temporizador corriendo normalmente
  running,

  /// Temporizador pausado por el usuario
  paused,

  /// Entrenamiento o bloque finalizado
  finished,
}
