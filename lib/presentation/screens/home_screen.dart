import 'package:flutter/material.dart';

import '../../widgets/wod_button.dart';
import '../../data/repositories/workout_history_repository_impl.dart';
import '../screens/emom_config_screen.dart';


import 'amrap_config_screen.dart';
import 'workout_history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = WorkoutHistoryRepositoryImpl(); // va ligada al debug boton para eliminar registros

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'SMARTWOD',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 30),

            // ==========================
            // MODOS DE ENTRENAMIENTO
            // ==========================

            WodButton(
              label: 'AMRAP',
              color: Colors.orange,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const AmrapConfigScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            WodButton(
              label: 'FOR TIME',
              color: Colors.blueGrey,
              onPressed: () {
                _showComingSoon(context);
              },
            ),

            const SizedBox(height: 15),

            WodButton(
              label: 'EMOM',
              color: Colors.purple,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EmomConfigScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            WodButton(
              label: 'TABATA',
              color: Colors.green,
              onPressed: () {
                _showComingSoon(context);
              },
            ),

            const SizedBox(height: 15),

            WodButton(
              label: 'MIX',
              color: Colors.grey,
              onPressed: () {
                _showComingSoon(context);
              },
            ),

            const SizedBox(height: 35),

            // ==========================
            // ETIQUETA HISTORIAL
            // ==========================

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const WorkoutHistoryScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white24,
                  ),
                ),
                child: const Text(
                  'Ver historial de entrenamientos',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ==========================
            // BOTÓN DEBUG (COMENTADO)
            // ==========================

            /*
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await repository.clear();

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Historial eliminado'),
                  ),
                );
              },
              child: const Text('Limpiar historial (Debug)'),
            ),
             *///cierre comentario debug boton */
          ],
        ),
      ),
    );
  }

  static void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Próximamente'),
        content: const Text(
          'Este modo se implementará después de AMRAP.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
