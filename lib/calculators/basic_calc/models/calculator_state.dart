// lib/calculators/basic_calc/models/calculator_state.dart

import 'package:rational/rational.dart';

class CalculatorState {
  final String output;
  final String history;
  final String currentInput;
  final String num1;
  final String operation;
  final String num2;
  final String operation2;
  final Rational memory;

  CalculatorState({
    this.output = "0",
    this.history = "",
    this.currentInput = "",
    this.num1 = "0",
    this.operation = "",
    Rational? memory,
    this.num2="",
    this.operation2=""
  }) : memory = memory ?? Rational.zero;

  CalculatorState copyWith({
    String? output,
    String? history,
    String? currentInput,
    String? num1,
    String? operation,
    Rational? memory,
    String? num2,
    String? operation2
  }) {
    return CalculatorState(
      output: output ?? this.output,
      history: history ?? this.history,
      currentInput: currentInput ?? this.currentInput,
      num1: num1 ?? this.num1,
      operation: operation ?? this.operation,
      memory: memory ?? this.memory,
      num2: num2 ?? this.num2,
      operation2: operation2 ?? this.operation2,
    );
  }
}
