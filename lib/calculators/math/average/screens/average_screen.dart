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
    final theme = Theme.of(context);
    final averageText = _controller.average == null
        ? '—'
        : _formatRational(_controller.average!);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.averageTitle),
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
      drawer: MenuDrawer(themeManager: _themeManager),
      body: Container(
        decoration: _themeManager.backgroundDecoration,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              children: [
              Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.averageLabel, style: theme.textTheme.labelMedium),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                averageText,
                                style: theme.textTheme.headlineMedium?.copyWith(
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
                        color: theme.dividerColor,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(l10n.averageCountLabel, style: theme.textTheme.labelMedium),
                          const SizedBox(height: 4),
                          Text(
                            '${_controller.count}',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: ExpansionTile(
                  initiallyExpanded: _historyExpanded,
                  onExpansionChanged: (expanded) => setState(() => _historyExpanded = expanded),
                  leading: const Icon(Icons.history),
                  title: Text(l10n.averageHistoryTitle),
                  subtitle: Text(
                    _controller.count == 0
                        ? l10n.averageHistoryEmpty
                        : l10n.averageHistoryCount(_controller.count),
                  ),
                  children: [
                    if (_controller.values.isEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(l10n.averageHistoryEmpty),
                      )
                    else
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 180),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: _controller.values.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final value = _controller.values[index];
                            return ListTile(
                              dense: true,
                              leading: CircleAvatar(
                                radius: 14,
                                child: Text('${index + 1}', style: const TextStyle(fontSize: 12)),
                              ),
                              title: Text(_formatRational(value)),
                              trailing: IconButton(
                                tooltip: l10n.averageRemoveValue,
                                icon: const Icon(Icons.close),
                                onPressed: () => _controller.removeAt(index),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _displayInput(),
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _AverageKeypad(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AverageKeypad extends StatelessWidget {
  const _AverageKeypad({
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

  @override
  Widget build(BuildContext context) {
    Widget key(String label, VoidCallback? onPressed, {bool primary = false, bool danger = false}) {
      final child = Center(
        child: Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
      );
      if (primary) {
        return FilledButton(onPressed: onPressed, child: child);
      }
      if (danger) {
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
          child: child,
        );
      }
      return FilledButton.tonal(onPressed: onPressed, child: child);
    }

    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: key('7', () => onDigit('7'))),
              const SizedBox(width: 8),
              Expanded(child: key('8', () => onDigit('8'))),
              const SizedBox(width: 8),
              Expanded(child: key('9', () => onDigit('9'))),
              const SizedBox(width: 8),
              Expanded(child: key('⌫', onBackspace, danger: true)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            children: [
              Expanded(child: key('4', () => onDigit('4'))),
              const SizedBox(width: 8),
              Expanded(child: key('5', () => onDigit('5'))),
              const SizedBox(width: 8),
              Expanded(child: key('6', () => onDigit('6'))),
              const SizedBox(width: 8),
              Expanded(child: key('C', onClear, danger: true)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            children: [
              Expanded(child: key('1', () => onDigit('1'))),
              const SizedBox(width: 8),
              Expanded(child: key('2', () => onDigit('2'))),
              const SizedBox(width: 8),
              Expanded(child: key('3', () => onDigit('3'))),
              const SizedBox(width: 8),
              Expanded(child: key('±', onSign)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            children: [
              Expanded(child: key('0', () => onDigit('0'))),
              const SizedBox(width: 8),
              Expanded(child: key(decimalSeparator, onDecimal)),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: key(addLabel, onAdd, primary: true)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: OutlinedButton(onPressed: onUndo, child: Text(undoLabel))),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: onClearAll,
                child: Text(clearAllLabel),
              ),
            ),
          ],
        ),
      ],
    );
  }
}