// lib/calculators/math/average/screens/average_screen.dart
import 'package:calculators/shared/services/history_export_service.dart';
import 'package:calculators/calculators/math/average/average_controller.dart';
import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/shared/theme/theme_manager.dart' as shared_theme;
import 'package:calculators/shared/widgets/menu_drawer.dart';
import 'package:calculators/utils/extensions/decimal_extensions.dart';
import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:rational/rational.dart';

class AverageScreen extends StatefulWidget {
  const AverageScreen({super.key});

  @override
  State<AverageScreen> createState() => _AverageScreenState();
}

class _AverageScreenState extends State<AverageScreen> {
  final AverageController _controller = AverageController();
  bool _historyExpanded = false;

  late final shared_theme.ThemeManager _themeManager;
  late final LocalNumberSymbols _numberSymbols;

  @override
  void initState() {
    super.initState();
    _themeManager = GetIt.I<shared_theme.ThemeManager>();
    _numberSymbols = GetIt.I.isRegistered<LocalNumberSymbols>()
        ? GetIt.I<LocalNumberSymbols>()
        : LocalNumberSymbols();
    _controller.addListener(_onControllerChanged);
    _themeManager.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _themeManager.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  String _formatRational(Rational value) {
    final decimal = value.toDecimal(scaleOnInfinitePrecision: 12);
    return decimal.toPreciseFormattedString;
  }

  String _displayInput() {
    if (_controller.rawInput.isEmpty) return '0';
    return _controller.rawInput.replaceAll('.', _numberSymbols.decimalSep);
  }

  String _buildReport(AppLocalizations l10n) {
    final buffer = StringBuffer()
      ..writeln(l10n.averageTitle)
      ..writeln(' ${l10n.averageCountLabel}: ${_controller.count}');
    if (_controller.average != null) {
      buffer.writeln('${l10n.averageLabel}: ${_formatRational(_controller.average!)}');
    }
    if (_controller.sum != null) {
      buffer.writeln('${l10n.averageSumLabel}: ${_formatRational(_controller.sum!)}');
    }
    buffer.writeln();
    buffer.writeln(l10n.averageHistoryTitle);
    if (_controller.values.isEmpty) {
      buffer.writeln(l10n.averageHistoryEmpty);
    } else {
      for (var i = 0; i < _controller.values.length; i++) {
        buffer.writeln('${i + 1}. ${_formatRational(_controller.values[i])}');
      }
    }
    return buffer.toString();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _copyReport(AppLocalizations l10n) async {
    await Clipboard.setData(ClipboardData(text: _buildReport(l10n)));
    _showSnack(l10n.basicHistoryCopied);
  }

  Future<void> _saveReport(AppLocalizations l10n) async {
    if (!isHistoryFileExportSupported) {
      _showSnack(l10n.basicHistoryExportUnsupported);
      return;
    }
    try {
      final filePath = await exportHistoryToTextFile(_buildReport(l10n));
      if (filePath == null || filePath.isEmpty) {
        _showSnack(l10n.basicHistoryExportError);
        return;
      }
      _showSnack(l10n.basicHistoryExported(filePath));
    } catch (_) {
      _showSnack(l10n.basicHistoryExportError);
    }
  }

  void _addValue(AppLocalizations l10n) {
    if (!_controller.addCurrentValue()) {
      _showSnack(l10n.averageInvalidNumber);
      return;
    }
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final mediaSize = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final bool isDesktopLike = mediaSize.width >= 768;
    final bool isPhone = mediaSize.width < 600;
    final double keyboardBottomPadding =
        isPhone ? (bottomInset + 24.0).clamp(22.0, 52.0).toDouble() : 24.0;
    final double keyboardHeight = (mediaSize.height * (isDesktopLike ? 0.34 : (isPhone ? 0.40 : 0.44)))
        .clamp(isDesktopLike ? 240.0 : (isPhone ? 230.0 : 280.0), isDesktopLike ? 360.0 : 520.0)
        .toDouble();
    final averageText = _controller.average == null
        ? '—'
        : _formatRational(_controller.average!);

    return Container(
      decoration: _themeManager.backgroundDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: MenuDrawer(themeManager: _themeManager),
          title: Text(l10n.averageTitle),
          backgroundColor: Colors.white.withAlpha(150),
          elevation: 0,
          actions: [
            IconButton(
              tooltip: l10n.basicHistoryCopy,
              onPressed: () => _copyReport(l10n),
              icon: const Icon(Icons.copy),
            ),
            IconButton(
              tooltip: l10n.basicHistorySave,
              onPressed: () => _saveReport(l10n),
              icon: const Icon(Icons.save_alt),
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SizedBox.expand(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: Colors.white.withAlpha(150),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.averageLabel,
                                      style: TextStyle(
                                        color: _themeManager.displayTextColor.withAlpha(180),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        averageText,
                                        style: TextStyle(
                                          color: _themeManager.displayTextColor,
                                          fontSize: 36,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 46,
                                color: _themeManager.displayTextColor.withAlpha(60),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    l10n.averageCountLabel,
                                    style: TextStyle(
                                      color: _themeManager.displayTextColor.withAlpha(180),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_controller.count}',
                                    style: TextStyle(
                                      color: _themeManager.displayTextColor,
                                      fontSize: 36,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Card(
                            elevation: 0,
                            color: Colors.white.withAlpha(120),
                            child: Theme(
                              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                initiallyExpanded: _historyExpanded,
                                onExpansionChanged: (expanded) =>
                                    setState(() => _historyExpanded = expanded),
                                iconColor: _themeManager.displayTextColor,
                                collapsedIconColor: _themeManager.displayTextColor,
                                leading: Icon(Icons.history, color: _themeManager.displayTextColor),
                                title: Text(
                                  l10n.averageHistoryTitle,
                                  style: TextStyle(
                                    color: _themeManager.displayTextColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  _controller.count == 0
                                      ? l10n.averageHistoryEmpty
                                      : l10n.averageHistoryCount(_controller.count),
                                  style: TextStyle(
                                    color: _themeManager.displayTextColor.withAlpha(170),
                                  ),
                                ),
                                children: [
                                  if (_controller.values.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          l10n.averageHistoryEmpty,
                                          style: TextStyle(
                                            color: _themeManager.displayTextColor.withAlpha(170),
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: isDesktopLike ? 220 : 160,
                                      ),
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        itemCount: _controller.values.length,
                                        separatorBuilder: (_, _) => Divider(
                                          height: 1,
                                          color: _themeManager.displayTextColor.withAlpha(40),
                                        ),
                                        itemBuilder: (context, index) {
                                          final value = _controller.values[index];
                                          return ListTile(
                                            dense: true,
                                            leading: CircleAvatar(
                                              radius: 14,
                                              backgroundColor: _themeManager.buttonGroupColor,
                                              foregroundColor: _themeManager.buttonTextColor,
                                              child: Text(
                                                '${index + 1}',
                                                style: const TextStyle(fontSize: 12),
                                              ),
                                            ),
                                            title: Text(
                                              _formatRational(value),
                                              style: TextStyle(
                                                color: _themeManager.displayTextColor,
                                              ),
                                            ),
                                            trailing: IconButton(
                                              tooltip: l10n.averageRemoveValue,
                                              icon: Icon(
                                                Icons.close,
                                                color: _themeManager.displayTextColor,
                                              ),
                                              onPressed: () => _controller.removeAt(index),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(180),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[200]!, width: 1.5),
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  _displayInput(),
                                  style: TextStyle(
                                    color: _themeManager.displayTextColor,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 8, 8, keyboardBottomPadding),
                    child: SizedBox(
                      height: keyboardHeight,
                      child: _AverageKeypad(
                        themeManager: _themeManager,
                        decimalSeparator: _numberSymbols.decimalSep,
                        addLabel: l10n.averageAdd,
                        onDigit: _controller.appendDigit,
                        onDecimal: _controller.appendDecimalSeparator,
                        onBackspace: _controller.backspace,
                        onClear: _controller.clearInput,
                        onSign: _controller.toggleSign,
                        onAdd: () => _addValue(l10n),
                        onUndo: _controller.canUndo ? _controller.undoLast : null,
                        onClearAll: _controller.count > 0 || _controller.hasInput
                            ? _controller.clearAll
                            : null,
                        undoLabel: l10n.averageUndo,
                        clearAllLabel: l10n.averageClearAll,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AverageKeypad extends StatelessWidget {
  const _AverageKeypad({
    required this.themeManager,
    required this.decimalSeparator,
    required this.addLabel,
    required this.onDigit,
    required this.onDecimal,
    required this.onBackspace,
    required this.onClear,
    required this.onSign,
    required this.onAdd,
    required this.onUndo,
    required this.onClearAll,
    required this.undoLabel,
    required this.clearAllLabel,
  });

  final shared_theme.ThemeManager themeManager;
  final String decimalSeparator;
  final String addLabel;
  final String undoLabel;
  final String clearAllLabel;
  final ValueChanged<String> onDigit;
  final VoidCallback onDecimal;
  final VoidCallback onBackspace;
  final VoidCallback onClear;
  final VoidCallback onSign;
  final VoidCallback onAdd;
  final VoidCallback? onUndo;
  final VoidCallback? onClearAll;

  Color _buttonColor({required bool primary, required bool danger}) {
    if (danger) return Colors.redAccent;
    if (primary) return Colors.green;
    return themeManager.buttonGroupColor;
  }

  Widget _buildKey(
    BuildContext context,
    String label,
    VoidCallback? onPressed, {
    int flex = 1,
    bool primary = false,
    bool danger = false,
  }) {
    final bool isPhone = MediaQuery.sizeOf(context).width < 600;
    final EdgeInsets buttonPadding = isPhone
        ? const EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0)
        : const EdgeInsets.all(6.0);
    final EdgeInsets contentPadding = isPhone
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 6)
        : const EdgeInsets.all(12);
    final double fontSize = isPhone ? 18 : 20;
    final Color background = _buttonColor(primary: primary, danger: danger);

    return Expanded(
      flex: flex,
      child: Padding(
        padding: buttonPadding,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: background,
            foregroundColor: themeManager.buttonTextColor,
            disabledBackgroundColor: background.withAlpha(120),
            disabledForegroundColor: themeManager.buttonTextColor.withAlpha(140),
            elevation: 6,
            shadowColor: Colors.black.withAlpha(120),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey[200]!, width: 2.0),
            ),
            padding: contentPadding,
          ),
          onPressed: onPressed,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              _buildKey(context, '7', () => onDigit('7')),
              _buildKey(context, '8', () => onDigit('8')),
              _buildKey(context, '9', () => onDigit('9')),
              _buildKey(context, '⌫', onBackspace, danger: true),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _buildKey(context, '4', () => onDigit('4')),
              _buildKey(context, '5', () => onDigit('5')),
              _buildKey(context, '6', () => onDigit('6')),
              _buildKey(context, 'C', onClear, danger: true),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _buildKey(context, '1', () => onDigit('1')),
              _buildKey(context, '2', () => onDigit('2')),
              _buildKey(context, '3', () => onDigit('3')),
              _buildKey(context, '±', onSign),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _buildKey(context, '0', () => onDigit('0')),
              _buildKey(context, decimalSeparator, onDecimal),
              _buildKey(context, addLabel, onAdd, flex: 2, primary: true),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _buildKey(context, undoLabel, onUndo),
              _buildKey(context, clearAllLabel, onClearAll, danger: true),
            ],
          ),
        ),
      ],
    );
  }
}