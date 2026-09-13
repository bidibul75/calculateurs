// lib/calculators/conversions/weight/services/weight_logic.dart

import 'package:decimal/decimal.dart';
import 'package:rational/rational.dart';

import '../../../../utils/extensions/string_extensions.dart';
import '../models/weight_state.dart';

/// Container for the five weight values resulting from a conversion.
class WeightValues {
  final String kilogram;
  final String gram;
  final String pound;
  final String ounce;
  final String stone;

  const WeightValues({
    required this.kilogram,
    required this.gram,
    required this.pound,
    required this.ounce,
    required this.stone,
  });
}

/// Business logic for weight / mass unit conversions.
///
/// All conversions go through a pivot (kilograms). Exact conversion factors
/// are stored as [Rational] literals.
class WeightLogic {
  /// Kilograms per gram.
  static final Rational _kgPerG = Rational.parse('0.001');

  /// Kilograms per pound (avoirdupois, exactly 0.45359237 kg).
  static final Rational _kgPerLb = Rational.parse('0.45359237');

  /// Kilograms per ounce (avoirdupois, exactly 0.028349523125 kg).
  static final Rational _kgPerOz = Rational.parse('0.028349523125');

  /// Kilograms per stone (exactly 14 pounds = 6.35029318 kg).
  static final Rational _kgPerSt = Rational.parse('6.35029318');

  /// Converts [input] (a string in the given [scale]) to all five weight units.
  static WeightValues convert(String input, WeightScale scale) {
    final cleaned = input.toCleanMathString;
    final rationalVal = Rational.parse(cleaned);

    final kilogramsIn = switch (scale) {
      WeightScale.kilogram => rationalVal,
      WeightScale.gram => rationalVal * _kgPerG,
      WeightScale.pound => rationalVal * _kgPerLb,
      WeightScale.ounce => rationalVal * _kgPerOz,
      WeightScale.stone => rationalVal * _kgPerSt,
    };

    final grams = kilogramsIn / _kgPerG;
    final pounds = kilogramsIn / _kgPerLb;
    final ounces = kilogramsIn / _kgPerOz;
    final stones = kilogramsIn / _kgPerSt;

    final decKg = kilogramsIn.toDecimal(scaleOnInfinitePrecision: 10);
    final decG = grams.toDecimal(scaleOnInfinitePrecision: 10);
    final decLb = pounds.toDecimal(scaleOnInfinitePrecision: 10);
    final decOz = ounces.toDecimal(scaleOnInfinitePrecision: 10);
    final decSt = stones.toDecimal(scaleOnInfinitePrecision: 10);

    final displayKg = decKg.toString().formatRound(limit: 6);
    final displayG = decG.toString().formatRound(limit: 6);
    final displayLb = decLb.toString().formatRound(limit: 6);
    final displayOz = decOz.toString().formatRound(limit: 6);
    final displaySt = decSt.toString().formatRound(limit: 6);

    return switch (scale) {
      WeightScale.kilogram => WeightValues(
          kilogram: input,
          gram: displayG,
          pound: displayLb,
          ounce: displayOz,
          stone: displaySt,
        ),
      WeightScale.gram => WeightValues(
          kilogram: displayKg,
          gram: input,
          pound: displayLb,
          ounce: displayOz,
          stone: displaySt,
        ),
      WeightScale.pound => WeightValues(
          kilogram: displayKg,
          gram: displayG,
          pound: input,
          ounce: displayOz,
          stone: displaySt,
        ),
      WeightScale.ounce => WeightValues(
          kilogram: displayKg,
          gram: displayG,
          pound: displayLb,
          ounce: input,
          stone: displaySt,
        ),
      WeightScale.stone => WeightValues(
          kilogram: displayKg,
          gram: displayG,
          pound: displayLb,
          ounce: displayOz,
          stone: input,
        ),
    };
  }

  static WeightValues zeroValues(WeightScale scale) {
    return convert('0', scale);
  }
}
