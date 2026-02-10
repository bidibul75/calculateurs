import 'package:calculators/calculators/basic_calc/models/calculator_state.dart';
import 'package:calculators/calculators/basic_calc/services/calculator_logic.dart';
import 'package:calculators/calculators/basic_calc/widgets/calc_button.dart';
import 'package:calculators/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  CalculatorState _state = CalculatorState();

  void _buttonPressed(String buttonText) {
    double memo;

    setState(() {
      switch (buttonText) {
        case "C":
          _state = _state.copyWith(output: "0", history: "", currentInput: "", num1: 0, operation: "");
          break;

        case "+":
        case "-":
        case "x":
        case "÷":
        case "x^y":
          if (_state.currentInput.isNotEmpty) {
            double n1 = double.parse(_state.currentInput);
            String op = (buttonText == "x^y") ? "^" : buttonText;
            _state = _state.copyWith(
              num1: n1,
              operation: op,
              currentInput: "",
              history: CalculatorLogic.updateHistory(_state.history, op, n1),
            );
          }
          break;

        case "=":
        case "M+":
        case "M-":
          memo = _state.memory;
          if (_state.currentInput.isNotEmpty) {
            double n2 = double.parse(_state.currentInput);

            if (_state.operation.isNotEmpty) {
              String result = CalculatorLogic.calculateResult(num1: _state.num1, num2: n2, operation: _state.operation);
              if (buttonText == "M+") memo += double.parse(result);
              if (buttonText == "M-") memo -= double.parse(result);
              _state = _state.copyWith(
                output: result,
                history: CalculatorLogic.updateHistory(_state.history, _state.operation, _state.num1, n2, result),
                currentInput: result,
                operation: "",
                memory: memo,
              );
            } else {
              if (buttonText == "M+" || buttonText == "M-") {
                if (buttonText == "M+") memo += n2;
                if (buttonText == "M-") memo -= n2;
                _state = _state.copyWith(memory: memo);
              }
            }
          }
          break;

        case "MR":
          memo = _state.memory;
          _state = _state.copyWith(
            output: memo.toString().cleanPointZero(),
            currentInput: memo.toString().cleanPointZero(),
          );
          break;

        case "MC":
          _state = _state.copyWith(memory: 0);
          break;

        case "x²":
          if (_state.currentInput.isNotEmpty) {
            double val = double.parse(_state.currentInput);
            String result = val.power(2).toString().cleanPointZero();
            _state = _state.copyWith(output: result, history: "${val.cleanDouble()}² = $result", currentInput: result);
          }
          break;

        case "√":
          if (_state.currentInput.isNotEmpty) {
            double val = double.parse(_state.currentInput);
            if (val >= 0) {
              String result = sqrt(val).toString().cleanPointZero();
              _state = _state.copyWith(
                output: result,
                history: "√(${val.cleanDouble()}) = $result",
                currentInput: result,
              );
            } else {
              _state = _state.copyWith(output: "Error", history: "negative √ not allowed");
            }
          }
          break;

        case "+/-":
          if (_state.currentInput.isNotEmpty) {
            String newVal = _state.currentInput.startsWith("-")
                ? _state.currentInput.substring(1)
                : "-${_state.currentInput}";
            _state = _state.copyWith(currentInput: newVal, output: newVal);
          }
          break;

        case "1/x":
          if (_state.currentInput.isNotEmpty) {
            double val = double.parse(_state.currentInput);
            if (val != 0) {
              String result = (1 / val).toString().cleanPointZero();
              _state = _state.copyWith(
                currentInput: result,
                output: result,
                history: "1/${val.cleanDouble()} = $result",
              );
            } else {
              _state = _state.copyWith(output: "Error : div by 0", history: "1/0");
            }
          }
          break;

        case "⌫":
          if (_state.currentInput.isNotEmpty) {
            String newVal = _state.currentInput.substring(0, _state.currentInput.length - 1);
            if (newVal.isEmpty || newVal == "-") newVal = "0";
            _state = _state.copyWith(currentInput: newVal, output: newVal);
          }
          break;

        default:
          String current = _state.currentInput;
          if (buttonText == "00" && (current == "" || current == "0")) return;
          if (_state.history.contains("=")) {
            if (buttonText == "00") return;
            if (buttonText == ".") buttonText = "0.";
            _state = _state.copyWith(currentInput: buttonText, output: buttonText, history: "", num1: 0, operation: "");
          } else {
            if (current == "0" && buttonText != ".") {
              current = buttonText;
            } else {
              // to avoid double points
              if (buttonText == ".") {
                if (current.contains(".")) return;
                if (current == "") current = "0";
              }
              current += buttonText;
            }
            // state update with the new string
            _state = _state.copyWith(currentInput: current, output: current);
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Basic calculator')),
      body: Column(
        children: [
          buildDisplay(),
          const Divider(height: 1),
          Expanded(
            child: Column(
              children: [
                buildButtonRow(["MC", "MR", "M-", "M+"], isMemory: true),
                buildButtonRow(["x²", "√", "x^y", "1/x"], isSpecial: true),
                buildButtonRow(["C", "⌫", "+/-", "÷"], isSpecial: true),
                buildButtonRow(["7", "8", "9", "x"]),
                buildButtonRow(["4", "5", "6", "-"]),
                buildButtonRow(["1", "2", "3", "+"]),
                buildButtonRow(["0", "00", ".", "="]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonRow(List<String> labels, {bool isMemory = false, bool isSpecial = false}) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: labels.map((label) {
          Color? bgColor;
          Color? txtColor;
          if (isMemory) {
            bgColor = Colors.green[400];
            txtColor = Colors.white;
          } else if (label == "=") {
            bgColor = Colors.blue[400];
            txtColor = Colors.white;
          } else if (["C", "⌫"].contains(label)) {
            bgColor = Colors.red[400];
            txtColor = Colors.white;
          } else if (isSpecial || ["x", "-", "+"].contains(label)) {
            bgColor = Colors.amber[400];
            txtColor = Colors.white;
          }
          return CalcButton(text: label, color: bgColor, textColor: txtColor, onPressed: () => _buttonPressed(label));
        }).toList(),
      ),
    );
  }

  Widget buildDisplay() {
    final String memoryDisplay = _state.memory != 0.0 ? "M = ${_state.memory.toString().cleanPointZero()}" : "";

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
      width: double.infinity,
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                memoryDisplay,
                style: TextStyle(fontSize: 16, color: Colors.green[700], fontWeight: FontWeight.bold),
              ),
              Text(_state.history, style: const TextStyle(fontSize: 18, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            _state.output,
            style: const TextStyle(fontSize: 54, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
