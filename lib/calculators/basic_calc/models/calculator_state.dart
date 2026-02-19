class CalculatorState {
  final String output;
  final String history;
  final String currentInput;

  // CHANGEMENT ICI : String au lieu de double pour garder la précision
  final String num1;

  final String operation;
  final double memory; // On peut garder double pour l'instant ou passer en String plus tard
  final bool lastOperationIsUnary;

  CalculatorState({
    this.output = "0",
    this.history = "",
    this.currentInput = "",
    this.num1 = "0", // Initialisation String
    this.operation = "",
    this.memory = 0.0,
    this.lastOperationIsUnary = false,
  });

  CalculatorState copyWith({
    String? output,
    String? history,
    String? currentInput,
    String? num1, // Changement de signature
    String? operation,
    double? memory,
    bool? lastOperationIsUnary,
  }) {
    return CalculatorState(
      output: output ?? this.output,
      history: history ?? this.history,
      currentInput: currentInput ?? this.currentInput,
      num1: num1 ?? this.num1,
      operation: operation ?? this.operation,
      memory: memory ?? this.memory,
      lastOperationIsUnary: lastOperationIsUnary ?? this.lastOperationIsUnary,
    );
  }
}
