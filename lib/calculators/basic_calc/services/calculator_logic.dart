import '../../../utils/extensions/double_extensions.dart';
import '../../../utils/extensions/string_extensions.dart';

class CalculatorLogic {
  static String calculateResult({required double num1, required double num2, required String operation}) {
    switch (operation) {
      case "+":
        return (num1 + num2).toString().cleanPointZero();
      case "-":
        return (num1 - num2).toString().cleanPointZero();
      case "x":
        return (num1 * num2).toString().cleanPointZero();
      case "÷":
        return (num2 == 0) ? "Error : divide by 0" : (num1 / num2).toString().cleanPointZero();
      case "^":
        if (num2.isInteger()) {
          return num1.power(num2.toInt()).toString().cleanPointZero();
        }
        return "Error : exponent must be integer";
      default:
        return "0";
    }
  }

  static String updateHistory(String currentHistory, String operation, double num1, [double? num2, String? output]) {
    String h = num1.toString().cleanPointZero();
    if (operation.isNotEmpty) h += " $operation ";
    if (num2 != null) h += "${num2.toString().cleanPointZero()} = ";
    if (output != null) h += output;
    return h;
  }
}
