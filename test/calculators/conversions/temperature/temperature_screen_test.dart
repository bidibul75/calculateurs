import 'package:calculators/calculators/conversions/temperature/screens/temperature_screen.dart';
import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/shared/theme/theme_manager.dart';
import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  setUp(() {
    if (GetIt.I.isRegistered<LocalNumberSymbols>()) {
      GetIt.I.unregister<LocalNumberSymbols>();
    }
    final symbols = LocalNumberSymbols();
    symbols.updateFromLocale('en-US');
    GetIt.I.registerSingleton<LocalNumberSymbols>(symbols);

    if (GetIt.I.isRegistered<ThemeManager>()) {
      GetIt.I.unregister<ThemeManager>();
    }
    GetIt.I.registerSingleton<ThemeManager>(ThemeManager());
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  testWidgets('desktop keyboard updates temperature inputs', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.windows),
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const TemperatureScreen(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit5);
    await tester.pump();

    expect(find.text('25'), findsWidgets);
    expect(find.text('77.00'), findsOneWidget);
    expect(find.text('536.67'), findsOneWidget);
    expect(find.text('Enter'), findsNothing);
    expect(find.byKey(const ValueKey<String>('temperature.save')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('temperature.copy')));
    await tester.pumpAndSettle();
  });
}
