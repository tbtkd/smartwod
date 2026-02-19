import 'package:flutter/material.dart';

import '../../widgets/wod_button.dart';
import 'amrap_config_screen.dart';
import 'workout_history_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

            // AMRAP
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

            // FOR TIME
            WodButton(
              label: 'FOR TIME',
              color: Colors.blueGrey,
              onPressed: () {
                _showComingSoon(context);
              },
            ),

            const SizedBox(height: 15),

            // EMOM
            WodButton(
              label: 'EMOM',
              color: Colors.purple,
              onPressed: () {
                _showComingSoon(context);
              },
            ),

            const SizedBox(height: 15),

            // TABATA
            WodButton(
              label: 'TABATA',
              color: Colors.green,
              onPressed: () {
                _showComingSoon(context);
              },
            ),

            const SizedBox(height: 15),

            // MIX
            WodButton(
              label: 'MIX',
              color: Colors.grey,
              onPressed: () {
                _showComingSoon(context);
              },
            ),

            const SizedBox(height: 25),

            // 🔥 HISTORIAL GLOBAL
            WodButton(
              label: 'HISTORIAL',
              color: Colors.white24,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const WorkoutHistoryScreen(),
                  ),
                );
              },
            ),
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
