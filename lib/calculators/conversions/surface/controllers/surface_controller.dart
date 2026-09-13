import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../../../utils/i18n/local_number_symbols.dart';
import '../models/surface_state.dart';
import '../services/surface_logic.dart';
import 'package:calculators/utils/extensions/string_extensions.dart';

/// Controller handling user input and state updates for the surface converter.
class SurfaceController extends ChangeNotifier {
  SurfaceController() : _state = SurfaceState.initial() {
    _decimalSeparator = GetIt.I<LocalNumberSymbols>().decimalSep;
  }

  SurfaceState _state;
  late final String _decimalSeparator;

  SurfaceState get state => _state;

  void onUnitSelected(SurfaceScale unit) {
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
      SurfaceScale.squareMeter => SurfaceScale.squareCentimeter,
      SurfaceScale.squareCentimeter => SurfaceScale.hectare,
      SurfaceScale.hectare => SurfaceScale.acre,
      SurfaceScale.acre => SurfaceScale.squareFoot,
      SurfaceScale.squareFoot => SurfaceScale.squareMeter,
    };
    onUnitSelected(nextUnit);
  }

  void _recalculateFromCurrentInput() {
    final values = SurfaceLogic.convert(_state.currentInput, _state.activeUnit);
    _state = _state.copyWith(
      squareMeter: values.squareMeter,
      squareCentimeter: values.squareCentimeter,
      hectare: values.hectare,
      acre: values.acre,
      squareFoot: values.squareFoot,
    );
    notifyListeners();
  }
}
