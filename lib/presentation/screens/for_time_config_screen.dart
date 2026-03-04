import 'package:flutter/material.dart';

import '../../domain/definitions/for_time_definition.dart';
import '../../domain/runners/segment_runner.dart';
import '../../domain/enums/workout_type.dart';
import '../../core/workout_type_extension.dart';
//import '../../core/audio/sound_engine.dart';
import 'timer_screen.dart';

class ForTimeConfigScreen extends StatefulWidget {
  const ForTimeConfigScreen({super.key});

  @override
  State<ForTimeConfigScreen> createState() =>
      _ForTimeConfigScreenState();
}

class _ForTimeConfigScreenState
    extends State<ForTimeConfigScreen> {

  int _minutes = 10;

  final List<int> _minuteOptions =
      List.generate(60, (i) => i + 1);

  int get _totalSeconds => _minutes * 60;

  String _format(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  // ===============================================================
  // START WORKOUT
  // ===============================================================
  void _startWorkout() {

    final definition = ForTimeDefinition(
      timeCapSeconds: _totalSeconds,
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

          workoutType: WorkoutType.forTime,

          totalConfiguredSeconds:
              definition.totalSeconds,

          /// 🔥 NUEVO — metadata para historial
          metadata: {
            "timeCapSeconds": _totalSeconds,
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final accentColor =
        WorkoutType.forTime.color;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text(
          WorkoutType.forTime.displayName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: 30),

            _SelectorCard(
              title: 'Time Cap (min)',
              value: _minutes.toString(),
              accentColor: accentColor,
              child: _buildWheel(
                options: _minuteOptions,
                selected: _minutes,
                accentColor: accentColor,
                onChanged: (val) =>
                    setState(() => _minutes = val),
              ),
            ),

            const SizedBox(height: 30),

            AnimatedContainer(
              duration:
                  const Duration(milliseconds: 300),
              padding:
                  const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24),
              decoration: BoxDecoration(
                color:
                    accentColor.withValues(alpha: 0.08),
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
                    'Tiempo total',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _format(_totalSeconds),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

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
                          BorderRadius.circular(26),
                    ),
                  ),
                  onPressed: _startWorkout,
                  child: const Text(
                    'Empezar For Time',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
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
                duration:
                    const Duration(
                        milliseconds: 200),
                style: TextStyle(
                  fontSize:
                      isSelected ? 18 : 14,
                  fontWeight:
                      isSelected
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
          const EdgeInsets.symmetric(
              horizontal: 20),
      child: Container(
        padding:
            const EdgeInsets.symmetric(
                vertical: 12),
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
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              value,
              style: TextStyle(
                color: accentColor,
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
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