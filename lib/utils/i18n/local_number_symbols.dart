// lib/utils/i18n/local_number_symbols.dart

import 'package:intl/intl.dart';
import 'package:intl/number_symbols.dart';
import 'package:intl/number_symbols_data.dart';

class LocalNumberSymbols {
  final String locale;
  final String decimalSep;
  final String thousandsSep;
  final String currencySymbol;

  LocalNumberSymbols._({
    required this.locale,
    required this.decimalSep,
    required this.thousandsSep,
    required this.currencySymbol,
  });

  String get languageCode => locale.split('_').first; // e.g. "fr" from "fr_FR"
  String get countryCode => locale.split('_').last; // e.g. "FR" from "fr_FR"

  factory LocalNumberSymbols() {
    final String locale = Intl.getCurrentLocale();
    final NumberSymbols symbols = numberFormatSymbols[locale] ?? numberFormatSymbols['en_US']!;

    return LocalNumberSymbols._(
      locale: symbols.NAME,
      decimalSep: symbols.DECIMAL_SEP,
      thousandsSep: symbols.GROUP_SEP,
      currencySymbol: symbols.CURRENCY_PATTERN,
    );
  }
}
