import 'dart:async';

class TimerCore {
  final Duration tickRate;

  TimerCore({
    this.tickRate = const Duration(milliseconds: 250),
  });

  final StreamController<int> _controller =
      StreamController<int>.broadcast();

  Stream<int> get stream => _controller.stream;

  Timer? _timer;

  DateTime? _startTime;
  int _pausedAccumulated = 0;
  bool _isRunning = false;
  bool _isPaused = false;

  int get elapsedSeconds {
    if (_startTime == null) return 0;

    final now = DateTime.now();

    final runningElapsed =
        now.difference(_startTime!).inSeconds;

    return _pausedAccumulated + runningElapsed;
  }

  Future<void> start() async {
    if (_isRunning) return;

    _isRunning = true;
    _isPaused = false;
    _pausedAccumulated = 0;
    _startTime = DateTime.now();

    _startTicker();
  }

  void _startTicker() {
    _timer?.cancel();

    _timer = Timer.periodic(tickRate, (_) {
      if (!_isRunning || _isPaused) return;

      _controller.add(elapsedSeconds);
    });
  }

  void pause() {
    if (!_isRunning || _isPaused) return;

    _pausedAccumulated += DateTime.now()
        .difference(_startTime!)
        .inSeconds;

    _isPaused = true;
  }

  void resume() {
    if (!_isRunning || !_isPaused) return;

    _startTime = DateTime.now();
    _isPaused = false;
  }

  void stop() {
    _timer?.cancel();
    _isRunning = false;
    _isPaused = false;
    _startTime = null;
    _pausedAccumulated = 0;
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}