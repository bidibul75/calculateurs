import 'package:flutter/material.dart';

/// Manages the theme state for the calculator
class ThemeManager extends ChangeNotifier {
  Color _backgroundColor = Colors.white;
  Color _buttonGroupColor = Colors.grey[850]!;

  Color get backgroundColor => _backgroundColor;
  Color get buttonGroupColor => _buttonGroupColor;

  void setBackgroundColor(Color color) {
    _backgroundColor = color;
    notifyListeners();
  }

  void setButtonGroupColor(Color color) {
    _buttonGroupColor = color;
    notifyListeners();
  }
}

