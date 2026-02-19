import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/workout_result.dart';
import '../../domain/enums/workout_type.dart';
import '../../core/amrap_block.dart';
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
      'note': result.note,
      'blocks': result.blocks?.map((b) => {
        'workSeconds': b.workSeconds,
        'restSeconds': b.restSeconds,
      }).toList(),
    });

    await prefs.setString(_key, jsonEncode(list));
  }

  @override
  Future<List<WorkoutResult>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw == null || raw.isEmpty) return [];

    final decoded = jsonDecode(raw) as List;

    return decoded.map((e) {
      final blocksRaw = e['blocks'] as List?;

      final blocks = blocksRaw?.map((b) {
        return AmrapBlock(
          workSeconds: b['workSeconds'],
          restSeconds: b['restSeconds'],
        );
      }).toList();

      return WorkoutResult(
        type: WorkoutType.values[
            (e['type'] is int) ? e['type'] : 0],
        date: DateTime.tryParse(e['date']) ??
            DateTime.now(),
        totalSeconds:
            (e['totalSeconds'] is int)
                ? e['totalSeconds']
                : 0,
        note: e['note'] is String
            ? e['note']
            : null,
        blocks: blocks,
      );
    }).toList();
  }

  Future<void> update(WorkoutResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw == null) return;

    final decoded = jsonDecode(raw) as List;

    final updated = decoded.map((e) {
      if (e['date'] ==
          result.date.toIso8601String()) {
        return {
          'type': result.type.index,
          'date': result.date.toIso8601String(),
          'totalSeconds': result.totalSeconds,
          'note': result.note,
          'blocks': result.blocks?.map((b) => {
            'workSeconds': b.workSeconds,
            'restSeconds': b.restSeconds,
          }).toList(),
        };
      }
      return e;
    }).toList();

    await prefs.setString(_key, jsonEncode(updated));
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
