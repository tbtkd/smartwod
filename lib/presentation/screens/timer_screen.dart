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
/// Esta pantalla es completamente neutral.
/// No conoce AMRAP, EMOM, TABATA, etc.
///
/// Recibe:
/// - runnerBuilder → construye el runner correspondiente
/// - workoutType → tipo de entrenamiento
/// - totalConfiguredSeconds → duración total configurada
/// - metadata → información adicional (bloques, rondas, etc.)
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
  /// Runner genérico (AMRAP, EMOM, etc.)
  late final WorkoutRunner _runner;

  /// Motor de sonido independiente
  late final SoundEngine _soundEngine;

  /// Suscripción al stream del runner
  late final StreamSubscription<TimerUiState> _subscription;

  /// Repositorio para guardar historial
  final _historyRepository = WorkoutHistoryRepositoryImpl();

  /// Estado actual emitido por el runner
  TimerUiState? _uiState;

  /// Control del countdown inicial
  bool _isCountingDown = false;
  int _countdownSeconds = 10;
  bool _trainingStarted = false;

  @override
  void initState() {
    super.initState();

    /// Inicializamos motor de sonido
    _soundEngine = SoundEngine();

    /// Construimos el runner según el modo recibido
    _runner = widget.runnerBuilder(_soundEngine);

    /// Escuchamos actualizaciones del runner
    _subscription = _runner.stream.listen(_onUpdate);
  }

  // =============================
  // RUNNER UPDATE
  // =============================

  /// Recibe actualizaciones del runner
  /// Maneja:
  /// - Actualización de UI
  /// - Finalización del entrenamiento
  void _onUpdate(TimerUiState state) async {
    /// Si el entrenamiento finalizó
    if (state.phase == TimerPhase.finished) {
      await _historyRepository.save(
        WorkoutResult(
          type: widget.workoutType,
          date: DateTime.now(),
          totalSeconds: _runner.totalWorkoutSeconds,
          blocks: widget.metadata, // solo aplica a ciertos modos
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

    if (!mounted) return;

    setState(() {
      _uiState = state;
    });
  }

  // =============================
  // WAKELOCK
  // =============================

  /// Activa wakelock durante entrenamiento
  Future<void> _enableWakelock() async {
    await WakelockPlus.enable();
  }

  /// Desactiva wakelock al salir
  Future<void> _disableWakelock() async {
    await WakelockPlus.disable();
  }

  // =============================
  // COUNTDOWN INICIAL
  // =============================

  /// Countdown previo al inicio del entrenamiento
  Future<void> _startCountdown() async {
    if (_isCountingDown || _trainingStarted) return;

    await _soundEngine.init();

    setState(() {
      _isCountingDown = true;
      _countdownSeconds = 10;
    });

    while (_countdownSeconds > 0 && mounted) {
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      final nextValue = _countdownSeconds - 1;

      setState(() {
        _countdownSeconds = nextValue;
      });

      /// Sonido en el segundo 3
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

  /// Tap central:
  /// - Inicia countdown si aún no comenzó
  /// - Pausa / reanuda si ya inició
  void _onCentralTap() {
    if (_uiState == null && !_isCountingDown) {
      _startCountdown();
      return;
    }

    if (_uiState != null && !_uiState!.isFinished) {
      _runner.togglePause();
    }
  }

  // =============================
  // EXIT PROTECTION
  // =============================

  /// Maneja confirmación antes de salir
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
    _subscription.cancel();
    _disableWakelock();
    _runner.dispose();
    super.dispose();
  }

  // =============================
  // UI
  // =============================

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
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

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
                          const AlwaysStoppedAnimation<Color>(
                            Color(0xFF00E5FF),
                          ),
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  'Tiempo total · '
                  '${widget.totalConfiguredSeconds ~/ 60}:'
                  '${(widget.totalConfiguredSeconds % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 14,
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