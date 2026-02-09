/// Representa un bloque dentro de un AMRAP
/// Puede ser de trabajo o de descanso
class AmrapBlock {
  // Duración del bloque en segundos
  final int durationSeconds;

  // true = descanso, false = trabajo (AMRAP)
  final bool isRest;

  const AmrapBlock({
    required this.durationSeconds,
    required this.isRest,
  });
}
