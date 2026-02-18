import 'dart:async';
import 'amrap_block.dart';
import 'timer_ui_state.dart';
import '../utils/feedback_service.dart';

class AmrapRunner {
  final List<AmrapBlock> _blocks;
  final void Function(TimerUiState) onUpdate;

  Timer? _timer;

  int _index = 0;
  TimerUiState? _state;

  int _elapsedSeconds = 0;

  DateTime? _phaseStartTime;
  int _phaseDuration = 0;

  AmrapRunner({
    required List<AmrapBlock> blocks,
    required this.onUpdate,
  }) : _blocks = blocks;

  // =============================
  // GETTERS
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

    if (_index >= _blocks.length) {
      return _blocks.last.workSeconds;
    }

    final current = _blocks[_index];

    if (_state?.phase == TimerPhase.rest) {
      return current.restSeconds ?? current.workSeconds;
    }

    return current.workSeconds;
  }

  // =============================
  // PUBLIC API
  // =============================

  void start() {
    if (_blocks.isEmpty) return;

    _timer?.cancel();

    _index = 0;
    _elapsedSeconds = 0;

    final first = _blocks.first;

    _phaseDuration = first.workSeconds;
    _phaseStartTime = DateTime.now();

    _state = TimerUiState(
      remainingSeconds: first.workSeconds,
      currentRound: 1,
      totalRounds: _blocks.length,
      phase: TimerPhase.work,
    );

    onUpdate(_state!);
    _startTick();
  }

  void togglePause() {
    if (_state == null) return;

    if (_state!.phase == TimerPhase.rest ||
        _state!.phase == TimerPhase.finished) {
      return;
    }

    if (_state!.phase == TimerPhase.paused) {
      // Reanudar
      _phaseStartTime = DateTime.now()
          .subtract(Duration(
              seconds: _phaseDuration -
                  _state!.remainingSeconds));

      _state = TimerUiState(
        remainingSeconds: _state!.remainingSeconds,
        currentRound: _state!.currentRound,
        totalRounds: _state!.totalRounds,
        phase: TimerPhase.work,
      );
    } else {
      // Pausar
      _state = TimerUiState(
        remainingSeconds: _state!.remainingSeconds,
        currentRound: _state!.currentRound,
        totalRounds: _state!.totalRounds,
        phase: TimerPhase.paused,
      );
    }

    onUpdate(_state!);
  }

  void dispose() {
    _timer?.cancel();
  }

  // =============================
  // ENGINE PRECISO
  // =============================

  void _startTick() {
    _timer?.cancel();

    _timer = Timer.periodic(
        const Duration(milliseconds: 200), (_) {
      if (_state == null) return;

      if (_state!.phase != TimerPhase.work &&
          _state!.phase != TimerPhase.rest) {
        return;
      }

      final now = DateTime.now();
      final elapsed =
          now.difference(_phaseStartTime!).inSeconds;

      final remaining =
          (_phaseDuration - elapsed).clamp(0, _phaseDuration);

      if (remaining > 0) {
        _elapsedSeconds =
            totalWorkoutSeconds - _remainingTotalEstimate();

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
    });
  }

  int _remainingTotalEstimate() {
    int remaining = 0;

    // fase actual
    remaining += _state?.remainingSeconds ?? 0;

    // fases futuras
    for (int i = _index + 1; i < _blocks.length; i++) {
      remaining += _blocks[i].workSeconds;
      if (i > 0) {
        remaining += _blocks[i].restSeconds ?? 0;
      }
    }

    return remaining;
  }

  void _nextPhase() {
    if (_state == null) return;

    final current = _blocks[_index];

    if (_state!.phase == TimerPhase.rest) {
      _phaseDuration = current.workSeconds;
      _phaseStartTime = DateTime.now();

      _state = TimerUiState(
        remainingSeconds: current.workSeconds,
        currentRound: _index + 1,
        totalRounds: _blocks.length,
        phase: TimerPhase.work,
      );

      onUpdate(_state!);
      FeedbackService.playPhaseChange();
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
      FeedbackService.playWorkoutFinished();
      return;
    }

    final next = _blocks[_index];

    if (next.restSeconds != null &&
        next.restSeconds! > 0) {
      _phaseDuration = next.restSeconds!;
      _phaseStartTime = DateTime.now();

      _state = TimerUiState(
        remainingSeconds: next.restSeconds!,
        currentRound: _index + 1,
        totalRounds: _blocks.length,
        phase: TimerPhase.rest,
      );
    } else {
      _phaseDuration = next.workSeconds;
      _phaseStartTime = DateTime.now();

      _state = TimerUiState(
        remainingSeconds: next.workSeconds,
        currentRound: _index + 1,
        totalRounds: _blocks.length,
        phase: TimerPhase.work,
      );
    }

    onUpdate(_state!);
    FeedbackService.playPhaseChange();
  }
}
