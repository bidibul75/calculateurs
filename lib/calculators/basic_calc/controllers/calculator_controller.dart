// lib/calculators/basic_calc/controllers/calculator_controller.dart

import 'dart:async';
import 'dart:convert';

import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:calculators/utils/extensions/extensions.dart';
import 'package:get_it/get_it.dart';
import 'package:rational/rational.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calculator_history_entry.dart';
import '../models/calculator_state.dart';
import '../services/calculator_logic.dart';

enum _LastAction { none, clear, equalOrMemory, number }

class CalculatorController extends ChangeNotifier {
  static const String _historyEntriesKey = 'basic.history.entries.v1';
  static const String _outputKey = 'basic.output.v1';
  static const String _currentInputKey = 'basic.currentInput.v1';
  static const String _memoryKey = 'basic.memory.v1';
  static const String _currentInputValueKey = 'basic.currentInputValue.v1';
  static const String _num1ValueKey = 'basic.num1Value.v1';
  static const String _num2ValueKey = 'basic.num2Value.v1';
  static const String _lastActionKey = 'basic.lastAction.v1';
  static const int _maxHistoryEntries = 50;
  static const String multiplySymbol = 'x';
  static const String divideSymbol = '÷';
  static const int _internalPrecision = 20;

  CalculatorState _state = CalculatorState();
  _LastAction _lastAction = _LastAction.none;

  CalculatorState get state => _state;
  bool isLastClicClear = false;
  bool isLastClicEqualOrMemo = false;
  bool isLastClicNumber = false;
  final symbols = GetIt.I<LocalNumberSymbols>();

  void _setLastAction(_LastAction action) {
    _lastAction = action;
    isLastClicClear = action == _LastAction.clear;
    isLastClicEqualOrMemo = action == _LastAction.equalOrMemory;
    isLastClicNumber = action == _LastAction.number;
  }

  String _serializeLastAction(_LastAction action) {
    switch (action) {
      case _LastAction.clear:
        return 'clear';
      case _LastAction.equalOrMemory:
        return 'equal_or_memory';
      case _LastAction.number:
        return 'number';
      case _LastAction.none:
        return 'none';
    }
  }

  _LastAction _deserializeLastAction(String? value) {
    switch (value) {
      case 'clear':
        return _LastAction.clear;
      case 'equal_or_memory':
        return _LastAction.equalOrMemory;
      case 'number':
        return _LastAction.number;
      case 'none':
      default:
        return _LastAction.none;
    }
  }

  /// Converts an exact Rational to a displayable string that maintains precision.
  /// This is used when we have an exact result to avoid converting to Decimal
  /// (which loses precision) and back.
  ///
  /// Note: Does NOT add the "≈" approximation marker - that's done by formatRound()
  /// in the UI. This ensures we get the precise decimal representation without
  /// the extra formatting that could interfere with history entry creation.
  String _formatExactRationalAsDisplay(Rational value) {
    final decimal = value.toDecimal(scaleOnInfinitePrecision: _internalPrecision);
    return decimal.toString();
  }

  Rational? _tryParseRational(String value) {
    final clean = value.toCleanMathString;
    if (clean.isEmpty || clean == '-' || clean == '+') {
      return null;
    }
    try {
      return Rational.parse(clean);
    } catch (_) {
      return null;
    }
  }

  Rational? _parsePersistedRationalOrNull(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    final value = raw.trim();
    final fractionParts = value.split('/');
    if (fractionParts.length == 2) {
      try {
        final numerator = BigInt.parse(fractionParts[0]);
        final denominator = BigInt.parse(fractionParts[1]);
        return Rational(numerator, denominator);
      } catch (_) {
        // Fall back to decimal parsing below.
      }
    }
    try {
      return Rational.parse(value);
    } catch (_) {
      return null;
    }
  }

  String _toCleanFromRational(Rational value) {
    return value.toDecimal(scaleOnInfinitePrecision: _internalPrecision).toString();
  }

  Rational? _computeExactBinary({required Rational left, required Rational right, required String operation}) {
    switch (operation) {
      case '+':
        return left + right;
      case '-':
        return left - right;
      case multiplySymbol:
        return left * right;
      case divideSymbol:
        return right == Rational.zero ? null : left / right;
      case '^':
      case 'x^y':
        return CalculatorLogic.tryExactPowerRational(left, right);
      default:
        return null;
    }
  }

  Rational? _computeExactUnary({required Rational input, required String operation}) {
    switch (operation) {
      case 'x²':
        return input * input;
      case '1/x':
        return input == Rational.zero ? null : Rational.one / input;
      case '%':
        return input / Rational.fromInt(100);
      case '√':
        return CalculatorLogic.tryExactSqrtRational(input);
      default:
        return null;
    }
  }

  String _canonicalButtonText(String buttonText) {
    if (buttonText == '*' || buttonText == '×') {
      return multiplySymbol;
    }
    if (buttonText == '/') {
      return divideSymbol;
    }
    return buttonText;
  }

  void onButtonPressed(String buttonText) {
    buttonText = _canonicalButtonText(buttonText);

    switch (buttonText) {
      case "C":
        if (isLastClicClear) {
          _setLastAction(_LastAction.none);
          _state = _state.copyWith(
            output: "0",
            currentInput: "",
            num1: "0",
            operation: "",
            history: "",
            historyEntries: const [],
            currentInputValue: null,
            num1Value: null,
            num2Value: null,
          );
        } else {
          _setLastAction(_LastAction.clear);
          // Clear only the current input and operation, preserve memory and history
          _state = _state.copyWith(
            output: "0",
            currentInput: "",
            num1: "0",
            operation: "",
            // If the history already contains a result (=), keep it for reference, otherwise clear it
            history: "",
            currentInputValue: null,
            num1Value: null,
            num2Value: null,
          );
        }
        break;

      case "+":
      case "-":
      case multiplySymbol:
      case divideSymbol:
      case "x^y":
        // Avoids to use Error message with operators (empty String allowed to allow to change the operator)
        if (_state.output.toCleanMathString.isNotEmpty && _state.output.toCleanMathString.isNotANumber) break;
        _setLastAction(_LastAction.none);
        _handleOperator(buttonText);
        break;

      case "=":
      case "M+":
      case "M-":
        // Avoids to use Error message or empty String with equal or memory button
        if (_state.output.toCleanMathString.isNotANumber) break;
        _setLastAction(_LastAction.equalOrMemory);
        _handleEqualOrMemory(buttonText);
        break;

      case "MR":
        _setLastAction(_LastAction.equalOrMemory);
        if (_state.memory != Rational.zero) {
          // Retrieve the formatted memory
          String memVal = _state.memory.toDecimal(scaleOnInfinitePrecision: 10).toSciPreciseFormattedString();
          _state = _state.copyWith(
            output: memVal,
            currentInput: memVal.toCleanMathString, // Clean for internal calculation
            history: "",
            currentInputValue: _state.memory,
          );
        }
        break;

      case "MC":
        _setLastAction(_LastAction.none);
        _state = _state.copyWith(memory: Rational.zero);
        break;

      case "+/-":
        // Avoids to use Error message
        if (_state.output.toCleanMathString.isNotANumber) break;
        _setLastAction(_LastAction.none);
        _handlePlusMinus();
        break;

      case "x²":
      case "1/x":
      case "√":
      case "%":
        // Avoids to use Error message
        if (_state.output.toCleanMathString.isNotANumber) break;
        _setLastAction(_LastAction.none);
        _handleUnary(buttonText);
        break;

      case "⌫":
        // Avoids to use Error message
        if (_state.output.toCleanMathString.isNotANumber) break;
        _setLastAction(_LastAction.none);
        _handleBackspace();
        break;

      default: // Digits and dot
        _handleNumber(buttonText);
    }
    notifyListeners();
    unawaited(_persistState());
  }

  Future<void> restorePersistedState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedOutput = prefs.getString(_outputKey) ?? '0';
    final savedCurrentInput = prefs.getString(_currentInputKey) ?? '';
    final savedMemoryRaw = prefs.getString(_memoryKey);
    final savedEntriesRaw = prefs.getString(_historyEntriesKey);
    final savedCurrentInputValueRaw = prefs.getString(_currentInputValueKey);
    final savedNum1ValueRaw = prefs.getString(_num1ValueKey);
    final savedNum2ValueRaw = prefs.getString(_num2ValueKey);
    final savedLastActionRaw = prefs.getString(_lastActionKey);

    Rational savedMemory = Rational.zero;
    if (savedMemoryRaw != null) {
      try {
        savedMemory = Rational.parse(savedMemoryRaw);
      } catch (_) {
        savedMemory = Rational.zero;
      }
    }

    List<CalculatorHistoryEntry> savedEntries = const [];
    if (savedEntriesRaw != null && savedEntriesRaw.isNotEmpty) {
      try {
        final decoded = jsonDecode(savedEntriesRaw) as List<dynamic>;
        savedEntries = decoded
            .map((item) => item as Map<String, dynamic>)
            .map(
              (item) => CalculatorHistoryEntry(
                displayText: item['displayText'] as String? ?? '',
                resultDisplay: item['resultDisplay'] as String? ?? '0',
                resultClean: item['resultClean'] as String? ?? '0',
                resultRational: item['resultRational'] as String?,
              ),
            )
            .where((entry) => entry.displayText.isNotEmpty)
            .toList();
      } catch (_) {
        savedEntries = const [];
      }
    }
    if (savedEntries.length > _maxHistoryEntries) {
      savedEntries = savedEntries.sublist(0, _maxHistoryEntries);
    }

    final safeOutput = savedOutput.isEmpty ? '0' : savedOutput;
    final safeInput = savedCurrentInput;
    final restoredCurrentInputValue =
        _parsePersistedRationalOrNull(savedCurrentInputValueRaw) ?? _tryParseRational(safeInput);
    final restoredNum1Value = _parsePersistedRationalOrNull(savedNum1ValueRaw) ?? _tryParseRational(safeInput);
    final restoredNum2Value = _parsePersistedRationalOrNull(savedNum2ValueRaw);

    _state = CalculatorState(
      output: safeOutput,
      currentInput: safeInput,
      history: '',
      historyEntries: savedEntries,
      num1: safeInput.isNotEmpty ? safeInput.toCleanMathString : '0',
      operation: '',
      num2: '',
      operation2: '',
      currentInputValue: restoredCurrentInputValue,
      num1Value: restoredNum1Value,
      num2Value: restoredNum2Value,
      memory: savedMemory,
    );
    _setLastAction(_deserializeLastAction(savedLastActionRaw));
    notifyListeners();
  }

  // --- Private Logic ---

  void _handleOperator(String label) {
    // Convert the UI label to the internal canonical operator symbol.
    String canonicalOperator = (label == "x^y") ? "^" : label;

    if (_state.currentInput.isNotEmpty) {
      // Store the first number (num1)
      String inputClean = _state.currentInput.toCleanMathString;
      Rational? inputValue = _state.currentInputValue ?? _tryParseRational(inputClean);

      if (_state.operation.isNotEmpty) {
        if (canonicalOperator != "^") {
          if (_state.operation2 == "^") {
            final baseValue = _state.num2Value ?? _tryParseRational(_state.num2);
            final exponentValue = inputValue ?? _tryParseRational(inputClean);
            final exactPow = (baseValue != null && exponentValue != null)
                ? CalculatorLogic.tryExactPowerRational(baseValue, exponentValue)
                : null;
            final num2Source = _state.num2Value != null
                ? _toCleanFromRational(_state.num2Value!)
                : _state.num2.toCleanMathString;
            inputClean = CalculatorLogic.calculateResult(num1: num2Source, num2: inputClean, operation: "^");
            inputValue = exactPow ?? _tryParseRational(inputClean);
          }
          // if the history contains a =, uses the result as the first number of the new calculation
          // else runs the calculation contained in the history
          String intermediateResult;
          Rational? intermediateValue;
          if (_state.history.contains('=')) {
            intermediateResult = _state.output;
            intermediateValue = _state.currentInputValue;
          } else {
            final num1Source = _state.num1Value != null
                ? _toCleanFromRational(_state.num1Value!)
                : _state.num1.toCleanMathString;
            final leftValue = _state.num1Value ?? _tryParseRational(num1Source);
            final rightValue = inputValue ?? _tryParseRational(inputClean);
            if (leftValue != null && rightValue != null) {
              intermediateValue = _computeExactBinary(left: leftValue, right: rightValue, operation: _state.operation);
            }
            // If there's already an operation pending, compute it first before setting the new operator
            intermediateResult = CalculatorLogic.calculateResult(
              num1: num1Source,
              num2: inputClean,
              operation: _state.operation,
            );
          }
          // Update history with the intermediate result
          String history = "${intermediateResult.formatRound()} $canonicalOperator";

          // Set the intermediate result as the new num1 for the next operation
          _state = _state.copyWith(
            num1: intermediateResult.toCleanMathString,
            operation: canonicalOperator,
            currentInput: "",
            output: "",
            history: history,
            num2: "",
            operation2: "",
            currentInputValue: null,
            num1Value: intermediateValue ?? _tryParseRational(intermediateResult),
            num2Value: null,
          );
        } else {
          _state = _state.copyWith(
            currentInput: "",
            num2: inputClean,
            operation2: canonicalOperator,
            // Keep the power chain in history as "1 000 x^y".
            history: CalculatorLogic.updateHistory(_state.history, "", "", inputClean, "", "^"),
            currentInputValue: null,
            num2Value: inputValue,
          );
        }
      } else {
        _state = _state.copyWith(
          num1: inputClean,
          operation: canonicalOperator,
          currentInput: "",
          // Update history with the canonical operator, for example "1 000 +".
          history: CalculatorLogic.updateHistory(_state.history, canonicalOperator, inputClean),
          currentInputValue: null,
          num1Value: inputValue,
        );
      }
    } else if (_state.operation.isNotEmpty) {
      // If the user changes operator without typing a new number (for example, + then x),
      // update only the operator in the history.
      String currentHist = _state.history.trim();
      if (currentHist.isNotEmpty) {
        String base = _state.num1Value != null ? _toCleanFromRational(_state.num1Value!) : _state.num1;
        print ("base : $base");
        String formattedBase = Decimal.tryParse(base) == null? base: Decimal.parse(base).toSciPreciseFormattedString();
        String newHistory = "${formattedBase.formatRound()} $canonicalOperator ";
        _state = _state.copyWith(operation: canonicalOperator, history: newHistory);
      }
    }
  }

  void _handleEqualOrMemory(String buttonText) {
    Rational memo = _state.memory;
    final currentInputValue = _state.currentInputValue ?? _tryParseRational(_state.currentInput);
    String currentInputClean = currentInputValue != null
        ? _toCleanFromRational(currentInputValue)
        : _state.currentInput.toCleanMathString;
    if (currentInputClean.isNotEmpty && _state.operation.isNotEmpty && !_state.history.contains("=")) {
      String result;
      String secondOperandForHistory = currentInputClean;
      Rational? exactResultValue;
      final num1Source = _state.num1Value != null
          ? _toCleanFromRational(_state.num1Value!)
          : _state.num1.toCleanMathString;

      if (_state.num2.isEmpty && _state.num2Value == null) {
        final leftValue = _state.num1Value ?? _tryParseRational(num1Source);
        final rightValue = currentInputValue ?? _tryParseRational(currentInputClean);
        if (leftValue != null && rightValue != null) {
          exactResultValue = _computeExactBinary(left: leftValue, right: rightValue, operation: _state.operation);
        }
        result = CalculatorLogic.calculateResult(
          num1: num1Source,
          num2: currentInputClean,
          operation: _state.operation,
        );
      } else {
        final num2Source = _state.num2Value != null
            ? _toCleanFromRational(_state.num2Value!)
            : _state.num2.toCleanMathString;
        final leftValue = _state.num1Value ?? _tryParseRational(num1Source);
        final baseValue = _state.num2Value ?? _tryParseRational(num2Source);
        final exponentValue = currentInputValue ?? _tryParseRational(currentInputClean);
        final secondPowExact = (baseValue != null && exponentValue != null)
            ? CalculatorLogic.tryExactPowerRational(baseValue, exponentValue)
            : null;
        if (leftValue != null && secondPowExact != null) {
          exactResultValue = _computeExactBinary(left: leftValue, right: secondPowExact, operation: _state.operation);
        }
        result = CalculatorLogic.calculateResult(
          num1: num1Source,
          num2: num2Source,
          num3: currentInputClean,
          operation: _state.operation,
          operation2: "^",
        );
        // Use exact value for history display if available
        secondOperandForHistory = secondPowExact != null
            ? _formatExactRationalAsDisplay(secondPowExact)
            : CalculatorLogic.calculateResult(num1: num2Source, num2: currentInputClean, operation: "^");

        // Adds an entry in history containing the intermediate result
        // in case of ^ in second part of the calculation
        // Example if we calculate 1 + 2^3 , adds 2^3 = 8 and 1 + 2^3 = 9 in history
        final intermediateHistory =
            "${CalculatorLogic.updateHistory(_state.history, "^", (_state.num2Value != null ? _toCleanFromRational(_state.num2Value!) : _state.num2.toCleanMathString), currentInputClean)} ${secondOperandForHistory.formatRound()}";
        final updatedHistoryEntries = _prependHistoryEntry(
          intermediateHistory,
          result,
          exactResultValue: secondPowExact,
        );
        _state = _state.copyWith(historyEntries: updatedHistoryEntries);
      }

      if (buttonText == "M+" || buttonText == "M-") {
        // Use exact value if available, otherwise parse from result string
        Rational resRational = exactResultValue ?? Rational.parse(result.toCleanMathString);
        if (buttonText == "M+") memo += resRational;
        if (buttonText == "M-") memo -= resRational;
      }

      // Use exact result for display if available, otherwise use calculated result
      final finalResult = exactResultValue != null ? _formatExactRationalAsDisplay(exactResultValue) : result;

      final history = _state.history.contains("=")
          ? "${_state.history} = $finalResult"
          : CalculatorLogic.updateHistory(
              _state.history,
              _state.operation,
              _state.num1,
              secondOperandForHistory,
              finalResult,
            );

      final updatedHistoryEntries = _prependHistoryEntry(history, finalResult, exactResultValue: exactResultValue);
      _state = _state.copyWith(
        output: finalResult,
        history: "",
        historyEntries: updatedHistoryEntries,
        currentInput: finalResult,
        operation: "",
        num1: "0",
        num2: "",
        operation2: "",
        currentInputValue: exactResultValue ?? _tryParseRational(finalResult),
        num1Value: null,
        num2Value: null,
        memory: memo,
      );
    } else if (buttonText.startsWith("M") && currentInputClean.isNotEmpty) {
      Rational val = currentInputValue ?? Rational.parse(currentInputClean);
      if (buttonText == "M+") memo += val;
      if (buttonText == "M-") memo -= val;
      _state = _state.copyWith(memory: memo);
    }
  }

  void _handleUnary(String op) {
    String history = "";
    if (_state.output.isNotEmpty) {
      String inputClean = _state.output.toCleanMathString;
      String result = CalculatorLogic.calculateUnary(input: inputClean, operation: op);
      final inputValue = _state.currentInputValue ?? _tryParseRational(inputClean);
      final unaryExactValue = inputValue == null ? null : _computeExactUnary(input: inputValue, operation: op);
      Rational? finalExactValue = unaryExactValue;

      if (_state.history.containsOperator && !_state.history.contains("=")) {
        // Adds an entry in history containing the intermediate result
        // Example if we calculate 1 + 2² , adds 2² = 4 and 1 + 2² = 5 in history
        // Excepted with %
        if (op != "%") {
          history = "${CalculatorLogic.updateHistoryUnary(inputClean, op, result)} ${result.formatRound()}";
          final updatedHistoryEntries = _prependHistoryEntry(history, result, exactResultValue: unaryExactValue);
          _state = _state.copyWith(historyEntries: updatedHistoryEntries);
          final leftValue = _state.num1Value ?? _tryParseRational(_state.num1);
          if (leftValue != null && unaryExactValue != null) {
            finalExactValue = _computeExactBinary(left: leftValue, right: unaryExactValue, operation: _state.operation);
          }
        }
        result = CalculatorLogic.calculateResult(
          num1: _state.num1Value != null ? _toCleanFromRational(_state.num1Value!) : _state.num1.toCleanMathString,
          num2: result.toCleanMathString,
          operation: _state.operation,
        );
      }

      if (_state.history.contains("=")) {
        history = "${CalculatorLogic.updateHistoryUnary(inputClean, op, result)} ${result.formatRound()}";
      } else {
        history =
            "${CalculatorLogic.updateHistoryUnary(inputClean, op, result, _state.history)} ${result.formatRound()}";
      }

      final updatedHistoryEntries = _prependHistoryEntry(history, result, exactResultValue: finalExactValue);
      _state = _state.copyWith(
        currentInput: result,
        output: result,
        history: "",
        historyEntries: updatedHistoryEntries,
        operation: "",
        num1: result.toCleanMathString,
        num2: "",
        operation2: "",
        currentInputValue: finalExactValue ?? _tryParseRational(result),
        num1Value: finalExactValue ?? _tryParseRational(result),
        num2Value: null,
      );
    }
    _setLastAction(_LastAction.equalOrMemory);
  }

  void _handlePlusMinus() {
    if (_state.currentInput.isNotEmpty) {
      String current = _state.currentInput;
      // Smart handling of the negative sign depending on the format
      if (current.startsWith("-")) {
        current = current.substring(1);
      } else {
        if (current != "0") current = "-$current";
      }
      _state = _state.copyWith(currentInput: current, output: current);
      _state = _state.copyWith(currentInputValue: _tryParseRational(current));
    }
  }

  void _handleBackspace() {
    if (_state.currentInput.isNotEmpty) {
      String newVal = _state.currentInput.substring(0, _state.currentInput.length - 1);
      if (newVal.isEmpty || newVal == "-") newVal = "";
      _state = _state.copyWith(
        currentInput: newVal,
        output: newVal.isEmpty ? "0" : newVal,
        currentInputValue: _tryParseRational(newVal),
      );
    }
  }

  /// Convert a math string (e.g., "1000.5") to locale format (e.g., "1 000,5" in fr-FR)
  /// with both thousand separators and decimal separator localization.
  /// Preserves incomplete decimals like "0." so they remain visible.
  String _formatInputForDisplay(String mathString) {
    // Check if the string has a trailing decimal point (even if empty after it)
    bool hasTrailingDecimal = mathString.endsWith('.');

    // Handle simple decimal separator cases
    if (mathString == "." || mathString == "0.") {
      return mathString.replaceAll('.', symbols.decimalSep);
    }

    // Split by decimal point (math string uses ".")
    final parts = mathString.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : "";

    // Handle negative numbers
    bool isNegative = integerPart.startsWith('-');
    String absIntegerPart = isNegative ? integerPart.substring(1) : integerPart;

    // Add thousands separator to integer part
    // Normalize non-breaking spaces: FR uses U+202F (narrow), some use U+00A0 (standard)
    String sep = symbols.thousandsSep
        .replaceAll('\u00A0', ' ')  // NO-BREAK SPACE
        .replaceAll('\u202F', ' '); // NARROW NO-BREAK SPACE

    final formattedInteger = absIntegerPart.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => sep,
    );

    String result = isNegative ? '-$formattedInteger' : formattedInteger;

    // Add decimal part with localized separator if exists, or just the separator if trailing
    if (decimalPart.isNotEmpty) {
      result += symbols.decimalSep + decimalPart;
    } else if (hasTrailingDecimal) {
      // Preserve trailing decimal separator
      result += symbols.decimalSep;
    }

    return result;
  }

  void _handleNumber(String buttonText) {
    // Normalize buttonText from locale to math string format first.
    // This ensures consistent handling: buttonText="," becomes "." in math string.
    String buttonTextMath = buttonText == symbols.decimalSep ? "." : buttonText;

    // Get current input in math string format
    String current = _state.currentInput.toCleanMathString;

    if (buttonText == "00") {
      if (!isLastClicNumber || current == "0") return;
    }

    // If a digit is typed after a result (=), start over
    if (isLastClicEqualOrMemo) {
      String valMath = buttonTextMath == "." ? "0." : buttonTextMath;
      String displayVal = _formatInputForDisplay(valMath);
      _state = CalculatorState(
        currentInput: displayVal,
        output: displayVal,
        history: "",
        historyEntries: _state.historyEntries,
        currentInputValue: _tryParseRational(valMath),
        memory: _state.memory,
      );
      // Treat the decimal separator as a numeric input so that "00" can follow it.
      _setLastAction(_LastAction.number);
      return;
    }

    if (current == "0" && buttonTextMath != ".") {
      // Replace leading "0" with the digit, unless it's the decimal separator
      current = buttonTextMath;
    } else {
      // Check for duplicate decimal separator
      if (buttonTextMath == "." && current.contains(".")) return;
      // If decimal is pressed on "0" or empty, ensure "0." format
      if (buttonTextMath == "." && (current.isEmpty || current == "0")) {
        current = "0.";
      } else {
        // Append the button text to current (both in math string format)
        current += buttonTextMath;
      }
    }

    String displayVal = _formatInputForDisplay(current);
    _state = _state.copyWith(
      currentInput: displayVal,
      output: displayVal,
      currentInputValue: _tryParseRational(current),
    );
    // Treat the decimal separator as a numeric input so that "00" can follow it.
    _setLastAction(_LastAction.number);
  }

  String memoryDisplay() {
    if (_state.memory == Rational.zero) return "";
    // Convert the stored Rational to a Decimal using a defined scale so we
    // don't hit the Rational.toDecimal assertion for non-finite rationals.
    try {
      final dec = _state.memory.toDecimal(scaleOnInfinitePrecision: _internalPrecision);
      return "M = ${dec.toSciPreciseFormattedString()}";
    } catch (_) {
      // Fallback to a smaller scale, then to the rational textual form.
      try {
        final dec = _state.memory.toDecimal(scaleOnInfinitePrecision: 10);
        return "M = ${dec.toSciPreciseFormattedString()}";
      } catch (_) {
        return "M = ${_state.memory.toString()}";
      }
    }
  }

  void selectHistoryEntry(CalculatorHistoryEntry entry) {
    _setLastAction(_LastAction.equalOrMemory);
    final selectedValue = _parsePersistedRationalOrNull(entry.resultRational) ?? _tryParseRational(entry.resultClean);
    _state = _state.copyWith(
      currentInput: entry.resultClean,
      output: entry.resultDisplay,
      history: "",
      num1: entry.resultClean,
      operation: "",
      num2: "",
      operation2: "",
      currentInputValue: selectedValue,
      num1Value: selectedValue,
      num2Value: null,
    );
    notifyListeners();
    unawaited(_persistState());
  }

  void clearHistory() {
    _state = _state.copyWith(historyEntries: const []);
    notifyListeners();
    unawaited(_persistState());
  }

  String historyEntriesToPlainText() {
    if (_state.historyEntries.isEmpty) {
      return '';
    }

    return _state.historyEntries
        .map(
          (entry) => entry.displayText.contains('= ≈') ? entry.displayText.replaceLast('= ≈', '≈') : entry.displayText,
        )
        .join('\n');
  }

  void removeHistoryEntryAt(int index) {
    if (index < 0 || index >= _state.historyEntries.length) {
      return;
    }

    final updatedEntries = List<CalculatorHistoryEntry>.from(_state.historyEntries)..removeAt(index);
    _state = _state.copyWith(historyEntries: updatedEntries);
    notifyListeners();
    unawaited(_persistState());
  }

  List<CalculatorHistoryEntry> _prependHistoryEntry(
    String historyText,
    String resultDisplay, {
    Rational? exactResultValue,
  }) {
    if (resultDisplay.toCleanMathString.isNotANumber) {
      return _state.historyEntries;
    }

    final entry = CalculatorHistoryEntry(
      displayText: historyText,
      resultDisplay: resultDisplay,
      resultClean: resultDisplay.toCleanMathString,
      resultRational: exactResultValue?.toString(),
    );
    final updatedEntries = <CalculatorHistoryEntry>[entry, ..._state.historyEntries];
    return updatedEntries.length > _maxHistoryEntries ? updatedEntries.sublist(0, _maxHistoryEntries) : updatedEntries;
  }

  Future<void> _persistState() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesSerialized = jsonEncode(
      _state.historyEntries
          .map(
            (entry) => {
              'displayText': entry.displayText,
              'resultDisplay': entry.resultDisplay,
              'resultClean': entry.resultClean,
              'resultRational': entry.resultRational,
            },
          )
          .toList(),
    );

    await prefs.setString(_historyEntriesKey, entriesSerialized);
    await prefs.setString(_outputKey, _state.output);
    await prefs.setString(_currentInputKey, _state.currentInput);
    await prefs.setString(_memoryKey, _state.memory.toString());
    await prefs.setString(_lastActionKey, _serializeLastAction(_lastAction));
    if (_state.currentInputValue == null) {
      await prefs.remove(_currentInputValueKey);
    } else {
      await prefs.setString(_currentInputValueKey, _state.currentInputValue.toString());
    }
    if (_state.num1Value == null) {
      await prefs.remove(_num1ValueKey);
    } else {
      await prefs.setString(_num1ValueKey, _state.num1Value.toString());
    }
    if (_state.num2Value == null) {
      await prefs.remove(_num2ValueKey);
    } else {
      await prefs.setString(_num2ValueKey, _state.num2Value.toString());
    }
  }
}
