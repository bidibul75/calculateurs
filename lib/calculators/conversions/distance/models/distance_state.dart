enum DistanceScale {
  meter,
  kilometer,
  mile,
  foot,
  inch,
}

class DistanceState {
  final DistanceScale activeUnit;   // <-- doit être DistanceScale, pas DistanceUnit
  final String currentInput;
  final String meter;
  final String kilometer;
  final String mile;
  final String foot;
  final String inch;

  const DistanceState({
    required this.activeUnit,
    required this.currentInput,
    required this.meter,
    required this.kilometer,
    required this.mile,
    required this.foot,
    required this.inch,
  });

  factory DistanceState.initial() {
    return const DistanceState(
      activeUnit: DistanceScale.meter,
      currentInput: '0',
      meter: '0',
      kilometer: '0',
      mile: '0',
      foot: '0',
      inch: '0',
    );
  }

  DistanceState copyWith({
    DistanceScale? activeUnit,
    String? currentInput,
    String? meter,
    String? kilometer,
    String? mile,
    String? foot,
    String? inch,
  }) {
    return DistanceState(
      activeUnit: activeUnit ?? this.activeUnit,
      currentInput: currentInput ?? this.currentInput,
      meter: meter ?? this.meter,
      kilometer: kilometer ?? this.kilometer,
      mile: mile ?? this.mile,
      foot: foot ?? this.foot,
      inch: inch ?? this.inch,
    );
  }
}
