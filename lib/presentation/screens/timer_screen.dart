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
import '../../core/workout_type_extension.dart';

/// ===============================================================
/// TIMER SCREEN
///
/// Pantalla central que ejecuta cualquier tipo de entrenamiento.
///
/// RESPONSABILIDADES:
/// - Ejecutar el runner correspondiente
/// - Escuchar actualizaciones del runner
/// - Mostrar UI del timer
/// - Guardar el resultado en historial
/// - Manejar pausa / countdown / salida
///
/// IMPORTANTE:
/// Esta pantalla es **agnóstica del tipo de entrenamiento**.
/// La lógica específica vive en los runners.
///
/// Soporta:
/// - AMRAP
/// - EMOM
/// - TABATA
/// - FOR TIME
/// ===============================================================
class TimerScreen extends StatefulWidget {

  /// Builder que crea el runner correspondiente
  final WorkoutRunner Function(SoundEngine) runnerBuilder;

  /// Tipo de entrenamiento
  final WorkoutType workoutType;

  /// Duración total configurada (en segundos)
  final int totalConfiguredSeconds;

  /// Metadata opcional enviada desde la pantalla de configuración
  /// Ejemplos:
  /// Tabata → rounds/workSeconds/restSeconds
  /// ForTime → timeCapSeconds
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

  /// Runner activo
  late final WorkoutRunner _runner;

  /// Motor de sonido
  late final SoundEngine _soundEngine;

  /// Suscripción al stream del runner
  late final StreamSubscription<TimerUiState> _subscription;

  /// Repositorio de historial
  final _historyRepository = WorkoutHistoryRepositoryImpl();

  /// Estado actual del timer
  TimerUiState? _uiState;

  /// Estado del countdown previo al entrenamiento
  bool _isCountingDown = false;
  int _countdownSeconds = 10;

  /// Indica si el entrenamiento ya inició
  bool _trainingStarted = false;

  Timer? _countdownTimer;

  // ===============================================================
  // FINALIZACIÓN MANUAL (solo For Time)
  // ===============================================================
  Future<void> _finishForTimeManually() async {

    final shouldFinish = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Finalizar entrenamiento',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '¿Seguro que deseas finalizar el entrenamiento?',
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
              'Finalizar',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (shouldFinish != true) return;

    /// Calculamos tiempo real usado
    final elapsedSeconds =
        widget.totalConfiguredSeconds -
        (_uiState?.remainingSeconds ?? 0);

    await _subscription.cancel();
    _runner.dispose(); // 🔴 importante

    await _historyRepository.save(
      WorkoutResult(
        type: widget.workoutType,
        date: DateTime.now(),
        totalSeconds: elapsedSeconds,
        metadata: _buildSafeMetadata(),
      ),
    );

    await _disableWakelock();

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => WorkoutFinishedScreen(
          totalSeconds: elapsedSeconds,
          totalAmraps: 1,
        ),
      ),
    );
  }

  // ===============================================================
  // INIT
  // ===============================================================
  @override
  void initState() {
    super.initState();

    _soundEngine = SoundEngine();

    /// El runner se construye dinámicamente
    _runner = widget.runnerBuilder(_soundEngine);

    /// Escuchamos actualizaciones del runner
    _subscription = _runner.stream.listen(_onUpdate);
  }

  // ===============================================================
  // ACTUALIZACIONES DEL RUNNER
  // ===============================================================
  void _onUpdate(TimerUiState state) async {

    /// Runner indica que terminó el entrenamiento
    if (state.phase == TimerPhase.finished) {

      await _subscription.cancel();
      _runner.dispose(); // 🔴 importante

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
  //
  // Convierte metadata enviada desde configuración en un formato
  // seguro para persistencia en historial.
  // ===============================================================
  Map<String, dynamic>? _buildSafeMetadata() {

    /// -----------------------------
    /// AMRAP
    /// -----------------------------
    if (widget.workoutType == WorkoutType.amrap) {

      final raw = widget.metadata;

      if (raw == null) return null;

      if (raw is Map<String, dynamic>) return raw;

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

    /// -----------------------------
    /// EMOM
    /// -----------------------------
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

    /// -----------------------------
    /// TABATA / FOR TIME
    /// -----------------------------
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
  // COUNTDOWN PREVIO AL ENTRENAMIENTO
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

      /// Sonido de cuenta regresiva
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

  // ===============================================================
  // TAP EN TIMER CENTRAL
  //
  // - Antes de iniciar → inicia countdown
  // - Durante entrenamiento → pausa / resume
  // ===============================================================
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
  // PROTECCIÓN AL SALIR
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

  // ===============================================================
  // DISPOSE
  // ===============================================================
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

    final accentColor = widget.workoutType.color;

    final bool isRest =
        _uiState != null && _uiState!.phase == TimerPhase.rest;

    final String topLabel = _isCountingDown
        ? 'Prepárate'
        : (_uiState == null
            ? 'Prepárate'
            : (isRest
            ? 'Descanso'
            : widget.workoutType == WorkoutType.forTime
                ? widget.workoutType.displayName.toUpperCase()
                : '${widget.workoutType.displayName.toUpperCase()} '
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
            widget.workoutType.displayName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// Etiqueta superior (fase actual)
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

                /// Timer central
                CentralTimer(
                  uiState: _uiState,
                  isCountingDown: _isCountingDown,
                  countdownSeconds: _countdownSeconds,
                  totalSeconds: _uiState?.phaseTotalSeconds ?? 0,
                  onTap: _onCentralTap,
                  accentColor: accentColor,
                ),

                const SizedBox(height: 32),

                /// Tiempo total configurado
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

                /// Barra de progreso
                if (_uiState != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: LinearProgressIndicator(
                      value: _runner.globalProgress,
                      minHeight: 6,
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        accentColor,
                      ),
                    ),
                  ),

                /// Botón finalizar manual (solo For Time)
                if (widget.workoutType == WorkoutType.forTime &&
                    _uiState != null &&
                    !_uiState!.isFinished)
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: SizedBox(
                      width: 200,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: _finishForTimeManually,
                        child: const Text(
                          'Finalizar',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
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