// lib/calculators/conversions/distance/controllers/distance_controller.dart
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../../../utils/i18n/local_number_symbols.dart';
import '../models/distance_state.dart';
import '../services/distance_logic.dart';
import 'package:calculators/utils/extensions/string_extensions.dart';


/// Controller handling user input and state updates for the distance converter.
class DistanceController extends ChangeNotifier {
  DistanceController() : _state = DistanceState.initial() {
    _decimalSeparator = GetIt.I<LocalNumberSymbols>().decimalSep;
  }

  DistanceState _state;
  late final String _decimalSeparator;

  DistanceState get state => _state;

  /// Called when the user selects a different active unit (via tab or cycle button).
  void onUnitSelected(DistanceScale unit) {
    _state = _state.copyWith(activeUnit: unit, currentInput: '0');
    _recalculateFromCurrentInput();
  }

  /// Handles a keypad button press (digit, decimal separator, clear, or backspace).
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

  /// Cycles through the active unit (used e.g. by a dedicated "switch unit" button).
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
    final String nextInput;

    nextInput = current.realTimeL10n(char, _decimalSeparator);

    _state = _state.copyWith(currentInput: nextInput);
    _recalculateFromCurrentInput();
  }

  void _cycleActiveUnit() {
    final nextUnit = switch (_state.activeUnit) {
      DistanceScale.meter => DistanceScale.kilometer,
      DistanceScale.kilometer => DistanceScale.mile,
      DistanceScale.mile => DistanceScale.foot,
      DistanceScale.foot => DistanceScale.inch,
      DistanceScale.inch => DistanceScale.meter,
    };
    onUnitSelected(nextUnit);
  }

  void _recalculateFromCurrentInput() {
    final values = DistanceLogic.convert(_state.currentInput, _state.activeUnit);
    _state = _state.copyWith(
      meter: values.meter,
      kilometer: values.kilometer,
      mile: values.mile,
      foot: values.foot,
      inch: values.inch,
    );
    notifyListeners();
  }
}
