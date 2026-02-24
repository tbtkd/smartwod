import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../core/timer_ui_state.dart';
import '../../core/amrap_block.dart';
import '../../core/audio/sound_engine.dart';

import '../../domain/runners/amrap_runner.dart';
import '../../domain/entities/workout_result.dart';
import '../../domain/enums/workout_type.dart';

import '../../data/repositories/workout_history_repository_impl.dart';

import '../../widgets/central_timer.dart';
import 'workout_finished_screen.dart';
import '../../core/timer_phase.dart';

class TimerScreen extends StatefulWidget {
  final List<AmrapBlock> blocks;

  const TimerScreen({
    Key? key,
    required this.blocks,
  }) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late final AmrapRunner _runner;
  late final SoundEngine _soundEngine;
  late final StreamSubscription<TimerUiState> _subscription;

  final _historyRepository = WorkoutHistoryRepositoryImpl();

  TimerUiState? _uiState;

  bool _isCountingDown = false;
  int _countdownSeconds = 10;
  bool _trainingStarted = false;

  @override
  void initState() {
    super.initState();

    _soundEngine = SoundEngine();

    _runner = AmrapRunner(
      blocks: widget.blocks,
      soundEngine: _soundEngine,
    );

    _subscription = _runner.stream.listen(_onUpdate);
  }

  // =============================
  // RUNNER UPDATE
  // =============================

  void _onUpdate(TimerUiState state) async {
    if (state.phase == TimerPhase.finished) {
      await _historyRepository.save(
        WorkoutResult(
          type: WorkoutType.amrap,
          date: DateTime.now(),
          totalSeconds: _runner.totalWorkoutSeconds,
          blocks: widget.blocks,
        ),
      );

      await _disableWakelock();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => WorkoutFinishedScreen(
            totalSeconds: _runner.totalWorkoutSeconds,
            totalAmraps: state.totalRounds,
          ),
        ),
      );

      return;
    }

    if (!mounted) return;

    setState(() {
      _uiState = state;
    });
  }

  // =============================
  // WAKELOCK
  // =============================

  Future<void> _enableWakelock() async {
    await WakelockPlus.enable();
  }

  Future<void> _disableWakelock() async {
    await WakelockPlus.disable();
  }

  // =============================
  // COUNTDOWN INICIAL
  // =============================

  Future<void> _startCountdown() async {
    if (_isCountingDown || _trainingStarted) return;

    await _soundEngine.init();

    setState(() {
      _isCountingDown = true;
      _countdownSeconds = 10;
    });

    while (_countdownSeconds > 0 && mounted) {
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      final nextValue = _countdownSeconds - 1;

      setState(() {
        _countdownSeconds = nextValue;
      });

      if (nextValue == 3) {
        await _soundEngine.playCountdown();
      }
    }

    if (!mounted) return;

    setState(() {
      _isCountingDown = false;
      _trainingStarted = true;
    });

    await _enableWakelock();
    await _runner.start();
  }

  void _onCentralTap() {
    if (_uiState == null && !_isCountingDown) {
      _startCountdown();
      return;
    }

    if (_uiState != null) {
      if (_uiState!.isFinished) return;
      _runner.togglePause();
    }
  }

  // =============================
  // EXIT PROTECTION
  // =============================

  Future<bool> _onWillPop() async {
    if (_uiState == null) return true;

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Salir del entrenamiento',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '¿Seguro que deseas abandonar el entrenamiento?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Salir',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (shouldExit == true) {
      await _disableWakelock();
      _runner.dispose();
      return true;
    }

    return false;
  }

  String _formatTotalTime() {
    int total = 0;

    for (int i = 0; i < widget.blocks.length; i++) {
      total += widget.blocks[i].workSeconds;
      if (i > 0) {
        total += widget.blocks[i].restSeconds ?? 0;
      }
    }

    final m = total ~/ 60;
    final s = total % 60;

    return '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _subscription.cancel();
    _disableWakelock();
    _runner.dispose();
    super.dispose();
  }

  // =============================
  // UI
  // =============================

  @override
  Widget build(BuildContext context) {
    final bool isRest =
        _uiState != null && _uiState!.phase == TimerPhase.rest;

    final String topLabel = _isCountingDown
        ? 'Prepárate'
        : (_uiState == null
            ? 'Prepárate'
            : (isRest
                ? 'Descanso'
                : 'Amrap ${_uiState!.currentRound} de ${_uiState!.totalRounds}'));

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'AMRAP',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    topLabel,
                    key: ValueKey(topLabel),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isRest ? Colors.blue : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                CentralTimer(
                  uiState: _uiState,
                  isCountingDown: _isCountingDown,
                  countdownSeconds: _countdownSeconds,
                  totalSeconds: _uiState?.phaseTotalSeconds ?? 0,
                  onTap: _onCentralTap,
                ),
                const SizedBox(height: 24),
                if (_uiState != null)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40),
                    child: LinearProgressIndicator(
                      value: _runner.globalProgress,
                      minHeight: 6,
                      backgroundColor: Colors.white12,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(
                            Color(0xFF00E5FF),
                          ),
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  'Tiempo total · ${_formatTotalTime()}',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
