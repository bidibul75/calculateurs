// lib/utils/extensions/decimal_extensions.dart

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
}
