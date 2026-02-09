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
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AMRAP ${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                onPressed: onEditTime,
                icon: const Icon(Icons.edit, color: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Time
          Text(
            _formatTime(durationSeconds),
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // Add rest
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
