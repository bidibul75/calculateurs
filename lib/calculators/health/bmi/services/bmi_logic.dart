// lib/calculators/health/bmi/services/bmi_logic.dart

import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:decimal/decimal.dart';
import 'package:get_it/get_it.dart';

/// BMI calculation logic
class BmiLogic {
  static const String errorToken = '__bmi_error__';

  static String _normalizeInput(String value, String decimalSep) {
    return value.replaceAll(decimalSep, '.').trim();
  }

  /// Calculate BMI from height (in meters) and weight (in kg)
  /// BMI = weight / (height²)
  static String calculateBmi(String heightStr, String weightStr) {
    try {
      final symbols = GetIt.I<LocalNumberSymbols>();
      final String normalizedHeight = _normalizeInput(heightStr, symbols.decimalSep);
      final String normalizedWeight = _normalizeInput(weightStr, symbols.decimalSep);

      final height = Decimal.parse(normalizedHeight);
      final weight = Decimal.parse(normalizedWeight);

      if (height <= Decimal.zero || weight <= Decimal.zero) {
        return errorToken;
      }

      final bmi = weight / (height * height);
      final String formatted = bmi.toDouble().toStringAsFixed(2);
      return formatted.replaceAll('.', symbols.decimalSep);
    } catch (e) {
      return errorToken;
    }
  }

  /// Get BMI category and description
  static String getBmiCategory(String bmiStr) {
    try {
      final symbols = GetIt.I<LocalNumberSymbols>();
      final normalized = _normalizeInput(bmiStr, symbols.decimalSep);
      final bmi = double.parse(normalized);

      if (bmi < 18.5) {
        return 'underweight';
      } else if (bmi < 25) {
        return 'normal';
      } else if (bmi < 30) {
        return 'overweight';
      } else {
        return 'obese';
      }
    } catch (e) {
      return '';
    }
  }

  /// Checks if the height is correct
  static bool isHeightCorrect(String heightStr) {
    final symbols = GetIt.I<LocalNumberSymbols>();
    final String normalizedHeight = _normalizeInput(heightStr, symbols.decimalSep);
    final double? normalizedHeightDouble = double.tryParse(normalizedHeight);
    return normalizedHeightDouble == null ? false : normalizedHeightDouble > 0.0 && normalizedHeightDouble < 2.73;
  }

  /// Checks if the weight is correct
  static bool isWeightCorrect(String weightStr) {
    final symbols = GetIt.I<LocalNumberSymbols>();
    final String normalizedWeight = _normalizeInput(weightStr, symbols.decimalSep);
    final double? normalizedWeightDouble = double.tryParse(normalizedWeight);
    return normalizedWeightDouble == null ? false : normalizedWeightDouble > 0.0 && normalizedWeightDouble < 600.0;
  }
}
