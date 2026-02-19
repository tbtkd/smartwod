import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/workout_result.dart';
import '../../domain/enums/workout_type.dart';
import 'workout_history_repository.dart';

class WorkoutHistoryRepositoryImpl
    implements WorkoutHistoryRepository {

  static const String _key = 'workout_history';

  @override
  Future<void> save(WorkoutResult result) async {
    final prefs = await SharedPreferences.getInstance();

    final raw = prefs.getString(_key);
    List<Map<String, dynamic>> list = [];

    if (raw != null && raw.isNotEmpty) {
      final decoded = jsonDecode(raw) as List;
      list = decoded.cast<Map<String, dynamic>>();
    }

    list.insert(0, {
      'type': result.type.index,
      'date': result.date.toIso8601String(),
      'totalSeconds': result.totalSeconds,
    });

    await prefs.setString(_key, jsonEncode(list));
  }

  @override
  Future<List<WorkoutResult>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw == null || raw.isEmpty) return [];

    final decoded = jsonDecode(raw) as List;

    final results = <WorkoutResult>[];

    for (final e in decoded) {
      try {
        final typeIndex = e['type'];

        final WorkoutType type =
            (typeIndex is int &&
                    typeIndex >= 0 &&
                    typeIndex < WorkoutType.values.length)
                ? WorkoutType.values[typeIndex]
                : WorkoutType.amrap;

        final int seconds =
            (e['totalSeconds'] is int)
                ? e['totalSeconds']
                : 0;

        final DateTime date =
            (e['date'] != null)
                ? DateTime.tryParse(e['date']) ??
                    DateTime.now()
                : DateTime.now();

        results.add(
          WorkoutResult(
            type: type,
            date: date,
            totalSeconds: seconds,
          ),
        );
      } catch (_) {
        // Ignora entradas corruptas
      }
    }

    return results;
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
