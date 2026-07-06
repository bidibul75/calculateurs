// lib/calculators/conversions/temperature/services/temperature_logic.dart
import 'package:calculators/utils/extensions/string_extensions.dart';
import 'package:decimal/decimal.dart';
import 'package:rational/rational.dart';

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
  static final Rational _kRational9 = Rational.fromInt(9);
  static final Rational _kRational5 = Rational.fromInt(5);
  static final Rational _kRational32 = Rational.fromInt(32);
  static final Rational _kRational27315 = Rational.parse('273.15');
  static final Rational _kRational45967 = Rational.parse('459.67');
  static final Rational _kRational49167 = Rational.parse('491.67');

  /// Converts a Rational into a formatted String rounded to 2 digits
  static String displayable (Rational disp) {
    return disp.toDecimal(scaleOnInfinitePrecision: 10).toString().formatRound(limit: 2);
  }

  static TemperatureValues convert(String input, TemperatureScale scale) {
    final normalizedInput = input.toCleanMathString;
    final Rational value = Rational.tryParse(normalizedInput) ?? Rational.zero;
    //final value = double.tryParse(normalizedInput) ?? 0.0;

    switch (scale) {
      case TemperatureScale.celsius:
        return TemperatureValues(
          celsius: input.format,
          fahrenheit: displayable((value * _kRational9 / _kRational5) + _kRational32),
          kelvin: displayable(value + _kRational27315),
          rankine: displayable((value + _kRational27315) * _kRational9 / _kRational5),
        );
      case TemperatureScale.fahrenheit:
        final celsius = (value - _kRational32) * _kRational5 / _kRational9;
        return TemperatureValues(
          celsius: displayable(celsius),
          fahrenheit: input.format,
          kelvin: displayable(celsius + _kRational27315),
          rankine: displayable(value + _kRational45967),
        );
      case TemperatureScale.kelvin:
        final celsius = value - _kRational27315;
        return TemperatureValues(
          celsius: displayable(celsius),
          fahrenheit: displayable((celsius * _kRational9 / _kRational5) + _kRational32),
          kelvin: input.format,
          rankine: displayable(value * _kRational9 / _kRational5),
        );
      case TemperatureScale.rankine:
        final celsius = (value - _kRational49167) * _kRational5 / _kRational9;
        return TemperatureValues(
          celsius: displayable(celsius),
          fahrenheit: displayable(value - _kRational45967),
          kelvin: displayable(value * _kRational5 / _kRational9),
          rankine: input.format,
        );
    }
  }

  static TemperatureValues zeroValues(TemperatureScale scale) {
    return convert('0', scale);
  }
}
