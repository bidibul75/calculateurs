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
  Widget _buildButton(String label, {required bool compact}) {
    final double fontSize = compact ? 14 : 20;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(compact ? 3.0 : 6.0),
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
                width: compact ? 1.2 : 2.0, // Width of border
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: compact ? 4 : 8, vertical: compact ? 6 : 12),
            minimumSize: Size.fromHeight(compact ? 34 : 44),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () => _controller.onButtonPressed(label),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              softWrap: false,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
          ),
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double availableHeight = constraints.maxHeight;
                    final bool isCompactHeight = availableHeight < 700;
                    // Compute keyboard height from actual available space to avoid vertical overflow.
                    final double keyboardHeight =
                        (availableHeight * (isDesktopLike ? 0.44 : (isCompactHeight ? 0.52 : 0.50)))
                            .clamp(isDesktopLike ? 300.0 : (isCompactHeight ? 250.0 : 320.0), isDesktopLike ? 560.0 : 640.0)
                            .toDouble();
                    final double keyboardBottomPadding = isCompactHeight ? 8.0 : 50.0;

                    return Column(
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
                      padding: EdgeInsets.fromLTRB(8, 5, 8, keyboardBottomPadding),
                      child: SizedBox(
                        height: keyboardHeight,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  _buildButton('MC', compact: isCompactHeight),
                                  _buildButton('MR', compact: isCompactHeight),
                                  _buildButton('M+', compact: isCompactHeight),
                                  _buildButton('M-', compact: isCompactHeight),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  _buildButton('x²', compact: isCompactHeight),
                                  _buildButton('√', compact: isCompactHeight),
                                  _buildButton('1/x', compact: isCompactHeight),
                                  _buildButton('x^y', compact: isCompactHeight),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  _buildButton('C', compact: isCompactHeight),
                                  _buildButton('⌫', compact: isCompactHeight),
                                  _buildButton('+/-', compact: isCompactHeight),
                                  _buildButton('÷', compact: isCompactHeight),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  _buildButton('7', compact: isCompactHeight),
                                  _buildButton('8', compact: isCompactHeight),
                                  _buildButton('9', compact: isCompactHeight),
                                  _buildButton('x', compact: isCompactHeight),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  _buildButton('4', compact: isCompactHeight),
                                  _buildButton('5', compact: isCompactHeight),
                                  _buildButton('6', compact: isCompactHeight),
                                  _buildButton('-', compact: isCompactHeight),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  _buildButton('1', compact: isCompactHeight),
                                  _buildButton('2', compact: isCompactHeight),
                                  _buildButton('3', compact: isCompactHeight),
                                  _buildButton('+', compact: isCompactHeight),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  _buildButton('0', compact: isCompactHeight),
                                  _buildButton('00', compact: isCompactHeight),
                                  _buildButton(symbols.decimalSep, compact: isCompactHeight),
                                  _buildButton('=', compact: isCompactHeight),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                      ],
                    );
                  },
                ),
              ),
            ),
            // Photo credit at the bottom right
            if (mediaSize.height >= 700)
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
