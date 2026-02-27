import 'dart:async';

import '../../core/timer_ui_state.dart';
import '../../core/timer_phase.dart';
import '../../core/audio/sound_engine.dart';
import '../definitions/workout_definition.dart';
import '../definitions/workout_structure.dart';
import '../definitions/workout_segment.dart';
import 'workout_runner.dart';

class SegmentRunner implements WorkoutRunner {
  final WorkoutDefinition definition;
  final SoundEngine _soundEngine;

  final StreamController<TimerUiState> _controller =
      StreamController.broadcast();

  @override
  Stream<TimerUiState> get stream => _controller.stream;

  late final WorkoutStructure _structure;
  late final List<WorkoutSegment> _segments;

  Timer? _timer;

  int _segmentIndex = 0;
  int _elapsedBeforePause = 0;
  int _globalElapsed = 0;

  DateTime? _segmentStartTime;

  TimerPhase _phase = TimerPhase.work;
  TimerPhase _phaseBeforePause = TimerPhase.work;

  bool _isPaused = false;
  int? _lastSecondAnnounced;

  SegmentRunner({
    required this.definition,
    required SoundEngine soundEngine,
  }) : _soundEngine = soundEngine {
    _structure = definition.buildStructure();
    _segments = _structure.segments;
  }

  @override
  int get totalWorkoutSeconds => definition.totalSeconds;

  @override
  double get globalProgress {
    if (totalWorkoutSeconds == 0) return 0;
    return (_globalElapsed / totalWorkoutSeconds)
        .clamp(0.0, 1.0);
  }

  @override
  Future<void> start() async {
    if (_segments.isEmpty || _structure.totalRounds <= 0) {
      return;
    }

    _segmentIndex = 0;
    _elapsedBeforePause = 0;
    _globalElapsed = 0;
    _isPaused = false;
    _lastSecondAnnounced = null;

    _startSegment();
  }

  void _startSegment() {
    if (_segmentIndex < 0 || _segmentIndex >= _segments.length) {
      return;
    }

    final segment = _segments[_segmentIndex];

    _phase = segment.phase;
    _phaseBeforePause = segment.phase;
    _segmentStartTime = DateTime.now();

    _emitState(segment.duration);
    _startTicker();
  }

  void _startTicker() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) {
        if (_isPaused || _segmentStartTime == null) return;

        final elapsed =
            _elapsedBeforePause +
                DateTime.now()
                    .difference(_segmentStartTime!)
                    .inSeconds;

        final segment = _segments[_segmentIndex];
        final remaining = segment.duration - elapsed;

        if (remaining < 0) {
          _lastSecondAnnounced = null;
          _nextSegment();
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
            _calculateGlobalElapsed(elapsed);

        _emitState(remaining);
      },
    );
  }

  int _calculateGlobalElapsed(int currentElapsed) {
    int total = 0;

    for (int i = 0; i < _segmentIndex; i++) {
      total += _segments[i].duration;
    }

    total += currentElapsed;

    return total.clamp(0, totalWorkoutSeconds);
  }

  void _nextSegment() async {
    _elapsedBeforePause = 0;
    _segmentIndex++;

    if (_segmentIndex >= _segments.length) {
      _timer?.cancel();
      _phase = TimerPhase.finished;

      _controller.add(
        TimerUiState(
          remainingSeconds: 0,
          currentRound: _structure.totalRounds,
          totalRounds: _structure.totalRounds,
          phase: TimerPhase.finished,
          phaseTotalSeconds: 0,
        ),
      );

      await _soundEngine.playWorkoutFinished();
      return;
    }

    _startSegment();
  }

  void _emitState(int remaining) {
    if (_segmentIndex < 0 || _segmentIndex >= _segments.length) {
      return;
    }

    final segment = _segments[_segmentIndex];

    _controller.add(
      TimerUiState(
        remainingSeconds: remaining.clamp(0, 9999),
        currentRound: segment.roundIndex,
        totalRounds: _structure.totalRounds,
        phase: _phase,
        phaseTotalSeconds: segment.duration,
      ),
    );
  }

  @override
  void togglePause() {
    if (_phase == TimerPhase.rest) return;

    if (!_isPaused) {
      _elapsedBeforePause +=
          DateTime.now()
              .difference(_segmentStartTime!)
              .inSeconds;

      _isPaused = true;
      _phaseBeforePause = _phase;
      _phase = TimerPhase.paused;
    } else {
      _isPaused = false;
      _segmentStartTime = DateTime.now();
      _phase = _phaseBeforePause;
    }

    _emitState(
      _segments[_segmentIndex].duration -
          _elapsedBeforePause,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}