import 'dart:async';

import 'amrap_block.dart';
import 'timer_ui_state.dart';

class AmrapRunner {
  final List<AmrapBlock> _blocks;
  final void Function(TimerUiState) onUpdate;
  Timer? _timer;

  int _index = 0;
  TimerUiState? _state; // 🔥 ya no es late

  AmrapRunner({
    required List<AmrapBlock> blocks,
    required this.onUpdate,
  }) : _blocks = blocks;

  /// 🔥 Getter seguro incluso antes de start()
  int get currentBlockTotalSeconds {
    if (_state == null) {
      // Antes de iniciar → primer bloque de trabajo
      return _blocks.isNotEmpty ? _blocks.first.workSeconds : 1;
    }

    if (_state!.phase == TimerPhase.work) {
      return _blocks[_index].workSeconds;
    }

    if (_state!.phase == TimerPhase.rest) {
      return _blocks[_index].restSeconds ?? 0;
    }

    return 1;
  }

  void start() {
    if (_blocks.isEmpty) return;

    _index = 0;

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

  void _nextPhase() {
    if (_state == null) return;

    final current = _blocks[_index];

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

    onUpdate(_state!);
  }

  void dispose() {
    _timer?.cancel();
  }
}
