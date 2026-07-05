// lib/calculators/conversions/temperature/controllers/temperature_controller.dart
import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../models/temperature_state.dart';
import '../services/temperature_logic.dart';
import 'package:calculators/utils/extensions/string_extensions.dart';

class TemperatureController extends ChangeNotifier {
  TemperatureState _state = const TemperatureState();

  TemperatureState get state => _state;

  TemperatureController() {
    _recalculateFromCurrentInput();
  }

  void onScaleSelected(TemperatureScale scale) {
    final selectedInput = _valueForScale(scale);
    _state = _state.copyWith(activeScale: scale, currentInput: selectedInput);
    _recalculateFromCurrentInput();
  }

  void onButtonPressed(String label) {
    if (label == 'C') {
      _clear();
    } else if (label == '⌫') {
      _backspace();
    } else {
      _appendToInput(label);
    }
  }

  void _clear() {
    _state = _state.copyWith(currentInput: '0');
    _recalculateFromCurrentInput();
  }

  void _backspace() {
    final current = _state.currentInput;
    if (current.length <= 1) {
      _state = _state.copyWith(currentInput: '0');
    } else {
      _state = _state.copyWith(currentInput: current.substring(0, current.length - 1));
    }
    _recalculateFromCurrentInput();
  }

  void _appendToInput(String char) {
    final current = _state.currentInput;
    final String nextInput;

    nextInput = current.realTimeL10n(char, _decimalSeparator);

    _state = _state.copyWith(currentInput: nextInput);
    _recalculateFromCurrentInput();
  }

  void _recalculateFromCurrentInput() {
    final values = TemperatureLogic.convert(_state.currentInput, _state.activeScale);
    _state = _state.copyWith(
      celsius: values.celsius,
      fahrenheit: values.fahrenheit,
      kelvin: values.kelvin,
      rankine: values.rankine,
    );
    notifyListeners();
  }

  String _valueForScale(TemperatureScale scale) {
    return switch (scale) {
      TemperatureScale.celsius => _state.celsius,
      TemperatureScale.fahrenheit => _state.fahrenheit,
      TemperatureScale.kelvin => _state.kelvin,
      TemperatureScale.rankine => _state.rankine,
    };
  }

  String get _decimalSeparator => GetIt.I<LocalNumberSymbols>().decimalSep;
}
