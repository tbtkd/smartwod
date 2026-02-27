import 'workout_structure.dart';

abstract class WorkoutDefinition {
  int get totalSeconds;
  WorkoutStructure buildStructure();
}