// # Configuración general (MaterialApp, tema)

import 'package:flutter/material.dart';
import '../screens/home_screen.dart';

// Este widget define la configuración GENERAL de la app
// Tema, título y pantalla inicial
class SmartWodApp extends StatelessWidget {
  const SmartWodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartWOD',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
