// lib/utils/extensions/decimal_extensions.dart

import 'package:calculators/utils/extensions/extensions.dart';
import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:calculators/utils/number_format_utils.dart';
import 'package:decimal/decimal.dart';
import 'package:get_it/get_it.dart';

LocalNumberSymbols _safeLocalNumberSymbols() {
  try {
    if (GetIt.I.isRegistered<LocalNumberSymbols>()) {
      return GetIt.I<LocalNumberSymbols>();
    }
  } catch (_) {
    // Fall back to default locale when the app initialisation is not complete yet.
  }

  return LocalNumberSymbols();
}

extension DecimalFormatting on Decimal {
  /// Converts a number into a local formatted number
  String get toPreciseFormattedString {
    // 1. Get the locale (e.g., "fr_FR" or "en_US")
    final symbols = _safeLocalNumberSymbols();

    // 2. Convert the Decimal to a raw String (e.g., "1234.5000")
    String val = toString();

    // 3. Remove ".0" if it's an integer (e.g., "10.0" -> "10")
    // Decimal handles this well, but a safeguard doesn't hurt
    val = val.removeTrailingZeros(isCleanMathString: true);

    // 4. Split integer and decimal parts
    List<String> parts = val.split('.');
    String integerPart = parts[0];
    String? decimalPart = parts.length > 1 ? parts[1] : null;

    // 5. Apply the thousands separator to the integer part
    // Magic regex to insert separators every 3 digits
    final regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    integerPart = integerPart.replaceAllMapped(regex, (Match m) {
      return '${m[1]}${symbols.thousandsSep}';
    });

    // 6. Recombine with the locale decimal separator (comma or dot)
    if (decimalPart != null) {
      return '$integerPart${symbols.decimalSep}$decimalPart';
    }

    return integerPart;
  }

  /// Tests if a Decimal is negative
  /// Returns boolean
  bool get isNegative => this < Decimal.zero;

  /// Exact round at [n] significative figures.
  /// Turns at 1.23456789E+10 only of the numbers "overflows" n figures.
  String formatResult({int n = 10}) {
    if (this == Decimal.zero) return '0';

    final bool negative = isNegative;
    final Decimal absVal = abs();

    final String sci = absVal.toStringAsExponential(n - 1);
    final int eIndex = sci.indexOf('e');
    final String mantissa = sci.substring(0, eIndex); // "1.23456789"
    final String expPart = sci.substring(eIndex + 1); // "+10" ou "-5"
    final int exponent = int.parse(expPart);

    // If too many numbers on the left or too many zeros on yhe right
    final useScientific = exponent >= n || exponent <= -n;

    final String result = useScientific
        ? '${mantissa.removeTrailingZeros(isCleanMathString: true)}E$expPart'
        : absVal.toStringAsPrecision(n).removeTrailingZeros(isCleanMathString: true);

    return negative ? '-$result' : result;
  }

  /// Localizes a clean scientific math string via LocalNumberSymbols
  /// (mantissa through [toPreciseFormattedString]).
  static String localizeCleanScientific(String sciValue) {
    final normalized = sciValue.replaceAll('e', 'E');
    final parts = normalized.split('E');
    if (parts.length != 2) {
      return Decimal.parse(normalized).toPreciseFormattedString;
    }
    final part1 = Decimal.parse(parts[0]);
    final part2 = Decimal.parse(parts[1]);
    final posExp = parts[1].trim().startsWith('+');
    return '${part1.toPreciseFormattedString}E${posExp ? '+' : ''}${part2.toString().trim()}';
  }

  /// Converts scientific notation AND non-scientific notation numbers into l10n numbers
  String toSciPreciseFormattedString({int n = 15}) {
    final raw = toString();
    final negative = raw.startsWith('-');
    final absRaw = negative ? raw.substring(1) : raw;
    final hasDecimal = absRaw.contains('.');

    // Avoid Decimal.toStringAsExponential only for huge integers (slow on web).
    // Moderate sizes still use formatResult for trailing-zero trimming.
    if (!hasDecimal && absRaw.length > 40) {
      final sci = formatIntegerDigitsSci(
        absRaw,
        significantDigits: n,
        negative: negative,
      );
      final approx = sci.startsWith('≈ ');
      final cleanSci = approx ? sci.substring(2) : sci;
      final localized = DecimalFormatting.localizeCleanScientific(cleanSci);
      return approx ? '≈ $localized' : localized;
    }

    String sciValue = formatResult(n: n);
    if (!sciValue.contains('E')) return Decimal.parse(sciValue).toPreciseFormattedString;
    return DecimalFormatting.localizeCleanScientific(sciValue);
  }
}
