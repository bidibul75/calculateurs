import 'dart:async';

import 'package:calculators/calculators/ip/IPv4/address.dart';
import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/shared/theme/theme_manager.dart' as shared_theme;
import 'package:calculators/shared/widgets/menu_drawer.dart';
import 'package:calculators/shared/widgets/photo_credit_link.dart';
import 'package:calculators/utils/extensions/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/ipv4_result_export_service.dart';

class Ipv4AddressScreen extends StatefulWidget {
  const Ipv4AddressScreen({super.key});

  @override
  State<Ipv4AddressScreen> createState() => _Ipv4AddressScreenState();
}

class _Ipv4AddressScreenState extends State<Ipv4AddressScreen> {
  static const String _inputPreferenceKey = 'ipv4.address.input.v1';
  static const String _showMobileKeypadPreferenceKey = 'ipv4.address.mobileKeypadVisible.v1';
  static const String _lastValidInputPreferenceKey = 'ipv4.address.lastValidInput.v1';

  static const double _mobileKeyHeight = 52;
  static const Duration _mobileKeypadAnimationDuration = Duration(milliseconds: 220);
  static const Key _mobileKeypadContainerKey = ValueKey<String>('ipv4.mobileKeypad');
  static const Key _clearButtonKey = ValueKey<String>('ipv4.key.clear');
  static const Key _backspaceButtonKey = ValueKey<String>('ipv4.key.backspace');
  static const Key _enterButtonKey = ValueKey<String>('ipv4.key.enter');
  static const Key _resultCopyButtonKey = ValueKey<String>('ipv4.result.copy');
  static const Key _resultSaveButtonKey = ValueKey<String>('ipv4.result.save');

  final shared_theme.ThemeManager _themeManager = GetIt.I<shared_theme.ThemeManager>();
  final TextEditingController _inputController = TextEditingController();

  Address? _result;
  String? _errorText;
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
      _isMobileKeypadVisible = true;
    });
    unawaited(_persistState());
  }

  void _calculate({bool hideMobileKeypad = false}) {
    final l10n = AppLocalizations.of(context);
    final rawInput = _inputController.text.trim();

    if (rawInput.isEmpty) {
      setState(() {
        _result = null;
        _errorText = l10n.ipv4ErrorEmptyCidr;
        if (hideMobileKeypad) _isMobileKeypadVisible = false;
      });
      unawaited(_persistState());
      return;
    }

    // Accept harmless spaces in user input, then validate the canonical CIDR form.
    final normalizedInput = rawInput.replaceAll(' ', '');
    if (!normalizedInput.isValidIPv4CIDR) {
      setState(() {
        _result = null;
        _errorText = l10n.ipv4ErrorInvalidCidr;
        if (hideMobileKeypad) _isMobileKeypadVisible = false;
      });
      unawaited(_persistState());
      return;
    }

    try {
      final address = Address(normalizedInput);
      setState(() {
        _result = address;
        _errorText = null;
        if (hideMobileKeypad) _isMobileKeypadVisible = false;
      });
      unawaited(_persistState());
    } catch (_) {
      setState(() {
        _result = null;
        _errorText = l10n.ipv4ErrorGeneric;
        if (hideMobileKeypad) _isMobileKeypadVisible = false;
      });
      unawaited(_persistState());
    }
  }

  /// Returns true only on Android and iOS to enable the custom mobile keypad.
  bool _isMobilePlatform(TargetPlatform platform) {
    return platform == TargetPlatform.android || platform == TargetPlatform.iOS;
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

      if (savedLastValidInput.isNotEmpty) {
        try {
          _result = Address(savedLastValidInput);
          _errorText = null;
        } catch (_) {
          _result = null;
        }
      }
    });
  }

  Future<void> _persistState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_inputPreferenceKey, _inputController.text);
    await prefs.setBool(_showMobileKeypadPreferenceKey, _isMobileKeypadVisible);
    await prefs.setString(_lastValidInputPreferenceKey, _result?.addressToProcess ?? '');
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

  Widget _buildMobileKeypad() {
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
              Row(children: [_buildKeyButton('.', fontSize: fontSize, padding: keyPadding), _buildKeyButton('0', fontSize: fontSize, padding: keyPadding), _buildKeyButton('/', fontSize: fontSize, padding: keyPadding)]),
              const SizedBox(height: 8),
              _buildActionKeyButton(
                label: 'Enter',
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

  String _addressScope(AppLocalizations l10n, Address address) {
    final int first = int.parse(address.addressOnlyList[0]);
    final int second = int.parse(address.addressOnlyList[1]);

    // Classify common IPv4 scopes used by admins (private, loopback, link-local, multicast, reserved).
    if (first == 10 || (first == 172 && second >= 16 && second <= 31) || (first == 192 && second == 168)) {
      return l10n.ipv4ScopePrivate;
    }
    if (first == 127) return l10n.ipv4ScopeLoopback;
    if (first == 169 && second == 254) return l10n.ipv4ScopeLinkLocal;
    if (first >= 224 && first <= 239) return l10n.ipv4ScopeMulticast;
    if (first >= 240) return l10n.ipv4ScopeReserved;
    return l10n.ipv4ScopePublic;
  }

  String _addressClass(Address address) {
    final int first = int.parse(address.addressOnlyList[0]);
    if (first <= 127) return 'A';
    if (first <= 191) return 'B';
    if (first <= 223) return 'C';
    if (first <= 239) return 'D';
    return 'E';
  }

  String _hostDisplay(List<String> host) {
    return host.join('.');
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

  void _showResultSnackBar(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _addressResultAsPlainText(AppLocalizations l10n, Address address) {
    final rows = <String>[
      '${l10n.ipv4InfoPrefix}: /${address.suffix}',
      '${l10n.ipv4InfoClass}: ${_addressClass(address)}',
      '${l10n.ipv4InfoScope}: ${_addressScope(l10n, address)}',
      '${l10n.ipv4InfoMask}: ${address.mask}',
      '${l10n.ipv4InfoWildcard}: ${address.wildcardMask}',
      '${l10n.ipv4InfoNetwork}: ${address.addressNetwork}',
      '${l10n.ipv4InfoBroadcast}: ${address.addressBroadcast}',
      '${l10n.ipv4InfoFirstHost}: ${_hostDisplay(address.addressAvailableFirstOne)}',
      '${l10n.ipv4InfoLastHost}: ${_hostDisplay(address.addressAvailableLastOne)}',
      '${l10n.ipv4InfoTotalAddresses}: ${address.numberAvailableAddresses}',
      '${l10n.ipv4InfoUsableHosts}: ${address.numberUsableAddresses}',
      '${l10n.ipv4InfoNetworkBinary}: ${address.addressNetworkStringBinary}',
      '${l10n.ipv4InfoBroadcastBinary}: ${address.addressBroadcastStringBinary}',
    ];

    return rows.join('\n');
  }

  Future<void> _copyAddressResult(AppLocalizations l10n, Address address) async {
    await Clipboard.setData(ClipboardData(text: _addressResultAsPlainText(l10n, address)));
    _showResultSnackBar(l10n.ipv4ResultCopied);
  }

  Future<void> _saveAddressResult(AppLocalizations l10n, Address address) async {
    if (!isIpv4ResultFileExportSupported) {
      _showResultSnackBar(l10n.ipv4ResultExportUnsupported);
      return;
    }

    try {
      final filePath = await exportIpv4ResultToTextFile(
        _addressResultAsPlainText(l10n, address),
        prefix: 'ipv4_address_result',
      );
      if (filePath == null || filePath.isEmpty) {
        _showResultSnackBar(l10n.ipv4ResultExportError);
        return;
      }
      _showResultSnackBar(l10n.ipv4ResultExported(filePath));
    } catch (_) {
      _showResultSnackBar(l10n.ipv4ResultExportError);
    }
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
            tooltip: l10n.ipv4ResultCopy,
            onPressed: onCopy,
            icon: const Icon(Icons.content_copy_outlined),
          ),
          IconButton(
            key: _resultSaveButtonKey,
            tooltip: l10n.ipv4ResultSave,
            onPressed: onSave,
            icon: const Icon(Icons.save_alt_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(AppLocalizations l10n, Address address) {
    return Card(
      color: Colors.white.withAlpha(200),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(l10n.ipv4InfoPrefix, '/${address.suffix}'),
            _buildInfoRow(l10n.ipv4InfoClass, _addressClass(address)),
            _buildInfoRow(l10n.ipv4InfoScope, _addressScope(l10n, address)),
            const Divider(),
            _buildInfoRow(l10n.ipv4InfoMask, address.mask),
            _buildInfoRow(l10n.ipv4InfoWildcard, address.wildcardMask),
            _buildInfoRow(l10n.ipv4InfoNetwork, address.addressNetwork),
            _buildInfoRow(l10n.ipv4InfoBroadcast, address.addressBroadcast),
            _buildInfoRow(l10n.ipv4InfoFirstHost, _hostDisplay(address.addressAvailableFirstOne)),
            _buildInfoRow(l10n.ipv4InfoLastHost, _hostDisplay(address.addressAvailableLastOne)),
            const Divider(),
            _buildInfoRow(l10n.ipv4InfoTotalAddresses, address.numberAvailableAddresses.toString()),
            _buildInfoRow(l10n.ipv4InfoUsableHosts, address.numberUsableAddresses.toString()),
            const Divider(),
            _buildInfoRow(l10n.ipv4InfoNetworkBinary, address.addressNetworkStringBinary),
            _buildInfoRow(l10n.ipv4InfoBroadcastBinary, address.addressBroadcastStringBinary),
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
    // Mobile app uses the custom keypad; desktop/web keeps standard text input behavior.
    final bool isMobileApp = !kIsWeb && _isMobilePlatform(Theme.of(context).platform);
    final bool showMobileKeypad = isMobileApp && _isMobileKeypadVisible;

    return Container(
      decoration: _themeManager.backgroundDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(l10n.ipv4Title),
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
                          l10n.ipv4InputLabel,
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
                          onSubmitted: (_) => _calculate(hideMobileKeypad: true),
                          decoration: InputDecoration(
                            hintText: l10n.ipv4InputHint,
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
                              ? _buildMobileKeypad()
                              : const SizedBox(key: ValueKey<String>('ipv4.mobileKeypad.hidden')),
                        ),
                        const SizedBox(height: 12),
                        if (isMobileApp)
                          if (!showMobileKeypad)
                            SizedBox(
                              height: _mobileKeyHeight,
                              child: ElevatedButton(
                                style: _keyButtonStyle(backgroundColor: Colors.redAccent),
                                onPressed: _clear,
                                child: Text(l10n.ipv4ActionClear),
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
                                    child: Text(l10n.ipv4ActionCalculate),
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
                                    child: Text(l10n.ipv4ActionClear),
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

