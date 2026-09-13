// lib/calculators/conversions/volume/services/volume_logic.dart

import 'package:decimal/decimal.dart';
import 'package:rational/rational.dart';

import '../../../../utils/extensions/string_extensions.dart';
import '../models/volume_state.dart';

/// Container for the five volume values resulting from a conversion.
class VolumeValues {
  final String liter;
  final String milliliter;
  final String gallon;
  final String fluidOunce;
  final String cubicMeter;

  const VolumeValues({
    required this.liter,
    required this.milliliter,
    required this.gallon,
    required this.fluidOunce,
    required this.cubicMeter,
  });
}

/// Business logic for volume unit conversions.
///
/// All conversions go through a pivot (litres). Exact conversion factors
/// are stored as [Rational] literals.
class VolumeLogic {
  /// Litres per millilitre.
  static final Rational _lPerMl = Rational.parse('0.001');

  /// Litres per US gallon (exactly 3.785411784 L).
  static final Rational _lPerGal = Rational.parse('3.785411784');

  /// Litres per US fluid ounce (exactly 0.0295735295625 L).
  static final Rational _lPerFlOz = Rational.parse('0.0295735295625');

  /// Litres per cubic metre (exactly 1000 L).
  static final Rational _lPerM3 = Rational.parse('1000');

  /// Converts [input] (a string in the given [scale]) to all five volume units.
  static VolumeValues convert(String input, VolumeScale scale) {
    final cleaned = input.toCleanMathString;
    final rationalVal = Rational.parse(cleaned);

    final litersIn = switch (scale) {
      VolumeScale.liter => rationalVal,
      VolumeScale.milliliter => rationalVal * _lPerMl,
      VolumeScale.gallon => rationalVal * _lPerGal,
      VolumeScale.fluidOunce => rationalVal * _lPerFlOz,
      VolumeScale.cubicMeter => rationalVal * _lPerM3,
    };

    final milliliters = litersIn / _lPerMl;
    final gallons = litersIn / _lPerGal;
    final fluidOunces = litersIn / _lPerFlOz;
    final cubicMeters = litersIn / _lPerM3;

    final decL = litersIn.toDecimal(scaleOnInfinitePrecision: 10);
    final decMl = milliliters.toDecimal(scaleOnInfinitePrecision: 10);
    final decGal = gallons.toDecimal(scaleOnInfinitePrecision: 10);
    final decFlOz = fluidOunces.toDecimal(scaleOnInfinitePrecision: 10);
    final decM3 = cubicMeters.toDecimal(scaleOnInfinitePrecision: 10);

    final displayL = decL.toString().formatRound(limit: 6);
    final displayMl = decMl.toString().formatRound(limit: 6);
    final displayGal = decGal.toString().formatRound(limit: 6);
    final displayFlOz = decFlOz.toString().formatRound(limit: 6);
    final displayM3 = decM3.toString().formatRound(limit: 6);

    return switch (scale) {
      VolumeScale.liter => VolumeValues(
          liter: input,
          milliliter: displayMl,
          gallon: displayGal,
          fluidOunce: displayFlOz,
          cubicMeter: displayM3,
        ),
      VolumeScale.milliliter => VolumeValues(
          liter: displayL,
          milliliter: input,
          gallon: displayGal,
          fluidOunce: displayFlOz,
          cubicMeter: displayM3,
        ),
      VolumeScale.gallon => VolumeValues(
          liter: displayL,
          milliliter: displayMl,
          gallon: input,
          fluidOunce: displayFlOz,
          cubicMeter: displayM3,
        ),
      VolumeScale.fluidOunce => VolumeValues(
          liter: displayL,
          milliliter: displayMl,
          gallon: displayGal,
          fluidOunce: input,
          cubicMeter: displayM3,
        ),
      VolumeScale.cubicMeter => VolumeValues(
          liter: displayL,
          milliliter: displayMl,
          gallon: displayGal,
          fluidOunce: displayFlOz,
          cubicMeter: input,
        ),
    };
  }

  static VolumeValues zeroValues(VolumeScale scale) {
    return convert('0', scale);
  }
}
