import 'package:flutter/material.dart';

class AmrapBlockCard extends StatelessWidget {
  final int index;
  final int durationSeconds;
  final VoidCallback onEditTime;
  final VoidCallback onAddRest;

  const AmrapBlockCard({
    super.key,
    required this.index,
    required this.durationSeconds,
    required this.onEditTime,
    required this.onAddRest,
  });

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AMRAP ${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: onEditTime,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _formatTime(durationSeconds),
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onAddRest,
            icon: const Icon(Icons.add, color: Colors.orange),
            label: const Text(
              'Agregar descanso',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}
