// lib/calculators/conversions/weight/controllers/weight_controller.dart
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../../../utils/i18n/local_number_symbols.dart';
import '../models/weight_state.dart';
import '../services/weight_logic.dart';
import 'package:calculators/utils/extensions/string_extensions.dart';

/// Controller handling user input and state updates for the weight converter.
class WeightController extends ChangeNotifier {
  WeightController() : _state = WeightState.initial() {
    _decimalSeparator = GetIt.I<LocalNumberSymbols>().decimalSep;
  }

  WeightState _state;
  late final String _decimalSeparator;

  WeightState get state => _state;

  void onUnitSelected(WeightScale unit) {
    _state = _state.copyWith(activeUnit: unit, currentInput: '0');
    _recalculateFromCurrentInput();
  }

  void onButtonPressed(String label) {
    switch (label) {
      case 'C':
        _clearInput();
        return;
      case '⌫':
        _backspace();
        return;
      default:
        _appendToInput(label);
    }
  }

  void cycleActiveUnit() {
    _cycleActiveUnit();
  }

  void _clearInput() {
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
    final String nextInput = current.realTimeL10n(char, _decimalSeparator);
    _state = _state.copyWith(currentInput: nextInput);
    _recalculateFromCurrentInput();
  }

  void _cycleActiveUnit() {
    final nextUnit = switch (_state.activeUnit) {
      WeightScale.kilogram => WeightScale.gram,
      WeightScale.gram => WeightScale.pound,
      WeightScale.pound => WeightScale.ounce,
      WeightScale.ounce => WeightScale.stone,
      WeightScale.stone => WeightScale.kilogram,
    };
    onUnitSelected(nextUnit);
  }

  void _recalculateFromCurrentInput() {
    final values = WeightLogic.convert(_state.currentInput, _state.activeUnit);
    _state = _state.copyWith(
      kilogram: values.kilogram,
      gram: values.gram,
      pound: values.pound,
      ounce: values.ounce,
      stone: values.stone,
    );
    notifyListeners();
  }
}
