import 'package:flutter/material.dart';

import '../../core/amrap_block.dart';

class AmrapBlocksSummary extends StatelessWidget {
  final List<AmrapBlock> blocks;

  const AmrapBlocksSummary({
    super.key,
    required this.blocks,
  });

  String _format(int seconds) {
    if (seconds < 60) {
      return '$seconds s';
    }
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return s == 0 ? '${m}m' : '${m}m ${s}s';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(blocks.length, (index) {
        final block = blocks[index];
        final isLast = index == blocks.length - 1;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              Text(
                'Trabajo ${index + 1} · ${_format(block.workSeconds)}',
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (!isLast && block.restSeconds != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Descanso · ${_format(block.restSeconds!)}',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
