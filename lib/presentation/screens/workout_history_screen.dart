import 'package:flutter/material.dart';

import '../../data/repositories/workout_history_repository_impl.dart';
import '../../domain/entities/workout_result.dart';
import '../../domain/enums/workout_type.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  State<WorkoutHistoryScreen> createState() =>
      _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState
    extends State<WorkoutHistoryScreen> {

  final _repository = WorkoutHistoryRepositoryImpl();
  List<WorkoutResult> _history = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _repository.loadAll();
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

  String _typeToString(WorkoutType type) {
    switch (type) {
      case WorkoutType.amrap:
        return 'AMRAP';
      case WorkoutType.emom:
        return 'EMOM';
      case WorkoutType.tabata:
        return 'TABATA';
      case WorkoutType.forTime:
        return 'FOR TIME';
      case WorkoutType.mix:
        return 'MIX';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Historial'),
      ),
      body: _history.isEmpty
          ? const Center(
              child: Text(
                'No hay entrenamientos aún',
                style: TextStyle(color: Colors.white54),
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
                      _typeToString(entry.type),
                      style:
                          const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Duración: ${_formatTime(entry.totalSeconds)}',
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
