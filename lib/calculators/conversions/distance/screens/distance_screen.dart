// lib/screens/distance_screen.dart

import 'dart:async';

import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/calculators/basic_calc/services/history_export_service.dart';
import 'package:calculators/shared/theme/theme_manager.dart' as shared_theme;
import 'package:calculators/shared/widgets/menu_drawer.dart';
import 'package:calculators/shared/widgets/photo_credit_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../../../../utils/i18n/local_number_symbols.dart';
import '../controllers/distance_controller.dart';
import '../models/distance_state.dart';

class DistanceScreen extends StatefulWidget {
  const DistanceScreen({super.key});

  @override
  State<DistanceScreen> createState() => _DistanceScreenState();
}

class _DistanceScreenState extends State<DistanceScreen> {
  static const Key _copyButtonKey = ValueKey<String>('distance.copy');
  static const Key _saveButtonKey = ValueKey<String>('distance.save');

  final DistanceController _controller = DistanceController();
  final shared_theme.ThemeManager _themeManager = GetIt.I<shared_theme.ThemeManager>();
  final symbols = GetIt.I<LocalNumberSymbols>();
  final FocusNode _keyboardFocusNode = FocusNode(debugLabel: 'distance_keyboard_focus');

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateUI);
    _themeManager.addListener(_updateUI);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _keyboardFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_updateUI);
    _themeManager.removeListener(_updateUI);
    _keyboardFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _updateUI() {
    setState(() {});
  }

  void _requestKeyboardFocus() {
    if (!_keyboardFocusNode.hasFocus) {
      _keyboardFocusNode.requestFocus();
    }
  }

  Color _getButtonColor(String label) {
    if (label == 'C' || label == '⌫') return Colors.redAccent;
    return _themeManager.buttonGroupColor;
  }

  String _buildDistanceReport() {
    final state = _controller.state;
    return [
      '${AppLocalizations.of(context).distanceUnitM}: ${state.meter}',
      '${AppLocalizations.of(context).distanceUnitKm}: ${state.kilometer}',
      '${AppLocalizations.of(context).distanceUnitMi}: ${state.mile}',
      '${AppLocalizations.of(context).distanceUnitFt}: ${state.foot}',
      '${AppLocalizations.of(context).distanceUnitInch}: ${state.inch}',
    ].join('\n');
  }

  void _showDistanceSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _copyDistanceToClipboard(AppLocalizations l10n) async {
    await Clipboard.setData(ClipboardData(text: _buildDistanceReport()));
    _showDistanceSnackBar(l10n.basicHistoryCopied);
  }

  Future<void> _saveDistanceToFile(AppLocalizations l10n) async {
    final content = _buildDistanceReport();

    if (!isHistoryFileExportSupported) {
      _showDistanceSnackBar(l10n.basicHistoryExportUnsupported);
      return;
    }

    try {
      final filePath = await exportHistoryToTextFile(content);
      if (filePath == null || filePath.isEmpty) {
        _showDistanceSnackBar(l10n.basicHistoryExportError);
        return;
      }
      _showDistanceSnackBar(l10n.basicHistoryExported(filePath));
    } catch (_) {
      _showDistanceSnackBar(l10n.basicHistoryExportError);
    }
  }

  Widget _buildFieldCard(String label, String value, DistanceScale scale) {
    final bool isPhone = MediaQuery.sizeOf(context).width < 600;
    final bool isActive = _controller.state.activeUnit == scale;
    final Color borderColor = isActive ? _themeManager.buttonGroupColor : Colors.grey.withAlpha(100);
    final Color backgroundColor = isActive ? Colors.white.withAlpha(210) : Colors.white.withAlpha(150);
    final double titleFontSize = isPhone ? 16 : 20;
    final double valueFontSize = isPhone ? (isActive ? 24 : 21) : (isActive ? 32 : 26);
    final EdgeInsets cardPadding = isPhone
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 10)
        : const EdgeInsets.symmetric(horizontal: 16, vertical: 14);

    return InkWell(
      onTap: () {
        _controller.onUnitSelected(scale);
        _requestKeyboardFocus();
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: cardPadding,
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
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: isActive ? _themeManager.displayTextColor : _themeManager.displayTextColor.withAlpha(230),
                fontSize: valueFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _mapCharacterToButton(String character) {
    if (character.length != 1) return null;
    if (RegExp(r'^[0-9]$').hasMatch(character)) return character;
    switch (character) {
      case '.':
      case ',':
        return symbols.decimalSep;
      case '-':
        return '-';
      case 'c':
      case 'C':
      case '\x1B':
        return 'C';
      default:
        return null;
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    final LogicalKeyboardKey key = event.logicalKey;
    final String keyLabel = key.keyLabel;

    if (key == LogicalKeyboardKey.backspace) {
      _controller.onButtonPressed('⌫');
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.escape || key == LogicalKeyboardKey.delete) {
      _controller.onButtonPressed('C');
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.numpadDecimal) {
      _controller.onButtonPressed(symbols.decimalSep);
      return KeyEventResult.handled;
    }

    if (RegExp(r'^[0-9]$').hasMatch(keyLabel)) {
      _controller.onButtonPressed(keyLabel);
      return KeyEventResult.handled;
    }

    if (keyLabel == '.' || keyLabel == ',') {
      _controller.onButtonPressed(symbols.decimalSep);
      return KeyEventResult.handled;
    }

    if (keyLabel == '-') {
      _controller.onButtonPressed('-');
      return KeyEventResult.handled;
    }

    final String? mapped = event.character == null ? null : _mapCharacterToButton(event.character!);
    if (mapped != null) {
      _controller.onButtonPressed(mapped);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  Widget _buildButton(String label) {
    final bool isPhone = MediaQuery.sizeOf(context).width < 600;
    final EdgeInsets buttonPadding = isPhone
        ? const EdgeInsets.symmetric(horizontal: 1.5, vertical: 1.0)
        : const EdgeInsets.all(6.0);
    final EdgeInsets contentPadding = isPhone
        ? const EdgeInsets.symmetric(horizontal: 6, vertical: 4)
        : const EdgeInsets.all(12);
    final double fontSize = isPhone ? 16 : 20;

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
          onPressed: () {
            _controller.onButtonPressed(label);
            _requestKeyboardFocus();
          },
          child: Text(
            label,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final mediaSize = MediaQuery.sizeOf(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;
    final bool isDesktopLike = mediaSize.width >= 768;
    final bool isPhone = mediaSize.width < 600;
    final double keyboardBottomPadding = isPhone ? (bottomInset + 8.0).clamp(8.0, 24.0).toDouble() : 50.0;
    final double keyboardHeight = (mediaSize.height * (isDesktopLike ? 0.36 : (isPhone ? 0.36 : 0.50)))
        .clamp(isDesktopLike ? 260.0 : (isPhone ? 215.0 : 300.0), isDesktopLike ? 430.0 : 560.0)
        .toDouble();

    return Focus(
      focusNode: _keyboardFocusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Container(
        decoration: _themeManager.backgroundDecoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(l10n.distanceTitle),
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
                            padding: EdgeInsets.fromLTRB(
                              isPhone ? 16 : 24,
                              isPhone ? 24 : 40,
                              isPhone ? 16 : 24,
                              isPhone ? 8 : 12,
                            ),
                            color: Colors.white.withAlpha(150),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        key: _copyButtonKey,
                                        onPressed: () => unawaited(_copyDistanceToClipboard(l10n)),
                                        tooltip: l10n.basicHistoryCopy,
                                        icon: const Icon(Icons.content_copy_outlined),
                                        color: _themeManager.displayTextColor,
                                      ),
                                      IconButton(
                                        key: _saveButtonKey,
                                        onPressed: () => unawaited(_saveDistanceToFile(l10n)),
                                        tooltip: l10n.basicHistorySave,
                                        icon: const Icon(Icons.save_alt_outlined),
                                        color: _themeManager.displayTextColor,
                                      ),
                                    ],
                                  ),
                                ),
                                _buildFieldCard(l10n.distanceUnitM, _controller.state.meter, DistanceScale.meter),
                                SizedBox(height: isPhone ? 8 : 12),
                                _buildFieldCard(
                                  l10n.distanceUnitKm,
                                  _controller.state.kilometer,
                                  DistanceScale.kilometer,
                                ),
                                SizedBox(height: isPhone ? 8 : 12),
                                _buildFieldCard(l10n.distanceUnitMi, _controller.state.mile, DistanceScale.mile),
                                SizedBox(height: isPhone ? 8 : 12),
                                _buildFieldCard(l10n.distanceUnitFt, _controller.state.foot, DistanceScale.foot),
                                SizedBox(height: isPhone ? 8 : 12),
                                _buildFieldCard(l10n.distanceUnitInch, _controller.state.inch, DistanceScale.inch),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, isPhone ? 2 : 5, 8, keyboardBottomPadding),
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
                                          child: Row(
                                            children: [_buildButton('7'), _buildButton('8'), _buildButton('9')],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [_buildButton('4'), _buildButton('5'), _buildButton('6')],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [_buildButton('1'), _buildButton('2'), _buildButton('3')],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(children: [_buildButton('0'), _buildButton(symbols.decimalSep)]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
      ),
    );
  }
}
