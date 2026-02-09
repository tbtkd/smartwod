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
        setState(() {
          _seconds = seconds;
        });
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
  // USER TAP HANDLER
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
        setState(() {
          _countdownSeconds--;
        });

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
    setState(() {
      _uiState = TimerUiState.idle;
    });
  }

  AmrapBlock? _effectiveBlock() {
    // Durante countdown, mostramos el primer bloque de trabajo
    if (_uiState == TimerUiState.countdown) {
      return widget.blocks.firstWhere(
        (b) => !b.isRest,
        orElse: () => widget.blocks.first,
      );
    }

    return _currentBlock;
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
  // TOP INFO (X de N + tiempo)
  // -----------------------------
  Widget _buildTopInfo() {
    if (_uiState == TimerUiState.idle ||
        _uiState == TimerUiState.finished) {
      return const SizedBox.shrink();
    }

    final block = _effectiveBlock();
    if (block == null) return const SizedBox.shrink();

    // Solo bloques de trabajo
    final workBlocks = widget.blocks.where((b) => !b.isRest).toList();
    final totalWorkBlocks = workBlocks.length;

    int currentWorkIndex = workBlocks.indexOf(block) + 1;
    if (currentWorkIndex <= 0) currentWorkIndex = 1;

    final duration = block.durationSeconds;
    final minutes = duration ~/ 60;
    final seconds = duration % 60;

    final timeLabel = minutes > 0
        ? '$minutes:${seconds.toString().padLeft(2, '0')}'
        : '$duration segundos';

    return Column(
      children: [
        Text(
          '$currentWorkIndex de $totalWorkBlocks',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          timeLabel,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 18,
          ),
        ),
      ],
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
                    _buildTopInfo(),
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
