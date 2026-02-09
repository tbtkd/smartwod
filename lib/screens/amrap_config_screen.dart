import 'package:flutter/material.dart';

import '../core/amrap_block.dart';
import 'widgets/amrap_block_card.dart';
import '../widgets/duration_picker_dialog.dart';
import 'timer_screen.dart';

class AmrapConfigScreen extends StatefulWidget {
  const AmrapConfigScreen({super.key});

  @override
  State<AmrapConfigScreen> createState() => _AmrapConfigScreenState();
}

class _AmrapConfigScreenState extends State<AmrapConfigScreen> {
  List<AmrapBlock> _blocks = const [
    AmrapBlock(durationSeconds: 60, isRest: false),
  ];

  void _editTime(int index) {
    showDialog(
      context: context,
      builder: (_) => DurationPickerDialog(
        initialSeconds: _blocks[index].durationSeconds,
        onTimeSelected: (s) {
          setState(() {
            _blocks[index] = AmrapBlock(
              durationSeconds: s,
              isRest: _blocks[index].isRest,
            );
          });
        },
      ),
    );
  }

  void _addRestAfter(int index) {
    setState(() {
      _blocks.insert(
        index + 1,
        const AmrapBlock(durationSeconds: 15, isRest: true),
      );
    });
  }

  void _addWorkBlock() {
    setState(() {
      _blocks = [
        ..._blocks,
        const AmrapBlock(durationSeconds: 60, isRest: false),
      ];
    });
  }

  void _startAmrap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TimerScreen(blocks: _blocks),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int workIndex = 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar AMRAP'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _blocks.length,
              itemBuilder: (context, index) {
                final block = _blocks[index];

                if (block.isRest) {
                  return ListTile(
                    leading:
                        const Icon(Icons.timer, color: Colors.grey),
                    title: const Text(
                      'Descanso',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '${block.durationSeconds} segundos',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon:
                          const Icon(Icons.edit, color: Colors.white),
                      onPressed: () => _editTime(index),
                    ),
                  );
                }

                final current = workIndex++;

                return AmrapBlockCard(
                  index: current,
                  durationSeconds: block.durationSeconds,
                  onEditTime: () => _editTime(index),
                  onAddRest: () => _addRestAfter(index),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _addWorkBlock,
                  child: const Text('Añadir otro AMRAP'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _startAmrap,
                  child: const Text('Empezar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
