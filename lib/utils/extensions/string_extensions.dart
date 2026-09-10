// lib/utils/extensions/string_extensions.dart

import 'package:calculators/utils/extensions/decimal_extensions.dart';
import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:calculators/utils/my_exception.dart';
import 'package:calculators/utils/number_format_utils.dart';
import 'package:decimal/decimal.dart';
import 'package:get_it/get_it.dart';
import 'package:rational/rational.dart';
import 'double_extensions.dart';

LocalNumberSymbols _safeLocalNumberSymbols() {
  try {
    if (GetIt.I.isRegistered<LocalNumberSymbols>()) {
      return GetIt.I<LocalNumberSymbols>();
    }
  } catch (_) {
    // Fall back to default locale when the app initialization is not complete yet.
  }

  return LocalNumberSymbols();
}

/// Utility extensions for the String class
extension StringExtensions on String {
  /// Counts the number of occurrences of a pattern in the string
  ///
  /// Example:
  /// ```dart
  /// "hello world hello".count("hello"); // 2
  /// ```
  int count(String pattern, {bool caseSensitive = true}) {
    if (pattern.isEmpty) return 0;

    if (caseSensitive) {
      return split(pattern).length - 1;
    } else {
      final regex = RegExp(RegExp.escape(pattern), caseSensitive: false);
      return regex.allMatches(this).length;
    }
  }

  /// Checks if the string is a valid IPv6 address
  bool get isValidIPv6 {
    // RFC-style IPv6 forms (full + compressed), without IPv4-mapped and zone id.
    final regex = RegExp(
      r'^(?:'
      r'(?:[0-9A-F]{1,4}:){7}[0-9A-F]{1,4}|'
      r'(?:[0-9A-F]{1,4}:){1,7}:|'
      r'(?:[0-9A-F]{1,4}:){1,6}:[0-9A-F]{1,4}|'
      r'(?:[0-9A-F]{1,4}:){1,5}(?::[0-9A-F]{1,4}){1,2}|'
      r'(?:[0-9A-F]{1,4}:){1,4}(?::[0-9A-F]{1,4}){1,3}|'
      r'(?:[0-9A-F]{1,4}:){1,3}(?::[0-9A-F]{1,4}){1,4}|'
      r'(?:[0-9A-F]{1,4}:){1,2}(?::[0-9A-F]{1,4}){1,5}|'
      r'[0-9A-F]{1,4}:(?::[0-9A-F]{1,4}){1,6}|'
      r':(?::[0-9A-F]{1,4}){1,7}|'
      r'::'
      r')$',
    );
    return regex.hasMatch(trim().toUpperCase());
  }

  /// Checks if the string is a valid IPv6 address in CIDR format
  bool get isValidIPv6CIDR {
    // RFC-style IPv6 forms (full + compressed), without IPv4-mapped and zone id.
    final regex = RegExp(
      r'^(?:'
      r'(?:[0-9A-F]{1,4}:){7}[0-9A-F]{1,4}/(12[0-8]|1[0-1][0-9]|[1-9]?[0-9])|'
      r'(?:[0-9A-F]{1,4}:){1,7}:/(12[0-8]|1[0-1][0-9]|[1-9]?[0-9])|'
      r'(?:[0-9A-F]{1,4}:){1,6}:[0-9A-F]{1,4}/(12[0-8]|1[0-1][0-9]|[1-9]?[0-9])|'
      r'(?:[0-9A-F]{1,4}:){1,5}(?::[0-9A-F]{1,4}){1,2}/(12[0-8]|1[0-1][0-9]|[1-9]?[0-9])|'
      r'(?:[0-9A-F]{1,4}:){1,4}(?::[0-9A-F]{1,4}){1,3}/(12[0-8]|1[0-1][0-9]|[1-9]?[0-9])|'
      r'(?:[0-9A-F]{1,4}:){1,3}(?::[0-9A-F]{1,4}){1,4}/(12[0-8]|1[0-1][0-9]|[1-9]?[0-9])|'
      r'(?:[0-9A-F]{1,4}:){1,2}(?::[0-9A-F]{1,4}){1,5}/(12[0-8]|1[0-1][0-9]|[1-9]?[0-9])|'
      r'[0-9A-F]{1,4}:(?::[0-9A-F]{1,4}){1,6}/(12[0-8]|1[0-1][0-9]|[1-9]?[0-9])|'
      r':(?::[0-9A-F]{1,4}){1,7}/(12[0-8]|1[0-1][0-9]|[1-9]?[0-9])|'
      r'::/(12[0-8]|1[0-1][0-9]|[1-9]?[0-9])'
      r')$',
    );
    return regex.hasMatch(trim().toUpperCase());
  }

  /// Checks if the string is a valid IPv4 address
  bool get isValidIPv4 {
    final regex = RegExp(
      r'^((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$',
    );
    return regex.hasMatch(trim());
  }

  /// Checks is the string is a valid IPv4 address in CIDR format
  bool get isValidIPv4CIDR {
    final regex = RegExp(
      r'^((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])/(3[0-2]|[12]?[0-9])$',
    );
    return regex.hasMatch(trim());
  }

  /// Checks if the address is an obsolete IPv4-mapped to IPV6 address
  bool get isObsoleteIPV4Mapped {
    String s = trim();
    if (!s.startsWith('::')) return false;
    s = s.substring(2);
    return s.isValidIPv4;
  }

  /// Checks if the address is a valid IPv4-mapped address
  /// Obsolete format (::IPv4) => false
  bool get isValidMappedIPv4 {
    String s = trim().toUpperCase();
    if (!s.contains('FFFF:')) return false;

    String firstPart = "${s.split('FFFF:')[0]}FFFF";
    String secondPart = s.split('FFFF:')[1];

    final regexFirst = RegExp(
      r'^(?:'
      r'::FFF|'
      r'(?:[0]{4}:){5}FFFF|'
      r')$',
    );
    if (!regexFirst.hasMatch(firstPart)) return false;
    return secondPart.isValidIPv4 ? true : false;
  }

  /// Checks if the string is a valid MAC address
  /// Valid formats : classic (Windows and Linux), Cisco, raw (no separators)
  bool get isValidMACAddress {
    final regex = RegExp(
      r'^(?:[0-9A-Fa-f]{2}([:-])(?:[0-9A-Fa-f]{2}\1){4}[0-9A-Fa-f]{2}|(?:[0-9A-Fa-f]{4}\.){2}[0-9A-Fa-f]{4}|[0-9A-Fa-f]{12})$',
    );
    return regex.hasMatch(trim());
  }

  /// Capitalizes the first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${length > 1 ? substring(1) : ""}';
  }

  /// Truncates the string if it exceeds maxLength AND it represents a double
  /// Beware ! works fine only with unformatted numbers
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    if (isADouble) {
      return '${substring(0, maxLength)}$suffix';
    }
    return this;
  }

  /// Simplifies a String ended with ".0" : for instance 3.0 becomes 3.
  /// Beware ! works fine only with unformatted numbers
  String get cleanPointZero {
    if (this == ".0") return "0";
    if (isNotEmpty && length > 2) {
      if (substring(length - 2) == ".0") return substring(0, length - 2);
    }
    return this;
  }

  /// Determines if a String represents a number
  /// Beware ! works fine only with unformatted numbers
  bool get isANumber => !(double.tryParse(this) == null);

  /// Determines if a string represents a double (.0 excluded)
  /// Beware ! works fine only with unformatted numbers
  bool get isADouble {
    String temp = trim().cleanPointZero;
    return isANumber && temp.contains(".");
  }

  /// Determines if a String does NOT represents a number
  /// Beware ! works fine only with unformatted numbers
  bool get isNotANumber => !isANumber;

  /// Determines if the string represents a number or a single expression with a single operator ( for instance 3² or √(1+2) ).
  bool get hasAGlobalOperator {
    String operation = trim();
    if (!operation.startsWith("√") && !operation.endsWith("²")) {
      return false;
    }
    if (operation.startsWith("√")) operation = operation.substring(1);
    if (operation.endsWith("²")) operation = operation.substring(0, operation.length - 1);
    operation = operation.trim();
    if (operation.isANumber) {
      return true;
    }
    if (!operation.startsWith("(")) return false;

    int count = 0;
    for (int i = 0; i < operation.length; ++i) {
      if (operation[i] == "(") count++;
      if (operation[i] == ")") {
        count--;
        if (count == 0) {
          if (i == (operation.length - 1)) {
            return true;
          } else {
            return false;
          }
        }
      }
    }
    return false;
  }

  /// Determines if the string represents a squared number or a squared expression as a whole.
  bool get isAGlobalSquared {
    return trim().endsWith("²") && hasAGlobalOperator;
  }

  /// Determines if the string represents a number inside a square root or an entire expression inside a square root.
  bool get isAGlobalSQR {
    return trim().startsWith("√") && hasAGlobalOperator;
  }

  /// Replaces the last occurrence of a pattern in a string
  /// or suppress the last occurrence if only one parameter is given
  String replaceLast(String from, [String to = ""]) {
    if (isEmpty || length < from.length) return this;
    String resultTemp = "";
    for (int i = length - from.length; i > -1; --i) {
      if (substring(i, i + from.length) == from) {
        resultTemp = substring(0, i) + to;
        resultTemp += (i + from.length >= length - 1) ? "" : substring(i + from.length);
        return resultTemp;
      }
    }
    return this;
  }

  /// Returns the last character of a string
  String get lastCharacter {
    return isEmpty ? "" : this[length - 1];
  }

  /// Removes last character
  String get removeLastChar {
    return isEmpty ? "" : substring(0, length - 1);
  }

  /// Cleans a formatted string (e.g: "1 000,50") to make it a standard mathematical string (e.g: "1000.50")
  /// Also strips a leading approximation marker (`≈`) used only for display.
  String get toCleanMathString {
    final symbols = _safeLocalNumberSymbols();

    String s = trimLeft();
    if (s.startsWith('≈')) {
      s = s.substring(1).trimLeft();
    }

    // 1. Remove thousand separators (spaces)
    s = s.replaceAll(symbols.thousandsSep, '');
    // Beware of non-breaking spaces sometimes used by Intl
    s = s.replaceAll('\u00A0', '').replaceAll(' ', '');

    // 2. Replace comma with dot
    s = s.replaceAll(symbols.decimalSep, '.');

    return s;
  }

  /// Determines if the string contains an operator (+, -, *, ÷)
  bool get containsOperator {
    return RegExp(r'[+\-*÷x]').hasMatch(this);
  }

  /// Local function to format a raw number (e.g: "1000.5" -> "1 000,5")
  String get format {
    try {
      if (isNotANumber) return this;

      final clean = toCleanMathString;
      final sign = clean.startsWith('-') ? '-' : '';
      final unsigned = sign.isEmpty ? clean : clean.substring(1);

      // Extremely large integer values: format from digit string only.
      // Decimal.toStringAsExponential is too slow on web for 2^1000-sized values.
      if (!unsigned.contains('.') &&
          !unsigned.toUpperCase().contains('E') &&
          unsigned.length > 18) {
        final sci = formatIntegerDigitsSci(
          unsigned,
          negative: sign == '-',
        );
        return _localizeMaybeApproximateScientific(sci);
      }

      final value = Rational.parse(clean).toDecimal(scaleOnInfinitePrecision: 10);
      return DecimalFormatting(value).toSciPreciseFormattedString();
    } catch (e) {
      return this;
    }
  }

  String _localizeMaybeApproximateScientific(String value) {
    final approx = value.startsWith('≈ ');
    final sci = approx ? value.substring(2) : value;
    final localized = DecimalFormatting.localizeCleanScientific(sci);
    return approx ? '≈ $localized' : localized;
  }

  /// Rounds a String representing a decimal number
  /// Beware ! Not for localized numbers !
  /// Returns a clean math String number
  String roundString({int limit = 10}) {
    if (double.tryParse(this) == null) return this;
    // Already compact scientific form: do not truncate mantissa/exponent.
    if (toUpperCase().contains('E')) return this;
    if (!contains('.')) return this;

    String s = removeTrailingZeros(isCleanMathString: true);

    final List<String> l = s.split('.');
    if (l[1].length <= limit) return s;

    if (limit == 0) {
      if (int.parse(l[1][0]) >= 5) {
        if (s.startsWith("-")) {
          return "≈ ${(BigInt.parse(l[0]) - BigInt.one).toString()}";
        } else {
          return "≈ ${(BigInt.parse(l[0]) + BigInt.one).toString()}";
        }
      }
      return "≈ ${l[0]}";
    }

    if (int.parse(l[1][limit]) >= 5) {
      return "≈ ${l[0]}.${l[1].substring(0, limit - 1)}${(int.parse(l[1].substring(limit - 1, limit)) + 1).toString()}";
    } else {
      return "≈ ${l[0]}.${l[1].substring(0, limit)}";
    }
  }

  /// Function to format a raw number (e.g: "1000.5" -> "1 000,5")
  /// and rounds it
  String formatRound({int limit = 10}) {
    // Capture ≈ before toCleanMathString strips it for math parsing.
    final hadApprox = trimLeft().startsWith('≈');
    String s = toCleanMathString;
    // Scientific results stay compact; localize via Decimal + LocalNumberSymbols.
    if (s.toUpperCase().contains('E')) {
      final localized = DecimalFormatting.localizeCleanScientific(s);
      return hadApprox ? '≈ $localized' : localized;
    }
    s = s.roundString(limit: limit);
    if (s.startsWith('≈ ') || hadApprox) {
      final rounded = (s.startsWith('≈ ') ? s.substring(2) : s).format;
      return '≈ $rounded';
    }
    return s.format;
  }

  /// Inserts one or several characters each n character in a string
  /// except end of string
  /// Warning : the string length must be a multiple of n and
  /// have dans 2 * n characters
  /// "123456".insert(2,":") -> 12:34:56
  String insertRep(int n, String s) {
    if (length < 2 * n) {
      throw MyException("Error : string must have more than 2 * n elements", this);
    }
    if (length % n != 0) {
      throw MyException("Error : string must be a multiple of pattern", this);
    }
    String s2 = substring(0, n);
    for (int j = n; j < length; j += n) {
      s2 += "$s${substring(j, j + n)}";
    }
    return s2;
  }

  /// Insert a String inside another one at the position given
  String insert(int pos, String s) {
    throwIf(
      pos > length,
      MyException("Error : the position of the insertion is not inside the string", pos.toString()),
    );
    return substring(0, pos) + s + substring(pos);
  }

  /// Localize input along key tap
  String realTimeL10n(String char, String decimalSep) {
    // Prevents from entering too long inputs
    if (length > 16) return this;

    // Takes into account special behavior to have with "0" numbers
    if (this == '0') return char == decimalSep ? '0$char' : char;

    // Avoids double decimal separators else returns non formatted number + decimal separator
    if (char == decimalSep) return contains(decimalSep) ? this : this + char;

    // Applies localized format only if the new character is added to a non-decimal number
    return contains(decimalSep) ? this + char : (toCleanMathString + char).format;
  }

  /// Removes non significant 0 in decimal numbers while preserving integer zeros.
  /// Warning : returns a toCleanMathString number
  String removeTrailingZeros({bool isCleanMathString = false}) {
    if (isEmpty) return this;
    String n = isCleanMathString ? this : toCleanMathString;

    final int sciIndex = n.toUpperCase().indexOf('E');
    String mantissa = n;
    String exponent = '';
    if (sciIndex != -1) {
      mantissa = n.substring(0, sciIndex);
      exponent = n.substring(sciIndex);
    }

    if (!mantissa.contains('.')) return n;

    final int dotIndex = mantissa.indexOf('.');
    final String integerPart = mantissa.substring(0, dotIndex);
    String fractionalPart = mantissa.substring(dotIndex + 1);

    while (fractionalPart.isNotEmpty && fractionalPart.endsWith('0')) {
      fractionalPart = fractionalPart.substring(0, fractionalPart.length - 1);
    }

    if (fractionalPart.isEmpty) {
      return '$integerPart$exponent';
    }

    return '$integerPart.$fractionalPart$exponent';
  }
}
