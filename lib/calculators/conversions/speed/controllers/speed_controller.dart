import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../../../utils/i18n/local_number_symbols.dart';
import '../models/speed_state.dart';
import '../services/speed_logic.dart';
import 'package:calculators/utils/extensions/string_extensions.dart';

/// Controller handling user input and state updates for the speed converter.
class SpeedController extends ChangeNotifier {
  SpeedController() : _state = SpeedState.initial() {
    _decimalSeparator = GetIt.I<LocalNumberSymbols>().decimalSep;
  }

  SpeedState _state;
  late final String _decimalSeparator;

  SpeedState get state => _state;

  void onUnitSelected(SpeedScale unit) {
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
      SpeedScale.kilometerPerHour => SpeedScale.meterPerSecond,
      SpeedScale.meterPerSecond => SpeedScale.milePerHour,
      SpeedScale.milePerHour => SpeedScale.knot,
      SpeedScale.knot => SpeedScale.footPerSecond,
      SpeedScale.footPerSecond => SpeedScale.kilometerPerHour,
    };
    onUnitSelected(nextUnit);
  }

  void _recalculateFromCurrentInput() {
    final values = SpeedLogic.convert(_state.currentInput, _state.activeUnit);
    _state = _state.copyWith(
      kilometerPerHour: values.kilometerPerHour,
      meterPerSecond: values.meterPerSecond,
      milePerHour: values.milePerHour,
      knot: values.knot,
      footPerSecond: values.footPerSecond,
    );
    notifyListeners();
  }
}
