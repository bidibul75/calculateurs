import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:get_it/get_it.dart';

import '../models/temperature_state.dart';

class TemperatureValues {
  final String celsius;
  final String fahrenheit;
  final String kelvin;
  final String rankine;

  const TemperatureValues({
    required this.celsius,
    required this.fahrenheit,
    required this.kelvin,
    required this.rankine,
  });
}

class TemperatureLogic {
  static String _normalizeInput(String value, String decimalSep) {
    return value.replaceAll(decimalSep, '.').trim();
  }

  static String _format(double value, String decimalSep) {
    return value.toStringAsFixed(2).replaceAll('.', decimalSep);
  }

  static TemperatureValues convert(String input, TemperatureScale scale) {
    final symbols = GetIt.I<LocalNumberSymbols>();
    final normalizedInput = _normalizeInput(input, symbols.decimalSep);
    final value = double.tryParse(normalizedInput) ?? 0.0;

    switch (scale) {
      case TemperatureScale.celsius:
        return TemperatureValues(
          celsius: input,
          fahrenheit: _format((value * 9 / 5) + 32, symbols.decimalSep),
          kelvin: _format(value + 273.15, symbols.decimalSep),
          rankine: _format((value + 273.15) * 9 / 5, symbols.decimalSep),
        );
      case TemperatureScale.fahrenheit:
        final celsius = (value - 32) * 5 / 9;
        return TemperatureValues(
          celsius: _format(celsius, symbols.decimalSep),
          fahrenheit: input,
          kelvin: _format(celsius + 273.15, symbols.decimalSep),
          rankine: _format(value + 459.67, symbols.decimalSep),
        );
      case TemperatureScale.kelvin:
        final celsius = value - 273.15;
        return TemperatureValues(
          celsius: _format(celsius, symbols.decimalSep),
          fahrenheit: _format((celsius * 9 / 5) + 32, symbols.decimalSep),
          kelvin: input,
          rankine: _format(value * 9 / 5, symbols.decimalSep),
        );
      case TemperatureScale.rankine:
        final celsius = (value - 491.67) * 5 / 9;
        return TemperatureValues(
          celsius: _format(celsius, symbols.decimalSep),
          fahrenheit: _format(value - 459.67, symbols.decimalSep),
          kelvin: _format(value * 5 / 9, symbols.decimalSep),
          rankine: input,
        );
    }
  }

  static TemperatureValues zeroValues(TemperatureScale scale) {
    return convert('0', scale);
  }
}
