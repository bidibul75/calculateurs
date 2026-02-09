class CalculatorState {
  final String output; // big font on screen
  final String history; // current or last calculation
  final String currentInput; // input buffer
  final double num1; // first number of the operation
  final String operation; // the selected operator
  final double memory; // the value stocked in memory (M keys)

  CalculatorState({
    this.output = "0",
    this.history = "",
    this.currentInput = "",
    this.num1 = 0,
    this.operation = "",
    this.memory = 0,
  });

  // a method to copy state
  CalculatorState copyWith({
    String? output,
    String? history,
    String? currentInput,
    double? num1,
    String? operation,
    double? memory,
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
