import 'dart:async';

import '../../core/amrap_block.dart';
import '../../core/timer_ui_state.dart';
import '../../core/timer_phase.dart';
import '../../core/audio/sound_engine.dart';
import 'workout_runner.dart';

class AmrapRunner implements WorkoutRunner {
  final List<AmrapBlock> _blocks;
  final SoundEngine _soundEngine;

  final StreamController<TimerUiState> _controller =
      StreamController.broadcast();

  @override
  Stream<TimerUiState> get stream => _controller.stream;

  Timer? _timer;

  int _index = 0;
  TimerPhase _phase = TimerPhase.work;

  DateTime? _phaseStartTime;
  int _elapsedBeforePause = 0;
  bool _isPaused = false;

  int _globalElapsed = 0;
  int _currentPhaseDuration = 0;

  int? _lastSecondAnnounced;

  AmrapRunner({
    required List<AmrapBlock> blocks,
    required SoundEngine soundEngine,
  })  : _blocks = blocks,
        _soundEngine = soundEngine;

  @override
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

  @override
  double get globalProgress {
    if (totalWorkoutSeconds == 0) return 0;
    return (_globalElapsed / totalWorkoutSeconds)
        .clamp(0.0, 1.0);
  }

  @override
  Future<void> start() async {
    if (_blocks.isEmpty) return;

    _index = 0;
    _phase = TimerPhase.work;
    _isPaused = false;
    _elapsedBeforePause = 0;
    _globalElapsed = 0;
    _lastSecondAnnounced = null;

    _currentPhaseDuration =
        _blocks[_index].workSeconds;

    _phaseStartTime = DateTime.now();

    _emitState();
    _startTicker();
  }

void _startTicker() {
  _timer?.cancel();

  _timer = Timer.periodic(
    const Duration(milliseconds: 250),
    (_) {
      if (_isPaused || _phaseStartTime == null) return;

      final now = DateTime.now();

      final elapsed =
          _elapsedBeforePause +
              now.difference(_phaseStartTime!).inSeconds;

      final remaining =
          _currentPhaseDuration - elapsed;

      if (remaining < 0) {
        _lastSecondAnnounced = null;
        _nextPhase();
        return;
      }

      // 🔥 EXACTAMENTE como countdown inicial
      if (_lastSecondAnnounced != remaining) {
        if (remaining == 3) {
          _soundEngine.playCountdown();
        }

        _lastSecondAnnounced = remaining;
      }

      _globalElapsed =
          _calculateGlobalElapsed(elapsed);

      _emitState(remainingOverride: remaining);
    },
  );
}

  int _calculateGlobalElapsed(int currentPhaseElapsed) {
    int total = 0;

    for (int i = 0; i < _index; i++) {
      total += _blocks[i].workSeconds;
      if (i > 0) {
        total += _blocks[i].restSeconds ?? 0;
      }
    }

    total += currentPhaseElapsed;

    return total.clamp(0, totalWorkoutSeconds);
  }

  void _emitState({int? remainingOverride}) {
    final remaining =
        remainingOverride ??
            (_currentPhaseDuration -
                _elapsedBeforePause);

    _controller.add(
      TimerUiState(
        remainingSeconds:
            remaining.clamp(0, 9999),
        currentRound: _index + 1,
        totalRounds: _blocks.length,
        phase: _phase,
        phaseTotalSeconds:
            _currentPhaseDuration,
      ),
    );
  }

  Future<void> _nextPhase() async {
    _elapsedBeforePause = 0;
    _lastSecondAnnounced = null;

    if (_phase == TimerPhase.work) {
      _index++;

      if (_index >= _blocks.length) {
        _timer?.cancel();
        _phase = TimerPhase.finished;

        _controller.add(
          TimerUiState(
            remainingSeconds: 0,
            currentRound: _blocks.length,
            totalRounds: _blocks.length,
            phase: TimerPhase.finished,
            phaseTotalSeconds: 0,
          ),
        );

        await _soundEngine.playWorkoutFinished();
        return;
      }

      final next = _blocks[_index];

      if (next.restSeconds != null &&
          next.restSeconds! > 0) {
        _phase = TimerPhase.rest;
        _currentPhaseDuration =
            next.restSeconds!;
      } else {
        _phase = TimerPhase.work;
        _currentPhaseDuration =
            next.workSeconds;
      }
    } else if (_phase == TimerPhase.rest) {
      _phase = TimerPhase.work;
      _currentPhaseDuration =
          _blocks[_index].workSeconds;
    }

    _phaseStartTime = DateTime.now();
    _emitState();
  }

  @override
  void togglePause() {
    if (_phase == TimerPhase.rest) return;

    if (!_isPaused) {
      _elapsedBeforePause +=
          DateTime.now()
              .difference(_phaseStartTime!)
              .inSeconds;

      _isPaused = true;
      _phase = TimerPhase.paused;
    } else {
      _isPaused = false;
      _phaseStartTime = DateTime.now();
      _phase = TimerPhase.work;
    }

    _emitState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}