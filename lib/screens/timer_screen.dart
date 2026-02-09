import 'dart:async';
import 'package:flutter/material.dart';

import '../core/amrap_block.dart';
import '../core/amrap_runner.dart';
import '../core/timer_ui_state.dart';
import '../widgets/central_timer.dart';
import '../utils/feedback_service.dart';

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
  late AmrapRunner _runner;

  TimerUiState _uiState = TimerUiState.idle;

  int _seconds = 0;
  int _countdownSeconds = 10;

  Timer? _countdownTimer;

  AmrapBlock? _currentBlock;
  int _currentBlockIndex = 0;

  @override
  void initState() {
    super.initState();

    _runner = AmrapRunner(
      blocks: widget.blocks,
      onBlockStart: (block) {
        FeedbackService.strongBeep();

        setState(() {
          _currentBlock = block;
          _currentBlockIndex++;
          _uiState = TimerUiState.running;
        });
      },
      onTick: (seconds) {
        setState(() => _seconds = seconds);
      },
      onFinish: () {
        FeedbackService.strongBeep();

        setState(() {
          _uiState = TimerUiState.finished;
        });
      },
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _runner.stop();
    super.dispose();
  }

  // -----------------------------
  // TAP HANDLER
  // -----------------------------
  void _onCentralTap() {
    switch (_uiState) {
      case TimerUiState.idle:
        _startCountdown();
        break;
      case TimerUiState.countdown:
        _cancelCountdown();
        break;
      case TimerUiState.running:
        _runner.pause();
        setState(() => _uiState = TimerUiState.paused);
        break;
      case TimerUiState.paused:
        _runner.resume();
        setState(() => _uiState = TimerUiState.running);
        break;
      case TimerUiState.finished:
        Navigator.pop(context);
        break;
    }
  }

  // -----------------------------
  // COUNTDOWN
  // -----------------------------
  void _startCountdown() {
    setState(() {
      _uiState = TimerUiState.countdown;
      _countdownSeconds = 10;
      _currentBlockIndex = 0;
    });

    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() => _countdownSeconds--);

        if (_countdownSeconds <= 3 && _countdownSeconds > 0) {
          FeedbackService.beep();
        }

        if (_countdownSeconds <= 0) {
          timer.cancel();
          _runner.start();
        }
      },
    );
  }

  void _cancelCountdown() {
    _countdownTimer?.cancel();
    setState(() => _uiState = TimerUiState.idle);
  }

  // -----------------------------
  // UI HELPERS
  // -----------------------------
  Color _activeColor() {
    if (_currentBlock == null) return Colors.orange;
    return _currentBlock!.isRest ? Colors.blue : Colors.orange;
  }

  String _blockLabel() {
    if (_currentBlock == null) return '';
    return _currentBlock!.isRest ? 'DESCANSO' : 'AMRAP';
  }

  double _progress() {
    if (_uiState == TimerUiState.countdown) {
      return _countdownSeconds / 10;
    }
    if (_currentBlock == null || _seconds <= 0) return 0;
    return _seconds / _currentBlock!.durationSeconds;
  }

  // -----------------------------
  // UI
  // -----------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('AMRAP'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_uiState != TimerUiState.idle &&
              _uiState != TimerUiState.finished)
            Column(
              children: [
                Text(
                  _blockLabel(),
                  style: const TextStyle(
                    color: Colors.white70,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${_currentBlockIndex} de ${widget.blocks.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 30),
          CentralTimer(
            state: _uiState,
            seconds: _uiState == TimerUiState.countdown
                ? _countdownSeconds
                : _seconds,
            progress: _progress(),
            color: _activeColor(),
            onTap: _onCentralTap,
          ),
          if (_uiState == TimerUiState.finished) ...[
            const SizedBox(height: 30),
            const Text(
              'ENTRENAMIENTO FINALIZADO',
              style: TextStyle(color: Colors.green),
            ),
          ],
        ],
      ),
    );
  }
}
