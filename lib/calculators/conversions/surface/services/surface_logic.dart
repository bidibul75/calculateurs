import 'package:decimal/decimal.dart';
import 'package:rational/rational.dart';

import '../../../../utils/extensions/string_extensions.dart';
import '../models/surface_state.dart';

/// Container for the five surface values resulting from a conversion.
class SurfaceValues {
  final String squareMeter;
  final String squareCentimeter;
  final String hectare;
  final String acre;
  final String squareFoot;

  const SurfaceValues({
    required this.squareMeter,
    required this.squareCentimeter,
    required this.hectare,
    required this.acre,
    required this.squareFoot,
  });
}

/// Business logic for surface unit conversions.
///
/// All conversions go through a pivot (square metres). Exact conversion factors
/// are stored as [Rational] literals.
class SurfaceLogic {
  /// Square metres per square centimetre.
  static final Rational _m2PerCm2 = Rational.parse('0.0001');

  /// Square metres per hectare (exactly 10 000 m²).
  static final Rational _m2PerHa = Rational.parse('10000');

  /// Square metres per international acre (exactly 4046.8564224 m²).
  static final Rational _m2PerAcre = Rational.parse('4046.8564224');

  /// Square metres per square foot (exactly 0.09290304 m² = 0.3048²).
  static final Rational _m2PerFt2 = Rational.parse('0.09290304');

  /// Converts [input] (a string in the given [scale]) to all five surface units.
  static SurfaceValues convert(String input, SurfaceScale scale) {
    final cleaned = input.toCleanMathString;
    final rationalVal = Rational.parse(cleaned);

    final m2In = switch (scale) {
      SurfaceScale.squareMeter => rationalVal,
      SurfaceScale.squareCentimeter => rationalVal * _m2PerCm2,
      SurfaceScale.hectare => rationalVal * _m2PerHa,
      SurfaceScale.acre => rationalVal * _m2PerAcre,
      SurfaceScale.squareFoot => rationalVal * _m2PerFt2,
    };

    final cm2 = m2In / _m2PerCm2;
    final ha = m2In / _m2PerHa;
    final acres = m2In / _m2PerAcre;
    final ft2 = m2In / _m2PerFt2;

    final decM2 = m2In.toDecimal(scaleOnInfinitePrecision: 10);
    final decCm2 = cm2.toDecimal(scaleOnInfinitePrecision: 10);
    final decHa = ha.toDecimal(scaleOnInfinitePrecision: 10);
    final decAcre = acres.toDecimal(scaleOnInfinitePrecision: 10);
    final decFt2 = ft2.toDecimal(scaleOnInfinitePrecision: 10);

    final displayM2 = decM2.toString().formatRound(limit: 6);
    final displayCm2 = decCm2.toString().formatRound(limit: 6);
    final displayHa = decHa.toString().formatRound(limit: 6);
    final displayAcre = decAcre.toString().formatRound(limit: 6);
    final displayFt2 = decFt2.toString().formatRound(limit: 6);

    return switch (scale) {
      SurfaceScale.squareMeter => SurfaceValues(
          squareMeter: input,
          squareCentimeter: displayCm2,
          hectare: displayHa,
          acre: displayAcre,
          squareFoot: displayFt2,
        ),
      SurfaceScale.squareCentimeter => SurfaceValues(
          squareMeter: displayM2,
          squareCentimeter: input,
          hectare: displayHa,
          acre: displayAcre,
          squareFoot: displayFt2,
        ),
      SurfaceScale.hectare => SurfaceValues(
          squareMeter: displayM2,
          squareCentimeter: displayCm2,
          hectare: input,
          acre: displayAcre,
          squareFoot: displayFt2,
        ),
      SurfaceScale.acre => SurfaceValues(
          squareMeter: displayM2,
          squareCentimeter: displayCm2,
          hectare: displayHa,
          acre: input,
          squareFoot: displayFt2,
        ),
      SurfaceScale.squareFoot => SurfaceValues(
          squareMeter: displayM2,
          squareCentimeter: displayCm2,
          hectare: displayHa,
          acre: displayAcre,
          squareFoot: input,
        ),
    };
  }

  static SurfaceValues zeroValues(SurfaceScale scale) {
    return convert('0', scale);
  }
}
