import 'package:flutter/material.dart';
import '../core/amrap_runner.dart';
import '../core/amrap_block.dart';

class TimerScreen extends StatefulWidget {
  final List<AmrapBlock> blocks;

  const TimerScreen({super.key, required this.blocks});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late AmrapRunner _runner;

  int _seconds = 0;
  bool _isRunning = false;
  bool _isFinished = false;
  AmrapBlock? _currentBlock;

  @override
  void initState() {
    super.initState();

    _runner = AmrapRunner(
      blocks: widget.blocks,
      onBlockStart: (block) {
        setState(() {
          _currentBlock = block;
          _isRunning = true;
        });
      },
      onTick: (seconds) {
        setState(() => _seconds = seconds);
      },
      onFinish: () {
        setState(() {
          _isRunning = false;
          _isFinished = true;
        });
      },
    );
  }

  @override
  void dispose() {
    _runner.stop();
    super.dispose();
  }

  String _formatTime(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final label = _currentBlock == null
        ? 'LISTO'
        : _currentBlock!.isRest
            ? 'DESCANSO'
            : 'AMRAP';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, title: const Text('AMRAP')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 20),
          Text(
            _formatTime(_seconds),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 64,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: (!_isRunning && !_isFinished)
                    ? _runner.start
                    : null,
                child: const Text('START'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _isRunning ? _runner.pause : null,
                child: const Text('PAUSE'),
              ),
            ],
          ),
          if (_isFinished)
            const Padding(
              padding: EdgeInsets.only(top: 24),
              child: Text(
                'ENTRENAMIENTO FINALIZADO',
                style: TextStyle(color: Colors.green),
              ),
            ),
        ],
      ),
    );
  }
}
