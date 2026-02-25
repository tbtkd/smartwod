import '../enums/workout_type.dart';

/// ===============================================================
/// WORKOUT RESULT
///
/// Representa el resultado final de un entrenamiento.
/// Se utiliza para almacenar información en el historial.
///
/// Esta clase pertenece a la capa de dominio (domain layer).
/// No depende de UI.
/// No depende de runners.
///
/// Es flexible para soportar múltiples modos:
/// - AMRAP
/// - EMOM
/// - TABATA
/// - FOR TIME
/// - MIX
/// ===============================================================
class WorkoutResult {

  /// Tipo de entrenamiento realizado
  /// Determina cómo debe interpretarse la metadata.
  final WorkoutType type;

  /// Fecha y hora en que se realizó el entrenamiento
  final DateTime date;

  /// Duración total en segundos
  final int totalSeconds;

  /// Información adicional específica del modo.
  ///
  /// Se estandariza como Map<String, dynamic> para:
  /// - Permitir serialización futura (JSON, SQLite, Hive)
  /// - Evitar acoplamiento a clases concretas
  /// - Facilitar expansión a nuevos modos
  ///
  /// Ejemplos:
  /// - AMRAP → { "blocks": List<AmrapBlock> }
  /// - EMOM → { "rounds": 5, "secondsPerRound": 60 }
  /// - TABATA → { "work": 20, "rest": 10, "rounds": 8 }
  /// - FOR TIME → null
  /// - MIX → estructura combinada
  final Map<String, dynamic>? metadata;

  /// Nota opcional del usuario
  final String? note;

  WorkoutResult({
    required this.type,
    required this.date,
    required this.totalSeconds,
    this.metadata,
    this.note,
  });

  /// ===============================================================
  /// COPY WITH
  ///
  /// Permite clonar el objeto modificando campos específicos.
  /// Útil para:
  /// - Agregar nota después
  /// - Editar historial
  /// - Modificar metadata sin alterar el objeto original
  /// ===============================================================
  WorkoutResult copyWith({
    WorkoutType? type,
    DateTime? date,
    int? totalSeconds,
    Map<String, dynamic>? metadata,
    String? note,
  }) {
    return WorkoutResult(
      type: type ?? this.type,
      date: date ?? this.date,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      metadata: metadata ?? this.metadata,
      note: note ?? this.note,
    );
  }
}