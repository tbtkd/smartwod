import 'package:flutter/material.dart';
import '../../utils/workout_history_service.dart';
import '../../models/workout_history_entry.dart';
import 'workout_stats_screen.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  State<WorkoutHistoryScreen> createState() =>
      _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState
    extends State<WorkoutHistoryScreen> {

  List<WorkoutHistoryEntry> _history = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data =
        await WorkoutHistoryService.loadHistory();
    setState(() {
      _history = data;
    });
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Historial'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const WorkoutStatsScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: _history.isEmpty
          ? const Center(
              child: Text(
                'No hay entrenamientos aún',
                style:
                    TextStyle(color: Colors.white54),
              ),
            )
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final entry = _history[index];

                return Card(
                  color: Colors.grey[900],
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8),
                  child: ListTile(
                    title: Text(
                      'AMRAP · ${entry.totalBlocks} bloques',
                      style: const TextStyle(
                          color: Colors.white),
                    ),
                    subtitle: Text(
                      '${_formatDate(entry.date)}\nDuración: ${_formatTime(entry.totalSeconds)}',
                      style: const TextStyle(
                          color: Colors.white70),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
