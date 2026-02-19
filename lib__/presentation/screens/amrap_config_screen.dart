import 'package:flutter/material.dart';

import '../../core/amrap_block.dart';
import '../widgets/duration_picker_dialog.dart';
import '../widgets/amrap_block_card.dart';
import 'timer_screen.dart';

class AmrapConfigScreen extends StatefulWidget {
  const AmrapConfigScreen({super.key});

  @override
  State<AmrapConfigScreen> createState() =>
      _AmrapConfigScreenState();
}

class _AmrapConfigScreenState extends State<AmrapConfigScreen> {

  final List<AmrapBlock> _blocks = [
    AmrapBlock(workSeconds: 60, restSeconds: null),
  ];

  void _startWorkout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TimerScreen(blocks: _blocks),
      ),
    );
  }

  // 🔹 resto de tu código permanece igual
}
