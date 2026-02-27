import 'workout_segment.dart';

class WorkoutStructure {
  final List<WorkoutSegment> segments;
  final int totalRounds;

  const WorkoutStructure({
    required this.segments,
    required this.totalRounds,
  });
}