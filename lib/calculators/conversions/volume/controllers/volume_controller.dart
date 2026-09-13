// lib/calculators/conversions/volume/controllers/volume_controller.dart
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../../../utils/i18n/local_number_symbols.dart';
import '../models/volume_state.dart';
import '../services/volume_logic.dart';
import 'package:calculators/utils/extensions/string_extensions.dart';

/// Controller handling user input and state updates for the volume converter.
class VolumeController extends ChangeNotifier {
  VolumeController() : _state = VolumeState.initial() {
    _decimalSeparator = GetIt.I<LocalNumberSymbols>().decimalSep;
  }

  VolumeState _state;
  late final String _decimalSeparator;

  VolumeState get state => _state;

  void onUnitSelected(VolumeScale unit) {
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
      VolumeScale.liter => VolumeScale.milliliter,
      VolumeScale.milliliter => VolumeScale.gallon,
      VolumeScale.gallon => VolumeScale.fluidOunce,
      VolumeScale.fluidOunce => VolumeScale.cubicMeter,
      VolumeScale.cubicMeter => VolumeScale.liter,
    };
    onUnitSelected(nextUnit);
  }

  void _recalculateFromCurrentInput() {
    final values = VolumeLogic.convert(_state.currentInput, _state.activeUnit);
    _state = _state.copyWith(
      liter: values.liter,
      milliliter: values.milliliter,
      gallon: values.gallon,
      fluidOunce: values.fluidOunce,
      cubicMeter: values.cubicMeter,
    );
    notifyListeners();
  }
}
