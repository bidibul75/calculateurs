// lib/calculators/basic_calc/screens/calculator_screen.dart

import 'dart:async';

import 'package:calculators/utils/extensions/extensions.dart';
import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/shared/theme/theme_manager.dart' as shared_theme;
import 'package:calculators/shared/widgets/photo_credit_link.dart';
import 'package:get_it/get_it.dart';
import '../controllers/calculator_controller.dart';
import '../models/calculator_history_entry.dart';
import '../models/calculator_state.dart';
import '../../../shared/widgets/menu_drawer.dart';
import 'package:calculators/shared/services/history_export_service.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  static const Key _clearHistoryButtonKey = ValueKey<String>('basic.history.clear');
  static const Key _copyHistoryButtonKey = ValueKey<String>('basic.history.copy');
  static const Key _saveHistoryButtonKey = ValueKey<String>('basic.history.save');

  final CalculatorController _controller = CalculatorController();
  final shared_theme.ThemeManager _themeManager = GetIt.I<shared_theme.ThemeManager>();
  final symbols = GetIt.I<LocalNumberSymbols>();
  final ScrollController _historyScrollController = ScrollController();
  final FocusNode _keyboardFocusNode = FocusNode(debugLabel: 'basic_calc_keyboard_focus');

  @override
  void initState() {
    super.initState();
    // We listen to controller changes to refresh the UI.
    _controller.addListener(_updateUI);
    _themeManager.addListener(_updateUI);
    unawaited(_controller.restorePersistedState());
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
    _historyScrollController.dispose();
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

  String? _mapCharacterToButton(String character) {
    if (character.length != 1) return null;

    if (RegExp(r'^[0-9]$').hasMatch(character)) {
      return character;
    }

    switch (character) {
      case '.':
      case ',':
        return symbols.decimalSep;
      case '+':
        return '+';
      case '-':
        return '-';
      case '/':
        return '÷';
      case '*':
      case 'x':
      case 'X':
      case '×':
        return CalculatorController.multiplySymbol;
      case '%':
        return '%';
      case '^':
        return 'x^y';
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

    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) {
      _controller.onButtonPressed('=');
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.backspace) {
      _controller.onButtonPressed('⌫');
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.escape || key == LogicalKeyboardKey.delete) {
      _controller.onButtonPressed('C');
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.numpadAdd) {
      _controller.onButtonPressed('+');
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.numpadSubtract) {
      _controller.onButtonPressed('-');
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.numpadMultiply) {
      _controller.onButtonPressed(CalculatorController.multiplySymbol);
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.numpadDivide) {
      _controller.onButtonPressed('÷');
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.numpadDecimal) {
      _controller.onButtonPressed(symbols.decimalSep);
      return KeyEventResult.handled;
    }

    final String? mapped = event.character == null ? null : _mapCharacterToButton(event.character!);
    if (mapped != null) {
      _controller.onButtonPressed(mapped);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  /// Determines the button color from its label.
  Color _getButtonColor(String label) {
    if (label == 'C' || label == "⌫") return Colors.redAccent;
    if (['MC', 'MR', 'M+', 'M-'].contains(label)) return Colors.blueGrey;
    if (['÷', 'x', '-', '+', '='].contains(label)) return Colors.orange;
    return _themeManager.buttonGroupColor;
  }

  /// Returns the text to show in the main output area.
  ///
  /// When the user is typing, we show the current input as-is.
  /// Otherwise we localize the stored output for display.
  String _buildDisplayText(CalculatorState state) {
    return _controller.isLastClicNumber && state.currentInput.isNotEmpty
        ? state.currentInput
        : state.output.formatRound();
  }

  /// Builds an individual button
  Widget _buildButton(String label, {required bool compact}) {
    final bool isPhone = MediaQuery.sizeOf(context).width < 600;
    final bool isLongLabel = label.length >= 3;
    // Keep labels larger on phones; slightly reduce only long labels.
    final double baseFontSize = isPhone ? (compact ? 18 : 24) : (compact ? 14 : 20);
    final double fontSize = (isPhone && isLongLabel) ? (baseFontSize - 2) : baseFontSize;
    final double verticalPadding = isPhone ? (compact ? 4 : 8) : (compact ? 6 : 12);
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
                color: Colors.grey[200]!, // Border color.
                width: compact ? 1.2 : 2.0, // Border width.
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: compact ? 4 : 8, vertical: verticalPadding),
            minimumSize: Size.fromHeight(compact ? 34 : 44),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {
            _controller.onButtonPressed(label);
            _requestKeyboardFocus();
          },
          child: isPhone
              ? Align(
                  alignment: const Alignment(0, -0.08),
                  child: Text(
                    label,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, height: 1.0),
                  ),
                )
              : FittedBox(
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

  Widget _buildHistoryItem(CalculatorHistoryEntry entry, int index) {
    final historyText = entry.displayText.contains('= ≈')
        ? entry.displayText.replaceLast('= ≈', '≈')
        : entry.displayText;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Dismissible(
        key: ValueKey<String>('history-$index-${entry.displayText}'),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => _controller.removeHistoryEntryAt(index),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: Colors.redAccent.withAlpha(220), borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.delete_outline, color: Colors.white),
        ),
        child: Material(
          color: Colors.white.withAlpha(120),
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => _controller.selectHistoryEntry(entry),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      historyText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: _themeManager.displayTextColor, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.replay_outlined, size: 18, color: _themeManager.displayTextColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showHistorySnackBar(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _copyHistoryToClipboard(AppLocalizations l10n) async {
    final historyText = _controller.historyEntriesToPlainText();
    if (historyText.isEmpty) {
      _showHistorySnackBar(l10n.basicHistoryEmpty);
      return;
    }

    await Clipboard.setData(ClipboardData(text: historyText));
    _showHistorySnackBar(l10n.basicHistoryCopied);
  }

  Future<void> _saveHistoryToFile(AppLocalizations l10n) async {
    final historyText = _controller.historyEntriesToPlainText();
    if (historyText.isEmpty) {
      _showHistorySnackBar(l10n.basicHistoryEmpty);
      return;
    }

    if (!isHistoryFileExportSupported) {
      _showHistorySnackBar(l10n.basicHistoryExportUnsupported);
      return;
    }

    try {
      final filePath = await exportHistoryToTextFile(historyText);
      if (filePath == null || filePath.isEmpty) {
        _showHistorySnackBar(l10n.basicHistoryExportError);
        return;
      }
      _showHistorySnackBar(l10n.basicHistoryExported(filePath));
    } catch (_) {
      _showHistorySnackBar(l10n.basicHistoryExportError);
    }
  }

  Widget _buildHistoryList(List<CalculatorHistoryEntry> entries, AppLocalizations l10n) {
    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                key: _copyHistoryButtonKey,
                onPressed: entries.isEmpty ? null : () => unawaited(_copyHistoryToClipboard(l10n)),
                tooltip: l10n.basicHistoryCopy,
                icon: const Icon(Icons.content_copy_outlined),
                color: _themeManager.displayTextColor,
              ),
              IconButton(
                key: _saveHistoryButtonKey,
                onPressed: entries.isEmpty ? null : () => unawaited(_saveHistoryToFile(l10n)),
                tooltip: l10n.basicHistorySave,
                icon: const Icon(Icons.save_alt_outlined),
                color: _themeManager.displayTextColor,
              ),
              IconButton(
                key: _clearHistoryButtonKey,
                onPressed: _controller.clearHistory,
                tooltip: l10n.basicHistoryClear,
                icon: const Icon(Icons.delete_sweep_outlined),
                color: _themeManager.displayTextColor,
              ),
            ],
          ),
        ),
        Expanded(
          child: Scrollbar(
            controller: _historyScrollController,
            thumbVisibility: true,
            child: ListView.builder(
              controller: _historyScrollController,
              itemCount: entries.length,
              itemBuilder: (context, index) => _buildHistoryItem(entries[index], index),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state;
    final l10n = AppLocalizations.of(context);
    final mediaSize = MediaQuery.sizeOf(context);
    final bool isDesktopLike = mediaSize.width >= 768;

    return Focus(
      focusNode: _keyboardFocusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Container(
        decoration: _themeManager.backgroundDecoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(l10n.appTitle),
            backgroundColor: Colors.white.withAlpha(150),
            // Semi-transparent white.
            foregroundColor: Colors.grey[150],
            // Text and action color.
            iconTheme: IconThemeData(color: Colors.grey[150]),
            // Icon color.
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
                      // Compute keyboard height from the available space to avoid vertical overflow.
                      final double keyboardHeight =
                          (availableHeight * (isDesktopLike ? 0.44 : (isCompactHeight ? 0.52 : 0.50)))
                              .clamp(
                                isDesktopLike ? 300.0 : (isCompactHeight ? 250.0 : 320.0),
                                isDesktopLike ? 560.0 : 640.0,
                              )
                              .toDouble();
                      final double keyboardBottomPadding = isCompactHeight ? 8.0 : 50.0;

                      return Column(
                        children: [
                          // Display area with a semi-transparent background.
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                              color: Colors.white.withAlpha(150),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (_controller.memoryDisplay().isNotEmpty)
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        _controller.memoryDisplay(),
                                        style: TextStyle(color: Colors.amber[800], fontSize: 24),
                                      ),
                                    ),
                                  if (state.history.isNotEmpty)
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        state.history.contains('= ≈')
                                            ? state.history.replaceLast('= ≈', '≈')
                                            : state.history,
                                        style: TextStyle(
                                          color: _themeManager.displayTextColor.withAlpha(180),
                                          fontSize: 24,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  const SizedBox(height: 10),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      _buildDisplayText(state),
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: _themeManager.displayTextColor,
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Expanded(child: _buildHistoryList(state.historyEntries, l10n)),
                                ],
                              ),
                            ),
                          ),

                          // Button grid area.
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
                                        _buildButton('%', compact: isCompactHeight),
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
                                        _buildButton(CalculatorController.multiplySymbol, compact: isCompactHeight),
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
              // Photo credit in the bottom-right corner, only when the Unsplash background is active.
              if (mediaSize.height >= 700 && _themeManager.isUnsplashBackgroundActive)
                Positioned(bottom: 16, right: 16, child: const PhotoCreditLink()),
            ],
          ),
        ),
      ),
    );
  }
}
