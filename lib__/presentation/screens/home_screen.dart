import 'package:flutter/material.dart';
import '../widgets/wod_button.dart';
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

            WodButton(
              label: 'AMRAP',
              color: Colors.orange,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AmrapConfigScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            WodButton(
              label: 'HISTORIAL',
              color: Colors.white24,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WorkoutHistoryScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
