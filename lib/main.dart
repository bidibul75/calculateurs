import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/shared/theme/theme_manager.dart' as shared_theme;
import 'package:calculators/navigation/app_routes.dart';
import 'package:get_it/get_it.dart';
import 'package:calculators/calculators/ip/IPv6/addressIPV6.dart';
import 'package:calculators/calculators/ip/IPv4/address.dart';

void main() async {
  // Mandatory to execute code before runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Lock screen orientation to portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Register shared services.
  final LocalNumberSymbols localNumberSymbols = LocalNumberSymbols();
  localNumberSymbols.updateFromLocale(WidgetsBinding.instance.platformDispatcher.locale.toString());
  if (!GetIt.I.isRegistered<LocalNumberSymbols>()) {
    GetIt.I.registerSingleton<LocalNumberSymbols>(localNumberSymbols);
  }
  if (!GetIt.I.isRegistered<shared_theme.ThemeManager>()) {
    GetIt.I.registerSingleton<shared_theme.ThemeManager>(shared_theme.ThemeManager());
  }

  //   runApp(const CalculatorApp());

  runApp(address() as Widget);

  // String address = "2001:db8:0:0:1234::/64";
  // print(address);
  //
  // AddressIPV6 addressIPV6 = AddressIPV6(address);
  // print(addressIPV6.address6List);
  // print(addressIPV6.numberOfAddresses);
  //
  // runApp(AddressIPV6(address) as Widget);
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
        Locale resolvedLocale = const Locale('en', 'US');

        if (locale != null) {
          for (final supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              resolvedLocale = supportedLocale;
              break;
            }
          }
        }

        if (GetIt.I.isRegistered<LocalNumberSymbols>()) {
          GetIt.I<LocalNumberSymbols>().updateFromLocale(resolvedLocale.toLanguageTag());
        }
        return resolvedLocale;
      },

      // Define routes
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
    );
  }
}
