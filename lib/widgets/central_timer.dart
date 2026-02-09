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

    final Color ringColor = isCountingDown
        ? Colors.orange
        : isIdle
            ? Colors.orange
            : uiState!.phase == TimerPhase.rest
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
            : uiState!.phase == TimerPhase.rest
                ? 'descansa'
                : 'toca para pausar';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        height: 260,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: ringColor,
            width: 10,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                mainText,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: ringColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                helperText,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
