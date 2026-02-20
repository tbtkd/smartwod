import 'package:audioplayers/audioplayers.dart';

class SoundEngine {
  final AudioPlayer _player = AudioPlayer();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    try {
      await _player.setReleaseMode(ReleaseMode.stop);
      await _player.setPlayerMode(PlayerMode.lowLatency);

      // preload countdown
      await _player.setSource(
        AssetSource('audio/countdown_1.wav'),
      );
      await _player.stop();

      _initialized = true;
    } catch (e) {
      print('Audio init error: $e');
    }
  }

  Future<void> playCountdown() async {
    await _player.stop();
    await _player.play(
      AssetSource('audio/countdown_1.wav'),
    );
  }

  Future<void> playPhaseChange() async {
    await _player.stop();
    await _player.play(
      AssetSource('audio/56828__esformouse__tone02.wav'),
    );
  }

  Future<void> playWorkoutFinished() async {
    await _player.stop();
    await _player.play(
      AssetSource('audio/well_done_optimized.wav'),
    );
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
