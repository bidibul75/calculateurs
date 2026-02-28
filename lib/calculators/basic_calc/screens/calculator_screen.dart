// lib/calculators/basic_calc/sreens/calculator_screen.dart

import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controllers/calculator_controller.dart';
import 'theme/theme_manager.dart';
import 'menu_drawer.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final CalculatorController _controller = CalculatorController();
  final ThemeManager _themeManager = ThemeManager();
  final symbols = GetIt.I<LocalNumberSymbols>();


  @override
  void initState() {
    super.initState();
    // We listen to shifts of the controller to update UI
    _controller.addListener(_updateUI);
    _themeManager.addListener(_updateUI);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateUI);
    _themeManager.removeListener(_updateUI);
    _controller.dispose();
    _themeManager.dispose();
    super.dispose();
  }

  void _updateUI() {
    setState(() {});
  }

  /// Determines button color amongst text
  Color _getButtonColor(String label) {
    if (label == 'C' || label == "⌫") return Colors.redAccent;
    if (['MC', 'MR', 'M+', 'M-'].contains(label)) return Colors.blueGrey;
    if (['÷', 'x', '-', '+', '='].contains(label)) return Colors.orange;
    return _themeManager.buttonGroupColor;
  }

  /// Builds an individual button
  Widget _buildButton(String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _getButtonColor(label),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => _controller.onButtonPressed(label),
          child: Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state;

    return Scaffold(
      backgroundColor: _themeManager.backgroundColor,
      appBar: AppBar(
        title: const Text('Basic calculator'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: MenuDrawer(themeManager: _themeManager),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              alignment: Alignment.bottomRight,
              // Add a ScrollView to prevent overflow when the history is long
              child: SingleChildScrollView(
                reverse: true, // Keep the content pinned to the bottom
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Memory display (aligned to the left)
                    if (_controller.memoryDisplay().isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(_controller.memoryDisplay(), style: TextStyle(color: Colors.amber, fontSize: 24)),
                      ),

                    // History display
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        state.history,
                        style: TextStyle(color: Colors.grey[400], fontSize: 24),
                        textAlign: TextAlign.right,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // FittedBox shrinks the font size if the text is too long
                    FittedBox(
                      fit: BoxFit.scaleDown, // Only shrinks, does not grow
                      alignment: Alignment.centerRight,
                      child: Text(
                        state.output,
                        // Force a single line to trigger shrinking
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 50, // We can even increase the base size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Button grid
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 40, 8, 40),
            child: Column(
              children: [
                Row(children: [_buildButton('MC'), _buildButton('MR'), _buildButton('M+'), _buildButton('M-')]),
                Row(children: [_buildButton('x²'), _buildButton('√'), _buildButton('1/x'), _buildButton('x^y')]),
                Row(children: [_buildButton('C'), _buildButton('⌫'), _buildButton('+/-'), _buildButton('÷')]),
                Row(children: [_buildButton('7'), _buildButton('8'), _buildButton('9'), _buildButton('x')]),
                Row(children: [_buildButton('4'), _buildButton('5'), _buildButton('6'), _buildButton('-')]),
                Row(children: [_buildButton('1'), _buildButton('2'), _buildButton('3'), _buildButton('+')]),
                Row(children: [_buildButton('0'), _buildButton('00'), _buildButton(symbols.decimalSep), _buildButton('=')]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
