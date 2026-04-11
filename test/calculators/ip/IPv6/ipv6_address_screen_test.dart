import 'package:calculators/calculators/ip/IPv6/screens/ipv6_address_screen.dart';
import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/shared/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Key mobileKeypadContainerKey = ValueKey<String>('ipv6.mobileKeypad');
const Key clearButtonKey = ValueKey<String>('ipv6.key.clear');
const Key enterButtonKey = ValueKey<String>('ipv6.key.enter');

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

  Future<void> pumpScreen(WidgetTester tester, {required TargetPlatform platform}) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: platform),
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Ipv6AddressScreen(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('mobile shows custom keypad with C and Enter actions', (tester) async {
    await pumpScreen(tester, platform: TargetPlatform.android);

    expect(find.byKey(mobileKeypadContainerKey), findsOneWidget);
    expect(find.byKey(clearButtonKey), findsOneWidget);
    expect(find.descendant(of: find.byKey(clearButtonKey), matching: find.text('C')), findsOneWidget);
    expect(find.byKey(enterButtonKey), findsOneWidget);
  });

  testWidgets('desktop hides custom keypad', (tester) async {
    await pumpScreen(tester, platform: TargetPlatform.windows);

    expect(find.byKey(mobileKeypadContainerKey), findsNothing);
  });
}


