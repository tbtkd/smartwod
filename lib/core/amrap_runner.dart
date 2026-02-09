import 'dart:async';

import 'amrap_block.dart';
import 'timer_ui_state.dart';

class AmrapRunner {
  final List<AmrapBlock> _blocks;
  final void Function(TimerUiState) onUpdate;
  Timer? _timer;

  int _index = 0;
  late TimerUiState _state;

  AmrapRunner({
    required List<AmrapBlock> blocks,
    required this.onUpdate,
  }) : _blocks = blocks;

  void start() {
    _index = 0;

    _state = TimerUiState(
      remainingSeconds: _blocks.first.workSeconds,
      currentRound: 1,
      totalRounds: _blocks.length,
      phase: TimerPhase.work,
    );

    onUpdate(_state);
    _tick();
  }

  void _tick() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_state.remainingSeconds > 1) {
        _state = TimerUiState(
          remainingSeconds: _state.remainingSeconds - 1,
          currentRound: _state.currentRound,
          totalRounds: _state.totalRounds,
          phase: _state.phase,
        );
        onUpdate(_state);
      } else {
        _nextPhase();
      }
    });
  }

  void _nextPhase() {
    final current = _blocks[_index];

    if (_state.phase == TimerPhase.rest) {
      _state = TimerUiState(
        remainingSeconds: current.workSeconds,
        currentRound: _index + 1,
        totalRounds: _blocks.length,
        phase: TimerPhase.work,
      );
      onUpdate(_state);
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
      onUpdate(_state);
      return;
    }

    final next = _blocks[_index];

    if (next.restSeconds != null) {
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

    onUpdate(_state);
  }

  void dispose() {
    _timer?.cancel();
  }
}
