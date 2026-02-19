import '../enums/workout_type.dart';
import '../../core/amrap_block.dart';

class WorkoutResult {
  final WorkoutType type;
  final DateTime date;
  final int totalSeconds;
  final List<AmrapBlock>? blocks;
  final String? note;

  WorkoutResult({
    required this.type,
    required this.date,
    required this.totalSeconds,
    this.blocks,
    this.note,
  });

  WorkoutResult copyWith({
    WorkoutType? type,
    DateTime? date,
    int? totalSeconds,
    List<AmrapBlock>? blocks,
    String? note,
  }) {
    return WorkoutResult(
      type: type ?? this.type,
      date: date ?? this.date,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      blocks: blocks ?? this.blocks,
      note: note ?? this.note,
    );
  }
}
