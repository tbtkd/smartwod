import 'package:flutter/material.dart';

//import '../../domain/runners/emom_runner.dart';
import '../../domain/enums/workout_type.dart';
import 'timer_screen.dart';
import '../../domain/runners/segment_runner.dart';
import '../../domain/definitions/emom_definition.dart';

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

  final List<int> _roundOptions =
      List.generate(30, (i) => i + 1);

  final List<int> _secondOptions = [30, 45, 60, 90];

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
      body: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: 30),

            _SelectorCard(
              title: 'Rondas',
              value: _rounds.toString(),
              accentColor: Colors.blueAccent,
              child: _buildWheel(
                options: _roundOptions,
                selected: _rounds,
                accentColor: Colors.blueAccent,
                onChanged: (val) =>
                    setState(() => _rounds = val),
              ),
            ),

            const SizedBox(height: 24),

            _SelectorCard(
              title: 'Duración por ronda',
              value: '$_secondsPerRound seg',
              accentColor: Colors.blueAccent,
              child: _buildWheel(
                options: _secondOptions,
                selected: _secondsPerRound,
                accentColor: Colors.blueAccent,
                onChanged: (val) =>
                    setState(() => _secondsPerRound = val),
              ),
            ),

            const SizedBox(height: 30),

            /// 🔥 Preview dinámico animado
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(
                  vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.blueAccent.withValues(alpha: 0.03),
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
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
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
                          /*runnerBuilder:
                              (soundEngine) =>
                                  EmomRunner(
                            totalRounds: _rounds,
                            secondsPerRound:
                                _secondsPerRound,
                            soundEngine:
                                soundEngine,
                          ),*/
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
    );
  }

  Widget _buildWheel({
    required List<int> options,
    required int selected,
    required Color accentColor,
    required Function(int) onChanged,
  }) {
    return SizedBox(
      height: 90,
      child: ListWheelScrollView.useDelegate(
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