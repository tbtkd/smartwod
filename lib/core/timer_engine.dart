import 'dart:async';

/// Motor genérico de tiempo
/// No conoce fases ni rounds
/// Solo cuenta segundos y notifica eventos
class TimerEngine {
  Timer? _timer;

  int _currentSeconds = 0;
  int _totalSeconds = 0;
  bool _countUp = false;

  bool _isRunning = false;

  void Function(int seconds)? onTick;
  void Function()? onFinish;

  TimerEngine();

  void start({
    required int totalSeconds,
    bool countUp = false,
    void Function(int seconds)? onTick,
    void Function()? onFinish,
  }) {
    if (_isRunning) return;

    _totalSeconds = totalSeconds;
    _countUp = countUp;

    this.onTick = onTick;
    this.onFinish = onFinish;

    _currentSeconds = _countUp ? 0 : _totalSeconds;

    _isRunning = true;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        _currentSeconds += _countUp ? 1 : -1;

        this.onTick?.call(_currentSeconds);

        final finished = (!_countUp && _currentSeconds <= 0) ||
            (_countUp && _currentSeconds >= _totalSeconds);

        if (finished) {
          stop();
          this.onFinish?.call();
        }
      },
    );
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
  }

  void reset() {
    stop();
    _currentSeconds = _countUp ? 0 : _totalSeconds;
    onTick?.call(_currentSeconds);
  }

  bool get isRunning => _isRunning;

  int get currentSeconds => _currentSeconds;

  int get totalSeconds => _totalSeconds;
}