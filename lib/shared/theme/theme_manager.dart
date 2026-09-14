// lib/shared/theme/theme_manager.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages shared theme colors across calculator modules.
class ThemeManager extends ChangeNotifier {
  static const String backgroundPresetWhite = 'background.white';
  static const String backgroundPresetDark = 'background.dark';
  static const String backgroundPresetLightBlue = 'background.lightBlue';
  static const String backgroundPresetLightAmber = 'background.lightAmber';
  static const String backgroundPresetSoftGrey = 'background.softGrey';
  static const String backgroundPresetWallpaper = 'background.wallpaper';
  static const String backgroundPresetBrushedMetal = 'background.brushedMetal';
  static const String buttonStylePresetFlat = 'buttonStyle.flat';
  static const String buttonStylePresetThreeD = 'buttonStyle.threeD';
  static const String wallpaperAssetPath = 'assets/textures/bady-abbas-5HI7Ea3yD-w-unsplash.jpg';
  static const String brushedMetalAssetPath = 'assets/textures/brushed_metal.jpg';
  static const String _backgroundPreferenceKey = 'theme.backgroundPreset';
  static const String _buttonStylePreferenceKey = 'theme.buttonStylePreset';

  static const Map<String, Color> _colorPresets = {
    backgroundPresetWhite: Colors.white,
    backgroundPresetDark: Color(0xFF212121),
    backgroundPresetLightBlue: Color(0xFFE3F2FD),
    backgroundPresetLightAmber: Color(0xFFFFF8E1),
    backgroundPresetSoftGrey: Color(0xFFF2F2F2),
  };

  Color _backgroundColor = Colors.white;
  String? _backgroundImageAsset;
  String _backgroundPresetId = backgroundPresetWhite;
  Color _buttonGroupColor = Colors.grey[700]!;
  Color _displayTextColor = Colors.black;
  Color _buttonTextColor = Colors.grey[200]!;
  String _buttonStylePresetId = buttonStylePresetThreeD;

  Color get backgroundColor => _backgroundColor;
  String? get backgroundImageAsset => _backgroundImageAsset;
  String get backgroundPresetId => _backgroundPresetId;
  Color get buttonGroupColor => _buttonGroupColor;
  Color get displayTextColor => _displayTextColor;
  Color get buttonTextColor => _buttonTextColor;
  String get buttonStylePresetId => _buttonStylePresetId;
  bool get isThreeDButtonStyle => _buttonStylePresetId == buttonStylePresetThreeD;
  bool get isUnsplashBackgroundActive => _backgroundPresetId == backgroundPresetWallpaper;

  BoxDecoration get backgroundDecoration {
    return BoxDecoration(
      color: _backgroundColor,
      image: _backgroundImageAsset == null
          ? null
          : DecorationImage(
              image: AssetImage(_backgroundImageAsset!),
              fit: BoxFit.cover,
            ),
    );
  }

  Future<void> restoreBackgroundPreset() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPresetId = prefs.getString(_backgroundPreferenceKey);
    if (savedPresetId != null) {
      _applyBackgroundPreset(savedPresetId, notifyListeners: false);
    }
    final savedButtonStyle = prefs.getString(_buttonStylePreferenceKey);
    if (savedButtonStyle != null) {
      setButtonStylePreset(savedButtonStyle, notifyListeners: false);
    }
  }

  void setBackgroundColor(Color color) {
    final presetId = _presetIdForColor(color);
    _applyBackgroundColor(color, presetId ?? 'background.custom');
  }

  void setBackgroundImageAsset(String assetPath, {String? presetId}) {
    final resolvedPresetId = presetId ?? _presetIdForAsset(assetPath) ?? 'background.customImage';
    _applyBackgroundImage(assetPath, resolvedPresetId);
  }

  void setBackgroundPreset(String presetId) {
    _applyBackgroundPreset(presetId);
  }

  void setButtonGroupColor(Color color) {
    _buttonGroupColor = color;
    notifyListeners();
  }

  void setDisplayTextColor(Color color) {
    _displayTextColor = color;
    notifyListeners();
  }

  void setButtonTextColor(Color color) {
    _buttonTextColor = color;
    notifyListeners();
  }

  void setButtonStylePreset(String presetId, {bool notifyListeners = true}) {
    final validPreset = presetId == buttonStylePresetFlat || presetId == buttonStylePresetThreeD
        ? presetId
        : buttonStylePresetThreeD;
    _buttonStylePresetId = validPreset;
    if (notifyListeners) {
      this.notifyListeners();
    }
    unawaited(_persistButtonStylePreset());
  }

  LinearGradient buttonGradient(Color baseColor) {
    if (!isThreeDButtonStyle) return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [baseColor, baseColor],
    );

    final topColor = Color.alphaBlend(Colors.white.withAlpha(90), baseColor);
    final midColor = Color.alphaBlend(Colors.black.withAlpha(12), baseColor);
    final bottomColor = Color.alphaBlend(Colors.black.withAlpha(42), baseColor);

    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [topColor, midColor, bottomColor],
      stops: const [0.0, 0.52, 1.0],
    );
  }

  BoxDecoration buttonSurfaceDecoration(Color baseColor, {double borderRadius = 8, double borderWidth = 1.5}) {
    final sideColor = isThreeDButtonStyle ? Colors.white.withAlpha(80) : Colors.grey[200]!;
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: sideColor, width: borderWidth),
      gradient: buttonGradient(baseColor),
      boxShadow: isThreeDButtonStyle
          ? [
              BoxShadow(
                color: Colors.black.withAlpha(130),
                offset: const Offset(0, 3),
                blurRadius: 0,
                spreadRadius: 0,
              ),
            ]
          : null,
    );
  }

  ButtonStyle calculatorButtonStyle({
    required Color backgroundColor,
    required Color foregroundColor,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
    double borderRadius = 8,
    double borderWidth = 1.5,
    bool isDangerAction = false,
  }) {
    final bool isThreeD = _buttonStylePresetId == buttonStylePresetThreeD;
    final Color effectiveBackground = isDangerAction ? Colors.redAccent : backgroundColor;
    final Color sideColor = isThreeD ? Colors.white.withAlpha(80) : Colors.grey[200]!;
    final Color pressedOverlay = isThreeD ? Colors.black.withAlpha(26) : Colors.white.withAlpha(30);

    return ElevatedButton.styleFrom(
      backgroundColor: effectiveBackground,
      foregroundColor: foregroundColor,
      disabledBackgroundColor: effectiveBackground.withAlpha(120),
      disabledForegroundColor: foregroundColor.withAlpha(140),
      elevation: isThreeD ? 0 : 1,
      shadowColor: Colors.transparent,
      overlayColor: pressedOverlay,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: sideColor, width: borderWidth),
      ),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      minimumSize: minimumSize ?? const Size(0, 42),
    );
  }

  void _applyBackgroundPreset(String presetId, {bool notifyListeners = true}) {
    if (_colorPresets.containsKey(presetId)) {
      _applyBackgroundColor(_colorPresets[presetId]!, presetId, notifyListeners: notifyListeners);
      return;
    }

    switch (presetId) {
      case backgroundPresetSoftGrey:
        _applyBackgroundColor(_colorPresets[backgroundPresetSoftGrey]!, presetId, notifyListeners: notifyListeners);
        return;
      case backgroundPresetWallpaper:
        _applyBackgroundImage(wallpaperAssetPath, presetId, notifyListeners: notifyListeners);
        return;
      case backgroundPresetBrushedMetal:
        _applyBackgroundImage(brushedMetalAssetPath, presetId, notifyListeners: notifyListeners);
        return;
    }
  }

  void _applyBackgroundColor(Color color, String presetId, {bool notifyListeners = true}) {
    _backgroundColor = color;
    _backgroundImageAsset = null;
    _backgroundPresetId = presetId;
    if (notifyListeners) {
      this.notifyListeners();
    }
    unawaited(_persistBackgroundPreset());
  }

  void _applyBackgroundImage(String assetPath, String presetId, {bool notifyListeners = true}) {
    _backgroundColor = Colors.white;
    _backgroundImageAsset = assetPath;
    _backgroundPresetId = presetId;
    if (notifyListeners) {
      this.notifyListeners();
    }
    unawaited(_persistBackgroundPreset());
  }

  String? _presetIdForAsset(String assetPath) {
    if (assetPath == wallpaperAssetPath) return backgroundPresetWallpaper;
    if (assetPath == brushedMetalAssetPath) return backgroundPresetBrushedMetal;
    return null;
  }

  String? _presetIdForColor(Color color) {
    for (final entry in _colorPresets.entries) {
      if (entry.value == color) {
        return entry.key;
      }
    }
    return null;
  }

  Future<void> _persistBackgroundPreset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_backgroundPreferenceKey, _backgroundPresetId);
  }

  Future<void> _persistButtonStylePreset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_buttonStylePreferenceKey, _buttonStylePresetId);
  }
}

