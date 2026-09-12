// lib/calculators/math/average/average_controller.dart
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:rational/rational.dart';

class AverageController extends ChangeNotifier {
  final List<Rational> _values = <Rational>[];
  String _rawInput = '';

  List<Rational> get values => List<Rational>.unmodifiable(_values);
  String get rawInput => _rawInput;
  int get count => _values.length;
  bool get hasInput => _rawInput.isNotEmpty;
  bool get canAdd => _tryParseInput() != null;
  bool get canUndo => _values.isNotEmpty;

  Rational? get average {
    if (_values.isEmpty) return null;
    final Rational sum = _values.fold<Rational>(
      Rational.zero,
      (Rational acc, Rational value) => acc + value,
    );
    return sum / Rational.fromInt(_values.length);
  }

  Rational? get sum {
    if (_values.isEmpty) return null;
    return _values.fold<Rational>(
      Rational.zero,
      (Rational acc, Rational value) => acc + value,
    );
  }

  void appendDigit(String digit) {
    if (digit == '0' && (_rawInput.isEmpty || _rawInput == '-0')) {
      _rawInput = _rawInput.startsWith('-') ? '-0' : '0';
      notifyListeners();
      return;
    }
    if (_rawInput == '0') {
      _rawInput = digit;
    } else if (_rawInput == '-0') {
      _rawInput = '-$digit';
    } else if (_rawInput == '-') {
      _rawInput = '-$digit';
    } else {
      if (_integerDigitCount >= 12) return;
      _rawInput += digit;
    }
    notifyListeners();
  }

  void appendDecimalSeparator() {
    if (_rawInput.contains('.')) return;
    if (_rawInput.isEmpty || _rawInput == '-') {
      _rawInput = '0.';
    } else {
      _rawInput += '.';
    }
    notifyListeners();
  }

  void toggleSign() {
    if (_rawInput.isEmpty || _rawInput == '0' || _rawInput == '0.') {
      _rawInput = '-';
    } else if (_rawInput == '-') {
      _rawInput = '';
    } else if (_rawInput.startsWith('-')) {
      _rawInput = _rawInput.substring(1);
    } else {
      _rawInput = '-$_rawInput';
    }
    notifyListeners();
  }

  void backspace() {
    if (_rawInput.isEmpty) return;
    _rawInput = _rawInput.substring(0, _rawInput.length - 1);
    notifyListeners();
  }

  void clearInput() {
    _rawInput = '';
    notifyListeners();
  }

  bool addCurrentValue() {
    final value = _tryParseInput();
    if (value == null) return false;
    _values.add(value);
    _rawInput = '';
    notifyListeners();
    return true;
  }

  void removeAt(int index) {
    if (index < 0 || index >= _values.length) return;
    _values.removeAt(index);
    notifyListeners();
  }

  void undoLast() {
    if (_values.isEmpty) return;
    _values.removeLast();
    notifyListeners();
  }

  void clearAll() {
    _values.clear();
    _rawInput = '';
    notifyListeners();
  }

  int get _integerDigitCount {
    final unsigned = _rawInput.replaceFirst('-', '');
    final integerPart = unsigned.split('.').first;
    return integerPart.replaceAll('0', '').isEmpty && unsigned.startsWith('0')
        ? integerPart.length
        : integerPart.length;
  }

  Rational? _tryParseInput() {
    if (_rawInput.isEmpty || _rawInput == '-' || _rawInput == '.' || _rawInput == '-.') {
      return null;
    }
    final normalized = _rawInput.endsWith('.') ? ' ${_rawInput}0' : _rawInput;
    final decimal = Decimal.tryParse(normalized);
    if (decimal == null) return null;
    return decimal.toRational();
  }
}