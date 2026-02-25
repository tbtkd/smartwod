import 'package:flutter/material.dart';

import '../../domain/entities/workout_result.dart';
import '../../domain/enums/workout_type.dart';
import '../../data/repositories/workout_history_repository_impl.dart';

/// ===============================================================
/// WORKOUT DETAIL SCREEN
///
/// Pantalla de detalle del entrenamiento guardado.
/// Soporta múltiples modos (AMRAP, EMOM, etc.).
///
/// - Lee información desde WorkoutResult
/// - Interpreta metadata según el tipo
/// - Permite agregar / editar notas
/// ===============================================================
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
        TextEditingController(text: widget.result.note ?? '');
  }

  // ===============================================================
  // FORMATO TIEMPO
  // ===============================================================
  String _format(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')} : '
        '${s.toString().padLeft(2, '0')}';
  }

  // ===============================================================
  // SAVE
  // ===============================================================
  Future<void> _save() async {
    final updated =
        widget.result.copyWith(
      note: _noteController.text.trim(),
    );

    await _repository.update(updated);

    if (!mounted) return;
    Navigator.pop(context);
  }

  // ===============================================================
  // METADATA HELPERS (AMRAP)
  // ===============================================================

  /// Extrae bloques solo si el modo es AMRAP.
  /// Ahora metadata es un Map<String, dynamic>
  /// y blocks es una lista de Map.
  List<Map<String, dynamic>> _amrapBlocks() {
    if (widget.result.type != WorkoutType.amrap) {
      return [];
    }

    final raw = widget.result.metadata?['blocks'];

    if (raw is List) {
      return raw
          .whereType<Map<String, dynamic>>()
          .toList();
    }

    return [];
  }

  int _totalWorkTime() {
    final blocks = _amrapBlocks();
    return blocks.fold<int>(
      0,
      (sum, b) =>
          sum + ((b['workSeconds'] ?? 0) as int),
    );
  }

  int _totalRestTime() {
    final blocks = _amrapBlocks();
    return blocks.fold<int>(
      0,
      (sum, b) =>
          sum + ((b['restSeconds'] ?? 0) as int),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blocks = _amrapBlocks();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Detalle ${widget.result.type.name.toUpperCase()}',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [

            /// ===================================================
            /// HEADER PRINCIPAL
            /// ===================================================
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withValues(alpha: 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [

                  Text(
                    _format(widget.result.totalSeconds),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight:
                          FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'Tiempo total',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [

                      /// Solo mostrar trabajo/descanso en AMRAP
                      if (widget.result.type ==
                          WorkoutType.amrap) ...[
                        _MiniStat(
                          label: 'Trabajo',
                          value:
                              _format(_totalWorkTime()),
                        ),
                        _MiniStat(
                          label: 'Descanso',
                          value:
                              _format(_totalRestTime()),
                        ),
                      ],

                      _MiniStat(
                        label: 'Fecha',
                        value: widget
                            .result.date
                            .toLocal()
                            .toString()
                            .split(' ')
                            .first,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// ===================================================
            /// DESGLOSE SOLO PARA AMRAP
            /// ===================================================
            if (blocks.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius:
                      BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    const Text(
                      'Desglose',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 14),

                    ListView.builder(
                      physics:
                          const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: blocks.length,
                      itemBuilder:
                          (context, index) {

                        final block =
                            blocks[index];

                        return Padding(
                          padding:
                              const EdgeInsets.only(
                                  bottom: 12),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [

                              _BulletRow(
                                color: Colors.orange,
                                text:
                                    'AMRAP ${index + 1}: '
                                    '${block['workSeconds']} segundos',
                              ),

                              if (block['restSeconds'] !=
                                      null &&
                                  block['restSeconds'] >
                                      0)
                                _BulletRow(
                                  color: Colors.grey,
                                  text:
                                      'Descanso ${index + 1}: '
                                      '${block['restSeconds']} segundos',
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 18),

            /// ===================================================
            /// NOTAS
            /// ===================================================
            _SectionCard(
              child: TextField(
                controller:
                    _noteController,
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                cursorColor: Colors.orange,
                decoration:
                    const InputDecoration(
                  border: InputBorder.none,
                  hintText:
                      'Escribe tus notas aquí...',
                  hintStyle:
                      TextStyle(
                          color: Colors.black45),
                  isDense: true,
                ),
              ),
            ),

            const SizedBox(height: 24),

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
                  'Guardar cambios',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===============================================================
/// MINI STAT
/// ===============================================================
class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight:
                FontWeight.bold,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

/// ===============================================================
/// SECTION CARD
/// ===============================================================
class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

/// ===============================================================
/// BULLET ROW
/// ===============================================================
class _BulletRow extends StatelessWidget {
  final Color color;
  final String text;

  const _BulletRow({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}