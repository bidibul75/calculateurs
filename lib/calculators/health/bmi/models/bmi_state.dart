// lib/calculators/health/bmi/models/bmi_state.dart

/// Represents the state of the BMI calculator
class BmiState {
  final String currentInput;
  final String output;
  final String? height; // Height in meters
  final String? weight; // Weight in kg
  final bool isHeightComplete;
  final bool hasError;
  final String prompt;

  const BmiState({
    this.currentInput = '',
    this.output = '0',
    this.height,
    this.weight,
    this.isHeightComplete = false,
    this.hasError = false,
    this.prompt = '',
  });

  BmiState copyWith({
    String? currentInput,
    String? output,
    String? height,
    String? weight,
    bool? isHeightComplete,
    bool? hasError,
    String? prompt,
  }) {
    return BmiState(
      currentInput: currentInput ?? this.currentInput,
      output: output ?? this.output,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      isHeightComplete: isHeightComplete ?? this.isHeightComplete,
      hasError: hasError ?? this.hasError,
      prompt: prompt ?? this.prompt,
    );
  }
}
