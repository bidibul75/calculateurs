enum WeightScale {
  kilogram,
  gram,
  pound,
  ounce,
  stone,
}

class WeightState {
  final WeightScale activeUnit;
  final String currentInput;
  final String kilogram;
  final String gram;
  final String pound;
  final String ounce;
  final String stone;

  const WeightState({
    required this.activeUnit,
    required this.currentInput,
    required this.kilogram,
    required this.gram,
    required this.pound,
    required this.ounce,
    required this.stone,
  });

  factory WeightState.initial() {
    return const WeightState(
      activeUnit: WeightScale.kilogram,
      currentInput: '0',
      kilogram: '0',
      gram: '0',
      pound: '0',
      ounce: '0',
      stone: '0',
    );
  }

  WeightState copyWith({
    WeightScale? activeUnit,
    String? currentInput,
    String? kilogram,
    String? gram,
    String? pound,
    String? ounce,
    String? stone,
  }) {
    return WeightState(
      activeUnit: activeUnit ?? this.activeUnit,
      currentInput: currentInput ?? this.currentInput,
      kilogram: kilogram ?? this.kilogram,
      gram: gram ?? this.gram,
      pound: pound ?? this.pound,
      ounce: ounce ?? this.ounce,
      stone: stone ?? this.stone,
    );
  }
}
