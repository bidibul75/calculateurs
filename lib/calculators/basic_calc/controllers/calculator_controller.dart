import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:calculators/utils/extensions/extensions.dart';
import 'package:rational/rational.dart';
import '../models/calculator_state.dart';
import '../services/calculator_logic.dart';

class CalculatorController extends ChangeNotifier {
  CalculatorState _state = CalculatorState();

  CalculatorState get state => _state;

  void onButtonPressed(String buttonText) {
    switch (buttonText) {
      case "C":
        // Clear only the current input and operation, preserve memory and history
        _state = _state.copyWith(
          output: "0",
          currentInput: "",
          num1: "0",
          operation: "",
          history: _state.history.contains("=") ? _state.history : "",
          // Clear history only if no result is displayed
          lastOperationIsUnary: false,
        );
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
        if (_state.memory != Rational.zero) {
          // Retrieve the formatted memory
          String memVal = _state.memory.toDecimal(scaleOnInfinitePrecision: 10).toPreciseFormattedString();
          _state = _state.copyWith(
            output: memVal,
            currentInput: memVal.toCleanMathString(), // Clean for internal calculation
            lastOperationIsUnary: true,
          );
        }
        break;

      case "MC":
        _state = _state.copyWith(memory: Rational.zero);
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

      default: // Digits and dot
        _handleNumber(buttonText);
    }
    notifyListeners();
  }

  // --- Private Logic ---

  void _handleOperator(String label) {
    // Convert UI label -> math symbol
    String op = (label == "x^y") ? "^" : label;

    if (_state.currentInput.isNotEmpty) {
      // Store the first number (num1)
      String inputClean = _state.currentInput.toCleanMathString();

      if (_state.operation.isNotEmpty) {
        // If there's already an operation pending, compute it first before setting the new operator
        String intermediateResult = CalculatorLogic.calculateResult(
          num1: _state.num1,
          num2: inputClean,
          operation: _state.operation,
        );

        // Update history with the intermediate result
        String history = CalculatorLogic.updateHistory(
          _state.history,
          _state.operation,
          _state.num1,
          false,
          inputClean,
          intermediateResult,
        );

        // Set the intermediate result as the new num1 for the next operation
        _state = _state.copyWith(
          num1: intermediateResult.toCleanMathString(),
          operation: op,
          currentInput: "",
          lastOperationIsUnary: false,
          history: history,
        );
      } else {
        _state = _state.copyWith(
          num1: inputClean,
          operation: op,
          currentInput: "",
          lastOperationIsUnary: false,
          // Update history: "1 000 +"
          history: CalculatorLogic.updateHistory(_state.history, op, inputClean, true),
        );
      }
    } else if (_state.operation.isNotEmpty) {
      // If we change operator without typing a new number (e.g. press + then change to x)
      // Only change the operator in the history
      String currentHist = _state.history.trim();
      // Remove the last operator and apply the new one
      if (currentHist.isNotEmpty) {
        // Simple regex to replace the last character if it is an operator
        // Or simplified rebuild:
        String base = _state.num1; // Reuse stored num1
        // Reformat num1 for display
        String formattedBase = Decimal.tryParse(base)?.toPreciseFormattedString() ?? base;
        String newHistory = "$formattedBase $op ";
        _state = _state.copyWith(operation: op, history: newHistory);
      }
    }
  }

  void _handleEqualOrMemory(String buttonText) {
    Rational memo = _state.memory;
    String currentInputClean = _state.currentInput.toCleanMathString();

    if (currentInputClean.isNotEmpty && _state.operation.isNotEmpty) {
      // 1. Compute the result
      String result = CalculatorLogic.calculateResult(
        num1: _state.num1,
        num2: currentInputClean,
        operation: _state.operation,
      );

      // Handle M+ / M- memory on the result
      if (buttonText == "M+" || buttonText == "M-") {
        // Keep the same precision as result
        Rational resRational = Rational.parse(result.toCleanMathString());
        if (buttonText == "M+") memo += resRational;
        if (buttonText == "M-") memo -= resRational;
      }

      // Update history
      String history = _state.lastOperationIsUnary
          ? "${_state.history} = $result"
          : CalculatorLogic.updateHistory(
              _state.history,
              _state.operation,
              _state.num1,
              false,
              currentInputClean,
              result,
            );

      _state = _state.copyWith(
        output: result,
        // result is already formatted by the logic
        history: history,
        currentInput: result,
        // Keep result as input for the next operation
        operation: "",
        // Reset operation
        memory: memo,
      );
    }
    // Direct memory handling (if no active operation: e.g. "5 M+")
    else if (buttonText.startsWith("M") && currentInputClean.isNotEmpty) {
      Rational val = Rational.parse(currentInputClean);
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
        history: "$history $result",
        lastOperationIsUnary: true,
      );
    }
  }

  void _handlePlusMinus() {
    if (_state.currentInput.isNotEmpty) {
      String current = _state.currentInput;
      // Smart handling of the negative sign depending on the format
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
    // Get the local decimal separator (comma or dot) via extensions or Intl
    // To simplify, assume the UI sends "." and we display "."
    // If you want to handle comma input, replace "." with "," here.

    String current = _state.currentInput;

    if (buttonText == "00" && (current == "" || current == "0")) return;

    // If a digit is typed after a result (=), start over
    if (_state.history.contains("=") && _state.operation.isEmpty && !_state.lastOperationIsUnary) {
      String val = (buttonText == ".") ? "0." : buttonText;
      _state = CalculatorState(
        currentInput: current + val,
        output: current + val,
        history: _state.history,
        memory: _state.memory,
      );
      return;
    }

    if (current == "0" && buttonText != ".") {
      current = buttonText;
    } else {
      if (buttonText == "." && current.contains(".")) return;
      (buttonText == "." && current.isEmpty) ? current = "0." : current += buttonText;
    }
    _state = _state.copyWith(currentInput: current, output: current);
  }

  String memoryDisplay() {
    if (_state.memory == Rational.zero) return "";
    return "M = ${Decimal.parse(_state.memory.toDecimal().toString()).toPreciseFormattedString()}";
  }
}
