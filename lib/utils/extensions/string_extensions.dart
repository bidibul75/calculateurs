// lib/utils/extensions/string_extensions.dart

import 'package:calculators/utils/extensions/decimal_extensions.dart';
import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:decimal/decimal.dart';
import 'package:get_it/get_it.dart';
import 'package:rational/rational.dart';

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
      r'(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|'
      r'(?:[0-9a-fA-F]{1,4}:){1,7}:|'
      r'(?:[0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|'
      r'(?:[0-9a-fA-F]{1,4}:){1,5}(?::[0-9a-fA-F]{1,4}){1,2}|'
      r'(?:[0-9a-fA-F]{1,4}:){1,4}(?::[0-9a-fA-F]{1,4}){1,3}|'
      r'(?:[0-9a-fA-F]{1,4}:){1,3}(?::[0-9a-fA-F]{1,4}){1,4}|'
      r'(?:[0-9a-fA-F]{1,4}:){1,2}(?::[0-9a-fA-F]{1,4}){1,5}|'
      r'[0-9a-fA-F]{1,4}:(?::[0-9a-fA-F]{1,4}){1,6}|'
      r':(?::[0-9a-fA-F]{1,4}){1,7}|'
      r'::'
      r')$',
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
  bool get isANumber {
    if (double.tryParse(this) == null) return false;
    return true;
  }

  /// Determines if a string represents a double (.0 excluded)
  /// Beware ! works fine only with unformatted numbers
  bool get isADouble {
    String temp = trim().cleanPointZero;
    if (isANumber && temp.contains(".")) return true;
    return false;
  }

  /// Determines if a String does NOT represents a number
  /// Beware ! works fine only with unformatted numbers
  bool get isNotANumber {
    if (isANumber) return false;
    return true;
  }

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
    if (trim().endsWith("²") && hasAGlobalOperator) {
      return true;
    }
    return false;
  }

  /// Determines if the string represents a number inside a square root or an entire expression inside a square root.
  bool get isAGlobalSQR {
    if (trim().startsWith("√") && hasAGlobalOperator) {
      return true;
    }
    return false;
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

  /// Cleans a formatted string (e.g: "1 000,50") to make it a standard mathematical string (e.g: "1000.50")
  String get toCleanMathString {
    final symbols = GetIt.I<LocalNumberSymbols>();

    // 1. Remove thousand separators (spaces)
    String s = replaceAll(symbols.thousandsSep, '');
    // Beware of non-breaking spaces sometimes used by Intl
    s = s.replaceAll('\u00A0', '').replaceAll(' ', '');

    // 2. Replace comma with dot
    s = s.replaceAll(symbols.decimalSep, '.');

    return s;
  }

  /// Determines if the string contains an operator (+, -, *, ÷)
  bool get containsOperator {
    return RegExp(r'[+\-*÷]').hasMatch(this);
  }

  /// Local function to format a raw number (e.g: "1000.5" -> "1 000,5")
  String get format {
    try {
      if (isNotANumber) return this;
      final value = Rational.parse(this).toDecimal(scaleOnInfinitePrecision: 10);
      return DecimalFormatting(value).toPreciseFormattedString;
    } catch (e) {
      return this;
    }
  }
}
