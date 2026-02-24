import 'package:audioplayers/audioplayers.dart';

class SoundEngine {
  final AudioPlayer _countdownPlayer = AudioPlayer();
  final AudioPlayer _finishPlayer = AudioPlayer();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    try {
      await _countdownPlayer.setReleaseMode(ReleaseMode.stop);
      await _countdownPlayer.setPlayerMode(PlayerMode.lowLatency);

      await _finishPlayer.setReleaseMode(ReleaseMode.stop);

      // Preload countdown
      await _countdownPlayer.setSource(
        AssetSource('audio/countdown_1.wav'),
      );
      await _countdownPlayer.stop();

      // Preload finish
      await _finishPlayer.setSource(
        AssetSource('audio/well_done_optimized.wav'),
      );
      await _finishPlayer.stop();

      _initialized = true;
    } catch (e) {
      print('Audio init error: $e');
    }
  }

  Future<void> playCountdown() async {
    try {
      await _countdownPlayer.stop();
      await _countdownPlayer.play(
        AssetSource('audio/countdown_1.wav'),
      );
    } catch (e) {
      print('Countdown audio error: $e');
    }
  }

  Future<void> playWorkoutFinished() async {
    try {
      await _finishPlayer.stop();
      await _finishPlayer.play(
        AssetSource('audio/well_done_optimized.wav'),
      );
    } catch (e) {
      print('Finish audio error: $e');
    }
  }

  // 🔥 CRÍTICO: cortar countdown inmediatamente
  Future<void> stopCountdown() async {
    try {
      await _countdownPlayer.stop();
    } catch (e) {
      print('Stop countdown error: $e');
    }
  }

  Future<void> dispose() async {
    await _countdownPlayer.dispose();
    await _finishPlayer.dispose();
  }
}