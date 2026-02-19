// # Botón reutilizable (AMRAP, EMOM, etc.)

import 'package:flutter/material.dart';

// WodButton es un botón reutilizable para los tipos de entrenamiento
// (AMRAP, EMOM, TABATA, etc.)
class WodButton extends StatelessWidget {
  // Texto que se mostrará en el botón
  final String label;

  // Color principal del botón
  final Color color;

  // Acción que se ejecutará al presionar el botón
  final VoidCallback onPressed;

  // Constructor del botón
  const WodButton({
    super.key,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Botón ancho (ocupa todo el ancho disponible)
      width: double.infinity,

      // Altura fija para que todos los botones se vean iguales
      height: 60,

      child: ElevatedButton(
        // Acción al presionar
        onPressed: onPressed,

        // Estilos del botón
        style: ElevatedButton.styleFrom(
          backgroundColor: color,        // Color del botón
          foregroundColor: Colors.white, // Color del texto
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Bordes redondeados
          ),
        ),

        // Texto del botón
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
