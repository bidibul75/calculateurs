// lib/utils/extensions/decimal_extensions.dart

import 'package:calculators/utils/extensions/extensions.dart';
import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:decimal/decimal.dart';
import 'package:get_it/get_it.dart';

extension DecimalFormatting on Decimal {
  /// Converts a number into a local formatted number
  String get toPreciseFormattedString {
    // 1. Get the locale (e.g., "fr_FR" or "en_US")
    final symbols = GetIt.I<LocalNumberSymbols>();

    // 2. Convert the Decimal to a raw String (e.g., "1234.5000")
    String val = toString();

    // 3. Remove ".0" if it's an integer (e.g., "10.0" -> "10")
    if (val.contains('.') && double.tryParse(val) != null) {
      // Check if the fractional part is only zeros
      // Decimal handles this well, but a safeguard doesn't hurt
      if (RegExp(r'\.0+$').hasMatch(val)) {
        val = val.split('.')[0];
      }
    }

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
  String formatResult(Decimal value, {int n = 10}) {
    if (value == Decimal.zero) return '0';

    final bool negative = value.isNegative;
    final Decimal absVal = value.abs();

    final String sci = absVal.toStringAsExponential(n - 1);

    final int eIndex = sci.indexOf('e');
    final String mantissa = sci.substring(0, eIndex);   // "1.23456789"
    final String expPart = sci.substring(eIndex + 1);   // "+10" ou "-5"
    final int exponent = int.parse(expPart);

    // If too many numbers on the left or too many zeros on yhe right
    final useScientific = exponent >= n || exponent <= -n;

    final String result = useScientific
        ? '${mantissa.removeTrailingZeros(isCleanMathString: true)}E$expPart'
        : absVal.toStringAsPrecision(n).removeTrailingZeros(isCleanMathString: true);

    return negative ? '-$result' : result;
  }

  /// Converts scientific notation AND non-scientific notation numbers into l10n numbers
  String toSciPreciseFormattedString (Decimal value, {int n = 10}) {
    String sciValue = formatResult(value, n: n);
    if (!sciValue.contains('E')) return Decimal.parse(sciValue).toPreciseFormattedString;
    Decimal part1 = Decimal.parse(sciValue.split('E')[0]);
    Decimal part2 = Decimal.parse(sciValue.split('E')[1]);
    bool posExp = sciValue.split('E')[1].trim().startsWith('+');
    // Concatenates localized mantissa and exponent with eventual + sign
    return '${part1.toPreciseFormattedString}E${posExp ? '+' : ''}${part2.toPreciseFormattedString}';
  }

}
