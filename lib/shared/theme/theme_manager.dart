import 'package:flutter/material.dart';

/// Manages shared theme colors across calculator modules.
class ThemeManager extends ChangeNotifier {
  Color _backgroundColor = Colors.white;
  Color _buttonGroupColor = Colors.grey[700]!;
  Color _displayTextColor = Colors.black;
  Color _buttonTextColor = Colors.grey[200]!;

  Color get backgroundColor => _backgroundColor;
  Color get buttonGroupColor => _buttonGroupColor;
  Color get displayTextColor => _displayTextColor;
  Color get buttonTextColor => _buttonTextColor;

  void setBackgroundColor(Color color) {
    _backgroundColor = color;
    notifyListeners();
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
}

