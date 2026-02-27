import '../../core/timer_phase.dart';
import 'workout_definition.dart';
import 'workout_structure.dart';
import 'workout_segment.dart';

class TabataDefinition implements WorkoutDefinition {
  final int workSeconds;
  final int restSeconds;
  final int rounds;

  TabataDefinition({
    required this.workSeconds,
    required this.restSeconds,
    required this.rounds,
  });

  @override
  int get totalSeconds =>
      rounds * (workSeconds + restSeconds);

  @override
  WorkoutStructure buildStructure() {
    final segments = <WorkoutSegment>[];

    for (int i = 0; i < rounds; i++) {
      // Work
      segments.add(
        WorkoutSegment(
          phase: TimerPhase.work,
          duration: workSeconds,
          roundIndex: i + 1,
        ),
      );

      // Rest
      segments.add(
        WorkoutSegment(
          phase: TimerPhase.rest,
          duration: restSeconds,
          roundIndex: i + 1,
        ),
      );
    }

    return WorkoutStructure(
      segments: segments,
      totalRounds: rounds,
    );
  }
}