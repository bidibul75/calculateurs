import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'calculators/basic_calc/screens/calculator_screen.dart';

void main() async {
  // // 1. Mandatory to execute code before runApp
  // WidgetsFlutterBinding.ensureInitialized();
  //
  // // 2. Gets the telephone language (ex: "fr_FR")
  // final String systemLocale = await findSystemLocale();
  //
  // // 3. Defines the default locale globally for all the intl package
  // Intl.defaultLocale = systemLocale;

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

      // // 4. Ajouter les délégués pour que les widgets Flutter (Calendriers, etc.)
      // // soient aussi traduits
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // // On accepte toutes les langues
      // supportedLocales: const [Locale('en'), Locale('fr'), Locale('es')],

      // Default start screen
      home: const CalculatorScreen(),
    );
  }
}
