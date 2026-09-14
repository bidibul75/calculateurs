// lib/calculators/finance/percentage/screens/percentage_screen.dart

import 'dart:async';

import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/shared/services/history_export_service.dart';
import 'package:calculators/shared/theme/theme_manager.dart' as shared_theme;
import 'package:calculators/shared/widgets/menu_drawer.dart';
import 'package:calculators/shared/widgets/photo_credit_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../../../../utils/i18n/local_number_symbols.dart';
import '../controllers/percentage_controller.dart';
import '../models/percentage_state.dart';

class PercentageScreen extends StatefulWidget {
  const PercentageScreen({super.key});

  @override
  State<PercentageScreen> createState() => _PercentageScreenState();
}

class _PercentageScreenState extends State<PercentageScreen> {
  static const Key _copyButtonKey = ValueKey<String>('percentage.copy');
  static const Key _saveButtonKey = ValueKey<String>('percentage.save');

  final PercentageController _controller = PercentageController();
  final shared_theme.ThemeManager _themeManager = GetIt.I<shared_theme.ThemeManager>();
  final symbols = GetIt.I<LocalNumberSymbols>();
  final FocusNode _keyboardFocusNode = FocusNode(debugLabel: 'percentage_keyboard_focus');

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

  String _modeLabel(AppLocalizations l10n, PercentageMode mode) {
    return switch (mode) {
      PercentageMode.tax => l10n.percentageModeTax,
      PercentageMode.discount => l10n.percentageModeDiscount,
      PercentageMode.increase => l10n.percentageModeIncrease,
      PercentageMode.tip => l10n.percentageModeTip,
    };
  }

  String _fieldLabel(AppLocalizations l10n, PercentageField field) {
    final mode = _controller.state.mode;
    return switch (field) {
      PercentageField.primary => switch (mode) {
          PercentageMode.tax => l10n.percentageTaxNet,
          PercentageMode.discount => l10n.percentageOriginal,
          PercentageMode.increase => l10n.percentageOriginal,
          PercentageMode.tip => l10n.percentageBill,
        },
      PercentageField.rate => switch (mode) {
          PercentageMode.tax => l10n.percentageTaxRate,
          PercentageMode.discount => l10n.percentageDiscountRate,
          PercentageMode.increase => l10n.percentageIncreaseRate,
          PercentageMode.tip => l10n.percentageTipRate,
        },
      PercentageField.delta => switch (mode) {
          PercentageMode.tax => l10n.percentageTaxAmount,
          PercentageMode.discount => l10n.percentageDiscountAmount,
          PercentageMode.increase => l10n.percentageIncreaseAmount,
          PercentageMode.tip => l10n.percentageTipAmount,
        },
      PercentageField.result => switch (mode) {
          PercentageMode.tax => l10n.percentageTaxGross,
          PercentageMode.discount => l10n.percentageFinal,
          PercentageMode.increase => l10n.percentageFinal,
          PercentageMode.tip => l10n.percentageTotal,
        },
    };
  }

  String _fieldValue(PercentageField field) {
    final state = _controller.state;
    return switch (field) {
      PercentageField.primary => state.primary,
      PercentageField.rate => state.rate,
      PercentageField.delta => state.delta,
      PercentageField.result => state.result,
    };
  }

  String _buildReport(AppLocalizations l10n) {
    final state = _controller.state;
    return [
      l10n.percentageTitle,
      _modeLabel(l10n, state.mode),
      '${_fieldLabel(l10n, PercentageField.primary)}: ${state.primary}',
      '${_fieldLabel(l10n, PercentageField.rate)}: ${state.rate}',
      '${_fieldLabel(l10n, PercentageField.delta)}: ${state.delta}',
      '${_fieldLabel(l10n, PercentageField.result)}: ${state.result}',
    ].join('\n');
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _copyToClipboard(AppLocalizations l10n) async {
    await Clipboard.setData(ClipboardData(text: _buildReport(l10n)));
    _showSnackBar(l10n.basicHistoryCopied);
  }

  Future<void> _saveToFile(AppLocalizations l10n) async {
    final content = _buildReport(l10n);
    if (!isHistoryFileExportSupported) {
      _showSnackBar(l10n.basicHistoryExportUnsupported);
      return;
    }
    try {
      final filePath = await exportHistoryToTextFile(content);
      if (filePath == null || filePath.isEmpty) {
        _showSnackBar(l10n.basicHistoryExportError);
        return;
      }
      _showSnackBar(l10n.basicHistoryExported(filePath));
    } catch (_) {
      _showSnackBar(l10n.basicHistoryExportError);
    }
  }

  Widget _buildModeChip(AppLocalizations l10n, PercentageMode mode) {
    final bool selected = _controller.state.mode == mode;
    return FilterChip(
      label: Text(_modeLabel(l10n, mode)),
      selected: selected,
      onSelected: (_) {
        _controller.onModeSelected(mode);
        _requestKeyboardFocus();
      },
      selectedColor: _themeManager.buttonGroupColor.withAlpha(180),
      checkmarkColor: _themeManager.buttonTextColor,
      labelStyle: TextStyle(
        color: selected ? _themeManager.buttonTextColor : _themeManager.displayTextColor,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: Colors.white.withAlpha(160),
      side: BorderSide(
        color: selected ? _themeManager.buttonGroupColor : Colors.grey.withAlpha(100),
      ),
    );
  }

  Widget _buildFieldCard(AppLocalizations l10n, PercentageField field) {
    final bool isPhone = MediaQuery.sizeOf(context).width < 600;
    final bool isActive = _controller.state.activeField == field;
    final Color borderColor = isActive ? _themeManager.buttonGroupColor : Colors.grey.withAlpha(100);
    final Color backgroundColor = isActive ? Colors.white.withAlpha(210) : Colors.white.withAlpha(150);
    final double titleFontSize = isPhone ? 12.5 : 14.5;
    final double valueFontSize = isPhone ? (isActive ? 20 : 18) : (isActive ? 26 : 22);
    final EdgeInsets cardPadding = isPhone
        ? const EdgeInsets.symmetric(horizontal: 10, vertical: 8)
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
    final double cardMinHeight = isPhone ? 48 : 58;
    final String value = isActive ? _controller.state.currentInput : _fieldValue(field);
    final String suffix = field == PercentageField.rate ? ' %' : '';

    return InkWell(
      onTap: () {
        _controller.onFieldSelected(field);
        _requestKeyboardFocus();
      },
      borderRadius: BorderRadius.circular(10),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: cardMinHeight),
        child: Container(
          width: double.infinity,
          padding: cardPadding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: isActive ? 2.4 : 1.4),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  _fieldLabel(l10n, field),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _themeManager.displayTextColor.withAlpha(190),
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  '$value$suffix',
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isActive ? _themeManager.displayTextColor : _themeManager.displayTextColor.withAlpha(230),
                    fontSize: valueFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
    final double keyboardBottomPadding =
        isPhone ? (bottomInset + 28.0).clamp(28.0, 56.0).toDouble() : 50.0;
    final double keyboardHeight = (mediaSize.height * (isDesktopLike ? 0.34 : (isPhone ? 0.34 : 0.48)))
        .clamp(isDesktopLike ? 240.0 : (isPhone ? 200.0 : 280.0), isDesktopLike ? 400.0 : 520.0)
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
            title: Text(l10n.percentageTitle),
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
                            color: Colors.white.withAlpha(150),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  padding: EdgeInsets.fromLTRB(
                                    isPhone ? 16 : 24,
                                    isPhone ? 16 : 28,
                                    isPhone ? 16 : 24,
                                    isPhone ? 8 : 12,
                                  ),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minHeight: constraints.maxHeight - 20),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  key: _copyButtonKey,
                                                  onPressed: () => unawaited(_copyToClipboard(l10n)),
                                                  tooltip: l10n.basicHistoryCopy,
                                                  icon: const Icon(Icons.content_copy_outlined),
                                                  color: _themeManager.displayTextColor,
                                                ),
                                                IconButton(
                                                  key: _saveButtonKey,
                                                  onPressed: () => unawaited(_saveToFile(l10n)),
                                                  tooltip: l10n.basicHistorySave,
                                                  icon: const Icon(Icons.save_alt_outlined),
                                                  color: _themeManager.displayTextColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: [
                                              for (final mode in PercentageMode.values)
                                                _buildModeChip(l10n, mode),
                                            ],
                                          ),
                                          SizedBox(height: isPhone ? 12 : 16),
                                          _buildFieldCard(l10n, PercentageField.primary),
                                          SizedBox(height: isPhone ? 8 : 12),
                                          _buildFieldCard(l10n, PercentageField.rate),
                                          SizedBox(height: isPhone ? 8 : 12),
                                          _buildFieldCard(l10n, PercentageField.delta),
                                          SizedBox(height: isPhone ? 8 : 12),
                                          _buildFieldCard(l10n, PercentageField.result),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
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
