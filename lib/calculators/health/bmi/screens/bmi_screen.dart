// lib/calculators/health/bmi/screens/bmi_screen.dart

import 'dart:async';

import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:flutter/material.dart';
import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/shared/theme/theme_manager.dart' as shared_theme;
import 'package:calculators/shared/widgets/photo_credit_link.dart';
import 'package:get_it/get_it.dart';
import '../controllers/bmi_controller.dart';
import '../services/bmi_logic.dart';
import '../../../../shared/widgets/menu_drawer.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  final BmiController _controller = BmiController();
  final shared_theme.ThemeManager _themeManager = GetIt.I<shared_theme.ThemeManager>();
  final symbols = GetIt.I<LocalNumberSymbols>();
  bool _isInitialized = false;
  bool _isRestored = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateUI);
    _themeManager.addListener(_updateUI);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize controller with localized prompts only once
    if (!_isInitialized) {
      final l10n = AppLocalizations.of(context);
      _controller.initialize(
        l10n.bmiPromptHeight,
        l10n.bmiPromptWeight,
        l10n.bmiPromptResult,
        l10n.bmiErrorInvalidHeight,
        l10n.bmiErrorInvalidWeight,
        l10n.bmiErrorGeneric,
      );
      _isInitialized = true;
    }

    if (!_isRestored) {
      _isRestored = true;
      unawaited(_controller.restorePersistedState());
    }
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


  /// Determines button color
  Color _getButtonColor(String label) {
    if (label == 'C' || label == "⌫") return Colors.redAccent;
    return _themeManager.buttonGroupColor;
  }

  /// Determines category text color based on BMI category
  Color _getCategoryColor(String bmiOutput) {
    final category = BmiLogic.getBmiCategory(bmiOutput);
    switch (category) {
      case 'underweight':
        return Colors.blue;
      case 'normal':
        return Colors.green;
      case 'overweight':
        return Colors.orange;
      case 'obese':
        return Colors.red;
      default:
        return _themeManager.displayTextColor;
    }
  }

  /// Builds an individual button
  Widget _buildButton(String label, {int flex = 1}) {
    final bool isPhone = MediaQuery.sizeOf(context).width < 600;
    final EdgeInsets buttonPadding = isPhone
        ? const EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0)
        : const EdgeInsets.all(6.0);
    final EdgeInsets contentPadding = isPhone ? const EdgeInsets.symmetric(horizontal: 8, vertical: 6) : const EdgeInsets.all(12);
    final double fontSize = isPhone ? 18 : 20;
    return Expanded(
      flex: flex,
      child: Padding(
        padding: buttonPadding,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _getButtonColor(label),
            foregroundColor: _themeManager.buttonTextColor,
            elevation: 6,
            shadowColor: Colors.black.withAlpha(120),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey[200]!, width: 2.0),
            ),
            padding: contentPadding,
          ),
          onPressed: () => _controller.onButtonPressed(label),
          child: Text(label, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  /// Builds the large Enter button
  Widget _buildEnterButton(String label) {
    final bool isPhone = MediaQuery.sizeOf(context).width < 600;
    final EdgeInsets buttonPadding = isPhone
        ? const EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0)
        : const EdgeInsets.all(6.0);
    final EdgeInsets contentPadding = isPhone ? const EdgeInsets.symmetric(horizontal: 8, vertical: 6) : const EdgeInsets.all(12);
    final double fontSize = isPhone ? 18 : 20;
    return Padding(
      padding: buttonPadding,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: _themeManager.buttonTextColor,
          elevation: 6,
          shadowColor: Colors.black.withAlpha(120),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey[200]!, width: 2.0),
          ),
          padding: contentPadding,
        ),
        onPressed: () => _controller.onButtonPressed(BmiController.actionEnter),
        child: Text(label, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
      ),
    );
  }

  String _localizedBmiCategory(AppLocalizations l10n, String bmiOutput) {
    final category = BmiLogic.getBmiCategory(bmiOutput);
    switch (category) {
      case 'underweight':
        return l10n.bmiCategoryUnderweight;
      case 'normal':
        return l10n.bmiCategoryNormal;
      case 'overweight':
        return l10n.bmiCategoryOverweight;
      case 'obese':
        return l10n.bmiCategoryObese;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state;
    final l10n = AppLocalizations.of(context);
    final bool hasComputedBmi = state.weight != null && state.prompt == l10n.bmiPromptResult;
    final String bmiCategory = hasComputedBmi ? _localizedBmiCategory(l10n, state.output) : '';
    final mediaSize = MediaQuery.sizeOf(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;
    final bool isDesktopLike = mediaSize.width >= 768;
    final bool isPhone = mediaSize.width < 600;
    final double keyboardBottomPadding = isPhone ? (bottomInset + 24.0).clamp(28.0, 56.0).toDouble() : 50.0;
    final double keyboardHeight = (mediaSize.height * (isDesktopLike ? 0.36 : (isPhone ? 0.42 : 0.50)))
        .clamp(isDesktopLike ? 260.0 : (isPhone ? 245.0 : 300.0), isDesktopLike ? 430.0 : 560.0)
        .toDouble();
    // Responsive height for output display (reserves space to prevent vertical shift on error)
    final double outputDisplayHeight = (mediaSize.height * (isDesktopLike ? 0.15 : 0.18))
        .clamp(isDesktopLike ? 80.0 : 90.0, isDesktopLike ? 120.0 : 140.0)
        .toDouble();

    return Container(
      decoration: _themeManager.backgroundDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(l10n.bmiTitle),
          backgroundColor: Colors.white.withAlpha(150),
          foregroundColor: Colors.grey[150],
          iconTheme: IconThemeData(color: Colors.grey[150]),
          elevation: 0,
          leading: MenuDrawer(themeManager: _themeManager),
        ),
        body: Stack(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: SizedBox.expand(
                  child: Column(
                    children: [
                       // Fixed prompt area (top, prevents vertical shift)
                       Container(
                         padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                         color: Colors.white.withAlpha(150),
                         child: Align(
                           alignment: Alignment.centerLeft,
                           child: Text(
                             state.prompt,
                             style: TextStyle(
                               color: _themeManager.displayTextColor.withAlpha(180),
                               fontSize: 24,
                             ),
                           ),
                         ),
                       ),

                       // Output display with reserved height (prevents vertical shift)
                       Expanded(
                         child: Container(
                           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                           color: Colors.white.withAlpha(150),
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.stretch,
                             children: [
                               // Reserved space for output
                               SizedBox(
                                 height: outputDisplayHeight,
                                 child: Align(
                                   alignment: Alignment.centerRight,
                                   child: FittedBox(
                                     fit: BoxFit.scaleDown,
                                     alignment: Alignment.centerRight,
                                     child: Text(
                                       state.output,
                                       maxLines: 1,
                                       style: TextStyle(
                                         color: state.hasError ? Colors.red : _themeManager.displayTextColor,
                                         fontSize: state.hasError ? 30 : 50,
                                         fontWeight: FontWeight.bold,
                                       ),
                                     ),
                                   ),
                                 ),
                               ),

                               if (bmiCategory.isNotEmpty) ...[
                                 const SizedBox(height: 8),
                                 Align(
                                   alignment: Alignment.centerRight,
                                   child: Text(
                                     bmiCategory,
                                     style: TextStyle(
                                       color: _getCategoryColor(state.output),
                                       fontSize: 20,
                                       fontWeight: FontWeight.w600,
                                     ),
                                   ),
                                 ),
                               ],
                             ],
                           ),
                         ),
                       ),
                      // Button grid area
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 5, 8, keyboardBottomPadding),
                        child: SizedBox(
                           height: keyboardHeight,
                           child: Row(
                             crossAxisAlignment: CrossAxisAlignment.stretch,
                             children: [
                               // Left side: numeric keypad
                               Expanded(
                                 flex: 3,
                                 child: SizedBox.expand(
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     children: [
                                       Expanded(child: Row(children: [_buildButton('C'), _buildButton('⌫')])),
                                       Expanded(
                                         child: Row(children: [_buildButton('7'), _buildButton('8'), _buildButton('9')]),
                                       ),
                                       Expanded(
                                         child: Row(children: [_buildButton('4'), _buildButton('5'), _buildButton('6')]),
                                       ),
                                       Expanded(
                                         child: Row(children: [_buildButton('1'), _buildButton('2'), _buildButton('3')]),
                                       ),
                                       Expanded(
                                         child: Row(children: [_buildButton('0'), _buildButton(symbols.decimalSep)]),
                                       ),
                                     ],
                                   ),
                                 ),
                               ),

                               // Right side: large Enter button
                               Expanded(flex: 1, child: _buildEnterButton(l10n.bmiActionEnter)),
                             ],
                           ),
                         ),
                       ),
                    ],
                  ),
                ),
              ),
            ),
            // Photo credit at the bottom right, only when the Unsplash background is active.
            if (_themeManager.isUnsplashBackgroundActive)
              const Positioned(
                bottom: 16,
                right: 16,
                child: PhotoCreditLink(),
              ),
          ],
        ),
      ),
    );
  }
}
