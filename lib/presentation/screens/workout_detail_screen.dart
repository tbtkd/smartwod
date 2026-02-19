import 'package:flutter/material.dart';

import '../../domain/entities/workout_result.dart';
import '../../data/repositories/workout_history_repository_impl.dart';
import '../../core/amrap_block.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final WorkoutResult result;

  const WorkoutDetailScreen({
    super.key,
    required this.result,
  });

  @override
  State<WorkoutDetailScreen> createState() =>
      _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState
    extends State<WorkoutDetailScreen> {

  final _repository = WorkoutHistoryRepositoryImpl();
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController =
        TextEditingController(text: widget.result.note);
  }

  String _format(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  Future<void> _save() async {
    final updated =
        widget.result.copyWith(
      note: _noteController.text.trim(),
    );

    await _repository.update(updated);

    if (!mounted) return;
    Navigator.pop(context);
  }

  int _totalWorkTime() {
    if (widget.result.blocks == null) return 0;
    return widget.result.blocks!
        .fold(0, (sum, b) => sum + b.workSeconds);
  }

  int _totalRestTime() {
    if (widget.result.blocks == null) return 0;
    return widget.result.blocks!
        .fold(0, (sum, b) => sum + (b.restSeconds ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    final blocks = widget.result.blocks;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Detalle AMRAP'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            const Text(
              'Duración total',
              style:
                  TextStyle(color: Colors.white54),
            ),
            const SizedBox(height: 6),
            Text(
              _format(widget.result.totalSeconds),
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Trabajo: ${_format(_totalWorkTime())}',
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),

            Text(
              'Descanso: ${_format(_totalRestTime())}',
              style: const TextStyle(
                color: Colors.white38,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Fecha',
              style:
                  TextStyle(color: Colors.white54),
            ),
            const SizedBox(height: 6),
            Text(
              widget.result.date
                  .toLocal()
                  .toString()
                  .split('.')
                  .first,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),

            if (blocks != null) ...[
              const SizedBox(height: 30),
              const Text(
                'Desglose',
                style:
                    TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 12),
              ...blocks
                  .asMap()
                  .entries
                  .expand((entry) {
                final index = entry.key;
                final block = entry.value;

                final List<Widget> rows = [];

                rows.add(
                  _DetailRow(
                    label:
                        'AMRAP ${index + 1}',
                    seconds:
                        block.workSeconds,
                  ),
                );

                if (block.restSeconds != null &&
                    block.restSeconds! > 0) {
                  rows.add(
                    _DetailRow(
                      label: 'Descanso',
                      seconds:
                          block.restSeconds!,
                    ),
                  );
                }

                return rows;
              }).toList(),
            ],

            const SizedBox(height: 30),

            const Text(
              'Nota',
              style:
                  TextStyle(color: Colors.white54),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _noteController,
              maxLines: 4,
              style:
                  const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.orange,
                ),
                child: const Text(
                    'Guardar nota'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final int seconds;

  const _DetailRow({
    required this.label,
    required this.seconds,
  });

  String _format(int s) {
    final m = s ~/ 60;
    final r = s % 60;
    return '${m.toString().padLeft(2, '0')}:'
        '${r.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 8),
      padding:
          const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
                color: Colors.white),
          ),
          Text(
            _format(seconds),
            style: const TextStyle(
              color: Colors.orange,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
