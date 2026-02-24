import 'package:flutter/material.dart';
import '../core/timer_ui_state.dart';
import '../core/timer_phase.dart';

class CentralTimer extends StatelessWidget {
  final TimerUiState? uiState;
  final bool isCountingDown;
  final int countdownSeconds;
  final int totalSeconds;
  final VoidCallback onTap;

  const CentralTimer({
    super.key,
    required this.uiState,
    required this.isCountingDown,
    required this.countdownSeconds,
    required this.totalSeconds,
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
    final TimerPhase? phase = uiState?.phase;

    final bool showPlayIcon =
        uiState == null && !isCountingDown;

    final int remaining =
        uiState?.remainingSeconds ?? 0;

    double progress = 0;

    if (isCountingDown) {
      progress = 1 - (countdownSeconds / 10);
    } else if (uiState != null &&
        totalSeconds > 0) {
      progress = 1 -
          (remaining / totalSeconds)
              .clamp(0.0, 1.0);
    }

    final Color color = isCountingDown
        ? Colors.orange
        : phase == TimerPhase.work
            ? Colors.orange
            : phase == TimerPhase.rest
                ? Colors.blue
                : phase == TimerPhase.paused
                    ? Colors.grey
                    : Colors.green;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 240,
        height: 240,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 240,
              height: 240,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 10,
                backgroundColor: Colors.white12,
                valueColor:
                    AlwaysStoppedAnimation<Color>(
                        color),
              ),
            ),
            if (showPlayIcon)
              const Icon(
                Icons.play_arrow,
                size: 70,
                color: Colors.white70,
              )
            else
              Text(
                isCountingDown
                    ? countdownSeconds.toString()
                    : _format(remaining),
                style: TextStyle(
                  color: color,
                  fontSize:
                      isCountingDown ? 48 : 40,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}