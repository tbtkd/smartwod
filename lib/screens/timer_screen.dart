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


  @override
  void initState() {
    super.initState();

    _runner = AmrapRunner(
      blocks: widget.blocks,
      onBlockStart: (block) {
        FeedbackService.strongBeep();

        setState(() {
          _currentBlock = block;
          _uiState = TimerUiState.running;
        });
      },
      onTick: (seconds) {
        setState(() => _seconds = seconds);
      },
      onFinish: () {
        FeedbackService.strongBeep();
        setState(() => _uiState = TimerUiState.finished);
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

  double _progress() {
    if (_uiState == TimerUiState.countdown) {
      return _countdownSeconds / 10;
    }
    if (_currentBlock == null || _seconds <= 0) return 0;
    return _seconds / _currentBlock!.durationSeconds;
  }

  // -----------------------------
  // ROUND INDICATOR (SOLO TRABAJO)
  // -----------------------------
  Widget _buildRoundIndicator() {
    if (_uiState == TimerUiState.idle ||
        _uiState == TimerUiState.finished) {
      return const SizedBox.shrink();
    }

    final workBlocks =
        widget.blocks.where((b) => !b.isRest).toList();

    if (workBlocks.isEmpty || _currentBlock == null) {
      return const SizedBox.shrink();
    }

    final currentWorkIndex =
        workBlocks.indexOf(_currentBlock!) + 1;

    return Text(
      '$currentWorkIndex de ${workBlocks.length}',
      style: TextStyle(
        color: _currentBlock!.isRest
            ? Colors.white54
            : Colors.white,
        fontSize: _currentBlock!.isRest ? 20 : 26,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // -----------------------------
  // REST INFO
  // -----------------------------
  Widget _buildRestInfo() {
    if (_currentBlock == null || !_currentBlock!.isRest) {
      return const SizedBox.shrink();
    }

    final minutes = _currentBlock!.durationSeconds ~/ 60;
    final seconds = _currentBlock!.durationSeconds % 60;

    return Text(
      'Descanso · $minutes:${seconds.toString().padLeft(2, '0')}',
      style: const TextStyle(
        color: Colors.blueAccent,
        fontSize: 16,
        letterSpacing: 1,
      ),
    );
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
        centerTitle: true,
        title: const Text(
          'AMRAP',
          style: TextStyle(
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildRoundIndicator(),
                    const SizedBox(height: 24),
                    CentralTimer(
                      state: _uiState,
                      seconds: _uiState == TimerUiState.countdown
                          ? _countdownSeconds
                          : _seconds,
                      progress: _progress(),
                      color: _activeColor(),
                      onTap: _onCentralTap,
                    ),
                    const SizedBox(height: 16),
                    _buildRestInfo(),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
