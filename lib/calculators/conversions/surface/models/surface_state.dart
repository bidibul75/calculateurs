enum SurfaceScale {
  squareMeter,
  squareCentimeter,
  hectare,
  acre,
  squareFoot,
}

class SurfaceState {
  final SurfaceScale activeUnit;
  final String currentInput;
  final String squareMeter;
  final String squareCentimeter;
  final String hectare;
  final String acre;
  final String squareFoot;

  const SurfaceState({
    required this.activeUnit,
    required this.currentInput,
    required this.squareMeter,
    required this.squareCentimeter,
    required this.hectare,
    required this.acre,
    required this.squareFoot,
  });

  factory SurfaceState.initial() {
    return const SurfaceState(
      activeUnit: SurfaceScale.squareMeter,
      currentInput: '0',
      squareMeter: '0',
      squareCentimeter: '0',
      hectare: '0',
      acre: '0',
      squareFoot: '0',
    );
  }

  SurfaceState copyWith({
    SurfaceScale? activeUnit,
    String? currentInput,
    String? squareMeter,
    String? squareCentimeter,
    String? hectare,
    String? acre,
    String? squareFoot,
  }) {
    return SurfaceState(
      activeUnit: activeUnit ?? this.activeUnit,
      currentInput: currentInput ?? this.currentInput,
      squareMeter: squareMeter ?? this.squareMeter,
      squareCentimeter: squareCentimeter ?? this.squareCentimeter,
      hectare: hectare ?? this.hectare,
      acre: acre ?? this.acre,
      squareFoot: squareFoot ?? this.squareFoot,
    );
  }
}
