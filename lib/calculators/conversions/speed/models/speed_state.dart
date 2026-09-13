enum SpeedScale {
  kilometerPerHour,
  meterPerSecond,
  milePerHour,
  knot,
  footPerSecond,
}

class SpeedState {
  final SpeedScale activeUnit;
  final String currentInput;
  final String kilometerPerHour;
  final String meterPerSecond;
  final String milePerHour;
  final String knot;
  final String footPerSecond;

  const SpeedState({
    required this.activeUnit,
    required this.currentInput,
    required this.kilometerPerHour,
    required this.meterPerSecond,
    required this.milePerHour,
    required this.knot,
    required this.footPerSecond,
  });

  factory SpeedState.initial() {
    return const SpeedState(
      activeUnit: SpeedScale.kilometerPerHour,
      currentInput: '0',
      kilometerPerHour: '0',
      meterPerSecond: '0',
      milePerHour: '0',
      knot: '0',
      footPerSecond: '0',
    );
  }

  SpeedState copyWith({
    SpeedScale? activeUnit,
    String? currentInput,
    String? kilometerPerHour,
    String? meterPerSecond,
    String? milePerHour,
    String? knot,
    String? footPerSecond,
  }) {
    return SpeedState(
      activeUnit: activeUnit ?? this.activeUnit,
      currentInput: currentInput ?? this.currentInput,
      kilometerPerHour: kilometerPerHour ?? this.kilometerPerHour,
      meterPerSecond: meterPerSecond ?? this.meterPerSecond,
      milePerHour: milePerHour ?? this.milePerHour,
      knot: knot ?? this.knot,
      footPerSecond: footPerSecond ?? this.footPerSecond,
    );
  }
}
