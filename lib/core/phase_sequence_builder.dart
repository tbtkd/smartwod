import '../domain/entities/amrap_block.dart';
import 'phase_step.dart';
import 'timer_phase.dart';

class PhaseSequenceBuilder {
  static List<PhaseStep> buildAmrap(List<AmrapBlock> blocks) {
    final steps = <PhaseStep>[];

    for (int i = 0; i < blocks.length; i++) {
      final block = blocks[i];

      steps.add(
        PhaseStep(
          phase: TimerPhase.work,
          duration: block.workDuration,
        ),
      );

      if (i < blocks.length - 1 &&
          block.restDuration != null &&
          block.restDuration!.inSeconds > 0) {
        steps.add(
          PhaseStep(
            phase: TimerPhase.rest,
            duration: block.restDuration!,
          ),
        );
      }
    }

    return steps;
  }
}