// lib/calculators/basic_calc/sreens/calculator_screen.dart

import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:flutter/material.dart';
import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/shared/theme/theme_manager.dart' as shared_theme;
import 'package:calculators/shared/widgets/photo_credit_link.dart';
import 'package:get_it/get_it.dart';
import '../controllers/calculator_controller.dart';
import '../../../shared/widgets/menu_drawer.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final CalculatorController _controller = CalculatorController();
  final shared_theme.ThemeManager _themeManager = GetIt.I<shared_theme.ThemeManager>();
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
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _getButtonColor(label),
            foregroundColor: _themeManager.buttonTextColor,
            elevation: 6,
            shadowColor: Colors.black.withAlpha(120),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                // Border line
                color: Colors.grey[200]!, // Color of border
                width: 2.0, // Width of border
              ),
            ),
            padding: const EdgeInsets.all(12),
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
    final l10n = AppLocalizations.of(context);
    final mediaSize = MediaQuery.sizeOf(context);
    final bool isDesktopLike = mediaSize.width >= 768;
    final double keyboardHeight =
        (mediaSize.height * (isDesktopLike ? 0.44 : 0.50))
            .clamp(isDesktopLike ? 330.0 : 360.0, isDesktopLike ? 560.0 : 720.0)
            .toDouble();

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/textures/bady-abbas-5HI7Ea3yD-w-unsplash.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(l10n.appTitle),
          backgroundColor: Colors.white.withAlpha(150),
          // Semi-transparent white
          foregroundColor: Colors.grey[150],
          // Text and actions color
          iconTheme: IconThemeData(color: Colors.grey[150]),
          // Icon color
          elevation: 0,
          leading: MenuDrawer(themeManager: _themeManager),
        ),
        body: Stack(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  children: [
                    // Display area with semi-transparent background
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                        alignment: Alignment.bottomRight,
                        color: Colors.white.withAlpha(150), // Semi-transparent white overlay
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
                                  child: Text(
                                    _controller.memoryDisplay(),
                                    style: TextStyle(color: Colors.amber[800], fontSize: 24),
                                  ),
                                ),

                              // History display
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  state.history,
                                  style: TextStyle(color: _themeManager.displayTextColor.withAlpha(180), fontSize: 24),
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
                                  style: TextStyle(
                                    color: _themeManager.displayTextColor,
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

                    // Button grid area
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 5, 8, 50),
                      child: SizedBox(
                        height: keyboardHeight,
                        child: Column(
                          children: [
                            Row(
                              children: [_buildButton('MC'), _buildButton('MR'), _buildButton('M+'), _buildButton('M-')],
                            ),
                            Row(
                              children: [_buildButton('x²'), _buildButton('√'), _buildButton('1/x'), _buildButton('x^y')],
                            ),
                            Row(children: [_buildButton('C'), _buildButton('⌫'), _buildButton('+/-'), _buildButton('÷')]),
                            Row(children: [_buildButton('7'), _buildButton('8'), _buildButton('9'), _buildButton('x')]),
                            Row(children: [_buildButton('4'), _buildButton('5'), _buildButton('6'), _buildButton('-')]),
                            Row(children: [_buildButton('1'), _buildButton('2'), _buildButton('3'), _buildButton('+')]),
                            Row(
                              children: [
                                _buildButton('0'),
                                _buildButton('00'),
                                _buildButton(symbols.decimalSep),
                                _buildButton('='),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Photo credit at the bottom right
            Positioned(
              bottom: 16,
              right: 16,
              child: const PhotoCreditLink(),
            ),
          ],
        ),
      ),
    );
  }
}
