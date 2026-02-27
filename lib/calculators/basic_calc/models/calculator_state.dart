// lib/calculators/basic_calc/models/calculator_state.dart

import 'package:rational/rational.dart';

class CalculatorState {
  final String output;
  final String history;
  final String currentInput;
  final String num1;
  final String operation;
  final Rational memory;

  CalculatorState({
    this.output = "0",
    this.history = "",
    this.currentInput = "",
    this.num1 = "0",
    this.operation = "",
    Rational? memory,
  }) : memory = memory ?? Rational.zero;

  CalculatorState copyWith({
    String? output,
    String? history,
    String? currentInput,
    String? num1,
    String? operation,
    Rational? memory,
  }) {
    return CalculatorState(
      output: output ?? this.output,
      history: history ?? this.history,
      currentInput: currentInput ?? this.currentInput,
      num1: num1 ?? this.num1,
      operation: operation ?? this.operation,
      memory: memory ?? this.memory,
    );
  }
}
