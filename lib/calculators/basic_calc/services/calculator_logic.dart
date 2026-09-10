// lib/calculators/basic_calc/services/calculator_logic.dart

import 'dart:math' as math;
import 'package:rational/rational.dart';
import 'package:decimal/decimal.dart';
import 'package:calculators/utils/extensions/extensions.dart';

class CalculatorLogic {
  static const int _internalPrecision = 20;
  static const int _maxExactRootDegree = 12;

  static final BigInt _bigIntZero = BigInt.zero;
  static final BigInt _bigIntOne = BigInt.one;
  static final BigInt _bigIntTwo = BigInt.from(2);

  static String _canonicalBinaryOperator(String operation) {
    if (operation == '*' || operation == '×') {
      return 'x';
    }
    return operation;
  }

  static BigInt? _exactIntegerNthRoot(BigInt value, int n) {
    if (n <= 0 || value < _bigIntZero) {
      return null;
    }
    if (value == _bigIntZero || value == _bigIntOne || n == 1) {
      return value;
    }

    BigInt low = _bigIntOne;
    BigInt high = value;
    while (low <= high) {
      final mid = (low + high) ~/ _bigIntTwo;
      final powered = mid.pow(n);
      if (powered == value) {
        return mid;
      }
      if (powered < value) {
        low = mid + _bigIntOne;
      } else {
        high = mid - _bigIntOne;
      }
    }
    return null;
  }

  static Rational? _exactRationalNthRoot(Rational value, int n) {
    if (n <= 0) {
      return null;
    }
    if (value == Rational.zero) {
      return Rational.zero;
    }

    final numerator = value.numerator;
    final denominator = value.denominator;
    final isNegative = numerator < _bigIntZero;
    if (isNegative && n.isEven) {
      return null;
    }

    final rootNumeratorAbs = _exactIntegerNthRoot(numerator.abs(), n);
    final rootDenominator = _exactIntegerNthRoot(denominator, n);
    if (rootNumeratorAbs == null || rootDenominator == null) {
      return null;
    }

    final rootNumerator = isNegative ? -rootNumeratorAbs : rootNumeratorAbs;
    return Rational(rootNumerator, rootDenominator);
  }

  static Rational? tryExactPowerRational(Rational base, Rational exponent) {
    if (exponent == Rational.zero) {
      return Rational.one;
    }

    if (exponent.isInteger) {
      return base.pow(exponent.toBigInt().toInt());
    }

    final exponentNumerator = exponent.numerator;
    final exponentDenominator = exponent.denominator;
    if (exponentDenominator <= _bigIntZero) {
      return null;
    }
    if (exponentDenominator > BigInt.from(_maxExactRootDegree)) {
      return null;
    }

    final rationalRoot = _exactRationalNthRoot(base, exponentDenominator.toInt());
    if (rationalRoot == null) {
      return null;
    }

    final absPower = exponentNumerator.abs().toInt();
    Rational powered = rationalRoot.pow(absPower);
    if (exponentNumerator < _bigIntZero) {
      if (powered == Rational.zero) {
        return null;
      }
      powered = Rational.one / powered;
    }
    return powered;
  }

  static Rational? tryExactSqrtRational(Rational value) {
    return _exactRationalNthRoot(value, 2);
  }

  /// Calculates the result of a binary operation (+, -, x, /)
  static String calculateResult({
    required String num1,
    required String num2,
    required String operation,
    String num3 = "",
    String operation2 = "",
  }) {
    try {
      // Convert clean Strings (1000.5) to Rational
      final r1 = Rational.parse(num1);
      Rational r2 = Rational.parse(num2);
      // Keep a single internal symbol for multiplication so every branch uses the canonical `x` operator.
      final normalizedOperator = _canonicalBinaryOperator(operation);

      // Handle case when num3 and operation2 are provided (x^y as second operand)
      if (num3 != "" && operation2 == "^") {
        final r3 = Rational.parse(num3);
        final exactSecondPow = tryExactPowerRational(r2, r3);
        if (exactSecondPow != null) {
          r2 = exactSecondPow;
        } else {
          final secondPow = math.pow(double.parse(num2), double.parse(num3)).toDouble();
          if (!secondPow.isFinite || secondPow.isNaN) return "Error exp";
          r2 = Rational.parse(secondPow.toString());
        }
      }

      Rational result;

      switch (normalizedOperator) {
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
          if (r2 == Rational.zero) return "Error Div By Zero";
          result = r1 / r2;
          break;
        case "^":
        case "x^y":
          try {
            final exactPow = tryExactPowerRational(r1, r2);
            if (exactPow != null) {
              result = exactPow;
            } else {
              final powValue = math.pow(double.parse(num1), double.parse(num2)).toDouble();
              if (!powValue.isFinite || powValue.isNaN) return "Error exp";
              return Decimal.parse(powValue.toString()).toSciPreciseFormattedString();
            }
          } catch (e) {
            return "Error exp";
          }
          break;
        default:
          return "Error default";
      }

      // Keep extra internal precision, then let formatRound decide if an approximation marker is needed.
      return result.toDecimal(scaleOnInfinitePrecision: _internalPrecision).toSciPreciseFormattedString();
    } catch (e) {
      return "Error end";
    }
  }

  /// Calculates the result of a unary operation (square root, square, reciprocal)
  static String calculateUnary({required String input, required String operation}) {
    try {
      final r = Rational.parse(input);
      Rational result;

      Decimal sqrtDecimal(Decimal value, {int scale = 30, int maxIterations = 50}) {
        if (value == Decimal.zero) return Decimal.zero;
        if (value < Decimal.zero) throw Exception("Negative sqrt");

        Decimal absDecimal(Decimal v) => v < Decimal.zero ? -v : v;
        Decimal divDecimal(Decimal a, Decimal b) => (a / b).toDecimal(scaleOnInfinitePrecision: scale);

        final two = Decimal.fromInt(2);
        Decimal x = divDecimal(value, two);
        if (x == Decimal.zero) {
          x = Decimal.one;
        }

        final Decimal epsilon = Decimal.parse("1e-$scale");

        for (int i = 0; i < maxIterations; i++) {
          final next = divDecimal(x + divDecimal(value, x), two);
          final diff = absDecimal(next - x);
          if (diff < epsilon) return next;
          x = next;
        }

        return x;
      }

      switch (operation) {
        case "x²":
          result = r * r;
          break;
        case "1/x":
          if (r == Rational.zero) return "Error Div By Zero";
          result = Rational.one / r;
          break;
        case "√":
          final exactSqrt = tryExactSqrtRational(r);
          if (exactSqrt != null) {
            return exactSqrt.toDecimal(scaleOnInfinitePrecision: _internalPrecision).toSciPreciseFormattedString();
          }
          // Try to use built-in sqrt first for rational results.
          // If input is irrational, fall back to Newton-Raphson for precision.
          final Decimal inputDecimal = Decimal.parse(input);
          final double inputDouble = double.parse(input);

          if (inputDouble >= 0) {
            final double sqrtDouble = math.sqrt(inputDouble);

            // Check if sqrt is finite and rational (perfect result)
            if (sqrtDouble.isFinite) {
              // Test if sqrtDouble is exactly representable as a rational with limited denominator
              // We test if (sqrt * 10^6) is close to an integer (rational with max 6 decimals)
              final scaled = sqrtDouble * 1e6;
              final roundedScaled = scaled.round();
              if ((scaled - roundedScaled).abs() < 1e-9 && (sqrtDouble * sqrtDouble - inputDouble).abs() < 1e-15) {
                // Rational result: use the double result converted to Decimal
                // This handles both integers (âˆš9 = 3) and decimals (âˆš6.25 = 2.5)
                return Decimal.parse(sqrtDouble.toString()).toSciPreciseFormattedString();
              }
            }
          } else {
            return 'Error SQRT Of A Negative Number';
          }

          // Fall back to Newton-Raphson for irrational/complex cases
          final Decimal sqrtResult = sqrtDecimal(inputDecimal, scale: 30);
          return sqrtResult.toSciPreciseFormattedString();
        case "%":
          result = r / Rational.fromInt(100);
          break;
        default:
          return "Error";
      }

      return result.toDecimal(scaleOnInfinitePrecision: _internalPrecision).toSciPreciseFormattedString();
    } catch (e) {
      return "Error";
    }
  }

  /// Returns a formatted history (e.g: "1 000 + 500 =")
  /// Updates the history display when an operator is clicked or result is computed
  static String updateHistory(
    String currentHistory,
    String operation,
    String num1, [
    String? num2, // clean String
    String? output, // Result already formatted
    String? operation2 = "",
  ]) {
    String formattedNum1 = num1.formatRound();

    // If num2 is provided, we're displaying the complete operation with result
    if (num2 != null) {
      String formattedNum2 = num2.formatRound();
      if (operation2 != "") {
        return "$currentHistory $formattedNum2 $operation2";
      } else {
        // output is already formatted by calculateResult
        String outputDisplay;
        if (output == null) {
          outputDisplay = "";
        } else {
          outputDisplay = output.formatRound();
        }
        return "$formattedNum1 $operation $formattedNum2 = $outputDisplay";
      }
    }

    // If num2 is null, we just clicked an operator and display only the operator
    return "$formattedNum1 $operation ";
  }

  /// Returns the history when a unary operator is used
  static String updateHistoryUnary(
    String inputVal,
    String operation,
    String resultFormatted, [
    String currentHistory = "",
  ]) {
    String formattedInput = inputVal.formatRound();

    switch (operation) {
      case "x²":
        return "${currentHistory == "" ? "" : currentHistory}($formattedInput)² =";
      case "1/x":
        return "${currentHistory == "" ? "" : currentHistory}1/($formattedInput) =";
      case "√":
        return "${currentHistory == "" ? "" : currentHistory}√($formattedInput) =";
      case "%":
        return "${currentHistory == "" ? "" : currentHistory}($formattedInput)% =";
      default:
        return "$operation($formattedInput) =";
    }
  }
}
