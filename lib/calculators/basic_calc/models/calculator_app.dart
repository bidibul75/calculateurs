import 'package:calculators/utils/extensions/extensions.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:calculators/calculators/basic_calc/services/generate_history.dart';

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homepage',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _currentInput = "";
  String _currentInputOld = "";
  double _num1 = 0;
  double _num2 = 0;
  String _operation = "";
  String _operationOld = "";
  String _history = "";
  String _memo = "0";
  String _memory = "";

  void _buttonPressed(String buttonText) {
    setState(() {
      switch (buttonText) {
        case "C":
          _output = "0";
          _currentInput = "";
          _num1 = 0;
          _num2 = 0;
          _operation = "";
          _history = "";
          break;

        case "+":
        case "-":
        case "x":
        case "÷":
          print("jkhhjjh opé : $_operation");
          print("jkljhjh history $_history");
          if (_operation.isEmpty) {
            if (_history.contains("=")) {
              _history = _currentInput;
              print("kljjkkjl contains $_history");
            }
            _num1 = double.parse(_currentInput);
            print(_num1);
            _currentInput = "";
          }

          _operation = buttonText;
          generateHistory(_history, _operation, _num1, _num2, _output);
          break;

        case "x^y":
          if (_currentInput == "" || _currentInput == "0") {
            _output = "Error : divide by 0";
            break;
          }
          if (_operation.isEmpty) {
            _num1 = double.parse(_currentInput);
            _currentInput = "";
            _operation = "^";
            generateHistory(_history, _operation, _num1, _num2, _output);
            break;
          } else {
            if (_currentInput == _num1.toString()) {
              _operation = "^";
              generateHistory(_history, _operation, _num1, _num2, _output);
              break;
            } else {}
          }

        case "=":
        case "M+":
        case "M-":
          if (_currentInput.isNotEmpty) {
            if (_operation.isNotEmpty) {
              _num2 = double.parse(_currentInput);
              switch (_operation) {
                case "+":
                  _output = (_num1 + _num2).toString().cleanPointZero();
                  break;
                case "-":
                  _output = (_num1 - _num2).toString().cleanPointZero();
                  break;
                case "x":
                  _output = (_num1 * _num2).toString().cleanPointZero();
                  break;
                case "÷":
                  _output = (_num2 == 0) ? "Error : divide by 0" : (_num1 / _num2).toString().cleanPointZero();
                  break;
                case "^":
                  if (_num2.isInteger()) {
                    _output = _num1.power(_num2.toInt()).toString().cleanPointZero();
                  } else {
                    _output = "Error : exponent must be an integer";
                  }
                  break;
                default:
                  _output = "Error : operation";
              }

              _currentInput = _output;
              generateHistory(_history, _operation, _num1, _num2, _output);
              _operationOld = _operation;
              _operation = "";
            }
            if (buttonText == "M-") {
              _memo = (double.parse(_memo) - double.parse(_currentInput)).toString();
              _memory = "M";
            }
            if (buttonText == "M+") {
              _memo = (double.parse(_memo) + double.parse(_currentInput)).toString();
              _memory = "M";
            }
          }
          break;

        case "MR":
          _history = "";
          _output = _memo;
          _currentInput = _memo;
          break;

        case "MC":
          _memo = "0";
          _memory = "";
          break;

        case "⌫":
          print("current imput :$_currentInput");
          print("num1 : $_num1");
          print("num2 : $_num2");
          print("operation : $_operation");
          if (_currentInput.isNotEmpty) {
            _currentInput = _currentInput.substring(0, _currentInput.length - 1);
            _output = _currentInput.isEmpty ? "0" : _currentInput;
          } else {
            if (_output.isNotEmpty) {
              if (_output.length > 1) {
                _output = _output.substring(0, _output.length - 1);
              } else {
                _output = "0";
              }
            }
          }
          break;

        case "+/-":
          if (_currentInput.isNotEmpty) {
            if (_currentInput.startsWith('-')) {
              _currentInput = _currentInput.substring(1);
            } else {
              _currentInput = '-$_currentInput';
            }
            _output = _currentInput;
          }
          break;
        case "x²":
          if (_currentInput.isNotEmpty) {
            _currentInputOld = _currentInput;
            _currentInput = (double.parse(_currentInput).power(2)).toString().cleanPointZero();
            _output = _currentInput;
            if (_history.isNotEmpty) {
              generateHistory(_history, _operation, _num1, _num2, _output, square: true);
            } else {
              _history = "$_currentInputOld ² = $_currentInput";
              _num1 = double.parse(_currentInput);
              _operation = "";
            }
          }
          break;
        case "√":
          if (_currentInput.isNotEmpty) {
            _currentInput = (sqrt(double.parse(_currentInput))).toString().cleanPointZero();
            _output = _currentInput;
          }
          break;
        case "1/x":
          if (_currentInput.isNotEmpty) {
            _currentInput = (1 / double.parse(_currentInput)).toString().cleanPointZero();
            _output = _currentInput;
          } else {
            _output = "Error : division by 0";
          }
          break;

        case ".":
          if (!_currentInput.contains(".")) {
            _currentInput += buttonText;
            _output = _currentInput;
          }
          break;

        default:
          if (_currentInput == "0" || _currentInput.contains("Error")) {
            _currentInput = buttonText;
          } else {
            _currentInput += buttonText;
          }
          _output = _currentInput;
      }
    });
  }


  Widget _buildButton(String buttonText, {Color? color, Color? textColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[200],
            foregroundColor: textColor ?? Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(24),
          ),
          onPressed: () => _buttonPressed(buttonText),
          child: Text(buttonText, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculatrice Flutter'), centerTitle: true),
      body: Column(
        children: <Widget>[
          // Memory
          Row(
            children: [
              // Memory
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                child: Text(_memory, style: const TextStyle(fontSize: 20, color: Colors.grey)),
              ),
              // History
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                  child: Text(_history, style: const TextStyle(fontSize: 20, color: Colors.grey)),
                ),
              ),
            ],
          ),
          // Main line
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Text(_output, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
          ),
          const Divider(),
          // Boutons
          Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _buildButton("MC", color: Colors.green[200], textColor: Colors.green[800]),
                    _buildButton("MR", color: Colors.green[200], textColor: Colors.green[800]),
                    _buildButton("M-", color: Colors.green[200], textColor: Colors.green[800]),
                    _buildButton("M+", color: Colors.green[200], textColor: Colors.green[800]),
                  ],
                ),
                // math operations
                Row(
                  children: <Widget>[
                    _buildButton("x²", color: Colors.grey[300], textColor: Colors.black),
                    _buildButton("√", color: Colors.grey[300], textColor: Colors.black),
                    _buildButton("x^y", color: Colors.grey[300], textColor: Colors.black),
                    _buildButton("1/x", color: Colors.grey[300], textColor: Colors.black),
                  ],
                ),

                Row(
                  children: <Widget>[
                    _buildButton("C", color: Colors.red[200], textColor: Colors.red[800]),
                    _buildButton("⌫", color: Colors.red[200], textColor: Colors.red[800]),
                    _buildButton("+/-", color: Colors.grey[300]),
                    _buildButton("÷", color: Colors.blue[200], textColor: Colors.blue[800]),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _buildButton("7"),
                    _buildButton("8"),
                    _buildButton("9"),
                    _buildButton("x", color: Colors.blue[200], textColor: Colors.blue[800]),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _buildButton("4"),
                    _buildButton("5"),
                    _buildButton("6"),
                    _buildButton("-", color: Colors.blue[200], textColor: Colors.blue[800]),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _buildButton("1"),
                    _buildButton("2"),
                    _buildButton("3"),
                    _buildButton("+", color: Colors.blue[200], textColor: Colors.blue[800]),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _buildButton("0"),
                    _buildButton("."),
                    _buildButton("=", color: Colors.green[200], textColor: Colors.green[800]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}