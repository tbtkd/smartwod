import 'dart:async';

/// Motor genérico de tiempo
/// Solo cuenta segundos, no sabe nada de UI
class TimerEngine {
  final int totalSeconds;
  final bool countUp;

  Timer? _timer;
  int _currentSeconds = 0;

  final void Function(int seconds)? onTick;
  final void Function()? onFinish;

  TimerEngine({
    required this.totalSeconds,
    this.countUp = false,
    this.onTick,
    this.onFinish,
  }) {
    _currentSeconds = countUp ? 0 : totalSeconds;
  }

  void start() {
    if (_timer != null) return;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        _currentSeconds += countUp ? 1 : -1;
        onTick?.call(_currentSeconds);

        if ((!countUp && _currentSeconds <= 0) ||
            (countUp && _currentSeconds >= totalSeconds)) {
          stop();
          onFinish?.call();
        }
      },
    );
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void reset() {
    stop();
    _currentSeconds = countUp ? 0 : totalSeconds;
    onTick?.call(_currentSeconds);
  }

  int get currentSeconds => _currentSeconds;
}
