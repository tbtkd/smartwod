import 'package:flutter/material.dart';
import '../../domain/definitions/tabata_definition.dart';
import '../../domain/runners/segment_runner.dart';
import '../../domain/enums/workout_type.dart';
import 'timer_screen.dart';

class TabataConfigScreen extends StatefulWidget {
  const TabataConfigScreen({super.key});

  @override
  State<TabataConfigScreen> createState() =>
      _TabataConfigScreenState();
}

class _TabataConfigScreenState
    extends State<TabataConfigScreen> {

  int _rounds = 8;
  int _workSeconds = 20;
  int _restSeconds = 10;

  int get _totalSeconds =>
      _rounds * (_workSeconds + _restSeconds);

  String _format(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  void _startWorkout() {
    final definition = TabataDefinition(
      workSeconds: _workSeconds,
      restSeconds: _restSeconds,
      rounds: _rounds,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TimerScreen(
          runnerBuilder: (soundEngine) =>
              SegmentRunner(
            definition: definition,
            soundEngine: soundEngine,
          ),
          workoutType: WorkoutType.tabata,
          totalConfiguredSeconds:
              definition.totalSeconds,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Configurar Tabata'),
      ),
      body: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [

          const Text(
            'Formato clásico 20/10',
            style: TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 20),

          Text(
            'Tiempo total ${_format(_totalSeconds)}',
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 40),

          ElevatedButton(
            onPressed: _startWorkout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text('Empezar Tabata'),
          ),
        ],
      ),
    );
  }
}