import '../../core/timer_phase.dart';
import 'workout_definition.dart';
import 'workout_structure.dart';
import 'workout_segment.dart';

class EmomDefinition implements WorkoutDefinition {
  final int totalRounds;
  final int secondsPerRound;

  EmomDefinition({
    required this.totalRounds,
    required this.secondsPerRound,
  });

  @override
  int get totalSeconds => totalRounds * secondsPerRound;

  @override
  WorkoutStructure buildStructure() {
    final segments = <WorkoutSegment>[];

    for (int i = 0; i < totalRounds; i++) {
      segments.add(
        WorkoutSegment(
          phase: TimerPhase.work,
          duration: secondsPerRound,
          roundIndex: i + 1,
        ),
      );
    }

    return WorkoutStructure(
      segments: segments,
      totalRounds: totalRounds,
    );
  }
}