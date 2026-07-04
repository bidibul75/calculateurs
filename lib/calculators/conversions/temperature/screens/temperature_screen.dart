import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/shared/theme/theme_manager.dart' as shared_theme;
import 'package:calculators/shared/widgets/menu_drawer.dart';
import 'package:calculators/shared/widgets/photo_credit_link.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../utils/i18n/local_number_symbols.dart';
import '../controllers/temperature_controller.dart';
import '../models/temperature_state.dart';

class TemperatureScreen extends StatefulWidget {
  const TemperatureScreen({super.key});

  @override
  State<TemperatureScreen> createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {
  final TemperatureController _controller = TemperatureController();
  final shared_theme.ThemeManager _themeManager = GetIt.I<shared_theme.ThemeManager>();
  final symbols = GetIt.I<LocalNumberSymbols>();

  @override
  void initState() {
    super.initState();
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

  Color _getButtonColor(String label) {
    if (label == 'C' || label == '⌫') return Colors.redAccent;
    return _themeManager.buttonGroupColor;
  }

  Widget _buildFieldCard(String label, String value, TemperatureScale scale) {
    final bool isActive = _controller.state.activeScale == scale;
    final Color borderColor = isActive ? _themeManager.buttonGroupColor : Colors.grey.withAlpha(100);
    final Color backgroundColor = isActive ? Colors.white.withAlpha(210) : Colors.white.withAlpha(150);

    return InkWell(
      onTap: () => _controller.onScaleSelected(scale),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: isActive ? 2.4 : 1.4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: _themeManager.displayTextColor.withAlpha(190),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: isActive ? _themeManager.displayTextColor : _themeManager.displayTextColor.withAlpha(230),
                fontSize: isActive ? 32 : 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String label) {
    final bool isPhone = MediaQuery.sizeOf(context).width < 600;
    final EdgeInsets buttonPadding = isPhone
        ? const EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0)
        : const EdgeInsets.all(6.0);
    final EdgeInsets contentPadding = isPhone
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 6)
        : const EdgeInsets.all(12);
    final double fontSize = isPhone ? 18 : 20;

    return Expanded(
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

  Widget _buildEnterButton(String label) {
    final bool isPhone = MediaQuery.sizeOf(context).width < 600;
    final EdgeInsets buttonPadding = isPhone
        ? const EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0)
        : const EdgeInsets.all(6.0);
    final EdgeInsets contentPadding = isPhone
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 6)
        : const EdgeInsets.all(12);
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
        onPressed: () => _controller.onButtonPressed(TemperatureController.actionEnter),
        child: Text(label, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state;
    final l10n = AppLocalizations.of(context);
    final mediaSize = MediaQuery.sizeOf(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;
    final bool isDesktopLike = mediaSize.width >= 768;
    final bool isPhone = mediaSize.width < 600;
    final double keyboardBottomPadding = isPhone ? (bottomInset + 24.0).clamp(22.0, 52.0).toDouble() : 50.0;
    final double keyboardHeight = (mediaSize.height * (isDesktopLike ? 0.36 : (isPhone ? 0.42 : 0.50)))
        .clamp(isDesktopLike ? 260.0 : (isPhone ? 245.0 : 300.0), isDesktopLike ? 430.0 : 560.0)
        .toDouble();

    return Container(
      decoration: _themeManager.backgroundDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(l10n.temperatureTitle),
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
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(24, 40, 24, 12),
                          color: Colors.white.withAlpha(150),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildFieldCard(l10n.temperatureLabelCelsius, state.celsius, TemperatureScale.celsius),
                              const SizedBox(height: 12),
                              _buildFieldCard(l10n.temperatureLabelFahrenheit, state.fahrenheit, TemperatureScale.fahrenheit),
                              const SizedBox(height: 12),
                              _buildFieldCard(l10n.temperatureLabelKelvin, state.kelvin, TemperatureScale.kelvin),
                              const SizedBox(height: 12),
                              _buildFieldCard(l10n.temperatureLabelRankine, state.rankine, TemperatureScale.rankine),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 5, 8, keyboardBottomPadding),
                        child: SizedBox(
                          height: keyboardHeight,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
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
            if (_themeManager.isUnsplashBackgroundActive)
              const Positioned(bottom: 16, right: 16, child: PhotoCreditLink()),
          ],
        ),
      ),
    );
  }
}
