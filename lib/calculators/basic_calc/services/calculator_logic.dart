import 'package:rational/rational.dart';
import 'package:decimal/decimal.dart';
import 'package:calculators/utils/extensions/extensions.dart';

class CalculatorLogic {
  static String calculateResult({
    required double num1,
    required double num2,
    required String operation
  }) {
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

      // Ici, on transforme le Rational en Decimal pour l'affichage
      // On utilise toFormatString() ou toString() du Decimal
      return result.toDecimal(scaleOnInfinitePrecision: 10).toString().cleanPointZero();

    } catch (e) {
      return "Error";
    }
  }

  static String updateHistory(String currentHistory, String operation, double num1, [double? num2, String? output]) {
    // Conversion propre pour l'historique aussi
    String format(double n) => Rational.parse(n.toString()).toDecimal().toString().cleanPointZero();

    String h = format(num1);
    if (operation.isNotEmpty) h += " $operation ";
    if (num2 != null) h += "${format(num2)} = ";
    if (output != null) h += output;

    return h;
  }
}
