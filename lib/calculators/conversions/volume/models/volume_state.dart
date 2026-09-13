enum VolumeScale {
  liter,
  milliliter,
  gallon,
  fluidOunce,
  cubicMeter,
}

class VolumeState {
  final VolumeScale activeUnit;
  final String currentInput;
  final String liter;
  final String milliliter;
  final String gallon;
  final String fluidOunce;
  final String cubicMeter;

  const VolumeState({
    required this.activeUnit,
    required this.currentInput,
    required this.liter,
    required this.milliliter,
    required this.gallon,
    required this.fluidOunce,
    required this.cubicMeter,
  });

  factory VolumeState.initial() {
    return const VolumeState(
      activeUnit: VolumeScale.liter,
      currentInput: '0',
      liter: '0',
      milliliter: '0',
      gallon: '0',
      fluidOunce: '0',
      cubicMeter: '0',
    );
  }

  VolumeState copyWith({
    VolumeScale? activeUnit,
    String? currentInput,
    String? liter,
    String? milliliter,
    String? gallon,
    String? fluidOunce,
    String? cubicMeter,
  }) {
    return VolumeState(
      activeUnit: activeUnit ?? this.activeUnit,
      currentInput: currentInput ?? this.currentInput,
      liter: liter ?? this.liter,
      milliliter: milliliter ?? this.milliliter,
      gallon: gallon ?? this.gallon,
      fluidOunce: fluidOunce ?? this.fluidOunce,
      cubicMeter: cubicMeter ?? this.cubicMeter,
    );
  }
}
