import 'package:flutter/material.dart';
import 'calculators/basic_calc/screens/calculator_screen.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ma Calculatrice',
      debugShowCheckedModeBanner: false, // Enlève la petite bannière "Debug"
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // C'est ici qu'on définit l'écran qui s'affiche au démarrage
      home: const CalculatorScreen(),
    );
  }
}
