import 'package:flutter/material.dart';

import '../core/amrap_runner.dart';
import '../core/timer_ui_state.dart';
import '../core/amrap_block.dart';
import '../widgets/central_timer.dart';

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
    }
  }

  @override
  void dispose() {
    _runner.dispose();
    super.dispose();
  }

  String _format(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  int _calculateTotalWorkoutTime() {
    int total = 0;

    for (final block in widget.blocks) {
      total += block.workSeconds;
      total += block.restSeconds ?? 0;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    final int currentRound = _uiState?.currentRound ?? 1;
    final int totalRounds =
        _uiState?.totalRounds ?? widget.blocks.length;

    final bool isRest = _uiState?.phase == TimerPhase.rest;

    final int totalRests =
        totalRounds > 1 ? totalRounds - 1 : 0;

    final int currentRest =
        isRest ? (currentRound - 1) : 0;

    final int totalWorkoutSeconds =
        _calculateTotalWorkoutTime();

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
      body: Column(
        children: [
          const Spacer(flex: 1),

          // ===== BLOQUE SUPERIOR =====
          Column(
            children: [
              if (_uiState != null)
                Text(
                  isRest ? 'DESCANSO' : 'AMRAP',
                  style: TextStyle(
                    color: isRest ? Colors.blue : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

              const SizedBox(height: 8),

              Text(
                isRest
                    ? '$currentRest de $totalRests'
                    : '$currentRound de $totalRounds',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              // 🔥 NUEVO: TIEMPO TOTAL DEL WORKOUT
              Text(
                'Tiempo total · ${_format(totalWorkoutSeconds)}',
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // ===== TEMPORIZADOR =====
          Expanded(
            child: Center(
              child: CentralTimer(
                uiState: _uiState,
                isCountingDown: _isCountingDown,
                countdownSeconds: _countdownSeconds,
                onTap: _onCentralTap,
              ),
            ),
          ),

          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
