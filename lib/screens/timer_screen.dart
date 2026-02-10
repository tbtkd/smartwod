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

  @override
  Widget build(BuildContext context) {
    final int currentRound = _uiState?.currentRound ?? 1;
    final int totalRounds = _uiState?.totalRounds ?? widget.blocks.length;
    final bool isRest = _uiState?.phase == TimerPhase.rest;
    final int remaining = _uiState?.remainingSeconds ?? 0;

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
          const Spacer(),

          // ===== BLOQUE CENTRAL (TODO JUNTO) =====
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // AMRAP / DESCANSO
                if (_uiState != null)
                  Text(
                    _uiState!.phase == TimerPhase.work
                        ? 'AMRAP'
                        : _uiState!.phase == TimerPhase.rest
                            ? 'DESCANSO'
                            : '',
                    style: TextStyle(
                      color: _uiState!.phase == TimerPhase.rest
                          ? Colors.blue
                          : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                const SizedBox(height: 6),

                // 1 de N (JUSTO ENCIMA DEL TIMER)
                Text(
                  '$currentRound de $totalRounds',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // Descanso en segundos
                if (isRest)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${remaining}s',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // ===== TEMPORIZADOR =====
                CentralTimer(
                  uiState: _uiState,
                  isCountingDown: _isCountingDown,
                  countdownSeconds: _countdownSeconds,
                  onTap: _onCentralTap,
                ),
              ],
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
