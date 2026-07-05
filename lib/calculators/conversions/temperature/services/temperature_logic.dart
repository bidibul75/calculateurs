// lib/calculators/conversions/temperature/services/temperature_logic.dart
import 'package:calculators/utils/extensions/string_extensions.dart';

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

  static TemperatureValues convert(String input, TemperatureScale scale) {
    final normalizedInput = input.toCleanMathString;
    final value = double.tryParse(normalizedInput) ?? 0.0;

    switch (scale) {
      case TemperatureScale.celsius:
        return TemperatureValues(
          celsius: input.format,
          fahrenheit: ((value * 9 / 5) + 32).toString().formatRound(limit: 2),
          kelvin: (value + 273.15).toString().formatRound(limit: 2),
          rankine: ((value + 273.15) * 9 / 5).toString().formatRound(limit: 2),
        );
      case TemperatureScale.fahrenheit:
        final celsius = (value - 32) * 5 / 9;
        return TemperatureValues(
          celsius: (celsius).toString().formatRound(limit: 2),
          fahrenheit: input.format,
          kelvin: (celsius + 273.15).toString().formatRound(limit: 2),
          rankine: (value + 459.67).toString().formatRound(limit: 2),
        );
      case TemperatureScale.kelvin:
        final celsius = value - 273.15;
        return TemperatureValues(
          celsius: (celsius).toString().formatRound(limit: 2),
          fahrenheit: ((celsius * 9 / 5) + 32).toString().formatRound(limit: 2),
          kelvin: input.format,
          rankine: (value * 9 / 5).toString().formatRound(limit: 2),
        );
      case TemperatureScale.rankine:
        final celsius = (value - 491.67) * 5 / 9;
        return TemperatureValues(
          celsius: celsius.toString().formatRound(limit: 2),
          fahrenheit: (value - 459.67).toString().formatRound(limit: 2),
          kelvin: (value * 5 / 9).toString().formatRound(limit: 2),
          rankine: input.format,
        );
    }
  }

  static TemperatureValues zeroValues(TemperatureScale scale) {
    return convert('0', scale);
  }
}
