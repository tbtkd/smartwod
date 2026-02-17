import 'package:flutter/material.dart';

enum DurationType { work, rest }

class DurationPickerDialog extends StatefulWidget {
  final int initialSeconds;
  final DurationType type;
  final void Function(int) onTimeSelected;

  const DurationPickerDialog({
    super.key,
    required this.initialSeconds,
    required this.type,
    required this.onTimeSelected,
  });

  @override
  State<DurationPickerDialog> createState() =>
      _DurationPickerDialogState();
}

class _DurationPickerDialogState
    extends State<DurationPickerDialog> {

  late int minutes;
  late int seconds;

  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _secondController;

  int get minTotal =>
      widget.type == DurationType.work ? 15 : 5;

  int get secondStep =>
      widget.type == DurationType.work ? 15 : 5;

  int get maxMinutes =>
      widget.type == DurationType.work ? 100 : 5;

  List<int> get secondValues {
    List<int> values = [];
    for (int i = 0; i < 60; i += secondStep) {
      values.add(i);
    }
    return values;
  }

  @override
  void initState() {
    super.initState();

    int initial = widget.initialSeconds < minTotal
        ? minTotal
        : widget.initialSeconds;

    minutes = initial ~/ 60;
    seconds = initial % 60;

    if (!secondValues.contains(seconds)) {
      seconds = secondValues.firstWhere(
          (e) => e >= seconds,
          orElse: () => secondValues.last);
    }

    _minuteController =
        FixedExtentScrollController(initialItem: minutes);

    _secondController =
        FixedExtentScrollController(
            initialItem: secondValues.indexOf(seconds));
  }

  @override
  void dispose() {
    _minuteController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  void _setPreset(int total) {
    if (total >= minTotal) {
      setState(() {
        minutes = total ~/ 60;
        seconds = total % 60;

        if (!secondValues.contains(seconds)) {
          seconds = secondValues.first;
        }

        _minuteController.jumpToItem(minutes);
        _secondController.jumpToItem(
            secondValues.indexOf(seconds));
      });
    }
  }

  void _confirm() {
    int total = (minutes * 60) + seconds;
    if (total < minTotal) total = minTotal;
    widget.onTimeSelected(total);
    Navigator.pop(context);
  }

  String _format(int value) =>
      value.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final isWork = widget.type == DurationType.work;

    return Dialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 18, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Stack(
              children: [
                Center(
                  child: Text(
                    isWork
                        ? 'Configurar AMRAP'
                        : 'Configurar Descanso',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [

                // MINUTOS
                _buildWheel(
                  label: 'min',
                  controller: _minuteController,
                  itemCount: maxMinutes + 1,
                  selectedValue: minutes,
                  onChanged: (index) {
                    setState(() => minutes = index);
                  },
                ),

                const SizedBox(width: 18),

                const Text(
                  ':',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 26,
                  ),
                ),

                const SizedBox(width: 18),

                // SEGUNDOS
                _buildWheel(
                  label: 'seg',
                  controller: _secondController,
                  itemCount: secondValues.length,
                  selectedValue: seconds,
                  onChanged: (index) {
                    setState(() =>
                        seconds = secondValues[index]);
                  },
                  valueBuilder: (index) =>
                      secondValues[index],
                ),
              ],
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: isWork
                  ? [15, 30, 45, 60, 90, 120, 180]
                      .map((e) => _presetChip(e))
                      .toList()
                  : [5, 10, 15, 20, 30, 45, 60]
                      .map((e) => _presetChip(e))
                      .toList(),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () =>
                      Navigator.pop(context),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                        color: Colors.white70),
                  ),
                ),
                TextButton(
                  onPressed: _confirm,
                  child: const Text(
                    'Aceptar',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWheel({
    required String label,
    required FixedExtentScrollController controller,
    required int itemCount,
    required int selectedValue,
    required Function(int) onChanged,
    int Function(int)? valueBuilder,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 90,
          width: 50,
          child: ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 30,
            physics:
                const FixedExtentScrollPhysics(),
            onSelectedItemChanged: onChanged,
            childDelegate:
                ListWheelChildBuilderDelegate(
              childCount: itemCount,
              builder: (context, index) {
                int value =
                    valueBuilder != null
                        ? valueBuilder(index)
                        : index;

                return Center(
                  child: Text(
                    _format(value),
                    style: TextStyle(
                      color: value ==
                              selectedValue
                          ? Colors.orange
                          : Colors.white54,
                      fontSize: 18,
                      fontWeight:
                          value ==
                                  selectedValue
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _presetChip(int totalSeconds) {
    return GestureDetector(
      onTap: () => _setPreset(totalSeconds),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius:
              BorderRadius.circular(18),
        ),
        child: Text(
          '${(totalSeconds ~/ 60).toString().padLeft(2, '0')}:'
          '${(totalSeconds % 60).toString().padLeft(2, '0')}',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
