import '../../core/timer_phase.dart';
import 'workout_definition.dart';
import 'workout_structure.dart';
import 'workout_segment.dart';

class ForTimeDefinition extends WorkoutDefinition {
  final int timeCapSeconds;

  ForTimeDefinition({
    required this.timeCapSeconds,
  });

  @override
  int get totalSeconds => timeCapSeconds;

  @override
  WorkoutStructure buildStructure() {
    return WorkoutStructure(
      totalRounds: 1,
      segments: [
        WorkoutSegment(
          duration: timeCapSeconds,
          phase: TimerPhase.work,
          roundIndex: 1,
        ),
      ],
    );
  }
}