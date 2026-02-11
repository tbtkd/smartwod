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

  late final int _totalTimeSeconds;

  @override
  void initState() {
    super.initState();

    _totalTimeSeconds = _calculateTotalTime();

    _runner = AmrapRunner(
      blocks: widget.blocks,
      onUpdate: _onUpdate,
    );
  }

  int _calculateTotalTime() {
    int total = 0;
    for (final block in widget.blocks) {
      total += block.workSeconds;
      total += block.restSeconds ?? 0;
    }
    return total;
  }

  String _format(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
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
    final bool isIdle = _uiState == null && !_isCountingDown;

    String topMessage;

    if (isIdle || _isCountingDown) {
      topMessage = "Prepárate";
    } else if (_uiState!.phase == TimerPhase.work) {
      topMessage =
          "AMRAP ${_uiState!.currentRound} de ${_uiState!.totalRounds}";
    } else if (_uiState!.phase == TimerPhase.rest) {
      // Ajuste correcto del descanso (no usar currentRound directo)
      final int restIndex =
          (_uiState!.currentRound > 1) ? _uiState!.currentRound - 1 : 1;
      final int totalRests =
          (_uiState!.totalRounds > 1) ? _uiState!.totalRounds - 1 : 1;

      topMessage = "DESCANSO $restIndex de $totalRests";
    } else {
      topMessage = "";
    }

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
        child: Column(
          children: [
            const Spacer(),

            // ===== MENSAJE SUPERIOR =====
            Text(
              topMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _uiState?.phase == TimerPhase.rest
                    ? Colors.blue
                    : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 24),

            // ===== CÍRCULO CENTRADO =====
            Expanded(
              flex: 3,
              child: Center(
                child: CentralTimer(
                  uiState: _uiState,
                  isCountingDown: _isCountingDown,
                  countdownSeconds: _countdownSeconds,
                  onTap: _onCentralTap,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ===== TIEMPO TOTAL =====
            Text(
              "Tiempo total · ${_format(_totalTimeSeconds)}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 14,
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
