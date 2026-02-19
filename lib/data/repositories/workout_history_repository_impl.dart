import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/workout_result.dart';
import '../../domain/enums/workout_type.dart';
import 'workout_history_repository.dart';

class WorkoutHistoryRepositoryImpl
    implements WorkoutHistoryRepository {

  static const _key = 'workout_history';

  @override
  Future<void> save(WorkoutResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    List<Map<String, dynamic>> list = [];

    if (raw != null) {
      list = (jsonDecode(raw) as List)
          .cast<Map<String, dynamic>>();
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

    if (raw == null) return [];

    final decoded = jsonDecode(raw) as List;

    return decoded.map((e) {
      return WorkoutResult(
        type: WorkoutType.values[e['type']],
        date: DateTime.parse(e['date']),
        totalSeconds: e['totalSeconds'],
      );
    }).toList();
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
