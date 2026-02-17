import 'package:flutter/material.dart';

class AmrapBlockCard extends StatelessWidget {
  final int index;
  final String workTime;
  final String? restTime;

  final VoidCallback onEditWork;
  final VoidCallback? onEditRest;
  final VoidCallback onDelete;

  const AmrapBlockCard({
    super.key,
    required this.index,
    required this.workTime,
    this.restTime,
    required this.onEditWork,
    this.onEditRest,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          // HEADER
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AMRAP ${index + 1}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // CONTENIDO
          Row(
            children: [

              // TRABAJO
              Expanded(
                child: _timeBox(
                  label: 'Trabajo',
                  time: workTime,
                  color: Colors.orange,
                  onTap: onEditWork,
                ),
              ),

              if (restTime != null) ...[
                const SizedBox(width: 10),

                // DESCANSO
                Expanded(
                  child: _timeBox(
                    label: 'Descanso',
                    time: restTime!,
                    color: Colors.blueAccent,
                    onTap: onEditRest,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeBox({
    required String label,
    required String time,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius:
              BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
