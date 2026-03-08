// lib/calculators/health/bmi/screens/bmi_screen.dart

import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:flutter/material.dart';
import 'package:calculators/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/bmi_controller.dart';
import '../services/bmi_logic.dart';
import '../../../basic_calc/screens/theme/theme_manager.dart';
import '../../../basic_calc/screens/menu_drawer.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  final BmiController _controller = BmiController();
  final ThemeManager _themeManager = GetIt.I<ThemeManager>();
  final symbols = GetIt.I<LocalNumberSymbols>();
  bool _isInitialized = false;

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
      _controller.initialize(l10n.bmiPromptHeight, l10n.bmiPromptWeight, l10n.bmiPromptResult);
      _isInitialized = true;
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

  /// Launch photo credits (photographer and photo page on Unsplash)
  Future<void> _launchPhotoCredits() async {
    final Uri url = Uri.parse(
      'https://unsplash.com/fr/photos/champ-dherbe-verte-pendant-la-journee-5HI7Ea3yD-w?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch photo credits');
    }
  }

  /// Determines button color
  Color _getButtonColor(String label) {
    if (label == 'C' || label == "⌫") return Colors.redAccent;
    return _themeManager.buttonGroupColor;
  }

  /// Builds an individual button
  Widget _buildButton(String label, {int flex = 1}) {
    return Expanded(
      flex: flex,
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
              side: BorderSide(color: Colors.grey[200]!, width: 2.0),
            ),
            padding: const EdgeInsets.all(12),
          ),
          onPressed: () => _controller.onButtonPressed(label),
          child: Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  /// Builds the large Enter button
  Widget _buildEnterButton() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
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
          padding: const EdgeInsets.all(12),
        ),
        onPressed: () => _controller.onButtonPressed('Enter'),
        child: Text('Enter', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                      // Display area with semi-transparent background
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                          alignment: Alignment.bottomRight,
                          color: Colors.white.withAlpha(150),
                          child: SingleChildScrollView(
                            reverse: true,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Prompt (e.g., "Height (m):" or "Weight (kg):")
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    state.prompt,
                                    style: TextStyle(
                                      color: _themeManager.displayTextColor.withAlpha(180),
                                      fontSize: 24,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Output display
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    state.output,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: _themeManager.displayTextColor,
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
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
                                        //color: _themeManager.displayTextColor.withAlpha(190),
                                        color: state.output == "Obese" ? Colors.red : Colors.green,
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
                      ),

                      // Button grid area
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 5, 8, 50),
                        child: SizedBox(
                          height: 320,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Left side: numeric keypad
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    Row(children: [_buildButton('C'), _buildButton('⌫')]),
                                    Row(children: [_buildButton('7'), _buildButton('8'), _buildButton('9')]),
                                    Row(children: [_buildButton('4'), _buildButton('5'), _buildButton('6')]),
                                    Row(children: [_buildButton('1'), _buildButton('2'), _buildButton('3')]),
                                    Row(children: [_buildButton('0'), _buildButton(symbols.decimalSep)]),
                                  ],
                                ),
                              ),

                              // Right side: large Enter button
                              Expanded(flex: 1, child: _buildEnterButton()),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Photo credit at the bottom right
            Positioned(
              bottom: 16,
              right: 16,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _launchPhotoCredits(),
                  child: Text(
                    l10n.photoCredit,
                    style: TextStyle(color: Colors.white, fontSize: 12, decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
