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

  void _editBlockTime(int index) {
    showDialog(
      context: context,
      builder: (_) => DurationPickerDialog(
        initialSeconds: _blocks[index].durationSeconds,
        onTimeSelected: (newSeconds) {
          setState(() {
            _blocks[index] = AmrapBlock(
              durationSeconds: newSeconds,
              isRest: false,
            );
          });
        },
      ),
    );
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

                return AmrapBlockCard(
                  index: index,
                  durationSeconds: block.durationSeconds,
                  onEditTime: () => _editBlockTime(index),
                  onAddRest: () {
                    // siguiente paso
                  },
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
