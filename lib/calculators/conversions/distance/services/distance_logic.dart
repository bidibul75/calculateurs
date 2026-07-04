// lib/calculators/conversions/distance/services/distance_logic.dart

import 'package:decimal/decimal.dart';
import 'package:get_it/get_it.dart';
import 'package:rational/rational.dart';

import '../models/distance_state.dart';
import 'package:calculators/utils/i18n/local_number_symbols.dart';

class DistanceLogic {
  // Facteurs de conversion vers le mètre (en Decimal pour la précision)
  static final Map<DistanceUnit, Decimal> _toMeters = {
    DistanceUnit.km: Decimal.fromInt(1000),
    DistanceUnit.m: Decimal.one,
    DistanceUnit.cm: Decimal.parse('0.01'),
    DistanceUnit.mm: Decimal.parse('0.001'),
    DistanceUnit.mi: Decimal.parse('1609.344'),
    DistanceUnit.yd: Decimal.parse('0.9144'),
    DistanceUnit.ft: Decimal.parse('0.3048'),
    DistanceUnit.inch: Decimal.parse('0.0254'),
    DistanceUnit.nmi: Decimal.parse('1852'),
  };

  /// Convertit une valeur d'une unité vers les trois champs
  static DistanceState convert({
    required String input,
    required DistanceUnit fromUnit,
    required DistanceUnit targetMetric,
    required DistanceUnit targetImperial,
  }) {
    if (input.isEmpty) {
      return DistanceState(
        metricValue: '',
        metricUnit: targetMetric,
        imperialValue: '',
        imperialUnit: targetImperial,
        nauticalValue: '',
      );
    }

    final symbols = GetIt.I<LocalNumberSymbols>();
    final normalizedInput = input.replaceAll(symbols.decimalSep, '.');

    final Rational inputVal = Rational.parse(normalizedInput);
    final Decimal fromFactor = _toMeters[fromUnit]!;

    final Rational meters = inputVal * Rational.parse(fromFactor.toString());

    final Rational metricVal = meters / Rational.parse(_toMeters[targetMetric]!.toString());
    final Rational imperialVal = meters / Rational.parse(_toMeters[targetImperial]!.toString());
    final Rational nauticalVal = meters / Rational.parse(_toMeters[DistanceUnit.nmi]!.toString());

    return DistanceState(
      metricValue: _format(metricVal.toDecimal(), symbols.decimalSep),
      metricUnit: targetMetric,
      imperialValue: _format(imperialVal.toDecimal(), symbols.decimalSep),
      imperialUnit: targetImperial,
      nauticalValue: _format(nauticalVal.toDecimal(), symbols.decimalSep),
    );
  }

  static String _format(Decimal value, String decimalSep) {
    final str = value.toString();
    return decimalSep == '.' ? str : str.replaceAll('.', decimalSep);
  }
}
