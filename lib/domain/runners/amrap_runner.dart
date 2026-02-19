import 'dart:async';
import '../services/workout_audio_service.dart';
import '../../core/timer_ui_state.dart';
import '../../core/amrap_block.dart';
import 'workout_runner.dart';

class AmrapRunner implements WorkoutRunner {
  final List<AmrapBlock> _blocks;
  final void Function(TimerUiState) onUpdate;
  final WorkoutAudioService _audioService;

  Timer? _timer;

  int _index = 0;
  TimerUiState? _state;

  bool _isPaused = false;
  DateTime? _phaseStartTime;
  int _elapsedSeconds = 0;

  AmrapRunner({
    required List<AmrapBlock> blocks,
    required this.onUpdate,
    required WorkoutAudioService audioService,
  })  : _blocks = blocks,
        _audioService = audioService;

  // 🔥 NUEVO GETTER CORRECTO
  int get elapsedSeconds => _elapsedSeconds;

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
      return current.restSeconds ?? current.workSeconds;
    }

    return current.workSeconds;
  }

  @override
  void start() {
    if (_blocks.isEmpty) return;

    _index = 0;
    _elapsedSeconds = 0;
    _isPaused = false;

    _phaseStartTime = DateTime.now();

    _state = TimerUiState(
      remainingSeconds: _blocks.first.workSeconds,
      currentRound: 1,
      totalRounds: _blocks.length,
      phase: TimerPhase.work,
    );

    onUpdate(_state!);
    _tick();
  }

  void _tick() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) {
        if (_state == null ||
            _isPaused ||
            _phaseStartTime == null) return;

        final now = DateTime.now();
        final elapsed =
            now.difference(_phaseStartTime!).inSeconds;

        final totalDuration = currentBlockTotalSeconds;
        final remaining = totalDuration - elapsed;

        // 🔥 CÁLCULO REAL DEL TIEMPO GLOBAL
        final totalElapsed =
            (_blocks
                    .take(_index)
                    .fold<int>(0, (sum, block) {
              final work = block.workSeconds;
              final rest = block.restSeconds ?? 0;
              return sum + work + rest;
            })) +
                (totalDuration - remaining);

        _elapsedSeconds = totalElapsed.clamp(
            0, totalWorkoutSeconds);

        if (remaining > 0) {
          _state = TimerUiState(
            remainingSeconds: remaining,
            currentRound: _state!.currentRound,
            totalRounds: _state!.totalRounds,
            phase: _state!.phase,
          );
          onUpdate(_state!);
        } else {
          _nextPhase();
        }
      },
    );
  }

  void _nextPhase() async {
    if (_state == null) return;

    final current = _blocks[_index];

    if (_state!.phase == TimerPhase.rest) {
      _phaseStartTime = DateTime.now();

      _state = TimerUiState(
        remainingSeconds: current.workSeconds,
        currentRound: _index + 1,
        totalRounds: _blocks.length,
        phase: TimerPhase.work,
      );

      onUpdate(_state!);
      await _audioService.playPhaseChange();
      return;
    }

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
      await _audioService.playWorkoutFinished();
      return;
    }

    final next = _blocks[_index];

    _phaseStartTime = DateTime.now();

    if (next.restSeconds != null &&
        next.restSeconds! > 0) {
      _state = TimerUiState(
        remainingSeconds: next.restSeconds!,
        currentRound: _index + 1,
        totalRounds: _blocks.length,
        phase: TimerPhase.rest,
      );
    } else {
      _state = TimerUiState(
        remainingSeconds: next.workSeconds,
        currentRound: _index + 1,
        totalRounds: _blocks.length,
        phase: TimerPhase.work,
      );
    }

    onUpdate(_state!);
    await _audioService.playPhaseChange();
  }

  @override
  void togglePause() {
    if (_state == null ||
        _state!.phase == TimerPhase.rest) return;

    _isPaused = !_isPaused;

    if (!_isPaused) {
      _phaseStartTime = DateTime.now();
    }

    _state = TimerUiState(
      remainingSeconds: _state!.remainingSeconds,
      currentRound: _state!.currentRound,
      totalRounds: _state!.totalRounds,
      phase: _isPaused
          ? TimerPhase.paused
          : TimerPhase.work,
    );

    onUpdate(_state!);
  }

  @override
  void dispose() {
    _timer?.cancel();
  }
}
