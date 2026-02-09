enum TimerPhase {
  rest,
  work,
  finished,
}

class TimerUiState {
  final int remainingSeconds;
  final int currentRound;
  final int totalRounds;
  final TimerPhase phase;

  const TimerUiState({
    required this.remainingSeconds,
    required this.currentRound,
    required this.totalRounds,
    required this.phase,
  });
}
