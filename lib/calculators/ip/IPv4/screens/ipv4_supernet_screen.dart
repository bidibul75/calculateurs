import 'dart:async';

import 'package:calculators/calculators/ip/IPv4/address.dart';
import 'package:calculators/calculators/ip/IPv4/relation.dart';
import 'package:calculators/calculators/ip/IPv4/supernet.dart';
import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/shared/services/result_feedback_service.dart';
import 'package:calculators/shared/theme/theme_manager.dart' as shared_theme;
import 'package:calculators/shared/widgets/menu_drawer.dart';
import 'package:calculators/shared/widgets/photo_credit_link.dart';
import 'package:calculators/utils/extensions/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/ipv4_result_export_service.dart';

class Ipv4SupernetScreen extends StatefulWidget {
  const Ipv4SupernetScreen({super.key});

  @override
  State<Ipv4SupernetScreen> createState() => _Ipv4SupernetScreenState();
}

class _Ipv4SupernetScreenState extends State<Ipv4SupernetScreen> {
  static const double _mobileKeyHeight = 52;
  static const String _addressesPreferenceKey = 'ipv4.supernet.addresses.v1';
  static const String _inputPreferenceKey = 'ipv4.supernet.input.v1';
  static const String _showMobileKeypadPreferenceKey = 'ipv4.supernet.mobileKeypadVisible.v1';

  final shared_theme.ThemeManager _themeManager = GetIt.I<shared_theme.ThemeManager>();
  final TextEditingController _inputController = TextEditingController();

  final List<String> _addresses = <String>[];
  final List<String> _duplicateMessages = <String>[];
  final List<Relation> _relations = <Relation>[];

  String? _inputError;
  String? _statusText;
  String? _supernetResult;
  bool? _allContiguous;
  bool _isMobileKeypadVisible = true;

  static const Key _resultCopyButtonKey = ValueKey<String>('ipv4.supernet.result.copy');
  static const Key _resultSaveButtonKey = ValueKey<String>('ipv4.supernet.result.save');

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(_updateUI);
    unawaited(_restorePersistedState());
  }

  @override
  void dispose() {
    _themeManager.removeListener(_updateUI);
    _inputController.dispose();
    super.dispose();
  }

  void _updateUI() {
    setState(() {});
  }

  void _resetAll() {
    setState(() {
      _inputController.clear();
      _addresses.clear();
      _duplicateMessages.clear();
      _relations.clear();
      _inputError = null;
      _statusText = null;
      _supernetResult = null;
      _allContiguous = null;
      _isMobileKeypadVisible = true;
    });
    unawaited(_persistState());
  }

  bool _isMobilePlatform(TargetPlatform platform) {
    return platform == TargetPlatform.android || platform == TargetPlatform.iOS;
  }

  void _appendToInput(String value) {
    setState(() {
      _inputController.text = '${_inputController.text}$value';
      _inputError = null;
    });
    unawaited(_persistState());
  }

  void _deleteLastChar() {
    if (_inputController.text.isEmpty) {
      return;
    }

    setState(() {
      _inputController.text = _inputController.text.substring(0, _inputController.text.length - 1);
      _inputError = null;
    });
    unawaited(_persistState());
  }

  void _clearInputOnly() {
    setState(() {
      _inputController.clear();
      _inputError = null;
      _isMobileKeypadVisible = true;
    });
    unawaited(_persistState());
  }

  ButtonStyle _keyButtonStyle({Color? backgroundColor, Color? foregroundColor}) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? _themeManager.buttonGroupColor,
      foregroundColor: foregroundColor ?? _themeManager.buttonTextColor,
      elevation: 6,
      shadowColor: Colors.black.withAlpha(120),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!, width: 2.0),
      ),
      padding: const EdgeInsets.all(12),
    );
  }

  Widget _actionButtonLabel(String text) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(text, maxLines: 1, softWrap: false),
    );
  }

  void _addAddress() {
    final l10n = AppLocalizations.of(context);
    final rawInput = _inputController.text.trim();

    if (rawInput.isEmpty) {
      setState(() {
        _inputError = l10n.ipv4SupernetErrorEmptyAddress;
      });
      unawaited(_persistState());
      return;
    }

    final normalized = rawInput.replaceAll(' ', '');
    if (!normalized.isValidIPv4CIDR) {
      setState(() {
        _inputError = l10n.ipv4SupernetErrorInvalidCidr;
      });
      unawaited(_persistState());
      return;
    }

    if (_addresses.contains(normalized)) {
      setState(() {
        _inputError = l10n.ipv4SupernetDuplicateMessage(normalized, 2);
      });
      unawaited(_persistState());
      return;
    }

    setState(() {
      _addresses.add(normalized);
      _inputController.clear();
      _inputError = null;
      _statusText = null;
      _supernetResult = null;
      _allContiguous = null;
      _relations.clear();
      _duplicateMessages.clear();
    });
    unawaited(_persistState());
  }

  String _computeSupernetCidr(List<Supernet> addresses) {
    final sorted = List<Supernet>.from(addresses);
    Supernet.sortAddressList(sorted);

    final binaries = sorted
        .map((a) => a.suffix == 32 ? a.addressOnlyString : a.addressNetworkStringBinary)
        .toList();

    final prefix = Supernet.supernetCalculation(sorted.length, binaries, '');
    final binarySupernet = prefix.padRight(32, '0');
    return '${stringBinaryToStringDecimalDots(binarySupernet)}/${prefix.length}';
  }

  void _calculateSupernet({bool hideMobileKeypad = false}) {
    final l10n = AppLocalizations.of(context);

    if (_addresses.length < 2) {
      setState(() {
        _statusText = l10n.ipv4SupernetErrorNeedTwo;
        _supernetResult = null;
        _relations.clear();
        _allContiguous = null;
        if (hideMobileKeypad) _isMobileKeypadVisible = false;
      });
      unawaited(_persistState());
      return;
    }

    try {
      final dedup = Supernet.deduplicateAddresses(_addresses);
      final unique = dedup.uniqueAddresses;

      if (unique.length < 2) {
        setState(() {
          _statusText = l10n.ipv4SupernetErrorNeedTwo;
          _supernetResult = null;
          _relations.clear();
          _allContiguous = null;
          if (hideMobileKeypad) _isMobileKeypadVisible = false;
        });
        unawaited(_persistState());
        return;
      }

      final duplicateMessages = dedup.duplicateCounts.entries
          .map((entry) => l10n.ipv4SupernetDuplicateMessage(entry.key, entry.value))
          .toList();

      final objects = unique.map(Supernet.new).toList();
      final contiguous = Supernet.isAListOfContiguousAddresses(List<Address>.from(objects));
      final supernetCidr = _computeSupernetCidr(objects);
      final relations = contiguous ? <Relation>[] : Supernet.computeRelations(List<Address>.from(objects));

      setState(() {
        _addresses
          ..clear()
          ..addAll(unique);
        _duplicateMessages
          ..clear()
          ..addAll(duplicateMessages);
        _allContiguous = contiguous;
        _statusText = contiguous ? l10n.ipv4SupernetContiguousYes : l10n.ipv4SupernetContiguousNo;
        _supernetResult = supernetCidr;
        _relations
          ..clear()
          ..addAll(relations);
        if (hideMobileKeypad) _isMobileKeypadVisible = false;
      });
      unawaited(_persistState());
    } catch (_) {
      setState(() {
        _statusText = l10n.ipv4SupernetErrorGeneric;
        if (hideMobileKeypad) _isMobileKeypadVisible = false;
      });
      unawaited(_persistState());
    }
  }

  Future<void> _restorePersistedState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAddresses = prefs.getStringList(_addressesPreferenceKey) ?? const <String>[];
    final savedInput = prefs.getString(_inputPreferenceKey) ?? '';
    final savedMobileKeypadVisible = prefs.getBool(_showMobileKeypadPreferenceKey);

    if (!mounted) {
      return;
    }

    setState(() {
      _addresses
        ..clear()
        ..addAll(savedAddresses);
      _inputController.text = savedInput;
      if (savedMobileKeypadVisible != null) {
        _isMobileKeypadVisible = savedMobileKeypadVisible;
      }
    });

    if (_addresses.length >= 2 && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _calculateSupernet();
        }
      });
    }
  }

  Future<void> _persistState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_addressesPreferenceKey, _addresses);
    await prefs.setString(_inputPreferenceKey, _inputController.text);
    await prefs.setBool(_showMobileKeypadPreferenceKey, _isMobileKeypadVisible);
  }

  Widget _buildKeyButton(String label, {required double fontSize, required EdgeInsets padding}) {
    return Expanded(
      child: Padding(
        padding: padding,
        child: SizedBox(
          height: _mobileKeyHeight,
          width: double.infinity,
          child: ElevatedButton(
            style: _keyButtonStyle(),
            onPressed: () => _appendToInput(label),
            child: Text(label, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildActionKeyButton({
    String? label,
    IconData? icon,
    required VoidCallback onPressed,
    required double fontSize,
    required EdgeInsets padding,
    bool expanded = true,
    Color? backgroundColor,
  }) {
    final bool hasLabel = label != null && label.isNotEmpty;
    final bool hasIcon = icon != null;

    Widget child;
    if (hasIcon && hasLabel) {
      child = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
        ],
      );
    } else if (hasIcon) {
      child = Icon(icon);
    } else {
      child = Text(label ?? '', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold));
    }

    final button = Padding(
      padding: padding,
      child: SizedBox(
        height: _mobileKeyHeight,
        width: double.infinity,
        child: ElevatedButton(
          style: _keyButtonStyle(backgroundColor: backgroundColor),
          onPressed: onPressed,
          child: child,
        ),
      ),
    );

    if (!expanded) {
      return button;
    }

    return Expanded(child: button);
  }

  Widget _buildMobileKeypad(AppLocalizations l10n) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool compact = constraints.maxWidth < 360;
        final double fontSize = compact ? 18 : 20;
        final EdgeInsets keyPadding = EdgeInsets.all(compact ? 3 : 4);
        final EdgeInsets actionPadding = EdgeInsets.all(compact ? 3 : 4);

        return Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(150),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _buildActionKeyButton(
                    label: 'C',
                    onPressed: _clearInputOnly,
                    fontSize: fontSize,
                    padding: actionPadding,
                    backgroundColor: Colors.redAccent,
                  ),
                  _buildActionKeyButton(
                    icon: Icons.backspace_outlined,
                    onPressed: _deleteLastChar,
                    fontSize: fontSize,
                    padding: actionPadding,
                    backgroundColor: Colors.redAccent,
                  ),
                ],
              ),
              Row(children: [_buildKeyButton('1', fontSize: fontSize, padding: keyPadding), _buildKeyButton('2', fontSize: fontSize, padding: keyPadding), _buildKeyButton('3', fontSize: fontSize, padding: keyPadding)]),
              Row(children: [_buildKeyButton('4', fontSize: fontSize, padding: keyPadding), _buildKeyButton('5', fontSize: fontSize, padding: keyPadding), _buildKeyButton('6', fontSize: fontSize, padding: keyPadding)]),
              Row(children: [_buildKeyButton('7', fontSize: fontSize, padding: keyPadding), _buildKeyButton('8', fontSize: fontSize, padding: keyPadding), _buildKeyButton('9', fontSize: fontSize, padding: keyPadding)]),
              Row(children: [_buildKeyButton('.', fontSize: fontSize, padding: keyPadding), _buildKeyButton('0', fontSize: fontSize, padding: keyPadding), _buildKeyButton('/', fontSize: fontSize, padding: keyPadding)]),
              const SizedBox(height: 8),
              _buildActionKeyButton(
                label: l10n.bmiActionEnter,
                icon: Icons.keyboard_return,
                onPressed: _addAddress,
                fontSize: fontSize,
                padding: actionPadding,
                expanded: false,
                backgroundColor: Colors.green,
              ),
            ],
          ),
        );
      },
    );
  }

  String _supernetResultAsPlainText(AppLocalizations l10n) {
    final lines = <String>[
      '${l10n.ipv4SupernetAddressesTitle}: ${_addresses.join(', ')}',
    ];

    if (_statusText != null && _statusText!.isNotEmpty) {
      lines.add(_statusText!);
    }

    if (_supernetResult != null) {
      lines.add('${l10n.ipv4SupernetResultValue}: $_supernetResult');
    }

    if (_relations.isNotEmpty) {
      lines.add(l10n.ipv4SupernetRelationsTitle);
      lines.addAll(_relations.map((r) => '${r.addressA} -> ${Relation.relationLabel(l10n, r.relationAB)} -> ${r.addressB}'));
    }

    return lines.join('\n');
  }

  Future<void> _copySupernetResult(AppLocalizations l10n) async {
    await copyResultToClipboard(
      context: context,
      text: _supernetResultAsPlainText(l10n),
      copiedMessage: l10n.ipv4ResultCopied,
    );
  }

  Future<void> _saveSupernetResult(AppLocalizations l10n) async {
    await saveResultToFileWithFeedback(
      context: context,
      content: _supernetResultAsPlainText(l10n),
      prefix: 'ipv4_supernet_result',
      isExportSupported: isIpv4ResultFileExportSupported,
      exportToTextFile: exportIpv4ResultToTextFile,
      unsupportedMessage: l10n.ipv4ResultExportUnsupported,
      errorMessage: l10n.ipv4ResultExportError,
      exportedMessageBuilder: l10n.ipv4ResultExported,
    );
  }

  Widget _buildResultActions(AppLocalizations l10n) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            key: _resultCopyButtonKey,
            tooltip: l10n.ipv4ResultCopy,
            onPressed: () => unawaited(_copySupernetResult(l10n)),
            icon: const Icon(Icons.content_copy_outlined),
          ),
          IconButton(
            key: _resultSaveButtonKey,
            tooltip: l10n.ipv4ResultSave,
            onPressed: () => unawaited(_saveSupernetResult(l10n)),
            icon: const Icon(Icons.save_alt_outlined),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bool showMobileKeypad = !kIsWeb && _isMobilePlatform(Theme.of(context).platform) && _isMobileKeypadVisible;

    return Container(
      decoration: _themeManager.backgroundDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(l10n.ipv4SupernetTitle),
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
                constraints: const BoxConstraints(maxWidth: 700),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 72),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white.withAlpha(150),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.ipv4SupernetInputLabel,
                          style: TextStyle(
                            color: _themeManager.displayTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _inputController,
                          keyboardType: TextInputType.text,
                          readOnly: showMobileKeypad,
                          textInputAction: TextInputAction.done,
                          onTap: !kIsWeb && _isMobilePlatform(Theme.of(context).platform)
                              ? () {
                                  if (!_isMobileKeypadVisible) {
                                    setState(() {
                                      _isMobileKeypadVisible = true;
                                    });
                                    unawaited(_persistState());
                                  }
                                }
                              : null,
                          onSubmitted: (_) => _addAddress(),
                          decoration: InputDecoration(
                            hintText: l10n.ipv4SupernetInputHint,
                            filled: true,
                            fillColor: Colors.white,
                            border: const OutlineInputBorder(),
                            errorText: _inputError,
                          ),
                        ),
                        if (showMobileKeypad) _buildMobileKeypad(l10n),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: _mobileKeyHeight,
                                child: ElevatedButton(
                                  style: _keyButtonStyle(),
                                  onPressed: _addAddress,
                                  child: _actionButtonLabel(l10n.ipv4SupernetActionAdd),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: SizedBox(
                                height: _mobileKeyHeight,
                                child: ElevatedButton(
                                  style: _keyButtonStyle(),
                                  onPressed: _addresses.length >= 2
                                      ? () => _calculateSupernet(hideMobileKeypad: showMobileKeypad)
                                      : null,
                                  child: _actionButtonLabel(l10n.ipv4SupernetActionCalculate),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: SizedBox(
                                height: _mobileKeyHeight,
                                child: ElevatedButton(
                                  style: _keyButtonStyle(backgroundColor: Colors.redAccent),
                                  onPressed: _resetAll,
                                  child: _actionButtonLabel(l10n.ipv4SupernetActionReset),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${l10n.ipv4SupernetAddressesTitle} (${_addresses.length})',
                          style: TextStyle(fontWeight: FontWeight.w600, color: _themeManager.displayTextColor),
                        ),
                        const SizedBox(height: 8),
                        if (_addresses.isEmpty)
                          Text(l10n.ipv4SupernetErrorNeedTwo)
                        else
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _addresses
                                .map(
                                  (address) => Chip(
                                    label: Text(address),
                                    onDeleted: () {
                                      setState(() {
                                        _addresses.remove(address);
                                      });
                                      unawaited(_persistState());
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        if (_duplicateMessages.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          ..._duplicateMessages.map((m) => Text(m, style: const TextStyle(color: Colors.orange))),
                        ],
                        if (_statusText != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            _statusText!,
                            style: TextStyle(
                              color: _allContiguous == false ? Colors.orange[800] : Colors.green[800],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        if (_supernetResult != null) ...[
                          const SizedBox(height: 16),
                          Card(
                            color: Colors.white.withAlpha(200),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.ipv4SupernetResultTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 8),
                                  Text('${l10n.ipv4SupernetResultValue}: $_supernetResult'),
                                  const Divider(),
                                  _buildResultActions(l10n),
                                ],
                              ),
                            ),
                          ),
                        ],
                        if (_relations.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Card(
                            color: Colors.white.withAlpha(200),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.ipv4SupernetRelationsTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 8),
                                  ..._relations.map(
                                    (r) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 3),
                                      child: Text.rich(
                                          TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                    text :'${r.addressA} -> ',
                                                  ),
                                              TextSpan(
                                                text: Relation.relationLabel(l10n, r.relationAB),
                                                style: TextStyle(color: Relation.isAGoodRelation(r.relationAB)?Colors.green:Colors.red),
                                              ),
                                              TextSpan(
                                                text: ' -> ${r.addressB}',
                                              ),
                                            ],
                                          ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
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

