import 'package:flutter/services.dart';

class FeedbackService {
  /// Beep corto (countdown)
  static void beep() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();
  }

  /// Beep fuerte (inicio / cambio de bloque / final)
  static void strongBeep() {
    SystemSound.play(SystemSoundType.alert);
    HapticFeedback.mediumImpact();
  }
}
