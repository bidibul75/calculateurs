import 'package:decimal/decimal.dart';
import 'package:rational/rational.dart';

import '../../../../utils/extensions/string_extensions.dart';
import '../models/speed_state.dart';

/// Container for the five speed values resulting from a conversion.
class SpeedValues {
  final String kilometerPerHour;
  final String meterPerSecond;
  final String milePerHour;
  final String knot;
  final String footPerSecond;

  const SpeedValues({
    required this.kilometerPerHour,
    required this.meterPerSecond,
    required this.milePerHour,
    required this.knot,
    required this.footPerSecond,
  });
}

/// Business logic for speed unit conversions.
///
/// All conversions go through a pivot (metres per second). Exact conversion
/// factors are stored as [Rational] literals.
class SpeedLogic {
  /// m/s per km/h (exactly 1000/3600 = 5/18).
    static final Rational _msPerKmh = Rational.parse('5') / Rational.parse('18');

    /// m/s per international mph (exactly 1609.344/3600).
    static final Rational _msPerMph =
        Rational.parse('1609.344') / Rational.parse('3600');

    /// m/s per international knot (exactly 1852/3600).
    static final Rational _msPerKn =
        Rational.parse('1852') / Rational.parse('3600');

    /// m/s per ft/s (exactly 0.3048).
    static final Rational _msPerFts = Rational.parse('0.3048');

  /// Converts [input] (a string in the given [scale]) to all five speed units.
  static SpeedValues convert(String input, SpeedScale scale) {
    final cleaned = input.toCleanMathString;
    final rationalVal = Rational.parse(cleaned);

    final msIn = switch (scale) {
      SpeedScale.meterPerSecond => rationalVal,
      SpeedScale.kilometerPerHour => rationalVal * _msPerKmh,
      SpeedScale.milePerHour => rationalVal * _msPerMph,
      SpeedScale.knot => rationalVal * _msPerKn,
      SpeedScale.footPerSecond => rationalVal * _msPerFts,
    };

    final kmh = msIn / _msPerKmh;
    final mph = msIn / _msPerMph;
    final kn = msIn / _msPerKn;
    final fts = msIn / _msPerFts;

    final decKmh = kmh.toDecimal(scaleOnInfinitePrecision: 10);
    final decMs = msIn.toDecimal(scaleOnInfinitePrecision: 10);
    final decMph = mph.toDecimal(scaleOnInfinitePrecision: 10);
    final decKn = kn.toDecimal(scaleOnInfinitePrecision: 10);
    final decFts = fts.toDecimal(scaleOnInfinitePrecision: 10);

    final displayKmh = decKmh.toString().formatRound(limit: 6);
    final displayMs = decMs.toString().formatRound(limit: 6);
    final displayMph = decMph.toString().formatRound(limit: 6);
    final displayKn = decKn.toString().formatRound(limit: 6);
    final displayFts = decFts.toString().formatRound(limit: 6);

    return switch (scale) {
      SpeedScale.kilometerPerHour => SpeedValues(
          kilometerPerHour: input,
          meterPerSecond: displayMs,
          milePerHour: displayMph,
          knot: displayKn,
          footPerSecond: displayFts,
        ),
      SpeedScale.meterPerSecond => SpeedValues(
          kilometerPerHour: displayKmh,
          meterPerSecond: input,
          milePerHour: displayMph,
          knot: displayKn,
          footPerSecond: displayFts,
        ),
      SpeedScale.milePerHour => SpeedValues(
          kilometerPerHour: displayKmh,
          meterPerSecond: displayMs,
          milePerHour: input,
          knot: displayKn,
          footPerSecond: displayFts,
        ),
      SpeedScale.knot => SpeedValues(
          kilometerPerHour: displayKmh,
          meterPerSecond: displayMs,
          milePerHour: displayMph,
          knot: input,
          footPerSecond: displayFts,
        ),
      SpeedScale.footPerSecond => SpeedValues(
          kilometerPerHour: displayKmh,
          meterPerSecond: displayMs,
          milePerHour: displayMph,
          knot: displayKn,
          footPerSecond: input,
        ),
    };
  }

  static SpeedValues zeroValues(SpeedScale scale) {
    return convert('0', scale);
  }
}
