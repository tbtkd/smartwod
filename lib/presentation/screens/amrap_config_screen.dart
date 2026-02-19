import 'package:flutter/material.dart';
import '../../core/amrap_block.dart';
import '../../widgets/duration_picker_dialog.dart';
import '../widgets/amrap_block_card.dart';
import 'timer_screen.dart';

class AmrapConfigScreen extends StatefulWidget {
  const AmrapConfigScreen({super.key});

  @override
  State<AmrapConfigScreen> createState() =>
      _AmrapConfigScreenState();
}

class _AmrapConfigScreenState
    extends State<AmrapConfigScreen> {

  final List<AmrapBlock> _blocks = [
    AmrapBlock(workSeconds: 60, restSeconds: null),
  ];

  final ScrollController _scrollController =
      ScrollController();

  final GlobalKey<AnimatedListState> _listKey =
      GlobalKey<AnimatedListState>();

  // =============================
  // UTILIDADES
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
        type: DurationType.work,
        onTimeSelected: (newSeconds) {
          setState(() {
            _blocks[index] = AmrapBlock(
              workSeconds: newSeconds,
              restSeconds: current.restSeconds,
            );
          });
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
        initialSeconds: current.restSeconds ?? 5,
        type: DurationType.rest,
        onTimeSelected: (newSeconds) {
          setState(() {
            _blocks[index] = AmrapBlock(
              workSeconds: current.workSeconds,
              restSeconds:
                  newSeconds > 0 ? newSeconds : null,
            );
          });
        },
      ),
    );
  }

  // =============================
  // ELIMINAR BLOQUE
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
        actionsAlignment:
            MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style:
                  TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              final removedBlock =
                  _blocks[index];

              _listKey.currentState?.removeItem(
                index,
                (context, animation) {
                  return SizeTransition(
                    sizeFactor: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: AmrapBlockCard(
                        index: index,
                        workTime: _formatTime(
                            removedBlock.workSeconds),
                        restTime:
                            removedBlock.restSeconds !=
                                        null &&
                                    removedBlock.restSeconds! >
                                        0
                                ? _formatTime(
                                    removedBlock.restSeconds!)
                                : null,
                        onEditWork: () {},
                        onEditRest: () {},
                        onDelete: () {},
                      ),
                    ),
                  );
                },
                duration:
                    const Duration(milliseconds: 300),
              );

              setState(() {
                _blocks.removeAt(index);
              });
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(
                color: Colors.redAccent,
              ),
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
    final newBlock = AmrapBlock(
      workSeconds: 60,
      restSeconds: 15,
    );

    setState(() {
      _blocks.add(newBlock);
    });

    _listKey.currentState?.insertItem(
      _blocks.length - 1,
      duration:
          const Duration(milliseconds: 300),
    );

    Future.delayed(
      const Duration(milliseconds: 250),
      () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration:
                const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      },
    );
  }

  void _startWorkout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            TimerScreen(blocks: _blocks),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
          style:
              TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [

            Expanded(
              child: AnimatedList(
                key: _listKey,
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                initialItemCount: _blocks.length,
                itemBuilder: (context, index, animation) {
                  final block = _blocks[index];

                  return SizeTransition(
                    sizeFactor: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: AmrapBlockCard(
                        index: index,
                        workTime:
                            _formatTime(block.workSeconds),
                        restTime: block.restSeconds != null &&
                                block.restSeconds! > 0
                            ? _formatTime(block.restSeconds!)
                            : null,
                        onEditWork: () => _editWork(index),
                        onEditRest: () => _editRest(index),
                        onDelete: () =>
                            _confirmDelete(index),
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton(
                onPressed: _addBlock,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                      color: Colors.white24),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  '+ Añadir bloque',
                  style:
                      TextStyle(color: Colors.white70),
                ),
              ),
            ),

            const SizedBox(height: 14),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _startWorkout,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(
                            Colors.orange),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(
                            Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Empezar',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Tiempo total ${_formatTime(_totalSeconds)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
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
