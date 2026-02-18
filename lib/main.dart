import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SmartWodApp());
}

class SmartWodApp extends StatelessWidget {
  const SmartWodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SMARTWOD',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
