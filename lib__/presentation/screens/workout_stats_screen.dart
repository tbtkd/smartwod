import 'package:flutter/material.dart';
import '../../utils/workout_history_service.dart';
import '../../models/workout_history_entry.dart';

class WorkoutStatsScreen extends StatefulWidget {
  const WorkoutStatsScreen({super.key});

  @override
  State<WorkoutStatsScreen> createState() =>
      _WorkoutStatsScreenState();
}

class _WorkoutStatsScreenState
    extends State<WorkoutStatsScreen> {

  int totalWorkouts = 0;
  int totalSeconds = 0;
  int longestWorkout = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final List<WorkoutHistoryEntry> history =
        await WorkoutHistoryService.loadHistory();

    totalWorkouts = history.length;
    totalSeconds = 0;
    longestWorkout = 0;

    for (final WorkoutHistoryEntry entry in history) {
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
            _statCard(
              title: 'Entrenamientos totales',
              value: totalWorkouts.toString(),
            ),
            _statCard(
              title: 'Tiempo acumulado',
              value: _formatTime(totalSeconds),
            ),
            _statCard(
              title: 'Entrenamiento más largo',
              value: _formatTime(longestWorkout),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
  }) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white70),
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
