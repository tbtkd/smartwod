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
  DateTime? _phaseStartTime;
  int _elapsedSeconds = 0;

  int _pausedAccumulated = 0;
  bool _countdownTriggered = false;

  AmrapRunner({
    required List<AmrapBlock> blocks,
    required this.onUpdate,
    required SoundEngine soundEngine,
  })  : _blocks = blocks,
        _soundEngine = soundEngine;

  // =============================
  // TOTAL WORKOUT TIME
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
    if (_blocks.isEmpty) return 1;

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
      remainingSeconds: _blocks.first.workSeconds,
      currentRound: 1,
      totalRounds: _blocks.length,
      phase: TimerPhase.work,
    );

    onUpdate(_state!);
    _startTicker();
  }

  // =============================
  // TICK LOOP
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

        // 🔥 3-2-1 final (work + rest)
        if (remaining <= 3 &&
            remaining > 0 &&
            !_countdownTriggered) {
          _countdownTriggered = true;
          _soundEngine.playCountdown();
        }

        // 🔥 Cálculo correcto acumulado
        int previousTime = 0;

        for (int i = 0; i < _index; i++) {
          previousTime += _blocks[i].workSeconds;
          previousTime += _blocks[i].restSeconds ?? 0;
        }

        if (_state!.phase == TimerPhase.rest) {
          previousTime += _blocks[_index].workSeconds;
        }

        _elapsedSeconds =
            (previousTime + elapsedInPhase)
                .clamp(0, totalWorkoutSeconds);

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

    final current = _blocks[_index];

    // 🔥 WORK → REST
    if (_state!.phase == TimerPhase.work &&
        current.restSeconds != null &&
        current.restSeconds! > 0) {

      _phaseStartTime = DateTime.now();

      _state = TimerUiState(
        remainingSeconds: current.restSeconds!,
        currentRound: _index + 1,
        totalRounds: _blocks.length,
        phase: TimerPhase.rest,
      );

      onUpdate(_state!);
      return;
    }

    // 🔥 REST → NEXT WORK
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

      // 🔥 NO TOCAR ESTO (Well Done funcional)
      await _soundEngine.playWorkoutFinished();

      return;
    }

    _phaseStartTime = DateTime.now();

    _state = TimerUiState(
      remainingSeconds: _blocks[_index].workSeconds,
      currentRound: _index + 1,
      totalRounds: _blocks.length,
      phase: TimerPhase.work,
    );

    onUpdate(_state!);
  }

  // =============================
  // PAUSE
  // =============================

  @override
  void togglePause() {
    if (_state == null) return;

    _isPaused = !_isPaused;

    if (_isPaused) {
      _pausedAccumulated += DateTime.now()
          .difference(_phaseStartTime!)
          .inSeconds;
    } else {
      _phaseStartTime = DateTime.now();
    }

    _state = TimerUiState(
      remainingSeconds: _state!.remainingSeconds,
      currentRound: _state!.currentRound,
      totalRounds: _state!.totalRounds,
      phase:
          _isPaused ? TimerPhase.paused : _state!.phase,
    );

    onUpdate(_state!);
  }

  // =============================
  // DISPOSE
  // =============================

  @override
  void dispose() {
    _timer?.cancel();
  }
}
