import 'package:flutter/material.dart';
import '../core/amrap_block.dart';
import '../widgets/duration_picker_dialog.dart';
import '../screens/widgets/amrap_block_card.dart';
import 'timer_screen.dart';

class AmrapConfigScreen extends StatefulWidget {
  const AmrapConfigScreen({super.key});

  @override
  State<AmrapConfigScreen> createState() => _AmrapConfigScreenState();
}

class _AmrapConfigScreenState extends State<AmrapConfigScreen> {
  final List<AmrapBlock> _blocks = [
    AmrapBlock(workSeconds: 60, restSeconds: null),
  ];

  // =============================
  // UTIL
  // =============================

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;

    return '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  int get _totalSeconds {
    int total = 0;

    for (int i = 0; i < _blocks.length; i++) {
      total += _blocks[i].workSeconds;

      if (i > 0) {
        total += _blocks[i].restSeconds ?? 0;
      }
    }

    return total;
  }

  // =============================
  // EDITAR TRABAJO
  // =============================

  void _editWork(int index) {
    final current = _blocks[index];

    showDialog(
      context: context,
      builder: (_) => DurationPickerDialog(
        initialSeconds: current.workSeconds,
        onTimeSelected: (newSeconds) {
          if (newSeconds > 0) {
            setState(() {
              _blocks[index] = AmrapBlock(
                workSeconds: newSeconds,
                restSeconds: current.restSeconds,
              );
            });
          }
        },
      ),
    );
  }

  // =============================
  // EDITAR DESCANSO
  // =============================

  void _editRest(int index) {
    final current = _blocks[index];

    showDialog(
      context: context,
      builder: (_) => DurationPickerDialog(
        initialSeconds: current.restSeconds ?? 0,
        onTimeSelected: (newSeconds) {
          setState(() {
            _blocks[index] = AmrapBlock(
              workSeconds: current.workSeconds,
              restSeconds: newSeconds > 0 ? newSeconds : null,
            );
          });
        },
      ),
    );
  }

  // =============================
  // CONFIRMAR ELIMINACIÓN
  // =============================

  void _confirmDelete(int index) {
    if (_blocks.length <= 1) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Center(
          child: Text(
            'Eliminar bloque',
            style: TextStyle(color: Colors.white),
          ),
        ),
        content: const Text(
          '¿Seguro que deseas eliminar este bloque?',
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _blocks.removeAt(index);
              });
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  // =============================
  // AÑADIR BLOQUE
  // =============================

  void _addBlock() {
    setState(() {
      _blocks.add(
        AmrapBlock(workSeconds: 60, restSeconds: 15),
      );
    });
  }

  // =============================
  // INICIAR ENTRENAMIENTO
  // =============================

  void _startWorkout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TimerScreen(blocks: _blocks),
      ),
    );
  }

  // =============================
  // BUILD
  // =============================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Configurar AMRAP',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [

            // LISTA DE BLOQUES
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: _blocks.length,
                itemBuilder: (context, index) {
                  final block = _blocks[index];

                  return AmrapBlockCard(
                    index: index,
                    workTime: _formatTime(block.workSeconds),
                    restTime: block.restSeconds != null &&
                            block.restSeconds! > 0
                        ? _formatTime(block.restSeconds!)
                        : null,
                    onEditWork: () => _editWork(index),
                    onEditRest: () => _editRest(index),
                    onDelete: () => _confirmDelete(index),
                  );
                },
              ),
            ),

            // DURACIÓN TOTAL DINÁMICA
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Duración total · ${_formatTime(_totalSeconds)}',
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 14,
                ),
              ),
            ),

            // BOTÓN AÑADIR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton(
                onPressed: _addBlock,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  '+ Añadir bloque',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // BOTÓN EMPEZAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: _startWorkout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  elevation: 6,
                  shadowColor: Colors.orange.withOpacity(0.4),
                  padding:
                      const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Empezar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
