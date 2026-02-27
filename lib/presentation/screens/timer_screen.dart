import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../core/timer_ui_state.dart';
import '../../core/audio/sound_engine.dart';
import '../../core/timer_phase.dart';

import '../../domain/runners/workout_runner.dart';
import '../../domain/entities/workout_result.dart';
import '../../domain/enums/workout_type.dart';

import '../../data/repositories/workout_history_repository_impl.dart';

import '../../widgets/central_timer.dart';
import 'workout_finished_screen.dart';

/// ===============================================================
/// TIMER SCREEN (MULTIMODO)
///
/// Pantalla neutral.
/// Ejecuta cualquier WorkoutRunner.
/// No conoce lógica específica de AMRAP o EMOM.
/// ===============================================================
class TimerScreen extends StatefulWidget {
  final WorkoutRunner Function(SoundEngine) runnerBuilder;
  final WorkoutType workoutType;
  final int totalConfiguredSeconds;
  final dynamic metadata;

  const TimerScreen({
    super.key,
    required this.runnerBuilder,
    required this.workoutType,
    required this.totalConfiguredSeconds,
    this.metadata,
  });

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {

  late final WorkoutRunner _runner;
  late final SoundEngine _soundEngine;
  late final StreamSubscription<TimerUiState> _subscription;

  final _historyRepository = WorkoutHistoryRepositoryImpl();

  TimerUiState? _uiState;

  bool _isCountingDown = false;
  int _countdownSeconds = 10;
  bool _trainingStarted = false;
  Timer? _countdownTimer;

  // ===============================================================
  // COLOR DINÁMICO SEGÚN MODO
  // ===============================================================
  Color _progressColor() {
    switch (widget.workoutType) {
      case WorkoutType.amrap:
        return Colors.orange;
      case WorkoutType.emom:
        return Colors.purple;
      case WorkoutType.tabata:
        return Colors.blue;
      case WorkoutType.forTime:
        return Colors.green;
      case WorkoutType.mix:
        return Colors.grey;
    }
  }

  Color _modeAccentColor() {
    switch (widget.workoutType) {
      case WorkoutType.amrap:
        return Colors.orange;
      case WorkoutType.emom:
        return Colors.blueAccent;
      default:
        return Colors.orange;
    }
  }


  @override
  void initState() {
    super.initState();

    _soundEngine = SoundEngine();
    _runner = widget.runnerBuilder(_soundEngine);

    /// Escuchamos el stream del runner
    _subscription = _runner.stream.listen(_onUpdate);
  }

  // ===============================================================
  // RUNNER UPDATE
  // ===============================================================
  void _onUpdate(TimerUiState state) async {

    //debugPrint('PHASE ACTUAL: ${state.phase}');

    // ---------------------------------------------------------------
    // FINALIZACIÓN
    // ---------------------------------------------------------------
    if (state.phase == TimerPhase.finished) {

      //debugPrint('ENTRO A FINISHED');

      await _subscription.cancel();

      await _historyRepository.save(
        WorkoutResult(
          type: widget.workoutType,
          date: DateTime.now(),
          totalSeconds: _runner.totalWorkoutSeconds,
          metadata: _buildSafeMetadata(),
        ),
      );

      await _disableWakelock();

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => WorkoutFinishedScreen(
            totalSeconds: _runner.totalWorkoutSeconds,
            totalAmraps: state.totalRounds,
          ),
        ),
      );

      return;
    }

    if (!mounted) return;
  
    setState(() {
      _uiState = state;
    });
  }

  // ===============================================================
  // METADATA SEGURA
  // Convierte List<AmrapBlock> → Map<String, dynamic>
  // ===============================================================
  Map<String, dynamic>? _buildSafeMetadata() {

    // ==============================
    // AMRAP (SIN CAMBIOS)
    // ==============================
    if (widget.workoutType == WorkoutType.amrap) {

      final raw = widget.metadata;

      if (raw == null) return null;

      if (raw is Map<String, dynamic>) {
        return raw;
      }

      if (raw is List) {
        return {
          "blocks": raw.map((b) {
            return {
              "workSeconds": b.workSeconds,
              "restSeconds": b.restSeconds,
            };
          }).toList(),
        };
      }
    }

    // ==============================
    // 🔥 EMOM (NUEVO SOPORTE REAL)
    // ==============================
    if (widget.workoutType == WorkoutType.emom) {

      final rounds = _uiState?.totalRounds ?? 0;

      final intervalSeconds =
          rounds > 0
              ? widget.totalConfiguredSeconds ~/ rounds
              : 0;

      return {
        "intervalSeconds": intervalSeconds,
        "rounds": rounds,
        "blocks": [],
      };
    }

    // ==============================
    // OTROS CASOS (SIN CAMBIOS)
    // ==============================
    if (widget.metadata is Map<String, dynamic>) {
      return widget.metadata;
    }

    return null;
  }

  // ===============================================================
  // WAKELOCK
  // ===============================================================
  Future<void> _enableWakelock() async {
    await WakelockPlus.enable();
  }

  Future<void> _disableWakelock() async {
    await WakelockPlus.disable();
  }

  // ===============================================================
  // COUNTDOWN
  // ===============================================================
  Future<void> _startCountdown() async {

    if (_isCountingDown || _trainingStarted) return;

    await _soundEngine.init();

    if (!mounted) return;

    setState(() {
      _isCountingDown = true;
      _countdownSeconds = 10;
    });

    while (_countdownSeconds > 0 && mounted) {
      await Future.delayed(const Duration(seconds: 1));

      final nextValue = _countdownSeconds - 1;

      if (!mounted) return;

      setState(() {
        _countdownSeconds = nextValue;
      });

      if (nextValue == 3) {
        await _soundEngine.playCountdown();
      }
    }

    if (!mounted) return;

    setState(() {
      _isCountingDown = false;
      _trainingStarted = true;
    });

    await _enableWakelock();
    await _runner.start();
  }

  void _onCentralTap() {
    if (_uiState == null && !_isCountingDown) {
      _startCountdown();
      return;
    }

    if (_uiState != null && !_uiState!.isFinished) {
      _runner.togglePause();
    }
  }

  // ===============================================================
  // EXIT PROTECTION
  // ===============================================================
  Future<bool> _onWillPop() async {

    if (_uiState == null) return true;

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Salir del entrenamiento',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '¿Seguro que deseas abandonar el entrenamiento?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Salir',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (shouldExit == true) {
      await _disableWakelock();
      _runner.dispose();
      return true;
    }

    return false;
  }

  @override
  void dispose() {
    _countdownTimer?.cancel(); 
    _subscription.cancel();
    _disableWakelock();
    _runner.dispose();
    super.dispose();
  }

  // ===============================================================
  // UI
  // ===============================================================
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
                : '${widget.workoutType.name.toUpperCase()} '
                  '${_uiState!.currentRound} de ${_uiState!.totalRounds}'));

    return PopScope(
      canPop: false,

      /// Nuevo callback recomendado por Flutter
      onPopInvokedWithResult: (didPop, result) async {

        if (didPop) return;

        /// Guardamos referencia del Navigator ANTES del await
        final navigator = Navigator.of(context);

        final shouldExit = await _onWillPop();

        if (!mounted) return;

        if (shouldExit) {
          navigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          title: Text(
            widget.workoutType.name.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w600),
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
                  totalSeconds: _uiState?.phaseTotalSeconds ?? 0,
                  onTap: _onCentralTap,
                  accentColor: _modeAccentColor(),
                ),

                const SizedBox(height: 32),

                Text(
                  'Tiempo total · '
                  '${widget.totalConfiguredSeconds ~/ 60}:'
                  '${(widget.totalConfiguredSeconds % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 22),

                if (_uiState != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: LinearProgressIndicator(
                      value: _runner.globalProgress,
                      minHeight: 6,
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _progressColor(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}