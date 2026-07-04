// lib/calculators/conversions/distance/models/distance_state.dart

enum DistanceUnit {
  km,
  m,
  cm,
  mm,
  mi,
  yd,
  ft,
  inch,
  nmi,
}

class DistanceState {
  final String metricValue;
  final DistanceUnit metricUnit;
  final String imperialValue;
  final DistanceUnit imperialUnit;
  final String nauticalValue;

  const DistanceState({
    this.metricValue = '',
    this.metricUnit = DistanceUnit.km,
    this.imperialValue = '',
    this.imperialUnit = DistanceUnit.mi,
    this.nauticalValue = '',
  });

  DistanceState copyWith({
    String? metricValue,
    DistanceUnit? metricUnit,
    String? imperialValue,
    DistanceUnit? imperialUnit,
    String? nauticalValue,
  }) {
    return DistanceState(
      metricValue: metricValue ?? this.metricValue,
      metricUnit: metricUnit ?? this.metricUnit,
      imperialValue: imperialValue ?? this.imperialValue,
      imperialUnit: imperialUnit ?? this.imperialUnit,
      nauticalValue: nauticalValue ?? this.nauticalValue,
    );
  }
}
