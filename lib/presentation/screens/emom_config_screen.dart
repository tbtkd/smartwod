import 'package:flutter/material.dart';

import '../../domain/runners/emom_runner.dart';
import '../../domain/enums/workout_type.dart';
//import '../../core/audio/sound_engine.dart';
import 'timer_screen.dart';

/// ===============================================================
/// EMOM CONFIG SCREEN (versión mínima de prueba)
///
/// Permite probar EMOM sin UI compleja.
/// Más adelante se puede hacer configurable.
/// ===============================================================
class EmomConfigScreen extends StatefulWidget {
  const EmomConfigScreen({super.key});

  @override
  State<EmomConfigScreen> createState() => _EmomConfigScreenState();
}

class _EmomConfigScreenState extends State<EmomConfigScreen> {
  int _rounds = 5;
  int _secondsPerRound = 60;

  int get _totalSeconds => _rounds * _secondsPerRound;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Configurar EMOM',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// Rondas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rondas',
                    style: TextStyle(color: Colors.white),
                  ),
                  DropdownButton<int>(
                    dropdownColor: Colors.grey[900],
                    value: _rounds,
                    items: List.generate(
                      20,
                      (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _rounds = value ?? 5;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// Duración por ronda
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Segundos por ronda',
                    style: TextStyle(color: Colors.white),
                  ),
                  DropdownButton<int>(
                    dropdownColor: Colors.grey[900],
                    value: _secondsPerRound,
                    items: const [
                      DropdownMenuItem(
                        value: 30,
                        child: Text('30', style: TextStyle(color: Colors.white)),
                      ),
                      DropdownMenuItem(
                        value: 45,
                        child: Text('45', style: TextStyle(color: Colors.white)),
                      ),
                      DropdownMenuItem(
                        value: 60,
                        child: Text('60', style: TextStyle(color: Colors.white)),
                      ),
                      DropdownMenuItem(
                        value: 90,
                        child: Text('90', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _secondsPerRound = value ?? 60;
                      });
                    },
                  ),
                ],
              ),

              const Spacer(),

              /// Botón iniciar
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TimerScreen(
                          runnerBuilder: (soundEngine) => EmomRunner(
                            totalRounds: _rounds,
                            secondsPerRound: _secondsPerRound,
                            soundEngine: soundEngine,
                          ),
                          workoutType: WorkoutType.emom,
                          totalConfiguredSeconds: _totalSeconds,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Empezar',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Tiempo total ${(_totalSeconds ~/ 60).toString().padLeft(2, '0')}:${(_totalSeconds % 60).toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}