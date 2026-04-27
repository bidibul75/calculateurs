class CalculatorHistoryEntry {
  final String displayText;
  final String resultDisplay;
  final String resultClean;
  // Canonical Rational string (for example "1/3") when exact value is known.
  final String? resultRational;

  const CalculatorHistoryEntry({
    required this.displayText,
    required this.resultDisplay,
    required this.resultClean,
    this.resultRational,
  });
}

