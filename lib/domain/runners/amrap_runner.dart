import 'dart:async';

import '../../core/amrap_block.dart';
import '../../core/timer_ui_state.dart';
import '../../core/audio/sound_engine.dart';

import 'workout_runner.dart';

class AmrapRunner implements WorkoutRunner {
  final List<AmrapBlock> _blocks;
  final void Function(TimerUiState) onUpdate;
  final SoundEngine _soundEngine;

  Timer? _timer;

  int _index = 0;
  TimerUiState? _state;

  bool _isPaused = false;
  TimerPhase? _phaseBeforePause;

  DateTime? _phaseStartTime;
  int _pausedAccumulated = 0;
  int _elapsedSeconds = 0;

  bool _countdownTriggered = false;

  AmrapRunner({
    required List<AmrapBlock> blocks,
    required this.onUpdate,
    required SoundEngine soundEngine,
  })  : _blocks = blocks,
        _soundEngine = soundEngine;

  // =============================
  // TOTAL TIME
  // =============================

  int get totalWorkoutSeconds {
    int total = 0;

    for (int i = 0; i < _blocks.length; i++) {
      total += _blocks[i].workSeconds;

      if (i > 0) {
        total += _blocks[i].restSeconds ?? 0;
      }
    }

    return total;
  }

  double get globalProgress {
    if (totalWorkoutSeconds == 0) return 0;
    return (_elapsedSeconds / totalWorkoutSeconds)
        .clamp(0.0, 1.0);
  }

  int get currentBlockTotalSeconds {
    final current = _blocks[_index];

    if (_state?.phase == TimerPhase.rest) {
      return current.restSeconds ?? 0;
    }

    return current.workSeconds;
  }

  // =============================
  // START
  // =============================

  @override
  Future<void> start() async {
    if (_blocks.isEmpty) return;

    _index = 0;
    _elapsedSeconds = 0;
    _pausedAccumulated = 0;
    _isPaused = false;
    _countdownTriggered = false;

    _phaseStartTime = DateTime.now();

    _state = TimerUiState(
      remainingSeconds: _blocks[0].workSeconds,
      currentRound: 1,
      totalRounds: _blocks.length,
      phase: TimerPhase.work,
    );

    onUpdate(_state!);
    _startTicker();
  }

  // =============================
  // TICK
  // =============================

  void _startTicker() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) {
        if (_state == null ||
            _isPaused ||
            _phaseStartTime == null) return;

        final now = DateTime.now();

        final elapsedInPhase =
            _pausedAccumulated +
                now.difference(_phaseStartTime!).inSeconds;

        final totalDuration = currentBlockTotalSeconds;
        final remaining = totalDuration - elapsedInPhase;

        // 🔥 Countdown final
        if (remaining <= 3 &&
            remaining > 0 &&
            !_countdownTriggered) {
          _countdownTriggered = true;
          _soundEngine.playCountdown();
        }

        // =============================
        // 🔥 CÁLCULO GLOBAL CORREGIDO
        // =============================

        int previousTime = 0;

        // bloques completamente terminados
        for (int i = 0; i < _index; i++) {
          if (i == 0) {
            previousTime += _blocks[i].workSeconds;
          } else {
            previousTime += (_blocks[i].restSeconds ?? 0);
            previousTime += _blocks[i].workSeconds;
          }
        }

        int currentProgress = 0;

        if (_state!.phase == TimerPhase.rest) {
          currentProgress = elapsedInPhase;
        } else if (_state!.phase == TimerPhase.work) {
          if (_index > 0) {
            currentProgress +=
                (_blocks[_index].restSeconds ?? 0);
          }

          currentProgress += elapsedInPhase;
        }

        _elapsedSeconds =
            (previousTime + currentProgress)
                .clamp(0, totalWorkoutSeconds);

        // =============================

        if (remaining > 0) {
          _state = TimerUiState(
            remainingSeconds: remaining,
            currentRound: _index + 1,
            totalRounds: _blocks.length,
            phase: _state!.phase,
          );

          onUpdate(_state!);
        } else {
          _nextPhase();
        }
      },
    );
  }

  // =============================
  // NEXT PHASE
  // =============================

  Future<void> _nextPhase() async {
    if (_state == null) return;

    _countdownTriggered = false;
    _pausedAccumulated = 0;

    if (_state!.phase == TimerPhase.work) {
      _index++;

      if (_index >= _blocks.length) {
        _timer?.cancel();

        _state = TimerUiState(
          remainingSeconds: 0,
          currentRound: _blocks.length,
          totalRounds: _blocks.length,
          phase: TimerPhase.finished,
        );

        onUpdate(_state!);

        await _soundEngine.playWorkoutFinished();
        return;
      }

      final nextBlock = _blocks[_index];

      if (nextBlock.restSeconds != null &&
          nextBlock.restSeconds! > 0) {

        _phaseStartTime = DateTime.now();

        _state = TimerUiState(
          remainingSeconds: nextBlock.restSeconds!,
          currentRound: _index + 1,
          totalRounds: _blocks.length,
          phase: TimerPhase.rest,
        );

        onUpdate(_state!);
        return;
      }

      _phaseStartTime = DateTime.now();

      _state = TimerUiState(
        remainingSeconds: nextBlock.workSeconds,
        currentRound: _index + 1,
        totalRounds: _blocks.length,
        phase: TimerPhase.work,
      );

      onUpdate(_state!);
    } else if (_state!.phase == TimerPhase.rest) {

      final currentBlock = _blocks[_index];

      _phaseStartTime = DateTime.now();

      _state = TimerUiState(
        remainingSeconds: currentBlock.workSeconds,
        currentRound: _index + 1,
        totalRounds: _blocks.length,
        phase: TimerPhase.work,
      );

      onUpdate(_state!);
    }
  }

  // =============================
  // PAUSE
  // =============================

  @override
  void togglePause() {
    if (_state == null) return;
    if (_state!.phase == TimerPhase.rest) return;

    _isPaused = !_isPaused;

    if (_isPaused) {
      _phaseBeforePause = _state!.phase;

      _pausedAccumulated += DateTime.now()
          .difference(_phaseStartTime!)
          .inSeconds;

      _state = TimerUiState(
        remainingSeconds: _state!.remainingSeconds,
        currentRound: _state!.currentRound,
        totalRounds: _state!.totalRounds,
        phase: TimerPhase.paused,
      );
    } else {
      _phaseStartTime = DateTime.now();

      _state = TimerUiState(
        remainingSeconds: _state!.remainingSeconds,
        currentRound: _state!.currentRound,
        totalRounds: _state!.totalRounds,
        phase: _phaseBeforePause ?? TimerPhase.work,
      );
    }

    onUpdate(_state!);
  }

  @override
  void dispose() {
    _timer?.cancel();
  }
}
