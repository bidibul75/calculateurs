import 'package:calculators/calculators/ip/IPv4/screens/ipv4_address_screen.dart';
import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/shared/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Key mobileKeypadContainerKey = ValueKey<String>('ipv4.mobileKeypad');
const Key clearButtonKey = ValueKey<String>('ipv4.key.clear');
const Key backspaceButtonKey = ValueKey<String>('ipv4.key.backspace');
const Key enterButtonKey = ValueKey<String>('ipv4.key.enter');
const Key resultCopyButtonKey = ValueKey<String>('ipv4.result.copy');
const Key resultSaveButtonKey = ValueKey<String>('ipv4.result.save');

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
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
    expect(find.byKey(resultCopyButtonKey), findsOneWidget);
    expect(find.byKey(resultSaveButtonKey), findsOneWidget);
  });

  testWidgets('shows custom keypad on mobile only', (tester) async {
    await pumpScreen(tester, platform: TargetPlatform.android);
    expect(find.byKey(mobileKeypadContainerKey), findsOneWidget);
    expect(find.byKey(enterButtonKey), findsOneWidget);

    await pumpScreen(tester, platform: TargetPlatform.windows);
    expect(find.byKey(mobileKeypadContainerKey), findsNothing);
    expect(find.byKey(enterButtonKey), findsNothing);
  });

  testWidgets('mobile shows Clear action only when keypad is hidden; desktop shows both actions', (tester) async {
    await pumpScreen(tester, platform: TargetPlatform.android);
    expect(find.text('Calculate'), findsNothing);
    expect(find.text('Clear'), findsNothing);

    for (final key in ['1', '9', '2', '.', '1', '6', '8', '.', '1', '.', '3', '4', '/', '2', '4']) {
      await tapKey(tester, key);
    }
    await tester.tap(find.byKey(enterButtonKey));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Clear'), findsOneWidget);

    await pumpScreen(tester, platform: TargetPlatform.windows);
    expect(find.text('Calculate'), findsOneWidget);
    expect(find.text('Clear'), findsOneWidget);
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
    await tester.tap(find.byKey(backspaceButtonKey));
    await tester.pump();

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.controller?.text, '1');
    expect(find.byKey(clearButtonKey), findsOneWidget);
    expect(find.byKey(backspaceButtonKey), findsOneWidget);
    expect(find.byIcon(Icons.backspace_outlined), findsOneWidget);
  });

  testWidgets('mobile keypad uses consistent key height', (tester) async {
    await pumpScreen(tester, platform: TargetPlatform.android, surfaceSize: const Size(375, 812));

    final Size digitSize = tester.getSize(find.widgetWithText(ElevatedButton, '1'));
    final Size clearSize = tester.getSize(find.byKey(clearButtonKey));
    final Size enterSize = tester.getSize(find.byKey(enterButtonKey));

    expect(digitSize.height, clearSize.height);
    expect(clearSize.height, enterSize.height);
  });

  testWidgets('mobile keypad hides with animation after Enter and shows the result area', (tester) async {
    await pumpScreen(tester, platform: TargetPlatform.android, surfaceSize: const Size(375, 812));

    for (final key in ['1', '9', '2', '.', '1', '6', '8', '.', '1', '.', '3', '4', '/', '2', '4']) {
      await tapKey(tester, key);
    }

    await tester.tap(find.byKey(enterButtonKey));
    await tester.pump();
    expect(find.byKey(mobileKeypadContainerKey), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byKey(mobileKeypadContainerKey), findsNothing);
    expect(find.text('Network address'), findsOneWidget);
    expect(find.text('192.168.1.0'), findsOneWidget);
  });

  testWidgets('tapping the input re-shows keypad after it has been hidden', (tester) async {
    await pumpScreen(tester, platform: TargetPlatform.android, surfaceSize: const Size(375, 812));

    for (final key in ['1', '9', '2', '.', '1', '6', '8', '.', '1', '.', '3', '4', '/', '2', '4']) {
      await tapKey(tester, key);
    }

    await tester.tap(find.byKey(enterButtonKey));
    await tester.pump();
    expect(find.byKey(mobileKeypadContainerKey), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byKey(mobileKeypadContainerKey), findsNothing);

    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(find.byKey(mobileKeypadContainerKey), findsOneWidget);
  });
}

