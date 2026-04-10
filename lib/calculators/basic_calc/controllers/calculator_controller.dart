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

class CalculatorController extends ChangeNotifier {
  static const String _historyEntriesKey = 'basic.history.entries.v1';
  static const String _outputKey = 'basic.output.v1';
  static const String _currentInputKey = 'basic.currentInput.v1';
  static const String _memoryKey = 'basic.memory.v1';
  static const int _maxHistoryEntries = 50;

  CalculatorState _state = CalculatorState();

  CalculatorState get state => _state;
  bool isLastClicClear = false;
  bool isLastClicEqualOrMemo = false;
  bool isLastClicNumber = false;
  final symbols = GetIt.I<LocalNumberSymbols>();

  void onButtonPressed(String buttonText) {
    switch (buttonText) {
      case "C":
        isLastClicEqualOrMemo = false;
        if (isLastClicClear) {
          isLastClicClear = false;
          _state = _state.copyWith(output: "0", currentInput: "", num1: "0", operation: "", history: "", historyEntries: const []);
        } else {
          isLastClicClear = true;
          // Clear only the current input and operation, preserve memory and history
          _state = _state.copyWith(
            output: "0",
            currentInput: "",
            num1: "0",
            operation: "",
            // If the history already contains a result (=), keep it for reference, otherwise clear it
            history: "",
          );
        }
        break;

      case "+":
      case "-":
      case "x":
      case "÷":
      case "x^y":
        // Avoids to use Error message with operators (empty String allowed to allow to change the operator)
        if (_state.output.toCleanMathString.isNotEmpty && _state.output.toCleanMathString.isNotANumber) break;
        isLastClicClear = false;
        isLastClicEqualOrMemo = false;
        _handleOperator(buttonText);
        break;

      case "=":
      case "M+":
      case "M-":
        // Avoids to use Error message or empty String with equal or memory button
        if (_state.output.toCleanMathString.isNotANumber) break;
        isLastClicClear = false;
        isLastClicEqualOrMemo = true;
        _handleEqualOrMemory(buttonText);
        break;

      case "MR":
        isLastClicClear = false;
        isLastClicEqualOrMemo = true;
        if (_state.memory != Rational.zero) {
          // Retrieve the formatted memory
          String memVal = _state.memory.toDecimal(scaleOnInfinitePrecision: 10).toPreciseFormattedString;
          _state = _state.copyWith(
            output: memVal,
            currentInput: memVal.toCleanMathString, // Clean for internal calculation
            history: "",
          );
        }
        break;

      case "MC":
        isLastClicClear = false;
        isLastClicEqualOrMemo = false;
        _state = _state.copyWith(memory: Rational.zero);
        break;

      case "+/-":
        // Avoids to use Error message
        if (_state.output.toCleanMathString.isNotANumber) break;
        isLastClicClear = false;
        isLastClicEqualOrMemo = false;
        _handlePlusMinus();
        break;

      case "x²":
      case "1/x":
      case "√":
        // Avoids to use Error message
        if (_state.output.toCleanMathString.isNotANumber) break;
        isLastClicClear = false;
        isLastClicEqualOrMemo = false;
        _handleUnary(buttonText);
        break;

      case "⌫":
        // Avoids to use Error message
        if (_state.output.toCleanMathString.isNotANumber) break;
        isLastClicClear = false;
        isLastClicEqualOrMemo = false;
        _handleBackspace();
        break;

      default: // Digits and dot
        isLastClicClear = false;
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

    _state = CalculatorState(
      output: safeOutput,
      currentInput: safeInput,
      history: '',
      historyEntries: savedEntries,
      num1: safeInput.isNotEmpty ? safeInput.toCleanMathString : '0',
      operation: '',
      num2: '',
      operation2: '',
      memory: savedMemory,
    );
    notifyListeners();
  }

  // --- Private Logic ---

  void _handleOperator(String label) {
    isLastClicNumber = false;
    // Convert UI label -> math symbol
    String op = (label == "x^y") ? "^" : label;

    if (_state.currentInput.isNotEmpty) {
      // Store the first number (num1)
      String inputClean = _state.currentInput.toCleanMathString;

      if (_state.operation.isNotEmpty) {
        if (op != "^") {
          if (_state.operation2 == "^") {
            inputClean = CalculatorLogic.calculateResult(
              num1: _state.num2.toCleanMathString,
              num2: inputClean,
              operation: "^",
            );
          }
          // if the history contains a =, uses the result as the first number of the new calculation
          // else runs the calculation contained in the history
          String intermediateResult;
          if (_state.history.contains('=')) {
            intermediateResult = _state.output;
          } else {
            // If there's already an operation pending, compute it first before setting the new operator
            intermediateResult = CalculatorLogic.calculateResult(
              num1: _state.num1.toCleanMathString,
              num2: inputClean,
              operation: _state.operation,
            );
          }
          // Update history with the intermediate result
          String history = "${intermediateResult.formatRound()} $op";

          // Set the intermediate result as the new num1 for the next operation
          _state = _state.copyWith(
            num1: intermediateResult.toCleanMathString,
            operation: op,
            currentInput: "",
            output: "",
            history: history,
            num2: "",
            operation2: "",
          );
        } else {
          _state = _state.copyWith(
            currentInput: "",
            num2: inputClean,
            operation2: op,
            // Update history: "1 000 x^y"
            history: CalculatorLogic.updateHistory(_state.history, "", "", inputClean, "", "^"),
          );
        }
      } else {
        _state = _state.copyWith(
          num1: inputClean,
          operation: op,
          currentInput: "",
          // Update history: "1 000 +"
          history: CalculatorLogic.updateHistory(_state.history, op, inputClean),
        );
      }
    } else if (_state.operation.isNotEmpty) {
      // If we change operator without typing a new number (e.g. press + then change to x)
      // Only change the operator in the history
      String currentHist = _state.history.trim();
      // Remove the last operator and apply the new one
      if (currentHist.isNotEmpty) {
        String base = _state.num1;
        String formattedBase = Decimal.tryParse(base)?.toPreciseFormattedString ?? base;
        String newHistory = "${formattedBase.formatRound()} $op ";
        _state = _state.copyWith(operation: op, history: newHistory);
      }
    }
  }

  void _handleEqualOrMemory(String buttonText) {
    isLastClicNumber = false;
    Rational memo = _state.memory;
    String currentInputClean = _state.currentInput.toCleanMathString;
    if (currentInputClean.isNotEmpty && _state.operation.isNotEmpty && !_state.history.contains("=")) {
      String result;
      String secondOperandForHistory = currentInputClean;

      if (_state.num2 == "") {
        result = CalculatorLogic.calculateResult(
          num1: _state.num1.toCleanMathString,
          num2: currentInputClean,
          operation: _state.operation,
        );
      } else {
        result = CalculatorLogic.calculateResult(
          num1: _state.num1.toCleanMathString,
          num2: _state.num2.toCleanMathString,
          num3: currentInputClean,
          operation: _state.operation,
          operation2: "^",
        );
        secondOperandForHistory = CalculatorLogic.calculateResult(
          num1: _state.num2.toCleanMathString,
          num2: currentInputClean,
          operation: "^",
        );
      }

      if (buttonText == "M+" || buttonText == "M-") {
        Rational resRational = Rational.parse(result.toCleanMathString);
        if (buttonText == "M+") memo += resRational;
        if (buttonText == "M-") memo -= resRational;
      }

      String history = _state.history.contains("=")
          ? "${_state.history} = $result"
          : CalculatorLogic.updateHistory(
              _state.history,
              _state.operation,
              _state.num1,
              secondOperandForHistory,
              result,
            );

      final updatedHistoryEntries = _prependHistoryEntry(history, result);
      _state = _state.copyWith(
        output: result,
        history: "",
        historyEntries: updatedHistoryEntries,
        currentInput: result,
        operation: "",
        num1: "0",
        num2: "",
        operation2: "",
        memory: memo,
      );
    } else if (buttonText.startsWith("M") && currentInputClean.isNotEmpty) {
      Rational val = Rational.parse(currentInputClean);
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

      if (_state.history.containsOperator && !_state.history.contains("=")) {
        result = CalculatorLogic.calculateResult(
          num1: _state.num1.toCleanMathString,
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

      final updatedHistoryEntries = _prependHistoryEntry(history, result);
      _state = _state.copyWith(
        currentInput: result,
        output: result,
        history: "",
        historyEntries: updatedHistoryEntries,
        operation: "",
        num1: result.toCleanMathString,
        num2: "",
        operation2: "",
      );
    }
    isLastClicEqualOrMemo = true;
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
    }
  }

  void _handleBackspace() {
    if (_state.currentInput.isNotEmpty) {
      String newVal = _state.currentInput.substring(0, _state.currentInput.length - 1);
      if (newVal.isEmpty || newVal == "-") newVal = "";
      _state = _state.copyWith(currentInput: newVal, output: newVal.isEmpty ? "0" : newVal);
    }
  }

  void _handleNumber(String buttonText) {
    // Get the local decimal separator (comma or dot) via extensions or Intl
    // To simplify, assume the UI sends "." and we display "."
    // If you want to handle comma input, replace "." with "," here.
    String current = _state.currentInput.toCleanMathString;

    if (buttonText == "00") {
      if (!isLastClicNumber || current == "0") return;
    }

    // If a digit is typed after a result (=), start over
    if (isLastClicEqualOrMemo) {
      isLastClicEqualOrMemo = false;
      String val = (buttonText == symbols.decimalSep) ? "0${symbols.decimalSep}" : buttonText;
      _state = CalculatorState(currentInput: val, output: val, history: "", historyEntries: _state.historyEntries, memory: _state.memory);
      isLastClicNumber = true;
      return;
    }

    if (current == "0" && buttonText != symbols.decimalSep) {
      current = buttonText;
    } else {
      if (buttonText == symbols.decimalSep && current.contains(symbols.decimalSep)) return;
      (buttonText == symbols.decimalSep && current.isEmpty)
          ? current = "0${symbols.decimalSep}"
          : current += buttonText;
    }
    _state = _state.copyWith(currentInput: current, output: current.format);
    isLastClicNumber = true;
  }

  String memoryDisplay() {
    if (_state.memory == Rational.zero) return "";
    return "M = ${Decimal.parse(_state.memory.toDecimal().toString()).toPreciseFormattedString}";
  }

  void selectHistoryEntry(CalculatorHistoryEntry entry) {
    isLastClicClear = false;
    isLastClicEqualOrMemo = true;
    isLastClicNumber = false;
    _state = _state.copyWith(
      currentInput: entry.resultClean,
      output: entry.resultDisplay,
      history: "",
      num1: entry.resultClean,
      operation: "",
      num2: "",
      operation2: "",
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
          (entry) => entry.displayText.contains('= ≈')
              ? entry.displayText.replaceLast('= ≈', '≈')
              : entry.displayText,
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

  List<CalculatorHistoryEntry> _prependHistoryEntry(String historyText, String resultDisplay) {
    if (resultDisplay.toCleanMathString.isNotANumber) {
      return _state.historyEntries;
    }

    final entry = CalculatorHistoryEntry(
      displayText: historyText,
      resultDisplay: resultDisplay,
      resultClean: resultDisplay.toCleanMathString,
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
            },
          )
          .toList(),
    );

    await prefs.setString(_historyEntriesKey, entriesSerialized);
    await prefs.setString(_outputKey, _state.output);
    await prefs.setString(_currentInputKey, _state.currentInput);
    await prefs.setString(_memoryKey, _state.memory.toString());
  }
}
