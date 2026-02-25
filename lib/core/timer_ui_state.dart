import 'timer_phase.dart';

class TimerUiState {
  final int remainingSeconds;
  final int phaseTotalSeconds;

  final int currentRound;
  final int totalRounds;

  final TimerPhase phase;

  final bool isPaused;

  const TimerUiState({
    required this.remainingSeconds,
    required this.phaseTotalSeconds,
    required this.currentRound,
    required this.totalRounds,
    required this.phase,
    this.isPaused = false,
  });

  bool get isFinished => phase == TimerPhase.finished;

  double get phaseProgress {
    if (phaseTotalSeconds == 0) return 0;
    return 1 - (remainingSeconds / phaseTotalSeconds);
  }
}