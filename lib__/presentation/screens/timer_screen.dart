import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../core/timer_ui_state.dart';
import '../../core/amrap_block.dart';

import '../../domain/runners/amrap_runner.dart';
import '../../domain/entities/workout_result.dart';
import '../../domain/enums/workout_type.dart';

import '../../core/audio/feedback_audio_service.dart';

import '../../data/repositories/workout_history_repository_impl.dart';

import '../widgets/central_timer.dart';
import 'workout_finished_screen.dart';

class TimerScreen extends StatefulWidget {
  final List<AmrapBlock> blocks;

  const TimerScreen({
    Key? key,
    required this.blocks,
  }) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late final AmrapRunner _runner;
  final _historyRepository = WorkoutHistoryRepositoryImpl();

  TimerUiState? _uiState;
  bool _isCountingDown = false;
  int _countdownSeconds = 10;
  bool _trainingStarted = false;

  @override
  void initState() {
    super.initState();

    _runner = AmrapRunner(
      blocks: widget.blocks,
      onUpdate: _onUpdate,
      audioService: FeedbackAudioService(),
    );
  }

  void _onUpdate(TimerUiState state) async {
    if (state.phase == TimerPhase.finished) {

      await _historyRepository.save(
        WorkoutResult(
          type: WorkoutType.amrap,
          date: DateTime.now(),
          totalSeconds: _runner.totalWorkoutSeconds,
        ),
      );

      await WakelockPlus.disable();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => WorkoutFinishedScreen(
            totalSeconds: _runner.totalWorkoutSeconds,
            totalAmraps: state.totalRounds,
          ),
        ),
      );

      return;
    }

    setState(() {
      _uiState = state;
    });
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _runner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('AMRAP'),
      ),
      body: const Center(
        child: Text(
          'Implementación UI continúa aquí',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
