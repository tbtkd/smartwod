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

  // Countdown previo
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
        setState(() {
          _countdownSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isCountingDown = false;
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('AMRAP'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_uiState != null)
            Text(
              '${_uiState!.currentRound} de ${_uiState!.totalRounds}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          const SizedBox(height: 24),
          Center(
            child: CentralTimer(
              uiState: _uiState,
              isCountingDown: _isCountingDown,
              countdownSeconds: _countdownSeconds,
              onTap: _onCentralTap,
            ),
          ),
        ],
      ),
    );
  }
}
