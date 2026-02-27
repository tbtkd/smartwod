import 'package:flutter/material.dart';
import '../domain/enums/workout_type.dart';

extension WorkoutTypeColor on WorkoutType {
  Color get color {
    switch (this) {
      case WorkoutType.amrap:
        return Colors.orange;
      case WorkoutType.emom:
        return Colors.purple;
      case WorkoutType.tabata:
        return Colors.blue;
      case WorkoutType.forTime:
        return Colors.green;
      case WorkoutType.mix:
        return Colors.grey;
    }
  }


 String get displayName {
    switch (this) {
      case WorkoutType.amrap:
        return "AMRAP";
      case WorkoutType.emom:
        return "EMOM";
      case WorkoutType.tabata:
        return "TABATA";
      case WorkoutType.forTime:
        return "FOR TIME";
      case WorkoutType.mix:
        return "MIX";
    }
  }
}