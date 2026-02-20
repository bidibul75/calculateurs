import 'dart:math' as math;
import 'package:rational/rational.dart';
import 'package:decimal/decimal.dart';
import 'package:calculators/utils/extensions/extensions.dart';

class CalculatorLogic {

  /// Calculates the result of a binary operation (+, -, *, /)
  static String calculateResult({
    required String num1,
    required String num2,
    required String operation
  }) {
    try {
      // Convert clean Strings (1000.5) to Rational
      final r1 = Rational.parse(num1);
      final r2 = Rational.parse(num2);

      Rational result;

      switch (operation) {
        case "+":
          result = r1 + r2;
          break;
        case "-":
          result = r1 - r2;
          break;
        case "x":
          result = r1 * r2;
          break;
        case "÷":
          if (r2 == Rational.zero) return "Error";
          result = r1 / r2;
          break;
        case "^":
        case "x^y":
        // Rational.pow expects an int.
        // If the exponent is decimal (e.g., 2.5), we should use log/exp in double
        // Here we truncate to int to stay within Rational
          try {
            int exponent = r2.toBigInt().toInt();
            result = r1.pow(exponent);
          } catch (e) {
            return "Error";
          }
          break;
        default:
          return "Error";
      }

      // Convert to Decimal with precision, then to formatted String
      return result
          .toDecimal(scaleOnInfinitePrecision: 10)
          .toPreciseFormattedString();

    } catch (e) {
      return "Error";
    }
  }

  /// Calculates the result of a unary operation (square root, square, reciprocal)
  static String calculateUnary({
    required String input,
    required String operation
  }) {
    try {
      final r = Rational.parse(input);
      Rational result;

      switch (operation) {
        case "x²":
          result = r * r;
          break;
        case "1/x":
          if (r == Rational.zero) return "Error";
          result = Rational.one / r;
          break;
        case "√":
        // Rational does not handle irrational square roots.
        // We use double instead.
          double val = r.toDouble();
          if (val < 0) return "Error";
          double root = math.sqrt(val);
          // Convert back to String for Rational parsing (to keep the string consistent)
          result = Rational.parse(root.toString());
          break;
        default:
          return "Error";
      }

      return result
          .toDecimal(scaleOnInfinitePrecision: 10)
          .toPreciseFormattedString();

    } catch (e) {
      return "Error";
    }
  }

  /// Updates the history string (e.g: "1 000 + 500 =")
  static String updateHistory(
      String currentHistory,
      String operation,
      String num1, // clean String (mathematical)
      [
        bool isOperatorChain = false, // True if we just clicked on +, -, etc.
        String? num2, // clean String
        String? output, // Result already formatted
      ]) {

    // Local function to format a raw number (e.g: "1000.5" -> "1 000,5")
    String format(String n) {
      try {
        if (n == "Error") return n;
        return Rational.parse(n)
            .toDecimal(scaleOnInfinitePrecision: 10)
            .toPreciseFormattedString();
      } catch (e) {
        return n;
      }
    }

    String formattedNum1 = format(num1);

    // Case 1: We just clicked on an operator (+, -, x...)
    if (isOperatorChain && num2 == null) {
      return "$formattedNum1 $operation ";
    }

    // Case 2: We just clicked on equal (=)
    if (num2 != null) {
      String formattedNum2 = format(num2);
      // output is already formatted by calculateResult
      return "$formattedNum1 $operation $formattedNum2 = ${output??""}";
    }

    return currentHistory;
  }

  static String updateHistoryUnary(
      String inputVal,
      String operation,
      String resultFormatted,
      String currentHistory
      ) {
    String format(String n) {
      try {
        return Rational.parse(n)
            .toDecimal(scaleOnInfinitePrecision: 10)
            .toPreciseFormattedString();
      } catch (e) {
        return n;
      }
    }

    String formattedInput = format(inputVal);

    switch (operation) {
      case "x²":
        return "($formattedInput)² =";
      case "1/x":
        return "1/($formattedInput) =";
      case "√":
        return "√($formattedInput) =";
      default:
        return "$operation($formattedInput) =";
    }
  }
}
