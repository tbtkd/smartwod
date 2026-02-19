import '../enums/workout_type.dart';

class WorkoutResult {
  final WorkoutType type;
  final DateTime date;
  final int totalSeconds;

  WorkoutResult({
    required this.type,
    required this.date,
    required this.totalSeconds,
  });
}
