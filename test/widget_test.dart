// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:calculators/calculators/basic_calc/screens/theme/theme_manager.dart';
import 'package:calculators/main.dart';
import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  testWidgets('Calculator app smoke test', (WidgetTester tester) async {
    // Setup GetIt before building the app
    if (GetIt.I.isRegistered<LocalNumberSymbols>()) {
      GetIt.I.unregister<LocalNumberSymbols>();
    }
    if (GetIt.I.isRegistered<ThemeManager>()) {
      GetIt.I.unregister<ThemeManager>();
    }

    final symbols = LocalNumberSymbols();
    symbols.updateFromLocale('en-US');
    GetIt.I.registerSingleton<LocalNumberSymbols>(symbols);
    GetIt.I.registerSingleton<ThemeManager>(ThemeManager());

    // Build our app and trigger a frame.
    await tester.pumpWidget(const CalculatorApp());
    await tester.pumpAndSettle();

    // Verify that the app has a title
    expect(find.text('Basic calculator'), findsOneWidget);

    // Verify that the app has a menu drawer button
    expect(find.byIcon(Icons.menu), findsOneWidget);
  });
}
