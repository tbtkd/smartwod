import 'package:flutter/material.dart';
import '../core/timer_ui_state.dart';
import '../core/timer_phase.dart';

/// ===============================================================
/// CENTRAL TIMER
///
/// Widget visual principal del temporizador.
///
/// RESPONSABILIDADES
/// - Mostrar countdown previo
/// - Mostrar tiempo restante
/// - Mostrar progreso circular del intervalo
///
/// IMPORTANTE
/// Este widget NO controla el tiempo ni los sonidos.
/// Solo representa el estado enviado por TimerScreen.
///
/// Los sonidos se controlan en:
/// - TimerScreen
/// - SoundEngine
/// - WorkoutRunner
///
/// Mantener este widget **sin lógica de tiempo**
/// evita interferencias con los sonidos del runner.
/// ===============================================================
class CentralTimer extends StatelessWidget {
  final TimerUiState? uiState;
  final bool isCountingDown;
  final int countdownSeconds;
  final int totalSeconds;
  final VoidCallback onTap;

  /// Color dinámico según tipo de entrenamiento
  final Color accentColor;

  const CentralTimer({
    super.key,
    required this.uiState,
    required this.isCountingDown,
    required this.countdownSeconds,
    required this.totalSeconds,
    required this.onTap,
    required this.accentColor,
  });

  /// ===============================================================
  /// FORMATO DE TIEMPO
  ///
  /// Convierte segundos a formato mm:ss
  /// ===============================================================
  String _format(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;

    return '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    /// Fase actual del runner
    final TimerPhase? phase = uiState?.phase;

    /// Mostrar botón play cuando aún no inicia
    final bool showPlayIcon =
        uiState == null && !isCountingDown;

    /// Segundos restantes del intervalo
    final int remaining =
        uiState?.remainingSeconds ?? 0;

    /// ===============================================================
    /// CÁLCULO DEL PROGRESO
    ///
    /// 0 = inicio
    /// 1 = intervalo terminado
    /// ===============================================================
    double progress = 0;

    if (isCountingDown) {
      /// Countdown siempre es de 10 segundos
      progress = 1 - (countdownSeconds / 10);
    } else if (uiState != null && totalSeconds > 0) {
      progress = 1 -
          (remaining / totalSeconds)
              .clamp(0.0, 1.0);
    }

    /// ===============================================================
    /// COLOR SEGÚN FASE
    ///
    /// WORK → color del modo
    /// REST → rojo
    /// WORK últimos 3s → rojo (alerta visual)
    /// PAUSED → gris
    /// FINISHED → verde
    ///
    /// Esto mejora la anticipación del atleta cuando el intervalo
    /// está por terminar.
    /// ===============================================================
    final Color color = isCountingDown
        ? accentColor

        /// REST siempre rojo
        : phase == TimerPhase.rest
            ? Colors.red

            /// WORK últimos 3 segundos
            : (phase == TimerPhase.work && remaining <= 3)
                ? Colors.red

                /// WORK normal
                : phase == TimerPhase.work
                    ? accentColor

                    /// PAUSE
                    : phase == TimerPhase.paused
                        ? Colors.grey

                        /// FINISHED
                        : Colors.green;

    /// ===============================================================
    /// TEXTO PRINCIPAL DEL TIMER
    /// ===============================================================
    final String timerText = isCountingDown
        ? countdownSeconds.toString()
        : _format(remaining);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 270,
        height: 270,
        child: Stack(
          alignment: Alignment.center,
          children: [

            /// ===================================================
            /// ANILLO DE PROGRESO
            ///
            /// Representa visualmente cuánto falta del intervalo.
            /// ===================================================
            SizedBox(
              width: 270,
              height: 270,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 14,
                backgroundColor: Colors.white12,
                valueColor:
                    AlwaysStoppedAnimation<Color>(color),
              ),
            ),

            /// ===================================================
            /// CONTENIDO CENTRAL
            /// ===================================================
            if (showPlayIcon)

              /// Icono play cuando el timer aún no inicia
              const Icon(
                Icons.play_arrow,
                size: 70,
                color: Colors.white70,
              )

            else

              /// AnimatedSwitcher solo anima el cambio visual
              /// del texto SIN alterar el tiempo del runner.
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: Text(
                  timerText,
                  key: ValueKey(timerText),
                  
                /// ============================================================
                /// DISPLAY PRINCIPAL DEL TIMER
                ///
                /// Ajustado para alta visibilidad durante entrenamientos.
                ///
                /// Objetivo:
                /// Permitir lectura clara del contador desde ~10 metros.
                ///
                /// Valores elegidos:
                /// Countdown → muy grande para impacto visual
                /// Timer normal → grande pero sin overflow
                ///
                /// El contenedor central es de 240x240, lo cual permite
                /// estos tamaños sin provocar RenderFlex overflow.
                ///
                /// Fuente monospace evita saltos visuales al cambiar
                /// de 09 → 10 → 11 segundos.
                /// ============================================================
                  style: TextStyle(
                    color: color,
                    
                    /// Tamaño del countdown previo (3..2..1)
                    fontSize: isCountingDown ? 120 : 80,
                    
                    /// Fuente monoespaciada para estabilidad visual
                    fontFamily: 'monospace',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}