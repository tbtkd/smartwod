import 'package:flutter/material.dart';

import '../core/amrap_block.dart';
import '../core/amrap_runner.dart';
import '../core/timer_ui_state.dart';

class TimerScreen extends StatefulWidget {
  final List<AmrapBlock> blocks;

  const TimerScreen({super.key, required this.blocks});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  TimerUiState? _uiState;
  late AmrapRunner _runner;

  @override
  void initState() {
    super.initState();
    _runner = AmrapRunner(
      blocks: widget.blocks,
      onUpdate: (state) {
        setState(() => _uiState = state);
      },
    );
  }

  void _start() {
    if (_uiState == null) {
      _runner.start();
    }
  }

  String _fmt(int s) {
    final m = s ~/ 60;
    final r = s % 60;
    return '${m.toString().padLeft(2, '0')}:'
        '${r.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isIdle = _uiState == null;

    final Color ringColor = isIdle
        ? Colors.orange
        : _uiState!.phase == TimerPhase.rest
            ? Colors.blue
            : Colors.orange;

    final String centerText =
        isIdle ? '▶' : _fmt(_uiState!.remainingSeconds);

    final String helperText = isIdle
        ? 'toca para empezar'
        : _uiState!.phase == TimerPhase.rest
            ? 'descansa'
            : 'toca para pausar';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('AMRAP')),
      body: Center(
        child: GestureDetector(
          onTap: _start,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_uiState != null)
                Text(
                  '${_uiState!.currentRound} de ${_uiState!.totalRounds}',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 22),
                ),
              const SizedBox(height: 16),
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ringColor, width: 8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        centerText,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        helperText,
                        style:
                            const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _runner.dispose();
    super.dispose();
  }
}
