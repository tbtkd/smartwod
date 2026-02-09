import 'package:flutter/material.dart';
import '../core/amrap_block.dart';
import 'timer_screen.dart';

class AmrapConfigScreen extends StatefulWidget {
  const AmrapConfigScreen({super.key});

  @override
  State<AmrapConfigScreen> createState() => _AmrapConfigScreenState();
}

class _AmrapConfigScreenState extends State<AmrapConfigScreen> {
  final List<AmrapBlock> _blocks = [
    AmrapBlock(durationSeconds: 600, isRest: false),
  ];

  void _addAmrap() {
    setState(() {
      _blocks.add(AmrapBlock(durationSeconds: 120, isRest: true));
      _blocks.add(AmrapBlock(durationSeconds: 600, isRest: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    final amrapCount = _blocks.where((b) => !b.isRest).length;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('AMRAP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$amrapCount x AMRAP',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: _blocks.length,
                itemBuilder: (_, i) {
                  final block = _blocks[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      block.isRest ? 'Descanso' : 'AMRAP',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),

            ElevatedButton(
              onPressed: _addAmrap,
              child: const Text('Añade otro AMRAP'),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TimerScreen(blocks: _blocks),
                  ),
                );
              },
              child: const Text('INICIAR AMRAP'),
            ),
          ],
        ),
      ),
    );
  }
}
