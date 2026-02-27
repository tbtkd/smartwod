import 'dart:async';

import '../../core/timer_ui_state.dart';
import '../../core/timer_phase.dart';
import '../../core/audio/sound_engine.dart';
import 'workout_runner.dart';

class EmomRunner implements WorkoutRunner {
  final int totalRounds;
  final int secondsPerRound;
  final SoundEngine _soundEngine;

  final StreamController<TimerUiState> _controller =
      StreamController.broadcast();

  @override
  Stream<TimerUiState> get stream => _controller.stream;

  Timer? _timer;

  int _currentRound = 0;
  TimerPhase _phase = TimerPhase.work;
  TimerPhase _phaseBeforePause = TimerPhase.work;

  DateTime? _roundStartTime;
  int _elapsedBeforePause = 0;
  bool _isPaused = false;

  int _globalElapsed = 0;
  int? _lastSecondAnnounced;

  EmomRunner({
    required this.totalRounds,
    required this.secondsPerRound,
    required SoundEngine soundEngine,
  }) : _soundEngine = soundEngine;

  @override
  int get totalWorkoutSeconds =>
      totalRounds * secondsPerRound;

  @override
  double get globalProgress {
    if (totalWorkoutSeconds == 0) return 0;
    return (_globalElapsed / totalWorkoutSeconds)
        .clamp(0.0, 1.0);
  }

  @override
  Future<void> start() async {
    if (totalRounds <= 0) return;

    _currentRound = 1;
    _phase = TimerPhase.work;
    _phaseBeforePause = TimerPhase.work;
    _elapsedBeforePause = 0;
    _globalElapsed = 0;
    _lastSecondAnnounced = null;
    _isPaused = false;

    _roundStartTime = DateTime.now();

    _emitState(secondsPerRound);
    _startTicker();
  }

  void _startTicker() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) {
        if (_isPaused || _roundStartTime == null) return;

        final elapsed =
            _elapsedBeforePause +
                DateTime.now()
                    .difference(_roundStartTime!)
                    .inSeconds;

        final remaining =
            secondsPerRound - elapsed;

        if (remaining < 0) {
          _nextRound();
          return;
        }

        if (_lastSecondAnnounced != remaining) {
          if (_lastSecondAnnounced != null &&
              _lastSecondAnnounced! > 3 &&
              remaining <= 3) {
            _soundEngine.playCountdown();
          }

          _lastSecondAnnounced = remaining;
        }

        _globalElapsed =
            ((_currentRound - 1) * secondsPerRound) +
                elapsed;

        _emitState(remaining);
      },
    );
  }

  void _nextRound() async {
    _elapsedBeforePause = 0;
    _lastSecondAnnounced = null;

    if (_currentRound >= totalRounds) {
      _timer?.cancel();
      _phase = TimerPhase.finished;

      _controller.add(
        TimerUiState(
          remainingSeconds: 0,
          currentRound: totalRounds,
          totalRounds: totalRounds,
          phase: TimerPhase.finished,
          phaseTotalSeconds: 0,
        ),
      );

      await _soundEngine.playWorkoutFinished();
      return;
    }

    _currentRound++;
    _roundStartTime = DateTime.now();

    _emitState(secondsPerRound);
  }

  void _emitState(int remaining) {
    _controller.add(
      TimerUiState(
        remainingSeconds: remaining.clamp(0, 9999),
        currentRound: _currentRound,
        totalRounds: totalRounds,
        phase: _phase,
        phaseTotalSeconds: secondsPerRound,
      ),
    );
  }

  @override
  void togglePause() {
    if (!_isPaused) {
      _elapsedBeforePause +=
          DateTime.now()
              .difference(_roundStartTime!)
              .inSeconds;

      _isPaused = true;
      _phaseBeforePause = _phase;
      _phase = TimerPhase.paused;
    } else {
      _isPaused = false;
      _roundStartTime = DateTime.now();
      _phase = _phaseBeforePause;
    }

    _emitState(secondsPerRound - _elapsedBeforePause);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}