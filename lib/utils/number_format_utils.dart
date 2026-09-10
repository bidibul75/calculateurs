// lib/utils/number_format_utils.dart

/// Fast scientific notation from a plain integer digit string.
/// Avoids Decimal.toStringAsExponential which is very slow on huge values (web).
/// Returns a clean math string (dot decimal separator), not locale-formatted.
String formatIntegerDigitsSci(
  String digits, {
  int significantDigits = 15,
  bool negative = false,
}) {
  var unsigned = digits.startsWith('-') ? digits.substring(1) : digits;
  if (unsigned.isEmpty) return '0';
  // Strip leading zeros without losing a lone zero.
  unsigned = unsigned.replaceFirst(RegExp(r'^0+(?=.)'), '');
  if (unsigned == '0') return '0';

  final sign = negative || digits.startsWith('-') ? '-' : '';
  if (unsigned.length <= significantDigits) {
    return '$sign$unsigned';
  }

  // Round half-up using the digit after the kept mantissa.
  var keep = unsigned.substring(0, significantDigits);
  final nextDigit = int.parse(unsigned[significantDigits]);
  if (nextDigit >= 5) {
    final rounded = BigInt.parse(keep) + BigInt.one;
    keep = rounded.toString();
    // 999... -> 1000... can grow by one digit; fold into the exponent.
    if (keep.length > significantDigits) {
      keep = keep.substring(0, significantDigits);
      final exponent = unsigned.length; // length-1 + 1 from carry
      final mantissa = keep.length == 1 ? keep : '${keep[0]}.${keep.substring(1)}';
      return '$sign${mantissa}E+$exponent';
    }
  }

  final exponent = unsigned.length - 1;
  final mantissa = keep.length == 1 ? keep : '${keep[0]}.${keep.substring(1)}';
  return '$sign${mantissa}E+$exponent';
  }
