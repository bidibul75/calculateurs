import 'dart:math' as math;
import 'package:rational/rational.dart';
import 'package:decimal/decimal.dart';
// Importez votre fichier barrel qui contient l'extension toPreciseFormattedString
import 'package:calculators/utils/extensions/extensions.dart';

class CalculatorLogic {

  /// Calcule le résultat d'une opération binaire (+, -, *, /)
  static String calculateResult({
    required String num1,
    required String num2,
    required String operation
  }) {
    try {
      // Conversion des Strings "propres" (1000.5) en Rational
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
        // Rational.pow attend un int.
        // Si l'exposant est décimal (ex: 2.5), on devrait utiliser des log/exp en double
        // Ici on tronque à l'entier pour rester dans Rational
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

      // On convertit en Decimal avec précision, puis en String formatée
      return result
          .toDecimal(scaleOnInfinitePrecision: 10)
          .toPreciseFormattedString();

    } catch (e) {
      return "Error";
    }
  }

  /// Calcule le résultat d'une opération unaire (racine, carré, inverse)
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
        // Rational ne gère pas les racines carrées irrationnelles.
        // On passe par double.
          double val = r.toDouble();
          if (val < 0) return "Error";
          double root = math.sqrt(val);
          // On repasse en String pour le parsing Rational (pour garder la chaine cohérente)
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

  /// Met à jour la chaîne de l'historique (ex: "1 000 + 500 =")
  static String updateHistory(
      String currentHistory,
      String operation,
      String num1, // String "propre" (mathématique)
      [
        bool isOperatorChain = false, // Vrai si on vient de cliquer sur +, -, etc.
        String? num2, // String "propre"
        String? output, // Résultat déjà formaté
      ]) {

    // Fonction locale pour formater un nombre brut (ex: "1000.5" -> "1 000,5")
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

    // Cas 1 : On vient de cliquer sur un opérateur (+, -, x...)
    if (isOperatorChain && num2 == null) {
      return "$formattedNum1 $operation ";
    }

    // Cas 2 : On vient de cliquer sur Égal (=)
    if (num2 != null) {
      String formattedNum2 = format(num2);
      // output est déjà formaté par calculateResult
      return "$formattedNum1 $operation $formattedNum2 =";
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

    // Construction mathématique jolie
    switch (operation) {
      case "x²":
        return "sqr($formattedInput) =";
      case "1/x":
        return "1/($formattedInput) =";
      case "√":
        return "√($formattedInput) =";
      default:
        return "$operation($formattedInput) =";
    }
  }
}
