import 'package:flutter/material.dart';

import '../../data/repositories/workout_history_repository_impl.dart';
import '../../domain/entities/workout_result.dart';
import 'workout_detail_screen.dart';
import '../../domain/enums/workout_type.dart';

/// ===============================================================
/// WORKOUT HISTORY SCREEN
///
/// Muestra el historial completo de entrenamientos realizados.
///
/// RESPONSABILIDADES
/// - Cargar historial desde el repositorio
/// - Mostrar resumen global
/// - Mostrar lista de entrenamientos
/// - Navegar al detalle del entrenamiento
///
/// NOTA:
/// Este screen solo interpreta metadata, no la genera.
/// La metadata se crea en TimerScreen.
/// ===============================================================
class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  State<WorkoutHistoryScreen> createState() =>
      _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState
    extends State<WorkoutHistoryScreen> {

  /// Repositorio de historial
  final _repository = WorkoutHistoryRepositoryImpl();

  /// Lista de entrenamientos guardados
  List<WorkoutResult> _history = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// ===============================================================
  /// CARGA HISTORIAL
  /// ===============================================================
  Future<void> _load() async {

    final data = await _repository.loadAll();

    if (!mounted) return;

    setState(() {
      _history = data;
    });
  }

  /// ===============================================================
  /// ESTADÍSTICAS
  /// ===============================================================

  /// Total de entrenamientos
  int get totalWorkouts => _history.length;

  /// Tiempo total acumulado
  int get totalTimeSeconds =>
      _history.fold(0, (sum, e) => sum + e.totalSeconds);

  /// ===============================================================
  /// FORMATO DE TIEMPO
  /// ===============================================================
  String _formatTime(int seconds) {

    final m = seconds ~/ 60;
    final s = seconds % 60;

    return  '${m.toString().padLeft(2, '0')}:'
            '${s.toString().padLeft(2, '0')}';
  }

  /// ===============================================================
  /// ICONO SEGÚN TIPO
  ///
  /// Mejora lectura visual del historial.
  /// ===============================================================
  IconData _typeIcon(WorkoutType type) {

    switch (type) {

      case WorkoutType.amrap:
        return Icons.loop;

      case WorkoutType.emom:
        return Icons.timer;

      case WorkoutType.tabata:
        return Icons.fitness_center;

      case WorkoutType.forTime:
        return Icons.flag;

      case WorkoutType.mix:
        return Icons.shuffle;
    }
  }

  /// ===============================================================
  /// COLOR SEGÚN TIPO
  /// ===============================================================
  Color _typeColor(WorkoutResult result) {

    switch (result.type) {

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

  /// ===============================================================
  /// NOMBRE DEL TIPO
  /// ===============================================================
  String _formatWorkoutType(WorkoutResult result) {
    return result.type.name.toUpperCase();
  }

  /// ===============================================================
  /// SUBTITULO DEL WORKOUT
  ///
  /// Permite entender el workout sin abrir detalle.
  /// ===============================================================
  String _workoutSubtitle(WorkoutResult result) {

    final metadata = result.metadata;

    if (metadata == null) return '';

    switch (result.type) {

      /// TABATA
      case WorkoutType.tabata:

        final rounds = metadata['rounds'] ?? 0;
        final work = metadata['workSeconds'] ?? 0;
        final rest = metadata['restSeconds'] ?? 0;

        return '$rounds rondas · ${work}s / ${rest}s';

      /// FOR TIME
      case WorkoutType.forTime:

        final cap = metadata['timeCapSeconds'];

        if (cap is int) {
          return 'Time Cap ${_formatTime(cap)}';
        }

        return 'For Time';

      /// EMOM
      case WorkoutType.emom:

        final rounds = metadata['rounds'] ?? 0;
        final interval = metadata['intervalSeconds'] ?? 0;

        return '$rounds rondas · ${_formatTime(interval)}';

      /// AMRAP
      case WorkoutType.amrap:

        final blocks = metadata['blocks'];

        if (blocks is List && blocks.isNotEmpty) {

          final first = blocks.first;

          final work = first['workSeconds'] ?? 0;
          final rest = first['restSeconds'] ?? 0;

          return 'Trabajo ${_formatTime(work)} · Descanso ${_formatTime(rest)}';
        }

        return 'AMRAP';

      case WorkoutType.mix:
        return 'Workout mixto';
    }
  }

  /// ===============================================================
  /// UI
  /// ===============================================================
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Historial'),
      ),

      body: _history.isEmpty
          ? const Center(
              child: Text(
                'Aún no hay entrenamientos',
                style: TextStyle(color: Colors.white54),
              ),
            )

          : Column(
              children: [

                /// ===================================================
                /// RESUMEN SUPERIOR
                /// ===================================================
                Container(

                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround,

                    children: [

                      _StatItem(
                        label: 'Entrenamientos',
                        value: totalWorkouts.toString(),
                      ),

                      _StatItem(
                        label: 'Tiempo total',
                        value: _formatTime(totalTimeSeconds),
                      ),
                    ],
                  ),
                ),

                /// ===================================================
                /// LISTA DE WORKOUTS
                /// ===================================================
                Expanded(

                  child: ListView.builder(

                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),

                    itemCount: _history.length,

                    itemBuilder: (context, index) {

                      final item = _history[index];
                      final color = _typeColor(item);

                      return GestureDetector(

                        onTap: () async {

                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  WorkoutDetailScreen(
                                result: item,
                              ),
                            ),
                          );

                          /// Recarga historial por si
                          /// se editó una nota
                          _load();
                        },

                        child: Container(

                          margin:
                              const EdgeInsets.only(bottom: 12),

                          padding:
                              const EdgeInsets.all(16),

                          decoration: BoxDecoration(

                            color: color.withValues(alpha: 0.15),

                            borderRadius:
                                BorderRadius.circular(16),

                            border: Border.all(
                              color: color.withValues(alpha: 0.35),
                            ),
                          ),

                          child: Row(

                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,

                            children: [

                              /// IZQUIERDA
                              Row(

                                children: [

                                  Icon(
                                    _typeIcon(item.type),
                                    color: color,
                                    size: 22,
                                  ),

                                  const SizedBox(width: 12),

                                  Column(

                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [

                                      Text(
                                        _formatWorkoutType(item),
                                        style: TextStyle(
                                          color: color,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      const SizedBox(height: 2),

                                      Text(
                                        _workoutSubtitle(item),
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        item.date
                                            .toLocal()
                                            .toString()
                                            .split('.')
                                            .first,
                                        style: const TextStyle(
                                          color: Colors.white38,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              /// DERECHA
                              Column(

                                crossAxisAlignment:
                                    CrossAxisAlignment.end,

                                children: [

                                  Text(
                                    _formatTime(item.totalSeconds),
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  if (item.note != null &&
                                      item.note!.isNotEmpty)

                                    const Icon(
                                      Icons.sticky_note_2,
                                      size: 16,
                                      color: Colors.white38,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

/// ===============================================================
/// WIDGET ESTADÍSTICA
/// ===============================================================
class _StatItem extends StatelessWidget {

  final String label;
  final String value;

  const _StatItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        Text(
          value,
          style: const TextStyle(
            color: Colors.orange,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}