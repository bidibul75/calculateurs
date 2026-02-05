// lib/utils/extensions/double_extensions.dart

/// Extension methods for [double] to provide common numerical operations.
/// Includes rounding, currency formatting, and percentage conversion.

extension DoubleExtensions on double {
  /// Rounds the double to [decimals] decimal places.
  ///
  /// Example:
  /// ```dart
  /// 123.4567.roundTo(2); // Returns 123.46
  /// ```
  ///
  /// Throws [ArgumentError] if [decimals] is negative.
  double roundTo(int decimals) {
    if (decimals < 0) {
      throw ArgumentError('Decimals must be a non-negative integer.');
    }
    final factor = (10.0).power(decimals);
    return (this * factor).round() / factor;
  }

  /// Formats the double as a currency string with the given [symbol].
  ///
  /// Example:
  /// ```dart
  /// 123.456.toCurrency(symbol: '\ $ '); // Returns "123.46 \ $ "
  /// ```
  String toCurrency({String symbol = '€'}) {
    if (symbol == "CHF" || symbol == "JPY") return '${((roundForCurrency(symbol)).truncate()).toString()} $symbol';
    return '${roundForCurrency(symbol).toString()} $symbol';
  }

  /// Converts the double to a percentage string.
  ///
  /// Example:
  /// ```dart
  /// 0.05.toPercentage(); // Returns "5%"
  /// ```
  String toPercentage() {
    return '${(this * 100).roundTo(2)}%';
  }

  /// Rounds the double based on the specified [strategy].
  ///
  /// Supported strategies:
  /// - [RoundingStrategy.bankers]: Rounds to the nearest even number (default).
  /// - [RoundingStrategy.floor]: Rounds down.
  /// - [RoundingStrategy.ceil]: Rounds up.
  ///
  /// Example:
  /// ```dart
  /// 2.5.roundTo(0, strategy: RoundingStrategy.bankers); // Returns 2.0
  /// ```
  double roundToWithStrategy(int decimals, {RoundingStrategy strategy = RoundingStrategy.bankers}) {
    if (decimals < 0) {
      throw ArgumentError('Decimals must be a non-negative integer.');
    }
    final double factor = (10.0).power(decimals);
    final scaled = this * factor;

    switch (strategy) {
      case RoundingStrategy.bankers:
        return scaled.round() / factor;
      case RoundingStrategy.floor:
        return scaled.floor() / factor;
      case RoundingStrategy.ceil:
        return scaled.ceil() / factor;
    }
  }

  /// Rounds the double for a specific currency, accounting for locale-specific rules.
  ///
  /// Example:
  /// ```dart
  /// 123.456.roundForCurrency('CHF'); // Returns 123.0 (Swiss Franc has no cents)
  /// ```
  double roundForCurrency(String currencyCode) {
    switch (currencyCode) {
      case 'CHF': // Swiss Franc (no cents)
      case 'JPY': // Japanese Yen (no decimals)
        return roundTo(0);
      default: // Default: 2 decimal places (EUR, USD, etc.)
        return roundTo(2);
    }
  }

  double power(int decimals) {
    bool decimalPositive = true;
    if (decimals == 0) return 1.0;
    if (decimals.isNegative) {
      if (this == 0) {
        throw "Error : divide by 0";
      }
      decimals = -decimals;
      decimalPositive = false;
    }

    double result = this;
    for (int i = 1; i < decimals; ++i) {
      result *= this;
    }
    return decimalPositive ? result : 1 / result;
  }

  bool isInteger() {
    return !isNaN && !isInfinite && this == toInt();
  }
}

/// Rounding strategies for numerical operations.
enum RoundingStrategy {
  bankers, // Rounds to the nearest even number (default).
  floor, // Rounds down.
  ceil, // Rounds up.
}
