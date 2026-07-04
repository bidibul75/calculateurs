// lib/calculators/ip/IPv6/screens/ipv6_address_screen.dart
import 'dart:async';

import 'package:calculators/calculators/ip/IPv6/address_ipv6.dart';
import 'package:calculators/calculators/ip/IPv6/services/ipv6_result_export_service.dart';
import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/shared/services/result_feedback_service.dart';
import 'package:calculators/shared/theme/theme_manager.dart' as shared_theme;
import 'package:calculators/shared/widgets/menu_drawer.dart';
import 'package:calculators/shared/widgets/photo_credit_link.dart';
import 'package:calculators/utils/extensions/decimal_extensions.dart';
import 'package:calculators/utils/my_exception.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ipv6AddressScreen extends StatefulWidget {
  const Ipv6AddressScreen({super.key});

  @override
  State<Ipv6AddressScreen> createState() => _Ipv6AddressScreenState();
}

class _Ipv6AddressScreenState extends State<Ipv6AddressScreen> {
  static const String _inputPreferenceKey = 'ipv6.address.input.v1';
  static const String _showMobileKeypadPreferenceKey = 'ipv6.address.mobileKeypadVisible.v1';
  static const String _lastValidInputPreferenceKey = 'ipv6.address.lastValidInput.v1';

  static const double _mobileKeyHeight = 52;
  static const Duration _mobileKeypadAnimationDuration = Duration(milliseconds: 220);
  static const Key _mobileKeypadContainerKey = ValueKey<String>('ipv6.mobileKeypad');
  static const Key _clearButtonKey = ValueKey<String>('ipv6.key.clear');
  static const Key _backspaceButtonKey = ValueKey<String>('ipv6.key.backspace');
  static const Key _enterButtonKey = ValueKey<String>('ipv6.key.enter');
  static const Key _resultCopyButtonKey = ValueKey<String>('ipv6.result.copy');
  static const Key _resultSaveButtonKey = ValueKey<String>('ipv6.result.save');

  final shared_theme.ThemeManager _themeManager = GetIt.I<shared_theme.ThemeManager>();
  final TextEditingController _inputController = TextEditingController();

  AddressIPV6? _result;
  String? _errorText;
  String? _lastValidInput;
  bool _isMobileKeypadVisible = true;

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

  void _clear() {
    setState(() {
      _inputController.clear();
      _result = null;
      _errorText = null;
      _lastValidInput = null;
      _isMobileKeypadVisible = true;
    });
    unawaited(_persistState());
  }

  void _appendToInput(String value) {
    setState(() {
      _inputController.text = '${_inputController.text}$value';
      _errorText = null;
    });
    unawaited(_persistState());
  }

  void _deleteLastChar() {
    if (_inputController.text.isEmpty) {
      return;
    }

    setState(() {
      _inputController.text = _inputController.text.substring(0, _inputController.text.length - 1);
      _errorText = null;
    });
    unawaited(_persistState());
  }

  void _clearInputOnly() {
    setState(() {
      _inputController.clear();
      _errorText = null;
      _isMobileKeypadVisible = true;
    });
    unawaited(_persistState());
  }

  bool _isMobilePlatform(TargetPlatform platform) {
    return platform == TargetPlatform.android || platform == TargetPlatform.iOS;
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

  Widget _buildKeyButton(
    String label, {
    required double fontSize,
    required EdgeInsets padding,
    Key? buttonKey,
  }) {
    return Expanded(
      child: Padding(
        padding: padding,
        child: SizedBox(
          height: _mobileKeyHeight,
          width: double.infinity,
          child: ElevatedButton(
            key: buttonKey,
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
        final double fontSize = compact ? 18 : 20;
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
                    label: 'C',
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
                onPressed: () => _calculate(hideMobileKeypad: true),
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

  void _calculate({bool hideMobileKeypad = false}) {
    final l10n = AppLocalizations.of(context);
    final rawInput = _inputController.text.trim();

    if (rawInput.isEmpty) {
      setState(() {
        _result = null;
        _errorText = l10n.ipv6ErrorEmptyAddress;
        if (hideMobileKeypad) {
          _isMobileKeypadVisible = false;
        }
      });
      unawaited(_persistState());
      return;
    }

    try {
      final parsed = AddressIPV6(rawInput);
      final normalized = AddressIPV6.cidrSimplifier('${parsed.addressWithoutSuffixString}/${parsed.suffix}');
      final canonicalInput = normalized.toUpperCase();

      setState(() {
        _result = AddressIPV6(canonicalInput);
        _errorText = null;
        _lastValidInput = canonicalInput;
        if (hideMobileKeypad) {
          _isMobileKeypadVisible = false;
        }
      });
      unawaited(_persistState());
    } on MyException catch (error) {
      setState(() {
        _result = null;
        _errorText = AddressIPV6.localizeError(l10n, error.error);
        if (hideMobileKeypad) {
          _isMobileKeypadVisible = false;
        }
      });
      unawaited(_persistState());
    } catch (_) {
      setState(() {
        _result = null;
        _errorText = l10n.ipv6ErrorGeneric;
        if (hideMobileKeypad) {
          _isMobileKeypadVisible = false;
        }
      });
      unawaited(_persistState());
    }
  }

  Future<void> _restorePersistedState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedInput = prefs.getString(_inputPreferenceKey) ?? '';
    final savedLastValidInput = prefs.getString(_lastValidInputPreferenceKey) ?? '';
    final savedMobileKeypadVisible = prefs.getBool(_showMobileKeypadPreferenceKey);

    if (!mounted) {
      return;
    }

    setState(() {
      _inputController.text = savedInput;
      if (savedMobileKeypadVisible != null) {
        _isMobileKeypadVisible = savedMobileKeypadVisible;
      }
      _lastValidInput = savedLastValidInput.isEmpty ? null : savedLastValidInput;

      if (savedLastValidInput.isNotEmpty) {
        try {
          _result = AddressIPV6(savedLastValidInput);
          _errorText = null;
        } on MyException {
          _result = null;
        }
      }
    });
  }

  Future<void> _persistState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_inputPreferenceKey, _inputController.text);
    await prefs.setBool(_showMobileKeypadPreferenceKey, _isMobileKeypadVisible);
    await prefs.setString(_lastValidInputPreferenceKey, _lastValidInput ?? '');
  }

  String _addressType(AddressIPV6 address) {
    final type = AddressIPV6.identifyType(address.addressWithoutSuffixString);
    final l10n = AppLocalizations.of(context);
    return AddressIPV6.typeLabel(l10n, type).isEmpty ? l10n.ipv6TypeUnknown : AddressIPV6.typeLabel(l10n, type);
  }

  String _simplifiedNetwork(AddressIPV6 address) {
    return AddressIPV6.cidrSimplifier('${address.networkAdress6.join(":")}/${address.suffix}').toUpperCase().split('/').first;
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w600, color: _themeManager.displayTextColor),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: SelectableText(
              value,
              style: TextStyle(color: _themeManager.displayTextColor),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _addressResultAsPlainText(AppLocalizations l10n, AddressIPV6 address) {
    final simplifiedAddress = AddressIPV6.cidrSimplifier('${address.addressWithoutSuffixString}/${address.suffix}').toUpperCase();
    final simplifiedNetwork = _simplifiedNetwork(address);
    final rows = <String>[
      '${l10n.ipv6InfoPrefix}: /${address.suffix}',
      '${l10n.ipv6InfoType}: ${_addressType(address)}',
      '${l10n.ipv6InfoSimplifiedAddress}: $simplifiedAddress',
      '${l10n.ipv6InfoExpandedAddress}: ${address.address6WithoutSuffixListString.join(":")}',
      '${l10n.ipv6InfoSimplifiedNetwork}: $simplifiedNetwork',
      '${l10n.ipv6InfoNetwork}: ${address.networkAdress6.join(":")}',
      '${l10n.ipv6InfoTotalAddresses}: ${Decimal.parse(address.numberOfAddresses.toString()).toPreciseFormattedString}',
      '${l10n.ipv6InfoNetworkBinary}: ${AddressIPV6.hexListToBinaryString(address.networkAdress6)}',
    ];

    return rows.join('\n');
  }

  Future<void> _copyAddressResult(AppLocalizations l10n, AddressIPV6 address) async {
    await copyResultToClipboard(
      context: context,
      text: _addressResultAsPlainText(l10n, address),
      copiedMessage: l10n.ipv6ResultCopied,
    );
  }

  Future<void> _saveAddressResult(AppLocalizations l10n, AddressIPV6 address) async {
    await saveResultToFileWithFeedback(
      context: context,
      content: _addressResultAsPlainText(l10n, address),
      prefix: 'ipv6_address_result',
      isExportSupported: isIpv6ResultFileExportSupported,
      exportToTextFile: exportIpv6ResultToTextFile,
      unsupportedMessage: l10n.ipv6ResultExportUnsupported,
      errorMessage: l10n.ipv6ResultExportError,
      exportedMessageBuilder: l10n.ipv6ResultExported,
    );
  }

  Widget _buildResultActions({
    required AppLocalizations l10n,
    required VoidCallback onCopy,
    required VoidCallback onSave,
  }) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            key: _resultCopyButtonKey,
            tooltip: l10n.ipv6ResultCopy,
            onPressed: onCopy,
            icon: const Icon(Icons.content_copy_outlined),
          ),
          IconButton(
            key: _resultSaveButtonKey,
            tooltip: l10n.ipv6ResultSave,
            onPressed: onSave,
            icon: const Icon(Icons.save_alt_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(AppLocalizations l10n, AddressIPV6 address) {
    final simplifiedAddress = AddressIPV6.cidrSimplifier('${address.addressWithoutSuffixString}/${address.suffix}').toUpperCase();
    final simplifiedNetwork = _simplifiedNetwork(address);

    return Card(
      color: Colors.white.withAlpha(200),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(l10n.ipv6InfoPrefix, '/${address.suffix}'),
            _buildInfoRow(l10n.ipv6InfoType, _addressType(address)),
            _buildInfoRow(l10n.ipv6InfoSimplifiedAddress, simplifiedAddress),
            _buildInfoRow(l10n.ipv6InfoExpandedAddress, address.address6WithoutSuffixListString.join(':')),
            const Divider(),
            _buildInfoRow(l10n.ipv6InfoSimplifiedNetwork, simplifiedNetwork),
            _buildInfoRow(l10n.ipv6InfoNetwork, address.networkAdress6.join(':')),
            _buildInfoRow(l10n.ipv6InfoTotalAddresses, Decimal.parse(address.numberOfAddresses.toString()).toPreciseFormattedString),
            _buildInfoRow(l10n.ipv6InfoNetworkBinary, AddressIPV6.hexListToBinaryString(address.networkAdress6)),
            const Divider(),
            _buildResultActions(
              l10n: l10n,
              onCopy: () => unawaited(_copyAddressResult(l10n, address)),
              onSave: () => unawaited(_saveAddressResult(l10n, address)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bool isMobileApp = !kIsWeb && _isMobilePlatform(Theme.of(context).platform);
    final bool showMobileKeypad = isMobileApp && _isMobileKeypadVisible;

    return Container(
      decoration: _themeManager.backgroundDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(l10n.ipv6Title),
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
                          l10n.ipv6InputLabel,
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
                          onTap: isMobileApp
                              ? () {
                                  if (!_isMobileKeypadVisible) {
                                    setState(() {
                                      _isMobileKeypadVisible = true;
                                    });
                                    unawaited(_persistState());
                                  }
                                }
                              : null,
                          onSubmitted: (_) => _calculate(hideMobileKeypad: true),
                          decoration: InputDecoration(
                            hintText: l10n.ipv6InputHint,
                            filled: true,
                            fillColor: Colors.white,
                            border: const OutlineInputBorder(),
                            errorText: _errorText,
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: _mobileKeypadAnimationDuration,
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SizeTransition(
                                axisAlignment: -1,
                                sizeFactor: animation,
                                child: child,
                              ),
                            );
                          },
                          child: showMobileKeypad
                              ? _buildMobileKeypad(l10n)
                              : const SizedBox(key: ValueKey<String>('ipv6.mobileKeypad.hidden')),
                        ),
                        const SizedBox(height: 12),
                        if (isMobileApp)
                          if (!showMobileKeypad)
                            SizedBox(
                              height: _mobileKeyHeight,
                              child: ElevatedButton(
                                style: _keyButtonStyle(backgroundColor: Colors.redAccent),
                                onPressed: _clear,
                                child: Text(l10n.ipv6ActionClear),
                              ),
                            )
                          else
                            const SizedBox.shrink()
                        else
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: _mobileKeyHeight,
                                  child: ElevatedButton(
                                    style: _keyButtonStyle(),
                                    onPressed: () => _calculate(hideMobileKeypad: showMobileKeypad),
                                    child: Text(l10n.ipv6ActionCalculate),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SizedBox(
                                  height: _mobileKeyHeight,
                                  child: ElevatedButton(
                                    style: _keyButtonStyle(backgroundColor: Colors.redAccent),
                                    onPressed: _clear,
                                    child: Text(l10n.ipv6ActionClear),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (_result != null) ...[
                          const SizedBox(height: 16),
                          _buildResultCard(l10n, _result!),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
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


