import '../../core/amrap_block.dart';
import '../../core/timer_phase.dart';
import 'workout_definition.dart';
import 'workout_structure.dart';
import 'workout_segment.dart';

class AmrapDefinition implements WorkoutDefinition {
  final List<AmrapBlock> blocks;

  AmrapDefinition({required this.blocks});

  @override
  int get totalSeconds {
    int total = 0;
    for (int i = 0; i < blocks.length; i++) {
      total += blocks[i].workSeconds;
      if (i > 0) {
        total += blocks[i].restSeconds ?? 0;
      }
    }
    return total;
  }

  @override
  WorkoutStructure buildStructure() {
    final segments = <WorkoutSegment>[];

    for (int i = 0; i < blocks.length; i++) {
      if (i > 0 && blocks[i].restSeconds != null && blocks[i].restSeconds! > 0) {
        segments.add(
          WorkoutSegment(
            phase: TimerPhase.rest,
            duration: blocks[i].restSeconds!,
            roundIndex: i + 1,
          ),
        );
      }

      segments.add(
        WorkoutSegment(
          phase: TimerPhase.work,
          duration: blocks[i].workSeconds,
          roundIndex: i + 1,
        ),
      );
    }

    return WorkoutStructure(
      segments: segments,
      totalRounds: blocks.length,
    );
  }
}