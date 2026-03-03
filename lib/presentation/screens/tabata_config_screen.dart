import 'package:flutter/material.dart';

import '../../domain/definitions/tabata_definition.dart';
import '../../domain/runners/segment_runner.dart';
import '../../domain/enums/workout_type.dart';
import '../../core/workout_type_extension.dart';
import 'timer_screen.dart';

class TabataConfigScreen extends StatefulWidget {
  const TabataConfigScreen({super.key});

  @override
  State<TabataConfigScreen> createState() =>
      _TabataConfigScreenState();
}

class _TabataConfigScreenState
    extends State<TabataConfigScreen> {

  int _rounds = 8;
  int _workSeconds = 20;
  int _restSeconds = 10;

  final List<int> _roundOptions =
      List.generate(30, (i) => i + 1);

  final List<int> _timeOptions =
      [10, 15, 20, 25, 30, 40, 45, 50, 60];

  // ===============================================================
  // PRESETS
  // ===============================================================

  final List<TabataPreset> _presets = const [
    TabataPreset(
      name: 'Clásico',
      rounds: 8,
      workSeconds: 20,
      restSeconds: 10,
    ),
    TabataPreset(
      name: 'Resistencia',
      rounds: 10,
      workSeconds: 30,
      restSeconds: 15,
    ),
    TabataPreset(
      name: 'Potencia',
      rounds: 6,
      workSeconds: 40,
      restSeconds: 20,
    ),
    TabataPreset(
      name: 'Sprint',
      rounds: 12,
      workSeconds: 15,
      restSeconds: 10,
    ),
    TabataPreset(
      name: 'Avanzado',
      rounds: 12,
      workSeconds: 45,
      restSeconds: 15,
    ),
  ];

  int get _totalSeconds =>
      _rounds * (_workSeconds + _restSeconds);

  String _format(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  void _applyPreset(TabataPreset preset) {
    setState(() {
      _rounds = preset.rounds;
      _workSeconds = preset.workSeconds;
      _restSeconds = preset.restSeconds;
    });
  }

  void _startWorkout() {
    final definition = TabataDefinition(
      workSeconds: _workSeconds,
      restSeconds: _restSeconds,
      rounds: _rounds,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TimerScreen(
          runnerBuilder: (soundEngine) =>
              SegmentRunner(
            definition: definition,
            soundEngine: soundEngine,
          ),
          workoutType: WorkoutType.tabata,
          totalConfiguredSeconds:
              definition.totalSeconds,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final accentColor =
        WorkoutType.tabata.color;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text(
          WorkoutType.tabata.displayName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: [

              const SizedBox(height: 15),

              // ===================================================
              // PRESETS ROW
              // ===================================================

              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    final preset = _presets[index];

                    final bool isActive =
                        _rounds == preset.rounds &&
                        _workSeconds ==
                            preset.workSeconds &&
                        _restSeconds ==
                            preset.restSeconds;

                    return GestureDetector(
                      onTap: () =>
                          _applyPreset(preset),
                      child: AnimatedContainer(
                        duration: const Duration(
                            milliseconds: 200),
                        padding:
                            const EdgeInsets.symmetric(
                                horizontal: 14),
                        decoration: BoxDecoration(
                          color: isActive
                              ? accentColor.withValues(
                                  alpha: 0.2)
                              : Colors.white10,
                          borderRadius:
                              BorderRadius.circular(
                                  18),
                          border: Border.all(
                            color: isActive
                                ? accentColor
                                : Colors.white12,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          preset.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w600,
                            color: isActive
                                ? accentColor
                                : Colors.white70,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: 10),
                  itemCount: _presets.length,
                ),
              ),

              const SizedBox(height: 15),

              // ===================================================
              // SELECTORS
              // ===================================================

              _SelectorCard(
                title: 'Rondas',
                value: _rounds.toString(),
                accentColor: accentColor,
                child: _buildWheel(
                  options: _roundOptions,
                  selected: _rounds,
                  accentColor: accentColor,
                  onChanged: (val) =>
                      setState(() => _rounds = val),
                ),
              ),

              const SizedBox(height: 13),

              _SelectorCard(
                title: 'Trabajo (seg)',
                value: '$_workSeconds',
                accentColor: accentColor,
                child: _buildWheel(
                  options: _timeOptions,
                  selected: _workSeconds,
                  accentColor: accentColor,
                  onChanged: (val) =>
                      setState(() =>
                          _workSeconds = val),
                ),
              ),

              const SizedBox(height: 13),

              _SelectorCard(
                title: 'Descanso (seg)',
                value: '$_restSeconds',
                accentColor: accentColor,
                child: _buildWheel(
                  options: _timeOptions,
                  selected: _restSeconds,
                  accentColor: accentColor,
                  onChanged: (val) =>
                      setState(() =>
                          _restSeconds = val),
                ),
              ),

              const SizedBox(height: 15),

              // ===================================================
              // PREVIEW
              // ===================================================

              AnimatedContainer(
                duration:
                    const Duration(milliseconds: 300),
                padding:
                    const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24),
                decoration: BoxDecoration(
                  color: accentColor.withValues(
                      alpha: 0.08),
                  borderRadius:
                      BorderRadius.circular(20),
                  border: Border.all(
                    color: accentColor.withValues(
                        alpha: 0.3),
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
                    const SizedBox(height: 4),
                    AnimatedSwitcher(
                      duration: const Duration(
                          milliseconds: 250),
                      child: Text(
                        _format(_totalSeconds),
                        key: ValueKey(
                            _totalSeconds),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight:
                              FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Padding(
                padding:
                    const EdgeInsets.symmetric(
                        horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          accentColor,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                26),
                      ),
                    ),
                    onPressed: _startWorkout,
                    child: const Text(
                      'Empezar Tabata',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWheel({
    required List<int> options,
    required int selected,
    required Color accentColor,
    required Function(int) onChanged,
  }) {
    return SizedBox(
      height: 70,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 36,
        physics:
            const FixedExtentScrollPhysics(),
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
                duration: const Duration(
                    milliseconds: 200),
                style: TextStyle(
                  fontSize:
                      isSelected ? 18 : 14,
                  fontWeight: isSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: isSelected
                      ? accentColor
                      : Colors.white54,
                ),
                child: Text(
                    value.toString()),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TabataPreset {
  final String name;
  final int rounds;
  final int workSeconds;
  final int restSeconds;

  const TabataPreset({
    required this.name,
    required this.rounds,
    required this.workSeconds,
    required this.restSeconds,
  });
}

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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),

            /// 🔥 CORRECCIÓN CLAVE AQUÍ
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                value,
                key: ValueKey('$title-$value'), // ← evita duplicate keys
                style: TextStyle(
                  color: accentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}