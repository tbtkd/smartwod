import 'package:flutter/material.dart';

import '../../data/repositories/workout_history_repository_impl.dart';
import '../../domain/entities/workout_result.dart';
import '../../domain/enums/workout_type.dart';
import 'workout_detail_screen.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  State<WorkoutHistoryScreen> createState() =>
      _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState
    extends State<WorkoutHistoryScreen> {

  final _repository = WorkoutHistoryRepositoryImpl();
  List<WorkoutResult> _history = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _repository.loadAll();
    if (!mounted) return;
    setState(() {
      _history = data;
    });
  }

  int get totalWorkouts => _history.length;

  int get totalTimeSeconds =>
      _history.fold(
          0, (sum, e) => sum + e.totalSeconds);

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Historial'),
      ),
      body: _history.isEmpty
          ? const Center(
              child: Text(
                'Aún no hay entrenamientos',
                style:
                    TextStyle(color: Colors.white54),
              ),
            )
          : Column(
              children: [

                // RESUMEN
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(
                        label: 'Entrenamientos',
                        value:
                            totalWorkouts.toString(),
                      ),
                      _StatItem(
                        label: 'Tiempo total',
                        value: _formatTime(
                            totalTimeSeconds),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(
                            horizontal: 16),
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      final item =
                          _history[index];

                      return GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  WorkoutDetailScreen(
                                result: item,
                              ),
                            ),
                          );
                          _load();
                        },
                        child: Container(
                          margin:
                              const EdgeInsets.only(
                                  bottom: 12),
                          padding:
                              const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius:
                                BorderRadius.circular(
                                    14),
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(
                                    'AMRAP',
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white,
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                  ),
                                  const SizedBox(
                                      height: 4),
                                  Text(
                                    item.date
                                        .toLocal()
                                        .toString()
                                        .split(
                                            '.')
                                        .first,
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors
                                              .white38,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .end,
                                children: [
                                  Text(
                                    _formatTime(
                                        item.totalSeconds),
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.orange,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                  if (item.note !=
                                          null &&
                                      item.note!
                                          .isNotEmpty)
                                    const Icon(
                                      Icons
                                          .sticky_note_2,
                                      size: 16,
                                      color:
                                          Colors.white38,
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
              ],
            ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({
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
            color: Colors.orange,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
