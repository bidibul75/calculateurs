import 'dart:async';

import 'package:calculators/calculators/ip/IPv4/relation.dart';
import 'package:calculators/calculators/ip/IPv6/address_ipv6.dart';
import 'package:calculators/calculators/ip/IPv6/supernet_ipv6.dart';
import 'package:calculators/calculators/ip/IPv6/services/ipv6_result_export_service.dart';
import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/shared/theme/theme_manager.dart' as shared_theme;
import 'package:calculators/shared/widgets/menu_drawer.dart';
import 'package:calculators/shared/widgets/photo_credit_link.dart';
import 'package:calculators/utils/my_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ipv6SupernetScreen extends StatefulWidget {
  const Ipv6SupernetScreen({super.key});

  @override
  State<Ipv6SupernetScreen> createState() => _Ipv6SupernetScreenState();
}

class _Ipv6SupernetScreenState extends State<Ipv6SupernetScreen> {
  static const double _mobileKeyHeight = 52;
  static const String _addressesPreferenceKey = 'ipv6.supernet.addresses.v1';
  static const String _inputPreferenceKey = 'ipv6.supernet.input.v1';
  static const String _showMobileKeypadPreferenceKey = 'ipv6.supernet.mobileKeypadVisible.v1';

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

  static const Key _resultCopyButtonKey = ValueKey<String>('ipv6.supernet.result.copy');
  static const Key _resultSaveButtonKey = ValueKey<String>('ipv6.supernet.result.save');
  static const Key _mobileKeypadContainerKey = ValueKey<String>('ipv6.supernet.mobileKeypad');
  static const Key _clearButtonKey = ValueKey<String>('ipv6.supernet.key.clear');
  static const Key _backspaceButtonKey = ValueKey<String>('ipv6.supernet.key.backspace');
  static const Key _enterButtonKey = ValueKey<String>('ipv6.supernet.key.enter');

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

  bool _isMobilePlatform(TargetPlatform platform) {
    return platform == TargetPlatform.android || platform == TargetPlatform.iOS;
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
    Key? buttonKey,
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
          key: buttonKey,
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
        final double fontSize = compact ? 16 : 18;
        final EdgeInsets keyPadding = EdgeInsets.all(compact ? 3 : 4);
        final EdgeInsets actionPadding = EdgeInsets.all(compact ? 3 : 4);

        return Container(
          key: _mobileKeypadContainerKey,
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
                    icon: Icons.clear,
                    onPressed: _clearInputOnly,
                    fontSize: fontSize,
                    padding: actionPadding,
                    buttonKey: _clearButtonKey,
                    backgroundColor: Colors.redAccent,
                  ),
                  _buildActionKeyButton(
                    icon: Icons.backspace_outlined,
                    onPressed: _deleteLastChar,
                    fontSize: fontSize,
                    padding: actionPadding,
                    buttonKey: _backspaceButtonKey,
                    backgroundColor: Colors.redAccent,
                  ),
                ],
              ),
              Row(children: [_buildKeyButton('1', fontSize: fontSize, padding: keyPadding), _buildKeyButton('2', fontSize: fontSize, padding: keyPadding), _buildKeyButton('3', fontSize: fontSize, padding: keyPadding)]),
              Row(children: [_buildKeyButton('4', fontSize: fontSize, padding: keyPadding), _buildKeyButton('5', fontSize: fontSize, padding: keyPadding), _buildKeyButton('6', fontSize: fontSize, padding: keyPadding)]),
              Row(children: [_buildKeyButton('7', fontSize: fontSize, padding: keyPadding), _buildKeyButton('8', fontSize: fontSize, padding: keyPadding), _buildKeyButton('9', fontSize: fontSize, padding: keyPadding)]),
              Row(children: [_buildKeyButton('A', fontSize: fontSize, padding: keyPadding), _buildKeyButton('B', fontSize: fontSize, padding: keyPadding), _buildKeyButton('C', fontSize: fontSize, padding: keyPadding)]),
              Row(children: [_buildKeyButton('D', fontSize: fontSize, padding: keyPadding), _buildKeyButton('E', fontSize: fontSize, padding: keyPadding), _buildKeyButton('F', fontSize: fontSize, padding: keyPadding)]),
              Row(children: [_buildKeyButton(':', fontSize: fontSize, padding: keyPadding), _buildKeyButton('0', fontSize: fontSize, padding: keyPadding), _buildKeyButton('/', fontSize: fontSize, padding: keyPadding)]),
              const SizedBox(height: 8),
              _buildActionKeyButton(
                label: l10n.bmiActionEnter,
                icon: Icons.keyboard_return,
                onPressed: () => _addAddress(),
                fontSize: fontSize,
                padding: actionPadding,
                buttonKey: _enterButtonKey,
                expanded: false,
                backgroundColor: Colors.green,
              ),
            ],
          ),
        );
      },
    );
  }

  void _addAddress() {
    final l10n = AppLocalizations.of(context);
    final rawInput = _inputController.text.trim();

    if (rawInput.isEmpty) {
      setState(() {
        _inputError = l10n.ipv6SupernetErrorEmptyAddress;
      });
      unawaited(_persistState());
      return;
    }

    try {
      final parsed = AddressIPV6(rawInput);
      final canonical = AddressIPV6.cidrSimplifier('${parsed.addressWithoutSuffixString}/${parsed.suffix}');

      if (_addresses.contains(canonical)) {
        setState(() {
          _inputError = l10n.ipv6SupernetDuplicateMessage(canonical, 2);
        });
        unawaited(_persistState());
        return;
      }

      setState(() {
        _addresses.add(canonical);
        _inputController.clear();
        _inputError = null;
        _statusText = null;
        _supernetResult = null;
        _allContiguous = null;
        _relations.clear();
        _duplicateMessages.clear();
      });
      unawaited(_persistState());
    } on MyException catch (error) {
      setState(() {
        _inputError = AddressIPV6.localizeError(l10n, error.error);
      });
      unawaited(_persistState());
    } catch (_) {
      setState(() {
        _inputError = l10n.ipv6SupernetErrorGeneric;
      });
      unawaited(_persistState());
    }
  }

  String _relationLabel(AppLocalizations l10n, String relation) {
    switch (relation) {
      case 'equal':
        return l10n.relationEqual;
      case 'outside':
        return l10n.relationOutside;
      case 'contiguous':
        return l10n.relationContiguous;
      case 'A_inside_B':
        return l10n.relationAInsideB;
      case 'B_inside_A':
        return l10n.relationBInsideA;
      case 'overlap':
      case 'overlaps':
        return l10n.relationOverlap;
      case 'intersecting':
        return l10n.relationIntersecting;
      default:
        return l10n.relationUnknown(relation);
    }
  }

  String _supernetResultAsPlainText(AppLocalizations l10n) {
    final lines = <String>[
      '${l10n.ipv6SupernetAddressesTitle}: ${_addresses.join(', ')}',
    ];

    if (_statusText != null && _statusText!.isNotEmpty) {
      lines.add(_statusText!);
    }

    if (_supernetResult != null) {
      lines.add('${l10n.ipv6SupernetResultValue}: $_supernetResult');
    }

    if (_relations.isNotEmpty) {
      lines.add(l10n.ipv6SupernetRelationsTitle);
      lines.addAll(_relations.map((relation) => '${relation.addressA} -> ${_relationLabel(l10n, relation.relationAB)} -> ${relation.addressB}'));
    }

    return lines.join('\n');
  }

  Future<void> _copySupernetResult(AppLocalizations l10n) async {
    await Clipboard.setData(ClipboardData(text: _supernetResultAsPlainText(l10n)));
    _showResultSnackBar(l10n.ipv6ResultCopied);
  }

  Future<void> _saveSupernetResult(AppLocalizations l10n) async {
    if (!isIpv6ResultFileExportSupported) {
      _showResultSnackBar(l10n.ipv6ResultExportUnsupported);
      return;
    }

    try {
      final filePath = await exportIpv6ResultToTextFile(
        _supernetResultAsPlainText(l10n),
        prefix: 'ipv6_supernet_result',
      );
      if (filePath == null || filePath.isEmpty) {
        _showResultSnackBar(l10n.ipv6ResultExportError);
        return;
      }
      _showResultSnackBar(l10n.ipv6ResultExported(filePath));
    } catch (_) {
      _showResultSnackBar(l10n.ipv6ResultExportError);
    }
  }

  void _showResultSnackBar(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildResultActions(AppLocalizations l10n) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            key: _resultCopyButtonKey,
            tooltip: l10n.ipv6ResultCopy,
            onPressed: () => unawaited(_copySupernetResult(l10n)),
            icon: const Icon(Icons.content_copy_outlined),
          ),
          IconButton(
            key: _resultSaveButtonKey,
            tooltip: l10n.ipv6ResultSave,
            onPressed: () => unawaited(_saveSupernetResult(l10n)),
            icon: const Icon(Icons.save_alt_outlined),
          ),
        ],
      ),
    );
  }

  Future<void> _calculateSupernet({bool hideMobileKeypad = false}) async {
    final l10n = AppLocalizations.of(context);

    if (_addresses.length < 2) {
      setState(() {
        _statusText = l10n.ipv6SupernetErrorNeedTwo;
        _supernetResult = null;
        _relations.clear();
        _allContiguous = null;
        if (hideMobileKeypad) {
          _isMobileKeypadVisible = false;
        }
      });
      unawaited(_persistState());
      return;
    }

    try {
      final dedup = SupernetIPv6.processDuplicateAddresses(_addresses);
      final unique = dedup.uniqueAddresses;

      if (unique.length < 2) {
        setState(() {
          _statusText = l10n.ipv6SupernetErrorNeedTwo;
          _supernetResult = null;
          _relations.clear();
          _allContiguous = null;
          if (hideMobileKeypad) {
            _isMobileKeypadVisible = false;
          }
        });
        unawaited(_persistState());
        return;
      }

      final duplicateMessages = dedup.duplicateCounts.entries
          .map((entry) => l10n.ipv6SupernetDuplicateMessage(entry.key, entry.value))
          .toList();
      final objects = unique.map(SupernetIPv6.new).toList();
      final contiguous = SupernetIPv6.isAListOfContiguousAddresses(List<AddressIPV6>.from(objects));
      final supernetCidr = SupernetIPv6.supernetCalc(List<SupernetIPv6>.from(objects));
      final relations = contiguous ? <Relation>[] : SupernetIPv6.computeRelations(List<SupernetIPv6>.from(objects));

      setState(() {
        _addresses
          ..clear()
          ..addAll(unique);
        _duplicateMessages
          ..clear()
          ..addAll(duplicateMessages);
        _allContiguous = contiguous;
        _statusText = contiguous ? l10n.ipv6SupernetContiguousYes : l10n.ipv6SupernetContiguousNo;
        _supernetResult = supernetCidr;
        _relations
          ..clear()
          ..addAll(relations);
        if (hideMobileKeypad) {
          _isMobileKeypadVisible = false;
        }
      });
      unawaited(_persistState());
    } on MyException catch (_) {
      setState(() {
        _statusText = l10n.ipv6SupernetErrorGeneric;
        if (hideMobileKeypad) {
          _isMobileKeypadVisible = false;
        }
      });
      unawaited(_persistState());
    } catch (_) {
      setState(() {
        _statusText = l10n.ipv6SupernetErrorGeneric;
        if (hideMobileKeypad) {
          _isMobileKeypadVisible = false;
        }
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
          unawaited(_calculateSupernet());
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

  Widget _buildAddressesChips() {
    return Wrap(
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
    );
  }

  Widget _buildResultCard(AppLocalizations l10n, {required bool showActions}) {
    return Card(
      color: Colors.white.withAlpha(200),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.ipv6SupernetResultTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            if (_supernetResult != null) Text('${l10n.ipv6SupernetResultValue}: $_supernetResult'),
            if (showActions) ...[
              const Divider(),
              _buildResultActions(l10n),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRelationsCard(AppLocalizations l10n, {required bool showActions}) {
    return Card(
      color: Colors.white.withAlpha(200),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.ipv6SupernetRelationsTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ..._relations.map(
              (relation) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text('${relation.addressA} -> ${_relationLabel(l10n, relation.relationAB)} -> ${relation.addressB}'),
              ),
            ),
            if (showActions) ...[
              const Divider(),
              _buildResultActions(l10n),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bool showMobileKeypad = !kIsWeb && _isMobilePlatform(Theme.of(context).platform) && _isMobileKeypadVisible;
    final bool hasRelations = _relations.isNotEmpty;

    return Container(
      decoration: _themeManager.backgroundDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(l10n.ipv6SupernetTitle),
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
                          l10n.ipv6SupernetInputLabel,
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
                            hintText: l10n.ipv6SupernetInputHint,
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
                                  child: Text(l10n.ipv6SupernetActionAdd),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: SizedBox(
                                height: _mobileKeyHeight,
                                child: ElevatedButton(
                                  style: _keyButtonStyle(),
                                  onPressed: _addresses.length >= 2 ? () => _calculateSupernet(hideMobileKeypad: showMobileKeypad) : null,
                                  child: Text(l10n.ipv6SupernetActionCalculate),
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
                                  child: Text(l10n.ipv6SupernetActionReset),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${l10n.ipv6SupernetAddressesTitle} (${_addresses.length})',
                          style: TextStyle(fontWeight: FontWeight.w600, color: _themeManager.displayTextColor),
                        ),
                        const SizedBox(height: 8),
                        if (_addresses.isEmpty)
                          Text(l10n.ipv6SupernetErrorNeedTwo)
                        else
                          _buildAddressesChips(),
                        if (_duplicateMessages.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          ..._duplicateMessages.map((message) => Text(message, style: const TextStyle(color: Colors.orange))),
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
                          _buildResultCard(l10n, showActions: !hasRelations),
                        ],
                        if (hasRelations) ...[
                          const SizedBox(height: 16),
                          _buildRelationsCard(l10n, showActions: true),
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


