import '../../domain/entities/workout_result.dart';

abstract class WorkoutHistoryRepository {
  Future<void> save(WorkoutResult result);
  Future<List<WorkoutResult>> loadAll();
  Future<void> clear();
}
