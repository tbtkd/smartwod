import 'package:flutter/material.dart';
import '../core/timer_ui_state.dart';

class CentralTimer extends StatelessWidget {
  final TimerUiState? uiState;
  final bool isCountingDown;
  final int countdownSeconds;
  final VoidCallback onTap;

  const CentralTimer({
    super.key,
    required this.uiState,
    required this.isCountingDown,
    required this.countdownSeconds,
    required this.onTap,
  });

  String _format(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // 🔥 Tamaño responsivo del círculo (75% del ancho)
    final double size = screenWidth * 0.75;

    final bool isIdle = uiState == null && !isCountingDown;
    final bool isRest =
        uiState != null && uiState!.phase == TimerPhase.rest;

    final Color ringColor = isCountingDown
        ? Colors.orange
        : isIdle
            ? Colors.orange
            : isRest
                ? Colors.blue
                : Colors.orange;

    final String mainText = isCountingDown
        ? countdownSeconds.toString()
        : isIdle
            ? '▶'
            : _format(uiState!.remainingSeconds);

    final String helperText = isCountingDown
        ? ''
        : isIdle
            ? 'Toca para empezar'
            : uiState!.phase == TimerPhase.work
                ? 'Toca para pausar'
                : '';

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: ringColor,
            width: size * 0.05, // 🔥 Grosor proporcional
          ),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔥 Animación suave al cambiar texto
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    mainText,
                    key: ValueKey(mainText),
                    style: TextStyle(
                      fontSize: size * 0.22, // 🔥 Escala automática
                      fontWeight: FontWeight.bold,
                      color: ringColor,
                    ),
                  ),
                ),

                if (helperText.isNotEmpty) ...[
                  SizedBox(height: size * 0.05),
                  Text(
                    helperText,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: size * 0.06,
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
