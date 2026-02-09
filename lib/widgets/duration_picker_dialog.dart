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

  void _incSeconds() {
    final i = _steps.indexOf(_seconds);
    if (i == _steps.length - 1) {
      setState(() {
        _minutes++;
        _seconds = 0;
      });
    } else {
      setState(() => _seconds = _steps[i + 1]);
    }
  }

  void _decSeconds() {
    final i = _steps.indexOf(_seconds);
    if (i == 0 && _minutes > 0) {
      setState(() {
        _minutes--;
        _seconds = 45;
      });
    } else if (i > 0) {
      setState(() => _seconds = _steps[i - 1]);
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
          _MinutePicker(
            value: _minutes,
            onChanged: (v) => setState(() => _minutes = v),
          ),
          const SizedBox(width: 24),
          _SecondPicker(
            value: _seconds,
            onInc: _incSeconds,
            onDec: _decSeconds,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar',
              style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () {
            widget.onTimeSelected(_minutes * 60 + _seconds);
            Navigator.pop(context);
          },
          child: const Text('Aceptar',
              style: TextStyle(color: Colors.orange)),
        ),
      ],
    );
  }
}

class _MinutePicker extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _MinutePicker({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('min', style: TextStyle(color: Colors.white)),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_up),
          color: Colors.white,
          onPressed: () => onChanged(value + 1),
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
          onPressed: value > 0 ? () => onChanged(value - 1) : null,
        ),
      ],
    );
  }
}

class _SecondPicker extends StatelessWidget {
  final int value;
  final VoidCallback onInc;
  final VoidCallback onDec;

  const _SecondPicker({
    required this.value,
    required this.onInc,
    required this.onDec,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('seg', style: TextStyle(color: Colors.white)),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_up),
          color: Colors.white,
          onPressed: onInc,
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
          onPressed: onDec,
        ),
      ],
    );
  }
}
