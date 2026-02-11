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
        ? 'prepárate'
        : isIdle
            ? 'toca para empezar'
            : uiState!.phase == TimerPhase.work
                ? 'toca para pausar'
                : '';

    return LayoutBuilder(
      builder: (context, constraints) {
        // 🔥 Toma el espacio real disponible
        final double maxSize = constraints.maxHeight;

        // ✅ 75% del espacio disponible
        final double size = maxSize * 0.75;

        return GestureDetector(
          onTap: onTap,
          child: Center(
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: ringColor,
                  width: size * 0.04, // grosor proporcional
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🔥 Número principal
                    Text(
                      mainText,
                      style: TextStyle(
                        fontSize: size * 0.22, // escala proporcional
                        fontWeight: FontWeight.bold,
                        color: ringColor,
                      ),
                    ),

                    // 🔥 Texto secundario
                    if (helperText.isNotEmpty) ...[
                      SizedBox(height: size * 0.05),
                      Text(
                        helperText,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: size * 0.07,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
