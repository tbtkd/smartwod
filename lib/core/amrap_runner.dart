import 'dart:async';
import 'amrap_block.dart';
import 'timer_ui_state.dart';

class AmrapRunner {
  final List<AmrapBlock> _blocks;
  final void Function(TimerUiState) onUpdate;

  Timer? _timer;

  int _index = 0;
  TimerUiState? _state;

  bool _isPaused = false;
  int _elapsedSeconds = 0;

  AmrapRunner({
    required List<AmrapBlock> blocks,
    required this.onUpdate,
  }) : _blocks = blocks;

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
    return (_elapsedSeconds / totalWorkoutSeconds).clamp(0.0, 1.0);
  }

  int get currentBlockTotalSeconds {
    if (_blocks.isEmpty) return 1;

    if (_state == null) {
      return _blocks.first.workSeconds;
    }

    if (_index >= _blocks.length) {
      return _blocks.last.workSeconds;
    }

    final current = _blocks[_index];

    if (_state!.phase == TimerPhase.rest) {
      return current.restSeconds ?? current.workSeconds;
    }

    return current.workSeconds;
  }

  void start() {
    if (_blocks.isEmpty) return;

    _index = 0;
    _elapsedSeconds = 0;
    _isPaused = false;

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

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_state == null) return;

      // 🔥 pausa solo afecta trabajo
      if (_isPaused && _state!.phase != TimerPhase.rest) {
        return;
      }

      if (_state!.remainingSeconds > 1) {
        _elapsedSeconds++;

        _state = TimerUiState(
          remainingSeconds: _state!.remainingSeconds - 1,
          currentRound: _state!.currentRound,
          totalRounds: _state!.totalRounds,
          phase: _state!.phase,
        );

        onUpdate(_state!);
      } else {
        _elapsedSeconds++;
        _nextPhase();
      }
    });
  }

  void pause() {
    if (_state == null) return;

    // 🔥 NO permitir pausa en descanso
    if (_state!.phase == TimerPhase.rest) return;

    if (_state!.isFinished) return;

    _isPaused = true;

    _state = TimerUiState(
      remainingSeconds: _state!.remainingSeconds,
      currentRound: _state!.currentRound,
      totalRounds: _state!.totalRounds,
      phase: TimerPhase.paused,
    );

    onUpdate(_state!);
  }

  void resume() {
    if (_state == null) return;
    if (!_isPaused) return;

    _isPaused = false;

    _state = TimerUiState(
      remainingSeconds: _state!.remainingSeconds,
      currentRound: _state!.currentRound,
      totalRounds: _state!.totalRounds,
      phase: TimerPhase.work,
    );

    onUpdate(_state!);
  }

  void togglePause() {
    if (_state == null) return;

    // 🔥 descanso completamente bloqueado
    if (_state!.phase == TimerPhase.rest) return;

    if (_isPaused) {
      resume();
    } else {
      pause();
    }
  }

  void _nextPhase() {
    if (_state == null) return;

    final current = _blocks[_index];

    // Si venimos de descanso → iniciar trabajo
    if (_state!.phase == TimerPhase.rest) {
      _state = TimerUiState(
        remainingSeconds: current.workSeconds,
        currentRound: _index + 1,
        totalRounds: _blocks.length,
        phase: TimerPhase.work,
      );

      onUpdate(_state!);
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
      return;
    }

    final next = _blocks[_index];

    if (next.restSeconds != null && next.restSeconds! > 0) {
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
  }

  void dispose() {
    _timer?.cancel();
  }
}
