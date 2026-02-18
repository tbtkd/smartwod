import 'package:flutter/material.dart';
import '../core/amrap_runner.dart';
import '../core/timer_ui_state.dart';
import '../core/amrap_block.dart';
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

  TimerUiState? _uiState;

  bool _isCountingDown = false;
  int _countdownSeconds = 10;

  @override
  void initState() {
    super.initState();

    _runner = AmrapRunner(
      blocks: widget.blocks,
      onUpdate: _onUpdate,
    );
  }

  void _onUpdate(TimerUiState state) {
    if (state.phase == TimerPhase.finished) {
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

  void _startCountdown() {
    if (_isCountingDown) return;

    setState(() {
      _isCountingDown = true;
      _countdownSeconds = 10;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;

      setState(() {
        _countdownSeconds--;
      });

      if (_countdownSeconds <= 0) {
        _isCountingDown = false;
        _runner.start();
        return false;
      }
      return true;
    });
  }

  void _onCentralTap() {
    if (_uiState == null && !_isCountingDown) {
      _startCountdown();
      return;
    }

    if (_uiState != null) {
      if (_uiState!.isFinished) return;
      _runner.togglePause();
    }
  }

  String _formatTotalTime() {
    int total = 0;

    for (int i = 0; i < widget.blocks.length; i++) {
      total += widget.blocks[i].workSeconds;

      if (i > 0) {
        total += widget.blocks[i].restSeconds ?? 0;
      }
    }

    final m = total ~/ 60;
    final s = total % 60;

    return '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _runner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isRest =
        _uiState != null && _uiState!.phase == TimerPhase.rest;

    final String topLabel = _isCountingDown
        ? 'Prepárate'
        : (_uiState == null
            ? 'Prepárate'
            : (isRest
                ? 'Descanso'
                : 'Amrap ${_uiState!.currentRound} de ${_uiState!.totalRounds}'));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'AMRAP',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  topLabel,
                  key: ValueKey(topLabel),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isRest ? Colors.blue : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              CentralTimer(
                uiState: _uiState,
                isCountingDown: _isCountingDown,
                countdownSeconds: _countdownSeconds,
                totalSeconds: _runner.currentBlockTotalSeconds,
                onTap: _onCentralTap,
              ),

              const SizedBox(height: 24),

              if (_uiState != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: LinearProgressIndicator(
                    value: _runner.globalProgress,
                    minHeight: 6,
                    backgroundColor: Colors.white12,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                ),

              const SizedBox(height: 12),

              Text(
                'Tiempo total · ${_formatTotalTime()}',
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
