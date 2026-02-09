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
  static const List<int> _steps = [0, 15, 30, 45];

  late int _minutes;
  late int _seconds;

  @override
  void initState() {
    super.initState();
    _minutes = widget.initialSeconds ~/ 60;
    _seconds = widget.initialSeconds % 60;
    if (!_steps.contains(_seconds)) _seconds = 0;
  }

  void _increaseSeconds() {
    final index = _steps.indexOf(_seconds);
    if (index == _steps.length - 1) {
      setState(() {
        _minutes++;
        _seconds = 0;
      });
    } else {
      setState(() {
        _seconds = _steps[index + 1];
      });
    }
  }

  void _decreaseSeconds() {
    final index = _steps.indexOf(_seconds);
    if (index == 0 && _minutes > 0) {
      setState(() {
        _minutes--;
        _seconds = 45;
      });
    } else if (index > 0) {
      setState(() {
        _seconds = _steps[index - 1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: const Text(
        'Seleccionar duración',
        style: TextStyle(color: Colors.white),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPicker(
            label: 'min',
            value: _minutes,
            onIncrease: () {
              setState(() {
                _minutes++;
              });
            },
            onDecrease: _minutes > 0
                ? () {
                    setState(() {
                      _minutes--;
                    });
                  }
                : null,
          ),
          const SizedBox(width: 24),
          _buildPicker(
            label: 'seg',
            value: _seconds,
            onIncrease: _increaseSeconds,
            onDecrease: _decreaseSeconds,
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
            widget.onTimeSelected(_minutes * 60 + _seconds);
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

  Widget _buildPicker({
    required String label,
    required int value,
    required VoidCallback onIncrease,
    VoidCallback? onDecrease,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_up),
          color: Colors.white,
          onPressed: onIncrease,
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
          icon: const Icon(Icons.keyboard_arrow_down),
          color: Colors.white,
          onPressed: onDecrease,
        ),
      ],
    );
  }
}
