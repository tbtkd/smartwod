import 'package:flutter/material.dart';

class DurationPickerDialog extends StatefulWidget {
  final int initialSeconds;
  final ValueChanged<int> onTimeSelected;

  const DurationPickerDialog({
    super.key,
    required this.initialSeconds,
    required this.onTimeSelected,
  });

  @override
  State<DurationPickerDialog> createState() =>
      _DurationPickerDialogState();
}

class _DurationPickerDialogState
    extends State<DurationPickerDialog> {
  late int _minutes;
  late int _seconds;

  @override
  void initState() {
    super.initState();
    _minutes = widget.initialSeconds ~/ 60;
    _seconds = widget.initialSeconds % 60;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: const Text(
        'Seleccionar tiempo',
        style: TextStyle(color: Colors.white),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _NumberPicker(
            label: 'min',
            value: _minutes,
            max: 99,
            onChanged: (value) {
              setState(() => _minutes = value);
            },
          ),
          const SizedBox(width: 16),
          _NumberPicker(
            label: 'seg',
            value: _seconds,
            max: 59,
            onChanged: (value) {
              setState(() => _seconds = value);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () {
            final totalSeconds = (_minutes * 60) + _seconds;
            widget.onTimeSelected(totalSeconds);
            Navigator.pop(context);
          },
          child: const Text(
            'Aceptar',
            style: TextStyle(color: Colors.orange),
          ),
        ),
      ],
    );
  }
}

/// Widget interno para seleccionar números
class _NumberPicker extends StatelessWidget {
  final String label;
  final int value;
  final int max;
  final ValueChanged<int> onChanged;

  const _NumberPicker({
    required this.label,
    required this.value,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        IconButton(
          onPressed: value < max ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.keyboard_arrow_up),
          color: Colors.white,
        ),
        Text(
          value.toString().padLeft(2, '0'),
          style: const TextStyle(
            color: Colors.orange,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: value > 0 ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.keyboard_arrow_down),
          color: Colors.white,
        ),
      ],
    );
  }
}
