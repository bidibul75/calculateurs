import 'dart:math' as math;
import 'package:rational/rational.dart';
import 'package:decimal/decimal.dart';
import 'package:calculators/utils/extensions/extensions.dart';

class CalculatorLogic {
  static String calculateResult({required double num1, required double num2, required String operation}) {
    final r1 = Rational.parse(num1.toString());
    final r2 = Rational.parse(num2.toString());

    Rational result;

    try {
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
          if (r2 == Rational.zero) return "Error : divide by 0";
          result = r1 / r2;
          break;
        case "^":
          if (num2.isInteger()) {
            result = r1.pow(num2.toInt());
          } else {
            return "Error : exponent must be integer";
          }
          break;
        default:
          return "0";
      }

      // Here we convert Rational to Decimal for display
      return result.toDecimal(scaleOnInfinitePrecision: 10).toString().cleanPointZero();
    } catch (e) {
      return "Error";
    }
  }

  static String calculateUnary({required double input, required String operation}) {
    final r = Rational.parse(input.toString());
    Rational result;

    try {
      switch (operation) {
        case "x²":
          result = r * r;
          break;
        case "1/x":
          if (r == Rational.zero) return "Error div. by 0";
          result = Rational.one / r;
          break;
        case "√":
          if (input < 0) return "Error negative root";
          // use of double for sqrt
          double root = math.sqrt(input);
          result = Rational.parse(root.toString());
          break;
        default:
          return "0";
      }
      return result.toDecimal(scaleOnInfinitePrecision: 10).toString();
    } catch (e) {
      print(e);
      return "Error";
    }
  }

  static String updateHistory(
    String currentHistory,
    String operation,
    double num1, [
    double? num2,
    String? output,
    bool parentheses = false,
  ]) {
    String h = "";
    // Clean convert
    String format(double n) => Rational.parse(n.toString()).toDecimal().toString().cleanPointZero();
    if (currentHistory == "") {
      h = format(num1);
    } else {
      if (["+", "-", "x", "÷", "^"].contains(operation)) {
        // Doesn't add parentheses if it's a number
        if (currentHistory.split("=")[0].trim().endsWith(operation)) {
          currentHistory = currentHistory.trim().substring(0, currentHistory.trim().length - 1);
        }
        if (currentHistory.length > 1) {
          if (currentHistory.trim().isNotANumber() && parentheses) {
            h = "(${currentHistory.split("=")[0].trim()})";
          } else {
            h = currentHistory.split("=")[0].trim();
          }
        } else {
          h = currentHistory.split("=")[0].trim();
        }
      }
    }
    if (operation.isNotEmpty) h += " $operation ";
    if (num2 != null) h += "${format(num2)} = \n";
    if (output != null) h += output;

    return h;
  }

  static String updateHistoryUnary(double val, String operation, String result, String lastHistory) {
    String historyTemp = "";
    String format(double n) => Rational.parse(n.toString()).toDecimal().toString().cleanPointZero();
    if (lastHistory == "") {
      historyTemp = format(val);
    } else {
      if (lastHistory.trim().endsWith("=")) {
        historyTemp = "(${lastHistory.split("=")[0].trim()})";
      } else if (lastHistory.trim().isNotANumber()) {
        if (operation == "x²") return "$lastHistory $val²";
        if (operation == "1/x") return "$lastHistory 1/$val";
        if (operation == "√") return "$lastHistory √$val";
      }
    }
    if (operation == "x²") return "$historyTemp² =\n$result";
    if (operation == "1/x") return "1/$historyTemp =\n$result";
    if (operation == "√") return "√$historyTemp =\n$result";
    return "Error";
  }
}
