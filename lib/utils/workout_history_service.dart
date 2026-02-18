import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout_history_entry.dart';

class WorkoutHistoryService {
  static const String _key = 'workout_history';

  static Future<void> addEntry(WorkoutHistoryEntry entry) async {
    final prefs = await SharedPreferences.getInstance();

    final existing = prefs.getString(_key);
    List<Map<String, dynamic>> list = [];

    if (existing != null) {
      final decoded = jsonDecode(existing) as List;
      list = decoded.cast<Map<String, dynamic>>();
    }

    list.insert(0, entry.toJson());

    await prefs.setString(_key, jsonEncode(list));
  }

  static Future<List<WorkoutHistoryEntry>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw == null) return [];

    final decoded = jsonDecode(raw) as List;

    return decoded
        .map((e) => WorkoutHistoryEntry.fromJson(e))
        .toList();
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
