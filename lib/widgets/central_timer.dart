import 'dart:math';
import 'package:flutter/material.dart';
import '../core/timer_ui_state.dart';

class CentralTimer extends StatelessWidget {
  final TimerUiState state;
  final int seconds;
  final double progress;
  final Color color;
  final VoidCallback onTap;

  const CentralTimer({
    super.key,
    required this.state,
    required this.seconds,
    required this.progress,
    required this.color,
    required this.onTap,
  });

  String _label() {
    switch (state) {
      case TimerUiState.idle:
        return 'toca para empezar';
      case TimerUiState.countdown:
        return 'prepárate';
      case TimerUiState.running:
        return 'toca para pausar';
      case TimerUiState.paused:
        return 'toca para continuar';
      case TimerUiState.finished:
        return 'finalizado';
    }
  }

  String _formattedTime() {
    if (state == TimerUiState.countdown) {
      return seconds.toString();
    }
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 260,
        height: 260,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              painter: _BaseCirclePainter(),
              size: const Size(260, 260),
            ),
            CustomPaint(
              painter: _ProgressPainter(
                progress: progress,
                color: color,
              ),
              size: const Size(260, 260),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formattedTime(),
                  style: TextStyle(
                    fontSize: state == TimerUiState.countdown ? 64 : 48,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _label(),
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BaseCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 6.0;
    final radius = (size.width / 2) - stroke;

    final paint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    canvas.drawCircle(
      size.center(Offset.zero),
      radius,
      paint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

class _ProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  _ProgressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 8.0;
    final radius = (size.width / 2) - stroke;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: radius,
    );

    canvas.drawArc(
      rect,
      -pi / 2,
      2 * pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressPainter old) {
    return old.progress != progress || old.color != color;
  }
}
