// lib/calculators/conversions/distance/services/distance_logic.dart

import 'package:decimal/decimal.dart';
import 'package:rational/rational.dart';

import '../../../../utils/extensions/string_extensions.dart';
import '../models/distance_state.dart';

/// Container for the five distance values resulting from a conversion.
class DistanceValues {
  final String meter;
  final String kilometer;
  final String mile;
  final String foot;
  final String inch;

  const DistanceValues({
    required this.meter,
    required this.kilometer,
    required this.mile,
    required this.foot,
    required this.inch,
  });
}

/// Business logic for distance / length unit conversions.
///
/// All conversions go through a pivot (metres) so that every unit pair is
/// computed through a single well-defined chain.  Exact conversion factors
/// are stored as [Rational] literals; [Decimal] is used for intermediate
/// arithmetic, and [StringExtensions.formatRound] produces the locale-aware
/// display string with the `≈` prefix automatically added when rounding
/// truncates the value.
class DistanceLogic {
  // -------------------------------------------------------------------------
  // Exact conversion factors (pivot = metres)
  // -------------------------------------------------------------------------

  /// Metres per kilometre.
  static Rational _M_PER_KM = Rational(BigInt.from(1000));

  /// Metres per mile (international survey foot, exactly 1609.344 m).
  static Rational _M_PER_MILE = Rational.parse('1609.344');

  /// Metres per foot (exactly 0.3048 m).
  static Rational _M_PER_FOOT = Rational.parse('0.3048');

  /// Metres per inch (exactly 0.0254 m = 2.54 cm).
  static final Rational _M_PER_INCH = Rational.parse('0.0254');

  /// Converts [input] (a string in the given [scale]) to all five distance
  /// units.  The field matching [scale] is returned as-is (the raw user input);
  /// the other four fields are computed from it via the metre pivot.
  ///
  /// Uses [Rational] for exact factor multiplication, then [Decimal] for the
  /// display conversion and [formatRound(limit:)] for the formatted string.
  static DistanceValues convert(String input, DistanceScale scale) {
    // Normalise the raw input (handles localised thousand / decimal separators)
    // into a plain dot-separated string suitable for Rational.parse().
    final cleaned = input.toCleanMathString;

    // Parse as Rational for exact arithmetic.
    final rationalVal = Rational.parse(cleaned);

    // ---- Pivot: convert the source value to metres ----
    final metersIn = switch (scale) {
      DistanceScale.meter => rationalVal,
      DistanceScale.kilometer => rationalVal * _M_PER_KM,
      DistanceScale.mile => rationalVal * _M_PER_MILE,
      DistanceScale.foot => rationalVal * _M_PER_FOOT,
      DistanceScale.inch => rationalVal * _M_PER_INCH,
    };

    // ---- Compute the four non-active units from the metre pivot ----
    final km = metersIn / _M_PER_KM;
    final miles = metersIn / _M_PER_MILE;
    final feet = metersIn / _M_PER_FOOT;
    final inches = metersIn / _M_PER_INCH;

    // Convert to Decimal for display; Rational.toDecimal() with 10-digit
    // scale preserves sub-millimetre precision for all common use cases.
    final decKm = km.toDecimal(scaleOnInfinitePrecision: 10);
    final decMiles = miles.toDecimal(scaleOnInfinitePrecision: 10);
    final decFeet = feet.toDecimal(scaleOnInfinitePrecision: 10);
    final decInches = inches.toDecimal(scaleOnInfinitePrecision: 10);
    final decMeters = metersIn.toDecimal(scaleOnInfinitePrecision: 10);

    // 6 significant decimal places — enough for sub-millimetre resolution on
    // any unit while keeping the display compact; the `≈` prefix is added
    // automatically by formatRound when the fractional part is truncated.
    final displayKm = decKm.toString().formatRound(limit: 6);
    final displayMiles = decMiles.toString().formatRound(limit: 6);
    final displayFeet = decFeet.toString().formatRound(limit: 6);
    final displayInches = decInches.toString().formatRound(limit: 6);
    final displayMeters = decMeters.toString().formatRound(limit: 6);

    return switch (scale) {
      DistanceScale.meter => DistanceValues(
          meter: input,
          kilometer: displayKm,
          mile: displayMiles,
          foot: displayFeet,
          inch: displayInches,
        ),
      DistanceScale.kilometer => DistanceValues(
          meter: displayMeters,
          kilometer: input,
          mile: displayMiles,
          foot: displayFeet,
          inch: displayInches,
        ),
      DistanceScale.mile => DistanceValues(
          meter: displayMeters,
          kilometer: displayKm,
          mile: input,
          foot: displayFeet,
          inch: displayInches,
        ),
      DistanceScale.foot => DistanceValues(
          meter: displayMeters,
          kilometer: displayKm,
          mile: displayMiles,
          foot: input,
          inch: displayInches,
        ),
      DistanceScale.inch => DistanceValues(
          meter: displayMeters,
          kilometer: displayKm,
          mile: displayMiles,
          foot: displayFeet,
          inch: input,
        ),
    };
  }

  /// Returns the five distance values for a "zero" input in the given [scale].
  /// Useful for initialising the UI before the user has typed anything.
  static DistanceValues zeroValues(DistanceScale scale) {
    return convert('0', scale);
  }
}
