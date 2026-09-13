import 'package:decimal/decimal.dart';
import 'package:rational/rational.dart';

import '../../../../utils/extensions/string_extensions.dart';
import '../models/percentage_state.dart';

/// Snapshot of the four linked percentage values.
class PercentageValues {
  final String primary;
  final String rate;
  final String delta;
  final String result;

  const PercentageValues({
    required this.primary,
    required this.rate,
    required this.delta,
    required this.result,
  });
}

/// Business logic for tax (HT/TTC), discount, increase and tip calculations.
///
/// Additive modes (tax, increase, tip):
///   result = primary × (1 + rate/100)
///   delta  = result − primary
///
/// Discount mode:
///   result = primary × (1 − rate/100)
///   delta  = primary − result
class PercentageLogic {
  static final Rational _hundred = Rational.fromInt(100);
  static final Rational _zero = Rational.zero;

  static PercentageValues convert({
    required String input,
    required PercentageField activeField,
    required PercentageMode mode,
    required String primary,
    required String rate,
    required String delta,
    required String result,
  }) {
    final edited = _parse(input);
    if (edited == null) {
      return PercentageValues(
        primary: primary,
        rate: rate,
        delta: delta,
        result: result,
      );
    }

    final currentPrimary = activeField == PercentageField.primary ? edited : _parse(primary);
    final currentRate = activeField == PercentageField.rate ? edited : _parse(rate);
    final currentDelta = activeField == PercentageField.delta ? edited : _parse(delta);
    final currentResult = activeField == PercentageField.result ? edited : _parse(result);

    final isDiscount = mode == PercentageMode.discount;

    Rational? nextPrimary = currentPrimary;
    Rational? nextRate = currentRate;
    Rational? nextDelta = currentDelta;
    Rational? nextResult = currentResult;

    switch (activeField) {
      case PercentageField.primary:
        nextPrimary = edited;
        if (nextRate != null) {
          final pair = _fromPrimaryAndRate(nextPrimary, nextRate, isDiscount: isDiscount);
          nextDelta = pair.$1;
          nextResult = pair.$2;
        } else if (nextDelta != null) {
          final pair = _fromPrimaryAndDelta(nextPrimary, nextDelta, isDiscount: isDiscount);
          nextRate = pair.$1;
          nextResult = pair.$2;
        } else if (nextResult != null) {
          final pair = _fromPrimaryAndResult(nextPrimary, nextResult, isDiscount: isDiscount);
          nextDelta = pair.$1;
          nextRate = pair.$2;
        }
      case PercentageField.rate:
        nextRate = edited;
        if (nextPrimary != null) {
          final pair = _fromPrimaryAndRate(nextPrimary, nextRate, isDiscount: isDiscount);
          nextDelta = pair.$1;
          nextResult = pair.$2;
        } else if (nextResult != null) {
          final pair = _fromResultAndRate(nextResult, nextRate, isDiscount: isDiscount);
          nextPrimary = pair.$1;
          nextDelta = pair.$2;
        } else if (nextDelta != null) {
          // rate + delta alone cannot uniquely recover primary without more data.
        }
      case PercentageField.delta:
        nextDelta = edited;
        if (nextPrimary != null) {
          final pair = _fromPrimaryAndDelta(nextPrimary, nextDelta, isDiscount: isDiscount);
          nextRate = pair.$1;
          nextResult = pair.$2;
        } else if (nextResult != null) {
          final pair = _fromResultAndDelta(nextResult, nextDelta, isDiscount: isDiscount);
          nextPrimary = pair.$1;
          nextRate = pair.$2;
        } else if (nextRate != null) {
          final pair = _fromDeltaAndRate(nextDelta, nextRate, isDiscount: isDiscount);
          nextPrimary = pair.$1;
          nextResult = pair.$2;
        }
      case PercentageField.result:
        nextResult = edited;
        if (nextRate != null) {
          final pair = _fromResultAndRate(nextResult, nextRate, isDiscount: isDiscount);
          nextPrimary = pair.$1;
          nextDelta = pair.$2;
        } else if (nextPrimary != null) {
          final pair = _fromPrimaryAndResult(nextPrimary, nextResult, isDiscount: isDiscount);
          nextDelta = pair.$1;
          nextRate = pair.$2;
        } else if (nextDelta != null) {
          final pair = _fromResultAndDelta(nextResult, nextDelta, isDiscount: isDiscount);
          nextPrimary = pair.$1;
          nextRate = pair.$2;
        }
    }

    return PercentageValues(
      primary: activeField == PercentageField.primary ? input : _format(nextPrimary ?? _zero),
      rate: activeField == PercentageField.rate ? input : _format(nextRate ?? _zero),
      delta: activeField == PercentageField.delta ? input : _format(nextDelta ?? _zero),
      result: activeField == PercentageField.result ? input : _format(nextResult ?? _zero),
    );
  }

  static (Rational delta, Rational result) _fromPrimaryAndRate(
    Rational primary,
    Rational rate, {
    required bool isDiscount,
  }) {
    final factor = isDiscount
        ? (Rational.one - (rate / _hundred))
        : (Rational.one + (rate / _hundred));
    final result = primary * factor;
    final delta = isDiscount ? (primary - result) : (result - primary);
    return (delta, result);
  }

  static (Rational rate, Rational result) _fromPrimaryAndDelta(
    Rational primary,
    Rational delta, {
    required bool isDiscount,
  }) {
    final result = isDiscount ? (primary - delta) : (primary + delta);
    final rate = primary == _zero ? _zero : ((delta / primary) * _hundred);
    return (rate, result);
  }

  static (Rational delta, Rational rate) _fromPrimaryAndResult(
    Rational primary,
    Rational result, {
    required bool isDiscount,
  }) {
    final delta = isDiscount ? (primary - result) : (result - primary);
    final rate = primary == _zero ? _zero : ((delta / primary) * _hundred);
    return (delta, rate);
  }

  static (Rational primary, Rational delta) _fromResultAndRate(
    Rational result,
    Rational rate, {
    required bool isDiscount,
  }) {
    final factor = isDiscount
        ? (Rational.one - (rate / _hundred))
        : (Rational.one + (rate / _hundred));
    if (factor == _zero) {
      return (_zero, result);
    }
    final primary = result / factor;
    final delta = isDiscount ? (primary - result) : (result - primary);
    return (primary, delta);
  }

  static (Rational primary, Rational rate) _fromResultAndDelta(
    Rational result,
    Rational delta, {
    required bool isDiscount,
  }) {
    final primary = isDiscount ? (result + delta) : (result - delta);
    final rate = primary == _zero ? _zero : ((delta / primary) * _hundred);
    return (primary, rate);
  }

  static (Rational primary, Rational result) _fromDeltaAndRate(
    Rational delta,
    Rational rate, {
    required bool isDiscount,
  }) {
    if (rate == _zero) {
      return (_zero, isDiscount ? -delta : delta);
    }
    final primary = (delta / rate) * _hundred;
    final result = isDiscount ? (primary - delta) : (primary + delta);
    return (primary, result);
  }

  static Rational? _parse(String value) {
    final cleaned = value.toCleanMathString.trim();
    if (cleaned.isEmpty || cleaned == '-' || cleaned == '.' || cleaned == '-.') {
      return null;
    }
    try {
      return Rational.parse(cleaned);
    } catch (_) {
      return null;
    }
  }

  static String _format(Rational value) {
    final dec = value.toDecimal(scaleOnInfinitePrecision: 12);
    return dec.toString().formatRound(limit: 6);
  }
}
