import 'package:audioplayers/audioplayers.dart';

class FeedbackService {

  static final AudioPlayer _countdownPlayer = AudioPlayer()
    ..setPlayerMode(PlayerMode.lowLatency);

  static final AudioPlayer _phasePlayer = AudioPlayer()
    ..setPlayerMode(PlayerMode.lowLatency);

  static final AudioPlayer _finishPlayer = AudioPlayer()
    ..setPlayerMode(PlayerMode.lowLatency);

  static final AudioContext _audioContext = AudioContext(
    android: AudioContextAndroid(
      isSpeakerphoneOn: true,
      stayAwake: false,
      contentType: AndroidContentType.sonification,
      usageType: AndroidUsageType.assistanceSonification,
      audioFocus: AndroidAudioFocus.none,
    ),
  );

  static bool _initialized = false;

  static Future<void> _ensureInit() async {
    if (_initialized) return;

    await _countdownPlayer.setAudioContext(_audioContext);
    await _phasePlayer.setAudioContext(_audioContext);
    await _finishPlayer.setAudioContext(_audioContext);

    _initialized = true;
  }

  static Future<void> playCountdownBeep() async {
    await _ensureInit();
    await _countdownPlayer.stop();
    await _countdownPlayer.play(
      AssetSource('sounds/beep_countdown.mp3'),
    );
  }

  static Future<void> playPhaseChange() async {
    await _ensureInit();
    await _phasePlayer.stop();
    await _phasePlayer.play(
      AssetSource('sounds/phase_change.mp3'),
    );
  }

  static Future<void> playWorkoutFinished() async {
    await _ensureInit();
    await _finishPlayer.stop();
    await _finishPlayer.play(
      AssetSource('sounds/workout_finished.mp3'),
    );
  }
}
