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
        r'^(([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|::([0-9a-fA-F]{1,4}:){0,6}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4})$'
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
}