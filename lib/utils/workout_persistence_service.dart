import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/amrap_block.dart';
import '../core/timer_ui_state.dart';

class WorkoutPersistenceService {
  static const String _key = 'active_workout';

  static Future<void> saveWorkout({
    required List<AmrapBlock> blocks,
    required int index,
    required TimerPhase phase,
    required int phaseDuration,
    required DateTime phaseStartTime,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final data = {
      'blocks': blocks
          .map((b) => {
                'work': b.workSeconds,
                'rest': b.restSeconds,
              })
          .toList(),
      'index': index,
      'phase': phase.index,
      'phaseDuration': phaseDuration,
      'phaseStartTime': phaseStartTime.toIso8601String(),
    };

    await prefs.setString(_key, jsonEncode(data));
  }

  static Future<Map<String, dynamic>?> loadWorkout() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw == null) return null;

    return jsonDecode(raw);
  }

  static Future<void> clearWorkout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
