import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../core/amrap_runner.dart';
import '../core/timer_ui_state.dart';
import '../core/amrap_block.dart';
import '../widgets/central_timer.dart';
import '../utils/feedback_service.dart';
import '../utils/workout_persistence_service.dart';
import '../utils/workout_history_service.dart';
import '../models/workout_history_entry.dart';
import 'workout_finished_screen.dart';

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

  TimerUiState? _uiState;

  bool _isCountingDown = false;
  int _countdownSeconds = 10;

  bool _trainingStarted = false;

  @override
  void initState() {
    super.initState();

    FeedbackService.preload();

    _runner = AmrapRunner(
      blocks: widget.blocks,
      onUpdate: _onUpdate,
    );

    _restoreWorkout();
  }

  // =============================
  // RESTORE WORKOUT
  // =============================

  Future<void> _restoreWorkout() async {
    final data = await WorkoutPersistenceService.loadWorkout();
    if (data == null) return;

    final blocksData = data['blocks'] as List;
    if (blocksData.length != widget.blocks.length) return;

    _trainingStarted = true;
    await _enableWakelock();
    _runner.start();
  }

  // =============================
  // RUNNER UPDATE
  // =============================

  void _onUpdate(TimerUiState state) async {
    if (state.phase == TimerPhase.finished) {

      // Guardar en historial
      await WorkoutHistoryService.addEntry(
        WorkoutHistoryEntry(
          date: DateTime.now(),
          totalSeconds: _runner.totalWorkoutSeconds,
          totalBlocks: state.totalRounds,
          blocks: widget.blocks,
        ),
      );

      await WorkoutPersistenceService.clearWorkout();
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

    setState(() {
      _uiState = state;
    });

    // Guardar estado activo
    if (state.phase != TimerPhase.paused) {
      await WorkoutPersistenceService.saveWorkout(
        blocks: widget.blocks,
        index: state.currentRound - 1,
        phase: state.phase,
        phaseDuration: _runner.currentBlockTotalSeconds,
        phaseStartTime: DateTime.now(),
      );
    }
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
  // COUNTDOWN
  // =============================

  void _startCountdown() {
    if (_isCountingDown) return;

    setState(() {
      _isCountingDown = true;
      _countdownSeconds = 10;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;

      setState(() {
        _countdownSeconds--;
      });

      if (_countdownSeconds <= 0) {
        _isCountingDown = false;
        _trainingStarted = true;

        await _enableWakelock();
        _runner.start();
        return false;
      }
      return true;
    });
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
    if (!_trainingStarted) return true;

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
      await WorkoutPersistenceService.clearWorkout();
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
    _disableWakelock();
    _runner.dispose();
    super.dispose();
  }

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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final allowExit = await _onWillPop();
              if (allowExit) {
                Navigator.pop(context);
              }
            },
          ),
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
                  totalSeconds: _runner.currentBlockTotalSeconds,
                  onTap: _onCentralTap,
                ),
                const SizedBox(height: 24),
                if (_uiState != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: LinearProgressIndicator(
                      value: _runner.globalProgress,
                      minHeight: 6,
                      backgroundColor: Colors.white12,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.orange),
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
