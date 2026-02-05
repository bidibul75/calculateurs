import 'package:calculators/utils/extensions/extensions.dart';

void generateHistory(String history, String operation, double num1, double num2, String output, {bool square = false, bool sqrt = false}) {
  if (square) {
    history = "( ${history.replaceFirst("=", ")²=")}";
    return;
  };
  if (sqrt) {
    history = "√( ${history.replaceFirst("=", ")=")}";
    return;
  }
  history += "${num1.toString().cleanPointZero()} ";
  print("opé: $operation");

  if (operation.isEmpty) {
    return;
  }
  else {
    history += operation;
  }
  //ERREUR A CE MOMENT
  print("generate : $num2");
  if (num2 == 0) return;
  history += num2.toString().cleanPointZero();

  history += "=";
  if (output.isEmpty) return;

  history += output.cleanPointZero();
}