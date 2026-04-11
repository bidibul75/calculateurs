import 'package:calculators/calculators/ip/IPv6/screens/ipv6_supernet_screen.dart';
import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/shared/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Key supernetResultCopyButtonKey = ValueKey<String>('ipv6.supernet.result.copy');
const Key supernetResultSaveButtonKey = ValueKey<String>('ipv6.supernet.result.save');

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
        home: const Ipv6SupernetScreen(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> addAddress(WidgetTester tester, String cidr) async {
    await tester.enterText(find.byType(TextField), cidr);
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
  }

  testWidgets('contiguous list keeps export actions in result card', (tester) async {
    await pumpScreen(tester);

    await addAddress(tester, '2001:db8::/64');
    await addAddress(tester, '2001:db8:0:1::/64');

    await tester.tap(find.text('Calculate supernet'));
    await tester.pumpAndSettle();

    expect(find.text('All addresses are contiguous.'), findsOneWidget);
    expect(find.text('Address relations'), findsNothing);
    expect(find.byKey(supernetResultCopyButtonKey), findsOneWidget);
    expect(find.byKey(supernetResultSaveButtonKey), findsOneWidget);

    final resultCard = find.ancestor(
      of: find.text('Supernet result'),
      matching: find.byType(Card),
    );
    expect(find.descendant(of: resultCard, matching: find.byKey(supernetResultCopyButtonKey)), findsOneWidget);
    expect(find.descendant(of: resultCard, matching: find.byKey(supernetResultSaveButtonKey)), findsOneWidget);
  });

  testWidgets('non-contiguous list shows export actions in relations card', (tester) async {
    await pumpScreen(tester);

    await addAddress(tester, '2001:db8::/64');
    await addAddress(tester, '2001:db8:0:2::/64');

    await tester.tap(find.text('Calculate supernet'));
    await tester.pumpAndSettle();

    expect(find.text('Addresses are not all contiguous.'), findsOneWidget);
    expect(find.text('Address relations'), findsOneWidget);
    expect(find.byKey(supernetResultCopyButtonKey), findsOneWidget);
    expect(find.byKey(supernetResultSaveButtonKey), findsOneWidget);

    final resultCard = find.ancestor(
      of: find.text('Supernet result'),
      matching: find.byType(Card),
    );
    final relationsCard = find.ancestor(
      of: find.text('Address relations'),
      matching: find.byType(Card),
    );

    expect(find.descendant(of: resultCard, matching: find.byKey(supernetResultCopyButtonKey)), findsNothing);
    expect(find.descendant(of: resultCard, matching: find.byKey(supernetResultSaveButtonKey)), findsNothing);
    expect(find.descendant(of: relationsCard, matching: find.byKey(supernetResultCopyButtonKey)), findsOneWidget);
    expect(find.descendant(of: relationsCard, matching: find.byKey(supernetResultSaveButtonKey)), findsOneWidget);
  });
}

