// lib/calculators/conversions/temperature/models/temperature_state.dart
enum TemperatureScale { celsius, fahrenheit, kelvin, rankine }

class TemperatureState {
  final String currentInput;
  final String celsius;
  final String fahrenheit;
  final String kelvin;
  final String rankine;
  final TemperatureScale activeScale;

  const TemperatureState({
    this.currentInput = '0',
    this.celsius = '0',
    this.fahrenheit = '32.00',
    this.kelvin = '273.15',
    this.rankine = '491.67',
    this.activeScale = TemperatureScale.celsius,
  });

  TemperatureState copyWith({
    String? currentInput,
    String? celsius,
    String? fahrenheit,
    String? kelvin,
    String? rankine,
    TemperatureScale? activeScale,
  }) {
    return TemperatureState(
      currentInput: currentInput ?? this.currentInput,
      celsius: celsius ?? this.celsius,
      fahrenheit: fahrenheit ?? this.fahrenheit,
      kelvin: kelvin ?? this.kelvin,
      rankine: rankine ?? this.rankine,
      activeScale: activeScale ?? this.activeScale,
    );
  }
}
