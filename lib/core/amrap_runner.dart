import 'dart:async';
import 'amrap_block.dart';
import 'timer_ui_state.dart';

class AmrapRunner {
  final List<AmrapBlock> _blocks;
  final void Function(TimerUiState) onUpdate;

  Timer? _timer;

  int _index = 0;
  TimerUiState? _state; // 🔥 nullable (evita LateInitializationError)

  bool _isPaused = false;

  AmrapRunner({
    required List<AmrapBlock> blocks,
    required this.onUpdate,
  }) : _blocks = blocks;

  // ==============================================================
  // 🔥 NUEVO: Total completo del entrenamiento (work + rest)
  // ==============================================================

  int get totalWorkoutSeconds {
    if (_blocks.isEmpty) return 0;

    int total = 0;

    for (final block in _blocks) {
      total += block.workSeconds;
      if (block.restSeconds != null && block.restSeconds! > 0) {
        total += block.restSeconds!;
      }
    }

    return total;
  }

  // ==============================================================
  // 🔥 Getter seguro para progreso del bloque actual
  // ==============================================================

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

  // ==============================================================
  // 🔥 NUEVO: Progreso global del entrenamiento
  // ==============================================================

  int get elapsedWorkoutSeconds {
    if (_blocks.isEmpty || _state == null) return 0;

    int elapsed = 0;

    for (int i = 0; i < _index; i++) {
      elapsed += _blocks[i].workSeconds;
      if (_blocks[i].restSeconds != null && _blocks[i].restSeconds! > 0) {
        elapsed += _blocks[i].restSeconds!;
      }
    }

    final currentTotal = currentBlockTotalSeconds;
    elapsed += (currentTotal - _state!.remainingSeconds);

    return elapsed.clamp(0, totalWorkoutSeconds);
  }

  // ==============================================================
  // INICIO
  // ==============================================================

  void start() {
    if (_blocks.isEmpty) return;

    _index = 0;
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
      if (_isPaused || _state == null) return;

      if (_state!.remainingSeconds > 1) {
        _state = TimerUiState(
          remainingSeconds: _state!.remainingSeconds - 1,
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

  // ==============================================================
  // PAUSA
  // ==============================================================

  void pause() {
    if (_state == null || _state!.isFinished) return;

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
    if (_state == null || !_isPaused) return;

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
    if (_isPaused) {
      resume();
    } else {
      pause();
    }
  }

  // ==============================================================
  // CAMBIO DE FASE
  // ==============================================================

  void _nextPhase() {
    if (_state == null) return;

    final current = _blocks[_index];

    // Si veníamos de descanso → regresar a trabajo
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

  // ==============================================================
  // CLEANUP
  // ==============================================================

  void dispose() {
    _timer?.cancel();
  }
}
