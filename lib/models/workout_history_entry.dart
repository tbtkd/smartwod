import '../core/amrap_block.dart';

class WorkoutHistoryEntry {
  final DateTime date;
  final int totalSeconds;
  final int totalBlocks;
  final List<AmrapBlock> blocks;

  WorkoutHistoryEntry({
    required this.date,
    required this.totalSeconds,
    required this.totalBlocks,
    required this.blocks,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'totalSeconds': totalSeconds,
      'totalBlocks': totalBlocks,
      'blocks': blocks.map((b) => {
            'work': b.workSeconds,
            'rest': b.restSeconds,
          }).toList(),
    };
  }

  factory WorkoutHistoryEntry.fromJson(Map<String, dynamic> json) {
    return WorkoutHistoryEntry(
      date: DateTime.parse(json['date']),
      totalSeconds: json['totalSeconds'],
      totalBlocks: json['totalBlocks'],
      blocks: (json['blocks'] as List)
          .map((b) => AmrapBlock(
                workSeconds: b['work'],
                restSeconds: b['rest'],
              ))
          .toList(),
    );
  }
}
