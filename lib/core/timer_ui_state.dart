import 'timer_phase.dart';

class TimerUiState {
  final int remainingSeconds;
  final int phaseTotalSeconds;
  final int currentRound;
  final int totalRounds;
  final TimerPhase phase;

  const TimerUiState({
    required this.remainingSeconds,
    required this.phaseTotalSeconds,
    required this.currentRound,
    required this.totalRounds,
    required this.phase,
  });

  bool get isFinished => phase == TimerPhase.finished;
}