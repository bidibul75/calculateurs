import 'package:calculators/main.dart';
import 'package:calculators/navigation/app_routes.dart';
import 'package:calculators/shared/theme/theme_manager.dart';
import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await GetIt.I.reset();

    final symbols = LocalNumberSymbols();
    symbols.updateFromLocale('en-US');
    GetIt.I.registerSingleton<LocalNumberSymbols>(symbols);
    GetIt.I.registerSingleton<ThemeManager>(ThemeManager());
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  testWidgets('basic calculator stores multiple history entries and reuses a tapped result', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(411, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const CalculatorApp(initialRoute: AppRoutes.home));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, '1'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, '+'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, '2'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, '='));
    await tester.pumpAndSettle();

    expect(find.textContaining('1 + 2 = 3'), findsOneWidget);

    await tester.tap(find.textContaining('1 + 2 = 3'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'x'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, '4'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, '='));
    await tester.pumpAndSettle();

    expect(find.textContaining('3 x 4 = 12'), findsOneWidget);
    expect(find.textContaining('1 + 2 = 3'), findsOneWidget);

    await tester.drag(find.textContaining('1 + 2 = 3'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.textContaining('1 + 2 = 3'), findsNothing);
    expect(find.textContaining('3 x 4 = 12'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('basic.history.clear')));
    await tester.pumpAndSettle();

    expect(find.textContaining('3 x 4 = 12'), findsNothing);
  });
}

