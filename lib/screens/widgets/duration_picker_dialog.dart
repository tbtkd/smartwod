import 'package:flutter/material.dart';

class DurationPickerDialog extends StatefulWidget {
  final int initialSeconds;
  final void Function(int) onTimeSelected;

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

  late int minutes;
  late int seconds;

  @override
  void initState() {
    super.initState();
    minutes = widget.initialSeconds ~/ 60;
    seconds = widget.initialSeconds % 60;
  }

  void _confirm() {
    final total = (minutes * 60) + seconds;
    widget.onTimeSelected(total);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        height: 300,
        child: Column(
          children: [

            const SizedBox(height: 20),

            const Center(
              child: Text(
                'Seleccionar duración',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  _buildPicker(
                    value: minutes,
                    max: 59,
                    onChanged: (val) =>
                        setState(() => minutes = val),
                  ),

                  const SizedBox(width: 10),

                  const Text(
                    ':',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 28,
                    ),
                  ),

                  const SizedBox(width: 10),

                  _buildPicker(
                    value: seconds,
                    max: 59,
                    onChanged: (val) =>
                        setState(() => seconds = val),
                  ),
                ],
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(context),
                    child: const Text(
                      'Cancelar',
                      style:
                          TextStyle(color: Colors.white70),
                    ),
                  ),
                  TextButton(
                    onPressed: _confirm,
                    child: const Text(
                      'Aceptar',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildPicker({
    required int value,
    required int max,
    required Function(int) onChanged,
  }) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_up,
                color: Colors.white),
            onPressed: () {
              if (value < max) onChanged(value + 1);
            },
          ),
          Text(
            value.toString().padLeft(2, '0'),
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down,
                color: Colors.white),
            onPressed: () {
              if (value > 0) onChanged(value - 1);
            },
          ),
        ],
      ),
    );
  }
}
