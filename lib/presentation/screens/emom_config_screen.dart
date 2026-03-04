import 'package:flutter/material.dart';

//import '../../domain/runners/emom_runner.dart';
import '../../domain/enums/workout_type.dart';
import 'timer_screen.dart';
import '../../domain/runners/segment_runner.dart';
import '../../domain/definitions/emom_definition.dart';

/// ===============================================================
/// EMOM CONFIG SCREEN
///
/// Pantalla de configuración para el modo EMOM.
///
/// RESPONSABILIDADES
/// - Permitir seleccionar número de rondas
/// - Permitir seleccionar duración de cada ronda
/// - Mostrar preview dinámico del tiempo total
/// - Iniciar el entrenamiento enviando configuración
///
/// NOTA
/// Se utilizan "wheel pickers" para selección rápida.
/// Cada wheel tiene su propio ScrollController para
/// evitar errores de reconstrucción de Flutter.
/// ===============================================================

class EmomConfigScreen extends StatefulWidget {
  const EmomConfigScreen({super.key});

  @override
  State<EmomConfigScreen> createState() =>
      _EmomConfigScreenState();
}

class _EmomConfigScreenState
    extends State<EmomConfigScreen>
    with TickerProviderStateMixin {

  int _rounds = 1;
  int _secondsPerRound = 60;

  int get _totalSeconds => _rounds * _secondsPerRound;

  /// ===============================================================
  /// OPCIONES DISPONIBLES
  /// ===============================================================

  final List<int> _roundOptions =
      List.generate(30, (i) => i + 1);

  final List<int> _secondOptions = [30, 45, 60, 90];

  /// ===============================================================
  /// CONTROLADORES DE SCROLL
  ///
  /// Se agregan para evitar errores:
  /// - Duplicate keys
  /// - Scroll reconstruido incorrectamente
  /// ===============================================================

  late FixedExtentScrollController _roundController;
  late FixedExtentScrollController _secondsController;

  /// ===============================================================
  /// INIT STATE
  /// ===============================================================

  @override
  void initState() {
    super.initState();

    /// Inicializa wheel en posición correcta
    _roundController = FixedExtentScrollController(
      initialItem: _roundOptions.indexOf(_rounds),
    );

    _secondsController = FixedExtentScrollController(
      initialItem: _secondOptions.indexOf(_secondsPerRound),
    );
  }

  /// ===============================================================
  /// DISPOSE
  /// ===============================================================

  @override
  void dispose() {
    _roundController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  /// ===============================================================
  /// FORMATEO DE TIEMPO
  /// ===============================================================

  String _format(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Configurar EMOM',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      /// ===========================================================
      /// BODY
      ///
      /// Se envuelve en SingleChildScrollView para evitar
      /// overflow en pantallas pequeñas.
      /// ===========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox(height: 30),

              /// ===================================================
              /// SELECTOR RONDAS
              /// ===================================================

              _SelectorCard(
                title: 'Rondas',
                value: _rounds.toString(),
                accentColor: Colors.purple,
                child: _buildWheel(
                  controller: _roundController,
                  options: _roundOptions,
                  selected: _rounds,
                  accentColor: Colors.purple,
                  onChanged: (val) =>
                      setState(() => _rounds = val),
                ),
              ),

              const SizedBox(height: 24),

              /// ===================================================
              /// SELECTOR DURACIÓN POR RONDA
              /// ===================================================

              _SelectorCard(
                title: 'Duración por ronda',
                value: '$_secondsPerRound seg',
                accentColor: Colors.purple,
                child: _buildWheel(
                  controller: _secondsController,
                  options: _secondOptions,
                  selected: _secondsPerRound,
                  accentColor: Colors.purple,
                  onChanged: (val) =>
                      setState(() => _secondsPerRound = val),
                ),
              ),

              const SizedBox(height: 30),

              /// ===================================================
              /// PREVIEW TIEMPO TOTAL
              /// ===================================================

              /// 🔥 Preview dinámico animado
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.purple.withValues(alpha: 0.03),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Tiempo total estimado',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    AnimatedSwitcher(
                      duration:
                          const Duration(milliseconds: 250),
                      child: Text(
                        _format(_totalSeconds),
                        key: ValueKey(_totalSeconds),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// ===================================================
              /// BOTÓN INICIAR
              /// ===================================================

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TimerScreen(
                            runnerBuilder: (soundEngine) =>
                            SegmentRunner(
                              definition: EmomDefinition(
                                totalRounds: _rounds,
                                secondsPerRound: _secondsPerRound,
                              ),
                              soundEngine: soundEngine,
                            ),
                            workoutType:
                                WorkoutType.emom,
                            totalConfiguredSeconds:
                                _totalSeconds,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Empezar EMOM',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// ===============================================================
  /// WHEEL PICKER
  ///
  /// Widget reutilizable para selección de valores.
  /// ===============================================================

  Widget _buildWheel({
    required FixedExtentScrollController controller,
    required List<int> options,
    required int selected,
    required Color accentColor,
    required Function(int) onChanged,
  }) {
    return SizedBox(
      height: 90,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 40,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
          onChanged(options[index]);
        },
        childDelegate:
            ListWheelChildBuilderDelegate(
          childCount: options.length,
          builder: (context, index) {

            final value = options[index];
            final isSelected =
                value == selected;

            return Center(
              child: AnimatedDefaultTextStyle(
                duration:
                    const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: isSelected ? 20 : 16,
                  fontWeight: isSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: isSelected
                      ? accentColor
                      : Colors.white54,
                ),
                child: Text(value.toString()),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// ===============================================================
/// SELECTOR CARD
///
/// Tarjeta visual que contiene un wheel selector.
/// ===============================================================

class _SelectorCard extends StatelessWidget {
  final String title;
  final String value;
  final Widget child;
  final Color accentColor;

  const _SelectorCard({
    required this.title,
    required this.value,
    required this.child,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius:
              BorderRadius.circular(20),
          border:
              Border.all(color: Colors.white12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedSwitcher(
              duration:
                  const Duration(milliseconds: 200),
              child: Text(
                value,
                key: ValueKey('$title-$value'),
                style: TextStyle(
                  color: accentColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}