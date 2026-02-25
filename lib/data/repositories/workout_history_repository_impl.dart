import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/workout_result.dart';
import '../../domain/enums/workout_type.dart';
import 'workout_history_repository.dart';

/// ===============================================================
/// WORKOUT HISTORY REPOSITORY IMPLEMENTATION
///
/// Persistencia local usando SharedPreferences.
/// Guarda historial en formato JSON serializado.
///
/// Compatible con múltiples modos (AMRAP, EMOM, etc.)
/// gracias a metadata estructurada.
/// ===============================================================
class WorkoutHistoryRepositoryImpl
    implements WorkoutHistoryRepository {

  static const String _key = 'workout_history';

  // ===============================================================
  // SAVE
  // ===============================================================
  @override
  Future<void> save(WorkoutResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    List<Map<String, dynamic>> list = [];

    /// Si ya existe historial, lo decodificamos
    if (raw != null && raw.isNotEmpty) {
      final decoded = jsonDecode(raw) as List;
      list = decoded.cast<Map<String, dynamic>>();
    }

    /// Insertamos el nuevo resultado al inicio (más reciente primero)
    list.insert(0, {
      'type': result.type.index,
      'date': result.date.toIso8601String(),
      'totalSeconds': result.totalSeconds,
      'note': result.note,

      /// Metadata ya viene estructurada como Map<String, dynamic>
      /// Puede contener:
      /// - blocks (AMRAP)
      /// - rounds / secondsPerRound (EMOM)
      /// - etc.
      'metadata': result.metadata,
    });

    await prefs.setString(_key, jsonEncode(list));
  }

  // ===============================================================
  // LOAD ALL
  // ===============================================================
  @override
  Future<List<WorkoutResult>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw == null || raw.isEmpty) return [];

    final decoded = jsonDecode(raw) as List;

    return decoded.map((e) {
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

        /// Metadata se recupera tal cual fue guardada
        /// No se interpreta aquí (eso es responsabilidad superior)
        metadata: e['metadata'] is Map<String, dynamic>
            ? e['metadata']
            : null,
      );
    }).toList();
  }

  // ===============================================================
  // UPDATE
  // ===============================================================
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
          'metadata': result.metadata,
        };
      }
      return e;
    }).toList();

    await prefs.setString(_key, jsonEncode(updated));
  }

  // ===============================================================
  // CLEAR
  // ===============================================================
  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}