import 'package:flutter/material.dart';
import 'package:calculators/utils/extensions/extensions.dart';
import '../models/calculator_state.dart';
import '../services/calculator_logic.dart';

class CalculatorController extends ChangeNotifier {
  CalculatorState _state = CalculatorState();

  CalculatorState get state => _state;

  void onButtonPressed(String buttonText) {
    switch (buttonText) {
      case "C":
        _state = _state.copyWith(output: '0', history: '', currentInput: '');
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
        _state = _state.copyWith(
          output: _state.memory.toString().cleanPointZero(),
          currentInput: _state.memory.toString().cleanPointZero(),
        );
        break;

      case "MC":
        _state = _state.copyWith(memory: 0);
        break;

      case "+/-":
        if (_state.currentInput.isNotEmpty) {
          String newVal = _state.currentInput.startsWith("-")
              ? _state.currentInput.substring(1)
              : "-${_state.currentInput}";
          _state = _state.copyWith(currentInput: newVal, output: newVal);
        }
        break;

      case "x²":
      case "1/x":
      case "√":
        _handleUnary(buttonText);
        break;

      case "⌫":
        if (_state.currentInput.isNotEmpty) {
          String newVal = _state.currentInput.substring(0, _state.currentInput.length - 1);
          if (newVal.isEmpty || newVal == "-") newVal = "0";
          _state = _state.copyWith(currentInput: newVal, output: newVal);
        }
        break;

      default: // Numbers and points
        _handleNumber(buttonText);
    }
    notifyListeners(); // Refreshes UI
  }

  // Private logics

  void _handleOperator(String label) {
    String op = (label == "x^y") ? "^" : label;
    if (_state.currentInput.isNotEmpty) {
      double n1 = double.parse(_state.currentInput);
      _state = _state.copyWith(
        num1: n1,
        operation: op,
        currentInput: "",
        lastOperationIsUnary: false,
        history: CalculatorLogic.updateHistory(_state.history, op, n1, true),
      );
    } else if (_state.operation.isNotEmpty) {
      String history = _state.history.trim();
      history = "${history.substring(0, history.length - 1).trim()} $op ";
      _state = _state.copyWith(operation: op, history: history);
    }
  }

  void _handleEqualOrMemory(String buttonText) {
    double memo = _state.memory;
    if (_state.currentInput.isNotEmpty) {
      double n2 = double.parse(_state.currentInput);
      if (_state.operation.isNotEmpty) {
        String result = CalculatorLogic.calculateResult(num1: _state.num1, num2: n2, operation: _state.operation);
        if (buttonText == "M+") memo += double.parse(result);
        if (buttonText == "M-") memo -= double.parse(result);

        String history = _state.lastOperationIsUnary
            ? "${_state.history} = $result"
            : CalculatorLogic.updateHistory(_state.history, _state.operation, _state.num1, false, n2, result);

        _state = _state.copyWith(output: result, history: history, currentInput: result, operation: "", memory: memo);
      } else if (buttonText.startsWith("M")) {
        if (buttonText == "M+") memo += n2;
        if (buttonText == "M-") memo -= n2;
        _state = _state.copyWith(memory: memo);
      }
    }
  }

  void _handleUnary(String op) {
    if (_state.currentInput.isNotEmpty) {
      double val = double.parse(_state.currentInput);
      String result = CalculatorLogic.calculateUnary(input: val, operation: op);
      String history = CalculatorLogic.updateHistoryUnary(val, op, result, _state.history);
      _state = _state.copyWith(
        currentInput: result,
        output: result.truncate(10),
        history: history,
        lastOperationIsUnary: true,
      );
    }
  }

  void _handleNumber(String buttonText) {
    String current = _state.currentInput;
    if (buttonText == "00" && (current == "" || current == "0")) return;

    if (_state.history.contains("=")) {
      if (buttonText == "00") return;
      String val = (buttonText == ".") ? "0." : buttonText;
      _state = _state.copyWith(
        currentInput: val,
        output: val,
        history: "",
        num1: 0,
        operation: "",
        lastOperationIsUnary: false,
      );
    } else {
      if (current == "0" && buttonText != ".") {
        current = buttonText;
      } else {
        if (buttonText == "." && current.contains(".")) return;
        if (buttonText == "." && current.isEmpty) current = "0";
        current += buttonText;
      }
      _state = _state.copyWith(currentInput: current, output: current);
    }
  }

  String memoryDisplay() {
    if (_state.memory == 0) {
      return "";
    } else {
      return "M = ${_state.memory.toString().cleanPointZero().truncate(10)}";
    }
  }
}
