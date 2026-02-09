import 'amrap_block.dart';
import 'timer_engine.dart';

/// Ejecuta una secuencia de bloques AMRAP en orden
class AmrapRunner {
  final List<AmrapBlock> blocks;

  int _currentIndex = 0;
  TimerEngine? _engine;

  final void Function(AmrapBlock block)? onBlockStart;
  final void Function(int seconds)? onTick;
  final void Function()? onFinish;

  AmrapRunner({
    required this.blocks,
    this.onBlockStart,
    this.onTick,
    this.onFinish,
  });

  void start() {
    if (blocks.isEmpty) return;
    _currentIndex = 0;
    _startBlock();
  }

  void _startBlock() {
    final block = blocks[_currentIndex];
    onBlockStart?.call(block);

    _engine = TimerEngine(
      totalSeconds: block.durationSeconds,
      onTick: onTick,
      onFinish: _nextBlock,
    );

    _engine!.start();
  }

  void _nextBlock() {
    _currentIndex++;
    if (_currentIndex < blocks.length) {
      _startBlock();
    } else {
      onFinish?.call();
    }
  }

  void pause() => _engine?.pause();
  void resume() => _engine?.start();
  void stop() => _engine?.stop();
}
