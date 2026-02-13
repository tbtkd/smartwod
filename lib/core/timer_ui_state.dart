enum TimerPhase {
  work,
  rest,
  paused,
  finished,
}

class TimerUiState {
  final int remainingSeconds;
  final int currentRound;
  final int totalRounds;
  final TimerPhase phase;

  // 🔥 NUEVO
  final TimerPhase? previousPhase;

  const TimerUiState({
    required this.remainingSeconds,
    required this.currentRound,
    required this.totalRounds,
    required this.phase,
    this.previousPhase,
  });

  bool get isFinished => phase == TimerPhase.finished;
}
