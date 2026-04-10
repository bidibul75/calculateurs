import 'package:calculators/calculators/ip/IPv4/screens/ipv4_supernet_screen.dart';
import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/shared/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Key supernetResultCopyButtonKey = ValueKey<String>('ipv4.supernet.result.copy');
const Key supernetResultSaveButtonKey = ValueKey<String>('ipv4.supernet.result.save');

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

  Future<void> pumpScreen(WidgetTester tester) async {
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
        home: const Ipv4SupernetScreen(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> addAddress(WidgetTester tester, String cidr) async {
    await tester.enterText(find.byType(TextField), cidr);
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
  }

  testWidgets('shows validation error for invalid CIDR input', (tester) async {
    await pumpScreen(tester);

    await addAddress(tester, '192.168.1.300/24');

    expect(find.text('Invalid IPv4 CIDR format.'), findsOneWidget);
  });

  testWidgets('computes and displays supernet for two valid addresses', (tester) async {
    await pumpScreen(tester);

    await addAddress(tester, '192.168.0.0/24');
    await addAddress(tester, '192.168.1.0/24');

    await tester.tap(find.text('Calculate supernet'));
    await tester.pumpAndSettle();

    expect(find.text('All addresses are contiguous.'), findsOneWidget);
    expect(find.text('Covering supernet: 192.168.0.0/23'), findsOneWidget);
    expect(find.byKey(supernetResultCopyButtonKey), findsOneWidget);
    expect(find.byKey(supernetResultSaveButtonKey), findsOneWidget);
  });

  testWidgets('prevents adding duplicate addresses and shows localized duplicate message', (tester) async {
    await pumpScreen(tester);

    await addAddress(tester, '10.0.0.0/24');
    await addAddress(tester, '10.0.0.0/24');

    expect(find.text('Duplicate removed: 10.0.0.0/24 (2 entries)'), findsOneWidget);
  });

  testWidgets('shows non-contiguous status and pairwise relations', (tester) async {
    await pumpScreen(tester);

    await addAddress(tester, '10.0.0.0/24');
    await addAddress(tester, '10.0.2.0/24');

    await tester.tap(find.text('Calculate supernet'));
    await tester.pumpAndSettle();

    expect(find.text('Addresses are not all contiguous.'), findsOneWidget);
    expect(find.textContaining('outside'), findsWidgets);
    expect(find.text('Address relations'), findsOneWidget);
  });
}

