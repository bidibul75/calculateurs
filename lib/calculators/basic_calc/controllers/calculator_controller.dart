import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:calculators/utils/extensions/extensions.dart';
import '../models/calculator_state.dart';
import '../services/calculator_logic.dart';

class CalculatorController extends ChangeNotifier {
  CalculatorState _state = CalculatorState();

  CalculatorState get state => _state;

  void onButtonPressed(String buttonText) {
    switch (buttonText) {
      case "C":
        _state = CalculatorState(); // Reset complet
        break;

      case "+":
      case "-":
      case "x":
      case "÷":
      case "x^y":
        _handleOperator(buttonText);
        break;

      case "=":
      case "M+":
      case "M-":
        _handleEqualOrMemory(buttonText);
        break;

      case "MR":
        if (_state.memory != 0) {
          // On récupère la mémoire formatée
          String memVal = Decimal.parse(_state.memory.toString()).toPreciseFormattedString();
          _state = _state.copyWith(
            output: memVal,
            currentInput: memVal.toCleanMathString(), // On nettoie pour le calcul interne
          );
        }
        break;

      case "MC":
        _state = _state.copyWith(memory: 0.0);
        break;

      case "+/-":
        _handlePlusMinus();
        break;

      case "x²":
      case "1/x":
      case "√":
        _handleUnary(buttonText);
        break;

      case "⌫":
        _handleBackspace();
        break;

      default: // Chiffres et point
        _handleNumber(buttonText);
    }
    notifyListeners();
  }

  // --- Logiques Privées ---

  void _handleOperator(String label) {
    // Conversion label interface -> symbole mathématique
    String op = (label == "x^y") ? "^" : label;

    if (_state.currentInput.isNotEmpty) {
      // On stocke le premier nombre (num1)
      String inputClean = _state.currentInput.toCleanMathString();

      _state = _state.copyWith(
        num1: inputClean,
        operation: op,
        currentInput: "",
        lastOperationIsUnary: false,
        // On met à jour l'historique : "1 000 +"
        history: CalculatorLogic.updateHistory(_state.history, op, inputClean, true),
      );
    } else if (_state.operation.isNotEmpty) {
      // Si on change d'opérateur sans avoir tapé de nouveau chiffre (ex: tape + puis change pour x)
      // On modifie juste l'opérateur dans l'historique
      String currentHist = _state.history.trim();
      // On enlève le dernier opérateur et on met le nouveau
      if (currentHist.isNotEmpty) {
        // Regex simple pour remplacer le dernier caractère si c'est un opérateur
        // Ou reconstruction simplifiée :
        String base = _state.num1; // On reprend le num1 stocké
        // On reformate num1 pour l'affichage
        String formattedBase = Decimal.tryParse(base)?.toPreciseFormattedString() ?? base;
        String newHistory = "$formattedBase $op ";
        _state = _state.copyWith(operation: op, history: newHistory);
      }
    }
  }

  void _handleEqualOrMemory(String buttonText) {
    double memo = _state.memory;
    String currentInputClean = _state.currentInput.toCleanMathString();

    if (currentInputClean.isNotEmpty && _state.operation.isNotEmpty) {
      // 1. Calculer le résultat
      String result = CalculatorLogic.calculateResult(
          num1: _state.num1,
          num2: currentInputClean,
          operation: _state.operation
      );

      // Gestion Mémoire M+ / M- sur le résultat
      if (buttonText == "M+" || buttonText == "M-") {
        // On nettoie le résultat formaté (ex: "1 000,50") pour avoir un double
        double resDouble = double.tryParse(result.toCleanMathString()) ?? 0.0;
        if (buttonText == "M+") memo += resDouble;
        if (buttonText == "M-") memo -= resDouble;
      }

      // Mise à jour historique
      String history = _state.lastOperationIsUnary
          ? "${_state.history} = $result"
          : CalculatorLogic.updateHistory(
          _state.history,
          _state.operation,
          _state.num1,
          false,
          currentInputClean,
          result
      );

      _state = _state.copyWith(
        output: result, // result est déjà formaté par la Logic
        history: history,
        currentInput: result, // On garde le résultat comme input pour la suite
        operation: "", // Reset opération
        memory: memo,
      );
    }
    // Gestion Mémoire directe (si pas d'opération en cours : ex: "5 M+")
    else if (buttonText.startsWith("M") && currentInputClean.isNotEmpty) {
      double val = double.tryParse(currentInputClean) ?? 0.0;
      if (buttonText == "M+") memo += val;
      if (buttonText == "M-") memo -= val;
      _state = _state.copyWith(memory: memo);
    }
  }

  void _handleUnary(String op) {
    if (_state.currentInput.isNotEmpty) {
      String inputClean = _state.currentInput.toCleanMathString();

      String result = CalculatorLogic.calculateUnary(input: inputClean, operation: op);

      String history = CalculatorLogic.updateHistoryUnary(inputClean, op, result, _state.history);

      _state = _state.copyWith(
        currentInput: result,
        output: result,
        history: history,
        lastOperationIsUnary: true,
      );
    }
  }

  void _handlePlusMinus() {
    if (_state.currentInput.isNotEmpty) {
      String current = _state.currentInput;
      // Gestion intelligente du signe négatif selon le format
      if (current.startsWith("-")) {
        current = current.substring(1);
      } else {
        if (current != "0") current = "-$current";
      }
      _state = _state.copyWith(currentInput: current, output: current);
    }
  }

  void _handleBackspace() {
    if (_state.currentInput.isNotEmpty) {
      String newVal = _state.currentInput.substring(0, _state.currentInput.length - 1);
      if (newVal.isEmpty || newVal == "-") newVal = "";
      _state = _state.copyWith(currentInput: newVal, output: newVal.isEmpty ? "0" : newVal);
    }
  }

  void _handleNumber(String buttonText) {
    // Récupération du séparateur décimal local (virgule ou point) via vos extensions ou Intl
    // Pour simplifier ici, on suppose que l'UI envoie "." et qu'on affiche "."
    // Si vous voulez gérer la virgule à la saisie, remplacez "." par "," ici.

    String current = _state.currentInput;

    // Si on tape un chiffre après avoir obtenu un résultat (=), on repart à zéro
    if (_state.history.contains("=") && _state.operation.isEmpty && !_state.lastOperationIsUnary) {
      if (buttonText == "00") return;
      String val = (buttonText == ".") ? "0." : buttonText;
      _state = CalculatorState(currentInput: val, output: val);
      return;
    }

    if (buttonText == "00" && (current == "" || current == "0")) return;

    if (current == "0" && buttonText != ".") {
      current = buttonText;
    } else {
      if (buttonText == "." && current.contains(".")) return;
      if (buttonText == "." && current.isEmpty) current = "0.";
      current += buttonText;
    }
    _state = _state.copyWith(currentInput: current, output: current);
  }

  String memoryDisplay() {
    if (_state.memory == 0) return "";
    return "M = ${Decimal.parse(_state.memory.toString()).toPreciseFormattedString()}";
  }
}
