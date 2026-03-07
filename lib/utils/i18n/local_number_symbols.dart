// lib/utils/i18n/local_number_symbols.dart

import 'package:intl/intl.dart';
import 'package:intl/number_symbols.dart';
import 'package:intl/number_symbols_data.dart';

class LocalNumberSymbols {
  static const String _defaultLocale = 'en_US';

  String _locale = _defaultLocale;
  String _decimalSep = '.';
  String _thousandsSep = ',';
  String _currencySymbol = r'$';

  String get locale => _locale;
  String get decimalSep => _decimalSep;
  String get thousandsSep => _thousandsSep;
  String get currencySymbol => _currencySymbol;

  LocalNumberSymbols._();

  String get languageCode => locale.split('_').first; // e.g. "fr" from "fr_FR"
  String get countryCode => locale.contains('_') ? locale.split('_').last : ''; // e.g. "FR" from "fr_FR"

  factory LocalNumberSymbols() {
    final instance = LocalNumberSymbols._();
    instance.updateFromLocale(Intl.getCurrentLocale());
    return instance;
  }

  void updateFromLocale(String? rawLocale) {
    final String normalized = _normalizeLocale(rawLocale);
    final String resolvedLocale = _resolveLocale(normalized);
    final NumberSymbols symbols = numberFormatSymbols[resolvedLocale] ?? numberFormatSymbols[_defaultLocale]!;

    _locale = symbols.NAME;
    _decimalSep = symbols.DECIMAL_SEP;
    _thousandsSep = symbols.GROUP_SEP;
    _currencySymbol = symbols.CURRENCY_PATTERN;

    // Keep intl aligned with the effective locale used by number symbols.
    Intl.defaultLocale = _locale;
  }

  String _normalizeLocale(String? rawLocale) {
    if (rawLocale == null || rawLocale.trim().isEmpty) return _defaultLocale;

    final String normalized = rawLocale.replaceAll('-', '_').trim();
    final List<String> parts = normalized.split('_');

    final String language = parts.first.toLowerCase();
    if (parts.length == 1 || parts[1].isEmpty) return language;

    final String country = parts[1].toUpperCase();
    return '${language}_$country';
  }

  String _resolveLocale(String normalizedLocale) {
    if (numberFormatSymbols.containsKey(normalizedLocale)) return normalizedLocale;

    final String language = normalizedLocale.split('_').first;

    if (numberFormatSymbols.containsKey(language)) return language;

    for (final String availableLocale in numberFormatSymbols.keys) {
      if (availableLocale.startsWith('${language}_')) return availableLocale;
    }

    return _defaultLocale;
  }
}
