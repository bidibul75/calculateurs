import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../../../utils/i18n/local_number_symbols.dart';
import 'package:calculators/utils/extensions/string_extensions.dart';
import '../models/percentage_state.dart';
import '../services/percentage_logic.dart';

/// Controller handling user input and linked recalculation for percentage tools.
class PercentageController extends ChangeNotifier {
  PercentageController() : _state = PercentageState.initial() {
    _decimalSeparator = GetIt.I<LocalNumberSymbols>().decimalSep;
  }

  PercentageState _state;
  late final String _decimalSeparator;

  PercentageState get state => _state;

  void onModeSelected(PercentageMode mode) {
    if (_state.mode == mode) return;
    _state = PercentageState.initial(mode: mode);
    notifyListeners();
  }

  void onFieldSelected(PercentageField field) {
    final currentValue = switch (field) {
      PercentageField.primary => _state.primary,
      PercentageField.rate => _state.rate,
      PercentageField.delta => _state.delta,
      PercentageField.result => _state.result,
    };
    _state = _state.copyWith(activeField: field, currentInput: currentValue);
    notifyListeners();
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

  void _recalculateFromCurrentInput() {
    final values = PercentageLogic.convert(
      input: _state.currentInput,
      activeField: _state.activeField,
      mode: _state.mode,
      primary: _state.primary,
      rate: _state.rate,
      delta: _state.delta,
      result: _state.result,
    );
    _state = _state.copyWith(
      primary: values.primary,
      rate: values.rate,
      delta: values.delta,
      result: values.result,
    );
    notifyListeners();
  }
}
