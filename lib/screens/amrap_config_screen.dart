import 'package:flutter/material.dart';

import '../core/amrap_block.dart';
import '../widgets/duration_picker_dialog.dart';
import 'timer_screen.dart';

class AmrapConfigScreen extends StatefulWidget {
  const AmrapConfigScreen({super.key});

  @override
  State<AmrapConfigScreen> createState() => _AmrapConfigScreenState();
}

class _AmrapConfigScreenState extends State<AmrapConfigScreen> {
  final List<AmrapBlock> _blocks = [
    const AmrapBlock(workSeconds: 60),
  ];

  String _fmt(int s) {
    final m = s ~/ 60;
    final r = s % 60;
    return '${m.toString().padLeft(2, '0')}:'
        '${r.toString().padLeft(2, '0')}';
  }

  void _editWork(int i) {
    showDialog(
      context: context,
      builder: (_) => DurationPickerDialog(
        initialSeconds: _blocks[i].workSeconds,
        onTimeSelected: (v) {
          setState(() {
            _blocks[i] = AmrapBlock(
              workSeconds: v,
              restSeconds: _blocks[i].restSeconds,
            );
          });
        },
      ),
    );
  }

  void _editRest(int i) {
    showDialog(
      context: context,
      builder: (_) => DurationPickerDialog(
        initialSeconds: _blocks[i].restSeconds ?? 15,
        onTimeSelected: (v) {
          setState(() {
            _blocks[i] = AmrapBlock(
              workSeconds: _blocks[i].workSeconds,
              restSeconds: v,
            );
          });
        },
      ),
    );
  }

  void _addAmrap() {
    setState(() {
      _blocks.add(const AmrapBlock(
        restSeconds: 15,
        workSeconds: 60,
      ));
    });
  }

  void _start() {
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
      appBar: AppBar(title: const Text('Configurar AMRAP')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _blocks.length,
              itemBuilder: (_, i) {
                final b = _blocks[i];
                return Card(
                  color: Colors.grey.shade900,
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AMRAP ${i + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (b.restSeconds != null) ...[
                          const SizedBox(height: 12),
                          const Text('Descanso',
                              style: TextStyle(color: Colors.grey)),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _fmt(b.restSeconds!),
                                style: const TextStyle(
                                    color: Colors.blue, fontSize: 20),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.white),
                                onPressed: () => _editRest(i),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),
                        const Text('Trabajo',
                            style: TextStyle(color: Colors.grey)),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _fmt(b.workSeconds),
                              style: const TextStyle(
                                  color: Colors.orange, fontSize: 24),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.white),
                              onPressed: () => _editWork(i),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _addAmrap,
                  child: const Text('Añadir nuevo AMRAP'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _start,
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
