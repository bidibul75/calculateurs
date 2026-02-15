// lib/utils/extensions/string_extensions.dart

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
    final regex = RegExp(
      r'^(([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|::([0-9a-fA-F]{1,4}:){0,6}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4})$',
    );
    return regex.hasMatch(this);
  }

  /// Capitalizes the first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Truncates the string if it exceeds maxLength
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }

  /// Simplifies a String ended with ".0" : for instance 3.0 becomes 3.
  String cleanPointZero() {
    if (isNotEmpty && length > 2) {
      if (substring(length - 2) == ".0") return substring(0, length - 2);
    }
    return this;
  }

  /// Determines if a String represents a number
  bool isANumber() {
    if (double.tryParse(this) == null) return false;
    return true;
  }

  /// Determines if a String does NOT represents a number
  bool isNotANumber() {
    if (isANumber()) return false;
    return true;
  }

  /// Determines if the string represents a number or a single expression with a single operator ( for instance 3² or √(1+2) ).
  bool hasAGlobalOperator() {
    String operation = trim();
    if (!operation.startsWith("√") && !operation.endsWith("²")) {
      return false;
    }
    if (operation.startsWith("√")) operation = operation.substring(1);
    if (operation.endsWith("²")) operation = operation.substring(0, operation.length - 1);
    operation = operation.trim();
    if (operation.isANumber()) {
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
  bool isAGlobalSquared() {
    if (trim().endsWith("²") && hasAGlobalOperator()) {
      return true;
    }
    return false;
  }

  /// Determines if the string represents a number inside a square root or an entire expression inside a square root.
  bool isAGlobalSQR() {
    if (trim().startsWith("√") && hasAGlobalOperator()) {
      return true;
    }
    return false;
  }

  /// Replaces the last occurrence of a pattern in a string.
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
}
