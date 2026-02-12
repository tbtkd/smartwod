import 'package:flutter/material.dart';
import '../core/timer_ui_state.dart';

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
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isIdle = uiState == null && !isCountingDown;
    final bool isRest =
        uiState != null && uiState!.phase == TimerPhase.rest;
    final bool isPaused =
        uiState != null && uiState!.phase == TimerPhase.paused;

    final Color targetColor = isCountingDown
        ? Colors.orange
        : isIdle
            ? Colors.orange
            : isRest
                ? Colors.blue
                : isPaused
                    ? Colors.orange.shade300
                    : Colors.orange;

    final String mainText = isCountingDown
        ? countdownSeconds.toString()
        : isIdle
            ? '▶'
            : _format(uiState!.remainingSeconds);

    final String helperText = isCountingDown
        ? 'Prepárate'
        : isIdle
            ? 'Toca para empezar'
            : uiState!.phase == TimerPhase.work
                ? 'Presiona para pausar'
                : uiState!.phase == TimerPhase.paused
                    ? 'Presiona para continuar'
                    : '';

    double progress = 1.0;

    if (uiState != null && totalSeconds > 0) {
      progress = uiState!.remainingSeconds / totalSeconds;
      progress = progress.clamp(0.0, 1.0);
    }

    final double size = MediaQuery.of(context).size.width * 0.75;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [

            /// 🔥 CÍRCULO CON TRANSICIÓN SUAVE
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              child: CustomPaint(
                size: Size(size, size),
                painter: _CirclePainter(
                  progress: progress,
                  color: targetColor,
                  dimmed: isPaused,
                ),
              ),
            ),

            /// 🔥 TEXTO CON TRANSICIÓN
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: Column(
                key: ValueKey(mainText + targetColor.toString()),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: size * 0.18,
                      fontWeight: FontWeight.bold,
                      color: targetColor,
                    ),
                    child: Text(mainText),
                  ),
                  if (helperText.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: size * 0.05,
                      ),
                      child: Text(helperText),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool dimmed;

  _CirclePainter({
    required this.progress,
    required this.color,
    required this.dimmed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 10.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth;

    final backgroundPaint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final progressPaint = Paint()
      ..color = dimmed ? color.withOpacity(0.4) : color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final sweepAngle = 2 * 3.1415926535 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.1415926535 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
