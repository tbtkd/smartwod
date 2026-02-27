import '../../core/timer_phase.dart';

class WorkoutSegment {
  final TimerPhase phase;
  final int duration;
  final int roundIndex;

  const WorkoutSegment({
    required this.phase,
    required this.duration,
    required this.roundIndex,
  });
}