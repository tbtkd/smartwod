import 'timer_ui_state.dart';

abstract class CoreRunner {
  Stream<TimerUiState> get state;

  void start();
  void pause();
  void resume();
  void stop();
  void dispose();
}