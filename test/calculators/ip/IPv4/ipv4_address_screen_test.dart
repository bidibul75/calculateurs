import 'package:calculators/calculators/ip/IPv4/screens/ipv4_address_screen.dart';
import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/shared/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  setUp(() {
    if (GetIt.I.isRegistered<ThemeManager>()) {
      GetIt.I.unregister<ThemeManager>();
    }
    GetIt.I.registerSingleton<ThemeManager>(ThemeManager());
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  Future<void> pumpScreen(
    WidgetTester tester, {
    TargetPlatform platform = TargetPlatform.android,
    Size? surfaceSize,
  }) async {
    await tester.binding.setSurfaceSize(surfaceSize);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: platform),
        locale: Locale('en'),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Ipv4AddressScreen(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tapKey(WidgetTester tester, String key) async {
    await tester.tap(find.text(key));
    await tester.pump();
  }

  testWidgets('shows validation error for an invalid CIDR', (tester) async {
    await pumpScreen(tester, platform: TargetPlatform.windows);

    await tester.enterText(find.byType(TextField), '192.168.1.300/24');
    await tester.tap(find.text('Calculate'));
    await tester.pumpAndSettle();

    expect(find.text('Invalid IPv4 CIDR format.'), findsOneWidget);
  });

  testWidgets('shows computed network details for a valid CIDR', (tester) async {
    await pumpScreen(tester, platform: TargetPlatform.windows);

    await tester.enterText(find.byType(TextField), '192.168.1.34/24');
    await tester.tap(find.text('Calculate'));
    await tester.pumpAndSettle();

    expect(find.text('Network address'), findsOneWidget);
    expect(find.text('192.168.1.0'), findsOneWidget);
    expect(find.text('Broadcast address'), findsOneWidget);
    expect(find.text('192.168.1.255'), findsOneWidget);
    expect(find.text('Usable hosts'), findsOneWidget);
    expect(find.text('254'), findsOneWidget);
  });

  testWidgets('shows custom keypad on mobile only', (tester) async {
    await pumpScreen(tester, platform: TargetPlatform.android);
    expect(find.text('Enter'), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_return), findsOneWidget);

    await pumpScreen(tester, platform: TargetPlatform.windows);
    expect(find.text('Enter'), findsNothing);
    expect(find.byIcon(Icons.keyboard_return), findsNothing);
  });

  testWidgets('mobile keypad supports delete and compact layouts', (tester) async {
    await pumpScreen(
      tester,
      platform: TargetPlatform.android,
      surfaceSize: const Size(320, 640),
    );

    await tester.tap(find.text('1'));
    await tester.pump();
    await tester.tap(find.text('2'));
    await tester.pump();
    await tester.tap(find.text('⌫'));
    await tester.pump();

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.controller?.text, '1');
    expect(find.text('C'), findsOneWidget);
    expect(find.text('⌫'), findsOneWidget);
  });

  testWidgets('mobile keypad hides after Enter and shows the result area', (tester) async {
    await pumpScreen(tester, platform: TargetPlatform.android, surfaceSize: const Size(375, 812));

    for (final key in ['1', '9', '2', '.', '1', '6', '8', '.', '1', '.', '3', '4', '/', '2', '4']) {
      await tapKey(tester, key);
    }

    await tapKey(tester, 'Enter');
    await tester.pumpAndSettle();

    expect(find.text('C'), findsNothing);
    expect(find.text('⌫'), findsNothing);
    expect(find.text('Network address'), findsOneWidget);
    expect(find.text('192.168.1.0'), findsOneWidget);
  });
}

