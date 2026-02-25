import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:calculators/utils/extensions/extensions.dart';
import 'package:get_it/get_it.dart';
import 'package:rational/rational.dart';
import '../models/calculator_state.dart';
import '../services/calculator_logic.dart';

class CalculatorController extends ChangeNotifier {
  CalculatorState _state = CalculatorState();

  CalculatorState get state => _state;
  bool isLastClicClear = false;
  bool isLastClicEqualOrMemo = false;
  bool isLastClicNumber = false;
  final symbols = GetIt.I<LocalNumberSymbols>();

  void onButtonPressed(String buttonText) {
    switch (buttonText) {
      case "C":
        isLastClicEqualOrMemo = false;
        if (isLastClicClear) {
          isLastClicClear = false;
          _state = _state.copyWith(
            output: "0",
            currentInput: "",
            num1: "0",
            operation: "",
            history: "",
            lastOperationIsUnary: false,
          );
        } else {
          isLastClicClear = true;
          // Clear only the current input and operation, preserve memory and history
          _state = _state.copyWith(
            output: "0",
            currentInput: "",
            num1: "0",
            operation: "",
            // If the history already contains a result (=), keep it for reference, otherwise clear it
            history: _state.history.contains("=") ? _state.history : "",
            lastOperationIsUnary: false,
          );
        }
        break;

      case "+":
      case "-":
      case "x":
      case "÷":
      case "x^y":
        isLastClicClear = false;
        isLastClicEqualOrMemo = false;
        _handleOperator(buttonText);
        break;

      case "=":
      case "M+":
      case "M-":
        isLastClicClear = false;
        isLastClicEqualOrMemo = true;
        _handleEqualOrMemory(buttonText);
        break;

      case "MR":
        isLastClicClear = false;
        isLastClicEqualOrMemo = true;
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
        isLastClicClear = false;
        isLastClicEqualOrMemo = false;
        _state = _state.copyWith(memory: Rational.zero);
        break;

      case "+/-":
        isLastClicClear = false;
        isLastClicEqualOrMemo = false;
        _handlePlusMinus();
        break;

      case "x²":
      case "1/x":
      case "√":
        isLastClicClear = false;
        isLastClicEqualOrMemo = false;
        _handleUnary(buttonText);
        break;

      case "⌫":
        isLastClicClear = false;
        isLastClicEqualOrMemo = false;
        _handleBackspace();
        break;

      default: // Digits and dot
        isLastClicClear = false;
        _handleNumber(buttonText);
    }
    notifyListeners();
  }

  // --- Private Logic ---

  void _handleOperator(String label) {
    _state = _state.copyWith(lastOperationIsUnary: false);
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
        String history = "$intermediateResult $op";

        // Set the intermediate result as the new num1 for the next operation
        _state = _state.copyWith(
          num1: intermediateResult.toCleanMathString(),
          operation: op,
          currentInput: "",
          output: "",
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
    if (currentInputClean.isNotEmpty && _state.operation.isNotEmpty && !_state.history.contains("=")) {
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
      String history = _state.history.contains("=")
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
    String history = "";
    if (_state.output.isNotEmpty) {
      String inputClean = _state.output.toCleanMathString();

      String result = CalculatorLogic.calculateUnary(input: inputClean, operation: op);

      if (_state.history.containsOperator() && !_state.history.contains("=")) {
        result = CalculatorLogic.calculateResult(num1: _state.num1, num2: result, operation: _state.operation);
      }
      // If we already have a history with an operator (e.g: "1 000 + 500") and we apply a unary operation on the result,
      // we want to keep the history and just update the last part (e.g: "1 000 + (500)² = 250 000").
      // But if we don't have an operator in the history, we just want to show the unary operation (e.g: "√(500) = 22,36").
      if (_state.history.contains("=")) {
        history = "${CalculatorLogic.updateHistoryUnary(inputClean, op, result)} $result";
        _state = _state.copyWith(currentInput: result, output: result, history: history, lastOperationIsUnary: false);
      } else {
        history = "${CalculatorLogic.updateHistoryUnary(inputClean, op, result, _state.history)} $result";
        _state = _state.copyWith(currentInput: result, output: result, history: history, lastOperationIsUnary: true);
      }
    }
    isLastClicEqualOrMemo = true;
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

    if (!isLastClicNumber) {
      if (buttonText == "00") return;
    } else {
      isLastClicNumber = true;
    }

    // If a digit is typed after a result (=), start over
    if (isLastClicEqualOrMemo) {
      isLastClicEqualOrMemo = false;
      String val = (buttonText == symbols.decimalSep) ? "0${symbols.decimalSep}" : buttonText;
      _state = CalculatorState(currentInput: val, output: val, history: _state.history, memory: _state.memory);
      return;
    }

    if (current == "0" && buttonText != symbols.decimalSep) {
      current = buttonText;
    } else {
      if (buttonText == symbols.decimalSep && current.contains(symbols.decimalSep)) return;
      (buttonText == symbols.decimalSep && current.isEmpty)
          ? current = "0${symbols.decimalSep}"
          : current += buttonText;
    }
    _state = _state.copyWith(currentInput: current, output: current);
  }

  String memoryDisplay() {
    if (_state.memory == Rational.zero) return "";
    return "M = ${Decimal.parse(_state.memory.toDecimal().toString()).toPreciseFormattedString()}";
  }
}
