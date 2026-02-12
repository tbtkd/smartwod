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

  const TimerUiState({
    required this.remainingSeconds,
    required this.currentRound,
    required this.totalRounds,
    required this.phase,
  });

  bool get isWork => phase == TimerPhase.work;
  bool get isRest => phase == TimerPhase.rest;
  bool get isPaused => phase == TimerPhase.paused;
  bool get isFinished => phase == TimerPhase.finished;
}
