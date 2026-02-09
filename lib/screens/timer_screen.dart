import 'dart:async';

import 'package:flutter/material.dart';

import '../core/amrap_block.dart';
import '../core/amrap_runner.dart';
import '../core/timer_ui_state.dart';
import '../widgets/central_timer.dart';

class TimerScreen extends StatefulWidget {
  final List<AmrapBlock> blocks;

  const TimerScreen({
    super.key,
    required this.blocks,
  });

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  TimerUiState? _uiState;
  late AmrapRunner _runner;

  bool _isCountingDown = false;
  int _countdownSeconds = 10;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _runner = AmrapRunner(
      blocks: widget.blocks,
      onUpdate: (state) {
        setState(() => _uiState = state);
      },
    );
  }

  void _onCentralTap() {
    if (_uiState != null || _isCountingDown) return;
    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      _isCountingDown = true;
      _countdownSeconds = 10;
    });

    _countdownTimer?.cancel();
    _countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 1) {
        setState(() => _countdownSeconds--);
      } else {
        timer.cancel();
        setState(() => _isCountingDown = false);
        _runner.start();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _runner.dispose();
    super.dispose();
  }

  /// Descanso que sigue al AMRAP actual
  int? _nextRestSeconds() {
    final index = (_uiState?.currentRound ?? 1) - 1;

    if (index < 0 || index >= widget.blocks.length - 1) {
      return null;
    }

    return widget.blocks[index + 1].restSeconds;
  }

  @override
  Widget build(BuildContext context) {
    final totalRounds = widget.blocks.length;
    final currentRound = _uiState?.currentRound ?? 1;
    final restSeconds = _nextRestSeconds();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('AMRAP')),
      body: Column(
        children: [
          const SizedBox(height: 24),

          // 🔹 INFO SUPERIOR
          Column(
            children: [
              Text(
                '$currentRound de $totalRounds',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (restSeconds != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    'Descanso · ${restSeconds}s',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),

          // 🔹 TEMPORIZADOR SIEMPRE CENTRADO
          Expanded(
            child: Center(
              child: CentralTimer(
                uiState: _uiState,
                isCountingDown: _isCountingDown,
                countdownSeconds: _countdownSeconds,
                onTap: _onCentralTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
