import 'package:flutter/material.dart';

import '../../data/repositories/workout_history_repository_impl.dart';
import '../../domain/entities/workout_result.dart';

class WorkoutStatsScreen extends StatefulWidget {
  const WorkoutStatsScreen({super.key});

  @override
  State<WorkoutStatsScreen> createState() =>
      _WorkoutStatsScreenState();
}

class _WorkoutStatsScreenState
    extends State<WorkoutStatsScreen> {

  final _repository = WorkoutHistoryRepositoryImpl();

  int totalWorkouts = 0;
  int totalSeconds = 0;
  int longestWorkout = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final List<WorkoutResult> history =
        await _repository.loadAll();

    totalWorkouts = history.length;
    totalSeconds = 0;
    longestWorkout = 0;

    for (final WorkoutResult entry in history) {
      totalSeconds += entry.totalSeconds;

      if (entry.totalSeconds > longestWorkout) {
        longestWorkout = entry.totalSeconds;
      }
    }

    if (!mounted) return;

    setState(() {});
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Estadísticas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _statCard('Entrenamientos totales',
                totalWorkouts.toString()),
            _statCard('Tiempo acumulado',
                _formatTime(totalSeconds)),
            _statCard('Entrenamiento más largo',
                _formatTime(longestWorkout)),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String value) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(
          title,
          style:
              const TextStyle(color: Colors.white70),
        ),
        trailing: Text(
          value,
          style: const TextStyle(
            color: Colors.orange,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
