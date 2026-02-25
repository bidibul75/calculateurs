import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'calculators/basic_calc/screens/calculator_screen.dart';
import 'package:get_it/get_it.dart';

void main() async {
  // Mandatory to execute code before runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Lock screen orientation to portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Records the unique instance at startup, so it can be used everywhere in the app with GetIt.I
  GetIt.I.registerSingleton<LocalNumberSymbols>(LocalNumberSymbols());

  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),

      // Default start screen
      home: const CalculatorScreen(),
    );
  }
}
