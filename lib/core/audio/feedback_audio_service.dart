import '../../domain/services/workout_audio_service.dart';
import '../../utils/feedback_service.dart';

class FeedbackAudioService implements WorkoutAudioService {

  @override
  Future<void> playPhaseChange() async {
    await FeedbackService.playPhaseChange();
  }

  @override
  Future<void> playWorkoutFinished() async {
    await FeedbackService.playWorkoutFinished();
  }
}
