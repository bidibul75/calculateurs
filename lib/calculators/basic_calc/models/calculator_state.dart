import 'package:rational/rational.dart';
import 'calculator_history_entry.dart';

class CalculatorState {
  static const Object _unset = Object();

  final String output;
  final String history;
  final List<CalculatorHistoryEntry> historyEntries;
  final String currentInput;
  final String num1;
  final String operation;
  final String num2;
  final String operation2;
  // Internal exact values used for chained calculations.
  final Rational? currentInputValue;
  final Rational? num1Value;
  final Rational? num2Value;
  final Rational memory;

  CalculatorState({
    this.output = "0",
    this.history = "",
    List<CalculatorHistoryEntry>? historyEntries,
    this.currentInput = "",
    this.num1 = "0",
    this.operation = "",
    this.num2 = "",
    this.operation2 = "",
    this.currentInputValue,
    this.num1Value,
    this.num2Value,
    Rational? memory,
  })  : historyEntries = historyEntries ?? const [],
        memory = memory ?? Rational.zero;

  CalculatorState copyWith({
    String? output,
    String? history,
    List<CalculatorHistoryEntry>? historyEntries,
    String? currentInput,
    String? num1,
    String? operation,
    String? num2,
    String? operation2,
    Object? currentInputValue = _unset,
    Object? num1Value = _unset,
    Object? num2Value = _unset,
    Rational? memory,
  }) {
    return CalculatorState(
      output: output ?? this.output,
      history: history ?? this.history,
      historyEntries: historyEntries ?? this.historyEntries,
      currentInput: currentInput ?? this.currentInput,
      num1: num1 ?? this.num1,
      operation: operation ?? this.operation,
      num2: num2 ?? this.num2,
      operation2: operation2 ?? this.operation2,
      currentInputValue:
          identical(currentInputValue, _unset) ? this.currentInputValue : currentInputValue as Rational?,
      num1Value: identical(num1Value, _unset) ? this.num1Value : num1Value as Rational?,
      num2Value: identical(num2Value, _unset) ? this.num2Value : num2Value as Rational?,
      memory: memory ?? this.memory,
    );
  }
}
