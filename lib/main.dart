import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homepage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
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
  double _num1 = 0;
  double _num2 = 0;
  String _operation = "";
  String _history = "";
  String _memo = "0";

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
          if (_operation == "") {
            _num1 = double.parse(_currentInput);
            _currentInput = "";
          }
          _operation = buttonText;
          _history = "$_num1 $_operation";
          break;

        case "=":
        case "M+":
        case "M-":
          if (_currentInput.isNotEmpty) {
            if (_operation.isNotEmpty) {
              _num2 = double.parse(_currentInput);
              _history = "$_num1 $_operation $_num2 =";

              switch (_operation) {
                case "+":
                  _output = (_num1 + _num2).toString();
                  break;
                case "-":
                  _output = (_num1 - _num2).toString();
                  break;
                case "x":
                  _output = (_num1 * _num2).toString();
                  break;
                case "÷":
                  _output = (_num2 == 0)
                      ? "Error : divide by 0"
                      : (_num1 / _num2).toString();
                  break;
                default:
                  _output = "Error : operation";
              }

              _currentInput = _output;
              _operation = "";
            }
            if (buttonText == "M-") {
              _memo = (double.parse(_memo) - double.parse(_currentInput))
                  .toString();
            }
            if (buttonText == "M+") {
              _memo = (double.parse(_memo) + double.parse(_currentInput))
                  .toString();
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
          break;

        case "⌫":
          if (_currentInput.isNotEmpty) {
            _currentInput = _currentInput.substring(
              0,
              _currentInput.length - 1,
            );
            _output = _currentInput.isEmpty ? "0" : _currentInput;
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(24),
          ),
          onPressed: () => _buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculatrice Flutter'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          // Affichage de l'historique
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            child: Text(
              _history,
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
          ),
          // Affichage principal
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Text(
              _output,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          // Boutons
          Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _buildButton(
                      "MC",
                      color: Colors.green[200],
                      textColor: Colors.green[800],
                    ),
                    _buildButton(
                      "MR",
                      color: Colors.green[200],
                      textColor: Colors.green[800],
                    ),
                    _buildButton(
                      "M-",
                      color: Colors.green[200],
                      textColor: Colors.green[800],
                    ),
                    _buildButton(
                      "M+",
                      color: Colors.green[200],
                      textColor: Colors.green[800],
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _buildButton(
                      "C",
                      color: Colors.red[200],
                      textColor: Colors.red[800],
                    ),
                    _buildButton("⌫", color: Colors.red[200], textColor: Colors.red[800]),
                    _buildButton("+/-", color: Colors.grey[300]),
                    _buildButton(
                      "÷",
                      color: Colors.blue[200],
                      textColor: Colors.blue[800],
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _buildButton("7"),
                    _buildButton("8"),
                    _buildButton("9"),
                    _buildButton(
                      "x",
                      color: Colors.blue[200],
                      textColor: Colors.blue[800],
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _buildButton("4"),
                    _buildButton("5"),
                    _buildButton("6"),
                    _buildButton(
                      "-",
                      color: Colors.blue[200],
                      textColor: Colors.blue[800],
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _buildButton("1"),
                    _buildButton("2"),
                    _buildButton("3"),
                    _buildButton(
                      "+",
                      color: Colors.blue[200],
                      textColor: Colors.blue[800],
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _buildButton("0"),
                    _buildButton("."),
                    _buildButton(
                      "=",
                      color: Colors.green[200],
                      textColor: Colors.green[800],
                    ),
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
