import 'package:flutter/material.dart';

class AmrapBlockCard extends StatelessWidget {
  final int index;
  final String workTime;
  final String? restTime;
  final VoidCallback onEditWork;
  final VoidCallback onEditRest;
  final VoidCallback onDelete;

  const AmrapBlockCard({
    super.key,
    required this.index,
    required this.workTime,
    required this.onEditWork,
    required this.onEditRest,
    required this.onDelete,
    this.restTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // HEADER CENTRADO + X
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'AMRAP ${index + 1}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(
                  Icons.close,
                  color: Colors.redAccent,
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [

              // TRABAJO
              Expanded(
                child: GestureDetector(
                  onTap: onEditWork,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Trabajo',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          workTime,
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // DESCANSO
              if (restTime != null)
                Expanded(
                  child: GestureDetector(
                    onTap: onEditRest,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Descanso',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            restTime!,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
